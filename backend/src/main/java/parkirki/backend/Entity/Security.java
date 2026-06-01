package parkirki.backend.Entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import java.time.LocalDateTime;

@Entity
@Table(name = "security")
@Data  // ✅ Generate getter/setter untuk SEMUA field
@NoArgsConstructor
@AllArgsConstructor
public class Security {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    @Column(name = "nip", nullable = false, unique = true, length = 20)
    private String nip;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "role", length = 20)
    private String role = "SECURITY";

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}