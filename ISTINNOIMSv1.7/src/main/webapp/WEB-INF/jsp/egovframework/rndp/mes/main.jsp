<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://egovframework.gov/ctl/ui" prefix="ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="stylesheet" type="text/css" href="/js/jquery-ui-1.14.1/jquery-ui.min.css" />
<script src="/js/jquery-ui-1.14.1/jquery-ui.min.js"></script>
<script src="/js/Chart/ChartB.js"></script>
<script src='/js/fullcalendar.js'></script>

<script type="text/javascript">
$(document).ready(function() {
    $(document).on('click', '#menu-toggle-btn', function() {
 //       $('body').toggleClass('nav-open');
        $('body').toggleClass('nav-close');

        // 애니메이션이 끝나는 시점에 리사이즈 이벤트 발생 (차트 깨짐 방지)
        setTimeout(function() {
            window.dispatchEvent(new Event('resize'));
        }, 300);
    });
});


document.addEventListener('DOMContentLoaded', function () {
    var calendarEl = document.getElementById('calendar');

    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        dayMaxEvents: 2,
        
        events: function(info, successCallback, failureCallback) {
            
            $.ajax({
                url: '/mes/main/calendar.do',
                type: 'POST',
                dataType: 'json',
                data: {
                    calStart: info.startStr, 
                    calEnd: info.endStr
                },
                success: function(response) {
                    // Controller에서 받은 List<Map>을 그대로 넘겨줌
                    successCallback(response);
                },
                error: function(xhr, status, error) {
                    console.error("캘린더 데이터 로딩 실패:", error);
                    failureCallback(error);
                }
            });
        },
        // 이벤트 클릭 핸들러 추가
        eventClick: function(info) {
            info.jsEvent.preventDefault(); 

            if (info.event.url) {
                // 새 창에서 띄우고 싶다면 window.open(info.event.url);
                // 현재 창에서 이동하고 싶다면 아래 코드 사용
                location.href = info.event.url;
            }
        }
    });

    calendar.render();
});
		
/* 페이징 */
function fn_guestList(pageNo) {
	$('#mloader').show();
	document.frm.submit();
}

function fn_keyDown(){
	if(event.keyCode == 13){
		fn_guestList(1);
	}			
}

function nowDate(){
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1 < 10 ? "0" + (date.getMonth() + 1) : date.getMonth() + 1;
    var day = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
    var nowDate = year + "-" + month + "-" + day;
	
    return nowDate;
}


$(document).ready(function(){	
	datepickerSet('topStartDate', 'topEndDate');
	
	$('.tab_button').click(function () {
		const target = $(this).data('tab');
		$('.tab_button').removeClass('active');
		$(this).addClass('active');
		$('.tab_content').hide();
		$('#' + target).show();
	});
	$('.tab_button.active').trigger('click');
	
	
});






function setStartDate(d) {
	var settingDate = new Date();
	if (d === '1d') settingDate.setDate(settingDate.getDate() - 1);
	else if (d === '2d') settingDate.setDate(settingDate.getDate() - 2);
	else if (d === '3d') settingDate.setDate(settingDate.getDate() - 3);
	else if (d === 7) settingDate.setDate(settingDate.getDate() - 7);
	else if (d === 1) settingDate.setMonth(settingDate.getMonth() - 1);
	else settingDate.setMonth(settingDate.getMonth() - 3);

	// 날짜 입력
	$('#topStartDate').val(settingDate.format("yyyy-MM-dd"));
	
	document.getElementById('selectedDateBtnValue').value = d;
	
	applyActiveButton(d);

	fn_guestList(1);
}

function applyActiveButton(value) {
	// 모든 버튼에서 active 제거
	document.querySelectorAll('.select_date .date_btn').forEach(btn => {
		btn.classList.remove('active');
	});

	// 해당 id 조합 버튼에 active 부여
	const targetId = 'btn' + value;
	const targetBtn = document.getElementById(targetId);
	if (targetBtn) {
		targetBtn.classList.add('active');
	}
}

function moveDetail(url){
	$("#topStartDate").val("");
	$("#topEndDate").val("");
	if(url != ''){
		document.frm.action = url;
	}else{
		document.frm.action = "/mes/main.do";
	}
	document.frm.submit();
}
function setDate() {
	  document.getElementById('selectedDateBtnValue').value = '';
	}
</script>
<style>
	.ellipsis {
		max-width: 130px; 
		white-space: nowrap; 
		overflow: hidden; 
		text-overflow: ellipsis;
	}
