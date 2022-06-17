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
public class SignOutMemberDTO {
	
	private Long signOutMemberNo;
	private Long memberNo;
	private String memberId;
	private String memberName;
	private String memberBirth;
	private String memberGender;
	private String memberPhone;
	private String memberEmail;
	private Integer memberAgreeState;
	private Date memberSignUp;
	private Date signOutMemberSignOut;
	
}
