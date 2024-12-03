package com.example.servicesservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PackageType {
    private short type_id;
    private String type_name;
    private int type_length;
    private int type_width;
    private int type_height;
}
