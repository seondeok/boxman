package com.spring.bm.department.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;

public interface DepartmentDao {

	/* 부서등록 */
	int insertDept(SqlSessionTemplate session, Map<String, String> param);
	/* 부서리스트출력 */
	List<Map<String, String>> selectDeptList(SqlSessionTemplate session);
	/* 부서삭제 */
	int updateDept(SqlSessionTemplate session, Map<String, Object> map);
	/* 부서상세 */
	Map<String, Object> selectDeptOne(SqlSessionTemplate session, int deptNo);

}
