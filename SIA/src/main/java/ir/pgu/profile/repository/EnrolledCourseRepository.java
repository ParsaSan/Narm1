package ir.pgu.profile.repository;

import ir.pgu.profile.model.EnrolledCourse;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EnrolledCourseRepository extends JpaRepository<EnrolledCourse, Long> {
    List<EnrolledCourse> findByStudentId(Long studentId);
}