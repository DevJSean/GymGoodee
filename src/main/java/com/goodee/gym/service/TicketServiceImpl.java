package com.goodee.gym.service;

import java.io.PrintWriter;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.domain.PayListDTO;
import com.goodee.gym.domain.RemainTicketDTO;
import com.goodee.gym.mapper.TicketMapper;

@Service
public class TicketServiceImpl implements TicketService {

	@Autowired
	private TicketMapper ticketMapper;
	
	@Override
	public void findTicketByNo(HttpServletRequest request, HttpServletResponse response, Model model) {
	
		try {
			if(request.getSession().getAttribute("loginMember") == null) {
				response.setContentType("text/html");
				PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('로그인 후 구매해주세요.')");
				out.println("location.href='" + request.getContextPath() + "/lsh'");
				out.println("</script>");
				out.close();
				return;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("ticketNo"));
		Long ticketNo = Long.parseLong(opt.orElse("0"));
		
		model.addAttribute("ticket", ticketMapper.selectTicketByNo(ticketNo));		

	}
	
	@Override
	public void orderConfirm(HttpServletRequest request, Model model) {
		model.addAttribute("ticketNo", request.getParameter("ticketNo")); 				// 수강권 번호
		model.addAttribute("pay_type", request.getParameter("pay_type")); 				// 결제수단 (transfer|card)
		model.addAttribute("pay_work", request.getParameter("pay_work")); 				// 결제요청 방식 (AUTH | PAY | CERT)
		model.addAttribute("memberId", request.getParameter("memberId")); 				// 결제자 고유 ID (빌링키)
		model.addAttribute("memberNo", request.getParameter("memberNo")); 				// 파트너 회원 고유번호
		model.addAttribute("memberName", request.getParameter("memberName")); 			// 결제자 이름
		model.addAttribute("memberPhone", request.getParameter("memberPhone")); 		// 결제자 휴대전화번호
		model.addAttribute("memberEmail", request.getParameter("memberEmail")); 		// 결제자 이메일
		model.addAttribute("ticketName", request.getParameter("ticketName")); 			// 상품명
		model.addAttribute("ticketPrice", request.getParameter("ticketPrice")); 		// 결제요청금액
		model.addAttribute("card_ver", request.getParameter("card_ver")); 				// 카드 세부 결제방식
		model.addAttribute("ticketSubject", request.getParameter("ticketSubject")); 	// 종목
		model.addAttribute("ticketCount", request.getParameter("ticketCount")); 		// 횟수
		model.addAttribute("ticketPeriod", request.getParameter("ticketPeriod")); 		// 기간
		System.out.println(request.getParameter("ticketName"));
		
	}
	
	
	
	@Transactional
	@Override
	public void orderResult(HttpServletRequest request, Model model) throws Exception{


	if (request.getParameter("PCD_PAY_TIME") == null) {
		return;
	}
	model.addAttribute("ticketNo", request.getParameter("ticketNo")); 			     		// 수강권 번호
	model.addAttribute("pay_rst", request.getParameter("PCD_PAY_RST")); 					// 결제요청 결과 (success | error)
	model.addAttribute("pay_code", request.getParameter("PCD_PAY_CODE")); 					// 결제요청 결과 코드
	model.addAttribute("pay_msg", request.getParameter("PCD_PAY_MSG")); 					// 결제요청 결과 메세지
	model.addAttribute("pay_type", request.getParameter("PCD_PAY_TYPE")); 					// 결제수단 (transfer|card)
	model.addAttribute("card_ver", request.getParameter("PCD_CARD_VER")); 					// 카드 세부 결제방식
	model.addAttribute("pay_work", request.getParameter("PCD_PAY_WORK")); 					// 결제요청 방식 (AUTH | PAY | CERT)
	model.addAttribute("auth_key", request.getParameter("PCD_AUTH_KEY")); 					// 결제요청 파트너 인증 토큰 값
	model.addAttribute("pay_reqkey", request.getParameter("PCD_PAY_REQKEY")); 				// (CERT방식) 최종 결제요청 승인키
	model.addAttribute("pay_cofurl", request.getParameter("PCD_PAY_COFURL")); 				// (CERT방식) 최종 결제요청 URL

	model.addAttribute("memberNo", request.getParameter("PCD_PAYER_NO")); 					// 결제자 고유번호 (파트너사 회원 회원번호)
	model.addAttribute("memberName", request.getParameter("PCD_PAYER_NAME")); 				// 결제자 이름
	model.addAttribute("memberPhone", request.getParameter("PCD_PAYER_HP")); 					// 결제자 휴대전화번호
	model.addAttribute("memberEmail", request.getParameter("PCD_PAYER_EMAIL")); 			// 결제자 이메일 (출금결과 수신)
	model.addAttribute("ticketName", request.getParameter("PCD_PAY_GOODS")); 				// 상품명
	model.addAttribute("ticketPrice", request.getParameter("PCD_PAY_TOTAL")); 				// 결제요청금액

	model.addAttribute("payDate", request.getParameter("PCD_PAY_TIME"));
	model.addAttribute("pay_cardreceipt", request.getParameter("PCD_PAY_CARDRECEIPT")); 	// 카드 매출전표 URL
	
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	
	String payListDate = request.getParameter("PCD_PAY_TIME").substring(0, 8);
	Date date = new Date(sdf.parse(payListDate).getTime());
	Long ticketNo = Long.parseLong(request.getParameter("ticketNo"));
	Long memberNo = Long.parseLong(request.getParameter("PCD_PAYER_NO"));

	PayListDTO payList = PayListDTO.builder()
			.ticketNo(ticketNo)
			.memberNo(memberNo)
			.payListDate(date)
			.build();
	
	ticketMapper.insertPayList(payList);
		
		HttpSession session = request.getSession();
		MemberDTO member = (MemberDTO)session.getAttribute("loginMember");
		String memberId = member.getMemberId();
		
		String remainTicketSubject = request.getParameter("ticketSubject");
		Integer ticketPeriod = Integer.parseInt(request.getParameter("ticketPeriod"));
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.DATE, ticketPeriod);
		Date remainTicketEndDate = new Date(sdf.parse(sdf.format(cal.getTime())).getTime());
		
		Integer remainTicketRemainCount = Integer.parseInt(request.getParameter("ticketCount"));
		
		RemainTicketDTO remainTicket = RemainTicketDTO.builder()
				.memberId(memberId)
				.remainTicketSubject(remainTicketSubject)
				.remainTicketEndDate(remainTicketEndDate)
				.remainTicketRemainCount(remainTicketRemainCount)
				.build();
		
		ticketMapper.insertRemainTicket(remainTicket);
		
	}
	

}





































