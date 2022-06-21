package com.goodee.gym.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.gym.domain.ClassDTO;
import com.goodee.gym.domain.TeacherDTO;
import com.goodee.gym.service.AdminService;

@Controller
public class AdminController {

	@Autowired
	private AdminService adminService;
	
	// 단순 페이지 이동
	@GetMapping(value="/admin/addTeacherPage")
	public String addTeacherPage() {
		return "admin/adminAddTeacher";
	}
	
	@GetMapping(value="/admin/addClassPage")
	public String addClassPage() {
		return "admin/adminAddClass";
	}
	
	// 강사 추가
	@ResponseBody
	@PostMapping(value="/admin/addTeacher", produces="application/json")
	public Map<String, Object> addTeacher(@RequestBody TeacherDTO teacher) {
		Map<String, Object> map = new HashMap<String, Object>();
		return adminService.addTeacher(teacher);
	}
	
	// 강사 목록 가져오기
	@ResponseBody
	@GetMapping(value="/admin/TeacherList", produces="application/json")
	public Map<String, Object> TeacherList(){
		return adminService.getMembers();
	}
	
	// 종목 별 강사 목록 가져오기
	@ResponseBody
	@GetMapping(value="/admin/teachersBySubject", produces="application/json")
	public Map<String, Object> teachersBySubject(@RequestParam String subject){
		return adminService.getMembersBySubject(subject);
	}
	
	// 종목 별 장소 목록 가져오기
	@ResponseBody
	@GetMapping(value="/admin/locationsBySubject", produces="application/json")
	public Map<String, Object> locationsBySubject(@RequestParam String subject){
		return adminService.getLocationsBySubject(subject);
	}
	
	// 강좌 개설하기
	@ResponseBody
	@PostMapping(value="/admin/addClass", produces="application/json")
	public Map<String, Object> addClass(@RequestParam ClassDTO registclass) {
		System.out.println("하하호홓");
		return adminService.addClass(registclass);
	}
}
