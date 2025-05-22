package com.example.servicesreadservice.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "tb_fitem")
public class PackageItem {
    @Id
    private int item_id;
    private String item_name;
    private String item_description;
    private BigDecimal item_length;
    private BigDecimal item_width;
    private BigDecimal item_heigth;
    private BigDecimal item_weight;
    @ManyToMany(mappedBy = "package_items")
    private List<DbPackage> packages;
}
