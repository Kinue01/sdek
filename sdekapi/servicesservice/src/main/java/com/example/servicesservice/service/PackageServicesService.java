package com.example.servicesservice.service;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.servicesservice.model.PackageServices;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class PackageServicesService {
    private final EventStoreDBClient client;

    public PackageServicesService(EventStoreDBClient client) {
        this.client = client;
    }

    @Async
    public CompletableFuture<PackageServices> addPackageAndServices(PackageServices packageServices) {
        final EventData data = EventData.builderAsJson("package_services_add", packageServices).build();
        client.appendToStream("package_services", data).join();
        return CompletableFuture.completedFuture(packageServices);
    }

    @Async
    public CompletableFuture<PackageServices> updatePackageAndServices(PackageServices packageServices) {
        final EventData data = EventData.builderAsJson("package_services_update", packageServices).build();
        client.appendToStream("package_services", data).join();
        return CompletableFuture.completedFuture(packageServices);
    }

    @Async
    public CompletableFuture<PackageServices> deletePackageAndServices(PackageServices packageServices) {
        final EventData data = EventData.builderAsJson("package_services_delete", packageServices).build();
        client.appendToStream("package_services", data).join();
        return CompletableFuture.completedFuture(packageServices);
    }
}
