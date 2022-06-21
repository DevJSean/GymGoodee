package com.goodee.gym.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface BoardService {

	// 공지사항 전체조회
	public void getAllNotices(HttpServletRequest request, Model model);
	// 공지사항 검색
	public void findNotices(HttpServletRequest request, Model model);
	// 공지사항 자동완성
	public Map<String, Object> noticeAutoComplete(HttpServletRequest request);
	
	// qna summernote에 image 첨부하기
	public Map<String, Object> uploadSummernoteImage(MultipartHttpServletRequest multipartRequest);
}
