package com.example.myapplication.model;

public record ClientResponse(
        int client_id,
        String client_lastname,
        String client_firstname,
        String client_middlename,
        UserResponse client_user
) {
}
