package com.goodee.gym.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.ui.Model;

import com.goodee.gym.domain.ClassDTO;
import com.goodee.gym.domain.TeacherDTO;

public interface AdminService {

	// 강사 추가하기
	public Map<String, Object> addTeacher(TeacherDTO teacher);
	
	// 강사 목록 가져오기
	public Map<String, Object> getMembers();
	
	
	
	// 종목 선택 후 해당 종목 강사 목록 가져오기
	public Map<String, Object> getMembersBySubject(String subject);
	
	// 종목 선택 후 해당 종목 장소 목록 가져오기
	public Map<String, Object> getLocationsBySubject(String subject);

	// 개설 강좌 추가하기
	public Map<String, Object> addClass(ClassDTO registclass, HttpServletResponse response);
	
	// 개설 강좌 목록 가져오기 + 페이징 처리
	public Map<String, Object> getClasses(int page);
	
	/* 관리자 */
	public void memberList(HttpServletRequest request, Model model);
	public void classList(HttpServletRequest request, Model model);
	public void payList(HttpServletRequest request, Model model);
	public void reserveList(HttpServletRequest request, Model model);
	public Map<String, Object> reserveCancle(String reservationCode, String memberId, String remainTicketSubject);

	
	
	

}
