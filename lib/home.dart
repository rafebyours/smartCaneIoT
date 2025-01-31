import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_cane/notifikasi.dart';
import 'package:smart_cane/about.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_cane/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:badges/badges.dart' as badges;
import 'dart:math';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool showDistance = true;
  int currentIndex = 1;
  bool isHealthIconSelected = false;
  bool isProfileIconSelected = false;

  // Controllers for animations
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;

  // Menambahkan variabel untuk lokasi
  late LatLng currentLocation;
  late LatLng apiLocation;
  bool isLocationFetched = false;
  bool isApiLocationFetched = false;

  bool hasNewNotifications = false; // Variabel untuk status notifikasi baru

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    // Mengambil lokasi perangkat dan API
    _getCurrentLocation();
    _getApiLocation();
    fetchNotifications(); 
    
     // Memanggil fetch notifikasi untuk mendapatkan jumlahnya
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengambil lokasi dari GPS perangkat
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      isLocationFetched = true;
    });
  }

  // Fungsi untuk mengambil lokasi dari API
  Future<void> _getApiLocation() async {
    try {
      Map<String, double> coordinates = await ApiService.fetchCoordinates();
      setState(() {
        apiLocation = LatLng(coordinates['latitude']!, coordinates['longitude']!);
        isApiLocationFetched = true;
      });
    } catch (e) {
      print("Error fetching API location: $e");
    }
  }

    // Fungsi untuk mendapatkan dan menghitung jumlah notifikasi baru
  Future<void> fetchNotifications() async {
    try {
      // Ambil data notifikasi (tanpa menghitung berdasarkan 'read')
      final List<dynamic> notifications = await ApiService.fetchHistoryNotifications();
      setState(() {
        // Menandai bahwa ada notifikasi baru (perubahan data)
        hasNewNotifications = notifications.isNotEmpty; // Cek apakah ada notifikasi baru
      });
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  


  void toggleContent(bool isDistance) {
    setState(() {
      showDistance = isDistance;
      _slideController.reset();
      _slideController.forward();
    });
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
      _scaleController.reset();
      _scaleController.forward();
    });
  }

@override
Widget build(BuildContext context) {
  List<Widget> pages = [
    NotificationPage(),
    buildHomePage(),
    AboutPage(),
  ];

  String appBarTitle;
  switch (currentIndex) {
    case 1:
      appBarTitle = "Home";
      break;
    case 2:
      appBarTitle = "About";
      break;
    default:
      appBarTitle = "Notifikasi";
  }

  return Scaffold(
    appBar: AppBar(
      title: Text(appBarTitle)
          .animate()
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.2, end: 0),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    body: Container(
      color: Colors.white,
      child: pages[currentIndex]
          .animate(controller: _scaleController)
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
            duration: 300.ms,
            curve: Curves.easeOut,
          )
          .fade(duration: 300.ms),
    ),
    bottomNavigationBar: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            selectedItemColor: Colors.teal.shade900,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(FontAwesomeIcons.bell)
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 1200.ms, delay: 200.ms),
                label: 'Notifikasi',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined)
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 1200.ms),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.info_outline)
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 1200.ms, delay: 400.ms),
                label: 'About',
              ),
            ],
            onTap: onTabTapped,
          ),
        ),
      ),
    ),
  );
}


  Widget buildHomePage() {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            // Menggunakan `initialCenter` untuk menetapkan pusat peta
            initialCenter: isLocationFetched && isApiLocationFetched
                ? currentLocation // Lokasi perangkat
                : LatLng(0.0, 0.0), // Default jika data belum diambil
            initialZoom: 13.2,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                if (isLocationFetched)
                  Marker(
                    point: currentLocation,
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                if (isApiLocationFetched)
                  Marker(
                    point: apiLocation,
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
              ],
            ),
          ],
        ).animate().fade(duration: 800.ms).scale(begin: const Offset(1.1, 1.1)),
        DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.1,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 4,
                    margin: const EdgeInsets.only(top: 0, bottom: 18),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 1000.ms),
                  buildMenuContainer(),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: showDistance
                            ? buildDistanceContent()
                            : buildHealthContent(),
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .slideY(
                    begin: 1, end: 0, duration: 500.ms, curve: Curves.easeOut)
                .fade(duration: 400.ms);
          },
        ),
      ],
    );
  }

  Widget buildMenuContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.blind,
              color:
                  isHealthIconSelected ? const Color(0xFF5B9D99) : const Color(0xFFABDAD3),
              size: 35,
            ),
            onPressed: () {
              toggleContent(true);
              setState(() {
                isHealthIconSelected = true;
                isProfileIconSelected = false;
              });
            },
          )
              .animate(target: isHealthIconSelected ? 1 : 0)
              .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.2, 1.2))
              .shake(hz: 2),
          IconButton(
            icon: Icon(
              Icons.health_and_safety,
              color:
                  isProfileIconSelected ? const Color(0xFF5B9D99) : const Color(0xFFABDAD3),
              size: 30,
            ),
            onPressed: () {
              toggleContent(false);
              setState(() {
                isHealthIconSelected = false;
                isProfileIconSelected = true;
              });
            },
          )
              .animate(target: isProfileIconSelected ? 1 : 0)
              .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.2, 1.2))
              .shake(hz: 2),
        ],
      ),
    );
  }


