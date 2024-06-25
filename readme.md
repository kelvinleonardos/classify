# Dokumentasi Aplikasi Classify dan Pengambilan Gambar
<p align="center">
  <img src="logo.jpeg" alt="Classify Logo">
</p>
## Gambaran Umum
  APlikasi Classify adalah sebuah aplikasi Android yang berguna untuk melakukan absensi siswa dengan menggunakan metode face-recognition memanfaatkan teknologi Deep Learning dengan menggunakan Algoritma dan CNN, yang mana aplikasinya dibagun dengan menggunakan framework Flutter. 
Aplikasi ini sendiri terdiri dari dua bagian utama yang berada dalam folder besar bernama `classify`: Aplikasi Classify dan skrip pengambilan gambar.

### 1. Aplikasi Classify
  Aplikasi Classify merupakan sebuah proyek Flutter yang terletak pada folder `classify_app`. Aplikasi ini menggunakan TensorFlow Lite untuk mengklasifikasikan gambar dari umpan kamera. Aplikasi ini juga mempertahankan daftar siswa dalam database SQLite, memungkinkan pengguna untuk menambahkan, melihat, dan menghapus catatan siswa.

### 2. Pengambilan Gambar
  Skrip ini berada dalam folder `image_dataset` dan bertugas untuk mengambil gambar dari kamera komputer dan menyimpannya ke dalam folder yang ditentukan. Gambar-gambar ini kemudian dapat digunakan untuk proses klasifikasi dalam Aplikasi Classify.

## Struktur Aplikasi
Aplikasi ini dibagi menjadi beberapa file dan folder, masing-masing dengan tujuan tertentu:

- Folder `classify/classify_app`: Berisi kode sumber untuk Aplikasi Classify.
- File `classify/image_dataset/main.py`: Berisi skrip untuk mengambil gambar dari kamera komputer.

## Fitur

### Klasifikasi Gambar
Aplikasi Classify menggunakan umpan kamera untuk mengklasifikasikan gambar secara real-time menggunakan model TensorFlow Lite. Model dimuat dari file `classify_app/assets/models.tflite`, dan label dimuat dari file `classify_app/assets/models.txt`.

### Database Siswa
Aplikasi Classify mempertahankan daftar siswa dalam database SQLite. Setiap siswa memiliki ID, nama, dan timestamp terakhir yang dicatat. Aplikasi ini menyediakan operasi berikut pada database siswa:

- **Insert**: Siswa baru dapat ditambahkan ke database. Nama siswa dimasukkan oleh pengguna, dan timestamp terakhir yang dicatat secara otomatis diatur ke tanggal dan waktu saat ini.
- **View**: Daftar siswa dapat dilihat dalam daftar. Setiap item daftar menampilkan nama siswa dan timestamp terakhir yang dicatat.
- **Update**: Aplikasi ini menyediakan metode untuk memperbarui catatan siswa, tetapi fitur ini saat ini tidak digunakan dalam antarmuka pengguna.
- **Delete**: Aplikasi ini menyediakan metode untuk menghapus catatan siswa, tetapi fitur ini saat ini tidak digunakan dalam antarmuka pengguna.

### Pengambilan Gambar
Skrip `main.py` dalam folder `image_dataset` mengambil gambar dari kamera komputer dan menyimpannya ke dalam folder yang ditentukan. Gambar-gambar ini kemudian dapat digunakan untuk proses klasifikasi dalam Aplikasi Classify.

## Menjalankan Aplikasi
Untuk menjalankan Aplikasi Classify, pastikan Anda telah menginstal dan menyiapkan Flutter dan Dart di mesin Anda. Kemudian, navigasikan ke direktori `classify/classify_app` di terminal Anda dan jalankan perintah berikut:

```bash
flutter run
```

Untuk menjalankan skrip pengambilan gambar, pastikan Anda telah menginstal dan menyiapkan Python dan OpenCV di mesin Anda. Kemudian, navigasikan ke direktori `classify/image_dataset` di terminal Anda dan jalankan perintah berikut:

```bash
python main.py
```

Ini akan memulai proses pengambilan gambar.
