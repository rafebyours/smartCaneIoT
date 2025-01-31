import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'api_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      final List<dynamic> response = await ApiService.fetchHistoryNotifications();
      for (final notification in response) {
        await _showNotification(
          "Notifikasi Baru",
          notification["message"] ?? "Tidak ada pesan",
        );
      }

      return response.map((notification) {
        return {
          "message": notification["message"] ?? "Tidak ada pesan",
          "timestamp": notification["timestamp"] ?? "Waktu tidak tersedia",
          "latitude": notification["latitude"] ?? 0.0,
          "longitude": notification["longitude"] ?? 0.0,
        };
      }).toList();
    } catch (e) {
      throw Exception("Failed to load notifications: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchEmergencyNotifications() async {
    return ApiService.fetchEmergencyNotifications();
  }

  Future<void> _openLocation(double latitude, double longitude) async {
    final url = Uri.parse('https://www.google.com/maps?q=$latitude,$longitude');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

Widget _buildNotificationList(
    Future<List<Map<String, dynamic>>> Function() fetchFunction, bool isEmergency) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: fetchFunction(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text("Error: ${snapshot.error}"),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(
          child: Text("No notifications available."),
        );
      }

      final notifications = snapshot.data!;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),  // Add horizontal padding
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            // Tentukan warna berdasarkan jenis notifikasi
            final bgColor = isEmergency
                ? const Color(0xFFEB5757) // Warna merah untuk notifikasi darurat
                : (index % 2 == 0)
                    ? const Color(0xFFABDAD3)
                    : const Color(0xFF7BBAB3);

            final latitude = notifications[index]["latitude"];
            final longitude = notifications[index]["longitude"];

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0), // Menambahkan margin
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notifications[index]["timestamp"]!,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white54, // Ubah warna timestamp menjadi lebih terang
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    notifications[index]["message"]!,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white, // Mengubah warna teks pesan notifikasi menjadi putih
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () => _openLocation(latitude, longitude),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: bgColor,
                    ),
                    child: const Text("Lihat Lokasi"),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOut);
          },
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, 
        bottom: TabBar(
          indicatorColor: const Color(0xFFABDAD3), 
          labelColor: const Color(0xFFABDAD3), 
          unselectedLabelColor: Colors.grey, 
          tabs: const [
            Tab(text: "Notifikasi"),
            Tab(text: "Notifikasi Darurat"),
          ],
        ),
      ),
      body: Container(
        color: Colors.white, // White background for the body area
        child: TabBarView(
          children: [
            _buildNotificationList(fetchNotifications, false),
            _buildNotificationList(fetchEmergencyNotifications, true),
          ],
        ),
      ),
    ),
  );
}

}


const List<String> _monthNames = [
  "", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
];
