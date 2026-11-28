package ir.pgu.resource.dto;

import ir.pgu.resource.model.Visibility;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResourceResponseDTO {

    private Long id;
    private Long courseId;
    private String courseTitle;
    private Long uploaderId;
    private String uploaderName;
    private String title;
    private String description;
    private String resourceType;
    private String fileType;
    private long fileSize;
    private Visibility visibility;
    private boolean fileValidated;
    private LocalDateTime uploadedAt;
    private boolean owner;
}