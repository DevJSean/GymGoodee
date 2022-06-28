package com.goodee.gym.controller;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.goodee.gym.path.Payple;
import com.goodee.gym.service.MyPageService;
import com.goodee.gym.service.TicketService;

@Controller
public class OrderController extends Payple {

	@Autowired
	private TicketService ticketService;
	
	@Autowired
	private MyPageService myPageService;
	
	
	@GetMapping("/pay/paySwim")
	public String paySwim() {
		return "pay/paySwim";
	}
	@GetMapping("/pay/paySpinning")
	public String paySpinning() {
		return "pay/paySpinning";
	}
	@GetMapping("/pay/payPliates")
	public String payPliates() {
		return "pay/payPliates";
	}
	@GetMapping("/pay/payDance")
	public String payDance() {
		return "pay/payDance";
	}
	
	
	// order.jsp : 주문 페이지
	@GetMapping(value = "/order/order")
	public String order(HttpServletRequest request, Model model) {
		ticketService.findTicketByNo(request, model);
		return "order/order";
	}
	
	
	// order_confirm.jsp : 결제확인 페이지
	@PostMapping(value = "/order/orderConfirm")
	public String orderConfirm(HttpServletRequest request, Model model) {

		// 파트너 인증
		JSONObject obj = new JSONObject();
		obj = payAuth(null);

		// 파트너 인증 후 결제요청 시 필요한 필수 파라미터
		model.addAttribute("authKey", obj.get("AuthKey")); 		// 인증 키
		model.addAttribute("payReqURL", obj.get("return_url")); // 결제요청 URL
		
		ticketService.orderConfirm(request, model);
		
		return "/order/orderConfirm";
	}

	
	// order_result.jsp : 결제결과 확인 페이지
	@PostMapping(value = "/order/orderResult")
	public String orderResult(HttpServletRequest request, Model model) throws Exception {
		ticketService.orderResult(request, model);
		myPageService.changeTicketInfo(request);
		return "order/orderResult";
	}
	
	

}
