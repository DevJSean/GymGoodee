package com.goodee.gym.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ClassDTO {

	private String classCode;
	private Long teacherNo;
	private String locationCode;
	private String classDate;
	private String classTime;
	
	// 강사명에 대한 정보 추가
	private String teacherName;
	
	// 해당 장소의 정원 정보 가져오기
	private Integer locationLimit;
	
	// 현재 신청인원수
	private Integer currentCount;
}
