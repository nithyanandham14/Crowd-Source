package com.Civic.Crowd_Source.Module;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class UserRegistrationDto {
    @NotBlank
    private String userName;

    @NotBlank
    private String password;

    @NotBlank
    private String confirmPassword;

    @NotBlank
    @Pattern(regexp="^[6-9]\\d{9}$", message="Invalid Indian phone number")
    private String mobileNumber;
}
