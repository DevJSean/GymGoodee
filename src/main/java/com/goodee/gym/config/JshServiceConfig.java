package com.goodee.gym.config;

import org.springframework.context.annotation.Configuration;

import com.goodee.gym.service.BoardService;
import com.goodee.gym.service.BoardServiceImpl;

@Configuration
public class JshServiceConfig {

	public BoardService boardService() {
		return new BoardServiceImpl();
	}
}
