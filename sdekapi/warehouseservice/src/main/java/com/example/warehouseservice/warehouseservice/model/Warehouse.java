package com.example.warehouseservice.warehouseservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.NotBlank;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Warehouse {
    private int warehouse_id;
    @NotBlank
    private String warehouse_name;
    @NotBlank
    private String warehouse_address;
    @NotBlank
    private WarehouseType warehouse_type;
}
