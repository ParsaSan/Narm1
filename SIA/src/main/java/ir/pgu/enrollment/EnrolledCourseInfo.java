package ir.pgu.enrollment;


import ir.pgu.profile.model.AcademicStatus;


public record EnrolledCourseInfo(String courseCode, AcademicStatus status) {}