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
@Table(name = "tb_fclient")
public class DbClient {
    @Id
    int client_id;
    String client_lastname;
    String client_firstname;
    String client_middlename;
    UUID client_user_id;
}
