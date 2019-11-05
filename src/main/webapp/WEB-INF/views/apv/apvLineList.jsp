<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<jsp:include page="/WEB-INF/views/common/header.jsp">   
   <jsp:param value="결재라인관리" name="pageTitle"/>
</jsp:include>

<section>
        <!-- Begin Page Content -->
        <div class="container-fluid">

          <!-- Page Heading -->
         <!--  <p class="mb-4">DataTables is a third party plugin that is used to generate the demo table below. For more information about DataTables, please visit the <a target="_blank" href="https://datatables.net">official DataTables documentation</a>.</p>
 -->
          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3" >
            
              <!-- <h6 class="m-0 font-weight-bold text-primary">DataTables Example</h6> -->
              <div style="float: right;">
              	<input type="button" class="btn btn-primary mr-2 pull-right" onclick="apvLine_enroll()" value="결재라인 등록"/>
              </div>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-stripped" id="dataTable" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>결재라인번호</th>
                      <th>결재라인명</th>
                      <th>설명</th>
                    </tr>
                  </thead>
                  <tfoot>

                  </tfoot>
                  <tbody>

                  </tbody>
                </table>
              </div>
            </div>
          </div>

        </div>
        ${pageBar }
        <!-- /.container-fluid -->

      <!-- End of Main Content -->
      


</section>
      <script>
      	function apvLine_enroll(){
      		var url="${path}/apv/apvLineEnroll.do";
      		var name="양식등록"
            window.open(url,name,"width=1000,height=900,left=600");
      	}
      </script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>