.num_2 ul li:not(:first-child) {
  width: fit-content; 
  margin: 0 auto; 
}

.err_all,
.err_plus {
    padding-top: 0;
}

/* 달력 사이즈 조절 */
.fc .fc-toolbar.fc-header-toolbar {
    margin-bottom: 10px;
}
.fc .fc-view-harness {
    height: 380px !important;
}

/* 월 넘김 클릭시 아웃라인 제거 */
.fc .fc-button:focus:not(:focus-visible) {
  outline: none;
  box-shadow: none;
}

/* 헤더 스크롤 제거 */
.fc .fc-scrollgrid-section-header .fc-scroller {
  overflow: hidden !important;
}
.err_group {
    display: flex;
    justify-content: flex-end; 
    align-items: center; 
    gap: 8px;
}
.err_all,
.err_plus,
.eos_all
.eos_plus {
    padding-top: 0;
}


</style>
<form id="frm" name="frm" method="post"	action="/mes/main.do">
<input type="hidden" id="selectedDateBtnValue" name="searchTypeSet10" value="${vo.searchTypeSet10}">
<input type="hidden" id="calStart" name="calStart" value="${cvo.calStart}">
<input type="hidden" id="calEnd" name="calEnd" value="${cvo.calEnd}">

		 <div id="mes_container">
		 	<div class="main_top">
		 		<div class="main_title" style="font-size:23px; padding-left: 17px;">
					시스템 운영 현황
				</div>
				<div class="seoeun_top">
				  <div class="seoeun_row">
					<ul class="select_date">
						<li>
							<button type="button" class="date_btn" id="btn1d" onclick="setStartDate('1d');">
								1일전
							</button>
						</li>
						<li>
							<button type="button" class="date_btn" id="btn2d" onclick="setStartDate('2d');">
								2일전
							</button>
						</li>
						<li>
							<button type="button" class="date_btn" id="btn3d" onclick="setStartDate('3d');">
								3일전
							</button>
						</li>
						<li>
							<button type="button" class="date_btn" id="btn7" onclick="setStartDate(7);">
								1주일
							</button>
						</li>
						<li>
							<button type="button" class="date_btn"  id="btn1" onclick="setStartDate(1);">
								1개월
							</button>
						</li>
						<li>
							<button type="button" class="date_btn"  id="btn3" onclick="setStartDate(3);">
								3개월
							</button>
						</li>
					</ul>
					</div>
					<div class="range_select">
						<img src="../../images/main_img/113.svg" class="cal">
						<input type="text" name="topStartDate" id="topStartDate" value="${vo.topStartDate}" readonly class="inp_color" onchange="setDate()" />
						- <input type="text" name="topEndDate" id="topEndDate" value="${vo.topEndDate}" readonly class="inp_color"  onchange="setDate()"/>
					<!-- <button type="submit" class="basic_btn dark" onclick="fn_guestList(1)">검색</button> -->
					</div>
					<img src="../../images/main_img/2.svg" class="se_2"  onclick="fn_guestList(1)">
				</div>
		 	</div>
		 	<div class="dashboard_wrap">
		 		<div class="top">
		 			<div class="error">
			 			<div>
		 					<div class="err_text">
		 						<span>작업관리</span>
		 							<div class="err_group">
			 							<c:if test="${ass762 eq 'T' || staff.kAdminAuth eq 'T'}">
					 						<div class="err_all">
					 							<a onclick="moveDetail('/mes/blueprint/kw_blueprint_lf.do');" style="cursor:pointer;">viewAll</a>
					 						</div>
					 						<c:if test="${assW762 eq 'T' || staff.kAdminAuth eq 'T'}">
					 							<div class="err_plus" style="padding-top:0px;">
					 								<a onclick="moveDetail('/mes/blueprint/kw_blueprint_lf.do');" style="cursor:pointer;">+</a>
					 							</div>
				 							</c:if>
				 						</c:if>
		 							</div>
		 					</div>
			 				<%--	<div class="error_statu" >
			 						<div class="regist">
			 							<p class="r_1">${mainIssueInfo.eSearchWordA}</p>		 							
			 							<strong>계획</strong>
			 						</div>
			 						<div class="ing" style="padding:10px;">		 							
			 							<p class="r_1" style="margin: -1px 0 5px 0;">${mainIssueInfo.eSearchWordB}</p>
			 							<strong>처리중</strong>
			 						</div>
			 						<div class="complete">
			 							<p class="r_1">${mainIssueInfo.eSearchWordC}</p>
			 							<strong>완료</strong>
			 						</div>
			 					</div> --%>
								<table class="dash_table">
									<!-- <thead>
										<tr>
											<th>No.</th>
											<th>자산유형 </th>
											<th>요청내용 </th>
											<th>상태</th>
											<th>요청일자</th>
										</tr>
									</thead> -->
									<thead>
										<tr>
											<th width="8%">No.</th>
											<th width="30%">작업시작일시</th>
											<th width="50%">작업내용</th>
											<th width="12%">작업상태</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="list" items="${mainWorkListList}" varStatus="i" end="11">
											<tr <c:if test="${ass762 eq 'T' || staff.kAdminAuth eq 'T'}">onclick="moveDetail('/mes/blueprint/kw_blueprint_vf.do?eChangeKey=${list.eChangeKey}');" </c:if> style="cursor:pointer;">
													<td width="40px"> ${i.count}</td>
													<td>
														${empty list.eWorkStart ? '-' : list.eWorkStart}
													</td>												
													<td class="ellipsis">${list.eReqContent}</td>
													<td>${list.eIsInterruptedName}</td>
											</tr>
										</c:forEach>
										 <c:forEach var="i" begin="${fn:length(mainWorkListList) + 1}" end="12">
										      <tr>
										        <td>${i}</td>
										        <td>-</td>
										        <td>-</td>
										        <td>-</td>
										      </tr>
									    </c:forEach>
									</tbody>
								</table>
							</div>
		 			</div>
		 			<div class="device">
		 				<div class="err_text">
	 						<span>장비현황</span>
 							<div class="err_group">
		 						<c:if test="${ass742 eq 'T' || staff.kAdminAuth eq 'T'}">
		 						<div class="err_all">
		 							<a onclick="moveDetail('/mes/asset/kw_asset_lf.do');" style="cursor:pointer;">viewAll</a>
		 						</div>
		 						</c:if>
	  							<div class="err_plus"> 
	  								<a <c:if test="${ass766 eq 'T' || staff.kAdminAuth eq 'T'}">onclick="moveDetail('/mes/asset/kw_asset_if.do');" </c:if> style="cursor:pointer;">+</a> 
	  							</div> 
  							</div>
	 					</div>
		 				<div class="tabs">
		 					<div class="tab">
		 						<button type="button" class="tab_button active" data-tab="all_content">자산유형별</button>
		 						<button type="button" class="tab_button" data-tab="programming_content">제조사별</button>
		 					</div>
		 					<div class="tab_contents">
			 					<div class="tab_content" id="all_content">
							        <div id="containerGraph1div" <c:if test="${ass742 eq 'T' || staff.kAdminAuth eq 'T'}"> onclick="moveDetail('/mes/asset/kw_asset_lf.do');" </c:if>>
							       	 <canvas id="containerGraph1" ></canvas>
							        </div>
							        <div class="list_graph_1">
										<div class="list_graph_nw"><!-- 네트워크 -->
											<img src="../../images/main_img/4.svg" class="top_cycle" />
