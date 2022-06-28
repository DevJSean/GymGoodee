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
public class ReviewDTO {

	private Long reviewNo;
	private String classCode;
	private String reviewSubject;
	private String memberId;
	private String reviewTitle;
	private String reviewContent;
	private Integer reviewHit;
	private String reviewIp;
	private Date reviewCreated;
	private Integer reviewState;
	private Integer reviewDepth;
	private Long reviewGroupNo;
	private Integer reviewGroupOrd;
	
	private Integer replyCount;
	
}
