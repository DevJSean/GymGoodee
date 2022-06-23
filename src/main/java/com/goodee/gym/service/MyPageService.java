package com.goodee.gym.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

public interface MyPageService {
	
	public void getCommingReservationsByNo(HttpServletRequest request, Model model);
	public void getOverReservationsByNo(HttpServletRequest request, Model model);
	public void getMyPayListByNo(Long memberNo, Model model);
	public void getMemberPw(Long memberNo, Model model);
	public void getMyInfoByNo(Long memberNo, Model model);
	
}
