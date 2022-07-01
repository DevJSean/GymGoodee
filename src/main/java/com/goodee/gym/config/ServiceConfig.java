package com.goodee.gym.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.goodee.gym.service.AdminService;
import com.goodee.gym.service.AdminServiceImpl;
import com.goodee.gym.service.BoardService;
import com.goodee.gym.service.BoardServiceImpl;
import com.goodee.gym.service.MemberService;
import com.goodee.gym.service.MemberServiceImpl;
import com.goodee.gym.service.MyPageService;
import com.goodee.gym.service.MyPageServiceImpl;
import com.goodee.gym.service.ReserveService;
import com.goodee.gym.service.ReserveServiceImpl;
import com.goodee.gym.service.TicketService;
import com.goodee.gym.service.TicketServiceImpl;


@Configuration
public class ServiceConfig {

	@Bean
	public MemberService memberService() {
		return new MemberServiceImpl();
	}
	
	@Bean
	public MyPageService myPageService() {
		return new MyPageServiceImpl();
	}
	
	@Bean
	public TicketService ticketService() {
		return new TicketServiceImpl();
	}
	
	@Bean
	public AdminService adminService() {
		return new AdminServiceImpl();
	}
	
	@Bean
	public ReserveService reserveService() {
		return new ReserveServiceImpl();
	}
	
	@Bean
	public BoardService boardService() {
		return new BoardServiceImpl();
	}
}