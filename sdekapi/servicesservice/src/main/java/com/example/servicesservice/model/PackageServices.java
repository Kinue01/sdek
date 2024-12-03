package com.example.servicesservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PackageServices {
    private Package db_package;
    private DbService service;
    private int service_count;
}
