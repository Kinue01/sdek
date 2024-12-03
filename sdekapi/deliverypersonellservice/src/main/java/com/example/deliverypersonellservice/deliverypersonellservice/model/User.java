package com.example.deliverypersonellservice.deliverypersonellservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    UUID user_id;
    String user_login;
    String user_password;
    String user_email;
    String user_phone;
    String user_access_token;
    Role user_role;
}
