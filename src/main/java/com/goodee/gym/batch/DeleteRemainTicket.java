package com.goodee.gym.batch;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.goodee.gym.domain.RemainTicketDTO;
import com.goodee.gym.mapper.TicketMapper;
				   
@Component
public class DeleteRemainTicket {				   

	@Autowired
	private TicketMapper ticketMapper;
	
	@Scheduled(cron = "0 0 3 1/1 * ?")
	public void execute() throws ParseException{
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String now = format.format(System.currentTimeMillis());
		
		List<RemainTicketDTO> remainTicket = ticketMapper.selectRemainTicket();
		
		for(int i = 0, size = remainTicket.size(); i < size; i++) {
			String endDate = remainTicket.get(i).getRemainTicketEndDate().toString(); 
			if (endDate.equals(now)) {
				ticketMapper.deleteRemainTicket(remainTicket.get(i).getRemainTicketNo());
				System.out.println("만료일이 지난 수강권을 삭제했습니다.");
			}
		}
		
	}
	
	
}
