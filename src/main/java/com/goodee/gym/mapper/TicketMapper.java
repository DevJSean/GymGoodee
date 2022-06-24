package com.goodee.gym.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.gym.domain.PayListDTO;
import com.goodee.gym.domain.TicketDTO;

@Mapper
public interface TicketMapper {

	public TicketDTO selectTicketByNo(Long ticketNo);
	
	public Integer insertPayList(PayListDTO payList);
	
}
