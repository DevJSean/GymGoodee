package com.goodee.gym.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.gym.service.ForecastService;

@Controller
public class IndexController {

	@GetMapping(value={"/", "/index"}) 
	public String index() {
		return "index";              
	}
		
	@ResponseBody
	@GetMapping(value = "/forecast", produces="application/json")
	public String forecast(HttpServletRequest request) {
		return ForecastService.forecast(request);
	}
	
	@GetMapping("/about/center")
	public String center() {
		return "about/center";
	}
	@GetMapping("/about/subject")
	public String subject() {
		return "about/subject";
	}
	

}
