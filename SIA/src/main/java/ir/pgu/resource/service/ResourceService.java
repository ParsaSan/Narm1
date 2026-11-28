package ir.pgu.resource.service;

import ir.pgu.resource.dto.FileDownloadResult;
import ir.pgu.resource.dto.ResourceResponseDTO;
import ir.pgu.resource.model.Resource;
import ir.pgu.resource.model.Visibility;
import ir.pgu.resource.repository.ResourceRepository;
import ir.pgu.user.model.User;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ResourceService {

    private final ResourceRepository resourceRepository;
    private final FileStorageService fileStorageService;

    @Transactional(readOnly = true)
    public List<ResourceResponseDTO> searchResources(String query, Long courseId, String fileType, User currentUser) {
        Specification<Resource> spec = (root, criteriaQuery, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            // شرط حریم خصوصی: فقط PUBLIC یا جزوه خصوصی متعلق به کاربر جاری
            Predicate publicPredicate = cb.equal(root.get("visibility"), Visibility.PUBLIC);
            if (currentUser != null && currentUser.getId() != null) {
                Predicate ownerPredicate = cb.equal(root.get("uploader").get("id"), currentUser.getId());
                predicates.add(cb.or(publicPredicate, ownerPredicate));
            } else {
                predicates.add(publicPredicate);
            }

            // جست‌وجو روی عنوان و نوع منبع
            if (query != null && !query.isBlank()) {
                String pattern = "%" + query.trim().toLowerCase() + "%";
                Predicate byTitle = cb.like(cb.lower(root.get("title")), pattern);
                Predicate byResourceType = cb.like(cb.lower(root.get("resourceType")), pattern);
                predicates.add(cb.or(byTitle, byResourceType));
            }

            // فیلتر بر اساس درس
            if (courseId != null && courseId > 0) {
                predicates.add(cb.equal(root.get("course").get("id"), courseId));
            }

            // فیلتر بر اساس فرمت فایل
            if (fileType != null && !fileType.isBlank() && !fileType.equalsIgnoreCase("همه")) {
                predicates.add(cb.equal(cb.lower(root.get("fileType")), fileType.trim().toLowerCase()));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        List<Resource> resources = resourceRepository.findAll(
                spec,
                Sort.by(Sort.Direction.DESC, "uploadedAt")
        );

        return resources.stream()
                .map(r -> toDto(r, currentUser))
                .toList();
    }

    @Transactional(readOnly = true)
    public FileDownloadResult downloadResource(Long resourceId, User currentUser) {
        Resource resource = resourceRepository.findWithDetailsById(resourceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "جزوه پیدا نشد"));

        if (resource.getVisibility() == Visibility.PRIVATE) {
            boolean isOwner = currentUser != null
                    && currentUser.getId() != null
                    && resource.getUploader().getId().equals(currentUser.getId());
            if (!isOwner) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "شما اجازه دانلود این جزوه خصوصی را ندارید");
            }
        }

        org.springframework.core.io.Resource file = fileStorageService.loadFileAsResource(resource.getFileUrl());
        String downloadFilename = buildDownloadFilename(resource);
        String contentType = resolveContentType(resource.getFileType());

        return new FileDownloadResult(file, downloadFilename, contentType, resource.getFileSize());
    }

    private ResourceResponseDTO toDto(Resource r, User currentUser) {
        User uploader = r.getUploader();
        String first = uploader.getFirstName() == null ? "" : uploader.getFirstName();
        String last = uploader.getLastName() == null ? "" : uploader.getLastName();
        String uploaderName = (first + " " + last).trim();

        if (uploaderName.isEmpty()) {
            uploaderName = uploader.getStudentNumber();
        }

        boolean isOwner = currentUser != null
                && currentUser.getId() != null
                && uploader.getId().equals(currentUser.getId());

        return new ResourceResponseDTO(
                r.getId(),
                r.getCourse().getId(),
                r.getCourse().getTitle(),
                uploader.getId(),
                uploaderName,
                r.getTitle(),
                r.getDescription(),
                r.getResourceType(),
                r.getFileType(),
                r.getFileSize(),
                r.getVisibility(),
                r.isFileValidated(),
                r.getUploadedAt(),
                isOwner
        );
    }

    private String buildDownloadFilename(Resource resource) {
        String base = resource.getTitle() == null ? "" : resource.getTitle().replaceAll("[\\\\/:*?\"<>|]", "_").trim();
        if (base.isEmpty()) {
            base = "resource-" + resource.getId();
        }
        String ext = resource.getFileType() == null ? "" : resource.getFileType().trim().toLowerCase();
        if (!ext.isEmpty() && !base.toLowerCase().endsWith("." + ext)) {
            return base + "." + ext;
        }
        return base;
    }

    private String resolveContentType(String fileType) {
        if (fileType == null) {
            return "application/octet-stream";
        }
        return switch (fileType.trim().toLowerCase()) {
            case "pdf" -> "application/pdf";
            case "docx" -> "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            case "doc" -> "application/msword";
            case "zip" -> "application/zip";
            case "png" -> "image/png";
            case "jpg", "jpeg" -> "image/jpeg";
            default -> "application/octet-stream";
        };
    }
}