package com.example.deliverypersonellservice.deliverypersonellservice.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.example.deliverypersonellservice.deliverypersonellservice.model.DeliveryPerson;
import com.example.deliverypersonellservice.deliverypersonellservice.service.DeliveryPersonService;

import java.util.concurrent.ExecutionException;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@RestController
@RequestMapping(value = "/api/delivery_person", produces = "application/json")
public class DeliveryPersonController {
    DeliveryPersonService service;

    public DeliveryPersonController(DeliveryPersonService service) {
        this.service = service;
    }

    @PostMapping
    @ResponseStatus(value = HttpStatus.CREATED)
    public DeliveryPerson addPerson(@RequestBody DeliveryPerson person) {
        try {
            return service.addPerson(person).get();
        }
        catch (ExecutionException | InterruptedException e) {
            return null;
        }
    }
    
    @PatchMapping
    public DeliveryPerson updatePerson(@RequestBody DeliveryPerson person) {
        try {
            return service.updatePerson(person).get();
        }
        catch (ExecutionException | InterruptedException e) {
            return null;
        }
    }

    @DeleteMapping
    public DeliveryPerson deletePerson(@RequestBody DeliveryPerson person) {
        try {
            return service.deletePerson(person).get();
        }
        catch (ExecutionException | InterruptedException e) {
            return null;
        }
    }
}
