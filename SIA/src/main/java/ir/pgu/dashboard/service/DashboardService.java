package ir.pgu.dashboard.service;

import ir.pgu.dashboard.model.Banner;
import ir.pgu.dashboard.model.DashboardStats;
import ir.pgu.dashboard.model.RecentCourse;
import ir.pgu.dashboard.repository.BannerRepository;
import ir.pgu.dashboard.repository.RecentCourseRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DashboardService {

    private final BannerRepository bannerRepository;
    private final RecentCourseRepository recentCourseRepository;

    @PostConstruct
    public void initDefaultData() {
        if (bannerRepository.count() == 0) {
            bannerRepository.save(new Banner(null, "ثبت‌نام نیمسال جدید", "مهلت تا پایان هفته جاری", "https://picsum.photos/600/300", "/register"));
            bannerRepository.save(new Banner(null, "مسابقات برنامه‌نویسی دانشگاه", "جوایز ارزنده برای برترین‌ها", "https://picsum.photos/600/301", "/contest"));
        }
    }

    public List<Banner> getAllBanners() {
        return bannerRepository.findAll();
    }

    public List<RecentCourse> getRecentCourses() {
        return recentCourseRepository.findTop3ByOrderByLastVisitedAtDesc();
    }

    public DashboardStats getBasicStats() {
        int currentTerm = 5;
        int passedUnits = 92;
        int currentTermUnits = 17;
        int currentTermCoursesCount = 6;
        String gpaTrend = "صعودی";
        List<Double> pastTermGpas = List.of(15.5, 16.2, 16.8, 17.1, 17.75);

        return new DashboardStats(
                currentTerm,
                passedUnits,
                currentTermUnits,
                currentTermCoursesCount,
                gpaTrend,
                pastTermGpas
        );
    }

    public RecentCourse recordCourseVisit(Long courseId, String title, String instructor) {
        RecentCourse course = recentCourseRepository.findById(courseId)
                .orElse(new RecentCourse(courseId, title, instructor, LocalDateTime.now()));
        course.setTitle(title);
        course.setInstructor(instructor);
        course.setLastVisitedAt(LocalDateTime.now());
        return recentCourseRepository.save(course);
    }
}