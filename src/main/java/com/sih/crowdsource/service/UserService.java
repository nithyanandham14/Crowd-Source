package com.sih.crowdsource.service;

import com.sih.crowdsource.dto.request.RegisterRequest;
import com.sih.crowdsource.dto.response.UserResponse;

import java.util.List;

public interface UserService {

    UserResponse registerUser(RegisterRequest request);

    UserResponse getUserById(Long id);

    List<UserResponse> getAllUsers();
}
