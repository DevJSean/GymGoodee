<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" type="image/png" href="../resources/images/favicon.png"/>
<link rel="stylesheet" href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css">
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/reset.css">
<title>GymGoodee : 회원가입</title>
<style>

	textarea {
		resize: none;
	}

	.blind {
		display: none;
	}
	
	.items, .item {
		padding-left: 20px;
		background-image: url(../resources/images/uncheck.png);
		background-size: 18px 18px;
		background-repeat: no-repeat;
	}
	
	.check {
		background-image: url(../resources/images/check.png);
	}
	
	.wrap {
        position: relative;
        height: 100%;
        letter-spacing: -0.5px;
    }
    .header .header_inner {
        margin: 0 auto;
        width: 743px;
        text-align: center;
        position: relative;
    }
    .header {
        padding-bottom: 30px;
    } 
    .header_inner .logo {
        display: inline-block;
        width: 200px;
        height: 100px;
        margin-top: 30px;
        background-image: url(../resources/images/linkedin_banner_image_1.png);
        background-size: 200px 100px;
        background-repeat: no-repeat;
        background-position: center;
    }
    .container {
        width: 743px;
        margin: 0 auto;
        position: relative;
        
    }
    .content {
    	width: 540px;
    	margin: 0 auto;
    }

</style>
<script src="../resources/js/jquery-3.6.0.js"></script>
<script src="http://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script>

	$(function(){
		$('#checkAll').on('click', function(){
			$('.checkOne').prop('checked', $('#checkAll').prop('checked'));
			if($('#checkAll').is(':checked')){
				$('.item, .items').addClass('check');
			} else {
				$('.item, .items').removeClass('check');
			}
		})

		
		
		$('.checkOne').on('click', function(){
			let checkAll = true;                         
			$.each($('.checkOne'), function(i, checkOne){
				if($(checkOne).is(':checked') == false){   
					$('#checkAll').prop('checked', false);
					$('.items').removeClass('check');
					checkAll = false;                      
					return false;
				}
			})
			if(checkAll){
				$('#checkAll').prop('checked', true);
				$('.items').addClass('check');
			}
		})
		
		$('.item, .items').on('click', function(){
			$(this).toggleClass('check');
		})
		
		$('#f').on('submit', function(event){
			if($('#service').is(':checked') == false || $('#privacy').is(':checked') == false) {
				alert("필수 약관에 모두 동의하세요.");
				event.preventDefault();
				return false;
			}
			return true;
		})
		
		$('#btnBack').on('click', function(){
			location.href="${contextPath}/member/loginPage";
		})
		
	})
	

