package com.goodee.gym.interceptor;

import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;


public class LoginInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		// 반환타입이 true 이면   @PostMapping("/member/login") 요청을 수행한다.
		// 반환타입이 false 이면  @PostMapping("/member/login") 요청을 수행하지 않기 때문에 작업을 직접 해줘야 한다.
		
		// 로그인 된 정보가 있다면 기존 로그인 정보를 제거
		HttpSession session = request.getSession();
		if(session.getAttribute("loginMember") != null) {
			session.removeAttribute("loginMember");
			return false;
		}
		return true;
		
		
	}
	
	// @PostMapping("/member/login") 요청 이후에 처리
	// 로그인 정보 세션에 올리기
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		
		// ModelAndView를 Map으로 변환하고 loginMember를 추출
		Map<String, Object> map = modelAndView.getModel();
		Object loginMember = map.get("loginMember");
		Object url = map.get("url");
		
		// loginMember가 있다면 (로그인 성공) session에 저장
		if(loginMember != null) {
			
			// session에 loginMember 저장
			HttpSession session = request.getSession();
			session.setAttribute("loginMember", loginMember);
			session.setMaxInactiveInterval(60*60);
			
			
			// 로그인 이후 이동
			if(url.toString().isEmpty()) { // 로그인 이전 화면 정보가 없으면 contextPath  이동
				response.sendRedirect(request.getContextPath());
			} else { // 로그인 이전 화면 정보가 있으면 해당 화면으로 이동하기
				response.sendRedirect(url.toString());
			}
		}
		// loginMember가 없다면 (로그인 실패) 로그인 페이지로 돌려보내기
		else {
				try {
					response.setContentType("text/html");
					PrintWriter out = response.getWriter();
						out.println("<script>");
						out.println("alert('아이디 또는 비밀번호를 잘못 입력했습니다. 입력하신 내용을 다시 확인해주세요.')");
						out.println("location.href='" + request.getContextPath() + "/member/loginPage'");
						out.println("</script>");
						out.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		
	}
	
	
}
