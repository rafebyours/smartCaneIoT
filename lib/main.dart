import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'notification_provider.dart';  // Impor NotificationProvider yang sudah kita buat
import 'api_service.dart';  // Impor ApiService untuk akses API

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi pengaturan notifikasi
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Mulai polling untuk notifikasi baru
  runApp(
    ChangeNotifierProvider(
      create: (context) => NotificationProvider()..startPolling(),  // Mulai polling saat aplikasi dimulai
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Cane App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),  // Home screen kamu tetap SplashScreen
      debugShowCheckedModeBanner: false,
    );
  }
}

