import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'about/aplikasi.dart';
import "about/contact.dart";
import "about/dev.dart";
import "about/faq.dart";
import "about/howtouse.dart";


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xFFABDAD3),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _buildListTile(
                  context,
                  title: "Tentang Aplikasi SmartCane",
                  icon: Icons.info_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutSmartCanePage()),
                    );
                  },
                ),
                _buildDivider(),
                _buildListTile(
                  context,
                  title: "FAQ",
                  icon: FontAwesomeIcons.questionCircle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FAQPage()),
                    );
                  },
                ),
                _buildDivider(),
                _buildListTile(
                  context,
                  title: "Cara Menggunakan Aplikasi",
                  icon: FontAwesomeIcons.lightbulb,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HowToUsePage()),
                    );
                  },
                ),
                _buildDivider(),
                _buildListTile(
                  context,
                  title: "Info Developer",
                  icon: FontAwesomeIcons.code,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeveloperInfoPage()),
                    );
                  },
                ),
                _buildDivider(),
                _buildListTile(
                  context,
                  title: "Info Kontak",
                  icon: FontAwesomeIcons.envelope,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactInfoPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 25.0, color: Colors.black),
                const SizedBox(width: 18.0),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18.0, color: Colors.black),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 18.0, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.black54,
      thickness: 1.0,
      height: 1.0,
      indent: 45.0,
      endIndent: 8.0,
    );
  }
}

