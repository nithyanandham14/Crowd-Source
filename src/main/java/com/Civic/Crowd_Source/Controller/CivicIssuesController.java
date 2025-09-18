package com.Civic.Crowd_Source.Controller;


import com.Civic.Crowd_Source.Module.Issues;
import com.Civic.Crowd_Source.Service.CivicIssuesServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/issues")
public class CivicIssuesController {
    @Autowired
    private CivicIssuesServices civicIssuesServices;
    // Submit a new issue with multimedia and location data
    @PostMapping("/submit")
    public ResponseEntity<?> submitIssue(
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

        Issues issues = civicIssuesServices.saveIssue(reporter, description, address, status, title, image, voiceMsg, video, latitude, longitude);
        return ResponseEntity.ok("Issue submitted successfully with ID: " + issues.getIssuesNo());
    }

    // Get all issues (potentially add pagination/filtering here)
    @GetMapping("/all")
    public ResponseEntity<List<Issues>> getAllIssues() {
        List<Issues> issues = civicIssuesServices.getIssuesByFilters(null, null, null);  // No filter parameters
        return ResponseEntity.ok(issues);
    }

}