<!-- 											<img src="../../images/main_img/107.svg" />	 -->
											<c:forEach var="assetTypeList" items="${assetTypeList}" varStatus="j">										
											<c:if test="${assetTypeList.aRowNo eq '1'}">
												<span style="font-size:13px;">${assetTypeList.aAssetModel}</span>
												<p><c:out value="${assetTypeList.aAssetCost == 0 ? '-' : assetTypeList.aAssetCost}" /></p>
											</c:if>
											</c:forEach>
										</div>
										<div class="list_graph_ba"><!-- 기반시설-->	
											<img src="../../images/main_img/5.svg" class="top_cycle" />
<!-- 											<img src="../../images/main_img/51.svg" /> -->
											<c:forEach var="assetTypeList" items="${assetTypeList}" varStatus="j">										
											<c:if test="${assetTypeList.aRowNo eq '2'}">
												<span style="font-size:13px;">${assetTypeList.aAssetModel}</span>
												<p><c:out value="${assetTypeList.aAssetCost == 0 ? '-' : assetTypeList.aAssetCost}" /></p>
											</c:if>
											</c:forEach>
										</div>
										<div class="list_graph_pc"><!-- pc-->
											<img src="../../images/main_img/8.svg" class="top_cycle" />
<!-- 											<img src="../../images/main_img/65.svg" /> -->
											<c:forEach var="assetTypeList" items="${assetTypeList}" varStatus="j">										
											<c:if test="${assetTypeList.aRowNo eq '3'}">
												<span style="font-size:13px;">${assetTypeList.aAssetModel}</span>
												<p><c:out value="${assetTypeList.aAssetCost == 0 ? '-' : assetTypeList.aAssetCost}" /></p>
											</c:if>
											</c:forEach>
										</div>
										<div class="list_graph_sc"><!-- 보안 -->
											<img src="../../images/main_img/9.svg" class="top_cycle" />
