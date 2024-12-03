package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DeliveryPersonResponse implements Serializable {
    int person_id;
    String person_lastname;
    String person_firstname;
    String person_middlename;
    User person_user;
    Transport person_transport;
}
