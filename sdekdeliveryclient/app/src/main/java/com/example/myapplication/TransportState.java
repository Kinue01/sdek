package com.example.myapplication;

import java.util.UUID;

public final class TransportState {
    private String transport_id;
    private double lat;
    private double lon;

    public TransportState(String transport_id, double lat, double lon) {
        this.transport_id = transport_id;
        this.lat = lat;
        this.lon = lon;
    }

    public String getTransport_id() {
        return transport_id;
    }

    public void setTransport_id(String transport_id) {
        this.transport_id = transport_id;
    }

    public double getLat() {
        return lat;
    }

    public void setLat(double lat) {
        this.lat = lat;
    }

    public double getLon() {
        return lon;
    }

    public void setLon(double lon) {
        this.lon = lon;
    }
}
