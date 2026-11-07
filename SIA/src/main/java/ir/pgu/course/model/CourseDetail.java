package ir.pgu.course.model;

import jakarta.persistence.*;

@Entity
@Table(name = "course_details")
public class CourseDetail {

    @Id
    @Column(name = "course_id")
    private Long courseId;

    @Column(length = 500)
    private String schedule;

    private String location;

    @Column(length = 2000)
    private String about;

    // سرفصل‌ها: هر خط یک فصل
    @Column(length = 4000)
    private String chapters;

    public Long getCourseId() { return courseId; }
    public String getSchedule() { return schedule; }
    public String getLocation() { return location; }
    public String getAbout() { return about; }
    public String getChapters() { return chapters; }

    public void setCourseId(Long courseId) { this.courseId = courseId; }
    public void setSchedule(String schedule) { this.schedule = schedule; }
    public void setLocation(String location) { this.location = location; }
    public void setAbout(String about) { this.about = about; }
    public void setChapters(String chapters) { this.chapters = chapters; }
}