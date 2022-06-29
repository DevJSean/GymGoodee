package com.goodee.gym.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.goodee.gym.domain.ClassDTO;
import com.goodee.gym.domain.MemberDTO;
import com.goodee.gym.domain.ReservationDTO;
import com.goodee.gym.mapper.ReserveMapper;

public class ReserveServiceImpl implements ReserveService {
	
	@Autowired
	private ReserveMapper reserveMapper;
	
		
	// 1. 개설 강좌 목록 가져오기
	// 종목, 날짜 받아와서 일치하는 개설 강좌를 리스트로 가져온 뒤,
	// 현재 접속해 있는 회원의 회원번호와 개설 강좌를 classCode를 가지고
	// reservation 테이블에서 해당 정보가 있는지 없는지 조회 후
	// classDTO의 reserveState에 예약 유무를 넣어준다.
	// select 작업으로만 이루어져어있으므로 transaction은 할 필요 x
	@Override
	public Map<String, Object> getSwimClasses(HttpServletRequest request) {
		String subject = request.getParameter("subject");
		String classDate = request.getParameter("classDate");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("subject", subject.substring(0,2));
		map.put("classDate",classDate);
		
		// 1) 개설 강좌 목록
		List<ClassDTO> classes = reserveMapper.selectClassList(map);
		int classCount = reserveMapper.selectCountClassList(map);
		
		// session에 "loginMember"로 로그인한 회원의 정보가 들어있다. => reserveSwim 에서 다시하기.....
		// 1) 비로그인 => 회원가입 버튼
		// 2) 로그인 / 수강권 x => 수강권 구매 버튼
		// 3) 로그인 / 수강권 o => 밑에 과정 진행
		
		HttpSession session = request.getSession();
		MemberDTO member = null;
		if(session.getAttribute("loginMember")!=null) {
			member = (MemberDTO)session.getAttribute("loginMember");
		}
		//System.out.println("member : " + member);
		
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("classes", classes);			// 강좌 목록
		res.put("classCount", classCount);		// 총 강좌 갯수
		if(member == null) {
			//System.out.println("비로그인 상태!!");
			res.put("state", -1);				// 비로그인 : -1
			return res;
		} 
		else if(member!=null){					// 회원인 경우
			String memberId = member.getMemberId();
			Map<String, Object> tmp1 = new HashMap<String, Object>();
			tmp1.put("subject", subject);
			tmp1.put("memberId", memberId);
			String tmp_reaminTicket = reserveMapper.getRemainTicketBySubject(tmp1);
			//System.out.println("남은 티켓 : " + tmp_reaminTicket);
			Optional<String> opt = Optional.ofNullable(tmp_reaminTicket);
			int remain = Integer.parseInt(opt.orElse("0"));
			//REAMIN_TICKET 테이블에서 해당 종목의 잔여수강권이 있는지 가져오기
			if(remain == 0) {				// 회원 -> 수강권 x
				res.put("state", 0);
			} else if(remain > 0) {			// 회원 -> 수강권 o
				res.put("state", 1);
			}
		}
		
		
		Long memberNo = member.getMemberNo();
				
		// 2) 해당 강좌를 내가 예약했는지 아닌지에 대한 정보 생성
		Map<String, Object> tmp = new HashMap<String, Object>();
		for(int i = 0; i<classes.size();i++) {
			
			// 2-1) 해당 강좌에 예약한 사람 수
			String classCode = classes.get(i).getClassCode();
			classes.get(i).setCurrentCount(reserveMapper.selectCountByClassCode(classCode));
			
			// 2-2) 
			// 수강 목록을 가져올 때 내가 이미 예약한 수업인지 아닌지에 대한 정보를 얻어오기 위해
			// memberNo와 classCode를 넘겨주어 reservation 테이블에서 reservaion_state 값을 가져온다.
			// -1(예약취소), 0(예약), 1(수강완료), 500(예약 안한 상태 => 테이블에 정보가 없기 때문에 null 값이 나온다.)
			tmp.put("memberNo", memberNo);
			tmp.put("classCode", classCode);
			
			Optional<String> opt = Optional.ofNullable(reserveMapper.selectReservationByClassCode(tmp));
			int reservationState = Integer.parseInt(opt.orElse("500"));		
			
			// 2-3) reservationState 설정하기
			classes.get(i).setReservationState(reservationState);
			tmp.clear();
		}
		
		
		// 3) 위의 과정을 모두 마친 후의 classes를 반환해주기
		res.put("classes", classes);
		
		return res;
	}

