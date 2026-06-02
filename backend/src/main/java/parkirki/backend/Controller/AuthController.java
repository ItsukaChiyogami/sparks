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
// Batasi hanya dari origin port Flutter Web Anda (biasanya port 5000-an atau '*' untuk semua)
@CrossOrigin(origins = "*", allowedHeaders = "*") 
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        try {
            LoginResponse response = authService.login(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                new LoginResponse(null, null, null, "Login gagal: " + e.getMessage())
            );
        }
    }
}