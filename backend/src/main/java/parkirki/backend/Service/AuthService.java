package parkirki.backend.Service;

import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Dto.LoginRequest;
import parkirki.backend.Dto.LoginResponse;
import parkirki.backend.Entity.Security;
import parkirki.backend.Entity.Mahasiswa;
import parkirki.backend.Repository.SecurityRepository;
import parkirki.backend.Repository.MahasiswaRepository;
import parkirki.backend.Repository.KendaraanRepository; // 🟢 Di-import untuk join data plat
import parkirki.backend.Config.JwtTokenProvider;
import org.springframework.security.crypto.password.PasswordEncoder;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final SecurityRepository securityRepository;
    private final MahasiswaRepository mahasiswaRepository;
    private final KendaraanRepository kendaraanRepository; // 🟢 Inject repository kendaraan
    private final JwtTokenProvider jwtTokenProvider;
    private final PasswordEncoder passwordEncoder;

    public LoginResponse login(LoginRequest request) {
        String identifier = request.getIdentifier().trim();
        String password = request.getPassword();

        Optional<Security> securityOpt = securityRepository.findByNip(identifier);
        Optional<Mahasiswa> mahasiswaOpt = mahasiswaRepository.findByNim(identifier);

        // 1. PROSES LOGIN MAHASISWA
        if (mahasiswaOpt.isPresent()) {
            Mahasiswa mahasiswa = mahasiswaOpt.get();
            
            if (!mahasiswa.getPassword().equals(password)) {
                throw new RuntimeException("Password salah");
            }
            
            String token = jwtTokenProvider.generateToken(mahasiswa.getNim());
            
            // 🟢 QUERY GABUNGAN: Cari plat nomor berdasarkan id mahasiswa (Foreign Key: mahasiswa_id)
            String platNomor = "Belum Diatur";
            try {
                // JPA memetakan query secara otomatis berdasarkan pencarian relasi Id
                var kendaraanOpt = kendaraanRepository.findById(mahasiswa.getId());
                if (kendaraanOpt.isPresent()) {
                    platNomor = kendaraanOpt.get().getPlatNomor(); // Mengambil kolom plat_nomor dari DB
                }
            } catch (Exception e) {
                platNomor = "Belum Diatur";
            }
            
            return new LoginResponse(
                mahasiswa.getId(),
                mahasiswa.getFullName(),
                token,
                "MAHASISWA",
                platNomor // 🟢 Kirim plat nomor asli dari database
            );
        }

        // 2. PROSES LOGIN SECURITY
        if (securityOpt.isPresent()) {
            Security security = securityOpt.get();
            
            if (!passwordEncoder.matches(password, security.getPassword())) {
                throw new RuntimeException("Password salah");
            }
            
            String token = jwtTokenProvider.generateToken(security.getNip());
            
            return new LoginResponse(
                security.getId(),
                security.getFullName(),
                token,
                security.getRole(),
                "-"
            );
        }

        throw new RuntimeException("Akun tidak ditemukan di sistem");
    }
}