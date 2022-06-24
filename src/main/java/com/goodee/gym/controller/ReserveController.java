package com.goodee.gym.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
	
	/* 단순 페이지 이동 */
	@GetMapping(value="/reserve/swimPage")
	public String swimpage() {
		return "reserve/swimPage";
	}
	
	// swimPage.jsp에서 넘겨준 선택한 날짜, 종목 정보를
	// model 에 실어서 reserve/reserveSwim 로 넘겨주기
	@GetMapping(value="/reserve/reserveSwim")
	public String reserveSwim(HttpServletRequest request, Model model) {
		model.addAttribute("subject", request.getParameter("subject"));
		model.addAttribute("classDate", request.getParameter("classDate"));
		return "reserve/reserveSwim";
	}
	
	/* 서비스 수행 후 페이지 이동 */
	// swimPage -> reserveSwim으로 이동 후
	// 받아온 날짜, 종목을 가지고
	// 개설 강좌목록 받아오기
	@ResponseBody
	@GetMapping(value="/reserve/getSwimClasses", produces = "application/json")
	public Map<String, Object> getSwimClasses(HttpServletRequest request) {
		return reserveService.getSwimClasses(request);
	}
	
	// 수영 예약하기
	// subject, memberNo, classCode 값이 파라미터로 넘어온다.
	// 예약 결과를 { "res" : 0 or 1 } 로 넘겨준다.
	@ResponseBody
	@PostMapping(value="/reserve/reserveSwim", produces="application/json")
	public Map<String, Object> reserveSwim(HttpServletRequest request) {
		return reserveService.reserveSwim(request);
	}
	
	// 수영 예약 취소하기
	@ResponseBody
	@PostMapping(value="/reserve/cancelSwim", produces="application/json")
	public Map<String, Object> cancelSwim(HttpServletRequest request){
		return reserveService.cancelSwim(request);
	}
	
}
