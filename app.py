from flask import Flask, render_template, jsonify, request
from pymongo import MongoClient
from bson.json_util import dumps
from flask_cors import CORS  # Impor CORS
import requests
import threading  # Untuk menjalankan proses background
import time  # Untuk mengatur interval waktu
import pytz
from datetime import datetime, timedelta, timezone
import paho.mqtt.client as mqtt
import threading
from math import radians, sin, cos, sqrt, atan2
import math
from apscheduler.schedulers.background import BackgroundScheduler

app = Flask(__name__)

# Setup CORS
CORS(app)  # Ini akan mengaktifkan CORS untuk seluruh aplikasi

gmt7 = pytz.timezone('Asia/Jakarta')

# Setup MongoDB Client
client = MongoClient('mongodb+srv://raflinugraha:SurajaKids@smartcane.5fzgg.mongodb.net/?retryWrites=true&w=majority&appName=smartCane')  # Ganti dengan URL MongoDB server Anda
db = client['sensor_db']  # Database
collection = db['sensor_data']  # Collection
realtime_collection = db['realtime_collection']
history_notification = db['history_notification']
emergency_notification = db["emergency_notification"]  # Nama koleksi
rekap_collection = db["rekap"]  # Koleksi untuk rekap data
realtime_jaraktempuh_collection = db['realtime_jaraktempuh'] 
# Konfigurasi MQTT
mqtt_broker = "broker.hivemq.com"  # Ganti dengan broker MQTT Anda
mqtt_port = 1883
mqtt_topic = "smartCane"

# Fungsi untuk koneksi ke MQTT
def on_connect(client, userdata, flags, rc):


    print("Connected to MQTT broker with result code " + str(rc))

def on_publish(client, userdata, mid):
    print("Message Published")

# Setup client MQTT
client = mqtt.Client()
client.on_connect = on_connect
client.on_publish = on_publish

# Fungsi untuk mengirim pesan ke MQTT
def send_mqtt_message(message):
    client.connect(mqtt_broker, mqtt_port, 60)
    client.loop_start()
    client.publish(mqtt_topic, message)
    client.loop_stop()

# Rute untuk mengirim data melalui MQTT
@app.route('/send_alert')
def send_data():
    message = "1"  # Data yang akan dikirim
    threading.Thread(target=send_mqtt_message, args=(message,)).start()
    return jsonify({"status": "Data sent", "message": message})

# Fungsi untuk menghitung jarak antara dua titik menggunakan rumus Haversine
def _calculateDistance(lat1, lon1, lat2, lon2):
    R = 6371  # Radius bumi dalam km
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = math.sin(dlat / 2) ** 2 + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon / 2) ** 2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    distance = R * c
    return distance


