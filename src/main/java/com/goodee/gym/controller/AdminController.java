package com.goodee.gym.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
	
	
	// 추가
	@GetMapping("/admin/memberList")
	public String memberList(HttpServletRequest request, Model model) {
		adminService.memberList(request, model);
		return "admin/memberList";
	}
	
	@GetMapping("/admin/classList")
	public String classList(HttpServletRequest request, Model model) {
		adminService.classList(request, model);
		return "admin/classList";
	}
	
	@GetMapping("/admin/payList")
	public String payList(HttpServletRequest request, Model model) {
		adminService.payList(request, model);
		return "admin/payList";
	}
	
	@GetMapping("/admin/reserveList")
	public String reserveList(HttpServletRequest request, Model model) {
		adminService.reserveList(request, model);
		return "admin/reserveSearch";
	}
	
	@ResponseBody
	@GetMapping(value="/admin/reserveCancle", produces="application/json")
	public Map<String, Object> remove(@RequestParam String reservationCode, @RequestParam String memberId, @RequestParam String remainTicketSubject) {
		return adminService.reserveCancle(reservationCode, memberId, remainTicketSubject);
	}
	

	
	// 강사 추가(INSERT)
	@ResponseBody
	@PostMapping(value="/admin/addTeacher", produces="application/json")
	public Map<String, Object> addTeacher(@RequestBody TeacherDTO teacher) {
		Map<String, Object> map = new HashMap<String, Object>();
		return adminService.addTeacher(teacher);
	}
	
	// 강사 목록 가져오기 (SELECT)
	@ResponseBody
	@GetMapping(value="/admin/TeacherList", produces="application/json")
	public Map<String, Object> TeacherList(){
		return adminService.getMembers();
	}
	
	// 종목 별 강사 목록 가져오기 (SELECT)
	@ResponseBody
	@GetMapping(value="/admin/teachersBySubject", produces="application/json")
	public Map<String, Object> teachersBySubject(@RequestParam String subject){
		return adminService.getMembersBySubject(subject);
	}
	
	// 종목 별 장소 목록 가져오기 (SELECT)
	@ResponseBody
	@GetMapping(value="/admin/locationsBySubject", produces="application/json")
	public Map<String, Object> locationsBySubject(@RequestParam String subject){
		return adminService.getLocationsBySubject(subject);
	}
	
	// 강좌 개설하기 (INSERT) ( json <-> json )
	@ResponseBody
	@PostMapping(value="/admin/addClass", produces="application/json")
	public Map<String, Object> addClass(@RequestBody ClassDTO registclass, HttpServletResponse response) {
		return adminService.addClass(registclass, response);
	}
	
	// 강좌 목록 + 페이징 처리
	@ResponseBody
	@GetMapping(value="/admin/ClassList", produces="application/json")
	public Map<String, Object> ClassList(int page){
		return adminService.getClasses(page);
	}
	
	
	// 예약 목록 검색
	@GetMapping(value="/admin/reserveSearch")
	public String noticeSearch(HttpServletRequest request, Model model) {
		adminService.findReserves(request, model);
		return "admin/reserveSearch";
	}
	
	

	
}