<!-- 											<img src="../../images/main_img/53.svg" /> -->
											<c:forEach var="assetTypeList" items="${assetTypeList}" varStatus="j">										
											<c:if test="${assetTypeList.aRowNo eq '4'}">
												<span style="font-size:13px;">${assetTypeList.aAssetModel}</span>
												<p><c:out value="${assetTypeList.aAssetCost == 0 ? '-' : assetTypeList.aAssetCost}" /></p>
											</c:if>
											</c:forEach>
										</div>
										<div class="list_graph_sv"><!-- 서버-->
											<img src="../../images/main_img/10.svg" class="top_cycle" />
<!-- 											<img src="../../images/main_img/63.svg" /> -->
											<c:forEach var="assetTypeList" items="${assetTypeList}" varStatus="j">										
											<c:if test="${assetTypeList.aRowNo eq '5'}">
												<span style="font-size:13px;">${assetTypeList.aAssetModel}</span>
												<p><c:out value="${assetTypeList.aAssetCost == 0 ? '-' : assetTypeList.aAssetCost}" /></p>
											</c:if>
											</c:forEach>
										</div>
									</div>
							    </div>
							</div>
							<div class="tab_content" id="programming_content">
							        <div id="containerGraph2div" <c:if test="${ass742 eq 'T' || staff.kAdminAuth eq 'T'}"> onclick="moveDetail('/mes/asset/kw_asset_lf.do');" </c:if>>
							       	 <canvas id="containerGraph2"></canvas>
							        </div>
							        <div class="list_graph_1">
										<div class="list_graph_nw"><!-- 네트워크 -->
											<img src="../../images/main_img/4.svg" class="top_cycle" />
<!-- 											<img src="../../images/main_img/107.svg" />	 -->
											<c:forEach var="assetMakerList" items="${assetMakerList}" varStatus="j">										
											<c:if test="${assetMakerList.aRowNo eq '1'}">
												<span style="font-size:13px;">${assetMakerList.aAssetModel}</span>
												<p><c:out value="${assetMakerList.aAssetCost == 0 ? '-' : assetMakerList.aAssetCost}" /></p>
											</c:if>
											</c:forEach>
										</div>
										<div class="list_graph_ba"><!-- 기반시설-->
											<img src="../../images/main_img/5.svg" class="top_cycle" />
<!-- 											<img src="../../images/main_img/51.svg" /> -->
											<c:forEach var="assetMakerList" items="${assetMakerList}" varStatus="j">										
											<c:if test="${assetMakerList.aRowNo eq '2'}">
												<span style="font-size:13px;">${assetMakerList.aAssetModel}</span>
												<p><c:out value="${assetMakerList.aAssetCost == 0 ? '-' : assetMakerList.aAssetCost}" /></p>
											</c:if>
											</c:forEach>
										</div>
										<div class="list_graph_pc"><!-- pc-->
											<img src="../../images/main_img/8.svg" class="top_cycle" />									
<!-- 											<img src="../../images/main_img/65.svg" /> -->
											<c:forEach var="assetMakerList" items="${assetMakerList}" varStatus="j">										
											<c:if test="${assetMakerList.aRowNo eq '3'}">
												<span style="font-size:13px;">${assetMakerList.aAssetModel}</span>
												<p><c:out value="${assetMakerList.aAssetCost == 0 ? '-' : assetMakerList.aAssetCost}" /></p>
											</c:if>
											</c:forEach>
										</div>
										<div class="list_graph_sc"><!-- 보안 -->
											<img src="../../images/main_img/9.svg" class="top_cycle" />
<!-- 											<img src="../../images/main_img/53.svg" /> -->
											<c:forEach var="assetMakerList" items="${assetMakerList}" varStatus="j">										
											<c:if test="${assetMakerList.aRowNo eq '4'}">
												<span style="font-size:13px;">${assetMakerList.aAssetModel}</span>
												<p><c:out value="${assetMakerList.aAssetCost == 0 ? '-' : assetMakerList.aAssetCost}" /></p>
											</c:if>
											</c:forEach>
										</div>
										<div class="list_graph_sv"><!-- 서버-->
											<img src="../../images/main_img/10.svg" class="top_cycle" />
