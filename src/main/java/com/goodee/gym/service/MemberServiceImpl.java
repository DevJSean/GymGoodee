package com.goodee.gym.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.SecureRandom;
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
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.mapper.MemberMapper;
import com.goodee.gym.util.SecurityUtils;

import net.nurigo.java_sdk.exceptions.CoolsmsException;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	private MemberMapper memberMapper;
	
	@Override
	public Map<String, Object> idCheck(String memberId) {
		Map<String, Object> map = new HashMap<>();
		map.put("res1", memberMapper.selectMemberById(memberId));
		map.put("res2", memberMapper.selectSignOutMemberById(memberId));
		return map;
	}
	
	@Override
	public Map<String, Object> emailCheck(String memberEmail) {
		Map<String, Object> map = new HashMap<>();
		map.put("res", memberMapper.selectMemberByEmail(memberEmail));
		return map;
	}
	
	@Override
	public Map<String, Object> sendAuthCodeEmail(String memberEmail) {
		
		String authCodeEmail = SecurityUtils.authCode(6);    
		System.out.println(authCodeEmail);
		
		Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.gmail.com");  
		props.put("mail.smtp.port", "587");            
		props.put("mail.smtp.auth", "true");            
		props.put("mail.smtp.starttls.enable", "true"); 
		
		final String USERNAME = "forspringlec@gmail.com";
		final String PASSWORD = "ukpiajijxfirdgcz";     
		
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
			message.setFrom(new InternetAddress(USERNAME, "GYM관리자"));
			message.setRecipient(Message.RecipientType.TO, new InternetAddress(memberEmail));
			message.setSubject("인증 요청 메일입니다.");
			message.setText("안녕하세요. GYMGOODEE 관리자입니다. 인증번호는 " + authCodeEmail + "입니다.");
			
			Transport.send(message);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("authCodeEmail", authCodeEmail);
		return map;
		
	}
	
	@Override
	public Map<String, Object> sendAuthCodeSMS(String memberPhone) {
		
		String authCodeSMS = SecurityUtils.authCode(6);
		
	    String api_key = "NCSM4A6HJTQWGBU3";
	    String api_secret = "G0IP0LQVML0IOUNCZCJRQQWBHJGJH982";
	    net.nurigo.java_sdk.api.Message coolsms = new net.nurigo.java_sdk.api.Message(api_key, api_secret);
		
	    HashMap<String, String> params = new HashMap<>();
	    params.put("to", memberPhone);
		params.put("from", "01056466373");
		params.put("type", "SMS");
		params.put("text", "[gym] 인증번호는 " + authCodeSMS + "입니다.");
		params.put("app_version", "test app 1.2");
		
		try {
			JSONObject obj = (JSONObject)(coolsms).send(params);
			System.out.println(obj);
		} catch (CoolsmsException e) {
			e.printStackTrace();
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("authCodeSMS", authCodeSMS);
		return map;
	}
	
	@Override
	public void signUp(HttpServletRequest request, HttpServletResponse response) {
		
		String memberId = SecurityUtils.xss(request.getParameter("memberId"));       
		String memberPw = SecurityUtils.sha256(request.getParameter("memberPw"));     
		String memberName = SecurityUtils.xss(request.getParameter("memberName"));    
		String memberBirth = SecurityUtils.xss(request.getParameter("memberBirth"));    
		String memberGender = SecurityUtils.xss(request.getParameter("memberGender"));   
		String memberPhone = SecurityUtils.xss(request.getParameter("memberPhone"));    
		String memberEmail = SecurityUtils.xss(request.getParameter("memberEmail")); 
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
		
		int res = memberMapper.insertMember(member);
		
		try {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			if(res == 1) {
				out.println("<script>");
				out.println("alert('회원 가입되었습니다.')");
				out.println("location.href='" + request.getContextPath() + "/lsh'");
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
		
		String memberId = SecurityUtils.xss(request.getParameter("memberId"));
		String memberPw = SecurityUtils.sha256(request.getParameter("memberPw"));
		
		MemberDTO member = MemberDTO.builder()
				.memberId(memberId)
				.memberPw(memberPw)
				.build();
		
		MemberDTO loginMember = memberMapper.selectMemberByIdPw(member);
		
		if(loginMember != null) {
			memberMapper.insertMemberLog(loginMember.getMemberNo());
		}
		
		return loginMember;
		
	}
	
	@Override
	public String naverLogin(HttpSession session) {

		String clientId = "XYULZHj0e4wadrMeNhvI";
		String redirectURI = null;
		try {
			redirectURI = URLEncoder.encode("http://localhost:9090/gym/member/callback", "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}	
	    SecureRandom random = new SecureRandom();
	    String state = new BigInteger(130, random).toString();
	    String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
	    apiURL += "&client_id=" + clientId;
	    apiURL += "&redirect_uri=" + redirectURI;
	    apiURL += "&state=" + state;
	    session.setAttribute("state", state);
		
		return apiURL;
	}
	
	@Override
	public void naverCallback(HttpServletRequest request, HttpServletResponse response) {
		
		String clientId = "XYULZHj0e4wadrMeNhvI";
	    String clientSecret = "4gVLsa0no9";
	    String code = request.getParameter("code");
	    String state = request.getParameter("state");
	    String redirectURI = null;
		try {
			redirectURI = URLEncoder.encode("http://localhost:9090/gym/member/callback", "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}	    
		String apiURL;
	    apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&";
	    apiURL += "client_id=" + clientId;
	    apiURL += "&client_secret=" + clientSecret;
	    apiURL += "&redirect_uri=" + redirectURI;
	    apiURL += "&code=" + code;
	    apiURL += "&state=" + state;

	    try {
	      URL url = new URL(apiURL);
	      HttpURLConnection con = (HttpURLConnection)url.openConnection();
	      con.setRequestMethod("GET");
	      int responseCode = con.getResponseCode();
	      BufferedReader br;
	      if(responseCode==200) { 
	        br = new BufferedReader(new InputStreamReader(con.getInputStream()));
	      } else {  
	        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
	      }
	      String inputLine;
	      StringBuffer res = new StringBuffer();
	      while ((inputLine = br.readLine()) != null) {
	        res.append(inputLine);
	      }
	      br.close();
	      org.json.JSONObject obj = new org.json.JSONObject(res.toString());
	      
		  String access_token = obj.getString("access_token"); 
	      
		  String header = "Bearer " + access_token; 

	      String apiURL2 = "https://openapi.naver.com/v1/nid/me";


	      Map<String, String> requestHeaders = new HashMap<>();
	      requestHeaders.put("Authorization", header);
	      String responseBody = get(apiURL2,requestHeaders);

	      org.json.JSONObject obj2 = new org.json.JSONObject(responseBody.toString());
	      
	      org.json.JSONObject obj3 = obj2.getJSONObject("response");
	      String memberId = obj3.getString("id");
	      String memberName = obj3.getString("name");
	      String memberBirth = obj3.getString("birthyear") + "-" + obj3.getString("birthday");
	      String memberGender = obj3.getString("gender");
	      String memberPhone = obj3.getString("mobile");
	      String memberEmail = obj3.getString("email");
	      
		  MemberDTO naver = MemberDTO.builder()
				  .memberId(memberId)
				  .memberName(memberName)
				  .memberBirth(memberBirth)
				  .memberGender(memberGender)
				  .memberPhone(memberPhone)
				  .memberEmail(memberEmail)
				  .build();
			
		  
		  if(memberMapper.selectMemberByEmail(memberEmail) == null) {
			  memberMapper.insertNaver(naver);
		  } else {
			  try {
			    	response.setContentType("text/html");
			    	PrintWriter out = response.getWriter();
			    		out.println("<script>");
			    		out.println("alert('등록된 아이디가 있습니다.')");
						out.println("location.href='" + request.getContextPath() + "/login'");
			    		out.println("</script>");
			    		out.close();
			    	  
			    } catch (Exception e) {
			    	e.printStackTrace();
			    }
		  }
		  MemberDTO loginMember = memberMapper.selectMemberById(memberId);
		  
		  memberMapper.insertMemberLog(loginMember.getMemberNo());
		  
		  HttpSession session = request.getSession();
	      session.setAttribute("loginMember", loginMember);
	      session.setMaxInactiveInterval(60*60);
	      
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	}
	
	@Override
	public String kakaoLogin(HttpSession session) {
		
		String clientId = "3e6d88b955a2408ebdcace4d52b2bf99";
		String redirectURI = null;
		try {
			redirectURI = URLEncoder.encode("http://localhost:9090/gym/member/kakaoCallback", "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}	
	    SecureRandom random = new SecureRandom();
	    String state = new BigInteger(130, random).toString();
	    String apiURL = "https://kauth.kakao.com/oauth/authorize?response_type=code";
	    apiURL += "&client_id=" + clientId;
	    apiURL += "&redirect_uri=" + redirectURI;
	    apiURL += "&state=" + state;
	    session.setAttribute("state", state);
		
		return apiURL;
	}
	
	@Override
	public void kakaoCallback(HttpServletRequest request, HttpServletResponse response) {
		String clientId = "3e6d88b955a2408ebdcace4d52b2bf99";
	    String clientSecret = "BENF6ElBnkKLakylegki6AoLsK8SYuJO";
	    String code = request.getParameter("code");
	    String state = request.getParameter("state");
	    String redirectURI = null;
	    String header = null;
	    String access_token = null;
	    MemberDTO loginMember;
	    
		try {
			redirectURI = URLEncoder.encode("http://localhost:9090/gym/member/kakaoCallback", "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}	
		
		String apiURL;
	    apiURL = "https://kauth.kakao.com/oauth/token?grant_type=authorization_code&";
	    apiURL += "client_id=" + clientId;
	    apiURL += "&client_secret=" + clientSecret;
	    apiURL += "&redirect_uri=" + redirectURI;
	    apiURL += "&code=" + code;
	    apiURL += "&state=" + state;

	    try {
	      URL url = new URL(apiURL);
	      HttpURLConnection con = (HttpURLConnection)url.openConnection();
	      con.setRequestMethod("POST");
	      int responseCode = con.getResponseCode();
	      BufferedReader br;
	      System.out.println("responseCode="+responseCode);
	      if(responseCode==200) { 
	        br = new BufferedReader(new InputStreamReader(con.getInputStream()));
	      } else {  
	        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
	      }
	      String inputLine;
	      StringBuffer res = new StringBuffer();
	      while ((inputLine = br.readLine()) != null) {
	        res.append(inputLine);
	      }
	      br.close();
	      org.json.JSONObject obj = new org.json.JSONObject(res.toString());
	      
		  access_token = obj.getString("access_token");
	      
		  header = "Bearer " + access_token; 

	      String apiURL2 = "https://kapi.kakao.com/v2/user/me";

	      Map<String, String> requestHeaders = new HashMap<>();
	      requestHeaders.put("Authorization", header);
	      
	      String responseBody = get(apiURL2,requestHeaders);

	      org.json.JSONObject obj2 = new org.json.JSONObject(responseBody.toString());
	      
	      org.json.JSONObject obj3 = obj2.getJSONObject("kakao_account");
	      org.json.JSONObject obj4 = obj3.getJSONObject("profile");
	      String memberId = String.valueOf(obj2.getLong("id"));
	      String memberName = obj4.getString("nickname");
	      String memberEmail = obj3.getString("email");
	      
	      String gender2 = obj3.getString("gender");
	      char memberGender = gender2.charAt(0);
	      
	      String memberBirth = obj3.getString("birthday");
	      String memberPhone = "카카오가입";
	      
		  MemberDTO kakao = MemberDTO.builder()
				  .memberId(memberId)
				  .memberName(memberName)
				  .memberEmail(memberEmail)
				  .memberGender(String.valueOf(memberGender))
				  .memberBirth(memberBirth)
				  .memberPhone(memberPhone)
				  .build();
		  
		  
		  if(memberMapper.selectMemberByEmail(memberEmail) == null) {
			  memberMapper.insertKakao(kakao);
		  } else {
			  try {
			    	response.setContentType("text/html");
			    	PrintWriter out = response.getWriter();
			    		out.println("<script>");
			    		out.println("alert('등록된 회원입니다.')");
						out.println("location.href='" + request.getContextPath() + "/member/loginPage'");
			    		out.println("</script>");
			    		out.close();
			    	  
			    } catch (Exception e) {
			    	e.printStackTrace();
			    }
		  }
		  loginMember = memberMapper.selectMemberById(memberId);
		  
		  memberMapper.insertMemberLog(loginMember.getMemberNo());
		  
		  HttpSession session = request.getSession();
	      session.setAttribute("loginMember", loginMember);
	      session.setMaxInactiveInterval(60*60);
	      
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	    
	}
	
    private static String get(String apiUrl, Map<String, String> requestHeaders){
        HttpURLConnection con = connect(apiUrl);
        try {
            con.setRequestMethod("GET");
            for(Map.Entry<String, String> header :requestHeaders.entrySet()) {
                con.setRequestProperty(header.getKey(), header.getValue());
            }

            int responseCode = con.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) { 
                return readBody(con.getInputStream());
            } else { 
                return readBody(con.getErrorStream());
            }
        } catch (IOException e) {
            throw new RuntimeException("API 요청과 응답 실패", e);
        } finally {
            con.disconnect();
        }
    }


    private static HttpURLConnection connect(String apiUrl){
        try {
            URL url = new URL(apiUrl);
            return (HttpURLConnection)url.openConnection();
        } catch (MalformedURLException e) {
            throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
        } catch (IOException e) {
            throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
        }
    }

    private static String readBody(InputStream body){
        InputStreamReader streamReader = new InputStreamReader(body);


        try (BufferedReader lineReader = new BufferedReader(streamReader)) {
            StringBuilder responseBody = new StringBuilder();


            String line;
            while ((line = lineReader.readLine()) != null) {
                responseBody.append(line);
            }


            return responseBody.toString();
        } catch (IOException e) {
            throw new RuntimeException("API 응답을 읽는데 실패했습니다.", e);
        }
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
	public Map<String, Object> idPhoneCheck(MemberDTO member) {
		Map<String, Object> map = new HashMap<>();
		map.put("findMember", memberMapper.selectMemberByIdPhone(member));
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