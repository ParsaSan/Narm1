package ir.pgu.dashboard.controller;

import ir.pgu.dashboard.model.Banner;
import ir.pgu.dashboard.model.DashboardStats;
import ir.pgu.dashboard.model.RecentCourse;
import ir.pgu.dashboard.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/dashboard")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    // ۱. دریافت آمار اولیه سامانه
    @GetMapping("/stats")
    public DashboardStats getStats() {
        return dashboardService.getBasicStats();
    }

    // ۲. دریافت بنرهای صفحه خانه
    @GetMapping("/banners")
    public List<Banner> getBanners() {
        return dashboardService.getAllBanners();
    }

    // ۳. دریافت ۳ درس اخیراً بازدیدشده کاربر
    @GetMapping("/recent-courses")
    public List<RecentCourse> getRecentCourses() {
        return dashboardService.getRecentCourses();
    }
}