package ir.pgu.course.dto;

import java.util.List;

public record CourseDetailResponse(
        Long id,
        String code,
        String title,
        String instructor,
        int units,
        String schedule,
        String location,
        String about,
        List<String> chapters
) {
}