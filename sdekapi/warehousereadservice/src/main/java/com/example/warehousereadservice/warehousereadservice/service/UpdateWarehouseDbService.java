package com.example.warehousereadservice.warehousereadservice.service;

import com.eventstore.dbclient.*;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseResponse;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

@Service
public class UpdateWarehouseDbService {
    private final EventStoreDBClient client;
    private final WarehouseRepository repository;
    private final ObjectMapper objectMapper;

    public UpdateWarehouseDbService(EventStoreDBClient client, WarehouseRepository repository, ObjectMapper objectMapper) {
        this.client = client;
        this.repository = repository;
        this.objectMapper = objectMapper;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener listener = new SubscriptionListener() {
            @Override
            @SneakyThrows
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                final RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "warehouse_add", "warehouse_update" -> repository.save(objectMapper.readValue(ev.getEventData(), WarehouseResponse.class));
                    case "warehouse_delete" -> repository.delete(objectMapper.readValue(ev.getEventData(), WarehouseResponse.class));
                }
            }

            @Override
            public void onCancelled(Subscription subscription, Throwable exception) {
                if (exception == null) return;
                super.onCancelled(subscription, exception);

            }
        };

        client.subscribeToStream("warehouse", listener);
    }
}
