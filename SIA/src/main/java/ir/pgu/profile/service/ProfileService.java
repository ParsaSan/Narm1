package ir.pgu.profile.service;

import ir.pgu.profile.dto.EnrolledCourseDto;
import ir.pgu.profile.dto.ProfileResponse;
import ir.pgu.profile.dto.UpdateProfileRequest;
import ir.pgu.profile.model.EnrolledCourse;
import ir.pgu.profile.model.StudentProfile;
import ir.pgu.profile.repository.EnrolledCourseRepository;
import ir.pgu.profile.repository.StudentProfileRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class ProfileService {

    // وقتی لاگین آماده شد، این باید از کاربر لاگین‌شده گرفته بشه
    private static final Long CURRENT_STUDENT_ID = 1L;

    private final StudentProfileRepository studentRepository;
    private final EnrolledCourseRepository courseRepository;

    public ProfileService(StudentProfileRepository studentRepository,
                          EnrolledCourseRepository courseRepository) {
        this.studentRepository = studentRepository;
        this.courseRepository = courseRepository;
    }

    @Transactional(readOnly = true)
    public ProfileResponse getProfile() {
        return buildResponse(findStudent());
    }

    @Transactional
    public ProfileResponse updateProfile(UpdateProfileRequest req) {
        StudentProfile s = findStudent();
        s.setFullName(req.fullName().trim());
        s.setPhone(req.phone());
        s.setPersonalEmail(req.personalEmail());
        s.setBio(req.bio());
        studentRepository.save(s);
        return buildResponse(s);
    }

    private StudentProfile findStudent() {
        return studentRepository.findById(CURRENT_STUDENT_ID)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "دانشجو پیدا نشد"));
    }

    private ProfileResponse buildResponse(StudentProfile s) {
        List<EnrolledCourseDto> courses = courseRepository.findByStudentId(s.getId())
                .stream()
                .map(this::toDto)
                .toList();

        return new ProfileResponse(
                s.getId(), s.getFullName(), s.getStudentType(), s.getStudentNumber(),
                s.getMajor(), s.getUniversityEmail(), s.getEntryYear(), s.getGpa(),
                s.getEducationStatus(), s.getPhone(), s.getPersonalEmail(), s.getBio(),
                courses.size(), courses);
    }

    private EnrolledCourseDto toDto(EnrolledCourse c) {
        return new EnrolledCourseDto(
                c.getCourseId(), c.getTitle(), c.getInstructorName(),
                c.getUnits(), c.getMembershipStatus());
    }
}