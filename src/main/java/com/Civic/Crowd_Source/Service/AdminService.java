package com.Civic.Crowd_Source.Service;

import com.Civic.Crowd_Source.Module.Admin;
import com.Civic.Crowd_Source.Repository.AdminRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AdminService {
    @Autowired
    private AdminRepo adminRepo;
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    // Admin login method with verification of all details
    public Admin login(String adminName, String rawPassword, String state, String district, String department) {
        Admin admin = adminRepo.findByAdminNameAndStateAndDistrictAndDepartment(adminName, state, district, department);
        if (admin != null && passwordEncoder.matches(rawPassword, admin.getPassword())) {
            return admin;
        }
        return null;
    }

}
