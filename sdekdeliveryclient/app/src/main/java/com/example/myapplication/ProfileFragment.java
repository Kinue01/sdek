package com.example.myapplication;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import com.example.myapplication.databinding.FragmentProfileBinding;
import org.jetbrains.annotations.NotNull;

import static androidx.navigation.fragment.FragmentKt.findNavController;

public class ProfileFragment extends Fragment {
    private FragmentProfileBinding binding;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        binding = FragmentProfileBinding.inflate(getLayoutInflater());
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull @NotNull View view, @Nullable @org.jetbrains.annotations.Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        binding.userLogin.setText(UserContext.currentUser.user_login());
        binding.userEmail.setText(UserContext.currentUser.user_email());
        binding.userPhone.setText(UserContext.currentUser.user_phone());
        binding.userFio.setText(UserContext.currentDeliveryPerson.person_lastname() + " " + UserContext.currentDeliveryPerson.person_firstname() + " " + UserContext.currentDeliveryPerson.person_middlename());
        binding.userTransport.setText(UserContext.currentDeliveryPerson.person_transport().transport_name());

        binding.buttonSubmit.setOnClickListener(view1 -> {
            UserContext.currentUser = null;
            findNavController(ProfileFragment.this).navigate(ProfileFragmentDirections.actionProfileFragmentToLoginFragment());
        });
    }
}