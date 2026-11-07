package ir.pgu.course.dto.controller;

import ir.pgu.course.dto.model.Course;
import ir.pgu.course.dto.service.CourseService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/courses")
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // برای رفع خطای اتصال به فلاتر
public class CourseController {

    private final CourseService courseService;

    // دریافت تمام دروس
    @GetMapping
    public ResponseEntity<List<Course>> getCourses(
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String search
    ) {
        return ResponseEntity.ok(courseService.getCourses(type, search));
    }

    // دریافت یک درس خاص با id
    @GetMapping("/{id}")
    public ResponseEntity<Course> getCourseById(@PathVariable Long id) {
        return courseService.getCourseById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // ایجاد یک درس جدید
    @PostMapping
    public ResponseEntity<Course> createCourse(@RequestBody Course course) {
        return ResponseEntity.ok(courseService.saveCourse(course));
    }
}