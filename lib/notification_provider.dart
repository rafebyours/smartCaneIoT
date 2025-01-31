import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_cane/api_service.dart';

class NotificationProvider extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int previousNotificationCount = 0;
  Timer? _pollingTimer;

  // Inisialisasi notifikasi
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Menampilkan notifikasi
  Future<void> showNotification(String title, String body) async {
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

  // Memulai polling untuk memeriksa perubahan data notifikasi
  void startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await checkForNewNotifications();
    });
  }

  // Memeriksa apakah ada notifikasi baru
  Future<void> checkForNewNotifications() async {
    try {
      final historyNotifications = await ApiService.fetchHistoryNotifications();
      final emergencyNotifications = await ApiService.fetchEmergencyNotifications();

      final int currentNotificationCount =
          historyNotifications.length + emergencyNotifications.length;

      // Cek apakah jumlah data bertambah
      if (currentNotificationCount > previousNotificationCount) {
        final newNotifications =
            currentNotificationCount - previousNotificationCount;

        // Tampilkan notifikasi untuk jumlah data baru yang ditemukan
        await showNotification(
          'Notifikasi Baru',
          'Ada $newNotifications notifikasi baru.',
        );

        // Update jumlah notifikasi yang terakhir
        previousNotificationCount = currentNotificationCount;
      }
    } catch (e) {
      // Tangani error jika ada masalah dengan pemanggilan API
      print('Error checking for new notifications: $e');
    }
  }

  // Hentikan polling saat aplikasi berhenti atau saat tidak diperlukan lagi
  void stopPolling() {
    _pollingTimer?.cancel();
  }
}
