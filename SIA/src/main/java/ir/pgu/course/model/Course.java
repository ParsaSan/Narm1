package ir.pgu.course.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "courses")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // کد درس مثل CE-401
    @Column(nullable = false, unique = true)
    private String code;

    // عنوان درس
    @Column(nullable = false)
    private String title;

    // عنوان انگلیسی
    private String englishTitle;

    // توضیحات کامل درس
    @Column(length = 1000)
    private String description;

    // تعداد واحد
    private Integer units;

    // نوع درس (تخصصی، پایه، عمومی)
    private String type;

    // نام استاد
    private String instructor;

    // وضعیت ثبت‌نام
    private Boolean isEnrolled = false;
}