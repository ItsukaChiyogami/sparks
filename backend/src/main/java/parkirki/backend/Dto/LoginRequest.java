package parkirki.backend.Dto;

import lombok.Data;

@Data
public class LoginRequest {
    private String identifier; // NIM atau NIP
    private String password;
}