package com.goodee.gym.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.goodee.gym.service.AdminService;
import com.goodee.gym.service.AdminServiceImpl;

@Configuration
public class ljm_ServiceConfig {

	@Bean
	public AdminService adminService() {
		return new AdminServiceImpl();
	}
}
