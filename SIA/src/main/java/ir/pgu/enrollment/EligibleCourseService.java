package ir.pgu.enrollment;

import ir.pgu.course.dto.CourseResponse;
import ir.pgu.course.model.Course;
import ir.pgu.profile.model.AcademicStatus;
import ir.pgu.profile.repository.EnrolledCourseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class EligibleCourseService {

    public static final List<AcademicStatus> ELIGIBLE =
            List.of(AcademicStatus.PASSED, AcademicStatus.CURRENT);

    private final EnrolledCourseRepository enrolledRepository;

    /** دروس مجاز برای آپلود جزوه */
    public List<CourseResponse> getEligibleCourses(Long userId) {
        return enrolledRepository
                .findByStudentUserIdAndAcademicStatusIn(userId, ELIGIBLE)
                .stream()
                .map(e -> {
                    Course c = e.getCourse();
                    return new CourseResponse(
                            c.getId(), c.getCode(), c.getTitle(), c.getEnglishTitle(),
                            c.getDescription(), c.getUnits(), c.getType(),
                            c.getInstructor(), true);
                })
                .toList();
    }

    /** برای استفاده‌ی Sanaz توی POST /api/resources */
    public boolean isEligible(Long userId, Long courseId) {
        return enrolledRepository
                .existsByStudentUserIdAndCourseIdAndAcademicStatusIn(userId, courseId, ELIGIBLE);
    }
}