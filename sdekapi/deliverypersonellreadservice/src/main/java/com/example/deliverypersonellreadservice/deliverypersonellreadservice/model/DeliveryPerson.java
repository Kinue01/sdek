package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "tb_delivery_person")
public class DeliveryPerson {
    @Id
    int person_id;
    String person_lastname;
    String person_firstname;
    String person_middlename;
    UUID person_user_id;
    int person_transport_id;
}
