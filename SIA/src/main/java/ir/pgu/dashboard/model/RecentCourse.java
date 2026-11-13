package ir.pgu.dashboard.model;

import jakarta.persistence.Entity;
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

    // شناسه این درس دقیقاً همان شناسه واقعی جدول اصلی دروس است
    @Id
    private Long id;

    private String title;
    private String instructor;
    private LocalDateTime lastVisitedAt;
}