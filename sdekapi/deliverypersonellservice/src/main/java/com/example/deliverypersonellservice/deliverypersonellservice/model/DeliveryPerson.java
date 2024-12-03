package com.example.deliverypersonellservice.deliverypersonellservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DeliveryPerson {
    int person_id;
    String person_lastname;
    String person_firstname;
    String person_middlename;
    User user;
    Transport transport;
}
