package ir.pgu.enrollment;

import java.util.List;

public interface CourseSource {

    List<EnrolledCourseInfo> fetchEnrolledCourses(String studentNumber);
}