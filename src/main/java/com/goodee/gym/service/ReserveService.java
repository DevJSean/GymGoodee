package com.goodee.gym.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

@Service
public interface ReserveService {

	public void getClasses(HttpServletRequest request, Model model);
	public Map<String, Object> getClasses1(HttpServletRequest request, Model model);
	public int getCountByClassCode(String classCode);
	
	public Map<String, Object> reserveSwim(HttpServletRequest request);
}
