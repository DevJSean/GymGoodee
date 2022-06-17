package com.goodee.gym.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TeacherDTO {
	
	private Long teacherNo;
	private String teacherName;
	private String teacherGender;
	private String teacherSubject;
}
