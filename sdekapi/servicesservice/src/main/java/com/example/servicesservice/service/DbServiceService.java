package com.example.servicesservice.service;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.servicesservice.model.DbService;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class DbServiceService {
    private final EventStoreDBClient client;

    public DbServiceService(EventStoreDBClient client) {
        this.client = client;
    }

    @Async
    public CompletableFuture<DbService> addService(DbService service) {
        final EventData data = EventData.builderAsJson("service_add", service).build();
        client.appendToStream("service", data).join();
        return CompletableFuture.completedFuture(service);
    }

    @Async
    public CompletableFuture<DbService> updateService(DbService service) {
        final EventData data = EventData.builderAsJson("service_update", service).build();
        client.appendToStream("service", data).join();
        return CompletableFuture.completedFuture(service);
    }

    @Async
    public CompletableFuture<DbService> deleteService(DbService service) {
        final EventData data = EventData.builderAsJson("service_delete", service).build();
        client.appendToStream("service", data).join();
        return CompletableFuture.completedFuture(service);
    }
}
