package parkirki.backend.Controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Dto.UpdateKendaraanRequest;
import parkirki.backend.Service.KendaraanService;

@RestController
@RequestMapping("/api/kendaraan")
@RequiredArgsConstructor
public class KendaraanController {

    private final KendaraanService kendaraanService;

    // ENDPOINT DIUBAH MENERIMA MAHASISWA ID
    @PutMapping("/mahasiswa/{mahasiswaId}")
    public ResponseEntity<?> updateKendaraan(
            @PathVariable Long mahasiswaId, 
            @RequestBody UpdateKendaraanRequest request) {
        try {
            return ResponseEntity.ok(kendaraanService.updateKendaraanByMahasiswaId(mahasiswaId, request));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}