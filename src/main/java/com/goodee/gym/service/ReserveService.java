package com.goodee.gym.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

@Service
public interface ReserveService {

	// 1. 받아온 종목, 날짜와 일치하는 강좌 반환하기
	public Map<String, Object> getClasses(HttpServletRequest request);
	
	// 2. 예약하기(update or insert)
	public Map<String, Object> reserve(HttpServletRequest request);
	
	// 3. 수영 예약 취소하기(update)
	public Map<String, Object> cancel(HttpServletRequest request);
	
}
