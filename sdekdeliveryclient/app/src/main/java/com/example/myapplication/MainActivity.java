package com.example.myapplication;

import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;
import androidx.navigation.NavController;
import androidx.navigation.fragment.NavHostFragment;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;
import com.example.myapplication.databinding.ActivityMainBinding;

public class MainActivity extends AppCompatActivity {
    private ActivityMainBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        NavHostFragment qweq = (NavHostFragment) getSupportFragmentManager().findFragmentById(R.id.navHostFragment);
        assert qweq != null;

        NavController navController = qweq.getNavController();

        navController.addOnDestinationChangedListener((navController1, navDestination, bundle) -> {
            if (navDestination.getId() == R.id.loginFragment) {
                binding.toolbar.setVisibility(View.GONE);
                binding.bottomNavView.setVisibility(View.GONE);
            } else {
                binding.toolbar.setVisibility(View.VISIBLE);
                binding.bottomNavView.setVisibility(View.VISIBLE);
            }
        });

        AppBarConfiguration appBarConfiguration = new AppBarConfiguration.Builder(navController.getGraph()).build();

        NavigationUI.setupWithNavController(binding.bottomNavView, navController);
        NavigationUI.setupWithNavController(binding.toolbar, navController, appBarConfiguration);

        setSupportActionBar(binding.toolbar);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        binding = null;
    }
}