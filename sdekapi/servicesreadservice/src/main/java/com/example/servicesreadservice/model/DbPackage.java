package com.example.servicesreadservice.model;

import jakarta.annotation.Nullable;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "tb_fpackage")
public class DbPackage {
    @Id
    UUID package_uuid;
    @Nullable
    LocalDate package_send_date;
    @Nullable
    LocalDate package_receive_date;
    @Nullable
    BigDecimal package_weight;
    int package_deliveryperson_id;
    short package_type_id;
    short package_status_id;
    int package_sender_id;
    int package_receiver_id;
    int package_warehouse_id;
    short package_paytype_id;
    int package_payer_id;
}