<!-- 											<img src="../../images/main_img/63.svg" /> -->
											<c:forEach var="assetMakerList" items="${assetMakerList}" varStatus="j">										
											<c:if test="${assetMakerList.aRowNo eq '5'}">
												<span style="font-size:13px;">${assetMakerList.aAssetModel}</span>
												<p><c:out value="${assetMakerList.aAssetCost == 0 ? '-' : assetMakerList.aAssetCost}" /></p>
											</c:if>
											</c:forEach>
										</div>
									</div>
							    </div>
		 				</div>
		 			</div>
		 			<div class="error">
		 				<div class="err_text">
	 						<span>일정관리</span>
	 					</div>
		 				<div id='calendar'></div>	
		 			</div>
		 			
		 		</div>
		 		<div class="btm">
		 			<div>
		 				<div class="eos_text">
	 						<span>EoS</span>
 							<div class="err_group">
		 						<c:if test="${ass742 eq 'T' || staff.kAdminAuth eq 'T'}">
		 						<div class="eos_all">
		 							<a onclick="moveDetail('/mes/asset/kw_asset_lf.do');" style="cursor:pointer;">viewAll</a>
		 						</div>
		 						</c:if>
	 							<div class="eos_plus"> 
	 								<a <c:if test="${ass766 eq 'T' || staff.kAdminAuth eq 'T'}">onclick="moveDetail('/mes/asset/kw_asset_if.do');" </c:if> style="cursor:pointer;">+</a>
	  							</div> 
  							</div>
	 					</div>
		 				<table  class="dash_table" >
							<thead>
								<tr>
									<th>No.</th>
									<th>대상</th>
									<th>유효기간</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="alist" items="${assetEosList}" varStatus="a" end="4">
									<tr <c:if test="${ass742 eq 'T' || staff.kAdminAuth eq 'T'}">  onclick="moveDetail('/mes/asset/kw_asset_vf.do?eAssetKey=${alist.eAssetKey}');" </c:if>>
										<td colspan="1" width="10%">${a.count }</td>
										<td colspan="1">${alist.eAssetModel }</td>
										<td colspan="1">${alist.eEosDate } : ${alist.searchTypeSet1 } </td>
									</tr>
								</c:forEach>
								 <c:forEach var="i" begin="${fn:length(assetEosList) + 1}" end="5">
								      <tr>
								        <td width="10%">${i}</td>
								        <td>-</td>
								        <td>-</td>
								      </tr>
							    </c:forEach>
							</tbody>
						</table>
		 			</div>
		 			<div>
		 				<div class="eos_text">
	 						<span>EoL</span>
 							<div class="err_group">
		 						<c:if test="${ass742 eq 'T' || staff.kAdminAuth eq 'T'}">
		 						<div class="eos_all">
		 							<a onclick="moveDetail('/mes/asset/kw_asset_lf.do');" style="cursor:pointer;">viewAll</a> 
		 						</div>
		 						</c:if>
	  							<div class="eos_plus"> 
	  								<a <c:if test="${ass766 eq 'T' || staff.kAdminAuth eq 'T'}">onclick="moveDetail('/mes/asset/kw_asset_if.do');" </c:if> style="cursor:pointer;">+</a> 
	  							</div> 
  							</div>
	 					</div>
		 				<table class="dash_table" >
							<thead>
								<tr>
									<th>No.</th>
									<th>대상</th>
									<th>유효기간</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="blist" items="${assetEolList}" varStatus="b" end="4">
									<tr <c:if test="${ass742 eq 'T' || staff.kAdminAuth eq 'T'}"> onclick="moveDetail('/mes/asset/kw_asset_vf.do?eAssetKey=${blist.eAssetKey}');" </c:if>>
										<td colspan="1" width="10%">${b.count }</td>
										<td colspan="1">${blist.eAssetModel }</td>
										<td colspan="1">${blist.eEolDate } : ${blist.searchTypeSet2 } </td>
									</tr>
								</c:forEach>
								 <c:forEach var="i" begin="${fn:length(assetEolList) + 1}" end="5">
								      <tr>
								        <td width="10%">${i}</td>
								        <td>-</td>
								        <td>-</td>
								      </tr>
							    </c:forEach>
							</tbody>
						</table>
		 			</div>
		 			<div>
		 				<div class="eos_text">
	 						<span>라이선스</span>
 							<div class="err_group">
		 						<c:if test="${ass754 eq 'T' || staff.kAdminAuth eq 'T'}">
		 						<div class="eos_all">
		 							<a onclick="moveDetail('/mes/asset/kw_Software_Register_lf.do');" style="cursor:pointer;">viewAll</a> 
		 						</div>
		 						</c:if>
	  							<div class="eos_plus"> 
	  								<a <c:if test="${ass766 eq 'T' || staff.kAdminAuth eq 'T'}">onclick="moveDetail('/mes/asset/kw_Software_Register_if.do');" </c:if> style="cursor:pointer;">+</a> 
	  							</div> 
  							</div>
	 					</div>
		 				<table class="dash_table" >
							<thead>
								<tr>
									<th>No.</th>
									<th>대상</th>
									<th>유효기간</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="clist" items="${mainSoftwareList}" varStatus="c" end="4">
									<tr <c:if test="${ass754 eq 'T' || staff.kAdminAuth eq 'T'}">  onclick="moveDetail('/mes/asset/kw_Software_Register_vf.do?eSWRegisterKey=${clist.eSWRegisterKey}');" </c:if>>
										<td colspan="1" width="10%">${c.count }</td>
										<td colspan="1">${clist.eProductName }</td>
										<td colspan="1">${clist.eEndDate } : ${clist.searchTypeSet1 } </td>
									</tr>
								</c:forEach>
								 <c:forEach var="i" begin="${fn:length(mainSoftwareList) + 1}" end="5">
								      <tr>
								        <td width="10%">${i}</td>
								        <td>-</td>
								        <td>-</td>
								      </tr>
							    </c:forEach>
							</tbody>
						</table>
		 			</div>
		 			<div>
		 				<div class="eos_text">
	 						<span>노후장비</span>
 							<div class="err_group">
		 						<c:if test="${ass742 eq 'T' || staff.kAdminAuth eq 'T'}">
		 						<div class="eos_all">
		 							<a onclick="moveDetail('/mes/asset/kw_asset_lf.do');"style="cursor:pointer;">viewAll</a> 
		 						</div>
		 						</c:if> 
	  							<div class="eos_plus"> 
	  								<a <c:if test="${ass766 eq 'T' || staff.kAdminAuth eq 'T'}">onclick="moveDetail('/mes/asset/kw_asset_if.do');" </c:if> style="cursor:pointer;">+</a> 
	  							</div> 
  							</div>
	 					</div>
		 				<table class="dash_table" >
							<thead>
								<tr>
									<th>No.</th>
									<th>대상</th>
									<th>도입일자(내구연수)</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="dlist" items="${mainLifeStatusList}" varStatus="d" end="4">
									<tr <c:if test="${ass742 eq 'T' || staff.kAdminAuth eq 'T'}"> onclick="moveDetail('/mes/asset/kw_asset_vf.do?eAssetKey=${dlist.eAssetKey}');" </c:if>>
										<td colspan="1" width="10%">${d.count }</td>
										<%--	<td colspan="1">${dlist.aAssetName }</td>   --%>
										<td colspan="1">${dlist.aAssetModel }</td>
										<td colspan="1">${dlist.eAssetDate }(${dlist.eLifespan }) </td>
									</tr>
								</c:forEach>
								 <c:forEach var="i" begin="${fn:length(mainLifeStatusList) + 1}" end="5">
								      <tr>
								        <td width="10%">${i}</td>
								        <td>-</td>
								        <td>-</td>
								      </tr>
							    </c:forEach>
							</tbody>
						</table>
		 			</div>
		 		</div>
		 	</div>
		</div>
	</form>

							
						<c:forEach var="assetMakerList" items="${assetMakerList}" varStatus="j">
							<input type="hidden" id="aAssetMaker_${j.index}" name="aAssetMaker" value="${assetMakerList.aAssetMaker}">
							<input type="hidden" id="aAssetCost_${j.index}" name="aAssetCost" value="${assetMakerList.aAssetCost}">
						</c:forEach>
						<c:forEach var="assetTypeList" items="${assetTypeList}" varStatus="j">
							<input type="hidden" id="aAssetType_${j.index}" name="aAssetType" value="${assetTypeList.aAssetType}">
							<input type="hidden" id="aAssetTypeCost_${j.index}" name="aAssetTypeCost" value="${assetTypeList.aAssetCost}">
						</c:forEach>

