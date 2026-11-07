package ir.pgu.config;

import ir.pgu.course.repository.CourseRepository;
import ir.pgu.profile.model.EnrolledCourse;
import ir.pgu.profile.model.StudentProfile;
import ir.pgu.profile.repository.EnrolledCourseRepository;
import ir.pgu.profile.repository.StudentProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(3)
@RequiredArgsConstructor
public class ProfileDataInitializer implements CommandLineRunner {

    private final StudentProfileRepository studentRepository;
    private final EnrolledCourseRepository enrolledRepository;
    private final CourseRepository courseRepository;
    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) {
        // ۱. پاکسازی کامل و ریستارت کردن شمارنده آیدی در پستگرس تا آیدی همیشه از ۱ شروع شود
        jdbcTemplate.execute("TRUNCATE TABLE profile_enrolled_courses, student_profiles RESTART IDENTITY CASCADE");

        // ۲. ساخت دانشجو با آیدی تضمین‌شده ۱
        StudentProfile s = new StudentProfile();
        s.setFullName("سارا احمدی");
        s.setStudentType("دانشجوی رسمی");
        s.setStudentNumber("4030711384");
        s.setMajor("مهندسی کامپیوتر - نرم‌افزار");
        s.setUniversityEmail("aut.ac.ir@40123456");
        s.setEntryYear(1401);
        s.setGpa(18.45);
        s.setEducationStatus("در حال تحصیل (مجاز به انتخاب واحد)");
        s.setPhone("09121234567");
        s.setPersonalEmail("sara.ahmadi@gmail.com");
        s.setBio("دانشجوی مهندسی کامپیوتر، علاقه‌مند به توسعه نرم‌افزار");
        s = studentRepository.save(s);

        final Long studentId = s.getId();

        // ۳. ثبت‌نام در دروس ترم جاری
        for (String code : List.of("110711306", "110711308", "110711305")) {
            courseRepository.findAll().stream()
                    .filter(c -> code.equals(c.getCode()))
                    .findFirst()
                    .ifPresent(c -> {
                        EnrolledCourse e = new EnrolledCourse();
                        e.setStudentId(studentId);
                        e.setCourseId(c.getId());
                        e.setMembershipStatus("عضو فعال");
                        enrolledRepository.save(e);
                    });
        }
        System.out.println(">>> اطلاعات پروفایل با آیدی ۱ با موفقیت مقداردهی شد.");
    }
}