package com.example.myapplication.model;

public record Transport(
        int transport_id,
        String transport_name,
        String transport_reg_number,
        TransportType transport_type,
        TransportStatus transport_status
) {
}
