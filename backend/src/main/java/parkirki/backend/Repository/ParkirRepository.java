package parkirki.backend.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import parkirki.backend.Entity.Parkir;
import parkirki.backend.Entity.Security;
import parkirki.backend.Entity.StatusParkir;
import java.util.List;

@Repository
public interface ParkirRepository extends JpaRepository<Parkir, Long> {
    
    List<Parkir> findByKendaraan_MahasiswaId(Long mahasiswaId);

    // BYPASS SETTER: Insert Paksa via Native SQL
    @Modifying
    @Query(value = "INSERT INTO parkir (status, kendaraan_id, created_at, updated_at) VALUES (:status, :kendaraanId, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)", nativeQuery = true)
    void insertParkirNative(@Param("kendaraanId") Long kendaraanId, @Param("status") String status);

    // BYPASS SETTER: Update Paksa via JPQL
    @Modifying
    @Query("UPDATE Parkir p SET p.status = :status, p.updatedBy = :security WHERE p.id = :parkirId")
    void updateStatusAndSecurity(@Param("parkirId") Long parkirId, @Param("status") StatusParkir status, @Param("security") Security security);

    // BYPASS GETTER: Ambil kendaraan_id tanpa panggil parkir.getKendaraan()
    @Query("SELECT p.kendaraan.id FROM Parkir p WHERE p.id = :parkirId")
    Long findKendaraanIdByParkirId(@Param("parkirId") Long parkirId);

    // Bantuan untuk me-return data setelah native insert
    @Query(value = "SELECT * FROM parkir WHERE kendaraan_id = :kendaraanId ORDER BY created_at DESC LIMIT 1", nativeQuery = true)
    Parkir findLastParkirByKendaraan(@Param("kendaraanId") Long kendaraanId);
}