package parkirki.backend.Dto;

import lombok.Data;
import parkirki.backend.Entity.StatusParkir;

@Data
public class UpdateParkirRequest {
    private Long securityId;
    private StatusParkir status;
}