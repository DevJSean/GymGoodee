package com.goodee.gym.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TicketDTO {

	private Long ticketNo;
	private String ticketSubject;
	private Integer ticketCount;
	private Integer ticketPeriod;
	private String ticketPrice;
	
}
