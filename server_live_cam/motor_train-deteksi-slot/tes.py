import cv2
from ultralytics import YOLO
from flask import Flask, Response

app = Flask(__name__)
model = YOLO('yolov8n.pt') 
cap = cv2.VideoCapture(0) # Menggunakan webcam lokal

def generate_frames():
    while True:
        success, frame = cap.read()
        if not success:
            break
        else:
            # Jalankan deteksi objek khusus motor (classes=[3])
            results = model(frame, conf=0.5, classes=[3])
            annotated_frame = results[0].plot()

            # Encode frame ke dalam bentuk format JPEG
            ret, buffer = cv2.imencode('.jpg', annotated_frame)
            frame_bytes = buffer.tobytes()
            
            # Gabungkan menjadi format stream MJPEG
            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + frame_bytes + b'\r\n')

@app.route('/video_feed')
def video_feed():
    # Mengembalikan response berupa stream video
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == '__main__':
    # Jalankan server di port 5000, accessible dari network lokal (0.0.0.0)
    app.run(host='0.0.0.0', port=5000, threaded=True)