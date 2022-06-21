package com.goodee.gym.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer{

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {

		// /getImage/abc.jpg 요청하면
		// C:\\upload\\summernote\\abc.jpg로 인식해라
		registry.addResourceHandler("/getImage/**")
			.addResourceLocations("file:///C:/upload/summernote/");
		
	}
	
}
