package com.goodee.gym.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.gym.domain.NoticeDTO;
import com.goodee.gym.domain.NoticeFileAttachDTO;
import com.goodee.gym.domain.QuestionDTO;

@Mapper
public interface BoardMapper {

	// 공지사항
	public int selectAllNoticesCount();
	public List<NoticeDTO> selectNotices(Map<String, Object> map);
	public int selectNoticesCount(Map<String, Object> map);
	public List<NoticeDTO> selectNoticeList(Map<String, Object> map);
	public NoticeDTO selectNoticeByNo(Long noticeNo);
	public List<NoticeFileAttachDTO> selectFileAttachListInTheNotice(Long noticeNo);
	public int updateNoticeHit(Long noticeNo);
	public NoticeFileAttachDTO selectNoticeFileAttachByNo(Long noticeNo);
	public int insertNotice(NoticeDTO notice);
	public int insertNoticeFileAttach(NoticeFileAttachDTO noticeFileAttach);
	public int deleteNotice(Long noticeNo);
	public int updateNotice(NoticeDTO notice);
	public int deleteNoticeFileAttach(Long noticeFileAttachNo);
	public List<NoticeFileAttachDTO> selectNoticeFileAttachListAtYesterday();
	public List<NoticeDTO> noticeAutoComplete(Map<String, Object> map);
	
	// QNA
	public int selectAllQuestionsCount();
	public List<QuestionDTO> selectQuestions(Map<String, Object> map);
	public int selectQuestionsCount(Map<String, Object> map);
	public List<QuestionDTO> selectQuestionList(Map<String, Object> map);
	public QuestionDTO selectQuestionByNo(Long questionNo);
	public int insertQuestion(QuestionDTO question);
	public int deleteQuestion(Long questionNo);
	public List<QuestionDTO> questionAutoComplete(Map<String, Object> map);
}
