package parkirki.backend.Dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class MahasiswaProfileResponse {
    private Long id;
    private String fullName;
    private String nim;
    private KendaraanDto kendaraan; // INI OBJECT TUNGGAL, BUKAN LIST LAGI
}