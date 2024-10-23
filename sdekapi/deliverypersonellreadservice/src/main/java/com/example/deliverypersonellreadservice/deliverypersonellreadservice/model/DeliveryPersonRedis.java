package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import org.springframework.data.redis.core.RedisHash;

import jakarta.persistence.Id;

@RedisHash("delivery_personell")
public class DeliveryPersonRedis {
    @Id
    int person_id;
    
    String person_lastname;
    String person_firstname;
    String person_middlename;
    User person_user;
    Transport person_transport;
    
    public DeliveryPersonRedis(int person_id, String person_lastname, String person_firstname, String person_middlename, User person_user, Transport person_transport) {
        this.person_id = person_id;
        this.person_lastname = person_lastname;
        this.person_middlename = person_middlename;
        this.person_user = person_user;
        this.person_transport = person_transport;
    }

    public int getPerson_id() {
        return person_id;
    }

    public void setPerson_id(int id) {
        this.person_id = id;
    }

    public String getPerson_lastname() {
        return person_lastname;
    }

    public void setPerson_lastname(String lastname) {
        this.person_lastname = lastname;
    }

    public String getPerson_firstname() {
        return person_firstname;
    }

    public void setPerson_firstname(String firstname) {
        this.person_firstname = firstname;
    }

    public String getPerson_middlename() {
        return person_middlename;
    }

    public void setPerson_middlename(String middlename) {
        this.person_middlename = middlename;
    }

    public User getPerson_user_id() {
        return person_user;
    }

    public void setPerson_user_id(User user) {
        this.person_user = user;
    }

    public Transport getPerson_transport_id() {
        return person_transport;
    }

    public void setPerson_transport_id(Transport transport) {
        this.person_transport = transport;
    }
}
