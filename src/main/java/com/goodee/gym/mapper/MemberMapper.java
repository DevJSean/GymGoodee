package com.goodee.gym.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.gym.domain.MemberDTO;


@Mapper
public interface MemberMapper {

	public MemberDTO selectMemberById(String memberId);
	public MemberDTO selectSignOutMemberById(String memberId);
	public MemberDTO selectMemberByEmail(String memberEmail);
	public int insertMember(MemberDTO member);
	public MemberDTO selectMemberByIdPw(MemberDTO member);
	public int insertMemberLog(Long memberNo);
	
	/* 네이버 */
	public int insertNaver(MemberDTO naver);
	
	/* 카카오 */
	public int insertKakao(MemberDTO kakao);

	
	/* 아이디 찾기 */
	public MemberDTO selectMemberByNameEmail(MemberDTO member);
	
	/* 비밀번호 찾기 */
	public MemberDTO selectMemberByIdPhone(MemberDTO member);
	public int updatePw(MemberDTO member);
	
}
