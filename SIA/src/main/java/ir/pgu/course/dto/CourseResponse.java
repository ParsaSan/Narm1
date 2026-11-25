package ir.pgu.course.dto;

public class CourseResponse {

    private final Long id;
    private final String code;
    private final String title;
    private final String englishTitle;
    private final String description;
    private final Integer units;
    private final String type;
    private final String instructor;
    private final boolean enrolled;

    public CourseResponse(Long id, String code, String title, String englishTitle,
                          String description, Integer units, String type,
                          String instructor, boolean enrolled) {
        this.id = id;
        this.code = code;
        this.title = title;
        this.englishTitle = englishTitle;
        this.description = description;
        this.units = units;
        this.type = type;
        this.instructor = instructor;
        this.enrolled = enrolled;
    }

    public Long getId() { return id; }
    public String getCode() { return code; }
    public String getTitle() { return title; }
    public String getEnglishTitle() { return englishTitle; }
    public String getDescription() { return description; }
    public Integer getUnits() { return units; }
    public String getType() { return type; }
    public String getInstructor() { return instructor; }
    public boolean isEnrolled() { return enrolled; }
}