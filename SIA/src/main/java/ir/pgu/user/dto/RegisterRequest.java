package ir.pgu.user.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Getter
@Setter
@NoArgsConstructor
public class RegisterRequest{
    @NotBlank
    private String firstName;

    @NotBlank
    private String lastName;

    @NotBlank
    private String studentNumber;


    private String phoneNumber;

    @NotBlank
    @Size(min = 8)
    private String password;



}