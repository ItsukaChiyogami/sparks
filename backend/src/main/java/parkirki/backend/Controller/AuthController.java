package parkirki.backend.Controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Service.AuthService;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    // Hapus 'consumes' biar kebal error 415. Spring bakal nerima otomatis.
    @PostMapping("/mahasiswa/login")
    public ResponseEntity<?> loginMahasiswa(
            @RequestParam("nim") String nim, 
            @RequestParam("password") String password) {
        try {
            return ResponseEntity.ok(authService.loginMahasiswa(nim, password));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Hapus 'consumes' biar kebal error 415. Spring bakal nerima otomatis.
    @PostMapping("/security/login")
    public ResponseEntity<?> loginSecurity(
            @RequestParam("nip") String nip, 
            @RequestParam("password") String password) {
        try {
            return ResponseEntity.ok(authService.loginSecurity(nip, password));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}