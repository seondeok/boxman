<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>

<jsp:include page="/WEB-INF/views/common/header.jsp">   
   <jsp:param value="BOXMAN" name="tabTitle"/> 
   <jsp:param value="" name="pageTitle"/>
</jsp:include>
<style>
	div#userId-container{position:relative; padding:0px;}
	div#userId-container span.guide {display:none;font-size: 12px;position:absolute; top:12px; right:0px;}
	div#userId-container span.ok{color:green;}
	div#userId-container span.no{color:red;}
</style>
<section>
<div class="col-12 grid-margin">
   <div class="card">
     <div class="card-body">
       <form class="form-sample" id="empFrm" method="post" enctype="multipart/form-data">
         <p class="card-description"> Personal info </p>
         <div class="row">
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">이름</label>
               <div class="col-sm-9">
                 <input type="text" class="form-control" name="empName" id="empName" required>
               </div>
             </div>
           </div>
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">부서</label>
               <div class="col-sm-9">
                  <select name = "deptNo" id = "deptNo" class="form-control">
                        <option value = "0">해당 부서를 선택하세요</option>
                        <c:forEach items="${dept}" var="dept">
                           <option value = "<c:out value='${dept["DEPTNO"]}'/>"><c:out value='${dept["DEPTNAME"]}'/></option>
                        </c:forEach>
                     </select>
               </div>
             </div>
           </div>
         </div>
         <div class="row">
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">아이디</label>
               <div class="col-sm-9">
                 <div id = "userId-container">
	               <input type="text" class="form-control" placeholder="아이디 (4글자이상)" name="empId" id="empId" required>
	               <span class="guide ok okId">이 아이디는 사용할 수 있습니다</span>
	               <span class="guide no noId">이 아이디는 사용할 수 없습니다</span>
            	</div>
               </div>
             </div>
           </div>
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">직급</label>
               <div class="col-sm-9">
                  <select name = "jobNo" id = "jobNo" class="form-control">
                        <option value = "0">해당 직급을 선택하세요</option>
                        <c:forEach items="${job}" var="j">
                           <option value = "<c:out value='${j["JOBNO"]}'/>"><c:out value='${j["JOBNAME"]}'/></option>
                        </c:forEach>
                     </select>
               </div>
             </div>
           </div>
         </div>
         <div class="row">
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">비밀번호</label>
               <div class="col-sm-9">
                 <input type="password" class="form-control" name="password" id="pw" required>
               </div>
             </div>
           </div>
           <div class="col-md-6">
            <div class="form-group row">
              <label class="col-sm-3 col-form-label">연봉</label>
              <div class="col-sm-9">
                <input type="text" class="form-control" name="empSal" id="empSal" onkeypress="f_onlyNum();" onkeyup="f_setCommaValue(this);" required>
              </div>
            </div>
          </div>
         </div>
         <div class="row">
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">비밀번호확인</label>
               <div class="col-sm-9">
               	 <div id = "userId-container">
	                 <input type="password" class="form-control" name="pw2" id="pw2" required>
	                 <span class="guide ok okPw">비밀번호 확인이 일치합니다.</span>
		             <span class="guide no noPw">비밀번호가 일치하지 않습니다.</span>
	             </div>
               </div>
             </div>
           </div>
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">은행</label>
               <div class="col-sm-9">
                  <select name = "empBank" id = "empBank" class="form-control">
                        <option value = "0">은행을 선택하세요</option>
                        <option value = "국민은행">국민은행</option>
                        <option value = "농협은행">농협은행</option>
                        <option value = "새마을금고">새마을금고</option>
                        <option value = "신한은행">신한은행</option>
                        <option value = "우리은행">우리은행</option>
                        <option value = "카카오뱅크">카카오뱅크</option>
                        <option value = "하나은행">하나은행</option>
                     </select>
               </div>
             </div>
           </div>
         </div>
         <div class="row">
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">성별</label>
               <div class="col-sm-9">
                 <select class="form-control" name="empGender">
                   <option value="M">Male</option>
                   <option value="F">Female</option>
                 </select>
               </div>
             </div>
           </div>
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">계좌번호</label>
               <div class="col-sm-9">
                 <input type="text" class="form-control" name="empBankNum" id="empBankNum" required>
               </div>
             </div>
           </div>
         </div>
         <div class="row">
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">전화번호</label>
               <div class="col-sm-9" style="">
                 <input type="text" class="form-control" name="empPhone" placeholder="-없이 입력하세요" id="empPhone" maxlength="11" required>
               </div>
             </div>
           </div>
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">주민등록번호</label>
               <div class="col-sm-9">
                 <input type="text" class="form-control" name="empSSN" id="empSSN" placeholder="123456-1234567" maxlength="14" required>
               </div>
             </div>
           </div>
         </div>
         <div class="row">
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">이메일</label>
               <div class="col-sm-9" style="">
                 <input type="email" class="form-control" name="empEmail" id="empEmail" placeholder="abc@abc.com" required>
               </div>
             </div>
           </div>
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">주소</label>
               <div class="col-sm-9">
                   <input type="text" id="sample6_postcode" placeholder="우편번호" style="width:200px;display:inline;" class="form-control">
	               <input type="button" class="btn btn-success mr-2" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" style="float:right;"><br>
	               <input type="text" id="sample6_address" placeholder="주소" class="form-control" >
	               <input type="text" id="sample6_detailAddress" placeholder="상세주소" class="form-control" style="display:inline;">
	               <input type="text" id="sample6_extraAddress" placeholder="참고항목" class="form-control" style="display:inline;">
	               <input type="hidden" name="empAddr" id="empAddr"/>
               <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
               <script>
                   function sample6_execDaumPostcode() {
                       new daum.Postcode({
                           oncomplete: function(data) {
                               // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
               
                               // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                               // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                               var addr = ''; // 주소 변수
                               var extraAddr = ''; // 참고항목 변
               
                               //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                               if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                                   addr = data.roadAddress;
                               } else { // 사용자가 지번 주소를 선택했을 경우(J)
                                   addr = data.jibunAddress;
                               }
               
                               // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                               if(data.userSelectedType === 'R'){
                                   // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                                   // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                                   if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                                       extraAddr += data.bname;
                                   }
                                   // 건물명이 있고, 공동주택일 경우 추가한다.
                                   if(data.buildingName !== '' && data.apartment === 'Y'){
                                       extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                                   }
                                   // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                                   if(extraAddr !== ''){
                                       extraAddr = ' (' + extraAddr + ')';
                                   }
                                   // 조합된 참고항목을 해당 필드에 넣는다.
                                   document.getElementById("sample6_extraAddress").value = extraAddr;
                               
                               } else {
                                   document.getElementById("sample6_extraAddress").value = '';
                               }
               
                               // 우편번호와 주소 정보를 해당 필드에 넣는다.
                               document.getElementById('sample6_postcode').value = data.zonecode;
                               document.getElementById("sample6_address").value = addr;
                               // 커서를 상세주소 필드로 이동한다.
                               document.getElementById("sample6_detailAddress").focus();
                           }
                       }).open();
                   }
               </script>
               </div>
             </div>
         </div>
         </div>
         <div class="row">
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">사원사진</label>
               <div class="col-sm-9">
					<img src="#" style="width:200px; height:auto;display:none;" id="proImg"/>
				</div>
               <div class="custom-file">
                    <input type="file" class="custom-file-input" name="proImg" id="upFile1">
                    <label class="custom-file-label" for="upFile1">파일을 선택하세요</label>
                </div>
             </div>
           </div>
           <div class="col-md-6">
             <div class="form-group row">
               <label class="col-sm-3 col-form-label">결재도장등록</label>
               <div class="col-sm-9">
					<img src="#" style="width:200px; height:auto; display:none;" id="proImg"/>
				</div>
               <div class="custom-file">
                    <input type="file" class="custom-file-input" name="stampImg" id="upFile3">
                    <label class="custom-file-label" for="upFile3">파일을 선택하세요</label>
                </div>
             </div>
           </div>
         </div>
         <div style="margin:0 auto; width:fit-content;">
            <button type="button" class="btn btn-success mr-2" onclick="return validate();" style="width:150px;">등록</button>
         </div>
       </form>
   	</div>
   </div>
 </div>
