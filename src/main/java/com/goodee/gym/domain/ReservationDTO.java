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
	
}
