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
public class MemberLogDTO {
	
	private Long memberLogNo;
	private Long memberNo;
	private Date memberLogSignIn;
	
}
