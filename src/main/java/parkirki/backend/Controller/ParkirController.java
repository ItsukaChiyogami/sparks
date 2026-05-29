package parkirki.backend.Controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Dto.CreateParkirRequest;
import parkirki.backend.Dto.UpdateParkirRequest;
import parkirki.backend.Service.ParkirService;

@RestController
@RequestMapping("/api/parkir")
@RequiredArgsConstructor
public class ParkirController {

    private final ParkirService parkirService;

    @PostMapping("/create")
    public ResponseEntity<?> createParkir(@RequestBody CreateParkirRequest request) {
        try {
            return ResponseEntity.ok(parkirService.createParkir(request));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/all")
    public ResponseEntity<?> getAllParkir() {
        return ResponseEntity.ok(parkirService.getAllParkir());
    }

    @GetMapping("/mahasiswa/{mahasiswaId}")
    public ResponseEntity<?> getParkirByMahasiswa(@PathVariable Long mahasiswaId) {
        return ResponseEntity.ok(parkirService.getParkirByMahasiswa(mahasiswaId));
    }

    @PutMapping("/{parkirId}/update")
    public ResponseEntity<?> updateStatusParkir(@PathVariable Long parkirId, @RequestBody UpdateParkirRequest request) {
        try {
            return ResponseEntity.ok(parkirService.updateStatusParkir(parkirId, request));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}