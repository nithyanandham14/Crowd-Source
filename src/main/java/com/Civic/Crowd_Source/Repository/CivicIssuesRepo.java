package com.Civic.Crowd_Source.Repository;

import com.Civic.Crowd_Source.Module.Issues;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CivicIssuesRepo extends JpaRepository<Issues,Integer> {
}
