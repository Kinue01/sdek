package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "tb_fuser")
public class UserDb {
    @Id
    private UUID user_id;
    private String user_login;
    private String user_password;
    @Nullable
    private String user_email;
    private String user_phone;
    @Nullable
    private String user_access_token;
    @ManyToOne
    @JoinColumn(name = "user_role_id")
    private Role user_role;
}
