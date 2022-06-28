package com.goodee.gym.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.gym.domain.AnswerDTO;
import com.goodee.gym.domain.ClassDTO;
import com.goodee.gym.domain.NoticeDTO;
import com.goodee.gym.domain.NoticeFileAttachDTO;
import com.goodee.gym.domain.QuestionDTO;
import com.goodee.gym.domain.ReviewDTO;

@Mapper
public interface BoardMapper {

	// 공지사항
	public int selectAllNoticesCount();
	public List<NoticeDTO> selectNotices(Map<String, Object> map);
	public int selectNoticesCount(Map<String, Object> map);
	public List<NoticeDTO> selectNoticeList(Map<String, Object> map);
	public List<NoticeDTO> noticeAutoComplete(Map<String, Object> map);
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
	
	// QNA
	public int selectAllQuestionsCount();
	public List<QuestionDTO> selectQuestions(Map<String, Object> map);
	public int selectQuestionsCount(Map<String, Object> map);
	public List<QuestionDTO> selectQuestionList(Map<String, Object> map);
	public List<QuestionDTO> questionAutoComplete(Map<String, Object> map);
	public QuestionDTO selectQuestionByNo(Long questionNo);
	public AnswerDTO selectAnswerByNo(Long questionNo);
	public int updateQuestionHit(Long questionNo);
	public int insertQuestion(QuestionDTO question);
	public int deleteQuestion(Long questionNo);
	public int insertAnswer(AnswerDTO answer);
	public int deleteAnswer(Long questionNo);
	
	// 리뷰
	public int selectAllReviewsCount();
	public List<ReviewDTO> selectReviews(Map<String, Object> map);
	public int selectReviewsCount(Map<String, Object> map);
	public List<ReviewDTO> selectReviewList(Map<String, Object> map);
	public List<ReviewDTO> reviewAutoComplete(Map<String, Object> map);
	public ReviewDTO selectReviewByNo(Long reviewNo);
	public int selectRepliesCount(Long reviewNo); // 해당 게시글에 해당하는 댓글만 세야 함
	public List<ReviewDTO> selectReplies(Map<String, Object> map); // 해당 게시글에 해당하는 댓글만 리스트 뽑아야
	public int updateReviewHit(Long reviewNo);
	public List<ClassDTO> selectTookClassCode(String memberId);
	public int insertReview(ReviewDTO review);
	public int deleteReview(Long reviewNo);
	public int updatePreviousReply(ReviewDTO previousReply);
	public int insertReply(ReviewDTO reply);
	public int deleteReply(Long reviewNo);
}

