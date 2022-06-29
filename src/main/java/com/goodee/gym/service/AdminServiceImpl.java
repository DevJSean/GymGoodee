package com.goodee.gym.service;

import java.io.PrintWriter;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.ArrayList;
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
import com.goodee.gym.util.PageUtils;
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
		List<TeacherDTO> teachers = null;
		teachers = adminMapper.selectTeachers();
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
		
		// 추가하려는 강좌의 강사번호와 일치하는 수업 목록들을 class 테이블에서 가져온다.
		// 가져온 목록들의 class_code를 substring 하여 '날짜_시간'이 일치하는 것이 있는면
		// 추가하면 x
		Long teacherNo = registclass.getTeacherNo();
		List<String> classCodes = new ArrayList<String>();
		classCodes = adminMapper.selectCodesFromReservationByTeacherNo(teacherNo);
		if(classCodes == null) {
			//System.out.println("하나도 없음");
		}
		Map<String, Object> map = new HashMap<String, Object>();
		String originCode = registclass.getClassDate() + "_" + registclass.getClassTime(); // '날짜_시간' 정보
		for(int i = 0; i<classCodes.size();i++) {
			int codeIndex = classCodes.get(i).lastIndexOf("_");
			String tmpCode = classCodes.get(i).substring(0,codeIndex);	// '날짜_시간'
			//System.out.println("tmpCode : " + tmpCode);
			if(originCode.equals(tmpCode)) {
				map.put("state", 501);		// 중복되는 강좌 개설하려고 시도!
				return map;
			}
		}
		
		// 위에 for문에서 if에 걸리지 않으면 여기로 넘어온다.
		// classTime A, B, C, D => 09:00 / 10: 00 / 19:30 / 20:30 으로 변경하기
		String classTime = registclass.getClassTime();
		switch(classTime) {
		case "A":
			registclass.setClassTime("09:00");
			break;
		case "B":
			registclass.setClassTime("10:00");
			break;
		case "C":
			registclass.setClassTime("19:30");
			break;
		case "D":
			registclass.setClassTime("20:30");
			break;
		}
		
		int res = 0;
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
	
	
	
	// 테스트
	@Override
	public Map<String, Object> getClasses1(int page) {
		
		int totalRecord = adminMapper.selectClassCount();
		PageUtils p = new PageUtils();
		p.setPageEntity(totalRecord, page);
		
		// 목록은 beginRecord ~ endRecord 사이값을 가져온다.
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("beginRecord", p.getBeginRecord());
		m.put("endRecord", p.getEndRecord());
		
		// 목록과 페이징 정보를 반환한다.
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("classes", adminMapper.selectClassList(m));
		map.put("p", p);
				
		return map;
	}

}
