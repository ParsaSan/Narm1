package ir.pgu.profile.dto;

import java.util.List;

public record ProfileResponse(
        Long id,
        String fullName,
        String studentType,
        String studentNumber,
        String major,
        String universityEmail,
        int entryYear,
        double gpa,
        String educationStatus,
        String phone,
        String personalEmail,
        String bio,
        int enrolledCoursesCount,
        List<EnrolledCourseDto> enrolledCourses
) {

}