package ir.pgu.dashboard.repository;

import ir.pgu.dashboard.model.RecentCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RecentCourseRepository extends JpaRepository<RecentCourse, Long> {

    List<RecentCourse> findTop3ByOrderByLastVisitedAtDesc();

    Optional<RecentCourse> findByTitle(String title);
}