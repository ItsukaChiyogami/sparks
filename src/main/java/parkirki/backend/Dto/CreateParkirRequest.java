package parkirki.backend.Dto;

import lombok.Data;

@Data
public class CreateParkirRequest {
    private Long mahasiswaId;
    private Long kendaraanId;
}