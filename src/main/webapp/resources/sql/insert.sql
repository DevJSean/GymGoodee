-- 회원(회원번호, 아이디, 비밀번호, 이름, 생년월일, 성별, 연락처, 이메일, 동의여부, 가입일, 비번 수정일, 로그인 종류 표시)
INSERT INTO MEMBER VALUES(101, 'ID101', 'PW101', '이름101', '1998-02-21', 'F', '010-0000-0002', 'email101@naver.com', 2, '22/06/02', '22/06/02', 3);
INSERT INTO MEMBER VALUES(102, 'ID102', 'PW102', '이름102', '1999-03-22', 'M', '010-0000-0003', 'email102@naver.com', 3, '22/06/03', '22/06/03', 3);

-- 회원 기록(회원기록번호, 회원번호, 로그인 일시)
INSERT INTO MEMBER_LOG VALUES(201, 101, '20220602');
INSERT INTO MEMBER_LOG VALUES(202, 102, '20220603');
INSERT INTO MEMBER_LOG VALUES(203, 101, '20220603');
INSERT INTO MEMBER_LOG VALUES(204, 102, '20220604');

-- 수강권(수강권번호, 종목, 횟수, 소멸기간, 가격)
INSERT INTO TICKET VALUES(1, 'SWIM', 8, 30, '80,000');
INSERT INTO TICKET VALUES(2, 'SWIM', 16, 30, '160,000');
INSERT INTO TICKET VALUES(3, 'SWIM', 24, 90, '216,000');
INSERT INTO TICKET VALUES(4, 'SWIM', 32, 90, '288,000');
INSERT INTO TICKET VALUES(5, 'SWIM', 40, 180, '320,000');
INSERT INTO TICKET VALUES(6, 'SWIM', 48, 180, '384,000');
INSERT INTO TICKET VALUES(7, 'DANCE', 8, 30, '80,000');
INSERT INTO TICKET VALUES(8, 'DANCE', 16, 30, '160,000');
INSERT INTO TICKET VALUES(9, 'DANCE', 24, 90, '216,000');
INSERT INTO TICKET VALUES(10, 'DANCE', 32, 90, '288,000');
INSERT INTO TICKET VALUES(11, 'DANCE', 40, 180, '320,000');
INSERT INTO TICKET VALUES(12, 'DANCE', 48, 180, '384,000');
INSERT INTO TICKET VALUES(13, 'PILATES', 8, 30, '160,000');
INSERT INTO TICKET VALUES(14, 'PILATES', 16, 30, '320,000');
INSERT INTO TICKET VALUES(15, 'PILATES', 24, 90, '432,000');
INSERT INTO TICKET VALUES(16, 'PILATES', 32, 90, '576,000');
INSERT INTO TICKET VALUES(17, 'PILATES', 40, 180, '640,000');
INSERT INTO TICKET VALUES(18, 'PILATES', 48, 180, '768,000');
INSERT INTO TICKET VALUES(19, 'SPINNING', 8, 30, '80,000');
INSERT INTO TICKET VALUES(20, 'SPINNING', 16, 30, '160,000');
INSERT INTO TICKET VALUES(21, 'SPINNING', 24, 90, '216,000');
INSERT INTO TICKET VALUES(22, 'SPINNING', 32, 90, '288,000');
INSERT INTO TICKET VALUES(23, 'SPINNING', 40, 180, '320,000');
INSERT INTO TICKET VALUES(24, 'SPINNING', 48, 180, '384,000');

--결제(결제번호, 회원번호, 수강권번호, 결제일)
INSERT INTO PAYLIST VALUES(301, 101, 1, '22/06/02');
INSERT INTO PAYLIST VALUES(302, 101, 7, '22/06/02');
INSERT INTO PAYLIST VALUES(303, 102, 1, '22/06/03');
INSERT INTO PAYLIST VALUES(304, 102, 7, '22/06/03');
INSERT INTO PAYLIST VALUES(305, 101, 13, '22/06/03');
INSERT INTO PAYLIST VALUES(306, 101, 19, '22/06/04');

