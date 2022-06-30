package com.goodee.gym.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface MyPageService {
	
	public Map<String, Object> getRemainTicketsById(HttpServletRequest request, Model model);
	public Map<String, Object> getCommingReservationsByNo(HttpServletRequest request);
	public Map<String, Object> getOverReservationsByNo(HttpServletRequest request, int page);
	public Map<String, Object> reserveCancle(String reservationCode, String memberId, String remainTicketSubject);
	public void getMyPayListByNo(HttpServletRequest request, Model model);
	public void changeTicketInfo(HttpServletRequest request);
	public void changePw(HttpServletRequest request, HttpServletResponse response);
	public void changeMyInfo(HttpServletRequest request, HttpServletResponse response);
	public void signOut(HttpServletRequest request, HttpServletResponse response);
	public Map<String, Object> getPwModified(HttpServletRequest request);
}
