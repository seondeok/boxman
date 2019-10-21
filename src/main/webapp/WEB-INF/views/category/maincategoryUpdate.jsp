<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="path" value="${pageContext.request.contextPath}"/>

<jsp:include page="/WEB-INF/views/common/header.jsp">   
   <jsp:param value="메인카테고리 관리" name="tabTitle"/> 
   <jsp:param value="" name="pageTitle"/>
</jsp:include>

<section id="content">
	<div class="card shadow mb-4">
       <div class="card-header py-3">
         <h6 class="m-0 font-weight-bold text-primary">메인카테고리 목록</h6>
       </div>
       <div class="card-body">
         <div class="table-responsive">
           <div id="dataTable_wrapper" class="dataTables_wrapper dt-bootstrap4">
              <div class="row">
                 <div class="col-sm-12 col-md-6">
                    <div class="dataTables_length" id="dataTable_length">
                    </div>
                 </div>
                 <div class="col-sm-12 col-md-6">
                  <div id="dataTable_filter" class="dataTables_filter">

                  </div>
                 </div>
              </div>
              <div class="row">
              <form id = "enrollFrm">
				<table class="table">
							<tr>
								<th scope="col" colspan="2">메인 카테고리 추가</th>
							</tr>
      						<tr>
      						<td>
      							<input type = "text" class = "form-control" id = "mcName" name = "mcName"/>
      						</td>
         					<td>
				  		<button onclick = "maincategoryEnroll();" class="btn btn-light btn-icon-split">
                   		 <span class="icon text-gray-600">
                    	  <i class="fas fa-arrow-right"></i>
                   		 </span>
                   		 <span class="text">추가하기</span>
                 		 </button>
								</td>
      						</tr>
						</table>
				</form>
                 <div class="col-sm-12">
                    <table class="table table-striped table-hover" id="dataTable" width="100%" cellspacing="0" role="grid" aria-describedby="dataTable_info" style="width: 100%;">
                       <thead>
						<tr>
							<th scope="col">번호</th>
							<th scope="col">메인 카테고리</th>
							<th scope="col"></th>
						</tr>
                       </thead>
                       <tbody>
                          <c:forEach items="${list}" var="stuffMaincategory" varStatus = "v">
      							<tr>
         						<td>				
         						<c:if test="${param.cPage!=1 }">
									<c:out value="${v.count }"/>
								</c:if>
								</td>
         							<td>${stuffMaincategory.mcName}</td>
         							<td>
										<button type="button" class="btn btn-success mr-2"
										onclick="location.href='${pageContext.request.contextPath }/category/maincategoryDelete.do?mcName=${stuffMaincategory.mcName}'">삭제</button>
									</td>
      							</tr>
   						  </c:forEach>
                       </tbody>
                     </table>
                   </div>
                 </div>
               </div>
               </div>
               </div>
                 ${pageBar }
               </div>
	
</section>

<script>
function maincategoryEnroll(){
	$("#enrollFrm").attr("action","${path}/category/maincategoryEnrollEnd.do");
	$("#enrollFrm").submit();
}
</script>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>