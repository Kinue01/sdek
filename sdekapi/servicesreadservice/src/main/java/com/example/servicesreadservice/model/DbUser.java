package com.example.servicesreadservice.model;

import jakarta.persistence.*;
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
    private UUID user_id;
    private String user_login;
    private String user_password;
    private String user_email;
    private String user_phone;
    private String user_access_token;
    @ManyToOne
    @JoinColumn(name = "user_role_id")
    private Role user_role;
}
