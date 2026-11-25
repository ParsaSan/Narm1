package ir.pgu.course.dto;

import java.util.List;

public class CourseDetailResponse {

    private final Long id;
    private final String code;
    private final String title;
    private final String instructor;
    private final int units;
    private final String schedule;
    private final String location;
    private final String about;
    private final List<String> chapters;
    private final boolean enrolled;

    public CourseDetailResponse(Long id, String code, String title, String instructor,
                                int units, String schedule, String location, String about,
                                List<String> chapters, boolean enrolled) {
        this.id = id;
        this.code = code;
        this.title = title;
        this.instructor = instructor;
        this.units = units;
        this.schedule = schedule;
        this.location = location;
        this.about = about;
        this.chapters = chapters;
        this.enrolled = enrolled;
    }

    public Long getId() { return id; }
    public String getCode() { return code; }
    public String getTitle() { return title; }
    public String getInstructor() { return instructor; }
    public int getUnits() { return units; }
    public String getSchedule() { return schedule; }
    public String getLocation() { return location; }
    public String getAbout() { return about; }
    public List<String> getChapters() { return chapters; }
    public boolean isEnrolled() { return enrolled; }
}