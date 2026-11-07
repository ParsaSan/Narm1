package ir.pgu.profile.config;

import ir.pgu.profile.model.EnrolledCourse;
import ir.pgu.profile.model.StudentProfile;
import ir.pgu.profile.repository.EnrolledCourseRepository;
import ir.pgu.profile.repository.StudentProfileRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

@Component
public class ProfileDataInitializer {

    private final StudentProfileRepository studentRepository;
    private final EnrolledCourseRepository courseRepository;

    public ProfileDataInitializer(StudentProfileRepository studentRepository,
                                  EnrolledCourseRepository courseRepository) {
        this.studentRepository = studentRepository;
        this.courseRepository = courseRepository;
    }

    @PostConstruct
    public void init() {
        if (studentRepository.count() > 0) {
            return;
        }

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

        addCourse(s.getId(), 1L, "مهندسی نرم‌افزار ۱", "استاد: ابراهیم صحافی زاده");
        addCourse(s.getId(), 2L, "پایگاه داده‌ها", "استاد: سعید طلعتیان آزاد");
        addCourse(s.getId(), 3L, "طراحی الگوریتم‌ها", "استاد: حبیب رستمی");
    }

    private void addCourse(Long studentId, Long courseId, String title, String instructor) {
        EnrolledCourse c = new EnrolledCourse();
        c.setStudentId(studentId);
        c.setCourseId(courseId);
        c.setTitle(title);
        c.setInstructorName(instructor);
        c.setUnits(3);
        c.setMembershipStatus("عضو فعال");
        courseRepository.save(c);
    }
}