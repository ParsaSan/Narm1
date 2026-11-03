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

        if (recentCourseRepository.count() == 0) {
            recentCourseRepository.save(new RecentCourse(null, "برنامه‌نویسی پیشرفته", "حبیب رستمی", LocalDateTime.now().minusHours(1)));
            recentCourseRepository.save(new RecentCourse(null, "ساختمان داده‌ها", "ابراهیم صحافی زاده", LocalDateTime.now().minusHours(4)));
            recentCourseRepository.save(new RecentCourse(null, "طراحی الگوریتم", "حبیب رستمی", LocalDateTime.now().minusDays(1)));
        }
    }

    public List<Banner> getAllBanners() {
        return bannerRepository.findAll();
    }

    public List<RecentCourse> getRecentCourses() {
        return recentCourseRepository.findTop3ByOrderByLastVisitedAtDesc();
    }

    public DashboardStats getBasicStats() {
        long totalCourses = recentCourseRepository.count();
        long totalFiles = 24;
        long totalStudents = 180;
        return new DashboardStats(totalCourses, totalFiles, totalStudents);
    }
}