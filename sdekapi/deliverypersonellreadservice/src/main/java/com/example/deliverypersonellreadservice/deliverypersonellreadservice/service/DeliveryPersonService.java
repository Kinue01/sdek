package com.example.deliverypersonellreadservice.deliverypersonellreadservice.service;

import java.util.ArrayList;
import java.util.concurrent.CompletableFuture;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPerson;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPersonRedis;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPersonResponse;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.Transport;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository.DeliveryPersonRedisRepository;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository.DeliveryPersonRepository;

@Service
public class DeliveryPersonService {
    DeliveryPersonRepository repository;
    DeliveryPersonRedisRepository redisRepository;

    public DeliveryPersonService(DeliveryPersonRepository repository, DeliveryPersonRedisRepository redisRepository) {
        this.redisRepository = redisRepository;
        this.repository = repository;
    }

    @Async
    public CompletableFuture<Iterable<DeliveryPersonResponse>> getPersons() {
        var redis = (ArrayList<DeliveryPersonRedis>)redisRepository.findAll();
        if (!redis.isEmpty()) {
            var res = redis.parallelStream().map(item -> {
                var user = new RestTemplate().getForEntity("http://localhost:8001/api/users", com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.User.class);
                    var transport = new RestTemplate().getForEntity("http://localhost:8011/api/transports", Transport.class);

                    return new DeliveryPersonResponse(
                        item.getPerson_id(), 
                        item.getPerson_lastname(), 
                        item.getPerson_firstname(),
                        item.getPerson_middlename(),
                        user.getBody(),
                        transport.getBody()
                    );
            }).toList();
            return CompletableFuture.completedFuture(res);
        }

        var remote = (ArrayList<DeliveryPerson>)repository.findAll();
        if (!remote.isEmpty()) {
            var res = remote.parallelStream().map(item -> {
                var user = new RestTemplate().getForEntity("http://localhost:8001/api/users", com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.User.class);
                    var transport = new RestTemplate().getForEntity("http://localhost:8011/api/transports", Transport.class);

                    return new DeliveryPersonResponse(
                        item.getPerson_id(),
                        item.getPerson_lastname(),
                        item.getPerson_firstname(),
                        item.getPerson_middlename(),
                        user.getBody(),
                        transport.getBody()
                    );
            }).toList();
            return CompletableFuture.completedFuture(res);
        }

        return null;
    }

    @Async
    public CompletableFuture<DeliveryPersonResponse> getPersonById(int id) {
        var redis = redisRepository.findById(id);
        if (redis.isPresent()) {
            return CompletableFuture.completedFuture(
                new DeliveryPersonResponse(
                    redis.get().getPerson_id(), 
                    redis.get().getPerson_lastname(),
                    redis.get().getPerson_firstname(), 
                    redis.get().getPerson_middlename(), 
                    redis.get().getPerson_user_id(), 
                    redis.get().getPerson_transport_id()
                )
            );
        }

        var remote = repository.findById(id);
        if (remote.isPresent()) {
            var user = new RestTemplate().getForEntity("http://localhost:8001/api/users", com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.User.class);
                var transport = new RestTemplate().getForEntity("http://localhost:8011/api/transports", Transport.class);

                return CompletableFuture.completedFuture(
                    new DeliveryPersonResponse(
                        remote.get().getPerson_id(), 
                        remote.get().getPerson_lastname(),
                        remote.get().getPerson_firstname(), 
                        remote.get().getPerson_middlename(), 
                        user.getBody(), 
                        transport.getBody()
                    )
                );
        }

        return null;
    }
}
