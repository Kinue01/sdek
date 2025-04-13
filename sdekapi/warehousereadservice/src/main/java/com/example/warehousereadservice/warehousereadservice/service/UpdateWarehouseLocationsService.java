package com.example.warehousereadservice.warehousereadservice.service;

import com.eventstore.dbclient.*;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseLocation;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseLocationRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

@Service
public class UpdateWarehouseLocationsService {
    private final WarehouseLocationRepository warehouseLocationRepository;
    private final EventStoreDBClient eventStoreDBClient;
    private final ObjectMapper objectMapper;

    public UpdateWarehouseLocationsService(WarehouseLocationRepository warehouseLocationRepository, EventStoreDBClient eventStoreDBClient, ObjectMapper objectMapper) {
        this.warehouseLocationRepository = warehouseLocationRepository;
        this.eventStoreDBClient = eventStoreDBClient;
        this.objectMapper = objectMapper;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener subscriptionListener = new SubscriptionListener() {
            @Override
            @SneakyThrows
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                final RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "warehouseLocation_add", "warehouseLocation_update" -> warehouseLocationRepository.save(objectMapper.readValue(ev.getEventData(), WarehouseLocation.class));
                    case "warehouseLocation_delete" -> warehouseLocationRepository.delete(objectMapper.readValue(ev.getEventData(), WarehouseLocation.class));
                }
                super.onEvent(subscription, event);
            }

            @Override
            public void onCancelled(Subscription subscription, Throwable exception) {
                super.onCancelled(subscription, exception);
            }
        };

        eventStoreDBClient.subscribeToStream("warehouseLocation", subscriptionListener);
    }
}
