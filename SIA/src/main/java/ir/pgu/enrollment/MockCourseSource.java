package ir.pgu.enrollment;

import ir.pgu.profile.model.AcademicStatus;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Component
@Profile("!prod")
public class MockCourseSource implements CourseSource {

    private static final List<String> CURRENT_CODES = List.of(
            "110711306", "110711308", "110711305",
            "1107009", "1107015", "1107012");

    // نمونه: دروس پاس‌شده‌ی ترم‌های قبل
    private static final List<String> PASSED_CODES = List.of(
            "1107053", "1107054", "1107005", "1107088", "711301", "110711302", "1107064");

    private static final Map<String, List<EnrolledCourseInfo>> DATA = Map.of(
            "4030711384", build(CURRENT_CODES, PASSED_CODES));

    private static List<EnrolledCourseInfo> build(List<String> current, List<String> passed) {
        List<EnrolledCourseInfo> out = new ArrayList<>();
        current.forEach(c -> out.add(new EnrolledCourseInfo(c, AcademicStatus.CURRENT)));
        passed.forEach(c -> out.add(new EnrolledCourseInfo(c, AcademicStatus.PASSED)));
        return out;
    }

    @Override
    public List<EnrolledCourseInfo> fetchEnrolledCourses(String studentNumber) {
        return DATA.getOrDefault(studentNumber, List.of());
    }
}