package ir.pgu.resource.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.core.io.Resource;

@Data
@AllArgsConstructor
public class FileDownloadResult {
    private Resource file;
    private String filename;
    private String contentType;
    private long fileSize;
}