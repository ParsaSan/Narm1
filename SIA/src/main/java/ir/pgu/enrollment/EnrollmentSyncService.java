package ir.pgu.enrollment;

import ir.pgu.course.model.Course;
import ir.pgu.course.repository.CourseRepository;
import ir.pgu.profile.model.EnrolledCourse;
import ir.pgu.profile.model.StudentProfile;
import ir.pgu.profile.repository.EnrolledCourseRepository;
import ir.pgu.profile.repository.StudentProfileRepository;
import ir.pgu.user.model.User;
import ir.pgu.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class EnrollmentSyncService {

    private final CourseSource courseSource;
    private final UserRepository userRepository;
    private final StudentProfileRepository profileRepository;
    private final CourseRepository courseRepository;
    private final EnrolledCourseRepository enrolledRepository;

    @Transactional
    public void syncStudent(String studentNumber) {
        User user = userRepository.findByStudentNumber(studentNumber).orElse(null);
        if (user == null) {
            return;
        }

        StudentProfile profile = profileRepository.findByUserId(user.getId()).orElse(null);
        if (profile == null) {
            return; // پروفایل ندارد، چیزی برای sync نیست
        }

        List<String> codes = courseSource.fetchEnrolledCourseCodes(studentNumber);
        if (codes.isEmpty()) {
            return;
        }
        Set<String> codeSet = Set.copyOf(codes);

        for (Course course : courseRepository.findAll()) {
            if (!codeSet.contains(course.getCode())) {
                continue;
            }
            boolean exists = enrolledRepository
                    .existsByStudentUserIdAndCourseId(user.getId(), course.getId());
            if (!exists) {
                EnrolledCourse e = new EnrolledCourse();
                e.setStudent(profile);
                e.setCourse(course);
                e.setMembershipStatus("عضو فعال");
                enrolledRepository.save(e);
            }
        }
    }
}