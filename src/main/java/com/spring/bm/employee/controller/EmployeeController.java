package com.spring.bm.employee.controller;

import java.io.File;
import java.sql.Date;
import java.text.ParseException;
import java.net.PasswordAuthentication;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.aspectj.bridge.Message;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.spring.bm.common.PageBarFactory;
import com.spring.bm.common.encrypt.MyEncrypt;
import com.spring.bm.department.model.service.DepartmentService;
import com.spring.bm.empjob.model.service.EmpJobService;
import com.spring.bm.employee.model.service.EmployeeService;
import com.spring.bm.employee.model.vo.EmpFile;

@Controller
public class EmployeeController {

	private Logger logger=LoggerFactory.getLogger(EmployeeController.class);

	@Autowired
	EmployeeService service;
	@Autowired
	DepartmentService dService;
	@Autowired
	EmpJobService jService;
	@Autowired
	BCryptPasswordEncoder pwEncoder;
	@Autowired
	MyEncrypt enc;

	/* 사원등록 */
	@RequestMapping("/emp/insertEmp.do")	//사원등록 폼으로 전환
	public String insertEmp(Model model) {

		List<Map<String, String>> dept = dService.selectDeptList();
		model.addAttribute("dept", dept);

		List<Map<String, String>> job = jService.empJobList();
		model.addAttribute("job", job);

		return "emp/empEnroll";
	}

	/* 사원리스트 불러오기 */
	@RequestMapping("/emp/empList.do")
	public ModelAndView empList(@RequestParam(value="cPage", 
	required=false, defaultValue="0") int cPage) {

		int numPerPage = 10;
		List<Map<String,String>> list = service.selectEmpList(cPage, numPerPage);
		int totalCount = service.selectEmpCount();

		ModelAndView mv=new ModelAndView();
		mv.addObject("pageBar", PageBarFactory.getPageBar(totalCount, cPage, numPerPage, "/bm/emp/empList.do"));
		mv.addObject("count", totalCount);
		mv.addObject("list", list);
		mv.setViewName("emp/empList");
		return mv;
	}

