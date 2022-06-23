package com.goodee.gym.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.domain.PayListDTO;
import com.goodee.gym.domain.ReservationDTO;

@Mapper
public interface MyPageMapper {

	// 다가올 수업 내역 조회
	public List<ReservationDTO> selectCommingReservationsByNo(Long memberNo);
	public int selectCommingCount(Long memberNo);
	
	// 지난 수업 내역 조회
	public List<ReservationDTO> selectOverReservationsByNo(Map<String, Object> map);
	public int selectOverCount(Long memberNo);
	
	// 결제 내역 조회
	public List<PayListDTO> selectPayList(Long memberNo);
	
	// 비밀번호 조회
	public String selectPwByNo(Long memberNo);
	
	// 개인정보 조회
	public MemberDTO selectMyInfoByNo(Long memberNo);
	
	// 비밀번호 수정
	public int updatePw(String memberPw);
}
