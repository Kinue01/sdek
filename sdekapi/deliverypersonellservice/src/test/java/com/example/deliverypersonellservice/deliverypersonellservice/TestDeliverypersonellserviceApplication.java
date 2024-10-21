package com.example.deliverypersonellservice.deliverypersonellservice;

import org.springframework.boot.SpringApplication;

public class TestDeliverypersonellserviceApplication {

	public static void main(String[] args) {
		SpringApplication.from(DeliverypersonellserviceApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
