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
		// {"res": null}
		// {"res": {"memberNo":1, ...}}
	}
	
	@ResponseBody
	@GetMapping(value="/member/emailCheck", produces="application/json")
	public Map<String, Object> emailCheck(@RequestParam String memberEmail) {
		return memberService.emailCheck(memberEmail);
		// {"res": null}
		// {"res": {"memberNo":1, ...}}
	}
	
	@ResponseBody
	@GetMapping(value="/member/sendAuthCode", produces="application/json")
	public Map<String, Object> sendAuthCode(@RequestParam String memberEmail) {
		return memberService.sendAuthCode(memberEmail);
	}
	
	@PostMapping("/member/signUp")
	public void signUp(HttpServletRequest request, HttpServletResponse response) {
		memberService.signUp(request, response);
	}
	
	@GetMapping("/member/loginPage")
	public String loginPage(@RequestParam(required=false) String url, Model model) {
		model.addAttribute("url", url);    // member/login.jsp로 url 속성값을 전달한다.
		return "member/login";
	}
	
	@PostMapping("/member/login")
	public void login(HttpServletRequest request, Model model) {
		
		// 아이디, 비밀번호가 일치하는 회원 정보 가져오기
		MemberDTO loginMember = memberService.login(request);
		
		// 아이디, 비밀번호가 일치하는 회원이 있으면(로그인 성공) LoginIntercepter의 postHandle() 메소드에 회원 정보 전달
		if(loginMember != null) {
			model.addAttribute("loginMember", loginMember);  // Model에 저장된 속성은 LoginInterceptor의 postHandle() 메소드의 ModelAndView 매개변수가 받는다.
		}
		
		// LoginIntercepter의 postHandle() 메소드에 로그인 이후에 이동할 경로 전달
		model.addAttribute("url", request.getParameter("url"));
		
	}
	
	@GetMapping("/member/logout")
	public String logout(HttpSession session, HttpServletResponse response) {
		// session의 모든 정보(로그인 정보 포함) 제거
		MemberDTO loginMember = (MemberDTO)session.getAttribute("loginMember");
		if(loginMember != null) {
			session.invalidate();
		}
		return "redirect:/lsh";
	}
	
	/* 아이디 찾기 */
	@GetMapping("/member/findIdPage")
	public String findIdPage() {
		return "member/findId";
	}
	
	@ResponseBody
	@RequestMapping(value="/member/findId", produces="application/json")
	public Map<String, Object> findId(@RequestBody MemberDTO member) {
		return memberService.findId(member);
	}
	
	/* 비밀번호 찾기 */
	@GetMapping("/member/findPwPage")
	public String findPwPage() {
		return "member/findPw";
	}
	@ResponseBody
	@GetMapping("/member/idEmailCheck")
	public Map<String, Object> idEmailCheck(MemberDTO member){
		return memberService.idEmailCheck(member);
	}
	@PostMapping("/member/changePw")
	public void changePw(HttpServletRequest request, HttpServletResponse response) {
		memberService.changePw(request, response);
	}
	
	
}
