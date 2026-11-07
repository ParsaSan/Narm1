package ir.pgu.course.service;

import ir.pgu.course.model.Course;
import ir.pgu.course.repository.CourseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CourseService {

    private final CourseRepository courseRepository;

    // دریافت لیست دروس (با امکان جستجو و فیلتر)
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

    // دریافت اطلاعات یک درس با شناسه
    public Optional<Course> getCourseById(Long id) {
        return courseRepository.findById(id);
    }

    // ذخیره یا افزودن درس جدید
    public Course saveCourse(Course course) {
        return courseRepository.save(course);
    }
}