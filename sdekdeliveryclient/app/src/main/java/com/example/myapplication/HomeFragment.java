package com.example.myapplication;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.fragment.app.Fragment;
import com.example.myapplication.databinding.FragmentHomeBinding;
import com.example.myapplication.model.PackageResponse;
import com.example.myapplication.model.PackageStatus;
import com.google.android.gms.location.*;
import com.google.gson.Gson;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.ResponseBody;
import okhttp3.WebSocket;
import org.jetbrains.annotations.NotNull;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

import java.util.ArrayList;
import java.util.List;

import static androidx.core.content.ContextCompat.getSystemService;

public class HomeFragment extends Fragment {
    private FragmentHomeBinding binding;
    private FusedLocationProviderClient mFusedLocationClient;
    private final Gson gson = new Gson();
    private static final int PERMISSION_ID = 44;
    private final Handler handler = new Handler(Looper.myLooper());
    private Runnable task, mainTask;
    private final OkHttpClient httpClient = new OkHttpClient.Builder().build();
    private WebSocket webSocket;
    private SdekPackageApi sdekPackageApi;
    private final List<PackageResponse> packages = new ArrayList<>();
    private final Handler mainHandler = new Handler(Looper.myLooper());
    private ArrayAdapter<String> packagesAdapter;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        packagesAdapter = new ArrayAdapter<>(requireContext(), android.R.layout.simple_list_item_1);
        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(requireContext());

        final Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(BuildConfig.PROD_API_URL)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        sdekPackageApi = retrofit.create(SdekPackageApi.class);

        final Request request = new Request.Builder().url(BuildConfig.PROD_WS + "/transportservice/api/track_transport").build();
        final WS listener = new WS();

        webSocket = httpClient.newWebSocket(request, listener);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        binding = FragmentHomeBinding.inflate(getLayoutInflater());
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NotNull View view, @Nullable @org.jetbrains.annotations.Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        binding.items.setAdapter(packagesAdapter);
        binding.btnOk.setVisibility(View.INVISIBLE);

        mainTask = () -> {
            packagesAdapter.clear();
            packages.clear();

            sdekPackageApi.packages().enqueue(new Callback<>() {
                @Override
                public void onResponse(Call<List<PackageResponse>> call, Response<List<PackageResponse>> response) {
                    response.body().forEach(pkg -> {
                        if (pkg.package_status().status_id() == 1) {
                            packagesAdapter.add(pkg.package_uuid().toString());
                            packages.add(pkg);
                        }
                    });
                    handler.postDelayed(mainTask, 3000);
                }

                @Override
                public void onFailure(Call<List<PackageResponse>> call, Throwable throwable) {
                    System.out.println(throwable);
                    handler.postDelayed(mainTask, 3000);
                }
            });
        };

        mainHandler.post(mainTask);

        task = () -> {
            requestNewLocationData();
            handler.postDelayed(task, 5000);
        };

