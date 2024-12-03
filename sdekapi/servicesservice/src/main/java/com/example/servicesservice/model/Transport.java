package com.example.servicesservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Transport {
    private int transport_id;
    private String transport_name;
    private String transport_reg_number;
    private TransportType transport_type;
    private TransportStatus transport_status;
}
