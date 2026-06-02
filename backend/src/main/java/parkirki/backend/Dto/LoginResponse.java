package parkirki.backend.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {
    private Long id;
    private String fullName;
    private String token;
    private String role;
    private String vehiclePlate; // 🟢 Menampung plat nomor hasil join tabel kendaraan
}