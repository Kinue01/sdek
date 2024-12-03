package com.example.warehouseservice.warehouseservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.NotBlank;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Warehouse {
    int warehouse_id;

    @NotBlank
    String warehouse_name;

    @NotBlank
    String warehouse_address;

    @NotBlank
    WarehouseType warehouse_type;
}
