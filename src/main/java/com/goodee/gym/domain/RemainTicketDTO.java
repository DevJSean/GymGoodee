package com.goodee.gym.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RemainTicketDTO {

	private Long remainTicketNo;
	private String memberId;
	private String remainTicketSubject;
	private Date remainTicketEndDate;
	private Integer remainTicketRemainCount;
	
}
