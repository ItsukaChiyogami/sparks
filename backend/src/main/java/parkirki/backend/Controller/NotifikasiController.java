package parkirki.backend.Controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Service.NotifikasiService;

@RestController
@RequestMapping("/api/notifikasi")
@RequiredArgsConstructor
public class NotifikasiController {

    private final NotifikasiService notifikasiService;

    @GetMapping("/mahasiswa/{mahasiswaId}")
    public ResponseEntity<?> getNotifikasi(@PathVariable Long mahasiswaId) {
        return ResponseEntity.ok(notifikasiService.getNotifikasiMahasiswa(mahasiswaId));
    }

    @PutMapping("/{notifikasiId}/read")
    public ResponseEntity<?> markAsRead(@PathVariable Long notifikasiId) {
        try {
            notifikasiService.markAsRead(notifikasiId);
            return ResponseEntity.ok("Notifikasi ditandai sudah dibaca");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}