@app.route('/api/rekap', methods=['POST'])
def rekap_post():
    try:
        # Mendapatkan data dari request
        rekap_data = request.get_json()

        # Mendapatkan data sesuai format yang baru
        time_diff = rekap_data.get('time_diff')  # Format: "2 jam 30 menit"
        total_distance_km = float(rekap_data.get('total_distance_km', 0))
        first_timestamp = rekap_data.get('first_timestamp')  # Format: 'YYYY-MM-DD HH:MM'
        last_timestamp = rekap_data.get('last_timestamp')  # Format: 'YYYY-MM-DD HH:MM'
        tanggal = rekap_data.get('tanggal')  # Format: 'YYYY-MM-DD'

        # Menghitung time_diff_hours jika belum ada
        if first_timestamp and last_timestamp:
            first_time = datetime.strptime(first_timestamp, '%Y-%m-%d %H:%M')
            last_time = datetime.strptime(last_timestamp, '%Y-%m-%d %H:%M')
            time_diff_seconds = abs((last_time - first_time).total_seconds())
            time_diff_hours = round(time_diff_seconds / 3600, 2)  # Hasil dalam jam
        else:
            time_diff_hours = rekap_data.get('time_diff_hours', 0)

        # Menyimpan data ke koleksi rekap
        result = rekap_collection.insert_one({
            "time_diff": time_diff,
            "time_diff_hours": time_diff_hours,  # Tambahkan nilai time_diff_hours
            "total_distance_km": total_distance_km,
            "first_timestamp": first_timestamp,
            "last_timestamp": last_timestamp,
            "tanggal": tanggal,
            "timestamp": time.time()  # Menambahkan timestamp untuk referensi waktu
        })

        return jsonify({"message": "Rekap data saved successfully!", "id": str(result.inserted_id)}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400




@app.route('/api/rekap', methods=['GET'])
def rekap_get():
    try:
        # Ambil semua data dari koleksi rekap
        data = list(rekap_collection.find().sort("tanggal", 1))  # Mengurutkan berdasarkan tanggal

        # Jika tidak ada data dalam koleksi
        if not data:
            return jsonify({"message": "No data available"}), 200

        # Format data menjadi JSON yang dapat digunakan frontend
        response_data = []
        for entry in data:
            response_data.append({
                "_id": str(entry.get("_id")),
                "time_diff": entry.get("time_diff", ""),
                "time_diff_hours": round(entry.get("time_diff_hours", 0), 2),  # Pastikan format double
                "total_distance_km": round(entry.get("total_distance_km", 0), 2),
                "tanggal": entry.get("tanggal", "")
            })

        return jsonify(response_data), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/upload', methods=['POST'])
def upload_data():
    try:
        # Mendapatkan data dari request
        data = request.get_json()

        # Mengubah string ke tipe data yang sesuai (misalnya float untuk distance, latitude, longitude)
        ultrasonic1 = float(data.get('ultrasonic1', 0))
        ultrasonic2 = float(data.get('ultrasonic2', 0))
        water_level = float(data.get('water_level', 0))
        latitude = float(data.get('latitude', 0))
        longitude = float(data.get('longitude', 0))

        # Simpan data ke MongoDB
        collection.insert_one({
            "ultrasonic1": ultrasonic1,
            "ultrasonic2": ultrasonic2,
            "water_level": water_level,
            "latitude": latitude,
            "longitude": longitude
        })
        
        return jsonify({"message": "Data saved successfully!"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/getData', methods=['GET'])
def get_data():
    # Mengambil semua data dari MongoDB
    data = collection.find()
    return dumps(data)  # Mengembalikan data dalam format JSON

@app.route('/')
def dashboard():
    return render_template('index.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/ourteam')
def our_team():
    return render_template('ourteam.html')

@app.route('/howtouse')
def how_to_use():
    return render_template('how.html')


# Endpoint untuk mendapatkan lokasi secara real-time dari MongoDB
# Fungsi untuk mengambil data lokasi dari database
def get_location_from_data():
    try:
        # Mengakses endpoint /data
        response = requests.get('http://localhost:5000/getData')  # Ganti dengan URL yang sesuai
        if response.status_code == 200:
            data = response.json()

            # Memeriksa apakah data adalah list dan mengambil data terakhir
            if isinstance(data, list) and len(data) > 0:
                # Mengambil latitude dan longitude dari elemen terakhir dalam list
                latitude = data[-1].get('latitude', 0.0)  # Mengambil latitude jika ada
                longitude = data[-1].get('longitude', 0.0)  # Mengambil longitude jika ada
            else:
                latitude = 0.0
                longitude = 0.0

            return {'latitude': latitude, 'longitude': longitude}
        else:
            return {'latitude': 0.0, 'longitude': 0.0}  # Jika gagal mengambil data
    except requests.exceptions.RequestException as e:
        print(f"Error connecting to /data: {e}")
        return {'latitude': 0.0, 'longitude': 0.0}  # Jika terjadi kesalahan dalam koneksi

# Endpoint untuk mengirim lokasi terbaru
@app.route('/api/realtime-collections', methods=['GET'])
def realtime_location():
    try:
        # Mengambil semua data dari collection realtime_collection, diurutkan berdasarkan timestamp terbaru
        all_data = realtime_collection.find().sort("timestamp", -1)
        data_list = []

        for data in all_data:
            # Mengambil timestamp dalam format Unix (UTC)
            timestamp_utc = data.get("timestamp", 0)

            # Mengonversi timestamp UTC ke GMT+7
            timestamp_gmt7 = datetime.fromtimestamp(timestamp_utc, tz=pytz.utc).astimezone(gmt7)

            # Format timestamp sesuai yang diinginkan (%Y-%m-%d %H:%M)
            formatted_timestamp = timestamp_gmt7.strftime('%Y-%m-%d %H:%M')

            data_list.append({
                "latitude": float(data.get('latitude', 0.0)),  # Default 0.0 jika tidak ada
                "longitude": float(data.get('longitude', 0.0)),  # Default 0.0 jika tidak ada
                "battery_percentage": float(data.get('battery_percentage', 100)),  # Default 100 jika tidak ada
                "timestamp": formatted_timestamp  # Timestamp dalam format '%Y-%m-%d %H:%M' GMT+7
            })

        # Mengembalikan data dalam format JSON
        return jsonify(data_list), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400




@app.route('/api/realtime-collections', methods=['POST'])
def post_realtime_location():
    try:
        # Mendapatkan data lokasi dan persentase baterai dari request
        data = request.get_json()

        # Mendapatkan latitude, longitude, dan persentase baterai dari data
        latitude = float(data.get('latitude', 0.0))
        longitude = float(data.get('longitude', 0.0))
        battery_percentage = float(data.get('battery_percentage', 100))  # Default 100% jika tidak ada

        # Mendapatkan waktu saat ini dalam zona waktu GMT+7
        timestamp_gmt7 = datetime.now(gmt7)

        # Mengonversi waktu GMT+7 ke timestamp Unix
        timestamp = timestamp_gmt7.timestamp()

        # Menyimpan data lokasi dan persentase baterai ke collection realtime_collection
        result = realtime_collection.insert_one({
            "latitude": latitude,
            "longitude": longitude,
            "battery_percentage": battery_percentage,  # Menyimpan persentase baterai
            "timestamp": timestamp  # Menyimpan timestamp UNIX GMT+7
        })

        return jsonify({"message": "Location data and battery percentage saved successfully!", "id": str(result.inserted_id)}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400






def haversine(lat1, lon1, lat2, lon2):
    R = 6371  # Radius bumi dalam kilometer
    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    delta_phi = math.radians(lat2 - lat1)
    delta_lambda = math.radians(lon2 - lon1)

    a = math.sin(delta_phi / 2)**2 + math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    return R * c  # Jarak dalam kilometer

def format_time_diff(seconds):
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    return f"{int(hours)} jam {int(minutes)} menit"

def calculate_time_diff(first_timestamp_str, last_timestamp_str):
    first_timestamp = datetime.strptime(first_timestamp_str, "%Y-%m-%d %H:%M")
    last_timestamp = datetime.strptime(last_timestamp_str, "%Y-%m-%d %H:%M")
    
    if first_timestamp < last_timestamp:
        first_timestamp, last_timestamp = last_timestamp, first_timestamp

    time_diff_seconds = (first_timestamp - last_timestamp).total_seconds()
    time_diff_hours = time_diff_seconds / 3600
    return format_time_diff(time_diff_seconds), round(time_diff_hours, 2)

def update_realtime_jaraktempuh():
    # Ambil data dari endpoint /api/realtime-collections
    response = requests.get('https://smart-cane.vercel.app/api/realtime-collections')  # Ganti dengan URL endpoint yang sesuai
    if response.status_code != 200:
        print("Gagal mengambil data dari endpoint /api/realtime-collections")
        return

    data = response.json()

    # Mendapatkan waktu saat ini di GMT+7
    gmt7 = datetime.now(timezone(timedelta(hours=7)))

    # Formatkan menjadi 'YYYY-MM-DD' sesuai kebutuhan
    today = gmt7.strftime('%Y-%m-%d')

    # Menyaring data yang hanya pada tanggal hari ini
    todays_data = [entry for entry in data if entry['timestamp'].startswith(today)]

    if len(todays_data) < 2:
        print("Data tidak cukup untuk menghitung jarak dan waktu")
        return

    # Ambil data pertama dan terakhir pada hari ini
    first_data = todays_data[0]
    last_data = todays_data[-1]

    # Menghitung selisih waktu dalam jam
    formatted_time_diff, time_diff_hours = calculate_time_diff(first_data["timestamp"], last_data["timestamp"])

    # Menghitung total jarak
    total_distance = 0
    for i in range(1, len(todays_data)):
        lat1, lon1 = todays_data[i-1]["latitude"], todays_data[i-1]["longitude"]
        lat2, lon2 = todays_data[i]["latitude"], todays_data[i]["longitude"]
        total_distance += haversine(lat1, lon1, lat2, lon2)

    formatted_distance = round(total_distance, 2)

    # Menghapus seluruh data sebelumnya agar hanya ada satu data di collection
    realtime_jaraktempuh_collection.delete_many({})  # Menghapus semua data di collection

    # Menyimpan atau memperbarui data terbaru dengan time_diff_hours, time_diff, total_distance_km
    realtime_jaraktempuh_collection.insert_one({
        'time_diff_hours': round(time_diff_hours, 2),  # Menyimpan waktu dalam jam
        'time_diff': formatted_time_diff,  # Menyimpan waktu dalam format jam dan menit
        'total_distance_km': formatted_distance,  # Menyimpan total jarak
        'first_timestamp': first_data["timestamp"],  # Menyimpan timestamp pertama
        'last_timestamp': last_data["timestamp"],  # Menyimpan timestamp terakhir
        'tanggal': today  # Menyimpan tanggal untuk referensi
    })

    print("Data telah diperbarui")




# Menjadwalkan fungsi update setiap 3 detik
scheduler = BackgroundScheduler()
scheduler.add_job(update_realtime_jaraktempuh, 'interval', seconds=3)
scheduler.start()

@app.route('/api/realtime-jaraktempuh', methods=['POST'])
def realtime_jaraktempuh():
    return jsonify({"status": "Data sedang diperbarui otomatis setiap 3 detik"}), 200


@app.route('/api/realtime-jaraktempuh', methods=['GET'])
def get_all_realtime_jaraktempuh():
    # Mengambil semua data dari collection
    data = list(realtime_jaraktempuh_collection.find({}))

    if not data:
        return jsonify({"message": "Tidak ada data tersedia"}), 404

    # Konversi ObjectId ke string agar bisa di-serialisasi menjadi JSON
    for entry in data:
        entry['_id'] = str(entry['_id'])

    return jsonify(data), 200





def move_data_to_rekap():
    # Ambil data dari collection 'realtime_jaraktempuh'
    
    # Mengambil waktu saat ini dan menyesuaikannya ke GMT+7
    today_gmt7 = datetime.utcnow() + timedelta(hours=7)
    today = today_gmt7.strftime('%Y-%m-%d')  # Menggunakan format 'YYYY-MM-DD'

    data = list(realtime_jaraktempuh_collection.find({}))

    if not data:
        print("Tidak ada data yang akan dipindahkan.")
        return

    # Menambahkan tanggal ke data yang akan dipindahkan
    for entry in data:
        entry['tanggal'] = today

    # Memasukkan data ke collection 'rekap'
    rekap_collection.insert_many(data)

    # Menghapus data dari collection 'realtime_jaraktempuh'
    realtime_jaraktempuh_collection.delete_many({})

    print(f"Data untuk tanggal {today} telah dipindahkan ke collection 'rekap'.")

# Menjadwalkan pemindahan data setiap hari pada pukul 23:59 GMT+7
scheduler = BackgroundScheduler()
scheduler.add_job(move_data_to_rekap, 'cron', hour=23, minute=59, timezone='Asia/Jakarta')
scheduler.start()


@app.route('/api/history-notification', methods=['POST'])
def history_notification_endpoint():
    try:
        # Mendapatkan data notifikasi dari request
        notification_data = request.get_json()
        
        # Menambahkan notifikasi ke collection history_notification dengan timestamp di zona waktu GMT+7
        current_time_gmt7 = datetime.now(gmt7)
        timestamp = current_time_gmt7.timestamp()  # Menggunakan timestamp dalam zona waktu GMT+7

        history_notification.insert_one({
            "message": notification_data.get('message'),
            "latitude": notification_data.get('latitude', 0.0),
            "longitude": notification_data.get('longitude', 0.0),
            "timestamp": timestamp  # Menambahkan timestamp untuk referensi waktu
        })
        
        return jsonify({"message": "Notification saved successfully!"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/api/history-notification', methods=['GET'])
def get_history_notification():
    try:
        # Ambil semua data dari koleksi history_notification, diurutkan berdasarkan timestamp (terbaru ke terlama)
        notifications = list(history_notification.find().sort("timestamp", -1))

        # Format data menjadi JSON yang dapat digunakan frontend
        response_data = []
        for notification in notifications:
            # Mengonversi timestamp ke zona waktu GMT+7 untuk ditampilkan
            timestamp = notification.get("timestamp", 0)
            gmt7_time = datetime.fromtimestamp(timestamp, gmt7)  # Mengonversi ke GMT+7
            formatted_time = gmt7_time.strftime('%Y-%m-%d %H:%M')  # Format timestamp

            response_data.append({
                "message": notification.get("message", "No message"),  # Field message
                "latitude": notification.get("latitude", 0.0),         # Field latitude
                "longitude": notification.get("longitude", 0.0),       # Field longitude
                "timestamp": formatted_time  # Format timestamp
            })

        return jsonify(response_data), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/api/emergency-notification', methods=['POST'])
def emergency_notification_endpoint():
    try:
        # Mendapatkan data notifikasi dari request
        notification_data = request.get_json()
        
        # Menambahkan notifikasi ke collection emergency_notification dengan timestamp di zona waktu GMT+7
        current_time_gmt7 = datetime.now(gmt7)
        timestamp = current_time_gmt7.timestamp()  # Menggunakan timestamp dalam zona waktu GMT+7

        emergency_notification.insert_one({
            "message": notification_data.get('message'),
            "latitude": notification_data.get('latitude', 0.0),
            "longitude": notification_data.get('longitude', 0.0),
            "timestamp": timestamp  # Menambahkan timestamp untuk referensi waktu
        })
        
        return jsonify({"message": "Notification saved successfully!"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/api/emergency-notification', methods=['GET'])
def get_emergency_notification():
    try:
        # Ambil semua data dari koleksi emergency_notification, diurutkan berdasarkan timestamp (terbaru ke terlama)
        notifications = list(emergency_notification.find().sort("timestamp", -1))

        # Format data menjadi JSON yang dapat digunakan frontend
        response_data = []
        for notification in notifications:
            # Mengonversi timestamp ke zona waktu GMT+7 untuk ditampilkan
            timestamp = notification.get("timestamp", 0)
            gmt7_time = datetime.fromtimestamp(timestamp, gmt7)  # Mengonversi ke GMT+7
            formatted_time = gmt7_time.strftime('%Y-%m-%d %H:%M')  # Format timestamp

            response_data.append({
                "message": notification.get("message", "No message"),  # Field message
                "latitude": notification.get("latitude", 0.0),         # Field latitude
                "longitude": notification.get("longitude", 0.0),       # Field longitude
                "timestamp": formatted_time  # Format timestamp
            })

        return jsonify(response_data), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400



@app.route('/send-command', methods=['POST'])
def send_command():
    # Ambil perintah dari body request
    command = request.json.get('command')

    # Simpan perintah (misalnya, di file log atau database)
    with open('command_log.json', 'a') as f:
        json.dump({'command': command}, f)
        f.write('\n')

    return jsonify({'status': 'success', 'message': f'Perintah "{command}" diterima dan disimpan.'})

# Fungsi untuk menambahkan data dummy secara otomatis






if __name__ == '__main__':
    try:
        app.run(debug=True, host='0.0.0.0', port=5000, use_reloader=False)
    except (KeyboardInterrupt, SystemExit):
        pass
    finally:
        scheduler.shutdown()
