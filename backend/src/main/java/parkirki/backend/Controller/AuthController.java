package parkirki.backend.Controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Dto.LoginRequest;
import parkirki.backend.Dto.LoginResponse;
import parkirki.backend.Service.AuthService;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", allowedHeaders = "*") 
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        try {
            LoginResponse response = authService.login(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            // 🟢 Menggunakan 5 argumen agar sesuai dengan struktur DTO baru
            return ResponseEntity.badRequest().body(
                new LoginResponse(null, null, null, "Login gagal: " + e.getMessage(), null)
            );
        }
    }
}