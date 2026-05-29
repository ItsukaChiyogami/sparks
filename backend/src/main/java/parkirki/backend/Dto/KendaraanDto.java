package parkirki.backend.Dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class KendaraanDto {
    private Long id;
    private String platNomor;
    private String jenisKendaraan;
}