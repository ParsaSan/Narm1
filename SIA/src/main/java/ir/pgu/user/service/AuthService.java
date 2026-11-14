package ir.pgu.user.service;

import ir.pgu.profile.model.StudentProfile;
import ir.pgu.profile.repository.StudentProfileRepository;
import ir.pgu.user.dto.AuthResponse;
import ir.pgu.user.dto.LoginRequest;
import ir.pgu.user.dto.RegisterRequest;
import ir.pgu.user.model.User;
import ir.pgu.user.repository.UserRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final StudentProfileRepository profileRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public AuthService(UserRepository userRepository,
                       StudentProfileRepository profileRepository,
                       BCryptPasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.profileRepository = profileRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public boolean isStudentNumberTaken(String studentNumber) {
        return userRepository.existsByStudentNumber(studentNumber);
    }

    @Transactional
    public void register(RegisterRequest request) {

        if (isStudentNumberTaken(request.getStudentNumber())) {
            throw new RuntimeException("Student number already exists");
        }

        if (request.getPhoneNumber() != null && !request.getPhoneNumber().isBlank()) {
            if (userRepository.existsByPhoneNumber(request.getPhoneNumber())) {
                throw new RuntimeException("Phone number already exists");
            }
        }

        User user = new User();
        user.setFirstName(request.getFirstName());
        user.setLastName(request.getLastName());
        user.setStudentNumber(request.getStudentNumber());
        user.setPhoneNumber(request.getPhoneNumber());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user = userRepository.save(user);

        StudentProfile profile = new StudentProfile();
        profile.setUser(user);
        profile.setStudentType("دانشجوی رسمی");
        profile.setEducationStatus("در حال تحصیل");
        profile.setEntryYear(0);
        profile.setGpa(0);
        profile.setPhone(request.getPhoneNumber());
        profileRepository.save(profile);
    }

    public AuthResponse login(LoginRequest request) {

        User user = userRepository.findByStudentNumber(request.getIdentifier())
                .or(() -> userRepository.findByPhoneNumber(request.getIdentifier()))
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid password");
        }

        return new AuthResponse(
                user.getId(),
                user.getFirstName(),
                user.getLastName(),
                user.getStudentNumber()
        );
    }
}