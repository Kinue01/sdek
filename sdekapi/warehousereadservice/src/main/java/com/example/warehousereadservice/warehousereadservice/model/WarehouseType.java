package com.example.warehousereadservice.warehousereadservice.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "tb_warehouse_type")
public class WarehouseType implements Serializable {
    @Id
    private short type_id;
    private String type_name;
    private int type_small_quantity;
    private int type_med_quantity;
    private int type_huge_quantity;
}
