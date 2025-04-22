package com.example.myapplication;

import com.example.myapplication.model.DeliveryPersonResponse;
import retrofit2.Call;
import retrofit2.http.GET;

import java.util.List;

public interface SdekDeliveryPersonApi {
    @GET("delivery_personell")
    Call<List<DeliveryPersonResponse>> personList();
}
