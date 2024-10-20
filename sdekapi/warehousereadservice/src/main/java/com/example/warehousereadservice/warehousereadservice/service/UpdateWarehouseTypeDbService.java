package com.example.warehousereadservice.warehousereadservice.service;

import com.eventstore.dbclient.EventStoreDBClient;
import com.eventstore.dbclient.ReadResult;
import com.eventstore.dbclient.ReadStreamOptions;
import com.eventstore.dbclient.RecordedEvent;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.stereotype.Service;
import java.util.concurrent.ExecutionException;

class UpdateTypesTask implements Runnable {
    EventStoreDBClient client;
    final WarehouseTypeRepository repository;

    public UpdateTypesTask(EventStoreDBClient client, WarehouseTypeRepository repository) {
        this.client = client;
        this.repository = repository;
    }

    @Override
    public void run() {
        ReadStreamOptions options = ReadStreamOptions.get().forwards().fromStart();
        try {
            while (true) {
                ReadResult res = client.readStream("warehouse_type", options).get();
                res.getEvents().forEach(resolvedEvent -> {
                    RecordedEvent event = resolvedEvent.getOriginalEvent();
                    switch (event.getEventType()) {
                        case "warehouse_type_add", "warehouse_type_update" -> {
                            repository.save(new ObjectMapper().convertValue(event.getEventData(), WarehouseType.class));
                        }
                        case "warehouse_type_delete" -> {
                            repository.delete(new ObjectMapper().convertValue(event.getEventData(), WarehouseType.class));
                        }
                    }
                });
            }
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        } catch (ExecutionException e) {
            throw new RuntimeException(e);
        }
    }
}

@Service
public class UpdateWarehouseTypeDbService {
    TaskExecutor executor;
    EventStoreDBClient client;
    final WarehouseTypeRepository repository;

    @Autowired
    public UpdateWarehouseTypeDbService(TaskExecutor executor, EventStoreDBClient client, WarehouseTypeRepository repository) {
        this.executor = executor;
        this.client = client;
        this.repository = repository;
    }

    public void init() {
        executor.execute(new UpdateTypesTask(client, repository));
    }
}
