package com.goodee.gym.batch;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.goodee.gym.mapper.MyPageMapper;


@Component  
public class UpdateReservationState {
	
	@Autowired
	private MyPageMapper myPageMapper;
	
	// 실시간으로 예약시간이 지났으면 확정처리
	@Scheduled(cron = "0/1 * * * * ?")  
	public void execute() throws Exception {
		
		myPageMapper.updateReservationState();
		
	}
}
