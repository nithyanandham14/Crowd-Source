package com.sih.crowdsource.service;

import com.sih.crowdsource.entity.Department;

import java.util.List;

public interface DepartmentService {

    Department createDepartment(Department department);

    List<Department> getAllDepartments();
}
