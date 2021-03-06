package com.goodee.gym.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

public interface TicketService {

	public void findTicketByNo(HttpServletRequest request, Model model);
	
	public void orderConfirm(HttpServletRequest request, Model model);

	public void orderResult(HttpServletRequest request, Model model) throws Exception;

}
