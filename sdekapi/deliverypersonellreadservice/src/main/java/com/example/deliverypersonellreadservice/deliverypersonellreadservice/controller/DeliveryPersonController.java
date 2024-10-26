package com.example.deliverypersonellreadservice.deliverypersonellreadservice.controller;

import com.example.deliverypersonellreadservice.deliverypersonellreadservice.service.UpdateDeliveryPersonellDbService;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPersonResponse;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.service.DeliveryPersonService;
import java.util.concurrent.ExecutionException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@RestController
@RequestMapping(value = "/api/delivery_persons", produces = "application/json")
public class DeliveryPersonController {
    DeliveryPersonService service;

    public DeliveryPersonController(DeliveryPersonService service, UpdateDeliveryPersonellDbService readService) {
        this.service = service;
        readService.init();
    }

    @GetMapping
    public DeliveryPersonResponse getPerson(@RequestParam int id) {
        try {
            var res = service.getPersonById(id);
            return res.get();
        }
        catch (InterruptedException | ExecutionException e) {
            return null;
        }
    }

    @GetMapping
    public Iterable<DeliveryPersonResponse> getPersons() {
        try {
            var res = service.getPersons();
            return res.get();
        }
        catch (InterruptedException | ExecutionException e) {
            return null;
        }
    }
}
