package com.goodee.gym.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.goodee.gym.domain.ClassDTO;
import com.goodee.gym.domain.LocationDTO;
import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.domain.PayListDTO;
import com.goodee.gym.domain.ReservationDTO;
import com.goodee.gym.domain.TeacherDTO;

@Mapper
public interface AdminMapper {

	public int insertTeacher(TeacherDTO teacher);
	public List<TeacherDTO> selectTeachers();
	public List<TeacherDTO> selectTeachersBySubject(String subject);
	public List<LocationDTO> selectLocationsBySubject(String subject);
	public List<String> selectCodesFromReservationByTeacherNo(Long teacherNo);
	public int insertClass(ClassDTO registclass);
	
	//public List<ClassDTO> selectClasses();
	
	
	// 개설 강좌 목록 + 페이징 처리
	
	/* 관리자 */
	public Integer selectClassCount();
	public int selectMemberCount();
	public List<MemberDTO> selectMemberList(Map<String, Object> map);
	
	public Integer selectCountByClassCode(String classCode);
	public List<ClassDTO> selectClassList(Map<String, Object> map);
	
	public int selectPayCount();
	public List<PayListDTO> selectPayList(Map<String, Object> map);
	
	public int selectReserveCount();
	public List<ReservationDTO> selectReserveList(Map<String, Object> map);
	
	public int updateReservation(String reservationCode);
	public int updateRemainTicket(@Param(value="memberId") String memberId, @Param(value="remainTicketSubject") String remainTicketSubject);

	// 검색
	public int selectReservationCount(Map<String, Object> map);
	public List<ReservationDTO> selectReservationList(Map<String, Object> map);
}