-- 잔여 수강권(잔여수강권번호, 아이디, 종목, 만료일, 남은횟수)
INSERT INTO REMAIN_TICKET VALUES(401, 'ID101', 'SWIM', '22/07/01', 8);
INSERT INTO REMAIN_TICKET VALUES(402, 'ID101', 'DANCE', '22/07/01', 8);
INSERT INTO REMAIN_TICKET VALUES(403, 'ID102', 'SWIM', '22/07/02', 8);
INSERT INTO REMAIN_TICKET VALUES(404, 'ID102', 'DANCE', '22/07/02', 8);
INSERT INTO REMAIN_TICKET VALUES(405, 'ID101', 'PILATES', '22/07/02', 8);
INSERT INTO REMAIN_TICKET VALUES(406, 'ID101', 'SPINNING', '22/07/03', 8);

-- 강사(강사번호, 강사이름, 강사성별, 종목)
INSERT INTO TEACHER VALUES(501, '장이수', 'F', 'SWIM');
INSERT INTO TEACHER VALUES(502, '마석도', 'M', 'DANCE');
INSERT INTO TEACHER VALUES(503, '강해상', 'M', 'PILATES');
INSERT INTO TEACHER VALUES(504, '장첸', 'M', 'SPINNING');
INSERT INTO TEACHER VALUES(505, '전일만', 'F', 'SWIM');

-- 장소(장소코드, 수강정원)
INSERT INTO LOCATION VALUES('SWIM01', 20);
INSERT INTO LOCATION VALUES('SWIM02', 20);
INSERT INTO LOCATION VALUES('DANCE01', 10);
INSERT INTO LOCATION VALUES('DANCE02', 12);
INSERT INTO LOCATION VALUES('PILATES01', 8);
INSERT INTO LOCATION VALUES('PILATES02', 10);
INSERT INTO LOCATION VALUES('SPINNING01', 15);
INSERT INTO LOCATION VALUES('SPINNING02', 18);

-- 개설강좌(강좌코드, 강사번호, 장소코드, 날짜, 시간)
INSERT INTO CLASS VALUES('20220613_A_SWIM01', 501, 'SWIM01', '20220613', '09:00');
INSERT INTO CLASS VALUES('20220614_A_SWIM01', 501, 'SWIM01', '20220614', '09:00');
INSERT INTO CLASS VALUES('20220613_A_DANCE01', 502, 'DANCE01', '20220613', '09:00');
INSERT INTO CLASS VALUES('20220614_B_DANCE02', 502, 'DANCE02', '20220614', '10:00');
INSERT INTO CLASS VALUES('20220615_A_DANCE01', 502, 'DANCE01', '20220615', '09:00');
INSERT INTO CLASS VALUES('20220616_B_DANCE02', 502, 'DANCE02', '20220616', '10:00');
INSERT INTO CLASS VALUES('20220617_A_DANCE02', 502, 'DANCE02', '20220617', '09:00');
INSERT INTO CLASS VALUES('20220618_B_DANCE01', 502, 'DANCE01', '20220618', '10:00');
INSERT INTO CLASS VALUES('20220619_A_DANCE01', 502, 'DANCE01', '20220619', '09:00');
INSERT INTO CLASS VALUES('20220620_B_DANCE01', 502, 'DANCE01', '20220620', '10:00');
INSERT INTO CLASS VALUES('20220621_A_DANCE01', 502, 'DANCE01', '20220621', '09:00');
INSERT INTO CLASS VALUES('20220622_B_DANCE01', 502, 'DANCE01', '20220622', '10:00');

