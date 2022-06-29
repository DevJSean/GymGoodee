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
public class MemberDTO {

	private Long rn;
	private Long memberNo;
	private String memberId;
	private String memberPw;
	private String memberName;
	private String memberBirth;
	private String memberGender;
	private String memberPhone;
	private String memberEmail;
	private Integer memberAgreeState;
	private Date memberSignUp;
	private Date memberPwModified;
	private Integer memberState;
	
}
