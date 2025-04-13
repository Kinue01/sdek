package com.example.deliverypersonellreadservice.deliverypersonellreadservice.controller;

import org.springframework.web.bind.annotation.*;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPersonResponse;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.service.DeliveryPersonService;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping(value = "/deliverypersonellreadservice/api", produces = "application/json")
public class DeliveryPersonController {
    private final DeliveryPersonService service;

    public DeliveryPersonController(DeliveryPersonService service) {
        this.service = service;
    }

    @GetMapping("/delivery_person/{id}")
    public DeliveryPersonResponse getPerson(@PathVariable("id") int id) {
        return service.getPersonById(id);
    }

    @GetMapping("/delivery_personell")
    public List<DeliveryPersonResponse> getPersons() {
        return service.getPersons();
    }
}