-- 예약 내역(예약코드, 회원번호, 강좌코드, 신청일시, 예약상태)
INSERT INTO RESERVATION VALUES('SWIM101', 101, '20220613_A_SWIM01', '22/06/09 11:44:43.578000000', 1);
INSERT INTO RESERVATION VALUES('DANCE101', 101, '20220613_A_DANCE01', '22/06/10 11:50:00.900000000', 1);
INSERT INTO RESERVATION VALUES('DANCE102', 101, '20220614_B_DANCE02', '22/06/11 11:50:00.900000000', 1);
INSERT INTO RESERVATION VALUES('DANCE103', 101, '20220615_A_DANCE01', '22/06/12 11:50:00.900000000', 1);
INSERT INTO RESERVATION VALUES('DANCE104', 101, '20220616_B_DANCE02', '22/06/13 11:50:00.900000000', 1);
INSERT INTO RESERVATION VALUES('DANCE105', 101, '20220617_A_DANCE02', '22/06/14 11:50:00.900000000', 1);
INSERT INTO RESERVATION VALUES('DANCE106', 101, '20220618_B_DANCE01', '22/06/15 11:50:00.900000000', 0);
INSERT INTO RESERVATION VALUES('DANCE107', 101, '20220619_A_DANCE01', '22/06/16 11:50:00.900000000', 0);


-- 리뷰(리뷰번호, 강좌코드, 종목, 아이디, 제목, 내용, 조회수, IP, 작성일, 삭제여부, 게시글/댓글, 동일그룹, 그룹내순서)
INSERT INTO REVIEW VALUES(601, '20220613_A_SWIM01', 'SWIM', 'ID101', '재밌는 수영수업', '너무 알차고 즐거웠어요', 0, '000.000.000.001', '22/06/14', 1, 0, 601, 0);
INSERT INTO REVIEW VALUES(602, NULL, NULL, 'ID102', NULL, '저도 듣고싶네요~', NULL, '000.000.000.001', '22/06/14', 1, 1, 601, 1);
INSERT INTO REVIEW VALUES(603, NULL, NULL, 'ID101', NULL, '꼭 들어보세요!', NULL, '000.000.000.001', '22/06/14', 1, 2, 601, 2);
INSERT INTO REVIEW VALUES(604, NULL, NULL, 'ID101', NULL, '삭제할 대댓글', NULL, '000.000.000.001', '22/06/15', -1, 1, 601, 3);
INSERT INTO REVIEW VALUES(605, '20220613_A_DANCE01', 'DANCE', 'ID102', '즐거운 스포츠댄스', '정말 재밌습니다.', 0, '000.000.000.001', '22/06/15', 1, 0, 605, 0);

-- QnA 질문(질문번호, 아이디, 제목, 내용, 조회수, IP, 작성일)
INSERT INTO QUESTION VALUES(701, 'ID101', '화장실', '화장실은 어디에 있나요?', 0, '000.000.000.001', '22/06/19');
INSERT INTO QUESTION VALUES(702, 'ID102', '주소가 뭘까', '센터 주소를 알려주시오', 0,'000.000.000.001', '22/06/20');

-- QnA 답변(답변번호, 질문번호, 내용, 작성일)
INSERT INTO ANSWER VALUES(901, 701, '화장실은 매점 옆에 있습니다.', '22/06/21');

-- 공지사항(공지사항번호, 제목, 내용, IP, 조회수, 작성일, 수정일)
INSERT INTO NOTICE VALUES(1001, '카카오, 네이버 로그인 이용자분들 필독', '카카오 네이버 로그인 시 초기 비밀번호가' ||CHR(13)||CHR(10)|| '본인의 생일 ( ex) 1월 1일생일 경우 0101 )로 등록되어 있으니' ||CHR(13)||CHR(10)|| '비밀번호를 변경해 주시기 바랍니다.', '000.000.000.001', 0, '22/06/19', '22/06/20');
INSERT INTO NOTICE VALUES(1002, '공지1', '내용1', '000.000.000.001', 0, '22/06/20', '22/06/20');
INSERT INTO NOTICE VALUES(1003, '공지2', '내용2', '000.000.000.001', 0, '22/06/21', '22/06/21');
INSERT INTO NOTICE VALUES(1004, '공지3', '내용3', '000.000.000.001', 0, '22/06/22', '22/06/22');

COMMIT;