package com.example.deliverypersonellservice.deliverypersonellservice.controller;

import com.example.deliverypersonellservice.deliverypersonellservice.model.DeliveryPerson;
import com.example.deliverypersonellservice.deliverypersonellservice.service.DeliveryPersonService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping(value = "/deliverypersonellservice/api/delivery_person", produces = "application/json")
public class DeliveryPersonController {
    private final DeliveryPersonService service;

    public DeliveryPersonController(DeliveryPersonService service) {
        this.service = service;
    }

    @PostMapping
    @ResponseStatus(value = HttpStatus.CREATED)
    public DeliveryPerson addPerson(@RequestBody DeliveryPerson person) {
        return service.addPerson(person);
    }
    
    @PatchMapping
    public DeliveryPerson updatePerson(@RequestBody DeliveryPerson person) {
        return service.updatePerson(person);
    }

    @DeleteMapping
    public DeliveryPerson deletePerson(@RequestBody DeliveryPerson person) {
        return service.deletePerson(person);
    }
}
