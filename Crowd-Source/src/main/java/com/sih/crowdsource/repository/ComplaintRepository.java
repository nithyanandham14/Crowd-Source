package com.sih.crowdsource.repository;

import com.sih.crowdsource.entity.Complaint;
import com.sih.crowdsource.entity.Department;
import com.sih.crowdsource.entity.User;
import com.sih.crowdsource.enums.ComplaintState;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ComplaintRepository extends JpaRepository<Complaint, Long> {

    List<Complaint> findByCreatedBy(User user);

    List<Complaint> findByDepartment(Department department);

    List<Complaint> findByStatus(ComplaintState status);
}
