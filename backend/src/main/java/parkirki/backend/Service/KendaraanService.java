package parkirki.backend.Service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Dto.UpdateKendaraanRequest;
import parkirki.backend.Entity.Kendaraan;
import parkirki.backend.Repository.KendaraanRepository;

@Service
@RequiredArgsConstructor
public class KendaraanService {

    private final KendaraanRepository kendaraanRepository;

    @Transactional
    public Kendaraan updateKendaraanByMahasiswaId(Long mahasiswaId, UpdateKendaraanRequest request) {
        // CARI KENDARAAN BERDASARKAN MAHASISWA_ID LANSUNG
        Kendaraan k = kendaraanRepository.findByMahasiswaId(mahasiswaId)
            .orElseThrow(() -> new RuntimeException("Kendaraan untuk mahasiswa ini tidak ditemukan"));

        k.setPlatNomor(request.getPlatNomor());
        k.setJenisKendaraan(request.getJenisKendaraan());
        
        return kendaraanRepository.save(k);
    }
}