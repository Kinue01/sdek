package com.example.warehouseservice.warehouseservice.controller;

import com.example.warehouseservice.warehouseservice.model.Warehouse;
import com.example.warehouseservice.warehouseservice.service.WarehouseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.util.concurrent.ExecutionException;

@Tag(name = "Warehouse", description = "Warehouse controller")
@RestController
@RequestMapping(path = "/warehouseservice/api/warehouse", produces = "application/json")
public class WarehouseController {
    private final WarehouseService service;

    public WarehouseController(WarehouseService service) {
        this.service = service;
    }

    @Operation(summary = "Add warehouse to event store")
    @ApiResponses(
        value = {
            @ApiResponse(responseCode = "201", description = "Warehouse added", 
            content = { @Content }),
            @ApiResponse(responseCode = "400", description = "Invalid warehouse object", 
            content = { @Content })
        }
    )
    @PostMapping
    @ResponseStatus(value = HttpStatus.CREATED)
    public Warehouse addWarehouse(@io.swagger.v3.oas.annotations.parameters.RequestBody(
        description = "Warehouse to add", required = true,
        content = @Content(mediaType = "application/json",
        schema = @Schema(implementation = Warehouse.class),
        examples = @ExampleObject(
            value = "{\"warehouse_id\": 0, \"warehouse_name\": \"Warehouse 1\", \"warehouse_address\": \"Some address\", \"warehouse_point\": {\"x\": 150.00, \"y\": 240.00}, \"warehouse_type\", null}" //todo write warehouse type example
        ))) @RequestBody Warehouse warehouse) {
       return service.addWarehouse(warehouse).join();
    }

    @Operation(summary = "Update warehouse")
    @ApiResponses(
        value = {
            @ApiResponse(responseCode = "200", description = "Warehouse updated", 
            content = { @Content }),
            @ApiResponse(responseCode = "400", description = "Invalid warehouse object", 
            content = { @Content })
        }
    )
    @PatchMapping
    public Warehouse updateWarehouse(@io.swagger.v3.oas.annotations.parameters.RequestBody(
        description = "Warehouse to update", required = true,
        content = @Content(mediaType = "application/json",
        schema = @Schema(implementation = Warehouse.class),
        examples = @ExampleObject(
            value = "{\"warehouse_id\": 0, \"warehouse_name\": \"Warehouse 1\", \"warehouse_address\": \"Some address\", \"warehouse_point\": {\"x\": 150.00, \"y\": 240.00}, \"warehouse_type\", null}" //todo write warehouse type example
        )))  @RequestBody Warehouse warehouse) {
        return service.updateWarehouse(warehouse).join();
    }

    @Operation(summary = "Delete warehouse")
    @ApiResponses(
        value = {
            @ApiResponse(responseCode = "200", description = "Warehouse deleted", 
            content = { @Content }),
            @ApiResponse(responseCode = "400", description = "Invalid warehouse object", 
            content = { @Content })
        }
    )
    @DeleteMapping
    public Warehouse deleteWarehouse(@io.swagger.v3.oas.annotations.parameters.RequestBody(
        description = "Warehouse to delete", required = true,
        content = @Content(mediaType = "application/json",
        schema = @Schema(implementation = Warehouse.class),
        examples = @ExampleObject(
            value = "{\"warehouse_id\": 100, \"warehouse_name\": \"Warehouse 1\", \"warehouse_address\": \"Some address\", \"warehouse_point\": {\"x\": 150.00, \"y\": 240.00}, \"warehouse_type\", null}" //todo write warehouse type example
        )))  @RequestBody Warehouse warehouse) {
        return service.deleteWarehouse(warehouse).join();
    }
}
