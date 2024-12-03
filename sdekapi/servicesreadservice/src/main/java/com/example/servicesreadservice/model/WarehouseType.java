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
@Table(name = "tb_fwarehouse_type")
public class WarehouseType {
    @Id
    private short type_id;
    private String type_name;
    private int type_small_quantity;
    private int type_med_quantity;
    private int type_huge_quantity;
}
