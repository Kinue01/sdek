package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

public class Transport {
    int transport_id;
    String transport_name;
    String transport_reg_number;
    TransportType transport_type;
    TransportStatus transport_status;

    public Transport(int transport_id, String transport_name, String transport_reg_number, TransportType type, TransportStatus status) {
        this.transport_id = transport_id;
        this.transport_name = transport_name;
        this.transport_reg_number = transport_reg_number;
        this.transport_type = type;
        this.transport_status = status;
    }

    public int getTransport_id() {
        return transport_id;
    }

    public void setTransport_id(int transport_id) {
        this.transport_id = transport_id;
    }

    public String getTransport_name() {
        return transport_name;
    }

    public void setTransport_name(String name) {
        this.transport_name = name;
    }

    public String getTransport_reg_number() {
        return transport_reg_number;
    }

    public void setTransport_reg_number(String number) {
        this.transport_reg_number = number;
    }

    public TransportType getTransport_type() {
        return transport_type;
    }

    public void setTransport_type(TransportType type) {
        this.transport_type = type;
    }

    public TransportStatus getTransport_status() {
        return transport_status;
    }

    public void setTransport_status(TransportStatus status) {
        this.transport_status = status;
    }
}
