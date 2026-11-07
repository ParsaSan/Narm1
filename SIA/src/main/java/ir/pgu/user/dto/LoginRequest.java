
package ir.pgu.user.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.NotBlank;

@Getter
@Setter
@NoArgsConstructor
public class LoginRequest {

    @NotBlank
    private String identifier;

    @NotBlank
    private String password;
}
