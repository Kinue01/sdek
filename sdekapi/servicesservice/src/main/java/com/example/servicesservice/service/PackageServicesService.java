package com.example.servicesservice.service;

import com.example.servicesservice.model.PackageServices;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.kurrent.dbclient.EventData;
import io.kurrent.dbclient.KurrentDBClient;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class PackageServicesService {
    private final KurrentDBClient client;
    private final ObjectMapper objectMapper;

    public PackageServicesService(KurrentDBClient client, ObjectMapper objectMapper) {
        this.client = client;
        this.objectMapper = objectMapper;
    }

    @SneakyThrows
    public CompletableFuture<PackageServices> addPackageAndServices(PackageServices packageServices) {
        EventData data = EventData.builderAsJson("package_services_add", objectMapper.writeValueAsBytes(packageServices)).build();
        client.appendToStream("package_services", data).join();
        return CompletableFuture.completedFuture(packageServices);
    }

    @SneakyThrows
    public CompletableFuture<PackageServices> updatePackageAndServices(PackageServices packageServices) {
        EventData data = EventData.builderAsJson("package_services_update", objectMapper.writeValueAsBytes(packageServices)).build();
        client.appendToStream("package_services", data).join();
        return CompletableFuture.completedFuture(packageServices);
    }

    @SneakyThrows
    public CompletableFuture<PackageServices> deletePackageAndServices(PackageServices packageServices) {
        EventData data = EventData.builderAsJson("package_services_delete", objectMapper.writeValueAsBytes(packageServices)).build();
        client.appendToStream("package_services", data).join();
        return CompletableFuture.completedFuture(packageServices);
    }
}
