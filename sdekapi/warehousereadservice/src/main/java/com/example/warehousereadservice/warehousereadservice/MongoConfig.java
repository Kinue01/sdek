package com.example.warehousereadservice.warehousereadservice;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@Configuration
@EnableMongoRepositories(basePackages = "com.example.warehousereadservice")
public class MongoConfig {

}
