package com.goodee.gym.service;

import java.text.SimpleDateFormat;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.goodee.gym.domain.PayListDTO;
import com.goodee.gym.mapper.TicketMapper;

@Service
public class TicketServiceImpl implements TicketService {

	@Autowired
	private TicketMapper ticketMapper;
	
	@Override
	public void findTicketByNo(HttpServletRequest request, Model model) {
	
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
		model.addAttribute("simple_flag", request.getParameter("simple_flag")); 		// 간편결제 여부 (Y|N)
		model.addAttribute("card_ver", request.getParameter("card_ver")); 				// 카드 세부 결제방식
		
	}
	
	
	
	
	
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
		java.sql.Date date = new java.sql.Date(sdf.parse(payListDate).getTime());
		System.out.println(date);
			
		Long ticketNo = Long.parseLong(request.getParameter("ticketNo"));
//			
//			DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
//			LocalDate date = LocalDate.parse(payListDate, dateTimeFormatter);
		
		Long memberNo = Long.parseLong(request.getParameter("PCD_PAYER_NO"));

		PayListDTO payList = PayListDTO.builder()
				.ticketNo(ticketNo)
				.memberNo(memberNo)
				.payListDate(date)
				.build();
		
		ticketMapper.insertPayList(payList);
			
	}
	

	
	@Override
	public void updatePayList(HttpServletRequest request, HttpServletResponse response) {
		

		
		
	}
	
	
	
}





































