package com.example.warehousereadservice.warehousereadservice;

import com.arangodb.ArangoDB;
import com.arangodb.springframework.annotation.EnableArangoRepositories;
import com.arangodb.springframework.config.ArangoConfiguration;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableArangoRepositories(basePackages = {"com.example"})
public class ArangoConf implements ArangoConfiguration {
    @Override
    public ArangoDB.Builder arango() {
        return new ArangoDB.Builder()
                .host("arangodb", 8529)
                .user("root")
                .password(String.valueOf(123));
    }

    @Override
    public String database() {
        return "warehouseLoc";
    }
}
