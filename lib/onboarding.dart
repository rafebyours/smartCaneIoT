import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:smart_cane/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 1.5.seconds,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
    _controller.repeat(reverse: true);

    Future.delayed(5.seconds, () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFABDAD3),
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Image.asset(
              'assets/5.png',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Color> backgroundColors = [
    const Color(0xFFFFD3BB), // Peach pastel
    const Color(0xFFABDAD3), // Hijau kebiruan pastel
    const Color(0xFFFAE3B8), // Krem/kuning muda lembut
  ];

  final List<Color> circleColors = [
    const Color(0xFFFFC1A1), // Cokelat pastel lembut, cocok dengan peach
    const Color(0xFF8AC0B9), // Hijau kebiruan pastel, transisi ke hijau kebiruan
    const Color(0xFFE6A87C), // Oranye peach, mendekati peach pastel
  ];


  final List<OnboardingPageData> pages = [
    OnboardingPageData(
      image: 'assets/People.png',
      title: 'Selamat Datang di Smart Cane',
      description:
          'Aplikasi ini membantu memantau mobilitas pengguna tongkat pintar dengan fitur deteksi rintangan, pelacakan lokasi, dan notifikasi darurat.',
      imagePosition: const Offset(40, 110),
      circleColor: const Color(0xFFFFC1A1),
      circlePosition: const Offset(10, 80),
    ),
    OnboardingPageData(
      image: 'assets/Maps.png',
      title: 'Pelacakan Lokasi Real-Time',
      description:
          'Lacak lokasi pengguna tongkat secara real-time, sehingga Anda selalu tahu keberadaannya dan dapat membantu jika tersesat.',
      imagePosition: const Offset(75, 130),
      circleColor: const Color(0xFF7BBAB3),
      circlePosition: const Offset(65, 110),
    ),
    OnboardingPageData(
      image: 'assets/Notif.png',
      title: 'Notifikasi Darurat',
      description:
          'Pengguna tongkat dapat menekan tombol darurat jika butuh bantuan. Anda akan menerima notifikasi langsung dan dapat melacak lokasinya untuk membantu segera.',
      imagePosition: const Offset(150, 130),
      circleColor: const Color(0xFFCC8C4D),
      circlePosition: const Offset(90, 80),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: backgroundColors[currentIndex],
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemCount: pages.length,
                itemBuilder: (context, index) => OnboardingPage(
                  data: pages[index],
                  animation: CustomAnimation<double>(
                    control: CustomAnimationControl.play,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (context, child, value) {
                      return Opacity(
                        opacity: value,
                        child: child,
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Button kanan kiri
                  Row(
                    children: [
                      CustomIconButton(
                        icon: Icons.arrow_back,
                        onPressed: currentIndex == 0
                            ? null
                            : () {
                                _pageController.previousPage(
                                  duration: 500.milliseconds,
                                  curve: Curves.easeInOut,
                                );
                              },
                        color: circleColors[currentIndex],
                      ),
                      const SizedBox(width: 8),
                      CustomIconButton(
                        icon: Icons.arrow_forward,
                        onPressed: currentIndex == pages.length - 1
                            ? null
                            : () {
                                _pageController.nextPage(
                                  duration: 500.milliseconds,
                                  curve: Curves.easeInOut,
                                );
                              },
                        color: circleColors[currentIndex],
                      ),
                    ],
                  ),
                  // Indikator halaman
                  Row(
                    children: List.generate(pages.length, (index) {
                      return AnimatedContainer(
                        duration: 300.milliseconds,
                        margin: const EdgeInsets.symmetric(horizontal: 9),
                        width: currentIndex == index ? 12 : 8,
                        height: currentIndex == index ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentIndex == index
                              ? Colors.black
                              : Colors.grey.withOpacity(0.5),
                        ),
                      );
                    }),
                  ),
                  // Button Skip
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  HomePage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(
                          Colors.black12.withOpacity(0.2)),
                      shadowColor: WidgetStateProperty.all(
                          Colors.white.withOpacity(0.8)),
                      elevation: WidgetStateProperty.all(3),
                      backgroundColor: WidgetStateProperty.all(
                          Colors.white.withOpacity(0.7)),
                      minimumSize: WidgetStateProperty.all(const Size(90, 45)),
                    ),
                    child: const Text(
                      'SKIP',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final CustomAnimation<double> animation;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 1),
      builder: (context, child, value) => Stack(
        children: [
          Positioned(
            // lingkaran
            left: data.circlePosition.dx,
            top: data.circlePosition.dy,
            child: Container(
              width: 270 * value,
              height: 270 * value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: data.circleColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(2, 4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            //posisi gambar
            left: data.imagePosition.dx,
            top: data.imagePosition.dy,
            child: Opacity(
              opacity: value,
              child: Image.asset(
                data.image,
                width: 230 * value,
                height: 230 * value,
              ),
            ),
          ),
          Positioned(
            // posisi teks
            bottom: 60,
            left: 20,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Text(
                  data.description,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPageData {
  final String image;
  final String title;
  final String description;
  final Offset imagePosition;
  final Color circleColor;
  final Offset circlePosition;

  OnboardingPageData({
    required this.image,
    required this.title,
    required this.description,
    required this.imagePosition,
    required this.circleColor,
    required this.circlePosition,
  });
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(4, 4),
                blurRadius: 6,
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(icon, color: Colors.black),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
