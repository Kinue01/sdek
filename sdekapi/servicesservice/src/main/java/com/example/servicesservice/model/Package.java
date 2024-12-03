package com.example.servicesservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Package {
    private UUID package_uuid;
    private LocalDate package_send_date;
    private LocalDate package_receive_date;
    private BigDecimal package_weight;
    private DeliveryPerson package_deliveryperson;
    private PackageType package_type;
    private PackageStatus package_status;
    private Client package_sender;
    private Client package_receiver;
    private Warehouse package_warehouse;
    private PackagePaytype package_paytype;
    private Client package_payer;
    private List<PackageItem> package_items;
}
