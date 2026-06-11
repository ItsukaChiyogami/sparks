import cv2
from ultralytics import YOLO
from flask import Flask, Response

app = Flask(__name__)
model = YOLO('yolov8n.pt') 
cap = cv2.VideoCapture(0) # Menggunakan webcam lokal

# Set resolusi ke HD agar perhitungan area lebih presisi
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)

# ── KONFIGURASI AREA PARKIR ──────────────────────────────────
# Asumsikan pada resolusi 1280x720, total area efektif tempat parkir adalah:
# Misal: Lebar 1000px * Tinggi 500px = 500.000 piksel.
TOTAL_AREA_PARKIR = 500000 

# Estimasi rata-rata ukuran 1 slot motor dalam piksel (lebar x tinggi)
# Anda bisa sesuaikan nilai ini setelah melihat hasil uji coba di lapangan
UKURAN_SATU_SLOT_MOTOR = 100000 
TOTAL_KAPASITAS_SLOT = 5

def generate_frames():
    while True:
        success, frame = cap.read()
        if not success:
            break
        
        # Jalankan deteksi objek khusus motor (classes=[3])
        results = model(frame, conf=0.5, classes=[3])
        annotated_frame = results[0].plot()

        # ── VISUALISASI GARIS BAWAH AREA PARKIR (BARU) ────────
        # Menentukan posisi tinggi (y) garis bawah.
        # Karena batas bawah area sebelumnya adalah 610, kita gunakan nilai ini.
        garis_bawah_y = 610
        start_x = 140   # Titik mulai kiri
        end_x = 1140    # Titik berakhir kanan
        
        # Gambar satu garis horizontal di bawah (Warna Biru, ketebalan 4)
        cv2.line(annotated_frame, (start_x, garis_bawah_y), (end_x, garis_bawah_y), (0, 0, 0), 4)
        # ──────────────────────────────────────────────────────

        total_area_motor = 0
        boxes = results[0].boxes
        for box in boxes:
            x1, y1, x2, y2 = box.xyxy[0].tolist()
            lebar = x2 - x1
            tinggi = y2 - y1
            area = lebar * tinggi
            total_area_motor += area

        slot_terpakai = int(total_area_motor // UKURAN_SATU_SLOT_MOTOR)
        remaining_slots = max(0, TOTAL_KAPASITAS_SLOT - slot_terpakai)


        # Encode frame ke format JPEG
        ret, buffer = cv2.imencode('.jpg', annotated_frame)
        frame_bytes = buffer.tobytes()
        
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame_bytes + b'\r\n')

@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

# API Tambahan agar Flutter bisa mengambil data sisa slot dalam bentuk JSON secara berkala
@app.route('/api/slots')
def get_slots():
    success, frame = cap.read()
    if not success:
        return {"remaining_slots": TOTAL_KAPASITAS_SLOT} # Jika kamera gagal, kembalikan kapasitas default
    
    # Jalankan deteksi objek khusus motor (classes=[3])
    results = model(frame, conf=0.5, classes=[3])
    total_area_motor = 0
    
    # Ambil koordinat bounding box dan hitung total luas piksel motor
    for box in results[0].boxes:
        x1, y1, x2, y2 = box.xyxy[0].tolist()
        lebar = x2 - x1
        tinggi = y2 - y1
        total_area_motor += (lebar * tinggi)
        
    # ── LOGIKA PENGURANGAN SLOT (Sama dengan di video feed) ──
    slot_terpakai = int(total_area_motor // UKURAN_SATU_SLOT_MOTOR)
    remaining_slots = max(0, TOTAL_KAPASITAS_SLOT - slot_terpakai)
    
    # Mengembalikan hasil pengurangan real-time ke aplikasi Flutter
    return {"remaining_slots": remaining_slots}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, threaded=True)