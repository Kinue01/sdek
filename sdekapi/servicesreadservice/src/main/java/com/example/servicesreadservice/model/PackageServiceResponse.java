package com.example.servicesreadservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PackageServiceResponse implements Serializable {
    private Package db_package;
    private DbService service;
    private int service_count;
}
