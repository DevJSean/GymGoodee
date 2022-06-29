package com.goodee.gym.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.gym.domain.ClassDTO;
import com.goodee.gym.domain.LocationDTO;
import com.goodee.gym.domain.TeacherDTO;

@Mapper
public interface AdminMapper {

	public int insertTeacher(TeacherDTO teacher);
	public List<TeacherDTO> selectTeachers();
	public List<TeacherDTO> selectTeachersBySubject(String subject);
	public List<LocationDTO> selectLocationsBySubject(String subject);
	public List<String> selectCodesFromReservationByTeacherNo(Long teacherNo);
	public int insertClass(ClassDTO registclass);
	public List<ClassDTO> selectClasses();
	
	
	// 테스트
	public Integer selectClassCount();
	public List<ClassDTO> selectClassList(Map<String, Object> map);
}