<script>
window.onload = function() {
	  // 데이터 추출
	  const sAssetTypeCost = document.getElementsByName('aAssetTypeCost');
	  const sAssetTypeCostValue = Array.from(sAssetTypeCost).map(el => parseInt(el.value));

	  const sAssetType = document.getElementsByName('aAssetType');
	  const sAssetTypeValue = Array.from(sAssetType).map(el => el.value);

	  const sAssetmcCount = document.getElementsByName('aAssetCost');
	  const sAssetmcCountValue = Array.from(sAssetmcCount).map(el => parseInt(el.value));

	  const sAssetMaker = document.getElementsByName('aAssetMaker');
	  const sAssetMakerValue = Array.from(sAssetMaker).map(el => el.value);

	  // ctx 변수 이름 분리 (중복 방지)
	  const ctx1 = document.getElementById('containerGraph1').getContext('2d');
	  const ctx2 = document.getElementById('containerGraph2').getContext('2d');

	  var maxY1 = 0;

	  if (Array.isArray(sAssetTypeCostValue) && sAssetTypeCostValue.length > 0) {
	    maxY1 = Math.max.apply(null, sAssetTypeCostValue);
	  }

		var yTicks1 = {
		  min: 0,
		  beginAtZero: true,
		  fontColor: '#6A6D75'
		};
		
		if (maxY1 <= 6) {
		  yTicks1.stepSize = 1;
		  yTicks1.max = 6;
		}
		
	   var maxY2 = 0;

	    if (Array.isArray(sAssetmcCountValue) && sAssetmcCountValue.length > 0) {
	      maxY2 = Math.max.apply(null, sAssetmcCountValue);
	    }

		var yTicks2 = {
		  min: 0,
		  beginAtZero: true,
		  fontColor: '#6A6D75'
		};
		
		if (maxY2 <= 6) {
		  yTicks2.stepSize = 1;
		  yTicks2.max = 6;
		}
		
	  // containerGraph1: sAssetTypeValue + sAssetTypeCostValue 사용, 막대그래프
	  new Chart(ctx1, {
		  type: 'bar',
		  data: {
		    labels: sAssetTypeValue,
		    datasets: [{
		      label: '식',
		      data: sAssetTypeCostValue,
		      backgroundColor: [
		        '#013d92', '#005cd3', '#a28cf8', '#37afc5', '#fdbf00',
		        '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40'
		      ],
		      borderWidth: 2,
		      borderColor: '#fff'
		    }]
		  },
		  options: {
		    responsive: true,
		    maintainAspectRatio: false,
		    legend: { display: false },
		
		    scales: {
		      yAxes: [{
		        ticks: yTicks1,
		        gridLines: {
		          display: true
		        }
		      }],
		      xAxes: [{
		        ticks: {
		          fontColor: '#6A6D75',
		          callback: function(value) {
		            return value.length > 12 ? value.substring(0, 12) + '...' : value;
		          }
		        },
		        gridLines: {
		          display: false
		        }
		      }]
		    },
		
		    tooltips: {
		      callbacks: {
		        label: function(tooltipItem) {
		          return Math.round(tooltipItem.yLabel) + '식';
		        }
		      }
		    }
		  }
		});

	  // containerGraph2: sAssetMakerValue + sAssetmcCountValue 사용, 막대그래프
	  new Chart(ctx2, {
		  type: 'bar',
		  data: {
		    labels: sAssetMakerValue,
		    datasets: [{
		      label: '식',
		      data: sAssetmcCountValue,
		      backgroundColor: [
		        '#013d92', '#005cd3', '#a28cf8', '#37afc5', '#fdbf00',
		        '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40'
		      ],
		      borderWidth: 2,
		      borderColor: '#fff'
		    }]
		  },
		  options: {
		    responsive: true,
		    maintainAspectRatio: false,
		    legend: { display: false },
		
		    scales: {
		      yAxes: [{
		        ticks: yTicks2,
		        gridLines: {
		          display: true
		        }
		      }],
		      xAxes: [{
		        ticks: {
		          fontColor: '#6A6D75',
		          callback: function(value) {
		            return value.length > 12 ? value.substring(0, 12) + '...' : value;
		          }
		        },
		        gridLines: {
		          display: false
		        }
		      }]
		    },
		
		    tooltips: {
		      callbacks: {
		        label: function(tooltipItem) {
		          return Math.round(tooltipItem.yLabel) + '식';
		        }
		      }
		    }
		  }
		});
	};
	
	const savedValue = document.getElementById('selectedDateBtnValue').value;
	if (savedValue) {
		applyActiveButton(savedValue);
	}
 </script>


