package parkirki.backend.Repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import parkirki.backend.Entity.Kendaraan;
import parkirki.backend.Entity.Mahasiswa;

@Repository
public interface KendaraanRepository extends JpaRepository<Kendaraan, Long> {
    
    // GANTI KE OPTIONAL KARENA RELASI 1-TO-1
    Optional<Kendaraan> findByMahasiswaId(Long mahasiswaId);

    @Query("SELECT k.platNomor FROM Kendaraan k WHERE k.id = :id")
    String findPlatNomorById(@Param("id") Long id);

    @Query("SELECT k.mahasiswa FROM Kendaraan k WHERE k.id = :id")
    Mahasiswa findMahasiswaByKendaraanId(@Param("id") Long id);
}