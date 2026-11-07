
package ir.pgu.user.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AuthResponse {

    private Long id;
    private String firstName;
    private String lastName;
    private String studentNumber;
}
