import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Ganti dengan URL Ngrok atau Flask Anda
  static const String baseUrl = "https://smart-cane.vercel.app";

  static Future<List<Map<String, dynamic>>> fetchRealtimeCollections() async {
    final url = Uri.parse('$baseUrl/api/realtime-collections');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Convert timestamp (in seconds) to DateTime
        for (var entry in data) {
          if (entry['timestamp'] is double) {
            entry['timestamp'] = DateTime.fromMillisecondsSinceEpoch(
                (entry['timestamp'] * 1000).toInt());
          }
        }

        return data.map((entry) => entry as Map<String, dynamic>).toList();
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

// Function to format DateTime as string



static Future<void> sendAlert() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/send_alert'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Data Sent: ${data['message']}');
      } else {
        print('Failed to send alert: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

static Future<Duration> calculateTravelTime() async {
  final url = Uri.parse('$baseUrl/api/realtime-collections');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body) as Map<String, dynamic>;
    
    // Contoh asumsi: timestamp awal dikirim dari server
    final startTime = DateTime.parse(data['start_time']); // Contoh key: 'start_time'
    final currentTime = DateTime.now();

    // Hitung durasi
    return currentTime.difference(startTime);
  } else {
    throw Exception("Failed to fetch travel time");
  }
}




  // Fetch history notifications
  static Future<List<dynamic>> fetchHistoryNotifications() async {
    final url = Uri.parse('$baseUrl/api/history-notification');

    try {
      final response = await http.get(url);  // Send GET request

      if (response.statusCode == 200) {
        // Parse the JSON response body and return as a list of notifications
        return json.decode(response.body);
      } else {
        // Handle unsuccessful request
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      // Handle errors, e.g., network issues
      print("Error fetching notifications: $e");
      return [];  // Return an empty list if there was an error
    }
  }


static Future<String> fetchBatteryPercentage() async {
  final url = Uri.parse('$baseUrl/api/realtime-collections');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    // Check if the data contains 'battery_percentage'
    if (data != null && data.isNotEmpty) {
      final batteryPercentage = data[0]['battery_percentage']; // Assume the first data point is representative

      // Ensure the battery_percentage is an integer
      if (batteryPercentage is int) {
        return batteryPercentage.toString(); // Convert to string and return
      } else {
        throw Exception("Battery percentage is not an integer");
      }
    } else {
      throw Exception("Battery percentage is missing or data is empty");
    }
  } else {
    throw Exception("Failed to fetch battery percentage");
  }
}






static Future<Map<String, double>> fetchCoordinates() async {
  try {
    final url = Uri.parse('$baseUrl/api/realtime-collections');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data == null || data.isEmpty) {
        throw Exception("Received empty or null data from the server");
      }

      // Check if the response contains the expected latitude and longitude
      final latestData = data[0]; // Assuming response is a list
      if (latestData != null && latestData['latitude'] != null && latestData['longitude'] != null) {
        double latitude = latestData['latitude'];
        double longitude = latestData['longitude'];
        return {'latitude': latitude, 'longitude': longitude};
      } else {
        throw Exception("Latitude or Longitude is missing in the response");
      }
    } else {
      throw Exception("Failed to fetch coordinates: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching coordinates: $e");
    throw Exception("Error fetching coordinates: $e");
  }
}

  // Add fetchCoordinatesAndTimestamps method here
  static Future<Map<String, dynamic>> fetchCoordinatesAndTimestamps() async {
    final url = Uri.parse('$baseUrl/api/realtime-collections');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Ambil data pertama (terbaru) jika response berupa array
      final latestData = data[0];

      final firstTimestamp = DateTime.parse(latestData['timestamp']); // Asumsi timestamp ada di data
      final firstLatitude = latestData['latitude'];
      final firstLongitude = latestData['longitude'];

      // Misalkan Anda ingin mengambil data terakhir dalam array
      final lastData = data[data.length - 1]; // Mengambil data terakhir
      final lastTimestamp = DateTime.parse(lastData['timestamp']); // Asumsi timestamp ada di data
      final lastLatitude = lastData['latitude'];
      final lastLongitude = lastData['longitude'];

      // Mengembalikan data dalam bentuk Map
      return {
        'firstTimestamp': firstTimestamp,
        'lastTimestamp': lastTimestamp,
        'firstLatitude': firstLatitude,
        'firstLongitude': firstLongitude,
        'lastLatitude': lastLatitude,
        'lastLongitude': lastLongitude,
      };
    } else {
      throw Exception("Failed to fetch coordinates and timestamps");
    }
  }

   static Future<List<Map<String, dynamic>>> fetchEmergencyNotifications() async {
    final url = Uri.parse('$baseUrl/api/emergency-notification');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((entry) {
          return {
            'latitude': entry['latitude'] ?? 0.0,
            'longitude': entry['longitude'] ?? 0.0,
            'message': entry['message'].toString(), // Convert message to string
            'timestamp': entry['timestamp'] ?? "Waktu tidak tersedia", // Fallback untuk timestamp
          };
        }).toList();
      } else {
        throw Exception("Failed to load emergency notifications");
      }
    } catch (e) {
      print("Error fetching emergency notifications: $e");
      return [];
    }
  }



  static Future<List<Map<String, dynamic>>> fetchRealtimeJarakTempuh() async {
  final url = Uri.parse('$baseUrl/api/realtime-jaraktempuh');
  
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Konversi data menjadi list of maps
      return data.map((entry) {
        return {
          'time_diff_hours': entry['time_diff_hours'] ?? 0.0,
          'time_diff': entry['time_diff'] ?? "Tidak tersedia",
          'total_distance_km': entry['total_distance_km'] ?? 0.0,
          'first_timestamp': entry['first_timestamp'] ?? "Waktu tidak tersedia",
          'last_timestamp': entry['last_timestamp'] ?? "Waktu tidak tersedia",
          'tanggal': entry['tanggal'] ?? "Tanggal tidak tersedia",
        };
      }).toList();
    } else {
      throw Exception("Failed to load realtime jarak tempuh data");
    }
  } catch (e) {
    print("Error fetching realtime jarak tempuh: $e");
    return [];
  }
}


 static Future<List<Map<String, dynamic>>> fetchRekap() async {
    final response = await http.get(Uri.parse('$baseUrl/api/rekap'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }



}
