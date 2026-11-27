package ir.pgu.resource.seed;

import ir.pgu.course.model.Course;
import ir.pgu.course.repository.CourseRepository;
import ir.pgu.resource.model.Resource;
import ir.pgu.resource.model.Visibility;
import ir.pgu.resource.repository.ResourceRepository;
import ir.pgu.user.model.User;
import ir.pgu.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Slf4j
@Component
@Order(100)
@RequiredArgsConstructor
public class ResourceDataSeeder implements CommandLineRunner {

    private final ResourceRepository resourceRepository;
    private final CourseRepository courseRepository;
    private final UserRepository userRepository;

    @Value("${app.upload.dir:uploads/resources}")
    private String uploadDir;

    @Override
    public void run(String... args) {
        if (resourceRepository.count() > 0) {
            return;
        }

        List<Course> courses = courseRepository.findAll();
        List<User> users = userRepository.findAll();
        if (courses.isEmpty() || users.isEmpty()) {
            log.warn("ResourceDataSeeder skipped: courses or users table is empty.");
            return;
        }

        User user1 = users.get(0);
        User user2 = users.size() > 1 ? users.get(1) : user1;
        Course course1 = courses.get(0);
        Course course2 = courses.size() > 1 ? courses.get(1) : course1;

        seedItem(course1, user1, "جزوه کامل فصل اول و دوم", "جزوه", "seed-note-1.pdf", "PDF", Visibility.PUBLIC);
        seedItem(course1, user2, "نمونه سوال میان‌ترم سال گذشته", "نمونه سوال", "seed-exam-2.pdf", "PDF", Visibility.PUBLIC);
        seedItem(course2, user1, "اسلایدهای جمع‌بندی کلاس", "اسلاید", "seed-slides-3.pdf", "PDF", Visibility.PUBLIC);
        seedItem(course2, user1, "خلاصه شخصی برای امتحان", "خلاصه", "seed-private-4.pdf", "PDF", Visibility.PRIVATE);

        log.info("4 sample resources seeded successfully.");
    }

    private void seedItem(Course course, User uploader, String title, String resourceType,
                          String fileName, String fileType, Visibility visibility) {
        byte[] samplePdfBytes = minimalPdfBytes(title);
        writeSampleFileIfAbsent(fileName, samplePdfBytes);

        Resource r = new Resource();
        r.setCourse(course);
        r.setUploader(uploader);
        r.setTitle(title);
        r.setResourceType(resourceType);
        r.setFileUrl(fileName);
        r.setFileType(fileType);
        r.setFileSize(samplePdfBytes.length);
        r.setVisibility(visibility);
        r.setFileValidated(true);

        resourceRepository.save(r);
    }

    private void writeSampleFileIfAbsent(String fileName, byte[] bytes) {
        try {
            Path root = Paths.get(uploadDir).toAbsolutePath().normalize();
            Files.createDirectories(root);
            Path target = root.resolve(fileName).normalize();
            if (target.startsWith(root) && Files.notExists(target)) {
                Files.write(target, bytes);
            }
        } catch (IOException e) {
            log.warn("Could not write sample seed file {}: {}", fileName, e.getMessage());
        }
    }

    private byte[] minimalPdfBytes(String title) {
        String content = "%PDF-1.4\n1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj\n"
                + "2 0 obj << /Type /Pages /Kids [3 0 R] /Count 1 >> endobj\n"
                + "3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 300 144] >> endobj\n"
                + "trailer << /Root 1 0 R >>\n%% " + title + "\n%%EOF";
        return content.getBytes(StandardCharsets.UTF_8);
    }
}