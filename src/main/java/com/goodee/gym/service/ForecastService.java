package com.goodee.gym.service;

import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;

import java.io.BufferedReader;
import java.io.IOException;

public class ForecastService {
    	
    public static String forecast(HttpServletRequest request) {	
    	String fDate = request.getParameter("fDate");
    	String x = request.getParameter("x");
    	String y = request.getParameter("y");
    	try {
    		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"); /*URL*/
    		urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=lkYJjFhNdh0yOa1pzlWsCt6Bw%2FxTOpBVa6vuiQNOjpZUtlkXKYbTkAhL4KDaY97SmQucM4J42kl0cBNDthXb0A%3D%3D"); /*Service Key*/
    		urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
    		urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("1000", "UTF-8")); /*한 페이지 결과 수*/
    		urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode("JSON", "UTF-8")); /*요청자료형식(XML/JSON) Default: XML*/
    		urlBuilder.append("&" + URLEncoder.encode("base_date","UTF-8") + "=" + URLEncoder.encode(fDate, "UTF-8")); 
    		urlBuilder.append("&" + URLEncoder.encode("base_time","UTF-8") + "=" + URLEncoder.encode("0800", "UTF-8")); 
    		urlBuilder.append("&" + URLEncoder.encode("nx","UTF-8") + "=" + URLEncoder.encode(x, "UTF-8")); /*예보지점의 X 좌표값*/
    		urlBuilder.append("&" + URLEncoder.encode("ny","UTF-8") + "=" + URLEncoder.encode(y, "UTF-8")); /*예보지점의 Y 좌표값*/
    		URL url = new URL(urlBuilder.toString());
    		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    		conn.setRequestMethod("GET");
    		conn.setRequestProperty("Content-type", "application/json");
    		//System.out.println("Response code: " + conn.getResponseCode());
    		BufferedReader rd;
    		if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
    			rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    		} else {
    			rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
    		}
    		StringBuilder sb = new StringBuilder();
    		String line;
    		while ((line = rd.readLine()) != null) {
    			sb.append(line);
    		}
    		rd.close();
    		conn.disconnect();
    		return sb.toString();
    	} catch (IOException e) {
    		e.printStackTrace();
		}
    	
        return null;
    }
}