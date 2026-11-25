package ir.pgu.profile.service;

import ir.pgu.course.model.Course;
import ir.pgu.profile.dto.EnrolledCourseDto;
import ir.pgu.profile.dto.ProfileResponse;
import ir.pgu.profile.dto.UpdateProfileRequest;
import ir.pgu.profile.model.StudentProfile;
import ir.pgu.profile.repository.EnrolledCourseRepository;
import ir.pgu.profile.repository.StudentProfileRepository;
import ir.pgu.user.model.User;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class ProfileService {

    private final StudentProfileRepository studentRepository;
    private final EnrolledCourseRepository enrolledRepository;

    public ProfileService(StudentProfileRepository studentRepository,
                          EnrolledCourseRepository enrolledRepository) {
        this.studentRepository = studentRepository;
        this.enrolledRepository = enrolledRepository;
    }

    @Transactional(readOnly = true)
    public ProfileResponse getProfile(Long userId) {
        return buildResponse(findStudent(userId));
    }

    @Transactional
    public ProfileResponse updateProfile(Long userId, UpdateProfileRequest req) {
        StudentProfile s = findStudent(userId);
        // فقط این سه فیلد قابل ویرایش‌اند؛ نام و شماره دانشجویی عمداً دست نمی‌خورند
        s.setPhone(req.getPhone());
        s.setPersonalEmail(req.getPersonalEmail());
        s.setBio(req.getBio());
        studentRepository.save(s);
        return buildResponse(s);
    }

    private StudentProfile findStudent(Long userId) {
        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "شناسه کاربر ارسال نشده است");
        }
        return studentRepository.findByUserId(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "دانشجو پیدا نشد"));
    }

    private ProfileResponse buildResponse(StudentProfile s) {
        User u = s.getUser();
        String fullName = ((u.getFirstName() == null ? "" : u.getFirstName()) + " "
                + (u.getLastName() == null ? "" : u.getLastName())).trim();

        List<EnrolledCourseDto> courses = buildCourses(s.getId());

        return new ProfileResponse(
                s.getId(), fullName, s.getStudentType(), u.getStudentNumber(),
                s.getMajor(), s.getUniversityEmail(), s.getEntryYear(), s.getGpa(),
                s.getEducationStatus(), s.getPhone(), s.getPersonalEmail(), s.getBio(),
                courses.size(), courses);
    }

    // نام، مدرس و واحد مستقیم از رابطه‌ی course خوانده می‌شود
    private List<EnrolledCourseDto> buildCourses(Long studentId) {
        return enrolledRepository.findByStudentId(studentId).stream()
                .map(e -> {
                    Course c = e.getCourse();
                    return new EnrolledCourseDto(
                            c.getId(),
                            c.getTitle(),
                            c.getInstructor(),
                            c.getUnits() == null ? 0 : c.getUnits(),
                            e.getMembershipStatus());
                })
                .toList();
    }
}