package com.goodee.gym.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.gym.domain.ReservationDTO;

@Mapper
public interface MyPageMapper {

	public List<ReservationDTO> selectCommingReservationsByNo(Long memberNo);
	public List<ReservationDTO> selectOverReservationsByNo(Long memberNo);
	
}
