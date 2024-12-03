package com.example.warehouseservice.warehouseservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WarehouseType {
    short type_id;
    String type_name;
    int type_small_quantity;
    int type_med_quantity;
    int type_huge_quantity;
}
