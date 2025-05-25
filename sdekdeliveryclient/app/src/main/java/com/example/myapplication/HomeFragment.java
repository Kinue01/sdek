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
import io.kurrent.dbclient.*;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.ResponseBody;
import okhttp3.WebSocket;
import org.jetbrains.annotations.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Objects;

import static androidx.core.content.ContextCompat.getSystemService;

public class HomeFragment extends Fragment {
    private static final Logger log = LoggerFactory.getLogger(HomeFragment.class);
    private FragmentHomeBinding binding;
    private FusedLocationProviderClient mFusedLocationClient;
    private final Gson gson = new Gson();
    private static final int PERMISSION_ID = 44;
    private final Handler handler = new Handler(Looper.myLooper());
    private Runnable task, mainTask;
    private SdekPackageApi sdekPackageApi;
    private final List<PackageResponse> packages = new ArrayList<>();
    private final Handler mainHandler = new Handler(Looper.myLooper());
    private ArrayAdapter<String> packagesAdapter;
    private PackageResponse currentPackage;
    private KurrentDBClient client;

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

        KurrentDBClientSettings settings = KurrentDBConnectionString.parseOrThrow(BuildConfig.ESDB_PROD_URL);
        client = KurrentDBClient.create(settings);
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
                    assert response.body() != null;
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
                    log.error(String.valueOf(throwable));
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
            if (binding.items.getSelectedItem() == null) Toast.makeText(requireContext(), "Please select a package", Toast.LENGTH_SHORT).show();

            final String selectedPackageUuid = binding.items.getSelectedItem().toString();

            final PackageResponse toUpdate = packages
                    .stream()
                    .filter(p -> p.package_uuid().toString().equals(selectedPackageUuid))
                    .findFirst().orElse(null);

            assert toUpdate != null;

            currentPackage = toUpdate;

            sdekPackageApi.packageStatus(2).enqueue(new Callback<>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    final PackageStatus status;
                    try (ResponseBody body = response.body()) {
                        assert body != null;
                        status = gson.fromJson(body.charStream(), PackageStatus.class);
                    }
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
                            log.error(String.valueOf(throwable));
                        }
                    });
                }

                @Override
                public void onFailure(Call<ResponseBody> call, Throwable throwable) {
                    log.error(String.valueOf(throwable));
                }
            });
        });

        binding.btnOk.setOnClickListener(v -> {
            handler.removeCallbacks(task);
            handler.post(() -> {});
            handler.postDelayed(() -> {}, 50000);

            sdekPackageApi.packageStatus(3).enqueue(new Callback<>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    final PackageStatus status;
                    try (ResponseBody responseBody = response.body()) {
                        assert responseBody != null;
                        status = gson.fromJson(responseBody.charStream(), PackageStatus.class);
                    }

                    DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());

                    final PackageResponse packageResponse;
                    try {
                        packageResponse = new PackageResponse(
                                currentPackage.package_uuid(),
                                currentPackage.package_send_date(),
                                Objects.requireNonNull(formatter.parse(LocalDate.now().toString())).toString(),
                                currentPackage.package_weight(),
                                currentPackage.package_deliveryperson(),
                                currentPackage.package_type(),
                                status,
                                currentPackage.package_sender(),
                                currentPackage.package_receiver(),
                                currentPackage.package_warehouse(),
                                currentPackage.package_paytype(),
                                currentPackage.package_payer(),
                                currentPackage.package_items()
                        );
                    } catch (ParseException e) {
                        throw new RuntimeException(e);
                    }

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
                            log.error(String.valueOf(throwable));
                        }
                    });
                }

                @Override
                public void onFailure(Call<ResponseBody> call, Throwable throwable) {
                    log.error(String.valueOf(throwable));
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
            EventData eventData = EventData.builderAsJson(
                    "transport_geo_changed",
                    gson.toJson(new TransportState(String.valueOf(UserContext.currentDeliveryPerson.person_transport().transport_id()), mLastLocation.getLatitude(), mLastLocation.getLongitude())).getBytes()
            ).build();
            AppendToStreamOptions options = AppendToStreamOptions.get().streamState(StreamState.any());
            client.appendToStream("transport_geo", options, eventData);
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
    }
}