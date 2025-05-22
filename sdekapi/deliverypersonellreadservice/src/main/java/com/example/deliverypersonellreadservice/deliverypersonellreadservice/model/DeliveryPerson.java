package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "tb_delivery_person")
public class DeliveryPerson {
    @Id
    private int person_id;
    private String person_lastname;
    private String person_firstname;
    private String person_middlename;
    @ManyToOne
    @JoinColumn(name = "person_user_id")
    private UserDb person_user;
    @ManyToOne
    @JoinColumn(name = "person_transport_id")
    private TransportDb person_transport;
}
