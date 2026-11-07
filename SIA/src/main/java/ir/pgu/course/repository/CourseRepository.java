package ir.pgu.course.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import ir.pgu.course.model.Course;

import java.util.List;

@Repository
public interface CourseRepository extends JpaRepository<Course, Long> {

    // فیلتر بر اساس نوع درس
    List<Course> findByType(String type);

    // جستجو بر اساس نام، نام انگلیسی، کد یا استاد
    List<Course> findByTitleContainingIgnoreCaseOrEnglishTitleContainingIgnoreCaseOrCodeContainingIgnoreCaseOrInstructorContainingIgnoreCase(
            String title, String englishTitle, String code, String instructor
    );
}