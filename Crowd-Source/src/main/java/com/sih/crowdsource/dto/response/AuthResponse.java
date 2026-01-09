package com.sih.crowdsource.dto.response;

import lombok.Getter;

@Getter
public class AuthResponse {

    private final String token;
    private final String type;

    public AuthResponse(String token) {
        this.token = token;
        this.type = "Bearer";
    }
}
