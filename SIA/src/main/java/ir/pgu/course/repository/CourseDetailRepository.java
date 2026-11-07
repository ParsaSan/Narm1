package ir.pgu.course.repository;

import ir.pgu.course.model.CourseDetail;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CourseDetailRepository extends JpaRepository<CourseDetail, Long> {
}