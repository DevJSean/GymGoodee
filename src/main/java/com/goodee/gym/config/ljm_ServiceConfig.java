package com.goodee.gym.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.goodee.gym.service.AdminService;
import com.goodee.gym.service.AdminServiceImpl;
import com.goodee.gym.service.ReserveService;
import com.goodee.gym.service.ReserveServiceImpl;

@Configuration
public class ljm_ServiceConfig {

	
	// admin
	@Bean
	public AdminService adminService() {
		return new AdminServiceImpl();
	}
	
	// reserve
	@Bean
	public ReserveService reserveService() {
		return new ReserveServiceImpl();
	}
	
}
