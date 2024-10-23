package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import java.util.UUID;

public class User {
    UUID user_id;
    String user_login;
    String user_password;
    String user_email;
    String user_phone;
    String user_access_token;
    Role user_role;

    public User(UUID user_id, String user_login, String user_password, String user_email, String user_phone, String user_access_token, Role user_role) {
        this.user_id = user_id;
        this.user_login = user_login;
        this.user_password = user_password;
        this.user_email = user_email;
        this.user_phone = user_phone;
        this.user_access_token = user_access_token;
        this.user_role = user_role;
    }

    public UUID getUser_id() {
        return user_id;
    }

    public void setUser_id(UUID user_id) {
        this.user_id = user_id;
    }

    public String getUser_login() {
        return user_login;
    }

    public void setUser_login(String user_login) {
        this.user_login = user_login;
    }

    public String getUser_password() {
        return user_password;
    }

    public void setUser_password(String user_password) {
        this.user_password = user_password;
    }

    public String getUser_email() {
        return user_email;
    }

    public void setUser_email(String user_email) {
        this.user_email = user_email;
    }

    public String getUser_phone() {
        return user_phone;
    }

    public void setUser_phone(String user_phone) {
        this.user_phone = user_phone;
    }

    public String getUser_access_token() {
        return user_access_token;
    }

    public void setUser_access_token(String user_access_token) {
        this.user_access_token = user_access_token;
    }

    public Role getUser_role() {
        return user_role;
    }

    public void setUser_role(Role userRole) {
        this.user_role = userRole;
    }
}
