package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "tb_delivery_perosnell")
public class DeliveryPerson {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int person_id;
    
    String person_lastname;
    String person_firstname;
    String person_middlename;
    int person_user_id;
    int person_transport_id;
    
    public DeliveryPerson(int person_id, String person_lastname, String person_firstname, String person_middlename, int person_user_id, int person_transport_id) {
        this.person_id = person_id;
        this.person_lastname = person_lastname;
        this.person_middlename = person_middlename;
        this.person_user_id = person_user_id;
        this.person_transport_id = person_transport_id;
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

    public int getPerson_user_id() {
        return person_user_id;
    }

    public void setPerson_user_id(int id) {
        this.person_user_id = id;
    }

    public int getPerson_transport_id() {
        return person_transport_id;
    }

    public void setPerson_transport_id(int id) {
        this.person_transport_id = id;
    }
}
