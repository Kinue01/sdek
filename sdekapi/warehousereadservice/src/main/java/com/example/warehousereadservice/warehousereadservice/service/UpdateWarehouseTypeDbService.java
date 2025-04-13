package com.example.warehousereadservice.warehousereadservice.service;

import com.eventstore.dbclient.*;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

@Service
public class UpdateWarehouseTypeDbService {
    private final EventStoreDBClient client;
    private final WarehouseTypeRepository repository;
    private final ObjectMapper mapper;

    public UpdateWarehouseTypeDbService(EventStoreDBClient client, WarehouseTypeRepository repository, ObjectMapper mapper) {
        this.client = client;
        this.repository = repository;
        this.mapper = mapper;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener listener = new SubscriptionListener() {
            @Override
            @SneakyThrows
            public void onEvent(Subscription subscription, ResolvedEvent ev) {
                final RecordedEvent event = ev.getOriginalEvent();
                switch (event.getEventType()) {
                    case "warehouse_type_add", "warehouse_type_update" -> repository.save(mapper.readValue(event.getEventData(), WarehouseType.class));
                    case "warehouse_type_delete" -> repository.delete(mapper.readValue(event.getEventData(), WarehouseType.class));
                }
            }

            @Override
            public void onCancelled(Subscription subscription, Throwable exception) {
                if (exception == null) return;
                super.onCancelled(subscription, exception);
            }
        };

        client.subscribeToStream("warehouse_type", listener);
    }
}
