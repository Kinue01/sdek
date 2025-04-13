package com.example.myapplication.model;

public record PackageType(
        short type_id,
        String type_name,
        int type_length,
        int type_width,
        int type_height
) {
}
