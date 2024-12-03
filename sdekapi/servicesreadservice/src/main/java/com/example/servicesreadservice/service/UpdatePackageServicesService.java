package com.example.servicesreadservice.service;

import com.eventstore.dbclient.*;
import com.example.servicesreadservice.mapper.PackageServicesToResponseMapper;
import com.example.servicesreadservice.model.PackageServiceResponse;
import com.example.servicesreadservice.model.PackageServices;
import com.example.servicesreadservice.repository.PackageServiceRepository;
import jakarta.annotation.PostConstruct;
import org.apache.commons.lang3.SerializationUtils;
import org.springframework.stereotype.Service;

@Service
public class UpdatePackageServicesService {
    private final EventStoreDBClient eventStoreDBClient;
    private final PackageServiceRepository packageServiceRepository;

    public UpdatePackageServicesService(EventStoreDBClient eventStoreDBClient, PackageServiceRepository packageServiceRepository) {
        this.eventStoreDBClient = eventStoreDBClient;
        this.packageServiceRepository = packageServiceRepository;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener listener = new SubscriptionListener() {
            @Override
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "package_services_add", "package_services_update" -> {
                        PackageServiceResponse response = SerializationUtils.deserialize(ev.getEventData());
                        packageServiceRepository.save(PackageServicesToResponseMapper.modelMapper.map(response, PackageServices.class));
                    }
                    case "package_services_delete" -> {
                        PackageServiceResponse input = SerializationUtils.deserialize(ev.getEventData());
                        packageServiceRepository.delete(PackageServicesToResponseMapper.modelMapper.map(input, PackageServices.class));
                    }
                }
                super.onEvent(subscription, event);
            }

            @Override
            public void onCancelled(Subscription subscription, Throwable exception) {
                if (exception == null) return;
                super.onCancelled(subscription, exception);
            }
        };

        eventStoreDBClient.subscribeToStream("package_services", listener);
    }
}