Widget buildStatCard({
  required String title,
  required String imagePath,
  required String value,
  Color? backgroundColor,
}) {
  return Container(
    height: 230,
    width: 160,
    decoration: BoxDecoration(
      color: backgroundColor ?? const Color(0xFFABDAD3),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(4, 4),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: Colors.teal[900],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 8),
        Image.asset(
          imagePath,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ).animate().scale(delay: 400.ms).fade(),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE0B2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.teal[900],
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ).animate().slideX(begin: 0.2, end: 0, delay: 500.ms).fadeIn(),
      ],
    ),
  ).animate().scale(delay: 200.ms).fadeIn();
}

    Widget buildDistanceContent() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rekap Jarak",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2, end: 0),
          SizedBox(height: 10),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: ApiService.fetchRealtimeJarakTempuh(), // Mengambil data dari API
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No data available"),
                );
              } else {
                final data = snapshot.data!;
                final latestEntry = data.last; // Asumsi data diurutkan berdasarkan waktu

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildStatCard(
                      title: "Waktu Tempuh",
                      imagePath: 'assets/timer.png',
                      value: latestEntry['time_diff'] ?? "N/A",
                    ),
                    buildStatCard(
                      title: "Jarak Tempuh",
                      imagePath: 'assets/jarak.png',
                      value: "${latestEntry['total_distance_km'].toStringAsFixed(2)} km",
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 20),
          Text(
            "Grafik",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2, end: 0),
          SizedBox(height: 10),
          buildBarGraph(), // Menampilkan grafik batang
        ],
      );
    }




Widget buildBarGraph() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: ApiService.fetchRekap(), // Memanggil API
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator()); // Menunggu data
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No data available"));
      } else {
        final data = snapshot.data!;
        return Container(
          height: 350,
          margin: const EdgeInsets.only(bottom: 20, top: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20), // Padding lebih besar untuk ruang lebih
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15), // Lebih melengkung
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Memberikan jarak antar bar
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((entry) {
              final tanggal = entry['tanggal'];
              final timeDiff = entry['time_diff'];
              final totalDistance = entry['total_distance_km'];

              return _buildAnimatedBar(
                label: tanggal,
                timeDiff: timeDiff,
                totalDistance: totalDistance,
                height: _getBarHeight(totalDistance), // Menggunakan fungsi pembatas tinggi bar
                color: _getBarColor(tanggal),
              );
            }).toList(),
          ),
        );
      }
    },
  );
}

Widget _buildAnimatedBar({
  required double height,
  required Color color,
  required String label,
  required String timeDiff,
  required double totalDistance,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 40, // Ukuran lebar yang lebih besar untuk bar
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8), // Border lebih melengkung
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 3),
              blurRadius: 8,
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10), // Jarak antar bar lebih besar
      ).animate().slideY(begin: 1, end: 0, duration: 600.ms, curve: Curves.easeInOut),
      const SizedBox(height: 12), // Jarak yang lebih besar untuk teks
      Text(
        label,
        style: const TextStyle(
          fontSize: 14, 
          fontWeight: FontWeight.w600, // Lebih tebal dan mudah dibaca
          color: Colors.black87, // Warna teks yang lebih gelap
        ),
      ),
      Text(
        "$timeDiff - ${totalDistance.toStringAsFixed(2)} km",
        style: const TextStyle(
          fontSize: 12, 
          color: Colors.black45, // Warna lebih lembut
        ),
      ),
    ],
  );
}

