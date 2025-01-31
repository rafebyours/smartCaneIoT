import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Kebijakan Privasi dan Syarat Penggunaan',
          style: TextStyle(color: Colors.black),
        ),
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
              const Text(
                'Kebijakan Privasi',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              _buildPrivacyPolicyItem(
                'Aplikasi Smart Cane dirancang untuk melindungi privasi pengguna sambil menyediakan fitur pelacakan yang bermanfaat bagi keluarga atau pihak terkait. Berikut adalah kebijakan privasi yang berlaku:',
                isDescription: true,
              ),
              _buildPrivacyPolicySection('1. Data yang Dikumpulkan',
                  '• Aplikasi ini mengumpulkan data lokasi pengguna saat tongkat digunakan. Data lokasi ini dibutuhkan untuk menjalankan fungsi utama aplikasi, yaitu pelacakan lokasi secara real-time untuk tujuan keamanan pengguna.'),
              _buildPrivacyPolicySection(
                  '2. Penyimpanan dan Penggunaan Data',
                  '• Data lokasi disimpan secara permanen, meskipun tongkat telah dimatikan. Riwayat lokasi akan tetap ada dan dapat diakses oleh keluarga atau pihak terkait melalui aplikasi.\n'
                      '• Data lokasi ini digunakan untuk memberikan informasi yang berguna tentang pola perjalanan pengguna dan membantu dalam situasi darurat.'),
              _buildPrivacyPolicySection('3. Keamanan Data',
                  '• Aplikasi Smart Cane memastikan bahwa data lokasi hanya dapat diakses oleh pihak-pihak yang telah diizinkan dan terdaftar di aplikasi. Kami berkomitmen untuk menjaga keamanan data pengguna dan menerapkan protokol keamanan untuk mencegah akses tidak sah.'),
              _buildPrivacyPolicySection('4. Berbagi Data dengan Pihak Ketiga',
                  '• Smart Cane tidak membagikan data lokasi pengguna kepada pihak ketiga kecuali jika diminta oleh hukum atau dalam situasi darurat di mana data lokasi pengguna dibutuhkan untuk keselamatan mereka.'),
              _buildPrivacyPolicySection('5. Persetujuan Pengguna',
                  '• Dengan menggunakan aplikasi Smart Cane, pengguna dan keluarga pengguna dianggap telah menyetujui pengumpulan, penyimpanan, dan penggunaan data lokasi sebagaimana dijelaskan di atas.'),
              _buildPrivacyPolicySection('6. Perubahan Kebijakan',
                  '• Kebijakan privasi ini dapat diperbarui sewaktu-waktu untuk menyesuaikan dengan kebutuhan atau perubahan regulasi. Setiap perubahan akan diinformasikan melalui pembaruan aplikasi.'),
              const SizedBox(height: 16.0),
              const Text(
                'Syarat Penggunaan',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              _buildPrivacyPolicySection('1. Penggunaan Aplikasi',
                  '• Aplikasi Smart Cane dirancang khusus untuk mendukung pengguna tunanetra dalam bergerak lebih aman. Dengan menggunakan aplikasi ini, pengguna dan keluarga diharapkan memahami fungsi dan keterbatasan yang ada.'),
              _buildPrivacyPolicySection(
                  '2. Hak dan Kewajiban Pengguna',
                  '• Pengguna diharapkan untuk menggunakan aplikasi secara bertanggung jawab sesuai dengan tujuan dan tidak menyalahgunakan fitur yang ada.\n'
                      '• Keluarga atau pihak terkait yang mengakses data lokasi harus menjaga kerahasiaan informasi ini dan tidak membagikannya tanpa izin.'),
              _buildPrivacyPolicySection(
                  '3. Batasan Tanggung Jawab',
                  '• Pengembang aplikasi Smart Cane tidak bertanggung jawab atas kerugian atau risiko yang mungkin timbul akibat penggunaan aplikasi, termasuk ketidakakuratan data lokasi yang disebabkan oleh masalah teknis atau konektivitas.\n'
                      '• Aplikasi ini bergantung pada koneksi internet dan modul GPS untuk menjalankan fungsinya. Oleh karena itu, pengguna diharapkan memastikan perangkat dan koneksi berjalan dengan baik saat menggunakan aplikasi.'),
              _buildPrivacyPolicySection('4. Pembatasan Umur',
                  '• Aplikasi ini diperuntukkan bagi pengguna dewasa atau pihak keluarga yang memiliki kewenangan untuk mengakses data lokasi dan mengoperasikan aplikasi.'),
              _buildPrivacyPolicySection('5. Perubahan pada Aplikasi',
                  '• Pengembang berhak untuk melakukan perubahan atau peningkatan fitur aplikasi kapan saja. Pemberitahuan akan diberikan melalui pembaruan aplikasi.'),
              _buildPrivacyPolicySection('6. Hukum yang Berlaku',
                  '• Kebijakan Privasi dan Syarat Penggunaan ini tunduk pada hukum yang berlaku di wilayah pengguna. Setiap perselisihan yang timbul dari penggunaan aplikasi ini akan diselesaikan berdasarkan hukum yang berlaku.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(height: 4.0),
          Text(
            content,
            style: const TextStyle(fontSize: 14.0),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicyItem(String content, {bool isDescription = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        content,
        style: TextStyle(
          fontSize: isDescription ? 14.0 : 16.0,
          fontWeight: isDescription ? FontWeight.normal : FontWeight.bold,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
