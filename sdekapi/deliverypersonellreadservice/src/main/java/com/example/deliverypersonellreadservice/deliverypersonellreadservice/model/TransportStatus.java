package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

public class TransportStatus {
    int status_id;
    String status_name;

    public TransportStatus(int status_id, String status_name) {
        this.status_id = status_id;
        this.status_name = status_name;
    }

    public int getType_id() {
        return status_id;
    }

    public void setType_id(int status_id) {
        this.status_id = status_id;
    }

    public String getType_name() {
        return status_name;
    }

    public void setType_name(String status_name) {
        this.status_name = status_name;
    }
}
