package parkirki.backend.Service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Dto.CreateParkirRequest;
import parkirki.backend.Dto.UpdateParkirRequest;
import parkirki.backend.Entity.Mahasiswa;
import parkirki.backend.Entity.Notifikasi;
import parkirki.backend.Entity.Parkir;
import parkirki.backend.Entity.Security;
import parkirki.backend.Entity.StatusParkir;
import parkirki.backend.Repository.KendaraanRepository;
import parkirki.backend.Repository.NotifikasiRepository;
import parkirki.backend.Repository.ParkirRepository;
import parkirki.backend.Repository.SecurityRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ParkirService {

    private final ParkirRepository parkirRepository;
    private final KendaraanRepository kendaraanRepository;
    private final SecurityRepository securityRepository;
    private final NotifikasiRepository notifikasiRepository;

    @Transactional
    public Parkir createParkir(CreateParkirRequest request) {
        // Cek validasi kepemilikan tanpa getMahasiswa() dari object Kendaraan secara langsung
        Mahasiswa pemilik = kendaraanRepository.findMahasiswaByKendaraanId(request.getKendaraanId());
        
        if (pemilik == null) {
            throw new RuntimeException("Kendaraan tidak ditemukan");
        }

        if (!pemilik.getId().equals(request.getMahasiswaId())) {
            throw new RuntimeException("Kendaraan ini bukan milik mahasiswa tersebut");
        }

        // Hajar database langsung, bypass SETTER Parkir
        parkirRepository.insertParkirNative(request.getKendaraanId(), StatusParkir.PENDING.name());
        
        return parkirRepository.findLastParkirByKendaraan(request.getKendaraanId());
    }

    public List<Parkir> getAllParkir() {
        return parkirRepository.findAll();
    }

    public List<Parkir> getParkirByMahasiswa(Long mahasiswaId) {
        return parkirRepository.findByKendaraan_MahasiswaId(mahasiswaId);
    }

    @Transactional
    public Parkir updateStatusParkir(Long parkirId, UpdateParkirRequest request) {
        Security security = securityRepository.findById(request.getSecurityId())
            .orElseThrow(() -> new RuntimeException("Security tidak ditemukan"));

        // Hajar database langsung, bypass SETTER Status & UpdatedBy
        parkirRepository.updateStatusAndSecurity(parkirId, request.getStatus(), security);

        Parkir savedParkir = parkirRepository.findById(parkirId)
            .orElseThrow(() -> new RuntimeException("Data parkir gagal diupdate"));

        // Ambil ID Kendaraan, Plat Nomor, dan Mahasiswa via Query (Bypass GETTER)
        Long kendaraanId = parkirRepository.findKendaraanIdByParkirId(parkirId);
        String platNomor = kendaraanRepository.findPlatNomorById(kendaraanId);
        Mahasiswa targetMahasiswa = kendaraanRepository.findMahasiswaByKendaraanId(kendaraanId);

        // Notifikasi (Asumsi Lombok jalan untuk class ini. Kalau error juga, berarti IDE lu fix rusak parah)
        Notifikasi notif = new Notifikasi();
        notif.setJudul("Status Parkir Diperbarui");
        notif.setPesan("Kendaraan Anda dengan plat " + platNomor + 
                       " saat ini berstatus: " + request.getStatus().name() + 
                       " (Diperbarui oleh: " + security.getFullName() + ")");
        notif.setMahasiswa(targetMahasiswa);
        notif.setParkir(savedParkir);
        notif.setRead(false);
        notifikasiRepository.save(notif);

        return savedParkir;
    }
}