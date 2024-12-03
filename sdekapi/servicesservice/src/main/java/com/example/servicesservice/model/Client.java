package com.example.servicesservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Client {
    private int client_id;
    private String client_lastname;
    private String client_firstname;
    private String client_middlename;
    private User client_user;
}