</script>
</head>
<body>

	<div id="wrap" class="wrap">
        <header class="header">
            <div class="header_inner">
                <a href="${contextPath}" class="logo">
                    <span class="blind">GymGoodee</span>
                </a>
            </div>
        </header>
        <div class="container">
        	<div class="content">
		
				<form id="f" action="${contextPath}/member/signUpPage">
				
					
					<label for="checkAll" class="items">이용약관, 개인정보 수집 및 이용, 위치정보 이용약관(선택), <br>&nbsp;&nbsp;&nbsp;프로모션 정보 수신(선택)에 모두 동의합니다.</label><br><br><br>
					<input type="checkbox" id="checkAll" class="blind checkAll">
					
					
					<label for="service" class="item">이용약관에 동의합니다.(필수)</label><br>
					<input type="checkbox" id="service" class="blind checkOne">
					<textarea rows="8" cols="80" spellcheck="false" readonly> 여러분을 환영합니다. &#10;&#10; GymGoodee 서비스 및 제품(이하 ‘서비스’)을 이용해 주셔서 감사합니다. &#10; 본 약관은 다양한 GymGoodee 서비스의 이용과 관련하여 회원 또는 비회원과의 관계를 설명하며, 아울러 여러분의 GymGoodee 서비스 이용에 도움이 될 수 있는 유익한 정보를 포함하고 있습니다. &#10; GymGoodee 서비스를 이용하시거나 GymGoodee 서비스 회원으로 가입하실 경우 여러분은 본 약관 및 관련 운영 정책을 확인하거나 동의하게 되므로, 잠시 시간을 내시어 주의 깊게 살펴봐 주시기 바랍니다.
					&#10; 회원으로 가입하시면 GymGoodee 서비스를 보다 편리하게 이용할 수 있습니다. &#10; 여러분은 본 약관을 읽고 동의하신 후 회원 가입을 신청하실 수 있으며, GymGoodee는 이에 대한 승낙을 통해 회원 가입 절차를 완료하고 여러분께 GymGoodee 서비스 이용 계정(이하 ‘계정’)을 부여합니다. 계정이란 회원이 GymGoodee 서비스에 로그인한 이후 이용하는 서비스 이용 이력을 회원 별로 관리하기 위해 설정한 회원 식별 단위를 말합니다. 회원은 자신의 계정을 통해 좀더 다양한 GymGoodee 서비스를 보다 편리하게 이용할 수 있습니다. 
					&#10; GymGoodee는 여러분이 게재한 게시물이 GymGoodee 서비스를 통해 다른 이용자들에게 전달되어 우리 모두의 삶을 더욱 풍요롭게 해줄 것을 기대합니다. 게시물은 여러분이 타인 또는 자신이 보게 할 목적으로 GymGoodee 서비스 상에 게재한 부호, 문자, 그림, 사진, 링크 등으로 구성된 각종 콘텐츠 자체 또는 파일을 말합니다.
					&#10; GymGoodee는 여러분의 생각과 감정이 표현된 콘텐츠를 소중히 보호할 것을 약속드립니다. 여러분이 제작하여 게재한 게시물에 대한 지식재산권 등의 권리는 당연히 여러분에게 있습니다.
					&#10; 한편, GymGoodee 서비스를 통해 여러분이 게재한 게시물을 적법하게 제공하려면 해당 콘텐츠에 대한 저장, 복제, 수정, 공중 송신, 전시, 배포, 2차적 저작물 작성(단, 번역에 한함) 등의 이용 권한(기한과 지역 제한에 정함이 없으며, 별도 대가 지급이 없는 라이선스)이 필요합니다. 게시물 게재로 여러분은 GymGoodee에게 그러한 권한을 부여하게 되므로, 여러분은 이에 필요한 권리를 보유하고 있어야 합니다.
					&#10; GymGoodee는 여러분이 부여해 주신 콘텐츠 이용 권한을 저작권법 등 관련 법령에서 정하는 바에 따라 GymGoodee 서비스 내 노출, 서비스 홍보를 위한 활용, 서비스 운영, 개선 및 새로운 서비스 개발을 위한 연구, 웹 접근성 등 법률상 의무 준수, 외부 사이트에서의 검색, 수집 및 링크 허용을 위해서만 제한적으로 행사할 것입니다. 만약, 그 밖의 목적을 위해 부득이 여러분의 콘텐츠를 이용하고자 할 경우엔 사전에 여러분께 설명을 드리고 동의를 받도록 하겠습니다.
					&#10; 여러분의 개인정보를 소중히 보호합니다. GymGoodee는 서비스의 원활한 제공을 위하여 회원이 동의한 목적과 범위 내에서만 개인정보를 수집∙이용하며, 개인정보 보호 관련 법령에 따라 안전하게 관리합니다. 
					&#10; 타인의 권리를 존중해 주세요. 여러분이 무심코 게재한 게시물로 인해 타인의 저작권이 침해되거나 명예훼손 등 권리 침해가 발생할 수 있습니다. GymGoodee는 이에 대한 문제 해결을 위해 ‘정보통신망 이용촉진 및 정보보호 등에 관한 법률’ 및 ‘저작권법’ 등을 근거로 권리침해 주장자의 요청에 따른 게시물 게시중단, 원 게시자의 이의신청에 따른 해당 게시물 게시 재개 등을 내용으로 하는 게시중단요청서비스를 운영하고 있습니다.
					&#10; GymGoodee 서비스 이용과 관련하여 몇 가지 주의사항이 있습니다. GymGoodee는 여러분이 서비스를 자유롭고 편리하게 이용할 수 있도록 최선을 다하고 있습니다. 다만, 여러분이 GymGoodee 서비스를 보다 안전하게 이용하고 GymGoodee 서비스에서 여러분과 타인의 권리가 서로 존중되고 보호받으려면 여러분의 도움과 협조가 필요합니다. 여러분의 안전한 서비스 이용과 권리 보호를 위해 부득이 아래와 같은 경우 여러분의 게시물 게재나 GymGoodee 서비스 이용이 제한될 수 있으므로, 이에 대한 확인 및 준수를 요청 드립니다.
					&#10; 회원 가입 시 이름, 생년월일, 휴대전화번호 등의 정보를 허위로 기재해서는 안 됩니다. 회원 계정에 등록된 정보는 항상 정확한 최신 정보가 유지될 수 있도록 관리해 주세요. 	자신의 계정을 다른 사람에게 판매, 양도, 대여 또는 담보로 제공하거나 다른 사람에게 그 사용을 허락해서는 안 됩니다. 아울러 자신의 계정이 아닌 타인의 계정을 무단으로 사용해서는 안 됩니다.
					&#10; 타인에 대해 직접적이고 명백한 신체적 위협을 가하는 내용의 게시물, 타인의 자해 행위 또는 자살을 부추기거나 권장하는 내용의 게시물, 타인의 신상정보, 사생활 등 비공개 개인정보를 드러내는 내용의 게시물, 타인을 지속적으로 따돌리거나 괴롭히는 내용의 게시물, 성매매를 제안, 알선, 유인 또는 강요하는 내용의 게시물, 공공 안전에 대해 직접적이고 심각한 위협을 가하는 내용의 게시물은 제한될 수 있습니다.
					&#10; 관련 법령상 금지되거나 형사처벌의 대상이 되는 행위를 수행하거나 이를 교사 또는 방조하는 등의 범죄 관련 직접적인 위험이 확인된 게시물, 관련 법령에서 홍보, 광고, 판매 등을 금지하고 있는 물건 또는 서비스를 홍보, 광고, 판매하는 내용의 게시물, 타인의 지식재산권 등을 침해하거나 모욕, 사생활 침해 또는 명예훼손 등 타인의 권리를 침해하는 내용이 확인된 게시물은 제한될 수 있습니다. 자극적이고 노골적인 성행위를 묘사하는 등 타인에게 성적 수치심을 유발시키거나 왜곡된 성 의식 등을 야기할 수 있는 내용의 게시물, 타인에게 잔혹감 또는 혐오감을 일으킬 수 있는 폭력적이고 자극적인 내용의 게시물, 본인 이외의 자를 사칭하거나 허위사실을 주장하는 등 타인을 기만하는 내용의 게시물, 과도한 욕설, 비속어 등을 계속하여 반복적으로 사용하여 심한 혐오감 또는 불쾌감을 일으키는 내용의 게시물은 제한될 수 있습니다.
					&#10; 부득이 서비스 이용을 제한할 경우 합리적인 절차를 준수합니다. GymGoodee는 다양한 정보와 의견이 담긴 여러분의 콘텐츠를 소중히 다룰 것을 약속 드립니다만, 여러분이 게재한 게시물이 관련 법령, 본 약관, 게시물 운영정책, 서비스의 약관, 운영정책 등에 위배되는 경우, 부득이 이를 비공개 또는 삭제 처리하거나 게재를 거부할 수 있습니다. 다만, 이것이 GymGoodee가 모든 콘텐츠를 검토할 의무가 있다는 것을 의미하지는 않습니다.
					&#10;또한 여러분이 관련 법령, 본 약관, 계정 및 게시물 운영정책, 각 개별 서비스에서의 약관, 운영정책 등을 준수하지 않을 경우, GymGoodee는 여러분의 관련 행위 내용을 확인할 수 있으며, 그 확인 결과에 따라 GymGoodee 서비스 이용에 대한 주의를 당부하거나, GymGoodee 서비스 이용을 일부 또는 전부, 일시 또는 영구히 정지시키는 등 그 이용을 제한할 수 있습니다. 한편, 이러한 이용 제한에도 불구하고 더 이상 GymGoodee 서비스 이용계약의 온전한 유지를 기대하기 어려운 경우엔 부득이 여러분과의 이용계약을 해지할 수 있습니다.
					&#10; 부득이 여러분의 서비스 이용을 제한해야 할 경우 명백한 법령 위반이나 타인의 권리침해로서 긴급한 위험 또는 피해 차단이 요구되는 사안 외에는 위와 같은 단계적 서비스 이용제한 원칙을 준수 하겠습니다. 명백한 법령 위반 등을 이유로 부득이 서비스 이용을 즉시 영구 정지시키는 경우 서비스 이용을 통해 구매한 수강권은 모두 소멸되고 이에 대해 별도로 보상하지 않으므로 유의해 주시기 바랍니다. 
					&#10; GymGoodee의 잘못은 GymGoodee이 책임집니다. &#10; GymGoodee는 여러분이 GymGoodee 서비스를 이용함에 있어 GymGoodee의 고의 또는 과실로 인하여 손해를 입게 될 경우 관련 법령에 따라 여러분의 손해를 배상합니다. 다만, 천재지변 또는 이에 준하는 불가항력으로 인하여 GymGoodee가 서비스를 제공할 수 없거나 이용자의 고의 또는 과실로 인하여 서비스를 이용할 수 없어 발생한 손해에 대해서 GymGoodee는 책임을 부담하지 않습니다. &#10; 그리고 GymGoodee가 손해배상책임을 부담하는 경우에도 통상적으로 예견이 불가능하거나 특별한 사정으로 인한 특별 손해 또는 간접 손해, 기타 징벌적 손해에 대해서는 관련 법령에 특별한 규정이 없는 한 책임을 부담하지 않습니다. 한편, GymGoodee 서비스를 매개로 한 여러분과 다른 회원 간 또는 여러분과 비회원 간의 의견 교환, 거래 등에서 발생한 손해나 여러분이 서비스 상에 게재된 타인의 게시물 등의 콘텐츠를 신뢰함으로써 발생한 손해에 대해서도 GymGoodee는 특별한 사정이 없는 한 이에 대해 책임을 부담하지 않습니다.
					&#10; 언제든지 GymGoodee 서비스 이용계약을 해지하실 수 있습니다. &#10; GymGoodee에게는 참 안타까운 일입니다만, 회원은 언제든지 GymGoodee 서비스 이용계약 해지를 신청하여 회원에서 탈퇴할 수 있으며, 이 경우 GymGoodee는 관련 법령 등이 정하는 바에 따라 이를 지체 없이 처리하겠습니다. GymGoodee 서비스 이용계약이 해지되면, 관련 법령 및 개인정보처리방침에 따라 GymGoodee가 해당 회원의 정보를 보유할 수 있는 경우를 제외하고, 해당 회원 계정에 부속된 게시물 일체를 포함한 회원의 모든 데이터는 소멸됨과 동시에 복구할 수 없게 됩니다. 
					&#10; GymGoodee는 여러분의 소중한 의견에 귀 기울이겠습니다. 여러분은 언제든지 QNA를 통해 서비스 이용과 관련된 의견이나 개선사항을 전달할 수 있으며, GymGoodee는 합리적 범위 내에서 가능한 그 처리과정 및 결과를 여러분께 전달할 수 있도록 하겠습니다.
					&#10;공지 일자: 2022년 6월 30일
					&#10;적용 일자: 2022년 7월 13일
					&#10;GymGoodee 서비스와 관련하여 궁금하신 사항이 있으시면 &#10;고객센터(대표번호: 010 – 5646 - 6373/ 평일 09:00~18:00)로 문의 주시기 바랍니다.</textarea>
					<br><br>
					
					<label for="privacy" class="item">개인정보 수집에 동의합니다.(필수)</label><br>
					<input type="checkbox" id="privacy" class="blind checkOne">
					<textarea rows="8" cols="80" spellcheck="false" readonly> 개인정보보호법에 따라 GymGoodee에 회원가입 신청하시는 분께 수집하는 개인정보의 항목, 개인정보의 수집 및 이용목적, 개인정보의 보유 및 이용기간, 동의 거부권 및 동의 거부 시 불이익에 관한 사항을 안내 드리오니 자세히 읽은 후 동의하여 주시기 바랍니다.
						&#10; 수집하는 개인정보 &#10; 이용자가 예약, 게시판 등과 같이 개인화 혹은 회원제 서비스를 이용하기 위해 회원가입을 할 경우, GymGoodee는 서비스 이용을 위해 필요한 최소한의 개인정보를 수집합니다.
						&#10; 회원가입 시점에 GymGoodee가 이용자로부터 수집하는 개인정보는 아래와 같습니다. &#10; 회원 가입 시에 ‘아이디, 비밀번호, 이름, 생년월일, 성별, 휴대전화번호, 이메일 주소’를 필수항목으로 수집합니다. 
						&#10; 개인정보 수집 및 이용 동의를 거부할 권리 &#10; 이용자는 개인정보의 수집 및 이용 동의를 거부할 권리가 있습니다. 회원가입 시 수집하는 최소한의 개인정보, 즉, 필수 항목에 대한 수집 및 이용 동의를 거부하실 경우, 회원가입이 어려울 수 있습니다.</textarea>
					<br><br>
					
					<label for="location" class="item">위치정보 수집에 동의합니다.(선택)</label><br>
					<input type="checkbox" name="agreements" value="location" id="location" class="blind checkOne">  
					<textarea rows="8" cols="80" spellcheck="false" readonly> 위치기반서비스 이용약관에 동의하시면, 위치를 활용한 GymGoodee 위치기반 서비스를 이용할 수 있습니다.
						&#10; 제 1 조 (목적) &#10; 이 약관은 GymGoodee가 제공하는 위치기반서비스와 관련하여 회사와 개인위치정보주체와의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.
						&#10; 제 2 조 (약관 외 준칙) &#10; 이 약관에 명시되지 않은 사항은 위치정보의 보호 및 이용 등에 관한 법률, 개인정보보호법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률, 전기통신기본법, 전기통신사업법 등 관계법령과 회사의 이용약관 및 개인정보처리방침, 회사가 별도로 정한 지침 등에 의합니다.
						&#10; 제 3 조 (서비스 내용 및 요금) &#10; 회사는 위치정보사업자로부터 위치정보를 전달받아 아래와 같은 위치기반서비스를 제공합니다. 생활편의 서비스 제공: 주변 시설물 찾기, 날씨 등 생활 편의 서비스를 제공합니다. &#10; 위치기반서비스의 이용요금은 무료입니다.
						&#10; 제 4 조 (개인위치정보주체의 권리) &#10;① 개인위치정보주체는 개인위치정보 수집 범위 및 이용약관의 내용 중 일부 또는 개인위치정보의 이용ㆍ제공 목적, 제공받는 자의 범위 및 위치기반서비스의 일부에 대하여 동의를 유보할 수 있습니다. &#10;② 개인위치정보주체는 개인위치정보의 수집ㆍ이용ㆍ제공에 대한 동의의 전부 또는 일부를 철회할 수 있습니다. &#10;③ 개인위치정보주체는 언제든지 개인위치정보의 수집ㆍ이용ㆍ제공의 일시적인 중지를 요구할 수 있습니다. 이 경우 회사는 요구를 거절하지 아니하며, 이를 위한 기술적 수단을 갖추고 있습니다. &#10;④ 개인위치정보주체는 회사에 대하여 아래 자료의 열람 또는 고지를 요구할 수 있고, 당해 자료에 오류가 있는 경우에는 그 정정을 요구할 수 있습니다. 이 경우 회사는 정당한 이유 없이 요구를 거절하지 아니합니다.
						&#10; 제 5 조 (사업자 정보 및 위치정보 관리책임자) &#10;① 회사의 상호, 주소 및 연락처는 다음과 같습니다. &#10;- 상호: GymGoodee &#10;- 주소:  08505 서울시 금천구 가산디지털2로 509호(가산동, 대륭테크노타운3차) &#10;- 전화번호: 010-5646-6373 &#10;② 회사는 다음과 같이 위치정보 관리책임자를 지정하여 이용자들이 서비스 이용과정에서 발생한 민원사항 처리를 비롯하여 개인위치정보주체의 권리 보호를 위해 힘쓰고 있습니다. &#10;- 위치정보 관리책임자 : 이상호 &#10;- 메일 : 문의하기</textarea>
					<br><br>
					
					<label for="promotion" class="item">프로모션 정보 수신에 동의합니다.(선택)</label><br>
					<input type="checkbox" name="agreements" value="promotion" id="promotion" class="blind checkOne">
					<textarea rows="3" cols="80" spellcheck="false"  readonly> GymGoodee에서 제공하는 이벤트/혜택 등 다양한 정보를 휴대전화, 이메일로 받아보실 수 있습니다.</textarea>
					<br><br>
					
					<input type="button" value="취소" id="btnBack">
					<input type="submit" value="다음">
					
				</form>
			</div>
		</div>
	</div>
	
</body>
</html>