package com.goodee.gym.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.goodee.gym.service.BoardService;

@Controller
public class BoardController {
	
	@Autowired
	private BoardService boardService;

	/*** 공지사항 ***/
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

	@GetMapping(value="/board/noticeDetail")
	public String noticeDetail(HttpServletRequest request, Model model) {
		boardService.getNoticeByNo(request, model);
		return "board/noticeDetail";
	}
	
	@GetMapping(value="/board/noticeDisplay")
	@ResponseBody 
	public ResponseEntity<byte[]> noticeDisplay(Long noticeFileAttachNo, @RequestParam(value="type", required=false, defaultValue="image") String type) {
		return boardService.noticeDisplay(noticeFileAttachNo, type);
	}
	
	@ResponseBody
	@GetMapping(value="/board/display")
	public ResponseEntity<byte[]> display(String path, String thumbnail) {
		return boardService.display(path, thumbnail);
	}
	
	@GetMapping(value="/board/noticeDownload")
	@ResponseBody
	public ResponseEntity<Resource> noticeDownload(@RequestHeader("User-Agent") String userAgent, @RequestParam Long noticeFileAttachNo) {
		return boardService.noticeDownload(userAgent, noticeFileAttachNo);
	}
	
	@GetMapping(value="/board/noticeAddPage")
	public String noticeAddPage() {
		return "board/noticeAdd";
	}
	
	@ResponseBody
	@PostMapping(value="/board/noticeAdd", produces="application/json")
	public Map<String, Object> noticeAdd(MultipartHttpServletRequest multipartRequest) {
		return boardService.addNotice(multipartRequest);
	}
	
	@GetMapping(value="/board/noticeRemove")
	public void noticeRemove(HttpServletRequest request, HttpServletResponse response) {
		boardService.removeNotice(request, response);
	}
	
	@GetMapping(value="/board/noticeModifyPage")
	public String noticeModifyPage(HttpServletRequest request, Model model) {
		boardService.getNoticeByNo(request, model);
		return "board/noticeModify";
	}
	
	@PostMapping(value="/board/noticeModify")
	public void change(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) {
		boardService.noticeModify(multipartRequest, response);
	}
	
	@GetMapping(value="/board/removeNoticeFileAttach")
	public String removeNoticeFileAttach(@RequestParam Long noticeFileAttachNo, @RequestParam Long noticeNo) {
		boardService.removeNoticeFileAttach(noticeFileAttachNo);
		return "redirect:/board/noticeDetail?noticeNo=" + noticeNo;
	}
	
	@ResponseBody
	@GetMapping(value="/board/noticeAutoComplete", produces="application/json")
	public Map<String, Object> noticeAutoComplete(HttpServletRequest request) {
		return boardService.noticeAutoComplete(request);
	}
	
	
	
	
	
	/*** QNA ***/
	@GetMapping(value="/board/questionList")
	public String questionList(HttpServletRequest request, Model model) {
		boardService.getAllquestions(request, model);
		return "board/questionSearch";
	}
	
	@GetMapping(value="/board/questionSearch")
	public String questionSearch(HttpServletRequest request, Model model) {
		boardService.findQuestions(request, model);
		return "board/questionSearch";
	}
	
	@GetMapping(value="/board/questionDetail")
	public String questionDetail(@RequestParam(value="questionNo", required=false, defaultValue="0") Long questionNo, Model model) {
		model.addAttribute("question", boardService.getQuestionByNo(questionNo));
		return "board/questionDetail";
	}
	
	@GetMapping(value="/board/questionAddPage")
	public String questionAddPage() {
		return "board/questionAdd";
	}
	
	@PostMapping(value="/board/questionAdd")
	public void questionAdd(HttpServletRequest request, HttpServletResponse response) {
		boardService.addQuestion(request, response);
	}
	
	@GetMapping(value="/board/questionRemove")
	public void questionRemove(HttpServletRequest request, HttpServletResponse response) {
		boardService.removeQuestion(request, response);
	}
	
	@ResponseBody
	@GetMapping(value="/board/questionAutoComplete", produces="application/json")
	public Map<String, Object> questionAutoComplete(HttpServletRequest request) {
		return boardService.questionAutoComplete(request);
	}
	
	@ResponseBody
	@PostMapping(value="/board/uploadSummernoteImage", produces="application/json")
	public Map<String, Object> uploadSummernoteImage(MultipartHttpServletRequest multipartRequest) {
		return boardService.uploadSummernoteImage(multipartRequest);
	}
	
	/*** 리뷰 ***/
	@GetMapping(value="/board/reviewList") 
	public String reviewSearchPage(HttpServletRequest request, Model model) {
		return "board/reviewSearch";              
	}
	
	
	
}
