package com.Civic.Crowd_Source.Service;

import com.Civic.Crowd_Source.Module.User;
import com.Civic.Crowd_Source.Module.UserRegistrationDto;
import com.Civic.Crowd_Source.Repository.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    private UserRepo userRepo;
    @Autowired
    private PasswordEncoder passwordEncoder;

    // Checks if username or mobile number already exist
    public boolean userExists(String userName, String mobileNumber) {
        return (userRepo.findByUserName(userName) != null) ||
                (userRepo.findByMobileNumber(mobileNumber) != null);
    }
    // Register new user with validation
    public User registerUser(UserRegistrationDto dto) {
        // Check if username already exists
        if (userRepo.findByUserName(dto.getUserName()) != null) {
            throw new RuntimeException("Username already exists");
        }
        // Check if phone number already exists
        if (userRepo.findByMobileNumber(dto.getMobileNumber()) != null) {
            throw new RuntimeException("Phone number already registered");
        }
        // Check password match
        if (!dto.getPassword().equals(dto.getConfirmPassword())) {
            throw new RuntimeException("Passwords do not match");
        }

        // Create and save new user with encoded password
        User user = new User();
        user.setUserName(dto.getUserName());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));
        user.setMobileNumber(dto.getMobileNumber());

        return userRepo.save(user);
    }

    // Existing login method, for reference
    public User login(String identifier, String rawPassword) {
        User user = userRepo.findByUserName(identifier);
        if (user == null) {
            user = userRepo.findByMobileNumber(identifier);
        }
        // Check password validity
        if (user != null && passwordEncoder.matches(rawPassword, user.getPassword())) {
            return user;
        }
        return null;
    }
}