package com.goodee.gym.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.gym.service.ForecastService;

@Controller
public class IndexController {

	// 단순 페이지 이동하는 매핑은 IndexController에 모아두는 것이 좋을 것 같다.
	
	@GetMapping(value={"/", "/index"}) 
	public String index() {
		return "index";              
	}
	
	@GetMapping(value={"/lsh"}) 
	public String lsh() {
		return "lsh_index";              
	}
	@GetMapping(value={"/ljm"}) 
	public String ljm() {
		return "ljm_index";              
	}
	@GetMapping(value={"/ogy"}) 
	public String ogy() {
		return "ogy_index";              
	}
	@GetMapping(value={"/phg"}) 
	public String phg() {
		return "phg_index";              
	}
	
	@GetMapping(value="/member/login")    
	public String member() {
		return "member/login";         
	}
	
	@ResponseBody
	@GetMapping(value = "/forecast", produces="application/json")
	public String forecast(HttpServletRequest request) {
		return ForecastService.forecast(request);
	}
	

}
