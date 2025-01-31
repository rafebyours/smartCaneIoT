import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DeveloperInfoPage extends StatefulWidget {
  const DeveloperInfoPage({super.key});

  @override
  _DeveloperInfoPageState createState() => _DeveloperInfoPageState();
}

class _DeveloperInfoPageState extends State<DeveloperInfoPage>
    with SingleTickerProviderStateMixin {
  int? selectedMemberIndex;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  // Data team members tetap sama
  final List<Map<String, dynamic>> teamMembers = [
    {
      'firstName': 'Rena',
      'fullName': 'Rena Heryani',
      'nim': '15-2022-218',
      'role': 'Pengembang Aplikasi Mobile',
      'description':
          'Rena bertanggung jawab untuk merancang dan mengembangkan aplikasi mobile yang digunakan bersama dengan tongkat tunanetra.',
    },
    {
      'firstName': 'Helen',
      'fullName': 'Helen Ayudia Yunita',
      'nim': '15-2022-265',
      'role': 'Pengembang Web',
      'description':
          'Helen mengembangkan aplikasi web yang terhubung dengan tongkat, memungkinkan pelacakan lokasi dan pengelolaan data pengguna.',
    },
    {
      'firstName': 'Rafli',
      'fullName': 'Rafli Nugraha',
      'nim': '15-2022-254',
      'role': 'Backend Developer',
      'description':
          'Rafli bertanggung jawab untuk membangun dan mengelola backend sistem, memastikan integrasi yang baik antara aplikasi mobile, aplikasi web, dan perangkat keras.',
    },
    {
      'firstName': 'Reza',
      'fullName': 'Fahreza Riana Attarik',
      'nim': '15-2022-238',
      'role': 'Desainer dan Pembuat Alat',
      'description':
          'Reza mengerjakan perancangan dan pembuatan perangkat keras tongkat tunanetra.',
    },
    {
      'firstName': 'Umar',
      'fullName': 'Muhammad Umar Maruapey',
      'nim': '15-2022-264',
      'role': 'Desainer dan Pembuat Alat',
      'description':
          'Umar bekerja sama dengan Reza dalam merancang dan memproduksi alat untuk pengguna.',
    },
    {
      'firstName': 'Fathan',
      'fullName': 'Muhammad Fathan Hasan',
      'nim': '15-2022-233',
      'role': 'Desain dan Pengembangan Kotak Alat',
      'description':
          'Fathan bertanggung jawab untuk merancang dan membuat kotak pelindung untuk alat, sehingga alat tersebut dapat digunakan dengan aman dan nyaman.',
    },
    {
      'firstName': 'Piter',
      'fullName': 'Juviter Siburian',
      'nim': '15-2022-255',
      'role': 'Desain dan Pengembangan Kotak Kalung',
      'description':
          'Piter membuat desain dan konstruksi kotak untuk kalung pelacak yang digunakan bersama dengan tongkat tunanetra.',
    },
  ];

  final double boxWidth = 150;
  final double imageSize = 140;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Informasi Developer',
          style: TextStyle(color: Colors.black),
        ).animate().fadeIn(duration: 600.ms).slideX(),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card dengan animasi
              Container(
                width: double.infinity,
                height: 230,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFABDAD3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Kelompok D-05',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: -0.2, end: 0),
                    const SizedBox(height: 5),
                    Image.asset(
                      'assets/team.png',
                      width: 200,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                        .animate()
                        .scale(duration: 800.ms, curve: Curves.easeOutBack)
                        .fade(),
                  ],
                ),
              ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 20),

              const Text(
                'Our Team',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(duration: 800.ms, delay: 300.ms).slideX(),

              const SizedBox(height: 10),

              // Animated ListView untuk anggota tim
              SizedBox(
                height: 190,
                child: ClipRect(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: teamMembers.length,
                    itemBuilder: (context, index) {
                      final firstName =
                          teamMembers[index]['firstName'] ?? 'No Name';
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMemberIndex =
                                selectedMemberIndex == index ? null : index;
                          });
                        },
                        child: Container(
                          width: boxWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFABDAD3),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Ganti CircleAvatar dengan ClipRRect
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),  // Sudut gambar agar sesuai dengan kotak
                                child: Image.asset(
                                  'assets/${firstName.toLowerCase()}.png',
                                  width: imageSize,  // Atur ukuran gambar
                                  height: imageSize,  // Atur ukuran gambar
                                  fit: BoxFit.cover,  // Mengisi kotak dengan gambar tanpa merusak rasio
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                firstName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                            .animate(
                              delay: Duration(milliseconds: 100 * index),
                            )
                            .fadeIn(duration: 800.ms)
                            .slideX(begin: 0.2, end: 0)
                            .scale(delay: 200.ms),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Animated Detail Card
              if (selectedMemberIndex != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFABDAD3),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teamMembers[selectedMemberIndex!]['fullName'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideX(),
                      const SizedBox(height: 5),
                      Text(
                        'NIM: ${teamMembers[selectedMemberIndex!]['nim'] ?? ''}',
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 100.ms)
                          .slideX(),
                      const SizedBox(height: 5),
                      Text(
                        'Peran: ${teamMembers[selectedMemberIndex!]['role'] ?? ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 200.ms)
                          .slideX(),
                      const SizedBox(height: 5),
                      Text(
                        teamMembers[selectedMemberIndex!]['description'] ?? '',
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 300.ms)
                          .slideX(),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
            ],
          ),
        ),
      ),
    );
  }
}
