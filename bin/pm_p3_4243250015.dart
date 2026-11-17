import 'dart:io';

import 'package:pm_p3_4243250015/pm_p3_4243250015.dart';

void main() {
  print('=== KALKULATOR IP SEMESTER ===');
  print('Masukkan data mata kuliah. Kosongkan nama untuk selesai.\n');

  final List<MataKuliah> daftarMk = [];

  // Perulangan input menggunakan while dan berhenti ketika nama kosong
  while (true) {
    stdout.write('Nama MK : ');
    final nama = (stdin.readLineSync() ?? '').trim();
    if (nama.isEmpty) {
      break;
    }

    try {
      stdout.write('SKS     : ');
      final sksInput = stdin.readLineSync() ?? '';
      final sks = validasiSks(sksInput);

      stdout.write('Nilai   : ');
      final nilaiInput = stdin.readLineSync() ?? '';
      final nilai = validasiNilaiHuruf(nilaiInput);

      daftarMk.add((nama: nama, sks: sks, nilaiHuruf: nilai));
    } on FormatException catch (e) {
      // Data yang melempar exception diabaikan tanpa menghentikan program
      print('Data diabaikan: ${e.message}\n');
    }
  }

  // Cetak Kartu Hasil Studi (KHS) dengan pengurutan nilai tertinggi
  cetakKhs(daftarMk, urutkan: true);
}
