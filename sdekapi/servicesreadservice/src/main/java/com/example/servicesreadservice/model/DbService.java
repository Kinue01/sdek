package com.example.servicesreadservice.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

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
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ManyToMany(mappedBy = "package_services")
    private List<DbPackage> packages;
}
