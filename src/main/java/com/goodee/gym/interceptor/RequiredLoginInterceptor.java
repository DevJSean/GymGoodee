package com.goodee.gym.interceptor;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;

public class RequiredLoginInterceptor implements HandlerInterceptor {

	// 게시글 작성은 로그인 사용자만 할 수 있으므로 미리 점검해야 한다.
	// 게시글 작성을 위해 로그인을 한 후, 원래 있던 자리로 돌아가야 한다.
	// 로그인 페이지로 넘어갈 때 원래 있던 페이지의 url을 파라미터로 적는다.
/*	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		if(request.getSession().getAttribute("loginMember") == null) {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("if(confirm('로그인이 필요한 기능입니다. 로그인 할까요?')){");
			out.println("location.href='" + request.getContextPath() + "/member/loginPage?url=" + request.getRequestURL() + "'");
			out.println("}else{");
			out.println("history.back()");
			out.println("}");
			out.println("</script>");
			out.close();
			return false;
		}
		
		return true;
	}
*/	
}
