package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "tb_frole")
public class Role {
    @Id
    private short role_id;
    private String role_name;
}
