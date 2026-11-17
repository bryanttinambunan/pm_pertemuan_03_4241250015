/// Library Kalkulator IP Semester (Tugas Rutin 3)
/// Pemrograman Mobile - Pertemuan 3
library;

/// Representasi data mata kuliah menggunakan Dart 3 Record.
typedef MataKuliah = ({String nama, int sks, String nilaiHuruf});

/// Mengubah nilai huruf menjadi bobot angka menggunakan switch expression.
/// Melempar [FormatException] jika huruf nilai tidak dikenal.
double bobot(String huruf) {
  final h = huruf.trim().toUpperCase();
  return switch (h) {
    'A' => 4.0,
    'B' => 3.0,
    'C' => 2.0,
    'D' => 1.0,
    'E' => 0.0,
    _ => throw FormatException(
      'Nilai huruf harus berupa A, B, C, D, atau E, bukan "$huruf".',
    ),
  };
}

/// Memvalidasi input SKS. SKS harus berupa bilangan bulat antara 1 sampai 6.
/// Melempar [FormatException] jika input tidak valid.
int validasiSks(String input) {
  final teks = input.trim();
  final angka = int.tryParse(teks);
  if (angka == null || angka < 1 || angka > 6) {
    throw FormatException('SKS harus berupa angka 1-6, bukan "$input".');
  }
  return angka;
}

/// Memvalidasi nilai huruf (A, B, C, D, atau E).
/// Melempar [FormatException] jika input tidak valid.
String validasiNilaiHuruf(String input) {
  final huruf = input.trim().toUpperCase();
  const nilaiValid = {'A', 'B', 'C', 'D', 'E'};
  if (!nilaiValid.contains(huruf)) {
    throw FormatException(
      'Nilai harus berupa huruf A, B, C, D, atau E, bukan "$input".',
    );
  }
  return huruf;
}

/// Menghitung Indeks Prestasi (IP) menggunakan higher-order function [fold].
/// Rumus: (Σ SKS × Bobot) / (Σ SKS).
double hitungIp(List<MataKuliah> data) {
  if (data.isEmpty) return 0.0;
  final totalSks = data.fold<int>(0, (total, mk) => total + mk.sks);
  if (totalSks == 0) return 0.0;

  final totalBobotSks = data.fold<double>(
    0.0,
    (total, mk) => total + (mk.sks * bobot(mk.nilaiHuruf)),
  );

  return totalBobotSks / totalSks;
}

/// Menentukan predikat kelulusan berdasarkan nilai IP menggunakan switch expression.
String predikat(double ip) {
  return switch (ip) {
    >= 3.51 => 'Dengan Pujian',
    >= 2.76 => 'Memuaskan',
    >= 2.00 => 'Cukup',
    _ => 'Kurang',
  };
}

/// Closure: mengembalikan fungsi filter mata kuliah yang nilainya
/// di bawah batas bobot tertentu (misal default 2.0 untuk nilai D dan E).
bool Function(MataKuliah) buatFilterPerbaikan({double batasBobot = 2.0}) {
  return (MataKuliah mk) => bobot(mk.nilaiHuruf) < batasBobot;
}

/// Mencetak Kartu Hasil Studi (KHS) ke layar console.
/// Memiliki parameter bernama [urutkan] untuk mengurutkan KHS dari nilai tertinggi
/// menggunakan higher-order function [List.sort] dengan fungsi pembanding.
void cetakKhs(List<MataKuliah> data, {bool urutkan = true}) {
  if (data.isEmpty) {
    print('\nBelum ada data mata kuliah yang dimasukkan.');
    return;
  }

  final salinan = List<MataKuliah>.from(data);
  if (urutkan) {
    // Pengurutan nilai tertinggi ke terendah menggunakan fungsi pembanding
    salinan.sort((a, b) {
      final cmp = bobot(b.nilaiHuruf).compareTo(bobot(a.nilaiHuruf));
      if (cmp != 0) return cmp;
      return a.nama.toLowerCase().compareTo(b.nama.toLowerCase());
    });
  }

  print('\nMata Kuliah                 SKS  Nilai');
  print('--------------------------------------');
  for (final mk in salinan) {
    final namaCol = mk.nama.padRight(28);
    final sksCol = mk.sks.toString().padRight(5);
    print('$namaCol$sksCol${mk.nilaiHuruf}');
  }
  print('--------------------------------------');

  final totalSks = salinan.fold<int>(0, (sum, mk) => sum + mk.sks);
  final ip = hitungIp(salinan);

  print('Total SKS : $totalSks');
  print('IP        : ${ip.toStringAsFixed(2)} (${predikat(ip)})');

  // Menggunakan higher-order function where dengan closure filter
  final filterRemedial = buatFilterPerbaikan(batasBobot: 2.0);
  final perluDiperbaiki = salinan.where(filterRemedial).toList();

  if (perluDiperbaiki.isNotEmpty) {
    final daftarNama = perluDiperbaiki.map((mk) => mk.nama).join(', ');
    print('Perlu diperbaiki: $daftarNama');
  } else {
    print('Perlu diperbaiki: Tidak ada (Semua mata kuliah tuntas)');
  }
}
