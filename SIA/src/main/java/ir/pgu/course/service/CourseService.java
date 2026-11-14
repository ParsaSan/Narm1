package ir.pgu.course.service;

import ir.pgu.course.dto.CourseResponse;
import ir.pgu.course.model.Course;
import ir.pgu.course.repository.CourseRepository;
import ir.pgu.profile.repository.EnrolledCourseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseService {

    private final CourseRepository courseRepository;
    private final EnrolledCourseRepository enrolledCourseRepository;

    public List<Course> getCourses(String type, String search) {
        if (search != null && !search.trim().isEmpty()) {
            return courseRepository.findByTitleContainingIgnoreCaseOrEnglishTitleContainingIgnoreCaseOrCodeContainingIgnoreCaseOrInstructorContainingIgnoreCase(
                    search, search, search, search
            );
        }

        if (type != null && !type.equals("همه") && !type.trim().isEmpty()) {
            return courseRepository.findByType(type);
        }

        return courseRepository.findAll();
    }

    public List<CourseResponse> getCoursesForUser(String type, String search, Long userId) {
        List<Course> courses = getCourses(type, search);

        Set<Long> enrolledCourseIds = (userId == null || userId <= 0)
                ? Set.of()
                : enrolledCourseRepository.findByStudentUserId(userId).stream()
                        .map(e -> e.getCourse().getId())
                        .collect(Collectors.toSet());

        return courses.stream()
                .map(c -> new CourseResponse(
                        c.getId(),
                        c.getCode(),
                        c.getTitle(),
                        c.getEnglishTitle(),
                        c.getDescription(),
                        c.getUnits(),
                        c.getType(),
                        c.getInstructor(),
                        enrolledCourseIds.contains(c.getId())
                ))
                .toList();
    }

    public Optional<Course> getCourseById(Long id) {
        return courseRepository.findById(id);
    }

    public Course saveCourse(Course course) {
        return courseRepository.save(course);
    }
}