package com.goodee.gym.service;

import java.io.File;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.ArrayList;
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

import com.goodee.gym.domain.NoticeDTO;
import com.goodee.gym.domain.NoticeFileAttachDTO;
import com.goodee.gym.domain.QuestionDTO;
import com.goodee.gym.mapper.BoardMapper;
import com.goodee.gym.util.MyFileUtils;
import com.goodee.gym.util.PageUtils;

import net.coobird.thumbnailator.Thumbnails;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardMapper boardMapper;
	
	/*** 공지사항 ***/
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
		model.addAttribute("paging", pageUtils.getPaging2(request.getContextPath() + "/board/noticeList"));
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
			model.addAttribute("paging", pageUtils.getPaging2(request.getContextPath() + "/board/noticeSearch?column=" + column + "&query=" + query));
			break;
		case "NOTICE_CREATED":
			model.addAttribute("paging", pageUtils.getPaging2(request.getContextPath() + "/board/noticeSearch?column=" + column + "&begin=" + begin + "&end=" + end));
			break;
		}
	}
	
	@Override
	public void getNoticeByNo(HttpServletRequest request, Model model) {

		Long noticeNo = Long.parseLong(request.getParameter("noticeNo"));
		
		// 조회수 증가
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
		
		// 다운로드 헤더
		HttpHeaders headers = new HttpHeaders();

		// 다운로드 되는 파일명(브라우저마다 세팅이 다르다.)
		String origin = noticeFileAttach.getNoticeFileAttachOrigin();
		try {
			// IE(userAgent에 Trident가 포함)
			if(userAgent.contains("Trident")) {
				origin = URLEncoder.encode(origin, "UTF-8").replaceAll("\\+", " ");
			}
			// Edge(userAgent에 Edg가 포함)
			else if(userAgent.contains("Edg")) {
				origin = URLEncoder.encode(origin, "UTF-8");
			}
			// 나머지
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
		if(files.get(0).getOriginalFilename().isEmpty()) {
			noticeFileAttachResult = 1; 
		} else { 
			noticeFileAttachResult = 0;
		}		
		
		String path = null;
		
		for(MultipartFile multipartFile : files) {
			try {
				if(multipartFile != null && multipartFile.isEmpty() == false) {
					
					String origin = multipartFile.getOriginalFilename();
					origin = origin.substring(origin.lastIndexOf("\\") + 1); // IE는 본래 이름에 전체 경로가 붙어서 파일명만 떼야 한다.
					
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
		map.put("noticeFileAttachResult", noticeFileAttachResult == files.size());
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
				out.println("alert('공지사항이 삭제되었습니다.')");
				out.println("location.href='" + request.getContextPath() + "/board/noticeList'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('공지사항이 삭제되지 않았습니다.')");
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
		
		// 파일 첨부 결과
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
				out.println("alert('공지사항이 수정되었습니다.')");
				out.println("location.href='" + multipartRequest.getContextPath() + "/board/noticeDetail?noticeNo=" + noticeNo + "'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('공지사항이 수정되지 않았습니다.')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public void removeNoticeFileAttach(Long noticeFileAttachNo) {
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
		boardMapper.deleteNoticeFileAttach(noticeFileAttachNo);
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
		} else if(column.equals("NOTICE_CONTENT")) {
			result.put("column", "noticeContent");
		}
		return result;
	}
	
	/*** Question/Answer  ***/
	@Override
	public void getAllquestions(HttpServletRequest request, Model model) {
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
		model.addAttribute("paging", pageUtils.getPaging2(request.getContextPath() + "/board/questionList"));
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
			model.addAttribute("paging", pageUtils.getPaging2(request.getContextPath() + "/board/questionSearch?column=" + column + "&query=" + query));
			break;
		case "QUESTION_CREATED":
			model.addAttribute("paging", pageUtils.getPaging2(request.getContextPath() + "/board/questionSearch?column=" + column + "&begin=" + begin + "&end=" + end));
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
		} else if(column.equals("MEMBER_ID")) {
			result.put("column", "memberId");
		} else if(column.equals("QUESTION_CONTENT")) {
			result.put("column", "questionContent");
		}
		return result;
	}
	
	@Override
	public QuestionDTO getQuestionByNo(Long questionNo) {
		return boardMapper.selectQuestionByNo(questionNo);
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
				out.println("alert('질문 추가 성공')");
				out.println("location.href='" + request.getContextPath() + "/board/questionList'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('질문 추가 실패')");
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
				out.println("alert('질문 삭제 성공')");
				out.println("location.href='" + request.getContextPath() + "/board/questionList'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('질문 삭제 실패')");
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
		
		// 에디터에 첨부된 파일
		// summernote 이미지 첨부는 한 장만 가능해서 getFile
		MultipartFile multipartFile = multipartRequest.getFile("file"); 
		
		// 저장할 파일명
		String saved = MyFileUtils.getUuidName(multipartFile.getOriginalFilename());
		
		// 저장할 경로
		String path = "C:" + File.separator +"upload" + File.separator + "gymgoodee";
		
		// 경로가 없으면 만들기
		File dir = new File(path);
		if(dir.exists() == false) {
			dir.mkdirs();
		}
		
		// 저장할 File 객체
		File file = new File(dir, saved);
		
		// File 객체 저장
		try {
			multipartFile.transferTo(file);
		} catch (Exception e) {
			try {
				FileUtils.forceDelete(file);
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		
		// 저장된 파일의 경로를 반환
		Map<String, Object> map = new HashMap<>();
		map.put("src", "/getImage/" + saved);    //"/getImage/" + 
		return map;
	}
}
