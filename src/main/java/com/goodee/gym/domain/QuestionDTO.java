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
public class QuestionDTO {

	private Long questionNo;
	private String memberId;
	private String questionTitle;
	private String questionContent;
	private Integer questionHit;
	private String questionIp;
	private Date questionCreated;
	private Date questionModified;
	
}
