package com.Civic.Crowd_Source.Repository;

import com.Civic.Crowd_Source.Module.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepo extends JpaRepository<User,Integer> {
    User findByUserName(String username);
    User findByMobileNumber(String mobileNumber);
}
