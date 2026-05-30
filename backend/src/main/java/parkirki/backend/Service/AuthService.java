package parkirki.backend.Service;

import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Dto.LoginRequest;
import parkirki.backend.Dto.LoginResponse;
import parkirki.backend.Entity.Security;
import parkirki.backend.Repository.SecurityRepository;
import parkirki.backend.Config.JwtTokenProvider;
import org.springframework.security.crypto.password.PasswordEncoder;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final SecurityRepository securityRepository;
    private final JwtTokenProvider jwtTokenProvider;
    private final PasswordEncoder passwordEncoder;

    public LoginResponse login(LoginRequest request) {
        Security security = securityRepository.findByNip(request.getIdentifier())
            .orElseThrow(() -> new RuntimeException("NIP tidak ditemukan"));
        
        // ✅ VERIFIKASI PASSWORD DENGAN BCrypt
        if (!passwordEncoder.matches(request.getPassword(), security.getPassword())) {
            throw new RuntimeException("Password salah");
        }
        
        // ✅ GENERATE JWT TOKEN
        String token = jwtTokenProvider.generateToken(security.getNip());
        
        return new LoginResponse(
            security.getId(),
            security.getFullName(),
            token,
            security.getRole()
        );
    }
}