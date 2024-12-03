package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Transport {
    int transport_id;
    String transport_name;
    String transport_reg_number;
    TransportType transport_type;
    TransportStatus transport_status;
}
