package com.example.warehousereadservice.warehousereadservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "tb_warehouse")
public class WarehouseResponse implements Serializable {
    @Id
    private int warehouse_id;
    private String warehouse_name;
    private String warehouse_address;
    @ManyToOne
    @JoinColumn(name = "warehouse_type_id")
    private WarehouseType warehouse_type;
}
