package ir.pgu.enrollment;

import java.util.List;

public interface CourseSource {

    List<String> fetchEnrolledCourseCodes(String studentNumber);
}