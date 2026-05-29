package parkirki.backend.Service;

import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Dto.LoginResponse;
import parkirki.backend.Entity.Mahasiswa;
import parkirki.backend.Entity.Security;
import parkirki.backend.Repository.MahasiswaRepository;
import parkirki.backend.Repository.SecurityRepository;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final MahasiswaRepository mahasiswaRepository;
    private final SecurityRepository securityRepository;

    // TERIMA NIM SECARA SPESIFIK (BUKAN IDENTIFIER)
    public LoginResponse loginMahasiswa(String nim, String password) {
        Mahasiswa mhs = mahasiswaRepository.findByNim(nim)
            .orElseThrow(() -> new RuntimeException("NIM tidak ditemukan"));
        
        // PLAIN TEXT PASSWORD CHECK (NO HASHING)
        if (!mhs.getPassword().equals(password)) {
            throw new RuntimeException("Password salah");
        }
        return new LoginResponse(mhs.getId(), mhs.getFullName());
    }

    // TERIMA NIP SECARA SPESIFIK (BUKAN IDENTIFIER)
    public LoginResponse loginSecurity(String nip, String password) {
        Security sec = securityRepository.findByNip(nip)
            .orElseThrow(() -> new RuntimeException("NIP tidak ditemukan"));
        
        // PLAIN TEXT PASSWORD CHECK (NO HASHING)
        if (!sec.getPassword().equals(password)) {
            throw new RuntimeException("Password salah");
        }
        return new LoginResponse(sec.getId(), sec.getFullName());
    }
}