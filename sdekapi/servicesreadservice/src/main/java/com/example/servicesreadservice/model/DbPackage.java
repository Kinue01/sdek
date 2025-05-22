package com.example.servicesreadservice.model;

import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "tb_fpackage")
public class DbPackage {
    @Id
    private UUID package_uuid;
    @Nullable
    private LocalDate package_send_date;
    @Nullable
    private LocalDate package_receive_date;
    @Nullable
    private BigDecimal package_weight;
    @ManyToOne
    @JoinColumn(name = "package_deliveryperson_id")
    private DbDeliveryPerson package_deliveryperson;
    @ManyToOne
    @JoinColumn(name = "package_type_id")
    private PackageType package_type;
    @ManyToOne
    @JoinColumn(name = "package_status_id")
    private PackageStatus package_status;
    @ManyToOne
    @JoinColumn(name = "package_sender_id")
    private DbClient package_sender;
    @ManyToOne
    @JoinColumn(name = "package_receiver_id")
    private DbClient package_receiver;
    @ManyToOne
    @JoinColumn(name = "package_warehouse_id")
    private DbWarehouse package_warehouse;
    @ManyToOne
    @JoinColumn(name = "package_paytype_id")
    private PackagePaytype package_paytype;
    @ManyToOne
    @JoinColumn(name = "package_payer_id")
    private DbClient package_payer;
    @ManyToMany
    @JoinTable(
            name = "tb_fpackage_items",
            joinColumns = @JoinColumn(name = "package_id"),
            inverseJoinColumns = @JoinColumn(name = "item_id")
    )
    private List<PackageItem> package_items;
    @ManyToMany
    @JoinTable(
            name = "tb_package_services",
            joinColumns = @JoinColumn(name = "package_id"),
            inverseJoinColumns = @JoinColumn(name = "service_id")
    )
    private List<DbService> package_services;
}
