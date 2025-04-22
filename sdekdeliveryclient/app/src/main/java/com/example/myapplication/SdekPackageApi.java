package com.example.myapplication;

import com.example.myapplication.model.PackageResponse;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.PATCH;
import retrofit2.http.Query;

import java.util.List;

public interface SdekPackageApi {
    @GET("/packagereadservice/api/packages")
    Call<List<PackageResponse>> packages();

    @GET("/packagereadservice/api/package_status")
    Call<ResponseBody> packageStatus(@Query("id") int id);

    @PATCH("/packageservice/api/package")
    Call<ResponseBody> updatePackage(@Body PackageResponse packageResponse);
}
