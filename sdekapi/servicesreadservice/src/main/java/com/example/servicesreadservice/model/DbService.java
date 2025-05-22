package com.example.servicesreadservice.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
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
    private short service_id;
    private String service_name;
    private double service_pay;
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ManyToMany(mappedBy = "package_services")
    private List<DbPackage> packages;
}
