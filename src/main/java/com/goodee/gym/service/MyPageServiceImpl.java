package com.goodee.gym.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.goodee.gym.mapper.MyPageMapper;

@Service
public class MyPageServiceImpl implements MyPageService {

	@Autowired
	private MyPageMapper myPageMapper;
	
	@Override
	public void getCommingReservationsByNo(Long memberNo, Model model) {
		model.addAttribute("commingReservations", myPageMapper.selectCommingReservationsByNo(memberNo));
	}
	
	@Override
	public void getOverReservationsByNo(Long memberNo, Model model) {
		model.addAttribute("overReservations", myPageMapper.selectOverReservationsByNo(memberNo));
	}
	
}
