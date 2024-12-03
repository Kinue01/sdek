package com.example.warehousereadservice.warehousereadservice.service;

import com.eventstore.dbclient.*;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseLocationRepository;
import jakarta.annotation.PostConstruct;
import org.apache.commons.lang3.SerializationUtils;
import org.springframework.stereotype.Service;

@Service
public class UpdateWarehouseLocationsService {
    private final WarehouseLocationRepository warehouseLocationRepository;
    private final EventStoreDBClient eventStoreDBClient;

    public UpdateWarehouseLocationsService(WarehouseLocationRepository warehouseLocationRepository, EventStoreDBClient eventStoreDBClient) {
        this.warehouseLocationRepository = warehouseLocationRepository;
        this.eventStoreDBClient = eventStoreDBClient;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener subscriptionListener = new SubscriptionListener() {
            @Override
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                final RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "warehouseLocation_add", "warehouseLocation_update" -> warehouseLocationRepository.save(SerializationUtils.deserialize(ev.getEventData()));
                    case "warehouseLocation_delete" -> warehouseLocationRepository.delete(SerializationUtils.deserialize(ev.getEventData()));
                }
                super.onEvent(subscription, event);
            }

            @Override
            public void onCancelled(Subscription subscription, Throwable exception) {
                super.onCancelled(subscription, exception);
            }
        };

        eventStoreDBClient.subscribeToStream("warehouseLocations", subscriptionListener);
    }
}