<style>
/* 대시보드 화면 넓게보기 */
/* [1] 최상위 레이아웃 및 브라우저 깨짐 방지 */
#main_container {
/*    min-width: 1200px !important;
    padding: 63px 32px 12px 80px !important; */
    min-width: 1480px !important;
    padding: 63px 32px 12px 280px !important;
    width: 100% !important;
    transition: padding-left 0.3s ease;
}

/* [2] 사이드바 및 토글 상태 제어 */
#side-nav {
/*    left:  -260px !important; */
    left: 0px !important;
    transition: left 0.3s ease !important;
}
body.nav-open #side-nav {
    left: 0 !important;
}
body.nav-open #main_container {
    padding-left: 280px !important; /* 사이드바 열릴 때 여백 복구 */
    min-width: 1480px !important; 
}
body.nav-close #side-nav {
    left: -260px !important;
}
body.nav-close #main_container {
    padding-left: 80px !important; 
    min-width: 1200px !important; 
}

/* [3] 대시보드 메인 컨테이너 */
#mes_container {
    width: 100% !important;
    max-width: none !important;
    margin: 0 !important;
    padding: 10px !important;
}

/* [4] 대시보드 행(Row) 설정: 높이 균등화(Stretch) */
.dashboard_wrap, 
.dashboard_wrap .top, 
.dashboard_wrap .btm {
    width: 100% !important;
    display: flex !important;
    flex-wrap: nowrap !important; /* 박스 떨어짐 방지 */
    gap: 20px;
}

