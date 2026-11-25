package ir.pgu.config;

import ir.pgu.enrollment.EnrollmentSyncService;
import ir.pgu.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Component
@Order(3)   // بعد از CourseDataInitializer (1) و CourseDetailInitializer (2)
@Profile("!prod")
@RequiredArgsConstructor
public class EnrollmentInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final EnrollmentSyncService syncService;

    @Override
    public void run(String... args) {
        userRepository.findAll()
                .forEach(u -> syncService.syncStudent(u.getStudentNumber()));
        System.out.println(">>> ثبت‌نام درس‌های دانشجویان همگام‌سازی شد.");
    }
}