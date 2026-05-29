package parkirki.backend.Service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import parkirki.backend.Dto.KendaraanDto;
import parkirki.backend.Dto.MahasiswaProfileResponse;
import parkirki.backend.Dto.UpdatePasswordRequest;
import parkirki.backend.Entity.Mahasiswa;
import parkirki.backend.Repository.MahasiswaRepository;

@Service
@RequiredArgsConstructor
public class MahasiswaService {

    private final MahasiswaRepository mahasiswaRepository;

    // READ SPECIFIC MAHASISWA
    public MahasiswaProfileResponse getProfileMahasiswa(Long id) {
        Mahasiswa mhs = mahasiswaRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Mahasiswa tidak ditemukan"));

        // Mapping Kendaraan Tunggal (Cek null biar gak error kalau belum punya kendaraan)
        KendaraanDto kDto = null;
        if (mhs.getKendaraan() != null) {
            kDto = new KendaraanDto(
                mhs.getKendaraan().getId(), 
                mhs.getKendaraan().getPlatNomor(), 
                mhs.getKendaraan().getJenisKendaraan().name()
            );
        }

        // Mapping dari Entity ke DTO biar password gak ikut ke-kirim
        return MahasiswaProfileResponse.builder()
            .id(mhs.getId())
            .fullName(mhs.getFullName())
            .nim(mhs.getNim())
            .kendaraan(kDto) // Masukkan objek tunggal
            .build();
    }

    // UPDATE PASSWORD
    @Transactional
    public void updatePassword(Long id, UpdatePasswordRequest request) {
        Mahasiswa mhs = mahasiswaRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Mahasiswa tidak ditemukan"));

        if (!mhs.getPassword().equals(request.getOldPassword())) {
            throw new RuntimeException("Password lama salah!");
        }

        mhs.setPassword(request.getNewPassword());
        mahasiswaRepository.save(mhs);
    }
}