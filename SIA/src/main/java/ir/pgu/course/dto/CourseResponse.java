package ir.pgu.course.dto;

public record CourseResponse(
        Long id,
        String code,
        String title,
        String englishTitle,
        String description,
        Integer units,
        String type,
        String instructor,
        boolean enrolled
) {
}