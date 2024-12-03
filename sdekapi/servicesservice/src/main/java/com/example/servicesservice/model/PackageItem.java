package com.example.servicesservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PackageItem {
    private int item_id;
    private String item_name;
    private String item_description;
    private double item_length;
    private double item_width;
    private double item_heigth;
    private double item_weight;
}
