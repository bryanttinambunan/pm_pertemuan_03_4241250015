# Tugas Rutin 3: Kalkulator IP Semester (Console)

## Identitas Mahasiswa

- **Nama**: Bryant Tinambunan
- **NIM**: 4243250015
- **Mata Kuliah**: Pemrograman Mobile (3KOM40215)
- **Program Studi**: Ilmu Komputer, Universitas Negeri Medan (UNIMED)
- **Pertemuan**: 3 (Control Flow, Functions, Closures, dan Error Handling di Dart)

---

## Deskripsi Program

Aplikasi console ini digunakan untuk menghitung Indeks Prestasi (IP) satu semester berbasis bahasa pemrograman Dart 3. Pengguna memasukkan data mata kuliah secara interaktif (nama mata kuliah, bobot SKS, dan nilai huruf) hingga pengguna mengosongkan input nama mata kuliah. Program kemudian menghasilkan cetakan Kartu Hasil Studi (KHS) yang terurut berdasarkan nilai tertinggi, menghitung total SKS, nilai IP semester beserta predikatnya, serta menyaring mata kuliah yang memerlukan perbaikan nilai (bobot < 2.0).

---

## Petunjuk Menjalankan Program

### 1. Menjalankan Kalkulator IP Semester (Tugas Rutin 3)

Dari direktori root proyek (`pm_p3_4243250015`), jalankan perintah:

```shell
dart run
```
atau
```shell
dart run bin/pm_p3_4243250015.dart
```

### 2. Menjalankan Todo CLI App (Praktikum Bagian B)

Tersedia juga implementasi Todo CLI lengkap beserta 3 tantangan modul (ubah judul, prioritas & pengurutan, dan ringkasan):

```shell
dart run bin/todo.dart
```

### 3. Menjalankan Unit Test

Pengujian otomatis dilakukan untuk memastikan keandalan fungsi validasi, perhitungan IP, fungsi pembanding, dan closure:

```shell
dart test
```

### 4. Menjalankan Pemeriksaan Kode (Linter)

Memastikan tidak ada error atau warning sesuai standar *Effective Dart*:

```shell
dart analyze
```

---

## Tangkapan Layar Sesi Interaksi

Berikut adalah rekaman sesi eksekusi terminal yang memperlihatkan alur input normal, penolakan input salah (SKS berupa teks dan nilai huruf di luar A–E), hingga pencetakan KHS:

```text
=== KALKULATOR IP SEMESTER ===
Masukkan data mata kuliah. Kosongkan nama untuk selesai.

Nama MK : Pemrograman Mobile
SKS     : 3
Nilai   : A

Nama MK : Jaringan Komputer
SKS     : tiga
Data diabaikan: SKS harus berupa angka 1-6, bukan "tiga".

Nama MK : Jaringan Komputer
SKS     : 3
Nilai   : Z
Data diabaikan: Nilai harus berupa huruf A, B, C, D, atau E, bukan "Z".

Nama MK : Statistika
SKS     : 2
Nilai   : B

Nama MK : Etika Profesi
SKS     : 2
Nilai   : D

Nama MK : 

Mata Kuliah                 SKS  Nilai
--------------------------------------
Pemrograman Mobile          3    A
Statistika                  2    B
Etika Profesi               2    D
--------------------------------------
Total SKS : 7
IP        : 2.86 (Memuaskan)
Perlu diperbaiki: Etika Profesi
```

*(Catatan: Tangkapan layar gambar terminal dapat disimpan pada berkas gambar atau dilihat melalui log sesi interaktif di atas).*

---

## Penjelasan Higher-Order Function, Closure, dan Error Handling

Pada aplikasi ini, *higher-order function* diterapkan pada fungsi `hitungIp()` menggunakan method `fold()` untuk mengakumulasikan total SKS serta total perkalian SKS dengan bobot nilai. Pada fungsi `cetakKhs()`, *higher-order function* `sort()` digunakan dengan fungsi pembanding (comparator lambda) untuk mengurutkan daftar mata kuliah dari bobot nilai tertinggi ke terendah, serta `where()` dan `map()` untuk menyaring dan memformat daftar nama mata kuliah remedial. Fitur *closure* diterapkan melalui fungsi `buatFilterPerbaikan({double batasBobot = 2.0})` yang menghasilkan fungsi predikat `(MataKuliah mk) => bobot(mk.nilaiHuruf) < batasBobot` yang menangkap (*capture*) variabel `batasBobot` dari lingkup pembuatnya.

Mekanisme *error handling* diterapkan dengan pemisahan tanggung jawab (*separation of concerns*). Fungsi `validasiSks()` melempar `FormatException` jika input bukan angka 1–6, dan fungsi `validasiNilaiHuruf()` serta `bobot()` melempar `FormatException` jika nilai bukan A–E. Pada fungsi `main()`, blok `try-catch` menangkap `FormatException` secara spesifik, menampilkan pesan peringatan yang ramah, dan mengabaikan baris data tidak valid tanpa menghentikan program.

---

## Pernyataan Penggunaan AI

Pengembangan program ini (struktur kode awal, penyusunan fungsi higher-order/closure, serta perancangan unit test dan dokumentasi) dibantu oleh asisten AI (Google Gemini). Seluruh logika kode telah diuji secara menyeluruh melalui `dart test` (11 pengujian lulus) dan diverifikasi kebersihannya dengan `dart analyze` tanpa error.
