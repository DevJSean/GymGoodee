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
	private String locationCode;
	private Long teacherNo;
	private String classDate;
	private String classTime;
}
