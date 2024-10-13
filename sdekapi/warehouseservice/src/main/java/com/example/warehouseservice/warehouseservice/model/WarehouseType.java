package com.example.warehouseservice.warehouseservice.model;

import lombok.Data;

@Data
public class WarehouseType {
    public int type_id;
    public String type_name;
    public int type_small_quantity;
    public int type_med_quantity;
    public int type_huge_quantity;
}
