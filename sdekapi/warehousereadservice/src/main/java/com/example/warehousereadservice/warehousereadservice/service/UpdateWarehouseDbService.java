package com.example.warehousereadservice.warehousereadservice.service;

import com.eventstore.dbclient.*;
import com.example.warehousereadservice.warehousereadservice.model.Warehouse;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.stereotype.Service;
import java.util.concurrent.ExecutionException;

class UpdateTask implements Runnable {
    EventStoreDBClient client;
    final WarehouseRepository repository;

    public UpdateTask(EventStoreDBClient client, WarehouseRepository repository) {
        this.client = client;
        this.repository = repository;
    }

    @Override
    public void run() {
        ReadStreamOptions options = ReadStreamOptions.get().forwards().fromStart();
        try {
            while (true) {
                ReadResult res = client.readStream("warehouse", options).get();
                res.getEvents().forEach(resolvedEvent -> {
                    RecordedEvent event = resolvedEvent.getOriginalEvent();
                    switch (event.getEventType()) {
                        case "warehouse_add", "warehouse_update" -> {
                            repository.save(new ObjectMapper().convertValue(event.getEventData(), Warehouse.class));
                        }
                        case "warehouse_delete" -> {
                            repository.delete(new ObjectMapper().convertValue(event.getEventData(), Warehouse.class));
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
public class UpdateWarehouseDbService {
    TaskExecutor executor;
    EventStoreDBClient client;
    final WarehouseRepository repository;

    @Autowired
    public UpdateWarehouseDbService(TaskExecutor executor, EventStoreDBClient client, WarehouseRepository repository) {
        this.executor = executor;
        this.client = client;
        this.repository = repository;
    }

    public void init() {
        executor.execute(new UpdateTask(client, repository));
    }
}
