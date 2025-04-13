package com.example.myapplication.model;

public record WarehouseResponse(
        int warehouse_id,
        String warehouse_name,
        String warehouse_address,
        WarehouseType warehouse_type
) {
}
