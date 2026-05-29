package parkirki.backend.Entity;

import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "parkir")
public class Parkir {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private StatusParkir status = StatusParkir.PENDING;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "kendaraan_id", nullable = false)
    private Kendaraan kendaraan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "security_id_updater")
    private Security updatedBy; // Siapa security yang meng-approve/reject

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

}