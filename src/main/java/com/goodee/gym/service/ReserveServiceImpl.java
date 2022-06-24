package com.goodee.gym.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

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
		
		/* 수정 필요 */
		HttpSession session = request.getSession();
		MemberDTO member = null;
		if(session.getAttribute("loginMember")!=null) {
			member = (MemberDTO)session.getAttribute("loginMember");
		}
		System.out.println("member : " + member);
		
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("classes", classes);
		res.put("classCount", classCount);		// 총 강좌 갯수
		if(member == null) {
			res.put("state", -1);			// 비로그인 : -1
		} 
		else if(member!=null){			// 회원인 경우
			String memberId = member.getMemberId();
			Map<String, Object> tmp1 = new HashMap<String, Object>();
			tmp1.put("subject", subject);
			tmp1.put("memberId", memberId);
			Optional<String> opt = Optional.ofNullable(reserveMapper.getRemainTicketBySubject(tmp1));
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

	// 2. 수영 예약하기
	@Override
	public Map<String, Object> reserveSwim(HttpServletRequest request) {
		// request에서 파라미터들 받아와서 insert 할 reservationDTO 만들고
		// 결과 res 로 받아오기
		
		// 1) 파라미터 처리
		String subject = request.getParameter("subject");
		Long memberNo = Long.parseLong(request.getParameter("memberNo"));
		String classCode = request.getParameter("classCode");
		
		
		// 2) Reservation 테이블에서 해당 회원 정보 찾기
		Map<String, Object> tmp = new HashMap<String, Object>();
		tmp.put("memberNo", memberNo);
		tmp.put("classCode", classCode);
		int flag = reserveMapper.selectMemberFromReservation(tmp);
		
		// 3)
		// flag가 1이면 이미 예약을 했다가 취소를 했으므로 
		// RESERVATION 테이블에 insert을 해주는 것이 아니라
		// RESERVATION_STATE 을 0으로 UPDATE 해줘야한다.
		int res = 0;
		if(flag == 1) {
			res = reserveMapper.updateAgainReserve(tmp);
		}
		// flag가 0이면 그냥 처음 예약하는 사람!			
		else if(flag == 0) {
			ReservationDTO reservation = ReservationDTO.builder()
					.classCode(classCode)
					.memberNo(memberNo)
					.subject(subject)		
					.build();			
			res = reserveMapper.insertReserveSwim(reservation);
		}
				
		
		// 4) 위의 결과를 받아 MAP으로 반환
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("res", res);
		
		
		// 잔여수강권 횟수 차감하기
		
		
		return map;
		
	}
	
	
	// 3. 수영 예약 취소하기 (UPDATE)
	@Override
	public Map<String, Object> cancelSwim(HttpServletRequest request) {
		
		// 1) 파라미터 처리
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberNo", request.getParameter("memberNo"));
		map.put("classCode", request.getParameter("classCode"));
		
		// 2) 결과 받아와 MAP으로 만들기
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("res", reserveMapper.updateCancelSwim(map));
		
		
		// 잔여수강권 횟수 증가시키기
		
		return res;
	}
}
