package com.goodee.gym.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.gym.domain.NoticeDTO;

@Mapper
public interface BoardMapper {

	//  공지사항
	public int selectAllNoticesCount();
	public List<NoticeDTO> selectNotices(Map<String, Object> map);
	public int selectNoticesCount(Map<String, Object> map);
	public List<NoticeDTO> selectNoticeList(Map<String, Object> map);
	public List<NoticeDTO> noticeAutoComplete(Map<String, Object> map);
	
	
}
