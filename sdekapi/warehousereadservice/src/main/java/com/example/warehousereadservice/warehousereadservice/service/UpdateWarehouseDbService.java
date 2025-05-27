package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseResponse;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.kurrent.dbclient.*;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class UpdateWarehouseDbService {
    private static final Logger logger = LoggerFactory.getLogger(UpdateWarehouseDbService.class);

    private final KurrentDBClient client;
    private final WarehouseRepository repository;
    private final ObjectMapper objectMapper;

    public UpdateWarehouseDbService(KurrentDBClient client, WarehouseRepository repository, ObjectMapper objectMapper) {
        this.client = client;
        this.repository = repository;
        this.objectMapper = objectMapper;
    }

    @PostConstruct
    public void init() {
        SubscribeToStreamOptions options = SubscribeToStreamOptions.get().batchSize(1024).fromStart();
        client.subscribeToStream("warehouse", new SubscriptionListener() {
            @Override
            @SneakyThrows
            public void onEvent(io.kurrent.dbclient.Subscription subscription, ResolvedEvent event) {
                final RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "warehouse_add", "warehouse_update" -> repository.save(objectMapper.readValue(ev.getEventData(), WarehouseResponse.class));
                    case "warehouse_delete" -> repository.delete(objectMapper.readValue(ev.getEventData(), WarehouseResponse.class));
                }
            }

            @Override
            public void onCancelled(io.kurrent.dbclient.Subscription subscription, Throwable exception) {
                logger.error(exception.getMessage(), exception);
            }
        }, options);
    }
}
