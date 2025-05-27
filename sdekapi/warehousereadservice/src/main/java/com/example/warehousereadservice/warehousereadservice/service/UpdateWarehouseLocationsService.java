package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseLocation;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseLocationRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.kurrent.dbclient.*;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class UpdateWarehouseLocationsService {
    private static final Logger logger = LoggerFactory.getLogger(UpdateWarehouseLocationsService.class);

    private final WarehouseLocationRepository warehouseLocationRepository;
    private final KurrentDBClient eventStoreDBClient;
    private final ObjectMapper objectMapper;

    public UpdateWarehouseLocationsService(WarehouseLocationRepository warehouseLocationRepository, KurrentDBClient eventStoreDBClient, ObjectMapper objectMapper) {
        this.warehouseLocationRepository = warehouseLocationRepository;
        this.eventStoreDBClient = eventStoreDBClient;
        this.objectMapper = objectMapper;
    }

    @PostConstruct
    public void init() {
        SubscribeToStreamOptions options = SubscribeToStreamOptions.get().batchSize(1024).fromStart();
        eventStoreDBClient.subscribeToStream("warehouseLocation", new SubscriptionListener() {
            @Override
            @SneakyThrows
            public void onEvent(io.kurrent.dbclient.Subscription subscription, ResolvedEvent event) {
                final RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "warehouseLocation_add", "warehouseLocation_update" -> warehouseLocationRepository.save(objectMapper.readValue(ev.getEventData(), WarehouseLocation.class));
                    case "warehouseLocation_delete" -> warehouseLocationRepository.delete(objectMapper.readValue(ev.getEventData(), WarehouseLocation.class));
                }
            }

            @Override
            public void onCancelled(io.kurrent.dbclient.Subscription subscription, Throwable exception) {
                logger.error(exception.getMessage(), exception);
            }
        }, options);
    }
}
