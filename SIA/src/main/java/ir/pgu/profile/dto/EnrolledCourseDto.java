package ir.pgu.profile.dto;

public class EnrolledCourseDto {

    private final Long courseId;
    private final String title;
    private final String instructorName;
    private final int units;
    private final String membershipStatus;

    public EnrolledCourseDto(Long courseId, String title, String instructorName,
                             int units, String membershipStatus) {
        this.courseId = courseId;
        this.title = title;
        this.instructorName = instructorName;
        this.units = units;
        this.membershipStatus = membershipStatus;
    }

    public Long getCourseId() { return courseId; }
    public String getTitle() { return title; }
    public String getInstructorName() { return instructorName; }
    public int getUnits() { return units; }
    public String getMembershipStatus() { return membershipStatus; }
}