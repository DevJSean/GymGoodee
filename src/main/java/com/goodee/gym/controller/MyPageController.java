package com.goodee.gym.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.gym.service.MyPageService;

@Controller
public class MyPageController {
	
	@Autowired
	private MyPageService myPageService;

	@GetMapping("/mypage/myReserveList")
	public String myReserveList(@RequestParam(value="memberNo", required=false, defaultValue="0L")Long memberNo, Model model) {
		myPageService.getCommingReservationsByNo(memberNo, model);
		myPageService.getOverReservationsByNo(memberNo, model);
		return "mypage/myReserveList";
	}
	
	@GetMapping("/mypage/myPayList")
	public String myPayList() {
		return "mypage/myPayList";
	}
	
	@GetMapping("/mypage/myPwCheck")
	public String myPwCheck() {
		return "mypage/myPwCheck";
	}
	
}
