package com.goodee.gym.batch;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.domain.RemainTicketDTO;
import com.goodee.gym.mapper.MemberMapper;
import com.goodee.gym.mapper.TicketMapper;

import net.nurigo.java_sdk.exceptions.CoolsmsException;


@Component  
public class AlertRemainSevenDays {

	@Autowired
	private TicketMapper ticketMapper;
	
	@Autowired
	private MemberMapper memberMapper;
	
	// 매일 새벽 3시에 어제 첨부된 파일 중 잘못된 파일들을 찾아서 제거한다.
	@Scheduled(cron = "0 0 12 1/1 * ?")  
	public void execute() {
		
		List<RemainTicketDTO> remainTicket = ticketMapper.selectRemainTicket();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		
		Date now = new Date(System.currentTimeMillis());
		
		Calendar cal = Calendar.getInstance();
		
		cal.setTime(now);
		cal.add(Calendar.DATE, 7);
		
		String date = sdf.format(cal.getTime());

		for(int i = 0, size = remainTicket.size(); i < size; i++) {
			
			Date endDate = remainTicket.get(i).getRemainTicketEndDate();
			
			String remainTicketEndDate = sdf.format(endDate);
			
			String memberId = remainTicket.get(i).getMemberId();
			
			MemberDTO loginMember = memberMapper.selectMemberById(memberId);
			String memberPhone = loginMember.getMemberPhone();
			
			if (remainTicketEndDate.equals(date)) {
				
				String api_key = "NCSM4A6HJTQWGBU3";
			    String api_secret = "G0IP0LQVML0IOUNCZCJRQQWBHJGJH982";
			    net.nurigo.java_sdk.api.Message coolsms = new net.nurigo.java_sdk.api.Message(api_key, api_secret);
				
			    HashMap<String, String> params = new HashMap<>();
			    params.put("to", memberPhone);
				params.put("from", "0221085900");
				params.put("type", "SMS");
				params.put("text", "[gym] 수강권 만료일이 7일 남았습니다.");
				params.put("app_version", "test app 1.2");
				
				try {
					JSONObject obj = (JSONObject)(coolsms).send(params);
					System.out.println(obj);
				} catch (CoolsmsException e) {
					e.printStackTrace();
				}
				System.out.println("같다");
			}
		}
		
	}
}
