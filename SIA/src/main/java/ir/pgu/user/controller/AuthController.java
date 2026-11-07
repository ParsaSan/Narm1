package ir.pgu.user.controller;

import ir.pgu.user.dto.AuthResponse;
import ir.pgu.user.model.User;
import ir.pgu.user.service.AuthService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ir.pgu.user.dto.RegisterRequest;
import org.springframework.web.bind.annotation.RequestBody;
import jakarta.validation.Valid;
import ir.pgu.user.dto.LoginRequest;


@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }
    @PostMapping("/register")
    public String register(@Valid @RequestBody RegisterRequest request) {
        authService.register(request);
        return "Registration successful";
    }

    @PostMapping("/login")
    public AuthResponse login(@Valid @RequestBody LoginRequest request) {
        return authService.login(request);
    }


}