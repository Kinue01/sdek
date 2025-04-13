package com.example.myapplication;

import com.example.myapplication.model.UserRequest;
import com.example.myapplication.model.UserResponse;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.POST;

public interface SdekAuthApi {
    @POST("user")
    Call<UserResponse> getUser(@Body UserRequest user);
}
