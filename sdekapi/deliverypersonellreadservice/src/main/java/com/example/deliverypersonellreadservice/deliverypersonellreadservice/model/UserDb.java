package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import jakarta.annotation.Nullable;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
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
    UUID user_id;
    String user_login;
    String user_password;
    @Nullable
    String user_email;
    String user_phone;
    @Nullable
    String user_access_token;
    short user_role_id;
}
