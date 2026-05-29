# Parkirki Backend API Documentation

Parkirki adalah sistem manajemen parkir kampus yang dirancang untuk efisiensi operasional keamanan dan transparansi bagi mahasiswa. Sistem ini dibangun dengan arsitektur RESTful yang scalable dan production-ready.

## 1. Problem Statement & Architecture
* **Problem:** Antrean manual di gerbang kampus sering menyebabkan bottleneck dan kurangnya data riwayat kendaraan yang akurat.
* **Constraint:** Perlu pemisahan akses yang ketat antara Mahasiswa (User) dan Security (Admin), serta penanganan input data kendaraan yang dinamis.
* **Solution:** Implementasi Role-Based Access Control (RBAC) via API dengan modul terpisah untuk Parkir, Kendaraan, dan Notifikasi.
* **Tradeoff:** Penggunaan `@RequestParam` pada login mempermudah integrasi form-data namun membutuhkan penanganan eksplisit di sisi Frontend dibanding JSON body.

## 2. Tech Stack
* **Framework:** Spring Boot 3.x
* **Security:** Spring Security (Implicitly used)
* **Data Handling:** Lombok, ResponseEntity Wrapper
* **Protocol:** HTTP/1.1 (JSON & x-www-form-urlencoded)

## 3. API Specification

### A. Authentication Module
| Endpoint | Method | Content-Type | Param/Body | Role |
| :--- | :--- | :--- | :--- | :--- |
| `/api/auth/mahasiswa/login` | POST | `application/x-www-form-urlencoded` | `nim`, `password` | Mahasiswa |
| `/api/auth/security/login` | POST | `application/x-www-form-urlencoded` | `nip`, `password` | Security |

### B. Parking Operations (Core)
| Endpoint | Method | Description |
| :--- | :--- | :--- |
| `/api/parkir/create` | POST | Mahasiswa melakukan request tiket parkir. |
| `/api/parkir/all` | GET | List seluruh aktivitas parkir (View for Security). |
| `/api/parkir/mahasiswa/{mahasiswaId}` | GET | Riwayat parkir spesifik per mahasiswa. |
| `/api/parkir/{parkirId}/update` | PUT | Security merubah status (Disetujui/Keluar). |

### C. User & Profile Management
* **Mahasiswa:**
    * `GET /api/mahasiswa/{id}`: Ambil profil.
    * `PUT /api/mahasiswa/{id}/password`: Update password.
    * `PUT /api/kendaraan/mahasiswa/{mahasiswaId}`: Update data plat nomor/kendaraan.
* **Security:**
    * `GET /api/security/{id}`: Ambil profil security.
    * `PUT /api/security/{id}/password`: Update password security.

### D. Notification System
* `GET /api/notifikasi/mahasiswa/{mahasiswaId}`: Fetch list notifikasi terbaru.
* `PUT /api/notifikasi/{notifikasiId}/read`: Tandai notifikasi telah dibaca.

## 4. Operational Flow

### Flow Request Parkir
1.  **Identity:** Mahasiswa login -> simpan `mahasiswaId`.
2.  **Submission:** Mahasiswa POST `/api/parkir/create` membawa `CreateParkirRequest`.
3.  **Approval:** Security melihat antrean di `/api/parkir/all`, lalu PUT `/api/parkir/{parkirId}/update` dengan status `APPROVED` saat kendaraan masuk.
4.  **Notification:** Mahasiswa menerima notif via `/api/notifikasi/mahasiswa/{id}`.

## 5. Security & Validation
* **Validation:** Setiap request harus divalidasi di layer Service (Handled by `parkirki.backend.Service`).
* **Error Handling:** Global Exception Handling mengembalikan `ResponseEntity.badRequest().body(e.getMessage())` untuk konsistensi di Client-side.
* **Sanitization:** Pastikan data `nomorPolisi` dan `nim/nip` disanitasi sebelum masuk ke database.

## 6. Implementation Guide (Frontend)
1.  Gunakan Axios/Fetch dengan header `Content-Type: application/x-www-form-urlencoded` khusus untuk endpoint login.
2.  Untuk endpoint lainnya, gunakan `Content-Type: application/json`.
3.  Implementasikan Interceptor untuk menangani error 400 (Bad Request) guna menampilkan pesan error dari backend langsung ke UI Toast/Alert.# sparks
