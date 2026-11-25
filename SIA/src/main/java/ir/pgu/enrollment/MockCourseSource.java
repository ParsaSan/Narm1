package ir.pgu.enrollment;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
@Profile("!prod")
public class MockCourseSource implements CourseSource {

    private static final Map<String, List<String>> DATA = Map.of(
            "4030711384", List.of(
                    "110711306",
                    "110711308",
                    "110711305",
                    "1107009",
                    "1107015",
                    "1107012")
    );

    @Override
    public List<String> fetchEnrolledCourseCodes(String studentNumber) {
        return DATA.getOrDefault(studentNumber, List.of());
    }
}