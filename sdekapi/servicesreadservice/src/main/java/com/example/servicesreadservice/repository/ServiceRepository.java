package com.example.servicesreadservice.repository;

import com.example.servicesreadservice.model.DbService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServiceRepository extends JpaRepository<DbService, Short> {
    
}
