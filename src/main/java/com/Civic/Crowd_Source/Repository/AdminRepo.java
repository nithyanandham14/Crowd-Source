package com.Civic.Crowd_Source.Repository;

import com.Civic.Crowd_Source.Module.Admin;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdminRepo extends JpaRepository<Admin,Integer> {
    Admin findByAdminNameAndStateAndDistrictAndDepartment(String adminName, String state, String district, String department);
}
