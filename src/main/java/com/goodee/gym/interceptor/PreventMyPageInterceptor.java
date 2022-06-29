package com.goodee.gym.interceptor;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;

public class PreventMyPageInterceptor implements HandlerInterceptor {

	// 로그아웃되면 마이페이지에 접근할 수 없도록 막기
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		if(request.getSession().getAttribute("loginMember") == null) {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('로그인 후 이용해주세요.')");
			out.println("location.href='" + request.getContextPath() + "/member/login'");
			out.println("</script>");
			out.close();
			return false;
		} 
		return true;
	}
}
