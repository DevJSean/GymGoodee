package com.goodee.gym.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface MyPageService {
	
	public Map<String, Object> getCommingReservationsByNo(Long memberNo);
	public Map<String, Object> getRemainTicketsById(String memberId);
	public Map<String, Object> reserveCancle(String reservationCode, String memberId, String remainTicketSubject);
	public void getOverReservationsByNo(HttpServletRequest request, Model model);
	public void getMyPayListByNo(Long memberNo, Model model);
	public void changePw(HttpServletRequest request, HttpServletResponse response);
	public void changeMyInfo(HttpServletRequest request, HttpServletResponse response);
	public void signOut(HttpServletRequest request, HttpServletResponse response);
}
