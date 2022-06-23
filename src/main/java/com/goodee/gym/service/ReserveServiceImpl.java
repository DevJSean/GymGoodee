package com.goodee.gym.service;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;

import com.goodee.gym.domain.ClassDTO;
import com.goodee.gym.domain.ReservationDTO;
import com.goodee.gym.mapper.ReserveMapper;

public class ReserveServiceImpl implements ReserveService {
	
	@Autowired
	private ReserveMapper reserveMapper;
	
	
	// 해당 종목, 날짜에 개설된 강좌 목록 가져오기
	@Override
	public void getClasses(HttpServletRequest request, Model model) {
		// reserveMapper.selectClassList 에 map 형식으로 넘겨준다.
		String subject = request.getParameter("subject");
		String classDate = request.getParameter("classDate");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("subject", subject.substring(0,2));
		map.put("classDate",classDate);
		
		
		// 1. 개설 강좌 목록
		List<ClassDTO> classes = reserveMapper.selectClassList(map);
		for(int i = 0; i<classes.size();i++) {
			String classCode = classes.get(i).getClassCode();
			classes.get(i).setCurrentCount(reserveMapper.selectCountByClassCode(classCode));
		}
		model.addAttribute("classes", classes);
	}
	
	
	// 종목 별 현재 예약 인원수
	@Override
	public int getCountByClassCode(String classCode) {
		return reserveMapper.selectCountByClassCode(classCode);
	}

	// 수영 예약하기
	@Override
	public Map<String, Object> reserveSwim(HttpServletRequest request) {
		// request에서 파라미터들 받아와서 insert 할 reservationDTO 만들고
		// 결과 res 로 받아오기
		String subject = request.getParameter("subject");
		Long memberNo = Long.parseLong(request.getParameter("memberNo"));
		String classCode = request.getParameter("classCode");
		
		ReservationDTO reservation = ReservationDTO.builder()
				.classCode(classCode)
				.memberNo(memberNo)
				.reservationCode(subject)		// 일단 reservationCode를 subject로 쓰자 -> 수정 해아함
				.build();
		
		int res = reserveMapper.insertSwim(reservation);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("res", res);
		
		
		return map;
		
	}
	
	
	// test
	@Override
	public Map<String, Object> getClasses1(HttpServletRequest request, Model model) {
		String subject = request.getParameter("subject");
		String classDate = request.getParameter("classDate");
		//System.out.println("subject: " + subject + " classDate: " + classDate);
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("subject", subject.substring(0,2));
		map.put("classDate",classDate);
		
		
		// 1. 개설 강좌 목록
		List<ClassDTO> classes = reserveMapper.selectClassList(map);
		for(int i = 0; i<classes.size();i++) {
			String classCode = classes.get(i).getClassCode();
			classes.get(i).setCurrentCount(reserveMapper.selectCountByClassCode(classCode));
		}
		Map<String, Object> res = new HashMap<String, Object>();
		
		res.put("classes", classes);
		return res;
	}
}
