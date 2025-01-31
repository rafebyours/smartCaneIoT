import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AboutSmartCanePage extends StatelessWidget {
  const AboutSmartCanePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tentang Aplikasi Smart Cane',
          style: TextStyle(color: Colors.black),
        ).animate().fadeIn(duration: 600.ms).moveY(begin: -30),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFABDAD3),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: const Text(
                  'Deskripsi Aplikasi',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(duration: 600.ms).moveY(begin: -20),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: Image.asset(
                  'assets/5.png',
                  height: 200.0,
                ).animate().fadeIn(duration: 800.ms).scaleXY(begin: 0.8),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Smart Cane adalah aplikasi pendamping untuk tongkat pintar yang dirancang khusus bagi penyandang tunanetra. Dengan teknologi canggih yang terintegrasi melalui sensor dan GPS, aplikasi ini membantu pengguna untuk bergerak lebih aman dan memberikan ketenangan bagi keluarga.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ).animate().fadeIn(duration: 700.ms).moveX(begin: -20),
              const SizedBox(height: 16.0),
              const Text(
                '1. Fitur Utama Smart Cane',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ).animate().fadeIn(duration: 700.ms).moveX(begin: -20),
              const SizedBox(height: 8.0),
              _buildFeatureItem(
                'a. Deteksi Rintangan',
                'Dilengkapi dengan sensor ultrasonik yang mendeteksi rintangan di depan, samping kanan, dan kiri hingga jarak 75 cm. Saat terdeteksi rintangan seperti genangan air, tiang, atau pohon, tongkat akan memberikan peringatan suara.',
              ),
              _buildFeatureItem(
                'b. Pelacakan GPS',
                'Melalui modul GPS yang terhubung ke aplikasi mobile dan web, keluarga dapat melacak lokasi pengguna secara real-time, sehingga sangat membantu jika pengguna tersesat.',
              ),
              _buildFeatureItem(
                'c. Tombol Darurat',
                'Pengguna dapat menekan tombol darurat pada tongkat jika membutuhkan bantuan. Notifikasi langsung akan dikirimkan ke aplikasi keluarga, disertai informasi lokasi.',
              ),
              _buildFeatureItem(
                'd. Pelacakan Tongkat dengan Kalung',
                'Fitur kalung pelacak (dalam pengembangan) memungkinkan pengguna melacak tongkat yang mungkin terjatuh atau tertinggal dengan tombol khusus. Tongkat akan mengeluarkan suara unik untuk memudahkan pengguna menemukannya.',
              ),
              _buildFeatureItem(
                'e. Instruksi Pulang',
                'Aplikasi dapat mengirimkan perintah suara “instruksi pulang” ke tongkat, memberi tahu pengguna untuk kembali ke rumah. Notifikasi juga muncul di aplikasi keluarga.',
              ),
              _buildFeatureItem(
                'f. Peringatan Baterai',
                'Status baterai ditampilkan di aplikasi, dan jika daya hampir habis, pengguna akan menerima peringatan suara. Tongkat juga mengeluarkan suara khusus sebagai tanda.',
              ),
              _buildFeatureItem(
                'g. Rekap Jarak',
                'Rekap jarak dari tongkat dinyalakan sampai dimatikan dicatat setiap hari.',
              ),
              const SizedBox(height: 16.0),
              const Text(
                '2. Manfaat Menggunakan Aplikasi dan Alat Ini',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ).animate().fadeIn(duration: 700.ms).moveX(begin: -20),
              const SizedBox(height: 8.0),
              _buildBenefitItem(
                'a. Meningkatkan Keamanan',
                'Dengan deteksi rintangan dan pelacakan GPS, pengguna merasa lebih aman saat beraktivitas di luar ruangan.',
              ),
              _buildBenefitItem(
                'b. Ketenangan Pikiran',
                'Keluarga dapat melacak lokasi pengguna secara real-time, memberikan ketenangan pikiran bagi mereka.',
              ),
              _buildBenefitItem(
                'c. Respon Darurat yang Cepat',
                'Tombol darurat pada tongkat memungkinkan pengguna untuk mendapatkan bantuan dengan cepat jika diperlukan.',
              ),
              _buildBenefitItem(
                'd. Kemudahan dalam Navigasi',
                'Aplikasi memberikan instruksi pulang yang memudahkan pengguna untuk kembali ke lokasi yang dikenal.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk item fitur dengan animasi fade dan move
  Widget _buildFeatureItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ).animate().fadeIn(duration: 500.ms).moveX(begin: -20),
        const SizedBox(height: 4.0),
        Text(
          description,
          style: const TextStyle(fontSize: 14.0),
          textAlign: TextAlign.justify,
        ).animate().fadeIn(duration: 500.ms).moveX(begin: 20),
        const SizedBox(height: 12.0),
      ],
    );
  }

  // Widget untuk item manfaat dengan animasi fade dan move
  Widget _buildBenefitItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ).animate().fadeIn(duration: 500.ms).moveX(begin: -20),
        const SizedBox(height: 4.0),
        Text(
          description,
          style: const TextStyle(fontSize: 14.0),
          textAlign: TextAlign.justify,
        ).animate().fadeIn(duration: 500.ms).moveX(begin: 20),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
