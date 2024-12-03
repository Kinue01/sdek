package com.example.warehousereadservice.warehousereadservice.model;

import jakarta.persistence.*;
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
    short type_id;
    String type_name;
    int type_small_quantity;
    int type_med_quantity;
    int type_huge_quantity;
}
