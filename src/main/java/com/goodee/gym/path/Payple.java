package com.goodee.gym.path;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class Payple {


	/**
	 * 파트너 인증 메소드
	 * 
	 * @param params // 상황별 파트너 인증 요청 파라미터(계정정보 제외)
	 * @return JSONObject // 파트너 인증 응답값
	 */
	public JSONObject payAuth(Map<String, String> params) {
		JSONObject jsonObject = new JSONObject();
		JSONParser jsonParser = new JSONParser();
		try {

			// 파트너 인증 Request URL
			String pURL = "https://democpay.payple.kr/php/auth.php"; // TEST (테스트)

			// 계정정보
			String cst_id = "test";
			String cust_key = "abcd1234567890";

			JSONObject obj = new JSONObject();
			obj.put("cst_id", cst_id);
			obj.put("custKey", cust_key);

			
			URL url = new URL(pURL);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();

			/*
			 * ※ Referer 설정 방법 
			 * TEST : referer에는 테스트 결제창을 띄우는 도메인을 넣어주셔야합니다. 
			 * 		  결제창을 띄울 도메인과 referer값이 다르면 [AUTH0007] 응답이 발생합니다.
			 * REAL : referer에는 가맹점 도메인으로 등록된 도메인을 넣어주셔야합니다.
			 * 		  다른 도메인을 넣으시면 [AUTH0004] 응답이 발생합니다.
			 * 		  또한, TEST에서와 마찬가지로 결제창을 띄우는 도메인과 같아야 합니다.
			 */
			con.setRequestMethod("POST");
			con.setRequestProperty("content-type", "application/json");
			con.setRequestProperty("charset", "UTF-8");
			con.setRequestProperty("referer", "http://localhost:9090");
			con.setDoOutput(true);

			DataOutputStream wr = new DataOutputStream(con.getOutputStream());
			wr.write(obj.toString().getBytes());
			wr.flush();
			wr.close();

			int responseCode = con.getResponseCode();
			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine = null;
			StringBuffer response = new StringBuffer();

			while ((inputLine = br.readLine()) != null) {
				response.append(inputLine);
			}

			br.close();

			jsonObject = (JSONObject) jsonParser.parse(response.toString());

		} catch (Exception e) {
			e.printStackTrace();
		}
		return jsonObject;

	}
	
}
