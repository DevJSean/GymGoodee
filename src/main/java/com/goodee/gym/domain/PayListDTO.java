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
public class PayListDTO {
	
	private Long payListNo;
	private Long memberNo;
	private Long ticketNo;
	private Date payListDate;

	/* 결제내역조회에 쓰일 값 추가 */
	private Long rn;
	private TicketDTO ticket;
	private String memberId;
	
}
