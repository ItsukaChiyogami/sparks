package parkirki.backend.Repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import parkirki.backend.Entity.Security;

@Repository
public interface SecurityRepository extends JpaRepository<Security, Long> {
    Optional<Security> findByNip(String nip);
    Optional<Security> findByNipAndRole(String nip, String role);
}