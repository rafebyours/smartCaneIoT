import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ContactInfoPage extends StatelessWidget {
  const ContactInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Informasi Kontak',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFABDAD3),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jika Anda memerlukan bantuan atau memiliki pertanyaan mengenai aplikasi Smart Cane, silakan hubungi kami melalui informasi kontak berikut:',
                    style: TextStyle(fontSize: 16),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .move(begin: Offset(0, 10)),
                  const SizedBox(height: 16),
                  const Text(
                    'Tim Pengembang Smart Cane',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .move(begin: Offset(0, 10)),
                  const SizedBox(height: 10),
                  buildContactInfoRow(
                    icon: Icons.email,
                    label: 'Email: smartcane.support@example.com',
                    onTap: () => _launchEmail('smartcane.support@example.com'),
                  ),
                  buildContactInfoRow(
                    icon: Icons.phone,
                    label: 'Telepon: +62 123 456 7890',
                    onTap: () => _launchPhone('+621234567890'),
                  ),
                  buildContactInfoRow(
                    icon: FontAwesomeIcons.whatsapp,
                    label: 'WhatsApp: +62 987 654 3210',
                    onTap: () => _launchWhatsApp('+629876543210'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Jam Operasional',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .move(begin: Offset(0, 10)),
                  const SizedBox(height: 10),
                  const Text('Senin - Jumat: Tutup'),
                  const Text('Sabtu: 10.00 - 10.10 WIB'),
                  const Text('Minggu: Tutup'),
                  const SizedBox(height: 20),
                  const Text(
                    'Kami siap membantu Anda dengan pertanyaan, masukan, atau masalah yang mungkin Anda hadapi dalam menggunakan aplikasi dan alat Smart Cane.',
                    style: TextStyle(fontSize: 16),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .move(begin: Offset(0, 10)),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).move(begin: const Offset(0, 20)),
          ],
        ),
      ),
    );
  }

  Widget buildContactInfoRow(
      {required IconData icon,
      required String label,
      required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).move(begin: const Offset(0, 10));
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    }
  }

  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    }
  }

  void _launchWhatsApp(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunch(whatsappUri.toString())) {
      await launch(whatsappUri.toString());
    }
  }
}
