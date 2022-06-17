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
public class AnswerDTO {

	private Long answerNo;
	private Long questionNo;
	private String answerContent;
	private Date answerCreated;
	
}