</section>
<script>
	/* 아이디 중복검사 */
	$(function(){
		$('#empId').keyup(function(){
			var empId = $(this).val().trim();
			if(empId.length<4) {
				$(".guide").hide();
				return;
			}
			$.ajax({
				url:"${path}/emp/checkId.do",
				data:{"empId":empId},
				success:function(data){
					if(data == 0) {
						$("span.okId").show();
						$("span.noId").hide();
					} else {
						$("span.okId").hide();
						$("span.noId").show();
					}
				}
			});
		});
	});
	//파일등록시 
	$(function(){
		$('[name=proImg]').on('change', function(event){
			var fileName=this.files[0].name;
			var reader = new FileReader();
			var ext = $(this).val().split('.').pop().toLowerCase();
            var fileSize = (this).files[0].size;
            var maxSize = 1024*1024*1024;
            
            if($.inArray(ext, ['png','jpg','jpeg']) == -1) {
               alert("등록할 수 없는 확장자입니다.");
               $(this).val("");
               return;
            } 
            
            if(fileSize > maxSize) {
               alert("첨부파일 크기는 1GB 이내로 등록 가능합니다.");
               $(this).val("");
               return;
            }
			$(this).next('.custom-file-label').html(fileName);
			reader.onload = function(e) {
				$('#proImg').attr("src",e.target.result);
			}
			reader.readAsDataURL(this.files[0]);
		});
		$('[name=stampImg]').on('change', function(event){
			var fileName=this.files[0].name;
			var reader = new FileReader();
			var ext = $(this).val().split('.').pop().toLowerCase();
            var fileSize = (this).files[0].size;
            var maxSize = 1024*1024*1024;
            
            if($.inArray(ext, ['png','jpg','jpeg']) == -1) {
               alert("등록할 수 없는 확장자입니다.");
               $(this).val("");
               return;
            } 
            
            if(fileSize > maxSize) {
               alert("첨부파일 크기는 1GB 이내로 등록 가능합니다.");
               $(this).val("");
               return;
            }
         
			$(this).next('.custom-file-label').html(fileName);
			reader.onload = function(e) {
				$('#stampImg').attr("src",e.target.result);
			}
			reader.readAsDataURL(this.files[0]);
		});
	});
   
   //유효성검사
   $(function(){         
         $('#empPhone').on("keyup",function() {
   		  $(this).val($(this).val().replace(/[^0-9]/g, ""));
   	   	 });
         
         $('#pw2').on("keyup",function(){
	         var pw = $('#pw').val();
	         var pw2 = $('#pw2').val();
        	 if(pw == pw2) {
        		$("span.okPw").show();
				$("span.noPw").hide();
        	 } else {
        		$("span.okPw").hide();
 				$("span.noPw").show();
        	 }
         });
   });

   String.prototype.trim = function() {
       return this.replace(/(^\s*)|(\s*$)/gi, "");  
   }

   String.prototype.replaceAll = function(str1, str2) {  
       var temp_str = "";  
       if(this.trim() != "" && str1 != str2) {  
           temp_str = this.trim();  
           while (temp_str.indexOf(str1) > -1){  
               temp_str = temp_str.replace(str1, str2);  
           }  
       }  
       return temp_str;  
   }

   //input에 comma세팅
   function f_setCommaValue(el){
       var value = f_getOnlyNum(el);
       var temp = '';
       var idx = value.length % 3;
       if(idx>0 && value.length > 3){
           temp = value.substring(0, idx) + ',';
           value = value.substring(idx);
       }
       for(i=(value.length/3) - 1; i>0; i--){
           temp += value.substring(0, 3) + ',';
           value = value.substring(3); 
       }
       temp += value;
       el.value = temp;

   }

   // 숫자만 반환

   function f_getOnlyNum(el){
       var value = el.value;
       if(value.trim().length == 0){
           value = '0';
    	}
       value = value.replaceAll(',', '');
       value = parseInt(value, 10).toString();
       return value;
   }
  
   //숫자만 입력
   function f_onlyNum(){
       var key = event.keyCode;
       var messageArea = document.getElementById("ssnMessage");
       if(!(key==8||key==9||key==13||key==46||key==144||(key>=48&&key<=57)||key==110||key==190)){
           alert('숫자만 입력 가능합니다');
           event.returnValue = false;
       }

   }
   
   function validate() {
      var empAddr = $('#sample6_postcode').val();
      empAddr += "/" + $('#sample6_address').val();
      empAddr += "/" + $('#sample6_detailAddress').val();
      empAddr += "/" + $('#sample6_extraAddress').val();
      $('#empAddr').val(empAddr);
      
      var sal = $('#empSal').val();
      sal = sal.replaceAll(",","");
      $('#empSal').val(sal);
      
      if(empAddr==null || empAddr=='') {
    	  alert("주소를 입력하세요.");
    	  return false;
      }
      
      
      if($('span.noId').is(":visible")) {
    	  alert("아이디를 확인하세요.");
    	  return false;
      }
      
      if($('span.noPw').is(":visible")) {
    	  alert("비밀번호를 확인하세요.");
    	  return false;
      }
      if($('#empName').val()==null || $('#empName').val()=="") {
    	  alert("이름을 입력하세요.");
    	  return false;
      } 
      
      if($('#empId').val()==null || $('#empId').val()=="") {
    	  alert("아이디를 입력하세요.");
    	  return false;
      } 
      
      if($('#pw2').val()==null || $('#pw2').val()=="") {
    	  alert("비밀번호를 입력하세요.");
    	  return false;
      } 
      
      if($('#empPhone').val()==null || $('#empPhone').val()=="") {
    	  alert("전화번호를 입력하세요.");
    	  return false;
      } 
      
      if($('#empEmail').val()==null || $('#empEmail').val()=="") {
    	  alert("이메일을 입력하세요.");
    	  return false;
      } 
      
      if($('#empSal').val()==null || $('#empSal').val()=="") {
    	  alert("연봉을 입력하세요.");
    	  return false;
      } 
      
      if($('#empBankNum').val()==null || $('#empBankNum').val()=="") {
    	  alert("계좌번호를 입력하세요.");
    	  return false;
      } 
      
      if($('#empSSN').val()==null || $('#empSSN').val()=="") {
    	  alert("주민등록번호를 입력하세요.");
    	  return false;
      } 
      
      if($('#deptNo').val()=='0') {
    	  alert("부서를 선택하세요.");
    	  return false;
      } 
      
      if($('#jobNo').val()=='0') {
    	  alert("직급을 선택하세요.");
    	  return false;
      }
      
      if($('#empBank').val()=='0') {
    	  alert("은행을 선택하세요.");
    	  return false;
      }
      
      if($('#upFile1').val()==null || $('#upFile1').val()=="") {
    	  alert("사원사진을 등록해주세요.");
    	  return false;
      }
      if($('#upFile3').val()==null || $('#upFile3').val()=="") {
    	  alert("결재도장을 등록해주세요.");
    	  return false;
      }
      
      $('#empFrm').attr("action","${pageContext.request.contextPath}/emp/insertEmpEnd.do");
      $('#empFrm').submit();
   }
   
   
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>