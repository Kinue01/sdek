package com.example.deliverypersonellservice.deliverypersonellservice.model;

import jakarta.persistence.*;

@Entity
@Table(name = "tb_delivery_person")
public class DeliveryPerson {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int person_id;

    String person_lastname;
    String person_firstname;
    String person_middlename;

}
