package ir.pgu.enrollment;

import ir.pgu.course.model.Course;
import ir.pgu.course.repository.CourseRepository;
import ir.pgu.profile.model.AcademicStatus;
import ir.pgu.profile.model.EnrolledCourse;
import ir.pgu.profile.model.StudentProfile;
import ir.pgu.profile.repository.EnrolledCourseRepository;
import ir.pgu.profile.repository.StudentProfileRepository;
import ir.pgu.user.model.User;
import ir.pgu.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class EnrollmentSyncService {

    private static final String ACTIVE_STATUS = "عضو فعال";
    private static final String PASSED_STATUS = "گذرانده";

    private final CourseSource courseSource;
    private final UserRepository userRepository;
    private final StudentProfileRepository profileRepository;
    private final CourseRepository courseRepository;
    private final EnrolledCourseRepository enrolledRepository;

    @Transactional
    public void syncStudent(String studentNumber) {
        User user = userRepository.findByStudentNumber(studentNumber).orElse(null);
        if (user == null) return;

        StudentProfile profile = profileRepository.findByUserId(user.getId()).orElse(null);
        if (profile == null) return;

        List<EnrolledCourseInfo> infos = courseSource.fetchEnrolledCourses(studentNumber);
        if (infos.isEmpty()) return;

        Map<String, AcademicStatus> statusByCode = new HashMap<>();
        for (EnrolledCourseInfo i : infos) {
            statusByCode.put(i.courseCode(), i.status());
        }

        for (Course course : courseRepository.findAll()) {
            AcademicStatus status = statusByCode.get(course.getCode());
            if (status == null) continue;

            EnrolledCourse enrolled = enrolledRepository
                    .findByStudentUserIdAndCourseId(user.getId(), course.getId())
                    .orElseGet(EnrolledCourse::new);

            enrolled.setStudent(profile);
            enrolled.setCourse(course);
            enrolled.setAcademicStatus(status);
            enrolled.setMembershipStatus(
                    status == AcademicStatus.PASSED ? PASSED_STATUS : ACTIVE_STATUS);
            enrolledRepository.save(enrolled);
        }
    }
}