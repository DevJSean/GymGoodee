<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js" integrity="sha256-6XMVI0zB8cRzfZjqKcD01PBsAy3FlDASrlC8SxCpInY=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">
<script>

	/* 페이지 로드 이벤트 */
	$(function(){
		
		
		//fnClassList();
		
		// 개설 날짜 선택하기
		$('#classDate').datepicker({	// 달력 나타나서 날짜 선택하기!
			'showOn' : 'focus',		// both 쓰면 옆에 버튼 생길 수 있다! / focus, button, both
			'dateFormat': "yymmdd"
		})
		
		// radio 선택 시 어떤 것을 선택했는지 알 수 있다.
		$(":radio[name=subject]").on('change',function(){
			var subject = $(this).attr('id');
			//alert(subject);
			
			fnGetTeacher(subject);
			fnGetLocation(subject)
		}) // change
		
		fnRegistClass();
		
		// 테스트
		
		fnPagingLink();
		fnList();
	})
	
	
	
	/* 함수 */
	
	// 0. 선택 사항들 초기화하기
	function fnInit(){
		$('input[name="subject"]').prop('checked',false);
		$("select#teachers option").remove();
		$("select#locations option").remove();
		$("#classDate").remove();
	}
	
	// 1. subject 담당인 강사 목록 가져오기
	function fnGetTeacher(subject){
		
		$.ajax({
			url : '${contextPath}/admin/teachersBySubject',
			type: 'GET',
			data : 'subject=' + subject,
			dataType: 'json',
			success : function(obj){
				$('#teachers').html('');
				$.each(obj.teachers, function(i,teacher){
					var res = '<option value="'+ teacher.teacherNo +'">' + teacher.teacherName +'</option>';
					$('#teachers').append(res);
				})
			}, error : function(jqXHR){
				
			}
			
		}) // ajax
		
		
	} // fnGetTeacher
	
	// 2. subject에 해당 하는 장소 목록 가져오기
	function fnGetLocation(subject){
		
		$.ajax({
			url : '${contextPath}/admin/locationsBySubject',
			type: 'GET',
			data : 'subject=' + subject.substr(0,2),
			dataType: 'json',
			success : function(obj){
				$('#locations').html('');
				$.each(obj.locations, function(i,location){
					var res = '<option value="'+ location.locationCode +'">' + location.locationCode +'</option>';
					$('#locations').append(res);
				})
			}, error : function(jqXHR){
				
			}
			
		}) // ajax
		
	} // fnGetLocation
	
	
	// 3. 강좌 개설하기 (POST 방식으로 INSERT 하기)
	function fnRegistClass(){
		
		$('#btnAdd').on('click',function(ev){
			// 강좌 코드, 강사번호, 장소코드, 날짜, 시간 정보를 CLASS 테이블에 INSERT 해야한다.
			// 강좌 코드 (날짜_시간_장소 형태로 생성)
			// 강사번호는 teacherNo, 장소코드는 locadtionCode 으로, 날짜는 $('#classDate').val(), 시간은 classTime으로 파라미터로 넘겨주면 된다.
			var subject = $(':radio[name=subject]:checked').val();
			if(typeof(subject) == 'undefined'){
				alert('종목을 선택하세요.');
				ev.preventDefault();
				return false;
			}
			
			if($('#classDate').val() == ''){
				alert('날짜 선택은 필수 입니다.');
				ev.preventDefault();
				return false;
			}
			
			$.ajax({
				url : '${contextPath}/admin/addClass',
				data: JSON.stringify(
					{
						'teacherNo': $('#teachers option:selected').val(),
						'locationCode':$('#locations option:selected').val(),
						'classDate': $('#classDate').val(),
						'classTime': $('#classTime option:selected').val()
					}
				),
				type: 'POST',
				contentType: 'application/json',
				dataType:'json',
				success : function(obj){
					if(obj.state == 501){
						alert('해당 강사는 이미 해당 시간대 강좌가 있습니다.');
						fnInit();
					}
					else{
						if(obj.res == 1){
							alert('강좌 개설에 성공했습니다.');
							//fnClassList();
							fnList();
						}
						else{
							alert('강좌 개설에 실패했습니다.');
						}						
					}
				},
				error: function(jqXHR){
					alert('예외코드[' + jqXHR.status + '] : ' + jqXHR.responseText);
				}
			}) // ajax	
			
			
		}) // click
		
	} // fnRegistClass
	
	///// 테스트 /////////////
	
	// 5. 페이징 링크 처리(page 전역변수 값을 링크의 data-page 값으로 바꾸고, fnList() 호출)
	function fnPagingLink(){
		$(document).on('click','.enable_link',function(){
			page = $(this).data('page');
			fnList();
		})
	} // fnPagingLink
	
	// 4. 개설강좌 목록 + page 전역변수
	var page = 1;
	function fnList(){
		$.ajax({
			/* 요청 */
			url : '${contextPath}/classes?page=' + page,
			type : 'GET',
			/* 응답 */
			dataType : 'json',
			success : function(obj){
				console.log(obj,classes);
				fnPrintClassList(obj.classes);
				fnPrintPaging(obj.p);
			},
			error : function(jqXHR){
				
			}
			
		}) // ajax
		
	} // fnList
	
	// 4-1) 강좌 목록 출력
	function fnPrintClassList(classes){
		$('#classes').empty();
		$.each(classes,function(i,registclass){
			var tr = $('<tr>');
			tr.append($('<td>').text(registclass.locationCode));
			tr.append($('<td>').text(registclass.teacherName));
			tr.append($('<td>').text(registclass.classDate));
			tr.append($('<td>').text(registclass.classTime));
			tr.appendTo($('#classes'));
			
		}) // each
		
		
	} // fnPrintClassList
	
	// 4-2) 페이징 정보 출력
	function fnPrintPaging(p){
		
		$('#paging').empty();
		
		var paging ='';
		
		// ◀◀ : 이전 블록으로 이동
		if(page <= p.pagePerBlock){
			paging += '<div class="disable_link">◀◀</div>';
		} else{			
			paging += '<div class="enable_link" data-page="'+ (p.beginPage - 1) +'">◀◀</div>';
		}
		
		// ◀  : 이전 페이지로 이동
		if(page == 1){
			paging += '<div class="disable_link">◀</div>';
		} else{			
			paging += '<div class="enable_link" data-page="'+ (page - 1) +'">◀</div>';
		}
		
		// 1 2 3 4 5 : 페이지 번호
		for(let i = p.beginPage; i<=p.endPage; i++){
			if(i == page){
				paging += '<div class="disable_link now_page">'+ i +'</div>';
			} else{
				paging += '<div class="enable_link" data-page="'+ i +'">'+ i +'</div>';				
			}
		}
		
		
		// ▶  : 다음 페이지로 이동
		if(page == p.totalPage){
			paging += '<div class="disable_link">▶</div>';
		} else{			
			paging += '<div class="enable_link" data-page="'+ (page + 1) +'">▶</div>';
		}
		
		// ▶▶ : 다음 블록으로 이동
		if(p.endPage == p.totalPage){
			paging += '<div class="disable_link">▶▶</div>';
		} else{			
			paging += '<div class="enable_link" data-page="'+ (p.endPage + 1) +'">▶▶</div>';
		}
		
		$('#paging').append(paging);
		
	} // fnPrintPaging
	
	
	
	///////////////// 테스트 끝 /////////////
	
	
	// 4) 개설강좌 목록 출력 
	function fnClassList(){
		$.ajax({
			url : '${contextPath}/admin/ClassList',
			type : 'GET',
			dataType : 'json',
			success: function(obj){
				$('#classes').empty();
				// obj에 res 와 classes 둘다 담자
				//console.log(obj);
				if(obj.res == 1){
					$.each(obj.classes, function(i,registclass){
						//console.log(registclass);
						var tr = $('<tr>');
						tr.append($('<td>').text(registclass.locationCode));
						tr.append($('<td>').text(registclass.teacherName));
						tr.append($('<td>').text(registclass.classDate));
						tr.append($('<td>').text(registclass.classTime));
						tr.appendTo($('#classes'));
					}) // each
				}
			},error : function(jqXHR){
				
			}
		
		}) // ajax
	} // fnClassList
	
