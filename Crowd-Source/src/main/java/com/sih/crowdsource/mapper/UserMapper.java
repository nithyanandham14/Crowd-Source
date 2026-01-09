package com.sih.crowdsource.mapper;

import com.sih.crowdsource.dto.response.UserResponse;
import com.sih.crowdsource.entity.User;

public class UserMapper {

    private UserMapper() {
        // prevent object creation
    }

    public static UserResponse toUserResponse(User user) {
        if (user == null) {
            return null;
        }

        return UserResponse.builder()
                .id(user.getId())
                .name(user.getName())
                .email(user.getEmail())
                .build();
    }
}
