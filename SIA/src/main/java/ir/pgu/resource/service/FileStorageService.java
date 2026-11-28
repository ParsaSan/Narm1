package ir.pgu.resource.service;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
@Slf4j
public class FileStorageService {

    @Value("${app.upload.dir:uploads/resources}")
    private String uploadDir;

    private Path rootLocation;

    @PostConstruct
    public void init() {
        try {
            rootLocation = Paths.get(uploadDir)
                    .toAbsolutePath()
                    .normalize();

            Files.createDirectories(rootLocation);

        } catch (IOException e) {
            throw new IllegalStateException(
                    "Could not initialize file storage directory", e
            );
        }
    }

    public String storeFile(MultipartFile file) {

        if (file == null || file.isEmpty()) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "فایل ارسالی خالی است"
            );
        }

        String originalFilename = file.getOriginalFilename();
        String extension = "";

        if (originalFilename != null) {
            int dotIndex = originalFilename.lastIndexOf('.');

            if (dotIndex >= 0) {
                extension = originalFilename.substring(dotIndex).toLowerCase();
            }
        }

        String storedFilename = UUID.randomUUID() + extension;

        try {
            Path targetLocation = rootLocation
                    .resolve(storedFilename)
                    .normalize();

            if (!targetLocation.startsWith(rootLocation)) {
                throw new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        "Invalid file path"
                );
            }

            Files.copy(
                    file.getInputStream(),
                    targetLocation,
                    StandardCopyOption.REPLACE_EXISTING
            );

            return storedFilename;

        } catch (IOException e) {
            log.error("Could not store file", e);

            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "خطا در ذخیره فایل"
            );
        }
    }

    public org.springframework.core.io.Resource loadFileAsResource(String fileName) {
        try {
            Path filePath = rootLocation.resolve(fileName).normalize();

            if (!filePath.startsWith(rootLocation)
                    || !rootLocation.equals(filePath.getParent())) {
                throw new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        "Invalid file path"
                );
            }

            org.springframework.core.io.Resource resource =
                    new UrlResource(filePath.toUri());

            if (resource.exists() && resource.isReadable()) {
                return resource;
            }

            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    "فایل پیدا نشد"
            );

        } catch (IOException e) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    "فایل پیدا نشد"
            );
        }
    }

    public void deleteFile(String fileName) {
        try {
            Path filePath = rootLocation.resolve(fileName).normalize();

            if (!filePath.startsWith(rootLocation)
                    || !rootLocation.equals(filePath.getParent())) {
                throw new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        "Invalid file path"
                );
            }

            Files.deleteIfExists(filePath);

        } catch (IOException e) {
            log.error("Could not delete file: {}", fileName, e);

            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "خطا در حذف فایل"
            );
        }
    }
}
