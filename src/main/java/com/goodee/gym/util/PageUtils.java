package com.goodee.gym.util;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PageUtils {

	/************************************************************************************  
		- 전체 11개 레코드
		- 레코드를 한 페이지에 3개씩 표시한다면
		- 전체 페이지는 4개가 된다.   */
	private int totalRecord;       // 전체 레코드 수          -> DB에서 구해온다.		SELECT COUNT(*) FROM EMPLOYEES;
	private int recordPerPage = 5; // 한 페이지 당 5개 레코드 -> 여기서 임의로 정한다.
	private int totalPage;         // 전체 페이지 개수        -> totalRecord와 recordPerPage로 계산한다.
	
	
	/************************************************************************************   
		- 전체 11개 레코드
		- 레코드를 한 페이지에 3개씩 표시한다면
		- 각 페이지에 표시되는 레코드의 번호는 다음과 같다.
		page = 1, beginRecord = 1, endRecord = 3
		page = 2, beginRecord = 4, endRecord = 6
		page = 3, beginRecord = 7, endRecord = 9
		page = 4, beginRecord = 10, endRecord = 11 (endRecord가 12가 아님을 주의)  */
	private int page;        		// 파라미터로 받아 온다.
	private int beginRecord;	    // page와 recordPerPage로 계산한다.
	private int endRecord;  		// beginRecord와 recordPerPage와 totalPage로 계산한다.
	
	/************************************************************************************   
		- 전체 12개 페이지를
		- 한 블록에 5개씩 표시한다면
		- 각 블록에 표시되는 페이지의 번호는 다음과 같다.
		block = 1,  1  2  3  4  5  , page = 1 ~ 5   , beginPage = 1  , endPage = 5
		block = 2,  6  7  8  9  10 , page = 6 ~ 10  , beginPage = 6  , endPage = 10
		block = 3,  11 12          , page = 11 ~ 15 , beginPage = 11 , endPage = 12 (endPage = 15가 아님을 주의)    */
	private int pagePerBlock = 5; // 한 블록에 몇 페이지 표시할지 -> 여기서 임의로 정한다.
	private int beginPage;        // page와 pagePerBlock으로 계산한다.
	private int endPage;          // beginPage, pagePerBlock, totalPage로 계산한다.
	
	
	// totalRecord : DB에서 가져온다.
	// page : 파라미터로 가져온다.
	public void setPageEntity(int totalRecord, int page) {
		
		// totalRecord, page 필드 값 저장
		this.totalRecord = totalRecord;
		this.page = page;
		
		
		// totalPage 필드 값 계산
		totalPage = totalRecord / recordPerPage;
		
		if(totalRecord % recordPerPage != 0) { 
			totalPage++;
		} else if(totalRecord == 0) {
			totalPage = 1;
		}

		// beginRecord, endRecord 필드 값 계산
		beginRecord = (page - 1) * recordPerPage + 1;
		endRecord = beginRecord + recordPerPage - 1;
		if(endRecord > totalRecord) { 
			endRecord = totalRecord;
		}
		
		// beginPage, endPage 필드 값 계산
		beginPage = ((page - 1) / pagePerBlock) * pagePerBlock + 1;
		endPage = beginPage + pagePerBlock - 1;
		if(endPage > totalPage) { 
			endPage = totalPage;
		}
		
	}
		
	// ◀◀  ◀  1  2  3  4  5  ▶  ▶▶
	public String getPaging(String path) {
		
		StringBuilder sb = new StringBuilder();
		
		String concat = path.contains("?") ? "&" : "?";
		path += concat;
		
		// 이전 블록으로 이동, 1블록은 <a> 태그가 없다.
		if(page <= pagePerBlock) {
			sb.append("<span class=\"unlink\"><i class=\"fa-solid fa-caret-left\"></i><i class=\"fa-solid fa-caret-left\"></i></span>");
		} else {
			sb.append("<a class=\"link\" href=\"" + path + "page=" + (beginPage - 1) + "\"><i class=\"fa-solid fa-caret-left\"></i><i class=\"fa-solid fa-caret-left\"></i></a>");
		}
		
		// 이전 페이지 (◀), 1페이지는 <a> 태그가 없다.
		if(page == 1) {
			sb.append("<span class=\"unlink\"><i class=\"fa-solid fa-caret-left\"></i></span>");
		} else {
			sb.append("<a class=\"link\" href=\"" + path + "page=" + (page - 1) + "\"><i class=\"fa-solid fa-caret-left\"></i></a>");
		}
		
		// 페이지 번호 (1 2 3 4 5), 현재 페이지는 <a> 태그가 없다.
		for(int p = beginPage; p <= endPage; p++) {
			if(p == page) {
				sb.append("<span class=\"unlink\">" + p + "</span>");
			} else {
				sb.append("<a class=\"link\" href=\"" + path + "page=" + p + "\">" + p + "</a>");
			}
		}
		
		// 다음 페이지 (▶), 마지막 페이지는 <a> 태그가 없다.
		if(page == totalPage) {
			sb.append("<span class=\"unlink\"><i class=\"fa-solid fa-caret-right\"></i></span>");
		} else {
			sb.append("<a class=\"link\" href=\"" + path + "page=" + (page + 1) + "\"><i class=\"fa-solid fa-caret-right\"></i></a>");
		}
		
		// 다음 블록으로 이동, 마지막 블록에는 <a> 태그가 없다.
		if(endPage == totalPage) {
			sb.append("<span class=\"unlink\"><i class=\"fa-solid fa-caret-right\"></i><i class=\"fa-solid fa-caret-right\"></i></span>");
		} else {
			sb.append("<a class=\"link\" href=\"" + path + "page=" + (endPage + 1) + "\"><i class=\"fa-solid fa-caret-right\"></i><i class=\"fa-solid fa-caret-right\"></i></a>");
		}
		
		return sb.toString();
		
	}

}
