import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/widgets/WGlobal.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WGlobal_AppBar_Stacked(context, "Kebijakan Privasi",
          fontSize: 16, isTransparent: true, leadButtonOnPressed: (() {
        Navigator.pop(context);
      })),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: RichText(
                    text: TextSpan(
                      text: 'PT AGRI GAIN NUSANTARA',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: c.blackColor),
                      children: const <TextSpan>[
                        TextSpan(
                            text: ' ("Panenin" atau "Kami")',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                ' menyusun Kebijakan Privasi ini untuk menjelaskan cara pengumpulan, penggunaan dan pengungkapan informasi dari pengguna aplikasi perangkat lunak Kami (“Aplikasi”),',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                ' situs web Kami dan layanan Kami lainnya (secara bersama-sama disebut sebagai “Layanan”).',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                'Dengan menggunakan Layanan Kami, Anda menyetujui pengumpulan, pengungkapan dan penggunaan lainnya atas informasi Anda yang dijelaskan di bawah ini. Di Panenin, Kami terus melakukan pengembangan dan Kebijakan Privasi Kami dapat diperbarui dari waktu ke waktu. Kami tidak akan melakukan perubahan penting terhadap Kebijakan Privasi tanpa memberikan pemberitahuan lebih dulu mengenai perubahan tersebut melalui Layanan Kami.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\n(Ketentuan sehubungan dengan cara pengumpulan, penggunaan dan pengungkapan informasi dari pengguna Layanan dalam Kebijakan Privasi ini wajib dibaca dan dipahami bersamaan, atau menjadi satu kesatuan dengan, Perjanjian Penggunaan Panenin (“Perjanjian Penggunaan”) yang ditandatangani bersamaan dengan pembuatan akun Panenin (“Akun”). Kecuali didefinisikan secara spesifik di dalam Kebijakan Privasi ini, istilah yang tidak didefinisikan dalam Kebijakan Privasi ini akan mengacu pada istilah yang diatur dalam Perjanjian Penggunaan.)',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text: '\n\nInformasi yang Panenin Kumpulkan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            )),
                        TextSpan(
                            text:
                                '\n\nInformasi Pendaftaran. Saat Anda membuat Akun, Kami meminta Anda untuk memberikan informasi pribadi, seperti nama dan nomor telepon dan pada tahap selanjutnya nama pengguna serta kata sandi. Kami juga dapat meminta Anda untuk melakukan personalisasi pengalaman pengguna Anda dengan informasi lain seperti lokasi dan preferensi Anda. Informasi ini secara bersama-sama disebut sebagai “Informasi Pendaftaran”.)',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nInformasi Penggunaan. Kami juga mengumpulkan informasi mengenai cara Anda menggunakan Layanan Kami, termasuk cara Anda melihat dan berinteraksi dengan konten, bagian Layanan Kami yang Anda gunakan, informasi yang Anda cari, konten yang Anda lihat dan tindakan yang Anda lakukan.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nID Pengguna dan ID Perangkat. Saat pemasangan Aplikasi dilakukan, Kami membuat nomor identifikasi khusus yang berkaitan dengan pemasangan perangkat lunak tersebut (“ID Pengguna”).',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nData Log. Saat Anda menggunakan Layanan Kami, secara otomatis Kami merekam informasi mengenai penggunaan Anda (“Data Log”). Data Log ini dapat memuat informasi seperti alamat Protokol Internet (IP) komputer atau perangkat bergerak Anda, jenis browser, halaman web yang Anda kunjungi sebelum masuk ke Situs Kami, halaman Situs Kami yang Anda kunjungi, waktu dan tanggal akses dan statistik lainnya.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nSurvei dan Promosi. Dari waktu ke waktu, Kami dapat memberikan Anda kesempatan untuk berpartisipasi dalam survei, kontes atau undian melalui Layanan Kami. Jika Anda berpartisipasi, Kami dapat meminta informasi tambahan tertentu dari Anda.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nCara Panenin Menggunakan Informasi yang Panenin Kumpulkan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            )),
                        TextSpan(
                            text:
                                '\n\nInformasi yang Anda Bagikan. Penggunaan Panenin dirancang untuk tujuan pribadi. Seluruh data yang Anda ungkapkan tidak akan dibagikan dengan orang lain. ',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nDengan Persetujuan Anda. Kami dapat mengungkapkan informasi apa pun yang Kami kumpulkan kepada pihak ketiga jika Kami telah mendapat persetujuan Anda.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nInformasi Bukan Rahasia atau Bukan Pribadi. Kami dapat mengungkapkan informasi gabungan dan informasi yang tidak dapat digunakan untuk identifikasi pribadi yang Kami kumpulkan. Pengungkapan tersebut tidak akan mencakup informasi pribadi non-publik mengenai pengguna perorangan.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nPenyedia Layanan. Kami mempekerjakan pihak ketiga untuk membantu Kami dalam penyediaan dan peningkatan Layanan (sebagai contoh, tanpa batasan, perusahaan pemeliharaan, manajemen basis data dan analisis web). Jika pihak-pihak ketiga tersebut menerima informasi personal non-publik mengenai Anda, mereka berkewajiban untuk tidak mengungkapkan atau menggunakan informasi tersebut untuk tujuan apa pun selain menjalankan tugas untuk kepentingan Kami.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nKepatuhan terhadap Hukum dan Penegakan Hukum. Panenin bekerja sama dengan pemerintah dan aparat penegak hukum serta pihak swasta untuk menegakkan dan mematuhi hukum. Kami akan mengungkapkan informasi apapun mengenai Anda kepada pemerintah atau aparat penegak hukum atau pihak swasta sebagaimana Kami, atas penilaian Kami sendiri, anggap perlu atau tepat untuk menanggapi klaim dan proses hukum (termasuk tetapi tidak terbatas pada panggilan pengadilan), untuk melindungi hak milik dan hak Panenin atau suatu pihak ketiga, untuk melindungi keamanan publik atau orang mana pun atau untuk mencegah atau membatasi apa pun yang Kami anggap sebagai, atau berisiko untuk menjadi, kegiatan melanggar hukum, tidak etis atau yang dapat ditindaklanjuti secara hukum.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nPengalihan Usaha. Panenin dapat menjual, mengalihkan atau dengan cara apa pun membagikan beberapa atau seluruh asetnya, termasuk informasi yang diidentifikasi dalam Kebijakan Privasi ini, sehubungan dengan suatu merger, akuisisi, reorganisasi atau penjualan aset atau dalam hal terjadi kebangkrutan.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text: '\n\nTeknologi dan Cookies',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            )),
                        TextSpan(
                            text:
                                '\n\nLayanan Kami mungkin menggunakan “cookies” untuk mengumpulkan informasi. Sebuah cookies adalah suatu berkas data kecil yang Kami pindahkan ke cakram keras (hard disk) komputer Anda untuk tujuan pencatatan. Kami mungkin menggunakan “persistent cookies” untuk menyimpan nama pengguna dan kata sandi masuk Anda untuk masuk ke Layanan di masa mendatang. Kami juga mungkin menggunakan “session ID cookies” untuk mengaktifkan fitur Layanan tertentu atau untuk membantu Kami memahami bagaimana Anda berinteraksi dengan Layanan. Anda dapat memerintahkan browser web Anda agar berhenti menerima cookies atau memperingatkan Anda sebelum menerima cookies tertentu atau secara keseluruhan. Akan tetapi, jika Anda tidak menerima cookies, Anda mungkin tidak dapat menggunakan aspek-aspek Layanan tertentu. Cookies yang ditempatkan pada perangkat atau komputer Anda oleh Panenin atau situs pihak ketiga atau layanan mana pun yang dapat Anda akses melalui Layanan mungkin tetap tersimpan pada perangkat atau komputer Anda sampai Anda menghapusnya.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nSelain itu, Kami bekerja sama dengan perusahaan pihak ketiga yang menggunakan cookies dan teknologi pelacak lain untuk mengumpulkan informasi yang tidak dapat digunakan untuk identifikasi mengenai aktivitas Anda di Situs dan Layanan Kami untuk membantu Kami memahami penggunaan serta pengoperasian Layanan Kami. Pihak-pihak ketiga ini dapat mengumpulkan dan menganalisis informasi tentang aktivitas daring Anda dari waktu ke waktu dan di berbagai situs web ketika Anda menggunakan Layanan Kami. Kami tidak memiliki kendali atas situs web maupun layanan pihak-pihak ketiga ini. Kami menyarankan Anda untuk membaca kebijakan privasi atau pernyataan yang tertera di situs web dan layanan lain yang Anda gunakan. Dengan menerima Kebijakan Privasi ini, dan dengan menggunakan Layanan Panenin, Anda menyetujui penggunaan cookies oleh Panenin dan perusahaan-perusahaan pihak ketiga yang bekerja dengan Panenin.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nBeberapa browser menggunakan fitur “Do Not Track” (DNT) yang, saat diaktifkan, memberi sinyal kepada situs web bahwa Anda tidak ingin dilacak. Karena belum ada standar yang secara umum diterima untuk menanggapi sinyal DNT browser, Kami saat ini tidak menanggapi sinyal tersebut.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text: '\n\nMengubah atau Menghapus Akun Anda',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            )),
                        TextSpan(
                            text:
                                '\n\nAnda dapat meminta Kami menghapus Akun Anda melalui email yang dikirim ke halo@panenin.id. Akun akan segera dihentikan dan, jika tidak ada hambatan, Kami akan menerima permintaan Anda dan menghapus informasi Akun Anda dalam waktu kurang dari 30 hari. Kami dapat menyimpan salinan arsip atas catatan Anda sebagaimana diwajibkan oleh hukum atau sebagaimana diperlukan untuk melindungi hak Panenin atau penggunanya. Anda dapat meminta instruksi cara mengubah preferensi pribadi Anda, mengakses informasi Anda dan memperbarui informasi Anda atau melayangkan pertanyaan apa pun sehubungan dengan kerahasiaan atau perlindungan data ke halo@panenin.id',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text:
                                '\n\nInformasi Anak-Anak dan Pengguna di Bawah Umur',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            )),
                        TextSpan(
                            text:
                                '\n\nKami tidak menyediakan layanan apa pun kepada setiap orang yang berusia di bawah 18 tahun. Orang tua atau wali yang mendapati bahwa anaknya memberikan informasi pribadi yang dapat digunakan untuk identifikasi kepada Kami tanpa persetujuan mereka dapat menghubungi Kami di halo@panenin.id. Jika Kami mengetahui bahwa siapapun yang berusia di bawah 18 tahun memberikan informasi pribadi yang dapat digunakan untuk identifikasi kepada Kami, Kami akan menghapus informasi beserta Akun tersebut.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text: '\n\nKeamanan Informasi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            )),
                        TextSpan(
                            text:
                                '\n\nPanenin menggunakan langkah keamanan fisik, teknologi dan administratif yang wajar untuk melindungi informasi yang dikumpulkan. Akan tetapi, tidak ada metode transmisi melalui internet, atau metode penyimpanan elektronik yang 100% aman. Oleh karena itu, walaupun Kami menggunakan cara yang secara komersial dapat diterima untuk melindungi informasi yang Kami kumpulkan, Kami tidak dapat menjamin keamanan mutlaknya. Jika Panenin mendapati adanya pelanggaran keamanan yang mengakibatkan pengungkapan yang tidak sah atas Informasi Pendaftaran Anda, Kami akan mencoba memberitahu Anda secara elektronik melalui Layanan agar Anda dapat melakukan langkah-langkah perlindungan yang sesuai. Panenin juga dapat mengirim email kepada Anda di alamat email yang Anda berikan kepada Kami mengenai pemberitahuan yang dimaksud dalam paragraf ini.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text: '\n\nPengelabuan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            )),
                        TextSpan(
                            text:
                                '\n\nPanenin sangat peduli kepada pencurian identitas dan praktik yang sekarang ini dikenal sebagai “pengelabuan (phising)”. Menjaga keamanan informasi untuk membantu melindungi Anda dari pencurian identitas adalah prioritas utama Kami. Kami tidak dan tidak akan, pada waktu kapan pun, meminta informasi kartu kredit, kata sandi masuk ataupun nomor KTP Anda melalui email atau komunikasi telepon yang tidak aman atau tidak resmi.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                        TextSpan(
                            text: '\n\nTautan ke Situs Lain',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            )),
                        TextSpan(
                            text:
                                '\n\nLayanan Kami mengandung tautan ke situs web dan layanan daring lainnya. Jika Anda memilih untuk mengunjungi suatu layanan atau pengiklan pihak ketiga dengan “mengeklik” tautan pihak ketiga, Anda akan diarahkan ke situs web atau layanan daring pihak ketiga tersebut. Tautan yang Kami sediakan ke situs web, konten atau penampilan spanduk iklan atau jenis iklan lainnya bukan merupakan suatu bentuk dukungan, otorisasi atau perwakilan dari afiliasi Kami dengan pihak ketiga tersebut, maupun sebuah dukungan atas kebijakan atau praktik keamanan privasi atau informasi mereka. Situs web dan layanan lainnya mengikuti peraturan berbeda mengenai penggunaan atau pengungkapan informasi pribadi yang Anda berikan kepada mereka. Kami menyarankan agar Anda membaca kebijakan privasi atau pernyataan situs web dan layanan lain yang Anda gunakan. Kami tidak memiliki kendali apa pun atas situs web atau layanan pihak ketiga.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                      ],
                    ),
                  )),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
