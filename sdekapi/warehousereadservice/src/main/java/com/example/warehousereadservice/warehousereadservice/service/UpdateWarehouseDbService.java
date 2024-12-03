package com.example.warehousereadservice.warehousereadservice.service;

import com.eventstore.dbclient.*;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseResponse;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRepository;
import jakarta.annotation.PostConstruct;
import org.apache.commons.lang3.SerializationUtils;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
public class UpdateWarehouseDbService {
    private final EventStoreDBClient client;
    private final WarehouseRepository repository;

    public UpdateWarehouseDbService(EventStoreDBClient client, WarehouseRepository repository) {
        this.client = client;
        this.repository = repository;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener listener = new SubscriptionListener() {
            @Override
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                final RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "warehouse_add", "warehouse_update" -> repository.save(SerializationUtils.deserialize(ev.getEventData()));
                    case "warehouse_delete" -> repository.delete(SerializationUtils.deserialize(ev.getEventData()));
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
