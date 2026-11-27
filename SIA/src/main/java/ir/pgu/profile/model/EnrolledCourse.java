package ir.pgu.profile.model;

import ir.pgu.course.model.Course;
import jakarta.persistence.*;

@Entity
@Table(name = "profile_enrolled_courses",
       uniqueConstraints = @UniqueConstraint(columnNames = {"student_id", "course_id"}))
public class EnrolledCourse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "student_id")
    private StudentProfile student;

    @ManyToOne(optional = false)
    @JoinColumn(name = "course_id")
    private Course course;

    private String membershipStatus;   // «عضو فعال»

    @Enumerated(EnumType.STRING)
    @Column(name = "academic_status")
    private AcademicStatus academicStatus;

    public Long getId() { return id; }
    public StudentProfile getStudent() { return student; }
    public Course getCourse() { return course; }
    public String getMembershipStatus() { return membershipStatus; }
    public AcademicStatus getAcademicStatus() { return academicStatus; }

    public void setId(Long id) { this.id = id; }
    public void setStudent(StudentProfile student) { this.student = student; }
    public void setCourse(Course course) { this.course = course; }
    public void setMembershipStatus(String membershipStatus) { this.membershipStatus = membershipStatus; }
    public void setAcademicStatus(AcademicStatus academicStatus) { this.academicStatus = academicStatus; }
}