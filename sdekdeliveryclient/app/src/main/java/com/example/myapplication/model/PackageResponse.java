package com.example.myapplication.model;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

public record PackageResponse(
        UUID package_uuid,
        String package_send_date,
        String package_receive_date,
        BigDecimal package_weight,
        DeliveryPersonResponse package_deliveryperson,
        PackageType package_type,
        PackageStatus package_status,
        ClientResponse package_sender,
        ClientResponse package_receiver,
        WarehouseResponse package_warehouse,
        PackagePaytype package_paytype,
        ClientResponse package_payer,
        List<PackageItem> package_items
) {
}
