package com.goodee.gym.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.goodee.gym.domain.ClassDTO;
import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.domain.PayListDTO;
import com.goodee.gym.domain.ReservationDTO;


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
	
	/* 관리자 */
	public int selectMemberCount();
	public List<MemberDTO> selectMemberList(Map<String, Object> map);
	
	public int selectClassCount();
	public Integer selectCountByClassCode(String classCode);
	public List<ClassDTO> selectClassList(Map<String, Object> map);
	
	public int selectPayCount();
	public List<PayListDTO> selectPayList(Map<String, Object> map);
	
	public int selectReserveCount();
	public List<ReservationDTO> selectReserveList(Map<String, Object> map);
	
	public int updateReservation(String reservationCode);
	public int updateRemainTicket(@Param(value="memberId") String memberId, @Param(value="remainTicketSubject") String remainTicketSubject);
}
