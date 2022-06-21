package com.goodee.gym.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.goodee.gym.domain.NoticeDTO;
import com.goodee.gym.mapper.BoardMapper;
import com.goodee.gym.util.MyFileUtils;
import com.goodee.gym.util.PageUtils;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardMapper boardMapper;
	
	@Override
	public void getAllNotices(HttpServletRequest request, Model model) {
		
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
			result.put("column", "title");
		} else if(column.equals("NOTICE_CONTENT")) {
			result.put("column", "content");
		}
		
		return result;
	}
	
	
	
	
	
	
	
	@Override
	public Map<String, Object> uploadSummernoteImage(MultipartHttpServletRequest multipartRequest) {
		
		// 에디터에 첨부된 파일
		// summernote 이미지 첨부는 한 장만 가능해서 getFile
		MultipartFile multipartFile = multipartRequest.getFile("file"); 
		
		// 저장할 파일명
		String saved = MyFileUtils.getUuidName(multipartFile.getOriginalFilename());
		
		// 저장할 경로
		String path = "C:" + File.separator +"upload" + File.separator + "summernote";
		
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
				FileUtils.forceDelete(file); // 예외 발생하면 삭제
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		
		// 저장된 파일의 경로를 반환
		Map<String, Object> map = new HashMap<>();
		map.put("src", "/getImage/" + saved);    
		return map;
	}
}
