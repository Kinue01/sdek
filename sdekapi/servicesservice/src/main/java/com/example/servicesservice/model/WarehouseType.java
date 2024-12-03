package com.example.servicesservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WarehouseType {
    private short type_id;
    private String type_name;
    private int type_small_quantity;
    private int type_med_quantity;
    private int type_huge_quantity;
}
