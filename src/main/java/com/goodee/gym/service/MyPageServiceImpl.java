package com.goodee.gym.service;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.domain.PayListDTO;
import com.goodee.gym.domain.TicketDTO;
import com.goodee.gym.mapper.MyPageMapper;
import com.goodee.gym.util.PageUtils;
import com.goodee.gym.util.SecurityUtils;

@Service
public class MyPageServiceImpl implements MyPageService {

	@Autowired
	private MyPageMapper myPageMapper;
	
	// 잔여수강권 조회
	@Override
	public Map<String, Object> getRemainTicketsById(HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		MemberDTO loginMember = (MemberDTO)session.getAttribute("loginMember");
		String memberId = loginMember.getMemberId();
		Map<String, Object> map = new HashMap<>();
		
		model.addAttribute("remainTickets", myPageMapper.selectTicketsById(memberId));
		map.put("remainTickets", myPageMapper.selectTicketsById(memberId));
		return map;
	}

	// 다가올 수업 내역 조회
	@Override
	public Map<String, Object> getCommingReservationsByNo(HttpServletRequest request) {

		// 파라미터
		HttpSession session = request.getSession();
		MemberDTO loginMember = (MemberDTO)session.getAttribute("loginMember");
		Long memberNo = loginMember.getMemberNo();
		String subject = request.getParameter("subject");
		
		// 전달할 Map
		Map<String, Object> map = new HashMap<>();
		map.put("memberNo", memberNo);
		map.put("subject", subject);
		
		// 반환할 Map
		Map<String, Object> resMap = new HashMap<>();
		resMap.put("commingTotalCount", myPageMapper.selectCommingCount(map));				// 다가올 수업 수
		resMap.put("commingReservations", myPageMapper.selectCommingReservationsByNo(map)); // 다가올 수업 내역
		return resMap;
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
	public Map<String, Object> getOverReservationsByNo(HttpServletRequest request, int page) {
		
		HttpSession session = request.getSession();
		MemberDTO loginMember = (MemberDTO)session.getAttribute("loginMember");
		Long memberNo = loginMember.getMemberNo();
		String subject = request.getParameter("subject");
		
		// 전달할 Map
		Map<String, Object> m = new HashMap<>();
		m.put("memberNo", memberNo);
		m.put("subject", subject);
		
		// page와 overTotalCount를 이용해서 페이징 정보를 구한다.
		int overTotalCount = myPageMapper.selectOverCount(m);
		PageUtils pageUtils = new PageUtils();
		pageUtils.setPageEntity(overTotalCount, page);
		
		// 목록은 beginRecord~endRecord 사이값을 가져온다.
		m.put("beginRecord", pageUtils.getBeginRecord());
		m.put("endRecord", pageUtils.getEndRecord());
		
		// 반환할 Map
		Map<String, Object> map = new HashMap<>();
		map.put("overTotalCount", overTotalCount);
		map.put("overReservations", myPageMapper.selectOverReservationsByNo(m));
		map.put("p", pageUtils);
		return map;
	}
	
	// 결제 내역 조회
	@Override
	public void getMyPayListByNo(HttpServletRequest request, Model model) {
		
		HttpSession session = request.getSession();
		MemberDTO loginMember = (MemberDTO)session.getAttribute("loginMember");
		Long memberNo = loginMember.getMemberNo();
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));

		// 전달할 Map
		Map<String, Object> map = new HashMap<>();
		map.put("memberNo", memberNo);
		
		int totalPayListCount = myPageMapper.getPayListCount(map);
		PageUtils pageUtils = new PageUtils();
		pageUtils.setPageEntity(totalPayListCount, page);
		
		// 목록은 beginRecord~endRecord 사이값을 가져온다.
		map.put("beginRecord", pageUtils.getBeginRecord());
		map.put("endRecord", pageUtils.getEndRecord());
		
		model.addAttribute("totalPayListCount", totalPayListCount);
		model.addAttribute("payList", myPageMapper.selectPayList(map));
		model.addAttribute("paging", pageUtils.getPaging(request.getContextPath() + "/mypage/myPayList"));
	}
	
	// 동일 종목 추가 결제시
	@Override
	public void changeTicketInfo(HttpServletRequest request) {
		
		Optional<String> optNo = Optional.ofNullable(request.getParameter("PCD_PAYER_NO"));
		Long memberNo = Long.parseLong(optNo.orElse("0"));
		
		List<PayListDTO> payList = myPageMapper.selectValidPayList(memberNo);
		if(payList.size() > 1) {
			int i = 0;
			for(int j = 1, size = payList.size(); j < size; j++) {
				if(payList.get(i).getTicket().getTicketSubject().equals(payList.get(j).getTicket().getTicketSubject())) {
					Integer ticketPeriod = payList.get(i).getTicket().getTicketPeriod();
					Integer ticketCount = payList.get(i).getTicket().getTicketCount();
					String ticketSubject = payList.get(i).getTicket().getTicketSubject();
	
					TicketDTO ticket = TicketDTO.builder()
							.memberNo(memberNo)
							.ticketPeriod(ticketPeriod)
							.ticketCount(ticketCount)
							.ticketSubject(ticketSubject)
							.build();
					
					myPageMapper.updateTicket(ticket);
					return;
				} 
			}
		}
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
	
	// 회원탈퇴
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
	
	// 비밀번호 변경일
	@Override
	public Map<String, Object> getPwModified(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberDTO loginMember = (MemberDTO)session.getAttribute("loginMember");
		
		Map<String, Object> map = new HashMap<>();
		map.put("postDays", myPageMapper.selectPwModified(loginMember.getMemberId()));
		return map;
	}
}
