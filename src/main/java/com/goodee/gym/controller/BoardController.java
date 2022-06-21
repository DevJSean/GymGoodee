package com.goodee.gym.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.goodee.gym.service.BoardService;

@Controller
public class BoardController {
	
	@Autowired
	private BoardService boardService;

	@GetMapping(value="/board/noticeSearchPage") 
	public String noticeList() {
		return "board/noticeSearch";              
	}
	
	@GetMapping(value="/board/noticeList")
	public String noticeList(HttpServletRequest request, Model model) {
		boardService.getAllNotices(request, model);
		return "board/noticeSearch";
	}
	
	@GetMapping(value="/board/noticeSearch")
	public String noticeSearch(HttpServletRequest request, Model model) {
		boardService.findNotices(request, model);
		return "board/noticeSearch";
	}
	
	@ResponseBody
	@GetMapping(value="/board/noticeAutoComplete", produces="application/json")
	public Map<String, Object> noticeAutoComplete(HttpServletRequest request) {
		return boardService.noticeAutoComplete(request);
	}
	
	@GetMapping(value="/board/qnaSearchPage") 
	public String qnaList() {
		return "board/qnaSearch";              
	}
	
	@PostMapping(value="/board/uploadSummernoteImage", produces="application/json")
	@ResponseBody
	public Map<String, Object> uploadSummernoteImage(MultipartHttpServletRequest multipartRequest) {
		return boardService.uploadSummernoteImage(multipartRequest);
	}
	
	
	@GetMapping(value="/board/reviewSearchPage") 
	public String reviewList() {
		return "board/reviewSearch";              
	}
	
	
	
}
