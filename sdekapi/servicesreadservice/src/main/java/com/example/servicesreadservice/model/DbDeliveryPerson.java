package com.example.servicesreadservice.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Entity
@Table(name = "tb_fdelivery_person")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class DbDeliveryPerson {
    @Id
    int person_id;
    String person_lastname;
    String person_firstname;
    String person_middlename;
    UUID person_user_id;
    int person_transport_id;
}
