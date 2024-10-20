package com.example.warehousereadservice.warehousereadservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class WarehousereadserviceApplication {
	public static void main(String[] args) {
		Logger logger = LoggerFactory.getLogger(WarehousereadserviceApplication.class);

		logger.info("Starting app");
		SpringApplication.run(WarehousereadserviceApplication.class, args);
	}
}
