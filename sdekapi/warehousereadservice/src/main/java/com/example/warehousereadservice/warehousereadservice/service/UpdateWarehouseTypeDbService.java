package com.example.warehousereadservice.warehousereadservice.service;

import com.eventstore.dbclient.*;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

@Service
public class UpdateWarehouseTypeDbService {
    EventStoreDBClient client;
    final WarehouseTypeRepository repository;

    public UpdateWarehouseTypeDbService(EventStoreDBClient client, WarehouseTypeRepository repository) {
        this.client = client;
        this.repository = repository;
    }

    public void init() {
        SubscriptionListener listener = new SubscriptionListener() {
            @Override
            public void onEvent(Subscription subscription, ResolvedEvent ev) {
                RecordedEvent event = ev.getOriginalEvent();
                switch (event.getEventType()) {
                    case "warehouse_type_add", "warehouse_type_update" -> {
                        repository.save(new ObjectMapper().convertValue(event.getEventData(), WarehouseType.class));
                    }
                    case "warehouse_type_delete" -> {
                        repository.delete(new ObjectMapper().convertValue(event.getEventData(), WarehouseType.class));
                    }
                }
            }
        };
        client.subscribeToStream("warehouse_type", listener);
    }
}
