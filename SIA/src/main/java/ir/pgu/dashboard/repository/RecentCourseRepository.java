package ir.pgu.dashboard.repository;

import ir.pgu.dashboard.model.RecentCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RecentCourseRepository extends JpaRepository<RecentCourse, Long> {

    // دریافت ۳ درس آخر بر اساس جدیدترین زمان بازدید
    List<RecentCourse> findTop3ByOrderByLastVisitedAtDesc();
}