Color _getBarColor(String tanggal) {
  // Tentukan warna untuk grafik berdasarkan tanggal atau kriteria lain
  if (tanggal == "2025-01-06") {
    return const Color(0xFF64B5F6); // Warna lebih lembut untuk tanggal 6 Januari
  } else {
    return const Color(0xFFFF80AB); // Warna yang lebih cerah untuk tanggal lainnya
  }
}

// Fungsi untuk membatasi tinggi bar maksimal
double _getBarHeight(double totalDistance) {
  const maxHeight = 200.0; // Maksimal tinggi bar
  final calculatedHeight = totalDistance * 3; // Kalkulasi tinggi berdasarkan total distance

  // Kembalikan nilai terkecil antara kalkulasi dan maxHeight
  return calculatedHeight > maxHeight ? maxHeight : calculatedHeight;
}




    Widget buildHealthContent() {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
      child: FutureBuilder<List<Map<String, dynamic>>>( 
        future: ApiService.fetchRealtimeCollections(), // Fetch data from API
        builder: (context, snapshot) {
          String batteryValue = "";

          if (snapshot.connectionState == ConnectionState.waiting) {
            batteryValue = "Loading...";
          } else if (snapshot.hasError) {
            batteryValue = "Error: ${snapshot.error}";
          } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
            final batteryPercentage = snapshot.data![0]['battery_percentage'];

            // Check if the value is a double and format it
            if (batteryPercentage is double) {
              batteryValue = "${batteryPercentage.toStringAsFixed(0)}%"; // Format to integer string
            } else if (batteryPercentage is int) {
              batteryValue = "$batteryPercentage%"; // In case it is still an int
            } else {
              batteryValue = "Invalid battery percentage data"; // Invalid data handling
            }
          } else {
            batteryValue = "No data available"; // Handle case where no data is available
          }

          return buildHealthCard(
            title: "Baterai",
            imagePath: 'assets/baterai.png',
            value: batteryValue,
            delay: 0,
          );
        },
      ),
    ),

          const SizedBox(width: 20),
          Expanded(
            child: buildHealthCard(
              title: "Instruksi Pulang",
              imagePath: 'assets/back.png',
              value: "Kirim", // Nilai tetap untuk instruksi pulang
              isButton: true,
              delay: 200,
              onPressed: () async {
                await ApiService.sendAlert(); // Panggil fungsi sendAlert saat tombol ditekan
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Instruksi pulang terkirim!')),
                );
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 25),
      Text(
        "Note: ketika menekan tombol kirim pada bagian Instruksi Pulang nanti ke tongkat akan muncul suara yang menginstruksikan pengguna untuk pulang ke rumah.",
        style: TextStyle(
          color: Colors.teal[900],
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.justify,
      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
    ],
  );
}


Widget buildHealthCard({
  required String title,
  required String imagePath,
  required String value,
  bool isButton = false,
  required int delay,
  VoidCallback? onPressed, // Menambahkan parameter onPressed
}) {
  return Container(
    height: 240,
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: const Color(0xFFABDAD3),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(-4, -4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(6, 6),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Title with animation
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal[900],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: -0.2, end: 0),
        
        const SizedBox(height: 8),
        
        // Image with animation
        Image.asset(
          imagePath,
          width: isButton ? 120 : 110,
          height: isButton ? 120 : 110,
          fit: BoxFit.cover,
        ).animate().scale(
              delay: Duration(milliseconds: delay + 200),
              duration: 400.ms,
            ).fade(),
        
        SizedBox(height: isButton ? 8 : 15),
        
        // If not a button, show the value container
        if (!isButton)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0B2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
              ),
            ),
          )
              .animate()
              .fadeIn(delay: Duration(milliseconds: delay + 400))
              .slideX(begin: 0.2, end: 0)
        
        // If it's a button, show the button with onPressed
        else
          GestureDetector(
            onTap: onPressed, // Calls the onPressed function when tapped
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B2),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Kirim",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[900],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.send,
                    color: Colors.teal[900],
                    size: 16,
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .shimmer(duration: 1200.ms)
                      .shake(hz: 2, curve: Curves.easeInOut),
                ],
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .shimmer(duration: 2000.ms)
                .animate()
                .fadeIn(delay: Duration(milliseconds: delay + 400))
                .slideX(begin: 0.2, end: 0),
          ),
      ],
    ),
  )
      .animate()
      .scale(
        delay: Duration(milliseconds: delay),
        duration: 400.ms,
        curve: Curves.easeOut,
      )
      .fadeIn();
}
}