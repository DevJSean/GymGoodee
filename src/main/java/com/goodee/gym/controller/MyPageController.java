package com.goodee.gym.controller;

import javax.servlet.http.HttpServletRequest;

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
	public String myReserveList(HttpServletRequest request, Model model) {
		myPageService.getCommingReservationsByNo(request, model);
		myPageService.getOverReservationsByNo(request, model);
		return "mypage/myReserveList";
	}
	
	@GetMapping("/mypage/myPayList")
	public String myPayList(@RequestParam Long memberNo, Model model) {
		myPageService.getMyPayListByNo(memberNo, model);
		return "mypage/myPayList";
	}
	
	@GetMapping("/mypage/myInfo")
	public String myInfo(@RequestParam Long memberNo, Model model) {
		myPageService.getMyInfoByNo(memberNo, model);
		return "mypage/myInfo";
	}

	@GetMapping("/mypage/changePw")
	public String myPwCheck(@RequestParam Long memberNo, Model model) {
		myPageService.getMemberPw(memberNo, model);
		return "mypage/changePw";
	}
	
}
