package com.Civic.Crowd_Source.Controller;

import com.Civic.Crowd_Source.Module.Admin;
import com.Civic.Crowd_Source.Module.Issues;
import com.Civic.Crowd_Source.Service.AdminService;
import com.Civic.Crowd_Source.Service.CivicIssuesServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/Admin")
public class AdminController {
    @Autowired
    private CivicIssuesServices civicIssuesServices;
    @Autowired
    private AdminService adminService;

    @PostMapping("/login")
    public ResponseEntity<?> loginAdmin(@RequestParam String adminName,
                                        @RequestParam String password,
                                        @RequestParam String state,
                                        @RequestParam String district,
                                        @RequestParam String department) {
        Admin admin = adminService.login(adminName, password, state, district, department);
        if (admin == null) {
            return ResponseEntity.status(401).body("Invalid credentials or access denied");
        }
        return ResponseEntity.ok(admin);
    }

    // View issues accessible to admin filtered by region/department
    @GetMapping("/issues")
    public ResponseEntity<List<Issues>> viewIssues(@RequestParam(required = false) String state,
                                                   @RequestParam(required = false) String district,
                                                   @RequestParam(required = false) String department) {
        List<Issues> issues = civicIssuesServices.getIssuesByFilters(state, district, department);
        return ResponseEntity.ok(issues);
    }
}