package com.goodee.gym.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.gym.domain.PayListDTO;
import com.goodee.gym.domain.RemainTicketDTO;
import com.goodee.gym.domain.TicketDTO;

@Mapper
public interface TicketMapper {

	public TicketDTO selectTicketByNo(Long ticketNo);
	
	public Integer insertPayList(PayListDTO payList);
	
	public Integer insertRemainTicket(RemainTicketDTO remainTicket);
	
	public List<RemainTicketDTO> selectRemainTicket();
	
	public Integer selectCountRemainTicket(RemainTicketDTO remainTicket);
	
	public int deleteRemainTicket(Long remainTicketNo);
}
