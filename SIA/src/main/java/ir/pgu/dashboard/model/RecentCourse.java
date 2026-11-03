package ir.pgu.dashboard.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "recent_courses")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecentCourse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // نام درس
    private String title;

    // نام استاد درس
    private String instructor;

    // تاریخ و ساعت آخرین بازدید دانشجو
    private LocalDateTime lastVisitedAt;
}