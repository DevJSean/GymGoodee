package com.goodee.gym.mapper;

import java.util.List;

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
	public int insertClass(ClassDTO registclass);
}
