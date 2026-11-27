package ir.pgu.enrollment;

import java.util.List;

import ir.pgu.profile.model.EnrolledCourse;

public interface CourseSource {

    List<EnrolledCourse> fetchEnrolledCourses(String studentNumber);
}