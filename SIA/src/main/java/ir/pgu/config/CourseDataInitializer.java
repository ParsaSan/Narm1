package ir.pgu.config;

import ir.pgu.course.dto.model.Course;
import ir.pgu.course.dto.repository.CourseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class CourseDataInitializer implements CommandLineRunner {

    private final CourseRepository courseRepository;

    @Override
    public void run(String... args) {
        // اگر قبلاً دیتابیس خالی بوده باشد، درس‌ها را ثبت می‌کند
        if (courseRepository.count() == 0) {
            List<Course> defaultCourses = List.of(
                // ۱. مهندسی نرم‌افزار ۱
                new Course(
                    null,
                    "110711306",
                    "مهندسی نرم‌افزار ۱",
                    "Software Engineering I",
                    "آشنایی با متدولوژی‌های چابک (Agile)، چرخه حیات نرم‌افزار، تحلیل نیازمندی‌ها، مدل‌سازی با UML و اصول معماری نرم‌افزار.",
                    3,
                    "تخصصی",
                    "ابراهیم صحافی زاده",
                    true
                ),

                // ۲. طراحی پایگاه داده‌ها
                new Course(
                    null,
                    "110711308",
                    "طراحی پایگاه داده‌ها",
                    "Database Design",
                    "مفاهیم بنیادی سیستم‌های مدیریت پایگاه داده رابطه‌ای، مدل‌سازی داده با ER، جبر رابطه‌ای، زبان SQL و اصول نرمال‌سازی.",
                    3,
                    "تخصصی",
                    "سعید طلعتیان آزاد",
                    true
                ),

                // ۳. سیستم‌های عامل
                new Course(
                    null,
                    "110711305",
                    "سیستم‌های عامل",
                    "Operating Systems",
                    "بررسی ساختار سیستم‌عامل، مدیریت پردازه‌ها و نخ‌ها، الگوریتم‌های زمان‌بندی CPU، همگام‌سازی، بن‌بست و مدیریت حافظه.",
                    3,
                    "تخصصی",
                    "مریم روشن",
                    true
                ),

                // ۴. طراحی کامپایلرها
                new Course(
                    null,
                    "110711309",
                    "طراحی کامپایلرها",
                    "Compiler Design",
                    "ساختار کلی کامپایلرها، تحلیل لغوی (Lexical)، تجزیه نحوی (Parsing)، تحلیل معنایی و اصول تولید و بهینه‌سازی کدهای میانی.",
                    3,
                    "تخصصی",
                    "حبیب رستمی",
                    false
                ),

                // ۵. طراحی الگوریتم‌ها
                new Course(
                    null,
                    "1107015",
                    "طراحی الگوریتم‌ها",
                    "Design and Analysis of Algorithms",
                    "تحلیل پیچیدگی زمانی و مکانی مجانبی، روش تقسیم و حل، روش‌های حریصانه، برنامه‌نویسی پویا و الگوریتم‌های پیشرفته گراف.",
                    3,
                    "تخصصی",
                    "حبیب رستمی",
                    false
                ),

                // ۶. زبان تخصصی
                new Course(
                    null,
                    "1107009",
                    "زبان تخصصی",
                    "Technical English for Computer Engineers",
                    "مطالعه و ترجمه متون پیشرفته مهندسی کامپیوتر، درک اصطلاحات فنی نرم‌افزار و شبکه، و اصول نگارش مستندات علمی و فنی.",
                    2,
                    "تخصصی",
                    "سعید طلعتیان آزاد",
                    false
                )
            );

            courseRepository.saveAll(defaultCourses);
            System.out.println(">>> دروس دانشگاهی با موفقیت در دیتابیس بارگذاری شدند.");
        }
    }
}