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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.service.MemberService;


@Controller
public class MemberController {

	@Autowired
	private MemberService memberService;
	
	@GetMapping("/member/agreePage")
	public String agreePage() {
		return "member/agree";
	}
	
	@GetMapping("/member/signUpPage")
	public String signUpPage(@RequestParam(required=false) String[] agreements, Model model) {
		model.addAttribute("agreements", agreements);
		return "member/signUp";
	}
	
	@ResponseBody
	@GetMapping(value="/member/idCheck", produces="application/json")
	public Map<String, Object> idCheck(@RequestParam String memberId) {
		return memberService.idCheck(memberId);
	}
	
	@ResponseBody
	@GetMapping(value="/member/emailCheck", produces="application/json")
	public Map<String, Object> emailCheck(@RequestParam String memberEmail) {
		return memberService.emailCheck(memberEmail);
	}
	
	@ResponseBody
	@GetMapping(value="/member/sendAuthCodeEmail", produces="application/json")
	public Map<String, Object> sendAuthCodeEmail(@RequestParam String memberEmail) {
		return memberService.sendAuthCodeEmail(memberEmail);
	}
	
	@ResponseBody
	@GetMapping(value="/member/sendAuthCodeSMS", produces="application/json")
	public Map<String, Object> sendAuthCodeSMS(@RequestParam String memberPhone) {
		return memberService.sendAuthCodeSMS(memberPhone);
	}
	
	@PostMapping("/member/signUp")
	public void signUp(HttpServletRequest request, HttpServletResponse response) {
		memberService.signUp(request, response);
	}
	
	@GetMapping("/member/loginPage")
	public String loginPage(@RequestParam(required=false) String url, Model model, HttpSession session) {
		memberService.admin();
		model.addAttribute("url", url);    // member/login.jsp로 url 속성값을 전달한다.
		model.addAttribute("naver", memberService.naverLogin(session));
		model.addAttribute("kakao", memberService.kakaoLogin(session));
		return "member/login";
	}
	
	@PostMapping("/member/login")
	public void login(HttpServletRequest request, Model model) {
		
		MemberDTO loginMember = memberService.login(request);
		if(loginMember != null) {
			model.addAttribute("loginMember", loginMember);  
		}
		model.addAttribute("url", request.getParameter("url"));
		
	}
	
	@GetMapping("/member/naverCallback")
	public String naverCallback(HttpServletRequest request, HttpServletResponse response) {
		memberService.naverCallback(request, response);
		return "index";
	}
	
	@GetMapping("/member/kakaoCallback")
	public String kakaoCallback(Model model, HttpServletRequest request, HttpServletResponse response) {
		memberService.kakaoCallback(request, response);
		return "index";
	}
	
	@GetMapping("/member/logout")
	public void logout(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		memberService.logout(session, request, response);
	}
	
	@GetMapping("/member/findIdPage")
	public String findIdPage() {
		return "member/findId";
	}
	
	@ResponseBody
	@RequestMapping(value="/member/findId", produces="application/json")
	public Map<String, Object> findId(@RequestBody MemberDTO member) {
		return memberService.findId(member);
	}
	
	@GetMapping("/member/findPwPage")
	public String findPwPage() {
		return "member/findPw";
	}
	
	@ResponseBody
	@GetMapping("/member/idPhoneCheck")
	public Map<String, Object> idPhoneCheck(MemberDTO member){
		return memberService.idPhoneCheck(member);
	}
	
	@PostMapping("/member/changePw")
	public void changePw(HttpServletRequest request, HttpServletResponse response) {
		memberService.changePw(request, response);
	}
	
	@GetMapping("/policy/service")
	public String service() {
		return "policy/service";
	}
	@GetMapping("/policy/privacy")
	public String privacy() {
		return "policy/privacy";
	}
	@GetMapping("/policy/location")
	public String location() {
		return "policy/location";
	}
}