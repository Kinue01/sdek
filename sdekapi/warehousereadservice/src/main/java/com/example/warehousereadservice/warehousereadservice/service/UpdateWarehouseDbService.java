package com.example.warehousereadservice.warehousereadservice.service;

import com.eventstore.dbclient.*;
import com.example.warehousereadservice.warehousereadservice.model.Warehouse;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UpdateWarehouseDbService {
    EventStoreDBClient client;
    final WarehouseRepository repository;

    @Autowired
    public UpdateWarehouseDbService(EventStoreDBClient client, WarehouseRepository repository) {
        this.client = client;
        this.repository = repository;
    }

    public void init() {
        SubscriptionListener listener = new SubscriptionListener() {
            @Override
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "warehouse_add", "warehouse_update" -> {
                        repository.save(new ObjectMapper().convertValue(ev.getEventData(), Warehouse.class));
                    }
                    case "warehouse_delete" -> {
                        repository.delete(new ObjectMapper().convertValue(ev.getEventData(), Warehouse.class));
                    }
                }
            }

            @Override
            public void onCancelled(Subscription subscription, Throwable exception) {
                if (exception == null)
                    return;
                super.onCancelled(subscription, exception);

            }
        };
        client.subscribeToStream("warehouse", listener);
    }
}