.dashboard_wrap .top {
    align-items: stretch !important; /* 모든 박스 높이를 가장 큰 박스에 맞춤 */
}

/* [5] 박스 공통 설정 및 너비 배분 */
.dashboard_wrap .top > div, 
.dashboard_wrap .btm > div {
    display: flex !important;
    flex-direction: column !important;
    min-width: 200px !important;
    height: auto !important;
}

/* 윗줄(top) 3분할 / 아랫줄(btm) 4분할 */
.dashboard_wrap .top > div { flex: 1 1 calc(33.333% - 20px) !important; max-width: 33.333% !important; }
.dashboard_wrap .btm > div { flex: 1 1 calc(25% - 20px) !important; max-width: 25% !important; }

/* [6] 첫 번째 박스 (테이블 & 제목 보호) */
.dashboard_wrap .top > div:nth-child(1) .err_text {
    flex: 0 0 auto !important; /* 제목 영역 찌그러짐 방지 */
    width: 100% !important;
}

.dashboard_wrap .top > div:nth-child(1) > div:not(.err_text) {
    flex-grow: 1 !important; /* 제목 제외 나머지 영역 확장 */
    display: flex !important;
    flex-direction: column !important;
}

.dashboard_wrap .top > div:nth-child(1) .dash_table {
    flex-grow: 1 !important;
    height: 100% !important;
    width: 100% !important;
    table-layout: fixed !important;
}

/* [7] 두 번째 박스 (Chart.js 그래프) */
#containerGraph1div, #containerGraph2div {
    width: 100% !important;
    height: 350px !important; /* 그래프 높이 기준 */
    position: relative;
}
#containerGraph1, #containerGraph2 { width: 100% !important; height: 100% !important; }

/* [8] 세 번째 박스 (FullCalendar 달력) */
.dashboard_wrap .top > div:nth-child(3) #calendar {
    flex-grow: 1 !important;
    display: flex !important;
    flex-direction: column !important;
}
.fc { flex-grow: 1 !important; height: 100% !important; min-height: 0 !important; }

/* [9] 탭 컨텐츠 및 공통 테이블 */
.tab_content { width: 100% !important; }
.tab_content.active { display: block !important; }
.dash_table { width: 100% !important; }

/* [10] 햄버거 토글 버튼 디자인 */
#menu-toggle-btn {
    position: fixed !important;
    bottom: 30px !important;
    left: 30px !important;
    z-index: 999999 !important;
    width: 50px;
    height: 50px;
    background: #4869fb;
/*    background: #101935; */
    color: white;
    border-radius: 50%;
    border: none;
    cursor: pointer;
    box-shadow: 0 4px 15px rgba(0,0,0,0.3);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    opacity: 0.7;
    transition: all 0.3s;
}
#menu-toggle-btn:hover { opacity: 1; transform: scale(1.1); background: #4869fb; }
</style>