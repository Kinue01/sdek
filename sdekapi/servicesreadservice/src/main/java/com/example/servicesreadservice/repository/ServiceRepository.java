package com.example.servicesreadservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.servicesreadservice.model.DbService;

@Repository
public interface ServiceRepository extends JpaRepository<DbService, Short> {
    
}
