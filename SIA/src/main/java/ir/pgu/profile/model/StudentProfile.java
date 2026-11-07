package ir.pgu.profile.model;

import jakarta.persistence.*;

@Entity
@Table(name = "student_profiles")
public class StudentProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String fullName;
    private String studentType;
    private String studentNumber;
    private String major;
    private String universityEmail;
    private int entryYear;
    private double gpa;
    private String educationStatus;

    // فیلدهای قابل ویرایش
    private String phone;
    private String personalEmail;

    @Column(length = 500)
    private String bio;

    public Long getId() { return id; }
    public String getFullName() { return fullName; }
    public String getStudentType() { return studentType; }
    public String getStudentNumber() { return studentNumber; }
    public String getMajor() { return major; }
    public String getUniversityEmail() { return universityEmail; }
    public int getEntryYear() { return entryYear; }
    public double getGpa() { return gpa; }
    public String getEducationStatus() { return educationStatus; }
    public String getPhone() { return phone; }
    public String getPersonalEmail() { return personalEmail; }
    public String getBio() { return bio; }

    public void setId(Long id) { this.id = id; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setStudentType(String studentType) { this.studentType = studentType; }
    public void setStudentNumber(String studentNumber) { this.studentNumber = studentNumber; }
    public void setMajor(String major) { this.major = major; }
    public void setUniversityEmail(String universityEmail) { this.universityEmail = universityEmail; }
    public void setEntryYear(int entryYear) { this.entryYear = entryYear; }
    public void setGpa(double gpa) { this.gpa = gpa; }
    public void setEducationStatus(String educationStatus) { this.educationStatus = educationStatus; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setPersonalEmail(String personalEmail) { this.personalEmail = personalEmail; }
    public void setBio(String bio) { this.bio = bio; }
}