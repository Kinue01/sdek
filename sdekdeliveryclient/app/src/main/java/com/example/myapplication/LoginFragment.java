package com.example.myapplication;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import com.example.myapplication.databinding.FragmentLoginBinding;
import com.example.myapplication.model.DeliveryPersonResponse;
import com.example.myapplication.model.UserRequest;
import com.example.myapplication.model.UserResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import okhttp3.MediaType;
import org.jetbrains.annotations.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import retrofit2.*;
import retrofit2.converter.gson.GsonConverterFactory;

import java.util.List;

import static androidx.navigation.fragment.FragmentKt.findNavController;

public class LoginFragment extends Fragment {
    private FragmentLoginBinding binding;
    private SdekAuthApi authApi;
    private SdekDeliveryPersonApi deliveryPersonApi;

    @Override
    public void onCreate(@Nullable @org.jetbrains.annotations.Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        final Retrofit authRetrofit = new Retrofit.Builder()
                .baseUrl("http://192.168.0.242:8080/authservice/api/")
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        authApi = authRetrofit.create(SdekAuthApi.class);

        final Retrofit deliveryRetrofit = new Retrofit.Builder()
                .baseUrl("http://192.168.0.242:8080/deliverypersonellreadservice/api/")
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        deliveryPersonApi = deliveryRetrofit.create(SdekDeliveryPersonApi.class);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        binding = FragmentLoginBinding.inflate(getLayoutInflater());
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable @org.jetbrains.annotations.Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        binding.btnLogin.setOnClickListener(v -> {
            final String user = binding.emailInp.getText().toString();
            final String pass = binding.passInp.getText().toString();

            authApi.getUser(new UserRequest(user, pass)).enqueue(new Callback<>() {
                @Override
                public void onResponse(Call<UserResponse> call, Response<UserResponse> response) {
                    if (response.isSuccessful() && response.body() != null && response.body().user_id() != null) {
                        UserContext.currentUser = response.body();

                        deliveryPersonApi.personList().enqueue(new Callback<>() {
                            @Override
                            public void onResponse(Call<List<DeliveryPersonResponse>> call, Response<List<DeliveryPersonResponse>> response) {
                                assert response.body() != null;
                                UserContext.currentDeliveryPerson = response.body()
                                        .stream()
                                        .filter(d -> d.person_user().user_id().equals(UserContext.currentUser.user_id()))
                                        .findFirst().orElse(null);
                            }

                            @Override
                            public void onFailure(Call<List<DeliveryPersonResponse>> call, Throwable throwable) {
                                System.out.println(throwable);
                            }
                        });

                        findNavController(LoginFragment.this).navigate(LoginFragmentDirections.actionLoginFragmentToHomeFragment());
                    }
                }

                @Override
                public void onFailure(Call<UserResponse> call, Throwable throwable) {
                    System.out.println(throwable);
                }
            });
        });
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        binding = null;
        authApi = null;
    }
}