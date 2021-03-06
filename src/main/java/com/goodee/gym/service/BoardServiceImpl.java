package com.goodee.gym.service;

import java.io.File;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.goodee.gym.domain.AnswerDTO;
import com.goodee.gym.domain.ClassDTO;
import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.domain.NoticeDTO;
import com.goodee.gym.domain.NoticeFileAttachDTO;
import com.goodee.gym.domain.QuestionDTO;
import com.goodee.gym.domain.ReviewDTO;
import com.goodee.gym.mapper.BoardMapper;
import com.goodee.gym.util.MyFileUtils;
import com.goodee.gym.util.PageUtils;

import net.coobird.thumbnailator.Thumbnails;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardMapper boardMapper;
	
	/****************/
	/**** notice ****/
	/****************/
	@Override
	public void getAllNotices(HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		if(session.getAttribute("updateHit") != null) {
			session.removeAttribute("updateHit");
		}
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		int totalRecord = boardMapper.selectAllNoticesCount();
		
		PageUtils pageUtils = new PageUtils();
		pageUtils.setPageEntity(totalRecord, page);
		
		Map<String, Object> map = new HashMap<>();
		map.put("beginRecord", pageUtils.getBeginRecord());
		map.put("endRecord", pageUtils.getEndRecord());
		
		List<NoticeDTO> notices = boardMapper.selectNotices(map);
		
		model.addAttribute("notices", notices);
		model.addAttribute("beginNo", totalRecord - pageUtils.getRecordPerPage() * (page - 1));
		model.addAttribute("paging", pageUtils.getPaging(request.getContextPath() + "/board/noticeList"));
	}
	
	@Override
	public void findNotices(HttpServletRequest request, Model model) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		String column = request.getParameter("column");
		String query = request.getParameter("query");
		String begin = request.getParameter("begin");
		String end = request.getParameter("end");
		
		Map<String, Object> map = new HashMap<>();
		map.put("column", column);
		map.put("query", query);
		map.put("begin", begin);
		map.put("end", end);
		
		int findRecord = boardMapper.selectNoticesCount(map);
		
		PageUtils pageUtils = new PageUtils();
		pageUtils.setPageEntity(findRecord, page);
		
		map.put("beginRecord", pageUtils.getBeginRecord());
		map.put("endRecord", pageUtils.getEndRecord());
		
		List<NoticeDTO> notices = boardMapper.selectNoticeList(map);
		
		model.addAttribute("notices", notices);
		model.addAttribute("beginNo", findRecord - pageUtils.getRecordPerPage() * (page - 1));
		
		switch(column) {
		case "NOTICE_TITLE":
		case "NOTICE_CONTENT":
			model.addAttribute("paging", pageUtils.getPaging(request.getContextPath() + "/board/noticeSearch?column=" + column + "&query=" + query));
			break;
		case "NOTICE_CREATED":
			model.addAttribute("paging", pageUtils.getPaging(request.getContextPath() + "/board/noticeSearch?column=" + column + "&begin=" + begin + "&end=" + end));
			break;
		}
	}
	
	@Override
	public void getNoticeByNo(HttpServletRequest request, Model model) {

		Long noticeNo = Long.parseLong(request.getParameter("noticeNo"));
		
		// ????????? ??????
		String referer = request.getHeader("referer");
		HttpSession session = request.getSession(); 
		if(referer.endsWith("List") && session.getAttribute("updateHit") == null) {
			boardMapper.updateNoticeHit(noticeNo);  
			session.setAttribute("updateHit", "done");  
		} else if(referer.endsWith("Search") && session.getAttribute("updateHit") == null) {
			boardMapper.updateNoticeHit(noticeNo);  
			session.setAttribute("updateHit", "done");  
		}
		
		model.addAttribute("notice", boardMapper.selectNoticeByNo(noticeNo));
		model.addAttribute("noticeFileAttaches", boardMapper.selectFileAttachListInTheNotice(noticeNo));
		
	}
	
	@Override
	public ResponseEntity<byte[]> noticeDisplay(Long noticeFileAttachNo, String type) {
		NoticeFileAttachDTO noticeFileAttach = boardMapper.selectNoticeFileAttachByNo(noticeFileAttachNo);
		
		File file = null;
		switch(type) {
		case "thumb":
			file = new File(noticeFileAttach.getNoticeFileAttachPath(), "s_" + noticeFileAttach.getNoticeFileAttachSaved());
			break;
		case "image":
			file = new File(noticeFileAttach.getNoticeFileAttachPath(), noticeFileAttach.getNoticeFileAttachSaved());
			break;
		}
		ResponseEntity<byte[]> entity = null;
		try {
			HttpHeaders headers = new HttpHeaders();
			headers.add("Content-Type", Files.probeContentType(file.toPath()));
			entity = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file), headers, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return entity;
	}
	
	@Override
	public ResponseEntity<byte[]> display(String path, String thumbnail) {

		File file = new File(path, thumbnail);
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders headers = new HttpHeaders();
			headers.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file), null, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@Override
	public ResponseEntity<Resource> noticeDownload(String userAgent, Long noticeFileAttachNo) {

		NoticeFileAttachDTO noticeFileAttach = boardMapper.selectNoticeFileAttachByNo(noticeFileAttachNo);
		
		File file = new File(noticeFileAttach.getNoticeFileAttachPath(), noticeFileAttach.getNoticeFileAttachSaved());
		
		Resource resource = new FileSystemResource(file);
		
		if(resource.exists() == false) { 
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		// ???????????? ??????
		HttpHeaders headers = new HttpHeaders();

		// ???????????? ?????? ?????????(?????????????????? ????????? ?????????.)
		String origin = noticeFileAttach.getNoticeFileAttachOrigin();
		try {
			// IE(userAgent??? Trident??? ??????)
			if(userAgent.contains("Trident")) {
				origin = URLEncoder.encode(origin, "UTF-8").replaceAll("\\+", " ");
			}
			// Edge(userAgent??? Edg??? ??????)
			else if(userAgent.contains("Edg")) {
				origin = URLEncoder.encode(origin, "UTF-8");
			}
			// ?????????
			else {
				origin = new String(origin.getBytes("UTF-8"), "ISO-8859-1");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		headers.add("Content-Disposition", "attachment; filename=" + origin);
		headers.add("Content-Length", file.length()+""); 
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	@Transactional
	@Override
	public Map<String, Object> addNotice(MultipartHttpServletRequest multipartRequest) {

		String title = multipartRequest.getParameter("title");
		String content = multipartRequest.getParameter("content");
		
		Optional<String> opt = Optional.ofNullable(multipartRequest.getHeader("X-Forwarded-For"));
		String ip = opt.orElse(multipartRequest.getRemoteAddr());
				
		NoticeDTO notice = NoticeDTO.builder()
				.noticeTitle(title)
				.noticeContent(content)
				.noticeIp(ip)
				.build();
		
		int noticeResult = boardMapper.insertNotice(notice);
		
		List<MultipartFile> files = multipartRequest.getFiles("files");
		
		List<String> thumbnails = new ArrayList<>();

		int noticeFileAttachResult;
		if(files.size() > 0) {
			if(files.get(0).getOriginalFilename().isEmpty()) {
				noticeFileAttachResult = 1; 
			} else { 
				noticeFileAttachResult = 0;
			}	
		} else {
			noticeFileAttachResult = 0;
		}
	
		String path = null;
		
		for(MultipartFile multipartFile : files) {
			try {
				if(multipartFile != null && multipartFile.isEmpty() == false) {
					
					String origin = multipartFile.getOriginalFilename();
					origin = origin.substring(origin.lastIndexOf("\\") + 1); // IE??? ?????? ????????? ?????? ????????? ????????? ???????????? ?????? ??????.
					
					String saved = MyFileUtils.getUuidName(origin);
					path = MyFileUtils.getTodayPath();
					
					File dir = new File(path);
					if(dir.exists() == false) {
						dir.mkdir();
					}
					
					File file = new File(dir, saved);
					
					String contentType = Files.probeContentType(file.toPath()); 
					if(contentType.startsWith("image")) {
						
						multipartFile.transferTo(file);
						
						Thumbnails.of(file)
							.size(100, 100)
							.toFile(new File(dir, "s_" + saved));
						
						thumbnails.add("s_" + saved);
						
						NoticeFileAttachDTO noticeFileAttach = NoticeFileAttachDTO.builder()
								.noticeFileAttachPath(path)
								.noticeFileAttachOrigin(origin)
								.noticeFileAttachSaved(saved)
								.noticeNo(notice.getNoticeNo())
								.build();
						noticeFileAttachResult += boardMapper.insertNoticeFileAttach(noticeFileAttach);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		Map<String, Object> map = new HashMap<>();
		map.put("noticeResult", noticeResult == 1);   
		map.put("noticeFileAttachResult", noticeFileAttachResult); // noticeFileAttachResult == files.size()
		map.put("thumbnails", thumbnails);
		map.put("path", path); 
		return map;
	}
	
	@Override
	public void removeNotice(HttpServletRequest request, HttpServletResponse response) {
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("noticeNo"));
		Long noticeNo = Long.parseLong(opt.orElse("0"));
		
		List<NoticeFileAttachDTO> noticeAttaches = boardMapper.selectFileAttachListInTheNotice(noticeNo);
		
		if(noticeAttaches != null && noticeAttaches.isEmpty() == false) {
			
			for(NoticeFileAttachDTO attach : noticeAttaches) {
				
				File file = new File(attach.getNoticeFileAttachPath(), attach.getNoticeFileAttachSaved());

				try {
					String contentType = Files.probeContentType(file.toPath());
					if(contentType.startsWith("image")) {
						if(file.exists()) {
							file.delete();
						}
						File thumbnail = new File(attach.getNoticeFileAttachPath(), "s_" + attach.getNoticeFileAttachSaved());
						if(thumbnail.exists()) {
							thumbnail.delete();
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		int res = boardMapper.deleteNotice(noticeNo);
		
		try {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			if(res == 1) {
				out.println("<script>");
				out.println("alert('??????????????? ?????????????????????.')");
				out.println("location.href='" + request.getContextPath() + "/board/noticeList'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('??????????????? ???????????? ???????????????.')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}		
	}
	
	@Transactional
	@Override
	public void noticeModify(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) {

		Long noticeNo = Long.parseLong(multipartRequest.getParameter("noticeNo"));
		String title = multipartRequest.getParameter("title");
		String content = multipartRequest.getParameter("content");
		
		NoticeDTO notice = NoticeDTO.builder()
				.noticeNo(noticeNo)
				.noticeTitle(title)
				.noticeContent(content)
				.build();
		
		int noticeResult = boardMapper.updateNotice(notice);
		
		List<MultipartFile> files = multipartRequest.getFiles("files"); 
		
		// ?????? ?????? ??????
		int noticeFileAttachResult;
		if(files.get(0).getOriginalFilename().isEmpty()) { 
			noticeFileAttachResult = 1;  
		} else {  
			noticeFileAttachResult = 0;
		}
		
		for(MultipartFile multipartFile : files) {
			try {
				if(multipartFile != null && multipartFile.isEmpty() == false) { 
					
					String origin = multipartFile.getOriginalFilename();
					origin = origin.substring(origin.lastIndexOf("\\") + 1); 
					String saved = MyFileUtils.getUuidName(origin);
					String path = MyFileUtils.getTodayPath();
					
					File dir = new File(path);
					if(dir.exists() == false) {
						dir.mkdir();
					}
					
					File file = new File(dir, saved);
					
					String contentType = Files.probeContentType(file.toPath());
					if(contentType.startsWith("image")) {
						
						multipartFile.transferTo(file);
						
						Thumbnails.of(file)
							.size(100, 100)
							.toFile(new File(dir, "s_" + saved));
						
						NoticeFileAttachDTO noticeFileAttach = NoticeFileAttachDTO.builder()
								.noticeFileAttachPath(path)
								.noticeFileAttachOrigin(origin)
								.noticeFileAttachSaved(saved)
								.noticeNo(noticeNo)
								.build();
						
						noticeFileAttachResult += boardMapper.insertNoticeFileAttach(noticeFileAttach);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		try {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			if(noticeResult == 1 && noticeFileAttachResult == files.size()) {
				out.println("<script>");
				out.println("alert('??????????????? ?????????????????????.')");
				out.println("location.href='" + multipartRequest.getContextPath() + "/board/noticeDetail?noticeNo=" + noticeNo + "'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('??????????????? ???????????? ???????????????.')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public Map<String, Object> removeNoticeFileAttach(Long noticeFileAttachNo) {
		NoticeFileAttachDTO noticeFileAttach = boardMapper.selectNoticeFileAttachByNo(noticeFileAttachNo);
		
		if(noticeFileAttach != null) {
			
			File file = new File(noticeFileAttach.getNoticeFileAttachPath(), noticeFileAttach.getNoticeFileAttachSaved());
			try {
				String contentType = Files.probeContentType(file.toPath());
				if(contentType.startsWith("image")) {
					if(file.exists()) {
						file.delete();
					}
					File thumbnail = new File(noticeFileAttach.getNoticeFileAttachPath(), "s_" + noticeFileAttach.getNoticeFileAttachSaved());
					if(thumbnail.exists()) {
						thumbnail.delete();
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		int res = boardMapper.deleteNoticeFileAttach(noticeFileAttachNo);
		
		Map<String, Object> map = new HashMap<>();
		map.put("res", res); 
		
		return map;
	}
	
	@Override
	public Map<String, Object> noticeAutoComplete(HttpServletRequest request) {
		String column = request.getParameter("column");
		String query = request.getParameter("query");
		
		Map<String, Object> map = new HashMap<>();
		map.put("column", column);
		map.put("query", query);
		
		List<NoticeDTO> list = boardMapper.noticeAutoComplete(map);
		
		Map<String, Object> result = new HashMap<>();
		if(list.size() == 0) {
			result.put("status", 400);
			result.put("list", null);
		} else {
			result.put("status", 200);
			result.put("list", list);
		}
		if(column.equals("NOTICE_TITLE")) {
			result.put("column", "noticeTitle");
		} 
		/*else if(column.equals("NOTICE_CONTENT")) {
			result.put("column", "noticeContent");
		} */
		return result;
	}
	
	
	
	/************************/
	/*** Question/Answer  ***/
	/************************/
	@Override
	public void getAllquestions(HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		if(session.getAttribute("updateHit") != null) {
			session.removeAttribute("updateHit");
		}
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		int totalRecord = boardMapper.selectAllQuestionsCount();
		
		PageUtils pageUtils = new PageUtils();
		pageUtils.setPageEntity(totalRecord, page);
		
		Map<String, Object> map = new HashMap<>();
		map.put("beginRecord", pageUtils.getBeginRecord());
		map.put("endRecord", pageUtils.getEndRecord());
		
		List<QuestionDTO> questions = boardMapper.selectQuestions(map);
		
		model.addAttribute("questions", questions);
		model.addAttribute("beginNo", totalRecord - pageUtils.getRecordPerPage() * (page - 1));
		model.addAttribute("paging", pageUtils.getPaging(request.getContextPath() + "/board/questionList"));
	}
	
	@Override
	public void findQuestions(HttpServletRequest request, Model model) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		String column = request.getParameter("column");
		String query = request.getParameter("query");
		String begin = request.getParameter("begin");
		String end = request.getParameter("end");
		
		Map<String, Object> map = new HashMap<>();
		map.put("column", column);
		map.put("query", query);
		map.put("begin", begin);
		map.put("end", end);
		
		int findRecord = boardMapper.selectQuestionsCount(map);
		
		PageUtils pageUtils = new PageUtils();
		pageUtils.setPageEntity(findRecord, page);
		
		map.put("beginRecord", pageUtils.getBeginRecord());
		map.put("endRecord", pageUtils.getEndRecord());
		
		List<QuestionDTO> questions = boardMapper.selectQuestionList(map);
		
		model.addAttribute("questions", questions);
		model.addAttribute("beginNo", findRecord - pageUtils.getRecordPerPage() * (page - 1));
		
		switch(column) {
		case "QUESTION_TITLE":
		case "MEMBER_ID":
		case "QUESTION_CONTENT":
			model.addAttribute("paging", pageUtils.getPaging(request.getContextPath() + "/board/questionSearch?column=" + column + "&query=" + query));
			break;
		case "QUESTION_CREATED":
			model.addAttribute("paging", pageUtils.getPaging(request.getContextPath() + "/board/questionSearch?column=" + column + "&begin=" + begin + "&end=" + end));
			break;
		}
	}
	
	@Override
	public Map<String, Object> questionAutoComplete(HttpServletRequest request) {
		String column = request.getParameter("column");
		String query = request.getParameter("query");
		
		Map<String, Object> map = new HashMap<>();
		map.put("column", column);
		map.put("query", query);
		
		List<QuestionDTO> list = boardMapper.questionAutoComplete(map);
		
		Map<String, Object> result = new HashMap<>();
		if(list.size() == 0) {
			result.put("status", 400);
			result.put("list", null);
		} else {
			result.put("status", 200);
			result.put("list", list);
		}
		if(column.equals("QUESTION_TITLE")) {
			result.put("column", "questionTitle");
		} 
		/*else if(column.equals("MEMBER_ID")) {
			result.put("column", "memberId");
		} else if(column.equals("QUESTION_CONTENT")) {
			result.put("column", "questionContent");
		}*/
		return result;
	}
	
	@Override
	public void getQuestionByNo(HttpServletRequest request, Model model) {
		
		Long questionNo = Long.parseLong(request.getParameter("questionNo"));
		
		// ????????? ??????
		String referer = request.getHeader("referer");
		HttpSession session = request.getSession(); 
		if(referer.endsWith("List") && session.getAttribute("updateHit") == null) {
			boardMapper.updateQuestionHit(questionNo);  
			session.setAttribute("updateHit", "done");  
		} else if(referer.endsWith("Search") && session.getAttribute("updateHit") == null) {
			boardMapper.updateQuestionHit(questionNo);  
			session.setAttribute("updateHit", "done");  
		}
		model.addAttribute("question", boardMapper.selectQuestionByNo(questionNo));
		model.addAttribute("answer", boardMapper.selectAnswerByNo(questionNo));
	}
	
	@Override
	public void addQuestion(HttpServletRequest request, HttpServletResponse response) {

		String writer = request.getParameter("writer");
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		
		QuestionDTO question = QuestionDTO.builder()
				.questionTitle(title)
				.memberId(writer)
				.questionContent(content)
				.questionIp(request.getRemoteAddr())
				.build();
		
		int res = boardMapper.insertQuestion(question);
		
		try {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			if(res == 1) {
				out.println("<script>");
				out.println("alert('????????? ?????????????????????.')");
				out.println("location.href='" + request.getContextPath() + "/board/questionList'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('?????? ?????? ??????')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public void removeQuestion(HttpServletRequest request, HttpServletResponse response) {
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("questionNo"));
		Long questionNo = Long.parseLong(opt.orElse("0"));
		
		int res = boardMapper.deleteQuestion(questionNo);
		
		try {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			if(res == 1) {
				out.println("<script>");
				out.println("alert('?????? ?????? ??????')");
				out.println("location.href='" + request.getContextPath() + "/board/questionList'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('?????? ?????? ??????')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public Map<String, Object> uploadSummernoteImage(MultipartHttpServletRequest multipartRequest) {
		
		// ???????????? ????????? ??????
		// summernote ????????? ????????? ??? ?????? ???????????? getFile
		MultipartFile multipartFile = multipartRequest.getFile("file"); 
		
		// ????????? ?????????
		String saved = MyFileUtils.getUuidName(multipartFile.getOriginalFilename());
		
		// ????????? ??????
		String path = "C:" + File.separator +"upload" + File.separator + "gymgoodee";
		
		// ????????? ????????? ?????????
		File dir = new File(path);
		if(dir.exists() == false) {
			dir.mkdirs();
		}
		
		// ????????? File ??????
		File file = new File(dir, saved);
		
		// File ?????? ??????
		try {
			multipartFile.transferTo(file);
		} catch (Exception e) {
			try {
				FileUtils.forceDelete(file);
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		
		// ????????? ????????? ????????? ??????
		Map<String, Object> map = new HashMap<>();
		map.put("src", multipartRequest.getContextPath() + "/getImage/" + saved);
		return map;
	}
	
	@Override
	public Map<String, Object> answerAdd(HttpServletRequest request) {
		Long questionNo = Long.parseLong(request.getParameter("questionNo"));
		if(boardMapper.selectAnswerByNo(questionNo) != null) {
			boardMapper.deleteAnswer(questionNo);
		}
		AnswerDTO answer = AnswerDTO.builder()
				.questionNo(questionNo)
				.answerContent(request.getParameter("answerContent"))
				.build();
		Map<String, Object> map = new HashMap<>();
		map.put("res", boardMapper.insertAnswer(answer));
		map.put("answerContent", boardMapper.selectAnswerByNo(questionNo));
		return map;
	}
	
	@Override
	public Map<String, Object> answerRemove(Long questionNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("res", boardMapper.deleteAnswer(questionNo));
		return map;
	}
	
	
	
	/****************/
	/**** review ****/
	/****************/
	@Override
	public void getAllReviews(HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		if(session.getAttribute("updateHit") != null) {
			session.removeAttribute("updateHit");
		}
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		int totalRecord = boardMapper.selectAllReviewsCount();
		
		PageUtils pageUtils = new PageUtils();
		pageUtils.setPageEntity(totalRecord, page);
		
		Map<String, Object> map = new HashMap<>();
		map.put("beginRecord", pageUtils.getBeginRecord());
		map.put("endRecord", pageUtils.getEndRecord());
		
		List<ReviewDTO> reviews = boardMapper.selectReviews(map);
		
		// ?????? ??????
		Date date = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String nowDate = dateFormat.format(date);
		
		model.addAttribute("reviews", reviews);
		model.addAttribute("now", nowDate);
		model.addAttribute("beginNo", totalRecord - pageUtils.getRecordPerPage() * (page - 1));
		model.addAttribute("paging", pageUtils.getPaging(request.getContextPath() + "/board/reviewList"));
	}
	
	@Override
	public void findReviews(HttpServletRequest request, Model model) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		String column = request.getParameter("column");
		String query = request.getParameter("query");
		String begin = request.getParameter("begin");
		String end = request.getParameter("end");
		
		Map<String, Object> map = new HashMap<>();
		map.put("column", column);
		map.put("query", query);
		map.put("begin", begin);
		map.put("end", end);
		
		int findRecord = boardMapper.selectReviewsCount(map);
		
		PageUtils pageUtils = new PageUtils();
		pageUtils.setPageEntity(findRecord, page);
		
		map.put("beginRecord", pageUtils.getBeginRecord());
		map.put("endRecord", pageUtils.getEndRecord());
		
		List<ReviewDTO> reviews = boardMapper.selectReviewList(map);
		
		// ?????? ??????
		Date date = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String nowDate = dateFormat.format(date);
		
		model.addAttribute("reviews", reviews);
		model.addAttribute("now", nowDate);
		model.addAttribute("beginNo", findRecord - pageUtils.getRecordPerPage() * (page - 1));
		
		switch(column) {
		case "REVIEW_TITLE":
		case "REVIEW_SUBJECT":
		case "MEMBER_ID":
		case "REVIEW_CONTENT":
			model.addAttribute("paging", pageUtils.getPaging(request.getContextPath() + "/board/reviewSearch?column=" + column + "&query=" + query));
			break;
		case "REVIEW_CREATED":
			model.addAttribute("paging", pageUtils.getPaging(request.getContextPath() + "/board/reviewSearch?column=" + column + "&begin=" + begin + "&end=" + end));
			break;
		}
	}
	
	@Override
	public Map<String, Object> reviewAutoComplete(HttpServletRequest request) {
		String column = request.getParameter("column");
		String query = request.getParameter("query");
		
		Map<String, Object> map = new HashMap<>();
		map.put("column", column);
		map.put("query", query);
		
		List<ReviewDTO> list = boardMapper.reviewAutoComplete(map);
		
		Map<String, Object> result = new HashMap<>();
		if(list.size() == 0) {
			result.put("status", 400);
			result.put("list", null);
		} else {
			result.put("status", 200);
			result.put("list", list);
		}
		if(column.equals("REVIEW_TITLE")) {
			result.put("column", "reviewTitle");
		} else if(column.equals("REVIEW_SUBJECT")) {
			result.put("column", "reviewSubject");
		} 
		/*else if(column.equals("MEMBER_ID")) {
			result.put("column", "memberId");
		} else if(column.equals("REVIEW_CONTENT")) {
			result.put("column", "reviewContent");
		}*/
		return result;
	}
	
	@Override
	public void getReviewByNo(HttpServletRequest request, Model model) {
		
		Long reviewNo = Long.parseLong(request.getParameter("reviewNo"));
		
		// ????????? ??????
		String referer = request.getHeader("referer");
		HttpSession session = request.getSession(); 
		if(referer.endsWith("wList") && session.getAttribute("updateHit") == null) {
			boardMapper.updateReviewHit(reviewNo);  
			session.setAttribute("updateHit", "done");  
		} else if(referer.endsWith("wSearch") && session.getAttribute("updateHit") == null) {
			boardMapper.updateReviewHit(reviewNo);  
			session.setAttribute("updateHit", "done");  
		}
		model.addAttribute("review", boardMapper.selectReviewByNo(reviewNo));
	}
	
	@Override
	public void getTookClassCode(HttpServletRequest request, Model model) {

		MemberDTO member = (MemberDTO)request.getSession().getAttribute("loginMember");
		String memberId = member.getMemberId();
		
		List<ClassDTO> classCodes = boardMapper.selectTookClassCode(memberId);  //memberId
		
		model.addAttribute("classCodes", classCodes);
	}
	
	@Override
	public void addReview(HttpServletRequest request, HttpServletResponse response) {

		String writer = request.getParameter("writer");
		String classCode = request.getParameter("class");
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		String subject = "";
		if(classCode.substring(11, 13).equals("SW")) {
			subject += "SWIM";
		} else if(classCode.substring(11, 13).equals("DA")) {
			subject += "DANCE";
		} else if(classCode.substring(11, 13).equals("PI")) {
			subject += "PILATES";
		} else {
			subject += "SPINNING";
		}

		ReviewDTO review = ReviewDTO.builder()
				.classCode(classCode)
				.reviewSubject(subject)
				.memberId(writer)
				.reviewTitle(title)
				.reviewContent(content)
				.reviewIp(request.getRemoteAddr())
				.build();
		
		int res = boardMapper.insertReview(review);
		
		try {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			if(res == 1) {
				out.println("<script>");
				out.println("alert('?????? ?????? ??????')");
				out.println("location.href='" + request.getContextPath() + "/board/reviewList'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('?????? ?????? ??????')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public void removeReview(HttpServletRequest request, HttpServletResponse response) {
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("reviewNo"));
		Long reviewNo = Long.parseLong(opt.orElse("0"));
		
		int res = boardMapper.deleteReview(reviewNo);
		
		try {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			if(res > 0) {
				out.println("<script>");
				out.println("alert('?????? ?????? ??????')");
				out.println("location.href='" + request.getContextPath() + "/board/reviewList'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('?????? ?????? ??????')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public Map<String, Object> getAllReplies(HttpServletRequest request, Model model) {
		Optional<String> optReviewNo = Optional.ofNullable(request.getParameter("reviewNo"));
		Long reviewNo = Long.parseLong(optReviewNo.orElse("0"));
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		int totalRecord = boardMapper.selectRepliesCount(reviewNo); // ?????? ???????????? ???????????? ????????? ?????? ???
		
		PageUtils pageUtils = new PageUtils();
		pageUtils.setPageEntity(totalRecord, page);
		
		Map<String, Object> map = new HashMap<>();
		map.put("reviewNo", reviewNo);
		map.put("beginRecord", pageUtils.getBeginRecord());
		map.put("endRecord", pageUtils.getEndRecord());
		
		Map<String, Object> map2 = new HashMap<>();
		map2.put("replies", boardMapper.selectReplies(map)); // ?????? ???????????? ???????????? ????????? ????????? ????????? ???
		map2.put("replyCount", totalRecord);
		map2.put("p", pageUtils);
		return map2;
	}
	
	@Transactional
	@Override
	public Map<String, Object> saveReply(HttpServletRequest request) {
		
		String writer = request.getParameter("writer");
		String content = request.getParameter("content");
		int depth = Integer.parseInt(request.getParameter("depth"));
		Long groupNo = Long.parseLong(request.getParameter("groupNo"));
		int groupOrd = Integer.parseInt(request.getParameter("groupOrd"));
		Optional<String> opt = Optional.ofNullable(request.getHeader("X-Forwarded-For"));
		String ip = opt.orElse(request.getRemoteAddr());
		
		ReviewDTO review = ReviewDTO.builder()
				.reviewGroupNo(groupNo)
				.reviewGroupOrd(groupOrd)
				.build();
		boardMapper.updatePreviousReply(review);
		
		ReviewDTO reply = ReviewDTO.builder()
				.memberId(writer)
				.reviewContent(content)
				.reviewDepth(depth + 1)
				.reviewGroupNo(groupNo)
				.reviewGroupOrd(groupOrd + 1)
				.reviewIp(ip)
				.build();
		
		Map<String, Object> map = new HashMap<>();
		map.put("res", boardMapper.insertReply(reply));
		return map;
	}
	
	@Override
	public Map<String, Object> removeReply(Long reviewNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("res", boardMapper.deleteReply(reviewNo));
		return map;
	}
	
	
}
