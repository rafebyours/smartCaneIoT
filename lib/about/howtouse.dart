import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Cara Menggunakan Aplikasi Smart Cane',
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
              _buildSectionTitle('1. Menyalakan Tongkat')
                  .animate()
                  .fade(duration: 400.ms),
              _buildHowToItem(
                'Tombol Power:',
                'Untuk menyalakan tongkat, tekan tombol power yang terdapat pada tongkat. Setelah tombol ditekan, tongkat akan aktif dan langsung terhubung dengan aplikasi.',
              ),
              _buildHowToItem(
                'Pelacakan Lokasi:',
                'Setelah tongkat dinyalakan, lokasi pengguna akan otomatis dilacak dan ditampilkan di aplikasi. Pastikan koneksi internet aktif untuk memanfaatkan fitur ini.',
              ),
              _buildSectionTitle('2. Fitur Deteksi Rintangan')
                  .animate()
                  .fade(duration: 400.ms),
              _buildHowToItem(
                'Peringatan Suara:',
                'Saat tongkat mendeteksi rintangan seperti genangan air, lubang, pohon, bebatuan, atau tembok, akan muncul peringatan atau pemberitahuan suara dari alat.',
              ),
              _buildSectionTitle('3. Tombol Darurat')
                  .animate()
                  .fade(duration: 400.ms),
              _buildHowToItem(
                'Penggunaan Tombol Darurat:',
                'Jika pengguna merasa dalam keadaan darurat dan memerlukan bantuan, cukup tekan tombol darurat yang ada di tongkat.',
              ),
              _buildHowToItem(
                'Notifikasi:',
                'Ketika tombol darurat ditekan, aplikasi akan mengirimkan notifikasi kepada keluarga atau pihak terkait, memberi tahu bahwa pengguna memerlukan bantuan.',
              ),
              // Tambahkan langkah lainnya sesuai dengan pola di atas
              // ...
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHowToItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ).animate().fade(duration: 400.ms, delay: 200.ms),
        const SizedBox(height: 4.0),
        Text(
          description,
          style: const TextStyle(fontSize: 14.0),
          textAlign: TextAlign.justify,
        ).animate().fade(duration: 400.ms, delay: 300.ms),
        const SizedBox(height: 12.0),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }
}
