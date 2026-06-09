import cv2
import matplotlib.pyplot as plt

# 1. Pastikan library ultralytics sudah terinstall.
# Di VS Code, jangan jalankan "!pip install ultralytics" di dalam file ini.
# Buka Terminal di VS Code (Ctrl + `) lalu ketik: pip install ultralytics

# 2. Baca foto simulasi (Ubah path di bawah ini sesuai lokasi gambar di laptopmu!)
# Contoh jika gambar ada di folder yang sama dengan file script ini:
img_path = '3.jpeg' 

img = cv2.imread(img_path)

if img is None:
    print(f"Error: Gambar tidak ditemukan di path '{img_path}'. Periksa kembali lokasi file gambar Anda.")
else:
    # Konversi warna dari BGR (OpenCV) ke RGB (Matplotlib)
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    # Tampilkan foto dengan sumbu koordinat (grid)
    plt.figure(figsize=(10, 8))
    plt.imshow(img_rgb)
    plt.grid(True, color='red', linestyle='-', linewidth=0.5)
    plt.title("Lihat posisi angka 0 dan 30 pada penggaris besi")
    plt.show()