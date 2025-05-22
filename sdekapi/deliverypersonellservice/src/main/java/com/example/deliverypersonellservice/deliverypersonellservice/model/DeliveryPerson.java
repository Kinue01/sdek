package com.example.deliverypersonellservice.deliverypersonellservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DeliveryPerson {
    private int person_id;
    private String person_lastname;
    private String person_firstname;
    private String person_middlename;
    private User user;
    private Transport transport;
}
