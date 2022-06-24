package com.goodee.gym.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.goodee.gym.service.TicketService;
import com.goodee.gym.service.TicketServiceImpl;

@Configuration
public class PhgServiceConfig {

	@Bean
	public TicketService ticketService() {
		return new TicketServiceImpl();
	}
	
}
