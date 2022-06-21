package com.goodee.gym.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.goodee.gym.domain.MemberDTO;

public interface MemberService {

	public Map<String, Object> idCheck(String memberId);
	public Map<String, Object> emailCheck(String memberEmail);
	public Map<String, Object> sendAuthCode(String memberEmail);
	public void signUp(HttpServletRequest request, HttpServletResponse response);
	public MemberDTO login(HttpServletRequest request);
	/* 아이디 찾기 */
	public Map<String, Object> findId(MemberDTO member);
	/* 비밀번호 찾기 */
	public Map<String, Object> idEmailCheck(MemberDTO member);
	public void changePw(HttpServletRequest request, HttpServletResponse response);
}
