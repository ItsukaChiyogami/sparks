package parkirki.backend.Service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Dto.UpdatePasswordRequest;
import parkirki.backend.Entity.Security;
import parkirki.backend.Repository.SecurityRepository;

@Service
@RequiredArgsConstructor
public class SecurityService {

    private final SecurityRepository securityRepository;

    // READ SPECIFIC SECURITY (Kembaliin Entity langsung karena gak ada list aneh-aneh, tapi password di-null kan)
    public Security getProfileSecurity(Long id) {
        Security sec = securityRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Security tidak ditemukan"));
        
        sec.setPassword(null); // Sembunyikan password di response
        return sec;
    }

    // UPDATE PASSWORD
    @Transactional
    public void updatePassword(Long id, UpdatePasswordRequest request) {
        Security sec = securityRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Security tidak ditemukan"));

        if (!sec.getPassword().equals(request.getOldPassword())) {
            throw new RuntimeException("Password lama salah!");
        }

        sec.setPassword(request.getNewPassword());
        securityRepository.save(sec);
    }
}