package com.goodee.gym.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.domain.PayListDTO;
import com.goodee.gym.domain.RemainTicketDTO;
import com.goodee.gym.domain.ReservationDTO;
import com.goodee.gym.domain.TicketDTO;

@Mapper
public interface MyPageMapper {

	// 다가올 수업 내역 조회
	public List<ReservationDTO> selectCommingReservationsByNo(Map<String, Object> map);
	public int selectCommingCount(Map<String, Object> map);
	
	// 예약 취소
	public int updateReservation(String reservationCode);
	public int updateRemainTicket(@Param(value="memberId") String memberId, @Param(value="remainTicketSubject") String remainTicketSubject);
	
	// 지난 수업 내역 조회
	public List<ReservationDTO> selectOverReservationsByNo(Map<String, Object> map);
	public int selectOverCount(Map<String, Object> map);
	
	// 결제 내역 조회
	public List<PayListDTO> selectPayList(Map<String, Object> map);
	public int getPayListCount(Map<String, Object> map);
	
	// 만료일이 지나지 않은 결제 내역 조회
	public List<PayListDTO> selectValidPayList(Long memberNo);
	
	// 동일 종목 추가 결제시
	public int updateTicket(TicketDTO ticket);
	
	// 비밀번호 조회
	public String selectMemberPwByNo(Long memberNo);
	
	// 비밀번호 수정
	public int updatePw(MemberDTO member);
	
	// 개인정보 수정 (이메일, 연락처)
	public int updateMyInfo(MemberDTO member);
	
	// 개인정보 불러오기
	public MemberDTO selectMemberById(Long memberNo);
	
	// 잔여수강권 조회
	public List<RemainTicketDTO> selectTicketsById(String memberId);
	
	// 회원 탈퇴
	public int deleteMember(Long memberNo);
	
	// 비밀번호 변경일 
	public Double selectPwModified(String memberId);
	
	// 예약확정 처리
	public void updateReservationState();
	
}
