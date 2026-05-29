package parkirki.backend.Service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Entity.Notifikasi;
import parkirki.backend.Repository.NotifikasiRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotifikasiService {

    private final NotifikasiRepository notifikasiRepository;

    // READ
    public List<Notifikasi> getNotifikasiMahasiswa(Long mahasiswaId) {
        return notifikasiRepository.findByMahasiswaIdOrderByDiterimaAtDesc(mahasiswaId);
    }

    // UPDATE (Tandai sudah dibaca)
    @Transactional
    public void markAsRead(Long notifikasiId) {
        Notifikasi notif = notifikasiRepository.findById(notifikasiId)
            .orElseThrow(() -> new RuntimeException("Notifikasi tidak ditemukan"));
        notif.setRead(true);
        notifikasiRepository.save(notif);
    }
}