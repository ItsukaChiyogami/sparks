package parkirki.backend.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor  // ✅ Constructor tanpa parameter (wajib untuk JSON serialization)
@AllArgsConstructor // ✅ Constructor dengan SEMUA parameter (wajib untuk new LoginResponse(...))
public class LoginResponse {
    private Long id;
    private String fullName;
    private String token;
    private String role;
}