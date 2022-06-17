package com.goodee.gym.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class QuestionFileAttachDTO {

	private Long QuestionFileAttachNo;
	private Long QuestionNo;
	private String QuestionFileAttachPath;
	private String QuestionFileAttachOrigin;
	private String QuestionFileAttachSaved;
	
}
