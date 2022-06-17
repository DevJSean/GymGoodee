package com.goodee.gym.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.goodee.gym.service.MemberService;
import com.goodee.gym.service.MemberServiceImpl;


@Configuration
public class ServiceConfig {

	@Bean
	public MemberService memberService() {
		return new MemberServiceImpl();
	}
	
}
