package parkirki.backend.Entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

@Data
@Entity
@Table(name = "kendaraan")
public class Kendaraan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "plat_nomor", nullable = false, unique = true, length = 15)
    private String platNomor;

    @Enumerated(EnumType.STRING)
    @Column(name = "jenis_kendaraan", length = 50, nullable = false)
    private JenisKendaraan jenisKendaraan;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "mahasiswa_id", nullable = false, unique = true)
    @JsonIgnore // <--- INI OBAT ANTI INFINITE LOOP JSON
    @ToString.Exclude // <--- INI OBAT ANTI MEMORY LEAK DI TERMINAL LOG
    private Mahasiswa mahasiswa;
}