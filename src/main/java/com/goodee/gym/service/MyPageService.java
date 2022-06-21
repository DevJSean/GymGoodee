package com.goodee.gym.service;

import org.springframework.ui.Model;

public interface MyPageService {
	
	public void getCommingReservationsByNo(Long memberNo, Model model);
	public void getOverReservationsByNo(Long memberNo, Model model);
}
