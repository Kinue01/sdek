package com.example.myapplication.model;

public record PackageItem(
        int item_id,
        String item_name,
        String item_description,
        double item_length,
        double item_width,
        double item_heigth,
        double item_weight
) {
}
