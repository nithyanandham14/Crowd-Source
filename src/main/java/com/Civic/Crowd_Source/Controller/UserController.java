package com.Civic.Crowd_Source.Controller;

import com.Civic.Crowd_Source.Module.Issues;
import com.Civic.Crowd_Source.Module.User;
import com.Civic.Crowd_Source.Module.UserRegistrationDto;
import com.Civic.Crowd_Source.Service.CivicIssuesServices;
import com.Civic.Crowd_Source.Service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/user")
public class UserController {
    @Autowired
    private UserService userservice;
    @Autowired
    private CivicIssuesServices civicissueService;
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestParam String identifier,
                                       @RequestParam String password) {
        // identifier can be username or email or mobile
        User user = userservice.login(identifier, password);
        if (user == null) {
            return ResponseEntity.status(401).body("Invalid credentials");
        }
        return ResponseEntity.ok(user);
    }
    // New registration endpoint
    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@Valid @RequestBody UserRegistrationDto dto) {
        try {
            User user = userservice.registerUser(dto);
            return ResponseEntity.ok("Registration successful! Welcome, " + user.getUserName() + ".");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Submit an issue with multimedia and location
    @PostMapping("/submit-issue")
    public ResponseEntity<String> submitIssue(
            @RequestParam String reporter,
            @RequestParam String description,
            @RequestParam String address,
            @RequestParam String status,
            @RequestParam String title,
            @RequestParam MultipartFile image,
            @RequestParam MultipartFile voiceMsg,
            @RequestParam MultipartFile video,
            @RequestParam Double latitude,
            @RequestParam Double longitude) {

        Issues issue = civicissueService.saveIssue(reporter, description, address, status, title, image, voiceMsg, video, latitude, longitude);
        return ResponseEntity.ok("Issue submitted successfully with ID: " + issue.getIssuesNo());
    }
}