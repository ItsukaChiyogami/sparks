package parkirki.backend.Entity;

import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

@Data
@Entity
@Table(name = "mahasiswa")
public class Mahasiswa {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    @Column(name = "nim", nullable = false, unique = true, length = 20)
    private String nim;

    @Column(name = "password", nullable = false)
    private String password;

    // UBAH JADI One-to-One (Bukan List lagi)
    @OneToOne(mappedBy = "mahasiswa", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude 
    private Kendaraan kendaraan;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}