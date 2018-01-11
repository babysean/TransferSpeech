package com.stot.dao;

import java.util.List;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Component;

import com.stot.bean.TestBean;

@Component
public class TestDao extends SqlSessionDaoSupport {

	/* 데이터베이스 접근해서 데이터가져오기 테스트 */
	public List<TestBean> selectAlltest() {
		return this.getSqlSession().selectList("selectAlltest");
	}

}
