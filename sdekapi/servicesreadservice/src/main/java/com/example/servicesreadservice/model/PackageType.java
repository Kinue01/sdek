package com.example.servicesreadservice.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "tb_fpackage_type")
public class PackageType {
    @Id
    private short type_id;
    private String type_name;
    private int type_length;
    private int type_width;
    private int type_height;
}
