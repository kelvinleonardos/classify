import cv2
import os
import time


def capture_images(output_folder, size, capture_duration=10):
    # Membuat folder output jika belum ada
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Inisialisasi kamera
    cap = cv2.VideoCapture(0)  # Gunakan 0 untuk kamera utama, atau ganti sesuai index kamera yang ingin digunakan

    # Hitung FPS (Frames per Second) dari kamera
    fps = cap.get(cv2.CAP_PROP_FPS)
    print(f"FPS: {fps}")

    # Menghitung jumlah frame yang harus diambil
    frames_to_capture = int(fps * capture_duration)
    print(f"Frames to capture: {frames_to_capture}")
    
    # Loop untuk mengambil gambar setiap 0.2 detik selama capture_duration detik
    for i in range(frames_to_capture):
        ret, frame = cap.read()
        if not ret:
            print("Gagal mengambil frame")
            break

        # Resize frame ke ukuran yang diinginkan
        resized_frame = cv2.resize(frame, size)

        # Simpan frame ke dalam folder output
        filename = f"image_{i}.jpg"
        output_path = os.path.join(output_folder, filename)
        cv2.imwrite(output_path, resized_frame)

        # Tampilkan frame yang sedang diambil
        cv2.imshow('Capturing...', resized_frame)
        cv2.waitKey(200)  # Tunggu 200 milidetik (0.2 detik) sebelum mengambil frame berikutnya

    # Tutup kamera dan jendela OpenCV
    print("Selesai mengambil gambar")
    cap.release()
    cv2.destroyAllWindows()
    print("Kamera ditutup")

# Path folder untuk menyimpan gambar
output_folder = 'test/class1'
# Ukuran yang diinginkan untuk gambar
size = (150, 150)
# Durasi pengambilan gambar (detik)
capture_duration = 3

# Panggil fungsi untuk mengambil gambar
capture_images(output_folder, size, capture_duration)
