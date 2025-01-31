import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  // Data FAQ tetap sama
  final List<Map<String, dynamic>> faqData = [
    {
      'category': 'Tentang Smart Cane',
      'questions': [
        {
          'question': 'Apa itu Smart Cane?',
          'answer':
              'Smart Cane adalah tongkat tunanetra berbasis IoT yang dilengkapi dengan sensor untuk mendeteksi rintangan dan sistem pelacakan GPS, memungkinkan pengguna untuk bergerak dengan lebih aman dan mandiri.',
          'isOpen': false,
        },
        {
          'question': 'Apa fungsi utama dari aplikasi Smart Cane?',
          'answer':
              'Aplikasi Smart Cane adalah pendamping untuk tongkat pintar yang membantu penyandang tunanetra mendeteksi rintangan, melacak lokasi, dan menyediakan tombol darurat serta peringatan baterai.',
          'isOpen': false,
        },
        {
          'question': 'Siapa yang dapat menggunakan aplikasi ini?',
          'answer':
              'Aplikasi Smart Cane dirancang untuk pengguna tunanetra, serta keluarga atau teman yang ingin membantu dan memantau keselamatan mereka.',
          'isOpen': false,
        },
        {
          'question':
              'Apakah ada video demo tentang cara menggunakan aplikasi?',
          'answer':
              'Ya, Anda dapat menemukan video demo cara menggunakan aplikasi melalui link yang tersedia di bagian cara penggunaan aplikasi.',
          'isOpen': false,
        },
        {
          'question': 'Apakah aplikasi Smart Cane tersedia dalam bahasa lain?',
          'answer':
              'Saat ini, aplikasi Smart Cane mungkin hanya tersedia dalam satu bahasa, tetapi rencana untuk mendukung lebih banyak bahasa di masa depan sedang dipertimbangkan.',
          'isOpen': false,
        },
      ]
    },
    {
      'category': 'Fitur dan Fungsi',
      'questions': [
        {
          'question': 'Bagaimana cara kerja fitur deteksi rintangan?',
          'answer':
              'Fitur deteksi rintangan bekerja dengan sensor ultrasonik yang dapat mendeteksi objek dalam jarak 75 cm di depan, samping kanan, dan kiri tongkat.',
          'isOpen': false,
        },
        {
          'question': 'Apakah aplikasi ini dapat melacak lokasi pengguna?',
          'answer':
              'Ya, Smart Cane dilengkapi dengan modul GPS yang memungkinkan keluarga atau pihak terkait untuk melacak lokasi pengguna tongkat secara real-time melalui aplikasi.',
          'isOpen': false,
        },
        {
          'question':
              'Apa yang harus dilakukan jika pengguna mengalami keadaan darurat seperti tersesat?',
          'answer':
              'Pengguna dapat menekan tombol darurat pada tongkat. Saat tombol ini ditekan, aplikasi akan memberikan notifikasi kepada keluarga dengan lokasi pengguna, sehingga bantuan dapat segera diberikan.',
          'isOpen': false,
        },
        {
          'question':
              'Apakah aplikasi Smart Cane memiliki fitur untuk melacak tongkat yang tertinggal atau jatuh?',
          'answer':
              'Ya, Smart Cane memiliki fitur pelacak tambahan berupa kalung (dalam pengembangan) yang bisa digunakan untuk melacak tongkat jika tertinggal atau terjatuh. Pengguna dapat menekan tombol pada kalung, dan tongkat akan mengeluarkan suara khusus untuk membantu menemukan tongkat.',
          'isOpen': false,
        },
        {
          'question': 'Bagaimana jika baterai tongkat hampir habis?',
          'answer':
              'Jika baterai hampir habis, aplikasi akan menampilkan peringatan dan memberikan notifikasi suara kepada pengguna. Tongkat juga akan mengeluarkan suara khusus sebagai tanda untuk segera mengisi ulang daya.',
          'isOpen': false,
        },
        {
          'question': 'Apa fungsi dari fitur Instruksi Pulang di aplikasi?',
          'answer':
              'Fitur ini memungkinkan keluarga atau pihak terkait untuk mengirimkan perintah suara “instruksi pulang” ke tongkat. Saat diaktifkan, pengguna akan mendengar suara instruksi untuk pulang, dan notifikasi akan muncul di aplikasi sebagai konfirmasi.',
          'isOpen': false,
        },
        {
          'question':
              'Apakah ada notifikasi untuk tombol darurat dan instruksi pulang?',
          'answer':
              'Ya, aplikasi akan menampilkan notifikasi untuk setiap tombol yang ditekan, baik tombol darurat maupun tombol instruksi pulang.',
          'isOpen': false,
        },
      ]
    },
    {
      'category': 'Penggunaan dan Aksesibilitas',
      'questions': [
        {
          'question': 'Apakah aplikasi ini membutuhkan koneksi internet?',
          'answer':
              'Ya, aplikasi memerlukan koneksi internet untuk mengirim dan menerima data dari modul GPS dan agar fitur notifikasi real-time berfungsi dengan baik.',
          'isOpen': false,
        },
        {
          'question':
              'Apakah saya perlu mendaftar atau login untuk menggunakan aplikasi?',
          'answer':
              'Tidak, pengguna tidak perlu melakukan pendaftaran atau login untuk menggunakan aplikasi. Hanya lokasi pengguna yang disimpan.',
          'isOpen': false,
        },
        {
          'question': 'Apakah aplikasi ini tersedia untuk perangkat lain?',
          'answer':
              'Saat ini, aplikasi Smart Cane dirancang untuk perangkat mobile, namun kami sedang mempertimbangkan pengembangan untuk platform lain di masa mendatang.',
          'isOpen': false,
        },
        {
          'question': 'Apakah ada batasan jarak untuk pelacakan lokasi?',
          'answer':
              'Modul GPS dapat melacak lokasi pengguna secara real-time selama perangkat dalam jangkauan sinyal GPS. Namun, beberapa area tertutup atau gedung dengan sinyal buruk mungkin mempengaruhi akurasi pelacakan.',
          'isOpen': false,
        },
      ]
    },
    {
      'category': 'Keamanan dan Privasi',
      'questions': [
        {
          'question': 'Apakah data lokasi pengguna disimpan dengan aman?',
          'answer':
              'Ya, data lokasi pengguna hanya dapat diakses oleh pihak-pihak yang terdaftar di aplikasi dan dirancang untuk menjaga keamanan serta privasi pengguna. Keluarga atau pihak yang diizinkan saja yang dapat mengakses data ini.',
          'isOpen': false,
        },
        {
          'question': 'Apakah data pengguna disimpan?',
          'answer':
              'Data yang disimpan adalah lokasi pengguna, dan data ini disimpan secara permanen meskipun tongkat dimatikan. Riwayat lokasi dapat diakses melalui aplikasi.',
          'isOpen': false,
        },
      ]
    },
    {
      'category': 'Masalah Teknis dan Dukungan',
      'questions': [
        {
          'question':
              'Apa yang harus saya lakukan jika mengalami masalah teknis dengan aplikasi?',
          'answer':
              'Jika Anda mengalami masalah teknis, silakan hubungi tim pengembang melalui informasi kontak yang tersedia dalam aplikasi untuk mendapatkan bantuan.',
          'isOpen': false,
        },
        {
          'question':
              'Di mana saya bisa mendapatkan informasi lebih lanjut tentang aplikasi?',
          'answer':
              'Anda dapat mengunjungi halaman "Tentang Aplikasi" dalam aplikasi untuk mendapatkan informasi lebih lanjut mengenai fitur, developer, dan kebijakan privasi.',
          'isOpen': false,
        },
        {
          'question': 'Apa yang terjadi jika tongkat mati?',
          'answer':
              'Jika tongkat mati, aplikasi tidak dapat melacak lokasi pengguna karena modul GPS tidak aktif. Pastikan untuk selalu mengisi daya tongkat agar tetap berfungsi dengan baik.',
          'isOpen': false,
        },
        {
          'question':
              'Apakah ada cara untuk mengetahui lokasi terakhir tongkat jika mati?',
          'answer':
              'Jika tongkat mati, aplikasi akan menampilkan lokasi terakhir yang terdeteksi sebelum tongkat dimatikan. Pastikan untuk memeriksa lokasi tersebut agar Anda tetap mengetahui posisi pengguna sebelum tongkat kehabisan daya.',
          'isOpen': false,
        },
      ]
    },
  ];

  late List<bool> isCategoryOpen;

  @override
  void initState() {
    super.initState();
    isCategoryOpen = List<bool>.generate(faqData.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('FAQ', style: TextStyle(color: Colors.black))
            .animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.2, end: 0),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: faqData.length,
          itemBuilder: (context, categoryIndex) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCategoryOpen[categoryIndex] =
                            !isCategoryOpen[categoryIndex];
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            faqData[categoryIndex]['category'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          duration: const Duration(milliseconds: 300),
                          turns: isCategoryOpen[categoryIndex] ? 0.25 : 0,
                          child: const Icon(Icons.arrow_right),
                        ),
                      ],
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Column(
                      children: [
                        const SizedBox(height: 10),
                        ...List.generate(
                          faqData[categoryIndex]['questions'].length,
                          (qIndex) {
                            final item =
                                faqData[categoryIndex]['questions'][qIndex];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  item['isOpen'] = !(item['isOpen'] ?? false);
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        AnimatedRotation(
                                          duration: const Duration(milliseconds: 300),
                                          turns:
                                              item['isOpen'] == true ? 0.25 : 0,
                                          child: const Icon(
                                            Icons.arrow_right,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item['question'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ClipRect(
                                      child: AnimatedSlide(
                                        duration: const Duration(milliseconds: 300),
                                        offset: item['isOpen'] == true
                                            ? Offset.zero
                                            : const Offset(0, -0.5),
                                        child: AnimatedOpacity(
                                          duration: const Duration(milliseconds: 300),
                                          opacity:
                                              item['isOpen'] == true ? 1 : 0,
                                          child: item['isOpen'] == true
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 24.0, top: 4.0),
                                                  child: Text(
                                                    item['answer'],
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style:
                                                        const TextStyle(fontSize: 14),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(
                                  duration: 400.ms,
                                  delay: Duration(milliseconds: 100 * qIndex),
                                )
                                .slideX(begin: 0.2, end: 0);
                          },
                        ),
                      ],
                    ),
                    crossFadeState: isCategoryOpen[categoryIndex]
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            )
                .animate(
                  delay: Duration(milliseconds: 100 * categoryIndex),
                )
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.2, end: 0);
          },
        ),
      ),
    );
  }
}
