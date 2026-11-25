package ir.pgu.profile.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class UpdateProfileRequest {

    // رشته خالی هم مجاز است
    @Pattern(regexp = "^(09\\d{9})?$", message = "شماره موبایل معتبر نیست")
    private String phone;

    @Email(message = "ایمیل معتبر نیست")
    private String personalEmail;

    @Size(max = 500, message = "حداکثر ۵۰۰ کاراکتر")
    private String bio;

    public UpdateProfileRequest() {
    }

    public UpdateProfileRequest(String phone, String personalEmail, String bio) {
        this.phone = phone;
        this.personalEmail = personalEmail;
        this.bio = bio;
    }

    public String getPhone() { return phone; }
    public String getPersonalEmail() { return personalEmail; }
    public String getBio() { return bio; }

    public void setPhone(String phone) { this.phone = phone; }
    public void setPersonalEmail(String personalEmail) { this.personalEmail = personalEmail; }
    public void setBio(String bio) { this.bio = bio; }
}