	/* 사원상세보기 */
	@RequestMapping("/emp/selectEmpOne.do")
	public ModelAndView selectEmpOne(int empNo, String temp) {
		Map<String, Object> empMap = service.selectEmpOne(empNo);
		try {
			empMap.replace("EMPSSN", enc.decrypt(String.valueOf(empMap.get("EMPSSN"))));
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		List<EmpFile> list = service.selectEmpFileList(empNo);

		Map<String, Object> dept = dService.selectDeptOne(Integer.parseInt(String.valueOf(empMap.get("DEPTNO"))));
		Map<String, Object> job = jService.selectEmpJobOne(Integer.parseInt(String.valueOf(empMap.get("JOBNO"))));
		List<Map<String, String>> deptList = dService.selectDeptList();
		List<Map<String, String>> jobList = jService.empJobList();
		String strAddr = String.valueOf(empMap.get("EMPADDR"));
		String[] addr = strAddr.split("/");

		ModelAndView mv = new ModelAndView();
		mv.addObject("emp", empMap);
		mv.addObject("addr", addr);
		mv.addObject("dept", dept);
		mv.addObject("job", job);
		mv.addObject("deptList", deptList);
		mv.addObject("jobList", jobList);
		mv.addObject("list", list);
		mv.setViewName("emp/empOne");

		return mv;
	}

	/* 사원로그인*/
	@RequestMapping("/bfLogin/loginEmp.do")
	public ModelAndView empLogin(@RequestParam Map<String,Object> map,HttpSession session) {

		Map<String, Object> m = service.selectLoginEmp(map);
		System.out.println(m.get("EMPNO"));

		ModelAndView mv = new ModelAndView();
		String msg = "";
		String loc = "";
		//		if(m.get("EMPPASSWORD").equals(map.get("empPassword"))) {
		if(m==null) {
			msg = "존재하지 않는 아이디입니다.";
			loc="/";
		}else if (pwEncoder.matches((CharSequence) map.get("empPassword"),(String)m.get("EMPPASSWORD"))) {
			msg = "로그인 성공";
			loc="/common/main.do";
			session.setAttribute("loginEmp", m);//HttpSession 사용
			session.setMaxInactiveInterval(60*60);//세션유효시간 1분
		} else if(pwEncoder.matches((CharSequence) map.get("empPassword"), (String)m.get("EMPPASSWORD"))==false){
			msg = "비밀번호가 일치하지 않습니다.";
			loc="/";
		}else {
			msg = "로그인 실패";
			loc="/";
		}

		mv.addObject("msg", msg);
		mv.addObject("loc", loc);
		mv.setViewName("common/msg");

		return mv;
	}

	/* 사원로그아웃*/
	@RequestMapping("/emp/logoutEmp.do")
	public String empLogout(HttpSession session) {
		session.invalidate();//세션 삭제
		return "redirect:/";
	}

	/* 사원등록 */
	@RequestMapping("/emp/insertEmpEnd.do")	//사원 등록 완료
	public ModelAndView insertEmpEnd(@RequestParam Map<String, String> param,
			//			@RequestParam(value="upFile", required=false) MultipartFile[] upFile,
			@RequestParam(value="proImg", required=false) MultipartFile proImg,
			@RequestParam(value="stampImg", required=false) MultipartFile stampImg,
			HttpServletRequest request) {

		logger.debug(param.get("password"));
		String empPassword = pwEncoder.encode((String)param.get("password"));
		
		try {
			param.replace("empSSN", enc.encrypt(String.valueOf(param.get("empSSN"))));
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		param.put("empPassword", empPassword);

		String saveDir = request.getSession().getServletContext().getRealPath("/resources/upload/emp");

		List<EmpFile> fileList = new ArrayList();

		File dir = new File(saveDir);

		if(!dir.exists()) logger.debug("생성결과 : " + dir.mkdir());
		if(!proImg.isEmpty()) {
			String oriFileName=proImg.getOriginalFilename();
			String ext=oriFileName.substring(oriFileName.lastIndexOf("."));
			//규칙설정
			SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd_HHMMssSSS");
			int rdv=(int)(Math.random()*1000);
			String reName=sdf.format(System.currentTimeMillis())+"_"+rdv+ext;
			//파일 실제 저장하기
			try {
				proImg.transferTo(new File(saveDir+"/"+reName));
			}catch (Exception e) {//IlligalStateException|IOException
				e.printStackTrace();
			}
			EmpFile ef = new EmpFile();
			ef.setEfcName("증명사진");
			ef.setEfOrgName(oriFileName);
			ef.setEfReName(reName);
			fileList.add(ef);
		}
		if(!stampImg.isEmpty()) {
			String oriFileName=stampImg.getOriginalFilename();
			String ext=oriFileName.substring(oriFileName.lastIndexOf("."));
			//규칙설정
			SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd_HHMMssSSS");
			int rdv=(int)(Math.random()*1000);
			String reName=sdf.format(System.currentTimeMillis())+"_"+rdv+ext;
			//파일 실제 저장하기
			try {
				stampImg.transferTo(new File(saveDir+"/"+reName));
			}catch (Exception e) {//IlligalStateException|IOException
				e.printStackTrace();
			}
			EmpFile ef = new EmpFile();
			ef.setEfcName("결재도장");
			ef.setEfOrgName(oriFileName);
			ef.setEfReName(reName);
			fileList.add(ef);
		}

		int result = 0;
		try {
			result=service.insertEmp(param,fileList);
		}catch (Exception e) {
			e.printStackTrace();
		}

		String msg = "";
		String loc = "/emp/empList.do";
		if(result > 0) {
			msg = param.get("empName") + "사원이 등록되었습니다.";
		} else {
			msg = param.get("empName") + "사원등록이 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();

		mv.addObject("msg", msg);
		mv.addObject("loc", loc);
		mv.setViewName("common/msg");

		return mv;
	}
	/* 사원등록끝 */

	/* 사원검색 */
	@RequestMapping("/emp/searchEmp.do")
	public ModelAndView searchEmp(@RequestParam(value="cPage",required=false, defaultValue="0") int cPage,
			@RequestParam Map<String, Object> param) {

		int numPerPage = 10;
		param.put("cPage", cPage);
		param.put("numPerPage", numPerPage);
		List<Map<String, String>> list = service.selectEmpSearchList(param);
		int totalCount = service.selectEmpSearchCount(param);

		ModelAndView mv=new ModelAndView();
		mv.addObject("pageBar", PageBarFactory.getPageBar(totalCount, cPage, numPerPage, "/bm/emp/empList.do"));
		mv.addObject("count", totalCount);
		mv.addObject("list", list);
		mv.setViewName("emp/empList");
		return mv;
	}

	/* 아이디중복확인 */
	@RequestMapping("/emp/checkId.do")
	@ResponseBody
	public int responsBody(String empId, Model model) throws JsonProcessingException {

		return service.checkId(empId);
	}

	/* 사원수정 */
	@RequestMapping("/emp/updateEmpEnd.do")
	public ModelAndView updateEmpEnd(@RequestParam Map<String, Object> param,
			@RequestParam(value="proImg", required=false) MultipartFile proImg,
			@RequestParam(value="stampImg", required=false) MultipartFile stampImg,
			HttpServletRequest request
			) {

		String saveDir = request.getSession().getServletContext().getRealPath("/resources/upload/emp");

		List<EmpFile> fileList = new ArrayList();
		List<EmpFile> oriFileList = service.selectEmpFileList(Integer.parseInt(String.valueOf(param.get("empNo"))));

		File dir = new File(saveDir);

		if(!dir.exists()) logger.debug("생성결과 : " + dir.mkdir());

		for(EmpFile efc : oriFileList) {

			if(!proImg.isEmpty()) {
				String oriFileName=proImg.getOriginalFilename();
				if(efc.getEfcName().equals("증명사진") && !oriFileName.equals(efc.getEfOrgName())) {
					int result = 0;
					try {
						result = service.deleteEmpFile(efc.getEfNo());
					} catch (Exception e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
					if(result > 0) {
						String ext=oriFileName.substring(oriFileName.lastIndexOf("."));
						//규칙설정
						SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd_HHMMssSSS");
						int rdv=(int)(Math.random()*1000);
						String reName=sdf.format(System.currentTimeMillis())+"_"+rdv+ext;
						//파일 실제 저장하기
						try {
							proImg.transferTo(new File(saveDir+"/"+reName));
						}catch (Exception e) {//IlligalStateException|IOException
							e.printStackTrace();
						}
						EmpFile ef = new EmpFile();
						ef.setEfcName("증명사진");
						ef.setEfOrgName(oriFileName);
						ef.setEfReName(reName);
						fileList.add(ef);
					}
				}
			}
			if(!stampImg.isEmpty()) {
				String oriFileName=stampImg.getOriginalFilename();
				if(efc.getEfcName().equals("결재도장") && !oriFileName.equals(efc.getEfOrgName())) {
					int result = 0;
					try {
						result = service.deleteEmpFile(efc.getEfNo());
					} catch (Exception e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
					if(result > 0) {
						String ext=oriFileName.substring(oriFileName.lastIndexOf("."));
						//규칙설정
						SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd_HHMMssSSS");
						int rdv=(int)(Math.random()*1000);
						String reName=sdf.format(System.currentTimeMillis())+"_"+rdv+ext;
						//파일 실제 저장하기
						try {
							stampImg.transferTo(new File(saveDir+"/"+reName));
						}catch (Exception e) {//IlligalStateException|IOException
							e.printStackTrace();
						}
						EmpFile ef = new EmpFile();
						ef.setEfcName("결재도장");
						ef.setEfOrgName(oriFileName);
						ef.setEfReName(reName);
						fileList.add(ef);
					}
				}
			}
		}

		int result = 0;
		try {
			result=service.updateEmp(param,fileList);
		}catch (Exception e) {
			e.printStackTrace();
		}

		String msg = "";
		String loc = "/emp/selectEmpOne.do?empNo="+param.get("empNo");
		if(result > 0) {
			msg = param.get("empName") + "사원이 수정되었습니다.";
		} else {
			msg = param.get("empName") + "사원수정이 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();

		mv.addObject("msg", msg);
		mv.addObject("loc", loc);
		mv.setViewName("common/msg");

		return mv;
	}
	
	/* 비밀번호 변경 팝업창 */
	@RequestMapping("/emp/updatePassword.do")
	public ModelAndView updatePassword(String empNo) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("empNo", empNo);
		mv.setViewName("emp/empUpPassword");
		return mv;
	}
	
	/* 비밀번호 변경 */
	@RequestMapping("/emp/updatePasswordEnd.do")
	@ResponseBody
	public int responsBody(@RequestParam Map<String, Object> param, Model model) throws JsonProcessingException {
		String empPassword = pwEncoder.encode((String)param.get("empPassword"));
		param.put("empPassword", empPassword);
		int result = 0;
		try {
			result = service.updatePassword(param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/* 출퇴근위치정보 확인/출근입력 */
	@RequestMapping("/emp/empGotoWork.do")
	@ResponseBody
	public int responseBody(@RequestParam Map<String, Object> param, Model model) {
		int result = 0;
		result = service.checkLocation(param);		//위치확인
		if(result > 0) {	//위치가 맞을 경우
			try {
				result = service.insertGotoWork(param);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return result;
	}
	
	/* 퇴근입력 */
	@RequestMapping("/emp/empOffWork.do")
	@ResponseBody
	public int responseBody1(@RequestParam Map<String, Object> param, Model model) {
		int result = 0;
		result = service.checkLocation(param);		//위치확인
		if(result > 0) {	//위치가 맞을 경우
			try {
				result = service.updateOffWork(param);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return result;
	}
	
	/* 근태하나보기 */
	@RequestMapping("/emp/selectAttenOne.do")
	@ResponseBody
	public int responseBody2(@RequestParam Map<String, Object> param, Model model) {
		Map<String, Object> map = service.selectAttenOne(param);
		int result = 0;
		if(map!=null) {
			result = 1;
		}
		return result;
	}
	
	/* 근태현황리스트 출력 */
	@RequestMapping("/emp/selectAttenList.do")
	public ModelAndView selectAttenList(@RequestParam Map<String, Object> param,
			@RequestParam(value="cPage", required=false, defaultValue="0") int cPage) {
		int numPerPage = 10;
		List<Map<String,String>> list = new ArrayList();
		list = service.selectAttenList(param, cPage, numPerPage);		
		int totalCount = service.selectAttenCount(param);
		
		String startStr = String.valueOf(param.get("startDay")).trim();
		String endStr = String.valueOf(param.get("endDay")).trim();
		Date startDay = null;
		Date endDay = null;
		ModelAndView mv=new ModelAndView();
		if(!startStr.equals("null") && !endStr.equals("null")) {
			startDay = Date.valueOf(startStr);
			endDay = Date.valueOf(endStr);
			mv.addObject("startDay",startDay);
			mv.addObject("endDay",endDay);
		}
		
		mv.addObject("pageBar", PageBarFactory.getPageBar(totalCount, cPage, numPerPage, "/bm/emp/selectAttenList.do"));
		mv.addObject("temp", String.valueOf(param.get("temp")));
		mv.addObject("count", totalCount);
		mv.addObject("list", list);
		mv.setViewName("emp/empAttendanceList");
		return mv;
	}
	
	/* 휴가리스트출력 */
	@RequestMapping("/emp/selectDayOffList.do")
	public ModelAndView selectDayOffList(@RequestParam Map<String, Object> param,
			@RequestParam(value="cPage", required=false, defaultValue="0") int cPage) {
		int numPerPage = 10;
		List<Map<String,String>> list = new ArrayList();

		list = service.selectDayOffList(param, cPage, numPerPage);		
		int totalCount = service.selectDayOffCount(param);
		
		String startStr = String.valueOf(param.get("startDay")).trim();
		String endStr = String.valueOf(param.get("endDay")).trim();
		Date startDay = null;
		Date endDay = null;
		ModelAndView mv=new ModelAndView();
		if(!startStr.equals("null") && !endStr.equals("null")) {
			startDay = Date.valueOf(startStr);
			endDay = Date.valueOf(endStr);
			mv.addObject("startDay",startDay);
			mv.addObject("endDay",endDay);
		}
		
		mv.addObject("pageBar", PageBarFactory.getPageBar(totalCount, cPage, numPerPage, "/bm/emp/selectAttenList.do"));
		mv.addObject("temp", String.valueOf(param.get("temp")));
		mv.addObject("count", totalCount);
		mv.addObject("list", list);
		mv.setViewName("emp/empDayOffList");
		return mv;
	}
	
	/* 출장리스트출력 */
	@RequestMapping("/emp/selectBTList.do")
	public ModelAndView selectBTList(@RequestParam Map<String, Object> param,
			@RequestParam(value="cPage", required=false, defaultValue="0") int cPage) {
		int numPerPage = 10;
		List<Map<String,String>> list = new ArrayList();

		list = service.selectBTList(param, cPage, numPerPage);		
		int totalCount = service.selectBTCount(param);
		
		String startStr = String.valueOf(param.get("startDay")).trim();
		String endStr = String.valueOf(param.get("endDay")).trim();
		Date startDay = null;
		Date endDay = null;
		ModelAndView mv=new ModelAndView();
		if(!startStr.equals("null") && !endStr.equals("null")) {
			startDay = Date.valueOf(startStr);
			endDay = Date.valueOf(endStr);
			mv.addObject("startDay",startDay);
			mv.addObject("endDay",endDay);
		}
		
		mv.addObject("pageBar", PageBarFactory.getPageBar(totalCount, cPage, numPerPage, "/bm/emp/selectAttenList.do"));
		mv.addObject("temp", String.valueOf(param.get("temp")));
		mv.addObject("count", totalCount);
		mv.addObject("list", list);
		mv.setViewName("emp/empBTList");
		return mv;
	}
	
	/*근태수정*/
	@RequestMapping("/emp/updateAtten.do")
	public ModelAndView updateAtten(@RequestParam Map<String, Object> param) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> map = new HashMap();
		map = service.selectAttenNoOne(param);
		mv.addObject("att", map);
		mv.addObject("temp", ""+param.get("temp"));
		mv.setViewName("emp/empAttendanceOne");
		return mv;
	}
	
	/* 근태수정완료 */
	@RequestMapping("/emp/updateAttenEnd.do")
	public ModelAndView updateAttenEnd(@RequestParam Map<String, Object> param) {
		ModelAndView mv = new ModelAndView();
		
		int result = 0;
		if((""+param.get("temp")).equals("my")) {
			try {
				logger.debug("야야");
				result = service.insertUpAttendance(param);
				if(result > 0) {
					//근태수정요청 결재로 이동
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		Map<String, Object> map = new HashMap();
		map = service.selectAttenNoOne(param);
		mv.addObject("att", map);
		mv.setViewName("emp/empAttendanceOne");
		return mv;
	}
	
	/* 휴가신청 */
	@RequestMapping("/emp/empDayOffForm.do")
	public ModelAndView insertDayOff(@RequestParam Map<String, Object> param) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> map = new HashMap();
		int empNo = Integer.parseInt(String.valueOf(param.get("empNo")));
		map = service.selectEmpOne(empNo);
		// 올해 휴가 신청 내역 있는지 조회
		map.put("temp", "my");
		map.put("empNo", empNo);
		int result = service.selectDayOffCount(param);
		if(result > 0) {
			map.replace("temp", "yes");	//해당 년도 휴가 신청 내역이 있을때
		} else {
			map.replace("temp", "no");	//해당 년도 휴가 신청 내역이 없을때
		}
		int num = service.selectDoRemaining(map);
		map.put("DOREMAININGDAYS", num);
		mv.addObject("e", map);
		mv.setViewName("emp/empDayOffForm");
		return mv;
	}
	
	/* 휴가신청 */
	@RequestMapping("/emp/insertDayOffEnd.do")
	public ModelAndView insertDayOffEnd(@RequestParam Map<String, Object> param) {

		param.put("temp", "my");
		int empNo = Integer.parseInt((""+param.get("empNo")));
		param.put("empNo", empNo);
		
		int result = service.selectDayOffCount(param);
		
		if(result > 0) {
			param.replace("temp", "yes");	//해당 년도 휴가 신청 내역이 있을때
		} else {
			param.replace("temp", "no");	//해당 년도 휴가 신청 내역이 없을때
		}
		param.put("empNo", empNo);
		int num = service.selectDoRemaining(param);
		param.put("DOREMAININGDAYS", num);
		
		String loc = "";
		String msg = "/emp/empList.do";
		result = 0;
		try {
			result = service.insertDayOff(param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		ModelAndView mv = new ModelAndView();
		if(result > 0) {
			msg = "휴가신청이 완료되었습니다.";
			loc = "/emp/selectDayOffList.do?empNo=" + empNo+"&temp=my";
		} else {
			msg = "휴가신청이 실패하였습니다.";
			loc= "/emp/selectDayOffList.do?empNo=" + empNo+"&temp=my";
			mv.setViewName("common/msg");
		}

		mv.addObject("msg", msg);
		mv.addObject("loc", loc);
		mv.setViewName("common/msg");
		
		return mv;
	}
	
	/* 출장신청 */
	@RequestMapping("/emp/insertBT.do")
	public ModelAndView insertBT(int empNo) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> map = new HashMap();
		map = service.selectEmpOne(empNo);
		mv.addObject("e", map);
		mv.setViewName("emp/empBTForm");
		return mv;
	}
	
	/* 출장신청완료 */
	@RequestMapping("/emp/insertBTEnd.do")
	public ModelAndView insertBTEnd(@RequestParam Map<String, Object> param) {
		ModelAndView mv = new ModelAndView();
		int result = 0;
		try {
			result = service.insertBT(param);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int empNo = Integer.parseInt((""+param.get("empNo")));
		String msg = "";
		String loc = "";
		
		if(result > 0) {
			msg = "출장신청이 완료되었습니다.";
			loc = "/emp/selectBTList.do?empNo=" + empNo+"&temp=my";
		} else {
			msg = "출장신청이 실패하였습니다.";
			loc= "/emp/selectBTList.do?empNo=" + empNo+"&temp=my";
			mv.setViewName("common/msg");
		}

		mv.addObject("msg", msg);
		mv.addObject("loc", loc);
		mv.setViewName("common/msg");
		
		return mv;
	}
	/*출장비용 청구*/
	@RequestMapping("/emp/insertBTP.do")
	public ModelAndView insertBTP(@RequestParam Map<String, Object> param) {
		//최근 출장 리스트(현재 달)
		List<Map<String, Object>> list = service.selectBTPList(param);
		
		//출장 한개
		Map<String, Object> e = service.selectBTOne(param);
		
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("list", list);
		mv.addObject("e", e);
		mv.setViewName("emp/empBTPForm");
		
		return mv;
	}
	
	/* 출장비용신청 */
	@RequestMapping("/emp/insertBTPEnd.do")
	public ModelAndView insertBTPEnd(@RequestParam Map<String, Object> param) {
		
		int result = 0;
		try {
			result = service.insertBTP(param);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("emp/empBTPForm");
		
		return mv;
	}
	
}