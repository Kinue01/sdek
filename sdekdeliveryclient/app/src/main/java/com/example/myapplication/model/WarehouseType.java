package com.example.myapplication.model;

public record WarehouseType(
        short type_id,
        String type_name,
        int type_small_quantity,
        int type_med_quantity,
        int type_huge_quantity
) {
}
