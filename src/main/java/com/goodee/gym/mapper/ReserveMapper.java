package com.goodee.gym.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.gym.domain.ClassDTO;
import com.goodee.gym.domain.ReservationDTO;

@Mapper
public interface ReserveMapper {

	// 종목, 날짜에 해당하는 개설 강좌 목록 가져오기
	public List<ClassDTO> selectClassList(Map<String, Object> map);
	
	// 각 강좌에 현재 예약한 인원이 몇명인지!
	public Integer selectCountByClassCode(String classCode);
	
	// 수영 강좌 예약하기
	public int insertSwim(ReservationDTO reservation);
}
