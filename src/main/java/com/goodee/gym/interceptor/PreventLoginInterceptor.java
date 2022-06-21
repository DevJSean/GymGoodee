package com.goodee.gym.interceptor;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;

public class PreventLoginInterceptor implements HandlerInterceptor {

	// 로그인을 했는데, 다시 로그인 또는 회원가입을 수행하려고 할 때 못하게 하기
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		// session에 올라와 있는 loginMember로 확인
		if(request.getSession().getAttribute("loginMember") != null) {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('해당 기능은 사용할 수 없습니다.')");
			out.println("location.href='" + request.getContextPath() + "'");
			out.println("</script>");
			out.close();
			return false;
		}
		return true;
	}
	
}
