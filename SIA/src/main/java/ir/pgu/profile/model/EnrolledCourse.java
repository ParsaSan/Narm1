package ir.pgu.profile.model;

import jakarta.persistence.*;

@Entity
@Table(name = "profile_enrolled_courses")
public class EnrolledCourse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "student_id")
    private Long studentId;

    private Long courseId;
    private String title;
    private String instructorName;
    private int units;
    private String membershipStatus;   // «عضو فعال»

    public Long getId() { return id; }
    public Long getStudentId() { return studentId; }
    public Long getCourseId() { return courseId; }
    public String getTitle() { return title; }
    public String getInstructorName() { return instructorName; }
    public int getUnits() { return units; }
    public String getMembershipStatus() { return membershipStatus; }

    public void setId(Long id) { this.id = id; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }
    public void setTitle(String title) { this.title = title; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }
    public void setUnits(int units) { this.units = units; }
    public void setMembershipStatus(String membershipStatus) { this.membershipStatus = membershipStatus; }
}