	// 2. 수영 예약하기 (UPDATE/INSERT + UPDATE)
	@Transactional
	@Override
	public Map<String, Object> reserveSwim(HttpServletRequest request) {
		// request에서 파라미터들 받아와서 insert 할 reservationDTO 만들고
		// 결과 res 로 받아오기
		
		// 1) 파라미터 처리
		String subject = request.getParameter("subject");
		String classCode = request.getParameter("classCode");
		
		HttpSession session = request.getSession();
		MemberDTO member = (MemberDTO)session.getAttribute("loginMember");
		Long memberNo = member.getMemberNo();
		
		// 2) Reservation 테이블에서 해당 회원이 예약한 class_code 가져오기
		Map<String, Object> tmp = new HashMap<String, Object>();
		tmp.put("memberNo", memberNo);
		tmp.put("classCode", classCode);
		List<String> classCodes = new ArrayList<String>();
		classCodes = reserveMapper.selectCodesFromReservation(tmp);
		if(classCodes == null) {
			//System.out.println("하나도 없음");
		}
		
		Map<String, Object> result = new HashMap<String, Object>();
		// 2-1)
		// classCodes들을 가져와 '날짜_시간' 만 substring 하여 
		// 파라미터로 받아온 classCode와 비교해본다.
		// 일치하는 것이 있으면 같은 날짜, 같은 시간에 이미 예약했으므로 
		// 예약불가!
		String originCode = classCode.substring(0,classCode.lastIndexOf("_"));
		System.out.println("originCode : " + originCode);
		for(int i = 0; i<classCodes.size();i++) {
			int codeIndex = classCodes.get(i).lastIndexOf("_");
			String tmpCode = classCodes.get(i).substring(0,codeIndex);	// '날짜_시간'
			//System.out.println("tmpCode : " + tmpCode);
			if(originCode.equals(tmpCode)) {
				result.put("state", 501);		// 중복되는 강좌 예약하려고 시도
				return result;
			}
		}
		
		
		// 3)
		// 2)의 과정을 통과하면 같은 날짜, 같은 시간대에 예약되어 있는 강좌가 없는 것이다.
		// 이때, 파라미터로 받아온 classCode 와 일치하는 classCode를 가지는 행이
		// RESERVATIO 테이블에 있는지 없는지 확인해야한다.
		// 동일한 것이 존재한다면
		// 이미 예약을 했다가 취소를 했으므로 
		// RESERVATION 테이블에 insert을 해주는 것이 아니라
		// RESERVATION_STATE 을 0으로 UPDATE 해줘야한다.
		
		int res = 0;
		int flag = reserveMapper.selectMemberFromReservation(tmp);
		
		// 예약했다가 취소한 사람 (UPDATE 작업)
		if(flag == 1) {
			res = reserveMapper.updateAgainReserve(tmp);	
		}		
		// flag가 0이면 그냥 처음 예약하는 사람! (INSERT 작업)		
		else if(flag == 0) {
			ReservationDTO reservation = ReservationDTO.builder()
					.classCode(classCode)
					.memberNo(memberNo)
					.subject(subject)		
					.build();			
			res = reserveMapper.insertReserveSwim(reservation);
		}
		
		// 4) 위의 과정까지 예약이 완료되었으므로 잔여수강권 횟수를 -1 해야한다. (UPDATE)
		
		
		String memberId = member.getMemberId();
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("subject",subject);
		map2.put("memberId", memberId);
		int res2 = reserveMapper.updateMinusRemainTicket(map2);
				
		
		// 5) 위의 결과를 받아 MAP으로 반환
		result.put("res", res);
		
		
		return result;
		
	}
	
	
	// 3. 수영 예약 취소하기 (UPDATE + UPDATE)
	@Transactional
	@Override
	public Map<String, Object> cancelSwim(HttpServletRequest request) {
		
		
		// 1) 파라미터 처리
		String subject = request.getParameter("subject");
		String classCode = request.getParameter("classCode");
		
		HttpSession session = request.getSession();
		MemberDTO member = (MemberDTO)session.getAttribute("loginMember");
		Long memberNo = member.getMemberNo();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberNo", memberNo);
		map.put("classCode", classCode);
		int res = reserveMapper.updateCancelSwim(map);
		//System.out.println("수강 취소 : " +res);
		
		// 2) 잔여수강권 횟수 증가시키기
		String memberId = member.getMemberId();
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("subject",subject);
		map2.put("memberId", memberId);
		//System.out.println("subject : " + subject + " memberId : " + memberId);
		int res2 = reserveMapper.updatePlusRemainTicket(map2);
		//System.out.println("잔여수강권 증감 : " + res2);
		
		// 3) 결과 받아와 MAP으로 만들기
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("res", res);
		
		return result;
	}
}
