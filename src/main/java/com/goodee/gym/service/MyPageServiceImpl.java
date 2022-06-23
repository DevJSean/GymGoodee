package com.goodee.gym.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.goodee.gym.mapper.MyPageMapper;
import com.goodee.gym.util.PageUtils;

@Service
public class MyPageServiceImpl implements MyPageService {

	@Autowired
	private MyPageMapper myPageMapper;
	
	// 다가올 수업 내역 조회
	@Override
	public void getCommingReservationsByNo(HttpServletRequest request, Model model) {
		Optional<String> optNo = Optional.ofNullable(request.getParameter("memberNo"));
		Long memberNo = Long.parseLong(optNo.orElse("0"));
		
		model.addAttribute("commingReservations", myPageMapper.selectCommingReservationsByNo(memberNo));
		model.addAttribute("commingTotalCount", myPageMapper.selectCommingCount(memberNo));
	}
	
	// 지난 수업 내역 조회
	@Override
	public void getOverReservationsByNo(HttpServletRequest request, Model model) {
		Optional<String> optNo = Optional.ofNullable(request.getParameter("memberNo"));
		Long memberNo = Long.parseLong(optNo.orElse("0"));
		
		Optional<String> optPage = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(optPage.orElse("1"));
		
		int overTotalCount = myPageMapper.selectOverCount(memberNo);
		
		PageUtils pageUtils = new PageUtils();
		pageUtils.setPageEntity(overTotalCount, page);
		
		Map<String, Object> map = new HashMap<>();
		map.put("beginRecord", pageUtils.getBeginRecord());
		map.put("endRecord", pageUtils.getEndRecord());
		map.put("memberNo", memberNo);
		
		model.addAttribute("overTotalCount", overTotalCount);
		model.addAttribute("paging", pageUtils.getPaging1(request.getContextPath() + "/mypage/myReserveList?memberNo=101"));
		model.addAttribute("overReservations", myPageMapper.selectOverReservationsByNo(map));
	}
	
	// 결제 내역 조회
	@Override
	public void getMyPayListByNo(Long memberNo, Model model) {
		model.addAttribute("payList", myPageMapper.selectPayList(memberNo));
	}
	
	// 비밀번호 조회
	@Override
	public void getMemberPw(Long memberNo, Model model) {
		model.addAttribute("memberPw", myPageMapper.selectPwByNo(memberNo));
	}
	
	// 개인정보 조회
	@Override
	public void getMyInfoByNo(Long memberNo, Model model) {
		model.addAttribute("member", myPageMapper.selectMyInfoByNo(memberNo));
	}
}
