package com.example.deliverypersonellservice.deliverypersonellservice.model;

public class DeliveryPerson {
    int person_id;
    String person_lastname;
    String person_firstname;
    String person_middlename;
    User user;
    Transport transport;

    public DeliveryPerson(int person_id, String person_lastname, String person_firstname, String person_middlename, User user, Transport transport) {
        this.person_id = person_id;
        this.person_lastname = person_lastname;
        this.person_firstname = person_firstname;
        this.person_middlename = person_middlename;
        this.user = user;
        this.transport = transport;
    }

    public int getPerson_id() {
        return person_id;
    }

    public void setPerson_id(int person_id) {
        this.person_id = person_id;
    }

    public String getPerson_lastname() {
        return person_lastname;
    }

    public void setPerson_lastname(String person_lastname) {
        this.person_lastname = person_lastname;
    }

    public String getPerson_firstname() {
        return person_firstname;
    }

    public void setPerson_firstname(String person_firstname) {
        this.person_firstname = person_firstname;
    }

    public String getPerson_middlename() {
        return person_middlename;
    }

    public void setPerson_middlename(String person_middlename) {
        this.person_middlename = person_middlename;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Transport getTransport() {
        return transport;
    }

    public void setTransport(Transport transport) {
        this.transport = transport;
    }
}
