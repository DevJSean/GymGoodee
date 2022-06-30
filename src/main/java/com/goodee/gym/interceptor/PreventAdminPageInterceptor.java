package com.goodee.gym.interceptor;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;

import com.goodee.gym.domain.MemberDTO;

public class PreventAdminPageInterceptor implements HandlerInterceptor {

	// 로그아웃되면 마이페이지에 접근할 수 없도록 막기
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		MemberDTO loginMember = (MemberDTO) request.getSession().getAttribute("loginMember");
		
		if(loginMember == null) {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('로그인 후 이용해주세요.')");
			out.println("location.href='" + request.getContextPath() + "/member/loginPage'");
			out.println("</script>");
			out.close();
			return false;
		} else if (loginMember.getMemberId().equals("admin") == false) {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('잘못된 접근입니다.')");
			out.println("location.href='" + request.getContextPath() + "'");
			out.println("</script>");
			out.close();
			return false;
		}
		return true;
	}
}
