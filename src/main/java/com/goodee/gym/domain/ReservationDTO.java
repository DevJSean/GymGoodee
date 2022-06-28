package com.goodee.gym.domain;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ReservationDTO {

private String subject;

private String reservationCode;
private Long memberNo;
private String classCode;
private Timestamp reservationDate;
private Integer reservationState;

/* 잔여수강권 테이블에서 조인으로 가져오는 값 */
private String remainTicketSubject;

/* 회원 테이블에서 조인으로 가져오는 값 */
private String memberId;

/* 개설강좌 테이블에서 조인으로 가져오는 값 */
private Long rn;
private String classDate;
private String classTime;
	
}
