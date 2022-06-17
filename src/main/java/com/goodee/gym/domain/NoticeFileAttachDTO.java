package com.goodee.gym.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class NoticeFileAttachDTO {

	private Long noticeFileAttachNo;
	private Long noticeNo;
	private String noticeFileAttachPath;
	private String noticeFileAttachOrigin;
	private String noticeFileAttachSaved;
	
}
