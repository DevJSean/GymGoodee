package com.goodee.gym.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.goodee.gym.domain.MemberDTO;

public interface MemberService {

	public Map<String, Object> idCheck(String memberId);
	public Map<String, Object> emailCheck(String memberEmail);
	public Map<String, Object> sendAuthCodeEmail(String memberEmail);
	public Map<String, Object> sendAuthCodeSMS(String memberPhone);

	public void signUp(HttpServletRequest request, HttpServletResponse response);
	public MemberDTO login(HttpServletRequest request);
	
	/* 네이버 */
	public String naverLogin(HttpSession session);
	public void naverCallback(HttpServletRequest request, HttpServletResponse response);
	
	/* 카카오 */
	public String kakaoLogin(HttpSession session);
	public void kakaoCallback(HttpServletRequest request, HttpServletResponse response);
	
	/* 아이디 찾기 */
	public Map<String, Object> findId(MemberDTO member);
	
	/* 비밀번호 찾기 */
	public Map<String, Object> idPhoneCheck(MemberDTO member);
	public void changePw(HttpServletRequest request, HttpServletResponse response);
}
