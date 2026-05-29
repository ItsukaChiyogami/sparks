package parkirki.backend.Entity;

import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "notifikasi")
public class Notifikasi {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "judul", nullable = false)
    private String judul;

    @Column(name = "pesan", nullable = false, columnDefinition = "TEXT")
    private String pesan;

    @Column(name = "is_read", nullable = false)
    private boolean isRead = false;

    // Relasi ke Mahasiswa (Siapa penerima notifnya)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "mahasiswa_id", nullable = false)
    private Mahasiswa mahasiswa;

    // Relasi ke transaksi parkir (Jika di-klik, buka halaman parkir mana?)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parkir_id", nullable = false)
    private Parkir parkir;

    @CreationTimestamp
    @Column(name = "diterima_at", updatable = false)
    private LocalDateTime diterimaAt;
}