        binding.btn.setOnClickListener(v -> {
            final String selectedPackageUuid = binding.items.getSelectedItem().toString();

            final PackageResponse toUpdate = packages
                    .stream()
                    .filter(p -> p.package_uuid().toString().equals(selectedPackageUuid))
                    .findFirst().orElse(null);

            sdekPackageApi.packageStatus(2).enqueue(new Callback<>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    final PackageStatus status = gson.fromJson(response.body().charStream(), PackageStatus.class);

                    final PackageResponse body = new PackageResponse(
                            toUpdate.package_uuid(),
                            toUpdate.package_send_date(),
                            toUpdate.package_receive_date(),
                            toUpdate.package_weight(),
                            UserContext.currentDeliveryPerson,
                            toUpdate.package_type(),
                            status,
                            toUpdate.package_sender(),
                            toUpdate.package_receiver(),
                            toUpdate.package_warehouse(),
                            toUpdate.package_paytype(),
                            toUpdate.package_payer(),
                            toUpdate.package_items()
                    );

                    sdekPackageApi.updatePackage(body).enqueue(new Callback<>() {
                        @Override
                        public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                            if (response.isSuccessful()) {
                                getLastLocation();
                                handler.post(task);

                                binding.btn.setVisibility(View.INVISIBLE);
                                binding.btnOk.setVisibility(View.VISIBLE);
                            }
                        }

                        @Override
                        public void onFailure(Call<ResponseBody> call, Throwable throwable) {
                            System.out.println(throwable);
                        }
                    });
                }

                @Override
                public void onFailure(Call<ResponseBody> call, Throwable throwable) {
                    System.out.println(throwable);
                }
            });
        });

        binding.btnOk.setOnClickListener(v -> {
            handler.removeCallbacks(task);
            handler.post(() -> {});
            handler.postDelayed(() -> {}, 50000);

            final String selectedPackageUuid = binding.items.getSelectedItem().toString();

            final PackageResponse toUpdate = packages
                    .stream()
                    .filter(p -> p.package_uuid().toString().equals(selectedPackageUuid))
                    .findFirst().orElse(null);

            sdekPackageApi.packageStatus(3).enqueue(new Callback<>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    final PackageStatus status = gson.fromJson(response.body().charStream(), PackageStatus.class);

                    final PackageResponse packageResponse = new PackageResponse(
                            toUpdate.package_uuid(),
                            toUpdate.package_send_date(),
                            toUpdate.package_receive_date(),
                            toUpdate.package_weight(),
                            toUpdate.package_deliveryperson(),
                            toUpdate.package_type(),
                            status,
                            toUpdate.package_sender(),
                            toUpdate.package_receiver(),
                            toUpdate.package_warehouse(),
                            toUpdate.package_paytype(),
                            toUpdate.package_payer(),
                            toUpdate.package_items()
                    );

                    sdekPackageApi.updatePackage(packageResponse).enqueue(new Callback<>() {
                        @Override
                        public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                            if (response.isSuccessful()) {
                                binding.btnOk.setVisibility(View.INVISIBLE);
                                binding.btn.setVisibility(View.VISIBLE);
                            }
                        }

                        @Override
                        public void onFailure(Call<ResponseBody> call, Throwable throwable) {
                            System.out.println(throwable);
                        }
                    });
                }

                @Override
                public void onFailure(Call<ResponseBody> call, Throwable throwable) {
                    System.out.println(throwable);
                }
            });
        });
    }

    @SuppressLint("MissingPermission")
    private void getLastLocation() {
        if (checkPermissions()) {
            if (isLocationEnabled()) {
                requestNewLocationData();
            } else {
                Toast.makeText(requireContext(), "Please turn on your location...", Toast.LENGTH_LONG).show();
                Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                startActivity(intent);
            }
        } else {
            requestPermissions();
        }
    }

    @SuppressLint("MissingPermission")
    private void requestNewLocationData() {
        final LocationRequest mLocationRequest = new LocationRequest();
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        mLocationRequest.setInterval(5);
        mLocationRequest.setFastestInterval(0);
        mLocationRequest.setNumUpdates(1);

        mFusedLocationClient.requestLocationUpdates(mLocationRequest, mLocationCallback, Looper.myLooper());
    }

    private final LocationCallback mLocationCallback = new LocationCallback() {
        @Override
        public void onLocationResult(LocationResult locationResult) {
            Location mLastLocation = locationResult.getLastLocation();
            webSocket.send(gson.toJson(new TransportState(String.valueOf(UserContext.currentDeliveryPerson.person_transport().transport_id()), mLastLocation.getLatitude(), mLastLocation.getLongitude())));
        }
    };

    // method to check for permissions
    private boolean checkPermissions() {
        return ActivityCompat.checkSelfPermission(requireContext(), android.Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(requireContext(), android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }

    private void requestPermissions() {
        ActivityCompat.requestPermissions(requireActivity(), new String[]{
                android.Manifest.permission.ACCESS_COARSE_LOCATION,
                android.Manifest.permission.ACCESS_FINE_LOCATION}, PERMISSION_ID);
    }

    private boolean isLocationEnabled() {
        LocationManager locationManager = getSystemService(requireContext(), LocationManager.class);
        assert locationManager != null;
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) || locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        if (requestCode == PERMISSION_ID && grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            getLastLocation();
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
        webSocket.cancel();
    }
}