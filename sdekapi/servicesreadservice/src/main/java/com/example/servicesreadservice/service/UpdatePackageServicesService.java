package com.example.servicesreadservice.service;

import com.eventstore.dbclient.*;
import com.example.servicesreadservice.model.DbPackage;
import com.example.servicesreadservice.model.PackageServiceResponse;
import com.example.servicesreadservice.repository.PackageRepository;
import com.example.servicesreadservice.repository.ServiceRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

@Service
public class UpdatePackageServicesService {
    private final EventStoreDBClient eventStoreDBClient;
    private final PackageRepository packageRepository;
    private final ServiceRepository serviceRepository;
    private final ObjectMapper objectMapper;

    public UpdatePackageServicesService(EventStoreDBClient eventStoreDBClient, ObjectMapper objectMapper, ServiceRepository serviceRepository, PackageRepository packageRepository) {
        this.eventStoreDBClient = eventStoreDBClient;
        this.objectMapper = objectMapper;
        this.serviceRepository = serviceRepository;
        this.packageRepository = packageRepository;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener listener = new SubscriptionListener() {
            @Override
            @SneakyThrows
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "package_services_add", "package_services_update" -> {
                        PackageServiceResponse response = objectMapper.readValue(ev.getEventData(), PackageServiceResponse.class);

                        serviceRepository.save(response.getService()); // save service

                        DbPackage dbPackage = packageRepository.findById(response.getDb_package().getPackage_uuid()).orElse(null);
                        assert dbPackage != null;
                        dbPackage.getPackage_services().add(response.getService());
                        packageRepository.save(dbPackage); // save package with new/updated service
                    }
                    case "package_services_delete" -> {
                        PackageServiceResponse input = objectMapper.readValue(ev.getEventData(), PackageServiceResponse.class);

                        serviceRepository.delete(input.getService());

                        DbPackage dbPackage = packageRepository.findById(input.getDb_package().getPackage_uuid()).orElse(null);
                        assert dbPackage != null;
                        dbPackage.getPackage_services().remove(input.getService());
                        packageRepository.save(dbPackage);
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
