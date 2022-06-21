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


private String reservationCode;
private Long memberNo;
private String classCode;
private Timestamp reservationDate;
private Integer reservationState;

/* 개설강좌 테이블에서 조인으로 가져오는 값 */
private String classDate;
private String classTime;
	
}
