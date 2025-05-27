package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.kurrent.dbclient.*;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class UpdateWarehouseTypeDbService {
    private static final Logger logger = LoggerFactory.getLogger(UpdateWarehouseTypeDbService.class);

    private final KurrentDBClient client;
    private final WarehouseTypeRepository repository;
    private final ObjectMapper mapper;

    public UpdateWarehouseTypeDbService(KurrentDBClient client, WarehouseTypeRepository repository, ObjectMapper mapper) {
        this.client = client;
        this.repository = repository;
        this.mapper = mapper;
    }

    @PostConstruct
    public void init() {
        SubscribeToStreamOptions options = SubscribeToStreamOptions.get().batchSize(1024).fromStart();
        client.subscribeToStream("warehouse_type", new SubscriptionListener() {
            @Override
            @SneakyThrows
            public void onEvent(io.kurrent.dbclient.Subscription subscription, ResolvedEvent event) {
                final RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "warehouse_type_add", "warehouse_type_update" -> repository.save(mapper.readValue(ev.getEventData(), WarehouseType.class));
                    case "warehouse_type_delete" -> repository.delete(mapper.readValue(ev.getEventData(), WarehouseType.class));
                }
            }

            @Override
            public void onCancelled(io.kurrent.dbclient.Subscription subscription, Throwable exception) {
                logger.error(exception.getMessage(), exception);
            }
        }, options);
    }
}
