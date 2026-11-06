package ir.pgu.profile.dto;

public record EnrolledCourseDto(
        Long courseId,
        String title,
        String instructorName,
        int units,
        String membershipStatus
) {

}