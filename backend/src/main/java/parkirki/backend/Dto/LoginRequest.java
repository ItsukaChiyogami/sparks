package parkirki.backend.Dto;

import lombok.Data;  // ← HARUS ADA

@Data  // ← HARUS ADA
public class LoginRequest {
    private String identifier;
    private String password;
}