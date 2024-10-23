package com.example.deliverypersonellservice.deliverypersonellservice.model;

public class Role {
    int role_id;
    String role_name;

    public Role(int role_id, String role_name) {
        this.role_id = role_id;
        this.role_name = role_name;
    }

    public int getType_id() {
        return role_id;
    }

    public void setType_id(int role_id) {
        this.role_id = role_id;
    }

    public String getType_name() {
        return role_name;
    }

    public void setType_name(String role_name) {
        this.role_name = role_name;
    }
}
