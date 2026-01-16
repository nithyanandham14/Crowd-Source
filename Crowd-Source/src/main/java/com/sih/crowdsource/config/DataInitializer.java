package com.sih.crowdsource.config;

import com.sih.crowdsource.entity.Department;
import com.sih.crowdsource.entity.Role;
import com.sih.crowdsource.repository.DepartmentRepository;
import com.sih.crowdsource.repository.RoleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final RoleRepository roleRepository;
    private final DepartmentRepository departmentRepository;

    @Override
    public void run(String... args) {
        // Initialize roles
        initializeRoles();

        // Initialize sample departments
        initializeDepartments();
    }

    private void initializeRoles() {
        createRoleIfNotExists("ROLE_USER");
        createRoleIfNotExists("ROLE_ADMIN");
        createRoleIfNotExists("ROLE_DEPARTMENT");

        System.out.println("✅ Roles initialized successfully");
    }

    private void createRoleIfNotExists(String roleName) {
        if (roleRepository.findByName(roleName).isEmpty()) {
            Role role = new Role();
            role.setName(roleName);
            roleRepository.save(role);
            System.out.println("Created role: " + roleName);
        }
    }

    private void initializeDepartments() {
        if (departmentRepository.count() == 0) {
            createDepartment("Public Works", "Roads, Water, and Sanitation");
            createDepartment("Health Services", "Healthcare and Medical Facilities");
            createDepartment("Transportation", "Public Transport and Traffic Management");
            createDepartment("Utilities", "Electricity, Gas, and Internet");
            createDepartment("Environment", "Waste Management and Environmental Issues");

            System.out.println("✅ Sample departments created successfully");
        } else {
            System.out.println("✅ Departments already exist");
        }
    }

    private void createDepartment(String name, String description) {
        Department department = Department.builder()
                .name(name)
                .description(description)
                .build();
        departmentRepository.save(department);
        System.out.println("Created department: " + name);
    }
}
