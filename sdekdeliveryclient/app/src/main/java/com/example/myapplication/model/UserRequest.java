package com.example.myapplication.model;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
public class UserRequest {
    @JsonProperty
    private String user_login;
    @JsonProperty
    private String user_password;

    public UserRequest() {}

    public UserRequest(String user_login, String user_password) {
        this.user_login = user_login;
        this.user_password = user_password;
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
}
