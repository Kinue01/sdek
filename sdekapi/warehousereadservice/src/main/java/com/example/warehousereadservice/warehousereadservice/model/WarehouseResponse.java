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
    int warehouse_id;
    String warehouse_name;
    String warehouse_address;
    @ManyToOne
    @JoinColumn(name = "warehouse_type_id")
    WarehouseType warehouse_type;
}
