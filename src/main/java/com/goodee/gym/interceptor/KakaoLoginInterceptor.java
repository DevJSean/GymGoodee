package com.goodee.gym.interceptor;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;


public class KakaoLoginInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		return true;
		
		
	}
	
	// @PostMapping("/member/kakaoCallback") 요청 이후에 처리
	// 로그인 정보 세션에 올리기
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		
		try {
	    	response.setContentType("text/html");
	    	PrintWriter out = response.getWriter();
	    		out.println("<script>");
	    		out.println("alert('마이페이지에서 휴대폰번호를 수정해주세요.')");
				out.println("location.href='" + request.getContextPath() + "/lsh'");
	    		out.println("</script>");
	    		out.close();
	    	  
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
		
	}
	
	
}
