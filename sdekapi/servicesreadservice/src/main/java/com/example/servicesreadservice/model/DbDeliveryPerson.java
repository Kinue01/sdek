package com.example.servicesreadservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "tb_fdelivery_person")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class DbDeliveryPerson {
    @Id
    private int person_id;
    private String person_lastname;
    private String person_firstname;
    private String person_middlename;
    @ManyToOne
    @JoinColumn(name = "person_user_id")
    private DbUser person_user;
    @ManyToOne
    @JoinColumn(name = "person_transport_id")
    private DbTransport person_transport;
}
