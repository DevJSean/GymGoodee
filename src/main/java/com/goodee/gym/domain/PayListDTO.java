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
	
}
