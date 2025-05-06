import 'package:get/get.dart';

class TutorialController extends GetxController {
  final RxList<TutorialVideo> tutorialVideos = <TutorialVideo>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTutorials();
  }

  void loadTutorials() {
    // Simulasi data tutorial
    // Dalam aplikasi produksi, ini bisa berasal dari API atau Firebase
    Future.delayed(const Duration(seconds: 1), () {
      tutorialVideos.addAll([
        TutorialVideo(
          id: '_S2iZL29rzs',
          title:
              'EduBilliard | CARA AGAR TUMPUAN TANGAN LU STABIL + WELCOME TO BILLIARD SPORTS MEDIA',
          description:
              'Selamat datang di channel BILLIARD SPORTS MEDIA, kenalin gw JEKA! Di channel ini kita bakal bahas seputar dunia billiard. Kupas tuntas sampai ke akar-akarnya pokoknya! Di video pertama ini gw bakal kasih tau salah satu basic pada olahraga billiard yang harus kalian tau sebagai pemula!  Kita juga bakalan kenalin diri ke kalian! Seperti apa videonya!? TONTON SAMPAI HABIS YA!! JANGAN LUPA KLIK TOMBOL LONCENG NOTIFIKASI KARENA KEDEPANNYA KITA AKAN ADAKAN GIVEAWAY! KLIK JUGA TOMBOL LIKE, COMMENT, SHARE SEBANYAK-BANYAKNYA, DAN SUBSCRIBE CHANNEL INI SUPAYA KITA BISA TERUS SEMANGAT BAWAIN KONTEN UNTUK KALIAN SEMUA!!!!',
          thumbnailUrl: 'https://img.youtube.com/vi/_S2iZL29rzs/0.jpg',
        ),
        TutorialVideo(
          id: 'r4V3yg9sxTk',
          title:
              'Pondasi awal latihan billiard pemula - profesional | Fundamental',
          description:
              'Pondasi awal latihan billiard pemula - profesional | Fundamental ',
          thumbnailUrl: 'https://img.youtube.com/vi/r4V3yg9sxTk/0.jpg',
        ),
        TutorialVideo(
          id: 'HdCXK1W4uH4',
          title:
              'KENAPA MISS BOLA LURUS YANG MUDAH ? | Tutorial Billiard Indonesia',
          description:
              'Lokasi : After Hour Bandung Instagram : afterhour_bandung Tempat Billiard berkonsepkan retro yang cozy dan nyaman Tunggu apa lagi, ayo kita main di After Hour !---------------------- INDO BILLIARD memiliki Official Store di Tokopedia. Kami menyediakan segala perlengkapan Billiard. Tokopedia : INDO BILLIARD https://www.tokopedia.com/indobilliard Untuk Ganti Grip, Ganti Master Tip, Balancing, Service Stik Billiard, dan Info lebih lanjut Hubungi : 0882-2059-2250',
          thumbnailUrl: 'https://img.youtube.com/vi/HdCXK1W4uH4/0.jpg',
        ),
        TutorialVideo(
          id: 'TyTgLN-eJys',
          title:
              'Cara mengayunkan stick biliar yang benar, cara ayun billiard untuk pemula',
          description:
              'Cara mengayunkan stick biliar yang benar, cara ayun billiard untuk pemula.',
          thumbnailUrl: 'https://img.youtube.com/vi/TyTgLN-eJys/0.jpg',
        ),
      ]);
      isLoading.value = false;
    });
  }
}

class TutorialVideo {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;

  TutorialVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
  });
}
