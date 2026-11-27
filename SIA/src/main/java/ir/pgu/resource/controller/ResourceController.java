package ir.pgu.resource.controller;

import ir.pgu.resource.dto.FileDownloadResult;
import ir.pgu.resource.dto.ResourceResponseDTO;
import ir.pgu.resource.service.ResourceService;
import ir.pgu.user.model.User;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.nio.charset.StandardCharsets;
import java.util.List;

@RestController
@RequestMapping("/api/resources")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ResourceController {

    private final ResourceService resourceService;

    @GetMapping
    public ResponseEntity<List<ResourceResponseDTO>> listAndSearch(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) Long courseId,
            @RequestParam(required = false) String fileType,
            HttpServletRequest request
    ) {
        User currentUser = resolveCurrentUser(request);
        return ResponseEntity.ok(resourceService.searchResources(query, courseId, fileType, currentUser));
    }

    @GetMapping("/{id}/download")
    public ResponseEntity<Resource> download(
            @PathVariable Long id,
            HttpServletRequest request
    ) {
        User currentUser = resolveCurrentUser(request);
        FileDownloadResult result = resourceService.downloadResource(id, currentUser);

        ContentDisposition contentDisposition = ContentDisposition.attachment()
                .filename(result.getFilename(), StandardCharsets.UTF_8)
                .build();

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(result.getContentType()))
                .header(HttpHeaders.CONTENT_DISPOSITION, contentDisposition.toString())
                .contentLength(result.getFileSize())
                .body(result.getFile());
    }

    private User resolveCurrentUser(HttpServletRequest request) {
        Object attr = request.getAttribute("currentUser");
        return (attr instanceof User user) ? user : null;
    }
}