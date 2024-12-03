package com.example.servicesreadservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DeliveryPerson {
    private int person_id;
    private String person_lastname;
    private String person_firstname;
    private String person_middlename;
    private User person_user;
    private Transport person_transport;
}
