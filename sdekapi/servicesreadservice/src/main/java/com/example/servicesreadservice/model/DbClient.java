package com.example.servicesreadservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "tb_fclient")
public class DbClient {
    @Id
    private int client_id;
    private String client_lastname;
    private String client_firstname;
    private String client_middlename;
    @ManyToOne
    @JoinColumn(name = "client_user_id")
    private DbUser client_user;
}
