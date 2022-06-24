package com.goodee.gym.service;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.mapper.MyPageMapper;
import com.goodee.gym.util.PageUtils;
import com.goodee.gym.util.SecurityUtils;

@Service
public class MyPageServiceImpl implements MyPageService {

	@Autowired
	private MyPageMapper myPageMapper;
	
	// 잔여수강권 조회
	@Override
	public Map<String, Object> getRemainTicketsById(String memberId) {
		Map<String, Object> map = new HashMap<>();
		map.put("remainTickets", myPageMapper.selectTicketsById(memberId));
		System.out.println(map);
		return map;
	}

	// 다가올 수업 내역 조회
	@Override
	public Map<String, Object> getCommingReservationsByNo(Long memberNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("commingTotalCount", myPageMapper.selectCommingCount(memberNo));
		map.put("commingReservations", myPageMapper.selectCommingReservationsByNo(memberNo));
		return map;
	}
	
	// 예약 취소
	@Override
	public Map<String, Object> reserveCancle(String reservationCode, String memberId, String remainTicketSubject) {
		Map<String, Object> map = new HashMap<>();
		// 예약내역 : 예약상태 -1로 업데이트
		map.put("resState", myPageMapper.updateReservation(reservationCode));
		// 잔여수강권 : 잔여횟수 +1 
		map.put("resRemain", myPageMapper.updateRemainTicket(memberId, remainTicketSubject));
		return map;
	}
	
	// 지난 수업 내역 조회
	@Override
	public void getOverReservationsByNo(HttpServletRequest request, Model model) {
		
		Optional<String> optNo = Optional.ofNullable(request.getParameter("memberNo"));
		Long memberNo = Long.parseLong(optNo.orElse("0"));
		
		Optional<String> optPage = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(optPage.orElse("1"));
		
		int overTotalCount = myPageMapper.selectOverCount(memberNo);
		
		PageUtils pageUtils = new PageUtils();
		pageUtils.setPageEntity(overTotalCount, page);
		
		Map<String, Object> map = new HashMap<>();
		map.put("beginRecord", pageUtils.getBeginRecord());
		map.put("endRecord", pageUtils.getEndRecord());
		map.put("memberNo", memberNo);
		
		model.addAttribute("overTotalCount", overTotalCount);
		model.addAttribute("paging", pageUtils.getPaging1(request.getContextPath() + "/mypage/myReserveList?memberNo=" + memberNo));
		model.addAttribute("overReservations", myPageMapper.selectOverReservationsByNo(map));
	}
	
	// 결제 내역 조회
	@Override
	public void getMyPayListByNo(Long memberNo, Model model) {
		model.addAttribute("payList", myPageMapper.selectPayList(memberNo));
	}
	
	// 비밀번호 변경
	@Override
	public void changePw(HttpServletRequest request, HttpServletResponse response) {
		int res = 0;
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("memberNo"));
		Long memberNo = Long.parseLong(opt.orElse("0"));
		String newPw = SecurityUtils.sha256(request.getParameter("newPw"));
		
		MemberDTO member = MemberDTO.builder()
				.memberNo(memberNo)
				.memberPw(newPw)
				.build();
		
		// 현재 비밀번호가 일치하는 지 확인
		String currentPw = SecurityUtils.sha256(request.getParameter("currentPw"));
		String memberPw = myPageMapper.selectMemberPwByNo(memberNo);
		
		response.setContentType("text/html");
		if(currentPw.equals(memberPw)) {
			res = myPageMapper.updatePw(member);
		} else {
			try {
				PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('비밀번호가 일치하지 않습니다.')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if(res > 0) {
			try {
				PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('비밀번호가 변경되었습니다.')");
				out.println("alert('다시 로그인하세요.')");
				out.println("location.href='" + request.getContextPath() + "'");
				out.println("</script>");
				out.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	// 개인정보 변경 (이메일, 연락처)
	@Override
	public void changeMyInfo(HttpServletRequest request, HttpServletResponse response) {
		int res = 0;
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("memberNo"));
		Long memberNo = Long.parseLong(opt.orElse("0"));
		String memberEmail = SecurityUtils.xss(request.getParameter("memberEmail"));
		String memberPhone = SecurityUtils.xss(request.getParameter("memberPhone"));
		
		MemberDTO member = MemberDTO.builder()
				.memberNo(memberNo)
				.memberEmail(memberEmail)
				.memberPhone(memberPhone)
				.build();
		
		res = myPageMapper.updateMyInfo(member);
		
		MemberDTO loginMember = myPageMapper.selectMemberById(memberNo);
		
		try {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			if(res > 0) {
				out.println("<script>");
				out.println("alert('개인정보가 변경되었습니다.')");
				out.println("location.href='" + request.getContextPath() + "/mypage/myInfo'");
				out.println("</script>");
				out.close();
				// 세션값 재설정
				HttpSession session = request.getSession();
			    session.setAttribute("loginMember", loginMember);
			} else {
				out.println("<script>");
				out.println("alert('개인정보 변경에 실패하였습니다.')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public void signOut(HttpServletRequest request, HttpServletResponse response) {
		int res = 0;
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("memberNo"));
		Long memberNo = Long.parseLong(opt.orElse("0"));
		
		// 탈퇴를 위해 입력한 비밀번호가 일치하는 지 확인
		String confirmPw = SecurityUtils.sha256(request.getParameter("confirmPw"));
		String memberPw = myPageMapper.selectMemberPwByNo(memberNo);
		
		response.setContentType("text/html");
		if(confirmPw.equals(memberPw)) {
			res = myPageMapper.deleteMember(memberNo);
		} else {
			try {
				PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('비밀번호가 일치하지 않습니다.')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		try {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			if(res == 1) {
				request.getSession().invalidate();  // session 초기화
				out.println("<script>");
				out.println("alert('탈퇴 되었습니다.')");
				out.println("location.href='" + request.getContextPath() + "'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('회원 탈퇴가 실패했습니다.')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
			
	}
}
