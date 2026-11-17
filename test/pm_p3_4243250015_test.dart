import 'package:pm_p3_4243250015/pm_p3_4243250015.dart';
import 'package:test/test.dart';

void main() {
  group('Fungsi bobot()', () {
    test('Mengubah nilai huruf A-E ke bobot angka dengan benar', () {
      expect(bobot('A'), equals(4.0));
      expect(bobot('a'), equals(4.0));
      expect(bobot('B'), equals(3.0));
      expect(bobot('C'), equals(2.0));
      expect(bobot('D'), equals(1.0));
      expect(bobot('E'), equals(0.0));
    });

    test('Melempar FormatException untuk nilai huruf tidak valid', () {
      expect(() => bobot('F'), throwsFormatException);
      expect(() => bobot('12'), throwsFormatException);
      expect(() => bobot(''), throwsFormatException);
    });
  });

  group('Fungsi validasi', () {
    test('validasiSks menerima angka 1-6 dan mengembalikan int', () {
      expect(validasiSks('1'), equals(1));
      expect(validasiSks('3'), equals(3));
      expect(validasiSks('6'), equals(6));
    });

    test('validasiSks melempar FormatException jika bukan angka atau di luar rentang 1-6', () {
      expect(() => validasiSks('tiga'), throwsFormatException);
      expect(() => validasiSks('0'), throwsFormatException);
      expect(() => validasiSks('7'), throwsFormatException);
      expect(() => validasiSks(''), throwsFormatException);
    });

    test('validasiNilaiHuruf menerima A-E case-insensitive', () {
      expect(validasiNilaiHuruf('a'), equals('A'));
      expect(validasiNilaiHuruf('B'), equals('B'));
    });

    test('validasiNilaiHuruf melempar FormatException jika tidak valid', () {
      expect(() => validasiNilaiHuruf('Z'), throwsFormatException);
      expect(() => validasiNilaiHuruf('100'), throwsFormatException);
    });
  });

  group('Fungsi hitungIp()', () {
    test('Mengembalikan 0.0 jika data kosong', () {
      expect(hitungIp([]), equals(0.0));
    });

    test('Menghitung IP dengan fold sesuai bobot dan SKS', () {
      final data = <MataKuliah>[
        (nama: 'Pemrograman Mobile', sks: 3, nilaiHuruf: 'A'), // 3 * 4 = 12
        (nama: 'Statistika', sks: 2, nilaiHuruf: 'B'), // 2 * 3 = 6
        (nama: 'Etika Profesi', sks: 2, nilaiHuruf: 'D'), // 2 * 1 = 2
      ];
      // Total SKS = 7, Total bobot = 20, IP = 20 / 7 ≈ 2.857
      final ip = hitungIp(data);
      expect(ip, closeTo(20 / 7, 0.001));
    });

    test('Menghitung IP untuk skenario contoh modul', () {
      // 3 SKS A (12) + 2 SKS B (6) + 2 SKS D (2) -> 20 / 7 = 2.86
      // Jika 3 A (12) + 2 B (6) + 1 C (2) + 1 D (1) = 21 / 7 = 3.00
      final data = <MataKuliah>[
        (nama: 'MK 1', sks: 3, nilaiHuruf: 'A'),
        (nama: 'MK 2', sks: 3, nilaiHuruf: 'B'),
      ]; // (12 + 9) / 6 = 21 / 6 = 3.5
      expect(hitungIp(data), equals(3.5));
    });
  });

  group('Fungsi predikat()', () {
    test('Mengembalikan predikat yang sesuai', () {
      expect(predikat(3.75), equals('Dengan Pujian'));
      expect(predikat(3.00), equals('Memuaskan'));
      expect(predikat(2.50), equals('Cukup'));
      expect(predikat(1.80), equals('Kurang'));
    });
  });

  group('Closure buatFilterPerbaikan() dan higher-order functions', () {
    test('Closure menyaring mata kuliah dengan bobot < batasBobot', () {
      final data = <MataKuliah>[
        (nama: 'Pemrograman Mobile', sks: 3, nilaiHuruf: 'A'),
        (nama: 'Statistika', sks: 2, nilaiHuruf: 'B'),
        (nama: 'Etika Profesi', sks: 2, nilaiHuruf: 'D'),
        (nama: 'Fisika', sks: 2, nilaiHuruf: 'E'),
      ];

      final filterDefault = buatFilterPerbaikan(); // batas default 2.0
      final remedi = data.where(filterDefault).map((mk) => mk.nama).toList();
      expect(remedi, equals(['Etika Profesi', 'Fisika']));

      // Custom closure dengan batas bobot 3.0
      final filterKetat = buatFilterPerbaikan(batasBobot: 3.0);
      final diBawahB = data.where(filterKetat).map((mk) => mk.nama).toList();
      expect(diBawahB, equals(['Etika Profesi', 'Fisika']));
    });
  });
}
