package parkirki.backend.Dto;

import lombok.Data;
import parkirki.backend.Entity.JenisKendaraan;

@Data
public class UpdateKendaraanRequest {
    private String platNomor;
    private JenisKendaraan jenisKendaraan;
}