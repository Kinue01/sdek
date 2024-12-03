package com.example.warehousereadservice.warehousereadservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Deprecated
@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "tb_warehouse")
public class Warehouse {
    @Id
    int warehouse_id;
    @Column
    String warehouse_name;
    @Column
    String warehouse_address;
    @Column
    short warehouse_type_id;
}
