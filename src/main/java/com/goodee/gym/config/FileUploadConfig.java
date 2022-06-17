package com.goodee.gym.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

@Configuration
public class FileUploadConfig {

	@Bean
	public CommonsMultipartResolver multipartResolver() { 
		CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
		multipartResolver.setDefaultEncoding("UTF-8");
		multipartResolver.setMaxUploadSizePerFile(1024 * 1024 * 10); // 한 파일당 최대 10MB 
		multipartResolver.setMaxUploadSize(1024 * 1024 * 50); // 전체 최대 50MB 
		return multipartResolver;
	}
}
