package com.goodee.gym.util;

import java.security.MessageDigest;

import org.apache.commons.codec.binary.Base64;

public class SecurityUtils {

	// XSS
	public static String xss(String str) {
		str = str.replaceAll("<", "&lt;");
		str = str.replaceAll(">", "&gt;");
		str = str.replaceAll("\"", "&quot;");
		str = str.replaceAll("\'", "&#x27;");
		str = str.replaceAll("&", "&amp;");
		return str;
	}
	
	// 인증코드 만들기
	public static String authCode(int length) {
		StringBuilder sb = new StringBuilder();
		for(int i = 0; i < length; i++) {
			if(Math.random() < 0.5) {
				sb.append( (char)((int)(Math.random() * 10) + 48) ); 
				//sb.append( (char)((int)(Math.random() * 10) + '0') ); 
			} else {
				sb.append( (char)((int)(Math.random() * 26) + 65) ); 
				//sb.append( (char)((int)(Math.random() * 26) + 'A') );
			}
		}
		return sb.toString();
	}
	
	// java.security 패키지 이용한 암호화
	// SHA-256 : 입력된 값을 256비트(32바이트) 암호화 처리하는 암호화 알고리즘, 복호화는 불가.
	// 1바이트가 2글자로 표현되므로 DB의 칼럼 크기는 64로 설정
	public static String sha256(String password) {
		MessageDigest md = null;
		try {
			md = MessageDigest.getInstance("SHA-256");
			md.update(password.getBytes());
		} catch (Exception e) {
			e.printStackTrace();
		}
		byte[] bytes = md.digest();
		StringBuilder sb = new StringBuilder();
		for(byte b : bytes) {
			sb.append(String.format("%02X", b)); 
		}
		return sb.toString();
	}
	
	// commons-codec 디펜던시를 이용한 암호화/복호화
	
	// 암호 : 1234 -> k23jrk2312o48
	public static String encodeBase64(String str) {
		return new String(Base64.encodeBase64(str.getBytes()));
	}
	
	// 복호 : k23jrk2312o48 -> 1234
	public static String decodeBase64(String str) {
		return new String(Base64.decodeBase64(str.getBytes()));
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
