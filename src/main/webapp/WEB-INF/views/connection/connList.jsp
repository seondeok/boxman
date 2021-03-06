<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="path" value="${pageContext.request.contextPath}"/>

<jsp:include page="/WEB-INF/views/common/header.jsp">   
   <jsp:param value="거래처 관리" name="tabTitle"/> 
</jsp:include>

<style>
th {
	text-align: center;
}
</style>

<section>

   <div class="card shadow mb-4">
       <div class="card-header py-3">
         <h6 class="m-0 font-weight-bold text-primary">거래처 목록</h6>
       </div>
       <div class="card-body">
         <div class="table-responsive">
           <div id="dataTable_wrapper" class="dataTables_wrapper dt-bootstrap4">
              <div class="row">
                 <div class="col-sm-12 col-md-6">
                 <form id="searchFrm">
                    <div class="dataTables_length" id="dataTable_length">
                       <label>Search:
							<select name="type" id="searchKeyword" class="form-control form-control-sm">
		                        <option value="conCode">거래처코드</option>
		                        <option value="conName">거래처명</option>
		                        <option value="conRepName">대표자명</option>
		                        <option value="conCateg">구분</option>
		                        <option value="conUseCk">사용구분</option>
		                     </select>
		                     <input type="search" class="form-control form-control-sm" name="data" aria-controls="dataTable">
						</label>
                  		<button type="button" onclick = "searchConnection();" class="btn btn-primary mr-2">
                            <span class="text">검색</span>
                       </button>
                    </div>
                   </form>
                 </div>
                 <div class="col-sm-12 col-md-6">
                  <div id="dataTable_filter" class="dataTables_filter">
                     <div style="float:right;">
                        <button type="button" onclick="location.href='${path}/connection/enrollConn.do'" class="btn btn-primary mr-2">
						        거래처 등록
						</button>
                    </div>
                  </div>
                 </div>
              </div>
              <div class="row">
                 <div class="col-sm-12">
                    <table class="table table-striped table-hover tablesorter" id="myTable" width="100%" cellspacing="0" role="grid" aria-describedby="dataTable_info" style="width: 100%;">
                       <thead>
                         <tr>
                             <th>거래처코드</th>
		                     <th>거래처명</th>
		                     <th>대표자명</th>
		                     <th>전화번호</th>
		                     <th>핸드폰번호</th>
		                     <th>구분</th>
		                     <th>사용구분</th>
		                     <th>이체정보</th>
		                     <th>주소</th>
                         </tr>
                       </thead>
                       <tbody>
                          <c:forEach items="${list }" var="c">
	                        <tr style="text-align:center;">
	                           <td><a href='${path }/connection/modifyConn.do?conCode=${c["CONCODE"]}&conTransCk=${c["CONTRANSCK"]}'><c:out value='${c["CONCODE"] }'/></a></td>
	                           <td><c:out value='${c["CONNAME"] }' /></td>
	                           <td><c:out value='${c["CONREPNAME"] }' /></td>
	                           <td><c:out value='${c["CONTEL"] }' /></td>
	                           <td><c:out value='${c["CONPHONE"] }' /></td>
	                           <td><c:out value='${c["CONCATEG"] }'/></td>
	                           <td><c:out value='${c["CONUSECK"] }' /></td>
	                           <td><c:out value='${c["CONTRANSCK"] }' /></td>
	                           <td style="text-align:left;"><c:out value='${c["CONADDR"] }' /></td>
	                        </tr>
	                     </c:forEach>
                       </tbody>
                     </table>
                   </div>
                 </div>
               </div>
         </div>
      </div>
      <div style="margin:0 auto; width:fit-content;">
		${pageBar }
      </div>
   </div>

</section>

<script>
function searchConnection(){
   $("#searchFrm").attr("action","${path}/connection/searchConnection.do");
   $("#searchFrm").submit();
}
//테이블 정렬
$(function() {
  $("#myTable").tablesorter();
});
</script>