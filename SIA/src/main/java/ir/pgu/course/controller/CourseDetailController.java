package ir.pgu.course.controller;

import ir.pgu.course.dto.CourseDetailResponse;
import ir.pgu.course.model.Course;
import ir.pgu.course.model.CourseDetail;
import ir.pgu.course.repository.CourseDetailRepository;
import ir.pgu.course.repository.CourseRepository;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.Arrays;
import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/course-details")
public class CourseDetailController {

    private final CourseRepository courseRepository;
    private final CourseDetailRepository detailRepository;

    public CourseDetailController(CourseRepository courseRepository,
                                  CourseDetailRepository detailRepository) {
        this.courseRepository = courseRepository;
        this.detailRepository = detailRepository;
    }

    @GetMapping("/{id}")
    public CourseDetailResponse get(@PathVariable Long id) {
        Course c = courseRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "درس پیدا نشد"));
        CourseDetail d = detailRepository.findById(id).orElse(null);

        List<String> chapters = (d == null || d.getChapters() == null || d.getChapters().isBlank())
                ? List.of()
                : Arrays.stream(d.getChapters().split("\n"))
                        .map(String::trim)
                        .filter(s -> !s.isEmpty())
                        .toList();

        String courseDescription = c.getDescription() == null ? "" : c.getDescription();
        String about = (d == null || d.getAbout() == null || d.getAbout().isBlank())
                ? courseDescription
                : d.getAbout();

        return new CourseDetailResponse(
                c.getId(),
                c.getCode(),
                c.getTitle(),
                c.getInstructor(),
                c.getUnits() == null ? 0 : c.getUnits(),
                d == null ? "" : nz(d.getSchedule()),
                d == null ? "" : nz(d.getLocation()),
                about,
                chapters);
    }

    private static String nz(String s) {
        return s == null ? "" : s;
    }
}