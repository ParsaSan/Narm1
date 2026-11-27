package ir.pgu.enrollment;

import ir.pgu.course.dto.CourseResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/courses/eligible-for-upload")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class EligibleCourseController {

    private final EligibleCourseService service;

    // فعلاً userId از پارامتر می‌آید (مثل بقیه‌ی APIها).
    // وقتی JWT آماده شد، Sanaz از روی توکن کاربر جاری را می‌گیرد.
    @GetMapping
    public List<CourseResponse> get(@RequestParam Long userId) {
        return service.getEligibleCourses(userId);
    }
}