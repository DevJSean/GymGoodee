package com.goodee.gym.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.goodee.gym.service.MyPageService;
import com.goodee.gym.service.MyPageServiceImpl;

@Configuration
public class MyPageServiceConfig {

	@Bean
	public MyPageService myPageService() {
		return new MyPageServiceImpl();
	}
	
}
