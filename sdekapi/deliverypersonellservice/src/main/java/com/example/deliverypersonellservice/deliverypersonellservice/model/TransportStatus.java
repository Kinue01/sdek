package com.example.deliverypersonellservice.deliverypersonellservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TransportStatus {
    short status_id;
    String status_name;
}
