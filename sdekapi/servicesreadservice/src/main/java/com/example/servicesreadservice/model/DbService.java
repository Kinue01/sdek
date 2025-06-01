package com.example.servicesreadservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "tb_service")
public class DbService implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private short service_id;
    private String service_name;
    private double service_pay;
}
