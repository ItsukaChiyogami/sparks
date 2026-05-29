package parkirki.backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import parkirki.backend.Entity.Notifikasi;
import java.util.List;

@Repository
public interface NotifikasiRepository extends JpaRepository<Notifikasi, Long> {
    List<Notifikasi> findByMahasiswaIdOrderByDiterimaAtDesc(Long mahasiswaId);
}