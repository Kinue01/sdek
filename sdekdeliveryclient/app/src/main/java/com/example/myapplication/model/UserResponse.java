package com.example.myapplication.model;

import java.util.UUID;

public record UserResponse(
        UUID user_id,
        String user_login,
        String user_password,
        String user_email,
        String user_phone,
        String user_access_token,
        UserRole user_role
) {
}
