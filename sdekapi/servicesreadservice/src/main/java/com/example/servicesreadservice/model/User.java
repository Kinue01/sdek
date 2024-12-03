package com.example.servicesreadservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private UUID user_id;
    private String user_login;
    private String user_password;
    private String user_email;
    private String user_phone;
    private String user_access_token;
    private Role user_role;
}
