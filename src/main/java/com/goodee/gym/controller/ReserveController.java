package com.goodee.gym.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.gym.service.ReserveService;

@Controller
public class ReserveController {

	@Autowired
	private ReserveService reserveService;
	
	// 단순 페이지 이동
	@GetMapping(value="/reserve/swimPage")
	public String swimpage() {
		return "reserve/swimPage";
	}
	
	@GetMapping(value="/reserve/test")
	public String test(Model model, HttpServletRequest request) {
		// 임시 테스트
		model.addAttribute("subject", request.getParameter("subject"));
		model.addAttribute("classDate", request.getParameter("classDate"));
		return "reserve/swimClasses";
	}
	
	// 해당 날짜 개설 강좌 조회하기 => 해당 날짜 클릭하면 개설 강좌 정보가 자식창으로 떠야한다.
	@GetMapping(value="/reserve/getClasses")
	public String getClasses(Model model, HttpServletRequest request) {
		
		// 수강 정보를 추가
		reserveService.getClasses(request, model);
		
		
		return "reserve/swimClasses";
	}
	
	@ResponseBody
	@GetMapping(value="/reserve/getClasses1", produces = "application/json")
	public Map<String, Object> getClasses1(Model model, HttpServletRequest request) {
		
		return reserveService.getClasses1(request, model);
	}
	
	
	// 강좌 별 현재 예약 인원 
	
	
	
	// 수영 예약하기
	@ResponseBody
	@PostMapping(value="/reserve/reserveSwim", produces="application/json")
	public Map<String, Object> reserveSwim(HttpServletRequest request) {
		return reserveService.reserveSwim(request);
	}
	
}
