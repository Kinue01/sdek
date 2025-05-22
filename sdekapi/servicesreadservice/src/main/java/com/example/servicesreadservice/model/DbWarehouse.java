package com.example.servicesreadservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "tb_fwarehouse")
public class DbWarehouse {
    @Id
    private int warehouse_id;
    private String warehouse_name;
    private String warehouse_address;
    @ManyToOne
    @JoinColumn(name = "warehouse_type_id")
    private WarehouseType warehouse_type;
}