</script>
<style>
	#paging{
		display : flex;
		justify-content: center;
		
	}
	#paging div{
		width : 32px;
		height : 20px;
		text-align: center;
	}
	.disable_link{
		color: lightgray;
	}
	.enable_link{
		cursor: pointer;
	}

</style>
</head>
<body>

	<h1>강좌 개설 페이지</h1>
	
	<hr>
	
	<!-- 강좌 선택하면 해당 강좌 선생님과, 해당 강좌 장소 보여주기 -->
	<!-- CLASS 테이블의 PK 는 '날짜_시간_장소' -->
	
	<!-- radio 선택했을 때의 이벤트 처리.... -->
	<!-- 강좌를 선택 했을 시, ajax 처리 하여 해당 강좌 선생님 선택, 장소 선택하여
		등록 버튼 눌렀을 때 pk를 위의 형태로 만들어서 insert 하는데 실패할 경우 이미 개설된 수업이므로
		불가능!
	-->
	
	개설하고자 하는 종목을 선택하세요!<br>
	<label for="SWIM">
		수영<input type="radio" name="subject" id="SWIM">	
	</label>
	<label for="PILATES">
		필라테스<input type="radio" name="subject" id="PILATES">	
	</label>
	<label for="SPINNING">
		스피닝<input type="radio" name="subject" id="SPINNING">	
	</label>
	<label for="DANCE">
		스포츠댄스<input type="radio" name="subject" id="DANCE">	
	</label>
	
	<hr>

	<form id="f">
		강사 선택
		<select id="teachers" name="teacherNo">
		</select>
		<br>
		장소 선택
		<select id="locations" name="locationCode">
		</select>
		<br>
		
		날짜 선택
		<input type="text" name="classDate" id="classDate">
		<br>
		
		시간 선택
		<select id="classTime" name="classTime">
			<option value="A">A</option>
			<option value="B">B</option>
			<option value="C">C</option>
			<option value="D">D</option>
		</select>
		<br><br>
		<input type="button" value="강좌 개설하기" id="btnAdd">
	</form>
	
	<hr>
	
	<h2>개설 강좌 목록</h2>
	<table border="1">
		<thead>
			<tr>
				<td>장소</td>
				<td>강사명</td>
				<td>날짜</td>
				<td>시간</td>
			</tr>
		</thead>
		<tbody id="classes">
			
		</tbody>
		<tfoot>
			<tr>
				<td colspan="4">
					<div id="paging"></div>
				</td>
			</tr>
			
		</tfoot>
	</table>
	
	
	
	
	
	
</body>
</html>