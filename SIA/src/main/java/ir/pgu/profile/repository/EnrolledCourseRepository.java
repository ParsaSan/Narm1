package ir.pgu.profile.repository;

import ir.pgu.profile.model.AcademicStatus;
import ir.pgu.profile.model.EnrolledCourse;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface EnrolledCourseRepository extends JpaRepository<EnrolledCourse, Long> {
    List<EnrolledCourse> findByStudentId(Long studentId);

    boolean existsByStudentUserIdAndCourseId(Long userId, Long courseId);
    List<EnrolledCourse> findByStudentUserId(Long userId);

    // جدید
    Optional<EnrolledCourse> findByStudentUserIdAndCourseId(Long userId, Long courseId);

    List<EnrolledCourse> findByStudentUserIdAndAcademicStatusIn(
            Long userId, Collection<AcademicStatus> statuses);

    boolean existsByStudentUserIdAndCourseIdAndAcademicStatusIn(
            Long userId, Long courseId, Collection<AcademicStatus> statuses);
}