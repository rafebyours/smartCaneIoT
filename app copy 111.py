from flask import Flask, render_template, jsonify, request
from pymongo import MongoClient
from bson.json_util import dumps
from flask_cors import CORS
import requests
import firebase_admin
from firebase_admin import credentials, db
import time
import json

# Inisialisasi Firebase dengan file JSON credential
cred = credentials.Certificate('serviceAccountKey.json')  # Ganti dengan file JSON Anda
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://smartcane-c86f5-default-rtdb.firebaseio.com/'  # URL database Realtime Anda
})

app = Flask(__name__)

# Setup CORS
CORS(app)  # Ini akan mengaktifkan CORS untuk seluruh aplikasi
commands = []
# Setup MongoDB Client (Opsional, jika Anda menggunakan MongoDB juga)
client = MongoClient('mongodb+srv://raflinugraha:SurajaKids@smartcane.5fzgg.mongodb.net/?retryWrites=true&w=majority&appName=smartCane')  # Ganti dengan URL MongoDB server Anda
mongo_db = client['sensor_db']  # Database
mongo_collection = mongo_db['sensor_data']  # Collection MongoDB

@app.route('/upload', methods=['POST'])
def upload_data():
    try:
        # Mendapatkan data dari request
        data = request.get_json()

        # Validasi data yang diterima
        if 'ultrasonic1' not in data or 'ultrasonic2' not in data or 'water_level' not in data or 'latitude' not in data or 'longitude' not in data or 'battery_percentage' not in data:
            return jsonify({"error": "Missing required fields"}), 400

        # Referensi ke lokasi Realtime Database
        ref = db.reference('sensor_data')

        # Menyimpan data termasuk presentase baterai
        ref.push({
            "ultrasonic1": data.get('ultrasonic1', 0),
            "ultrasonic2": data.get('ultrasonic2', 0),
            "water_level": data.get('water_level', 0),
            "latitude": data.get('latitude', 0),
            "longitude": data.get('longitude', 0),
            "battery_percentage": data.get('battery_percentage', 100),  # Menambahkan presentase baterai
            "timestamp": time.time()  # Tambahkan timestamp
        })

        # Menyimpan data ke MongoDB (Jika dibutuhkan)
        mongo_collection.insert_one(data)

        return jsonify({"message": "Data saved to Realtime Database and MongoDB successfully!"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/getData', methods=['GET'])
def get_data():
    try:
        # Referensi ke lokasi Realtime Database
        ref = db.reference('sensor_data')

        # Ambil data dari Realtime Database
        data = ref.get()

        # Memastikan data dikembalikan sebagai JSON
        return jsonify(data), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/api/realtime-location', methods=['GET'])
def get_realtime_location():
    try:
        # Referensi ke lokasi Realtime Database
        ref = db.reference('sensor_data')

        # Ambil semua data dan ambil entri terakhir
        data = ref.get()
        if data:
            last_key = list(data.keys())[-1]
            last_entry = data[last_key]
            latitude = last_entry.get('latitude', 0.0)
            longitude = last_entry.get('longitude', 0.0)
            battery_percentage = last_entry.get('battery_percentage', 100)  # Ambil data baterai terakhir
        else:
            latitude, longitude, battery_percentage = 0.0, 0.0, 100.0

        return jsonify({'latitude': latitude, 'longitude': longitude, 'battery_percentage': battery_percentage}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/send-command', methods=['POST'])
def send_command():
    try:
        # Ambil perintah dari body request
        command = request.json.get('command')

        if command:
            # Simpan perintah dalam list (tidak disimpan di file)
            commands.append({'command': command, 'timestamp': time.time()})

            return jsonify({'status': 'success', 'message': f'Perintah "{command}" diterima dan disimpan.'}), 200
        else:
            return jsonify({"error": "No command provided"}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/get-command', methods=['GET'])
def get_command():
    try:
        # Mengambil semua perintah yang disimpan dalam list
        return jsonify({'commands': commands}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400

# Referensi ke lokasi history_notification di Firebase Realtime Database
history_ref = db.reference('history_notifications')

@app.route('/add-history-notification', methods=['POST'])
def add_history_notification():
    try:
        # Mendapatkan data dari request
        data = request.get_json()

        # Validasi data yang diterima
        required_fields = ['message', 'timestamp', 'longitude', 'latitude']
        missing_fields = [field for field in required_fields if field not in data]

        if missing_fields:
            return jsonify({"error": f"Missing required fields: {', '.join(missing_fields)}"}), 400

        # Menyimpan data ke Realtime Database
        history_ref.push({
            "message": data['message'],
            "timestamp": data['timestamp'],
            "longitude": data['longitude'],
            "latitude": data['latitude']
        })

        return jsonify({"message": "Notification history saved successfully!"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400



@app.route('/get-history-notifications', methods=['GET'])
def get_history_notifications():
    try:
        # Mengambil semua data dari Firebase Realtime Database
        data = history_ref.get()

        if not data:
            return jsonify({"message": "No history notifications found"}), 200

        # Memproses data untuk membuat format yang konsisten
        formatted_data = []
        for key, value in data.items():
            formatted_data.append({
                "message": value.get("message", "Unnamed notification"),
                "timestamp": value.get("timestamp", "No timestamp available"),
                "longitude": value.get("longitude", "No longitude"),
                "latitude": value.get("latitude", "No latitude")
            })

        return jsonify(formatted_data), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400



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

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
