import 'dart:io';

/// Definisi Record Tugas dengan properti id, judul, selesai, dan prioritas (Tantangan 2)
typedef Tugas = ({
  int id,
  String judul,
  bool selesai,
  String prioritas, // 'Tinggi', 'Sedang', 'Rendah'
});

extension Kapital on String {
  String get kapital =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

final List<Tugas> daftar = [];
int _idBerikut = 1;

void main() {
  print('=== TODO CLI (PRAKTIKUM B) ===');
  var jalan = true;
  while (jalan) {
    tampilkanMenu();
    final pilihan = baca('Pilih menu');
    try {
      switch (pilihan) {
        case '1':
          final judul = baca('Judul tugas');
          print(
            'Prioritas: [1] Tinggi  [2] Sedang  [3] Rendah (default: Sedang)',
          );
          final pChoice = baca('Pilih prioritas (1/2/3)');
          final prioritas = switch (pChoice) {
            '1' => 'Tinggi',
            '3' => 'Rendah',
            _ => 'Sedang',
          };
          tambah(judul, prioritas: prioritas);
        case '2':
          tampilkan(daftar);
        case '3':
          tandaiSelesai(bacaAngka('ID tugas'));
        case '4':
          hapus(bacaAngka('ID tugas'));
        case '5':
          tampilkan(cari(baca('Kata kunci')), judul: 'Hasil pencarian');
        case '6':
          tampilkan(
            daftar.where((t) => !t.selesai).toList(),
            judul: 'Belum selesai',
          );
        case '7':
          // Tantangan 1: Ubah judul yang memakai _indeksDari dan menolak judul kosong
          final id = bacaAngka('ID tugas yang ingin diubah');
          final judulBaru = baca('Judul baru');
          ubahJudul(id, judulBaru);
        case '0':
          jalan = false;
        default:
          print('Menu tidak dikenal.');
      }
    } on FormatException catch (e) {
      print('Peringatan: ${e.message}');
    }
  }
  print('Sampai jumpa!');
}

void tampilkanMenu() {
  print('''
[1] Tambah       [2] Lihat semua    [3] Tandai selesai
[4] Hapus        [5] Cari           [6] Belum selesai
[7] Ubah judul   [0] Keluar''');
}

String baca(String label) {
  stdout.write('$label: ');
  return (stdin.readLineSync() ?? '').trim();
}

int bacaAngka(String label) {
  final teks = baca(label);
  final angka = int.tryParse(teks);
  if (angka == null) throw FormatException('"$teks" bukan angka.');
  return angka;
}

void tambah(String judul, {String prioritas = 'Sedang'}) {
  if (judul.isEmpty) throw FormatException('Judul tidak boleh kosong.');
  daftar.add((
    id: _idBerikut++,
    judul: judul.kapital,
    selesai: false,
    prioritas: prioritas,
  ));
  print('Tugas ditambahkan dengan prioritas $prioritas.');
}

/// Tantangan 3: Fungsi ringkasan() yang mengembalikan record
({int total, int selesai, double persen}) ringkasan() {
  final total = daftar.length;
  final selesai = daftar.where((t) => t.selesai).length;
  final persen = total == 0 ? 0.0 : (selesai / total) * 100;
  return (total: total, selesai: selesai, persen: persen);
}

/// Bobot prioritas untuk pembanding sorting (Tinggi > Sedang > Rendah)
int _bobotPrioritas(String p) => switch (p) {
  'Tinggi' => 3,
  'Sedang' => 2,
  'Rendah' => 1,
  _ => 0,
};

void tampilkan(List<Tugas> data, {String judul = 'Daftar tugas'}) {
  print('--- $judul (${data.length}) ---');
  if (data.isEmpty) {
    print('(kosong)');
    return;
  }

  // Tantangan 2: Urutkan tampilan dengan sort dan fungsi pembanding
  final sortedData = List<Tugas>.from(data);
  sortedData.sort((a, b) {
    // Utamakan prioritas lebih tinggi terlebih dahulu
    final pCmp = _bobotPrioritas(b.prioritas)
        .compareTo(_bobotPrioritas(a.prioritas));
    if (pCmp != 0) return pCmp;
    return a.id.compareTo(b.id);
  });

  for (final t in sortedData) {
    final tanda = t.selesai ? '[x]' : '[ ]';
    final prio = '[${t.prioritas}]'.padRight(9);
    print('${t.id.toString().padLeft(3)} $tanda $prio ${t.judul}');
  }

  // Tampilkan ringkasan di menu [2] Lihat semua
  if (judul == 'Daftar tugas') {
    final r = ringkasan();
    print(
      'Ringkasan: ${r.selesai}/${r.total} tugas selesai (${r.persen.toStringAsFixed(1)}%)',
    );
  }
}

int _indeksDari(int id) {
  final i = daftar.indexWhere((t) => t.id == id);
  if (i == -1) throw FormatException('Tugas dengan ID $id tidak ditemukan.');
  return i;
}

void tandaiSelesai(int id) {
  final i = _indeksDari(id);
  final t = daftar[i];
  daftar[i] = (id: t.id, judul: t.judul, selesai: true, prioritas: t.prioritas);
  print('"${t.judul}" ditandai selesai.');
}

/// Tantangan 1: Mengubah judul tugas dengan validasi judul tidak kosong
void ubahJudul(int id, String judulBaru) {
  if (judulBaru.isEmpty) throw FormatException('Judul tidak boleh kosong.');
  final i = _indeksDari(id);
  final t = daftar[i];
  daftar[i] = (
    id: t.id,
    judul: judulBaru.kapital,
    selesai: t.selesai,
    prioritas: t.prioritas,
  );
  print('Judul tugas #${t.id} berhasil diubah menjadi "${daftar[i].judul}".');
}

void hapus(int id) {
  final t = daftar.removeAt(_indeksDari(id));
  print('"${t.judul}" dihapus.');
}

List<Tugas> cari(String kata) {
  final kunci = kata.toLowerCase();
  return daftar.where((t) => t.judul.toLowerCase().contains(kunci)).toList();
}
