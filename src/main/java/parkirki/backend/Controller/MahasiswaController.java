package parkirki.backend.Controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Dto.UpdatePasswordRequest;
import parkirki.backend.Service.MahasiswaService;

@RestController
@RequestMapping("/api/mahasiswa")
@RequiredArgsConstructor
public class MahasiswaController {

    private final MahasiswaService mahasiswaService;

    @GetMapping("/{id}")
    public ResponseEntity<?> getProfile(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(mahasiswaService.getProfileMahasiswa(id));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{id}/password")
    public ResponseEntity<?> updatePassword(@PathVariable Long id, @RequestBody UpdatePasswordRequest request) {
        try {
            mahasiswaService.updatePassword(id, request);
            return ResponseEntity.ok("Password berhasil diubah");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}