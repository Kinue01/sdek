package com.example.servicesservice.service;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.servicesservice.model.PackageServices;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class PackageServicesService {
    private final EventStoreDBClient client;
    private final ObjectMapper objectMapper;

    public PackageServicesService(EventStoreDBClient client, ObjectMapper objectMapper) {
        this.client = client;
        this.objectMapper = objectMapper;
    }

    @SneakyThrows
    public CompletableFuture<PackageServices> addPackageAndServices(PackageServices packageServices) {
        final EventData data = EventData.builderAsBinary("package_services_add", objectMapper.writeValueAsBytes(packageServices)).build();
        client.appendToStream("package_services", data).join();
        return CompletableFuture.completedFuture(packageServices);
    }

    @SneakyThrows
    public CompletableFuture<PackageServices> updatePackageAndServices(PackageServices packageServices) {
        final EventData data = EventData.builderAsBinary("package_services_update", objectMapper.writeValueAsBytes(packageServices)).build();
        client.appendToStream("package_services", data).join();
        return CompletableFuture.completedFuture(packageServices);
    }

    @SneakyThrows
    public CompletableFuture<PackageServices> deletePackageAndServices(PackageServices packageServices) {
        final EventData data = EventData.builderAsBinary("package_services_delete", objectMapper.writeValueAsBytes(packageServices)).build();
        client.appendToStream("package_services", data).join();
        return CompletableFuture.completedFuture(packageServices);
    }
}
