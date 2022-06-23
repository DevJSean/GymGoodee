package com.goodee.gym.service;

import java.io.PrintWriter;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import com.goodee.gym.domain.ClassDTO;
import com.goodee.gym.domain.TeacherDTO;
import com.goodee.gym.mapper.AdminMapper;
import com.goodee.gym.util.SecurityUtils;

@Service
public class AdminServiceImpl implements AdminService {
	
	@Autowired
	private AdminMapper adminMapper;

	// 강사 등록
	@Override
	public Map<String, Object> addTeacher(TeacherDTO teacher) {
		// 이름 XSS 처리
		teacher.setTeacherName(SecurityUtils.xss(teacher.getTeacherName()));
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("res", adminMapper.insertTeacher(teacher));
		
		return map;
	}
	
	
	// 강사 목록 가져오기
	@Override
	public Map<String, Object> getMembers() {
		Map<String, Object> members = new HashMap<String, Object>();
		List<TeacherDTO> teachers = adminMapper.selectTeachers();
		if(teachers == null) {
			// 강사 정보가 없을 경우
			members.put("teachers", null);
			members.put("res", 0);
		} else {
			members.put("teachers",teachers);
			members.put("res", 1);
		}
		return members;
	}
	
	// 종목 선택 후 해당 종목 강사 목록 가져오기
	@Override
	public Map<String, Object> getMembersBySubject(String subject) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("teachers", adminMapper.selectTeachersBySubject(subject));
		return map;
	}
	
	// 종목 선택 후 해당 종목 장소 목록 가져오기
	@Override
	public Map<String, Object> getLocationsBySubject(String subject) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("locations", adminMapper.selectLocationsBySubject(subject));
		return map;
	}
	
	
	// 개설 강좌 추가하기
	@Override
	public Map<String, Object> addClass(ClassDTO registclass, HttpServletResponse response) {
		// 강좌 코드 (날짜_시간_장소)로 만들기
		String classCode = registclass.getClassDate() + "_" + registclass.getClassTime() +"_" + registclass.getLocationCode();
		//System.out.println("1. classCode =" + classCode);
		registclass.setClassCode(classCode);
		
		int res = 0;
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			res = adminMapper.insertClass(registclass);
			map.put("res", res);
			return map;
			
		} catch (DuplicateKeyException e) {
			try {
				PrintWriter out = response.getWriter();
				response.setContentType("text/plain");
				response.setStatus(502);
				out.println("해당 강좌는 이미 개설되었습니다.");				
				out.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return null;
	}
	
	// 개설 강좌 목록 가져오기
	@Override
	public Map<String, Object> getClasses() {
		Map<String, Object> map = new HashMap<String, Object>();
		List<ClassDTO> classes = adminMapper.selectClasses();
		if(classes == null) {
			// 개설 강좌 정보가 없을 경우
			map.put("classes", null);
			map.put("res", 0);
		} else {
			map.put("classes",classes);
			map.put("res", 1);
		}
		return map;
	}
	
	

}