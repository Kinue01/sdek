package com.example.warehousereadservice.warehousereadservice.service;

import com.eventstore.dbclient.*;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import org.apache.commons.lang3.SerializationUtils;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
public class UpdateWarehouseTypeDbService {
    private final EventStoreDBClient client;
    private final WarehouseTypeRepository repository;

    public UpdateWarehouseTypeDbService(EventStoreDBClient client, WarehouseTypeRepository repository) {
        this.client = client;
        this.repository = repository;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener listener = new SubscriptionListener() {
            @Override
            public void onEvent(Subscription subscription, ResolvedEvent ev) {
                final RecordedEvent event = ev.getOriginalEvent();
                switch (event.getEventType()) {
                    case "warehouse_type_add", "warehouse_type_update" -> repository.save(SerializationUtils.deserialize(event.getEventData()));
                    case "warehouse_type_delete" -> repository.delete(SerializationUtils.deserialize(event.getEventData()));
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
