package com.Civic.Crowd_Source.Service;

import com.Civic.Crowd_Source.Module.Issues;
import com.Civic.Crowd_Source.Module.User;
import com.Civic.Crowd_Source.Repository.CivicIssuesRepo;
import com.Civic.Crowd_Source.Repository.UserRepo;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
public class CivicIssuesServices {
    @Autowired
    private CivicIssuesRepo issuesRepo;
    @Autowired
    private UserRepo userRepo;
    // Define directory where files will be uploaded; configure as needed
    private final String uploadDir = "uploads/";

    @Transactional
    public Issues saveIssue(String reporter, String description, String address, String status, String title,
                            MultipartFile image, MultipartFile voiceMsg, MultipartFile video,
                            Double latitude, Double longitude) {

        Issues issue = new Issues();

        issue.setReporter(reporter);
        issue.setDescription(description);
        issue.setAddress(address);
        issue.setStatus(status);
        issue.setTitle(title);
        issue.setStdate(LocalDate.now());
        issue.setLatitude(latitude);
        issue.setLongitude(longitude);

        // Save files and store only filenames (or relative paths)
        issue.setImagePath(saveFile(image));
        issue.setVoiceMsgPath(saveFile(voiceMsg));
        issue.setVideoPath(saveFile(video));

        // Optionally link user entity (assuming reporter is userName)
        User user = userRepo.findByUserName(reporter);
        if (user != null) {
            issue.setUser(user);
        }

        return issuesRepo.save(issue);
    }

    // Helper method to save MultipartFile to disk
    private String saveFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        // Create upload directory if it doesn't exist
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        // Generate unique filename to avoid collisions
        String filename = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();

        try {
            File destination = new File(dir, filename);
            file.transferTo(destination);
            return filename;  // Store just the filename or relative path
        } catch (IOException e) {
            throw new RuntimeException("Failed to store file " + filename, e);
        }
    }

    // Retrieve all issues (filtering can be enhanced)
    public List<Issues> getIssuesByFilters(String state, String district, String department) {
        return issuesRepo.findAll();
    }

}
