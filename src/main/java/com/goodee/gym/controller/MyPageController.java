package com.goodee.gym.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.service.MyPageService;

@Controller
public class MyPageController {
	
	@Autowired
	private MyPageService myPageService;

	@GetMapping("/mypage/myReserveList")
	public String myReserveList(HttpServletRequest request, Model model) {
		myPageService.getOverReservationsByNo(request, model);
		return "mypage/myReserveList";
	}
	
	@ResponseBody
	@GetMapping(value="/remainTickets", produces="application/json")
	public Map<String, Object> remainTickets(HttpServletRequest request, Model model) {
		return myPageService.getRemainTicketsById(request, model);
		
	}
	
	@ResponseBody
	@GetMapping(value="/mypage/myCommingReserveList", produces="application/json")
	public Map<String, Object> myCommingReserveList(HttpServletRequest request) {
		return myPageService.getCommingReservationsByNo(request);
	}
	
	@ResponseBody
	@GetMapping(value="/reserveCancle", produces="application/json")
	public Map<String, Object> remove(@RequestParam String reservationCode, @RequestParam String memberId, @RequestParam String remainTicketSubject) {
		return myPageService.reserveCancle(reservationCode, memberId, remainTicketSubject);
	}
	
	@GetMapping("/mypage/myPayList")
	public String myPayList(HttpServletRequest request, Model model) {
		myPageService.getMyPayListByNo(request, model);
		return "mypage/myPayList";
	}
	
	@GetMapping("/mypage/myInfo")
	public String myInfo() {
		return "mypage/myInfo";
	}

	@GetMapping("/mypage/changePwPage")
	public String changePwPage(HttpServletRequest request) {
		return "mypage/changePw";
	}
	
	// 비밀번호 변경 후 메인으로 보내기
	@PostMapping("/mypage/changePw")
	public void changePW(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		myPageService.changePw(request, response);
		// session의 모든 정보(로그인 정보 포함) 제거
		MemberDTO loginMember = (MemberDTO)session.getAttribute("loginMember");
		if(loginMember != null) {
			session.invalidate();
		}
	}
	
	@PostMapping("/mypage/changeInfo")
	public void changeInfo(HttpSession session, HttpServletRequest request, HttpServletResponse response, Model model) {
		myPageService.changeMyInfo(request, response);
	}
	
	@GetMapping("/mypage/signOutPage")
	public String signOutPage() {
		return "mypage/signOut";
	}
	
	
	@PostMapping("/mypage/signOut")
	public void signOut(HttpServletRequest request, HttpServletResponse response) {
		myPageService.signOut(request, response);
	}
	
	@ResponseBody
	@GetMapping(value="/mypage/pwModifiedCheck", produces="application/json")
	public Map<String, Object> pwModifiedCheck(HttpServletRequest request) {
		return myPageService.getPwModified(request);
	}
	
}
