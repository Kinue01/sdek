package com.example.myapplication.model;

public record DeliveryPersonResponse(
        int person_id,
        String person_lastname,
        String person_firstname,
        String person_middlename,
        UserResponse person_user,
        Transport person_transport
) {
}
