package com.example.servicesreadservice.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "tb_fuser")
public class DbUser {
    @Id
    UUID user_id;
    String user_login;
    String user_password;
    String user_email;
    String user_phone;
    String user_access_token;
    short user_role_id;
}
