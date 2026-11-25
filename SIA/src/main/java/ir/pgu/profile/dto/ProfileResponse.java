package ir.pgu.profile.dto;

import java.util.List;

public class ProfileResponse {

    private final Long id;
    private final String fullName;
    private final String studentType;
    private final String studentNumber;
    private final String major;
    private final String universityEmail;
    private final int entryYear;
    private final double gpa;
    private final String educationStatus;
    private final String phone;
    private final String personalEmail;
    private final String bio;
    private final int enrolledCoursesCount;
    private final List<EnrolledCourseDto> enrolledCourses;

    public ProfileResponse(Long id, String fullName, String studentType, String studentNumber,
                           String major, String universityEmail, int entryYear, double gpa,
                           String educationStatus, String phone, String personalEmail, String bio,
                           int enrolledCoursesCount, List<EnrolledCourseDto> enrolledCourses) {
        this.id = id;
        this.fullName = fullName;
        this.studentType = studentType;
        this.studentNumber = studentNumber;
        this.major = major;
        this.universityEmail = universityEmail;
        this.entryYear = entryYear;
        this.gpa = gpa;
        this.educationStatus = educationStatus;
        this.phone = phone;
        this.personalEmail = personalEmail;
        this.bio = bio;
        this.enrolledCoursesCount = enrolledCoursesCount;
        this.enrolledCourses = enrolledCourses;
    }

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
    public int getEnrolledCoursesCount() { return enrolledCoursesCount; }
    public List<EnrolledCourseDto> getEnrolledCourses() { return enrolledCourses; }
}