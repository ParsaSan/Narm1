package ir.pgu.profile.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record UpdateProfileRequest(
        @NotBlank(message = "نام و نام خانوادگی الزامی است")
        @Size(max = 80, message = "حداکثر ۸۰ کاراکتر")
        String fullName,

        // رشته خالی هم مجاز است
        @Pattern(regexp = "^(09\\d{9})?$", message = "شماره موبایل معتبر نیست")
        String phone,

        @Email(message = "ایمیل معتبر نیست")
        String personalEmail,

        @Size(max = 500, message = "حداکثر ۵۰۰ کاراکتر")
        String bio
) {

}