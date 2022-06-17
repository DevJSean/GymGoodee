package com.goodee.gym.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class IndexController {

	// 단순 페이지 이동하는 매핑은 IndexController에 모아두는 것이 좋을 것 같다.
	
	@GetMapping(value={"/", "/index"}) 
	public String index() {
		return "index";              
	}
	
	@GetMapping(value="/member/login")    
	public String member() {
		return "member/login";         
	}
	

}
