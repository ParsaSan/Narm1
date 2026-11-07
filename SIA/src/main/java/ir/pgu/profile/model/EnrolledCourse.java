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

    @Column(name = "course_id")
    private Long courseId;

    private String membershipStatus;   // «عضو فعال»

    public Long getId() { return id; }
    public Long getStudentId() { return studentId; }
    public Long getCourseId() { return courseId; }
    public String getMembershipStatus() { return membershipStatus; }

    public void setId(Long id) { this.id = id; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }
    public void setMembershipStatus(String membershipStatus) { this.membershipStatus = membershipStatus; }
}