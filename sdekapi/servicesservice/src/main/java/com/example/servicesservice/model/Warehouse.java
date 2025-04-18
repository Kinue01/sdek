package com.example.servicesservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Warehouse {
    private int warehouse_id;
    private String warehouse_name;
    private String warehouse_address;
    private WarehouseType warehouse_type;
}
