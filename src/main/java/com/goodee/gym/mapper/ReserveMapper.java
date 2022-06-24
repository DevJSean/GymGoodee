package com.goodee.gym.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.gym.domain.ClassDTO;
import com.goodee.gym.domain.ReservationDTO;

@Mapper
public interface ReserveMapper {

	// 1. 리스트 가져오기
	// 종목, 날짜에 해당하는 개설 강좌 목록 가져오기
	public List<ClassDTO> selectClassList(Map<String, Object> map);
	
	// 개설 강좌 갯수 가져오기
	public int selectCountClassList(Map<String, Object> map);
	
	// 잔여 수강권에서 남은 티켓 수 가져오기
	public String getRemainTicketBySubject(Map<String, Object> map);
	
	// 각 강좌에 현재 예약한 인원이 몇명인지!(쿼리문에서 where reservation_state = 0)
	public Integer selectCountByClassCode(String classCode);
	
	// 회원 번호와, classCode를 넘기면 reservation 테이블의 RESERVATION_STATE(string)를 반환해준다.
	public String selectReservationByClassCode(Map<String, Object> map);
	

	// 2. 수영 강좌 예약하기
	// 1) 예약 테이블에서 넘겨준 memberNo, classCode 에 일치하는 회원이 있는지 확인
	public int selectMemberFromReservation(Map<String, Object> map);
	// 2-1) 예약 -> 취소 -> 다시 예약하는 상황
	public int updateAgainReserve(Map<String, Object> map);
	
	// 2-2) 처음 예약
	public int insertReserveSwim(ReservationDTO reservation);
	
	
	// 3. 수영 예약 취소하기
	public int updateCancelSwim(Map<String, Object> map);
	
	
}
