package com.goodee.gym.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.goodee.gym.domain.QuestionDTO;

public interface BoardService {

	// 공지사항 전체조회
	public void getAllNotices(HttpServletRequest request, Model model);
	// 공지사항 검색 (noticeList)
	public void findNotices(HttpServletRequest request, Model model);
	// 공지사항 자동완성
	public Map<String, Object> noticeAutoComplete(HttpServletRequest request);
	// 공지사항 상세 보기
	public void getNoticeByNo(HttpServletRequest request, Model model);
	public ResponseEntity<byte[]> noticeDisplay(Long noticeFileAttachNo, String type);
	public ResponseEntity<byte[]> display(String path, String thumbnail);
	public ResponseEntity<Resource> noticeDownload(String userAgent, Long noticeFileAttachNo);
	// 공지사항 삽입
	public Map<String, Object> addNotice(MultipartHttpServletRequest multipartRequest);
	// 공지사항 삭제
	public void removeNotice(HttpServletRequest request, HttpServletResponse response);
	// 공지사항 수정
	public void noticeModify(MultipartHttpServletRequest multipartRequest, HttpServletResponse response);
	// 공지사항 파일 삭제
	public void removeNoticeFileAttach(Long noticeFileAttachNo);
	
	
	// 질문 전체조회
	public void getAllquestions(HttpServletRequest request, Model model);
	// 질문 검색 (questionList)
	public void findQuestions(HttpServletRequest request, Model model);
	// 질문 자동완성
	public Map<String, Object> questionAutoComplete(HttpServletRequest request);
	// 질문 검색 (questionDetail)
	public QuestionDTO getQuestionByNo(Long questionNo);
	// 질문 추가
	public void addQuestion(HttpServletRequest request, HttpServletResponse response);
	// 질문 삭제
	public void removeQuestion(HttpServletRequest request, HttpServletResponse response);
	// 질문 summernote에 image 첨부하기
	public Map<String, Object> uploadSummernoteImage(MultipartHttpServletRequest multipartRequest);
}
