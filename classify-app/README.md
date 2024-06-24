# Dokumentasi Aplikasi Classify

## Gambaran Umum
Aplikasi Classify adalah proyek Flutter yang menggunakan TensorFlow Lite untuk mengklasifikasikan gambar dari umpan kamera. Aplikasi ini juga mempertahankan daftar siswa dalam database SQLite, memungkinkan pengguna untuk menambahkan, melihat, dan menghapus catatan siswa.

## Dependensi
Aplikasi ini menggunakan dependensi berikut:

- SDK Flutter
- Kamera
- TensorFlow Lite (tflite)
- Icon Cupertino
- SQLite (sqflite)
- Path

## Struktur Aplikasi
Aplikasi ini dibagi menjadi beberapa file Dart, masing-masing dengan tujuan tertentu:

- `main.dart`: Ini adalah titik masuk aplikasi. Ini menginisialisasi kamera dan menyiapkan widget aplikasi utama. Ini juga berisi widget HomePage, ListPage, dan AddPage.

- `models/student.dart`: File ini mendefinisikan kelas Student, yang mewakili catatan siswa dalam database SQLite.

- `databases/dbhelper.dart`: File ini berisi kelas DatabaseHelper, yang menyediakan metode untuk berinteraksi dengan database SQLite.

## Fitur

### Klasifikasi Gambar
Aplikasi ini menggunakan umpan kamera untuk mengklasifikasikan gambar secara real-time menggunakan model TensorFlow Lite. Model dimuat dari file `assets/models.tflite`, dan label dimuat dari file `assets/models.txt`.

### Database Siswa
Aplikasi ini mempertahankan daftar siswa dalam database SQLite. Setiap siswa memiliki ID, nama, dan timestamp terakhir yang dicatat. Aplikasi ini menyediakan operasi berikut pada database siswa:

- **Insert**: Siswa baru dapat ditambahkan ke database. Nama siswa dimasukkan oleh pengguna, dan timestamp terakhir yang dicatat secara otomatis diatur ke tanggal dan waktu saat ini.

- **View**: Daftar siswa dapat dilihat dalam daftar. Setiap item daftar menampilkan nama siswa dan timestamp terakhir yang dicatat.

- **Update**: Aplikasi ini menyediakan metode untuk memperbarui catatan siswa, tetapi fitur ini saat ini tidak digunakan dalam antarmuka pengguna.

- **Delete**: Aplikasi ini menyediakan metode untuk menghapus catatan siswa, tetapi fitur ini saat ini tidak digunakan dalam antarmuka pengguna.

## Menjalankan Aplikasi
Untuk menjalankan aplikasi, pastikan Anda telah menginstal dan menyiapkan Flutter dan Dart di mesin Anda. Kemudian, navigasikan ke direktori proyek di terminal Anda dan jalankan perintah berikut:

```bash
flutter run
```

Ini akan memulai aplikasi dalam mode debug. Anda juga dapat membangun versi rilis dari aplikasi dengan menjalankan:

```bash
flutter build apk --release
```

Ini akan membuat APK rilis yang dapat diinstal pada perangkat Android.