package com.goodee.gym.service;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.mapper.MemberMapper;
import com.goodee.gym.util.SecurityUtils;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	private MemberMapper memberMapper;
	
	@Override
	public Map<String, Object> idCheck(String memberId) {
		Map<String, Object> map = new HashMap<>();
		map.put("res", memberMapper.selectMemberById(memberId));
		return map;
	}
	
	@Override
	public Map<String, Object> emailCheck(String memberEmail) {
		Map<String, Object> map = new HashMap<>();
		map.put("res", memberMapper.selectMemberByEmail(memberEmail));
		return map;
	}
	
	@Override
	public Map<String, Object> sendAuthCode(String memberEmail) {
		
		// 인증코드
		String authCode = SecurityUtils.authCode(6);    // 6자리 인증코드
		System.out.println(authCode);
		
		// 필수 속성
		Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.gmail.com");  // 구글 메일로 보냅니다.
		props.put("mail.smtp.port", "587");             // 구글 메일 보내는 포트.
		props.put("mail.smtp.auth", "true");            // 인증되었다.
		props.put("mail.smtp.starttls.enable", "true"); // TLS 허용한다.
		
		// 메일을 보내는 사용자 정보
		final String USERNAME = "forspringlec@gmail.com";
		final String PASSWORD = "ukpiajijxfirdgcz";     // 발급 받은 앱 비밀번호
		
		// 사용자 정보를 javax.mail.Session에 저장
		Session session = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(USERNAME, PASSWORD);
			}
		});
		
		
		// 이메일 전송하기
		try {
			
			Message message = new MimeMessage(session);
			
			message.setHeader("Content-Type", "text/plain; charset=UTF-8");
			message.setFrom(new InternetAddress(USERNAME, "인증코드관리자"));
			message.setRecipient(Message.RecipientType.TO, new InternetAddress(memberEmail));
			message.setSubject("인증 요청 메일입니다.");
			message.setText("인증번호는 " + authCode + "입니다.");
			
			Transport.send(message);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("authCode", authCode);
		return map;
		
	}
	
	@Override
	public void signUp(HttpServletRequest request, HttpServletResponse response) {
		
		// 파라미터
		String memberId = SecurityUtils.xss(request.getParameter("memberId"));        // 크로스 사이트 스크립팅
		String memberPw = SecurityUtils.sha256(request.getParameter("memberPw"));     // SHA-256 암호화
		String memberName = SecurityUtils.xss(request.getParameter("memberName"));    // 크로스 사이트 스크립팅
		String memberBirth = SecurityUtils.xss(request.getParameter("memberBirth"));    // 크로스 사이트 스크립팅
		String memberGender = SecurityUtils.xss(request.getParameter("memberGender"));    // 크로스 사이트 스크립팅
		String memberPhone = SecurityUtils.xss(request.getParameter("memberPhone"));    // 크로스 사이트 스크립팅
		String memberEmail = SecurityUtils.xss(request.getParameter("memberEmail"));  // 크로스 사이트 스크립팅
		String location = request.getParameter("location");
		String promotion = request.getParameter("promotion");
		int memberAgreeState = 1;  // 필수 동의
		if(location.equals("location") && promotion.equals("promotion")) {
			memberAgreeState = 4;  // 필수 + 위치 + 프로모션 동의
		} else if(location.equals("location") && promotion.isEmpty()) {
			memberAgreeState = 2;  // 필수 + 위치 동의
		} else if(location.isEmpty() && promotion.equals("promotion")) {
			memberAgreeState = 3;  // 필수 + 프로모션 동의
		}
		
		// MemberDTO
		MemberDTO member = MemberDTO.builder()
				.memberId(memberId)
				.memberPw(memberPw)
				.memberName(memberName)
				.memberBirth(memberBirth)
				.memberGender(memberGender)
				.memberPhone(memberPhone)
				.memberEmail(memberEmail)
				.memberAgreeState(memberAgreeState)
				.build();
		
		// MEMBER 테이블에 member 저장
		int res = memberMapper.insertMember(member);
		
		// 응답
		try {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			if(res == 1) {
				out.println("<script>");
				out.println("alert('회원 가입되었습니다.')");
				out.println("location.href='" + request.getContextPath() + "'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('회원 가입에 실패했습니다.')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	@Override
	public MemberDTO login(HttpServletRequest request) {
		
		// 파라미터

		String memberId = SecurityUtils.xss(request.getParameter("memberId"));
		String memberPw = SecurityUtils.sha256(request.getParameter("memberPw"));
		
		// MemberDTO
		MemberDTO member = MemberDTO.builder()
				.memberId(memberId)
				.memberPw(memberPw)
				.build();
		
		// ID/Password가 일치하는 회원 조회
		MemberDTO loginMember = memberMapper.selectMemberByIdPw(member);
		
		// 로그인 기록 남기기
		if(loginMember != null) {
			memberMapper.insertMemberLog(loginMember.getMemberNo());
		}
		
		return loginMember;
		
	}
	
	
	/* 아이디 찾기 */
	@Override
	public Map<String, Object> findId(MemberDTO member) {
		Map<String, Object> map = new HashMap<>();
		map.put("findMember", memberMapper.selectMemberByNameEmail(member));
		return map;
	}
	
	/* 비밀번호 찾기 */
	@Override
	public Map<String, Object> idEmailCheck(MemberDTO member) {
		Map<String, Object> map = new HashMap<>();
		map.put("findMember", memberMapper.selectMemberByIdEmail(member));
		return map;
	}
	
	@Override
	public void changePw(HttpServletRequest request, HttpServletResponse response) {
		
		String memberId = request.getParameter("memberId");
		String memberPw = SecurityUtils.sha256(request.getParameter("memberPw"));
		
		MemberDTO member = MemberDTO.builder()
				.memberId(memberId)
				.memberPw(memberPw)
				.build();
		
		int res = memberMapper.updatePw(member);
		
		try {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			if(res == 1) {
				out.println("<script>");
				out.println("alert('비밀번호가 수정되었습니다.')");
				out.println("location.href='" + request.getContextPath() + "/member/loginPage'");
				out.println("</script>");
				out.close();
			} else {
				out.println("<script>");
				out.println("alert('비밀번호가 수정되지 않았습니다.')");
				out.println("history.back()");
				out.println("</script>");
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
}