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

import com.goodee.gym.service.MyPageService;

@Controller
public class MyPageController {
	
	@Autowired
	private MyPageService myPageService;

	@GetMapping("/mypage/myReserveList")
	public String myReserveList() {
		return "mypage/myReserveList";
	}
	
	@ResponseBody
	@GetMapping(value="/remainTickets", produces="application/json")
	public Map<String, Object> remainTickets(HttpServletRequest request) {
		return myPageService.getRemainTicketsById(request);
	}
	
	@ResponseBody
	@GetMapping(value="/mypage/myCommingReserveList", produces="application/json")
	public Map<String, Object> myCommingReserveList(HttpServletRequest request) {
		return myPageService.getCommingReservationsByNo(request);
	}
	
	@ResponseBody
	@GetMapping(value="/mypage/myOverReserveList", produces="application/json")
	public Map<String, Object> getMembers(HttpServletRequest request, @RequestParam int page){
		return myPageService.getOverReservationsByNo(request, page);
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
	
	@GetMapping("/mypage/pwCheckPage")
	public String pwCheckPage() {
		return "mypage/pwCheck";
	}
	
	@ResponseBody
	@PostMapping(value="/mypage/pwCheck", produces="application/json")
	public Map<String, Object> pwCheck(HttpServletRequest request, HttpServletResponse response) {
		return myPageService.pwCheck(request, response); 
	}
	
	@GetMapping("/mypage/myInfo")
	public String myInfo() {
		return "mypage/myInfo";
	}

	@GetMapping("/mypage/changePwPage")
	public String changePwPage(HttpServletRequest request) {
		return "mypage/changePw";
	}
	
	// ???????????? ?????? ??? ???????????? ?????????
	@PostMapping("/mypage/changePw")
	public void changePW(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		myPageService.changePw(request, response);
	}
	
	@PostMapping("/mypage/changeInfo")
	public void changeInfo(HttpSession session, HttpServletRequest request, HttpServletResponse response, Model model) {
		myPageService.changeMyInfo(request, response);
	}
	
	@GetMapping("/mypage/signOutPage")
	public String signOutPage(HttpServletRequest request, Model model) {
		myPageService.getMyTicketsById(request, model);
		return "mypage/signOut";
	}
	
	
	@GetMapping("/mypage/signOut")
	public void signOut(HttpServletRequest request, HttpServletResponse response) {
		myPageService.signOut(request, response);
	}
	
	@ResponseBody
	@GetMapping(value="/mypage/pwModifiedCheck", produces="application/json")
	public Map<String, Object> pwModifiedCheck(HttpServletRequest request) {
		return myPageService.getPwModified(request);
	}

	
}
