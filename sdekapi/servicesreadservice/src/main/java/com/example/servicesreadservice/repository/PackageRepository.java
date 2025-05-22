package com.example.servicesreadservice.repository;

import com.example.servicesreadservice.model.DbPackage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface PackageRepository extends JpaRepository<DbPackage, UUID> {
}
