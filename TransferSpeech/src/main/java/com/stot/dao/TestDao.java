package com.stot.dao;

import java.util.List;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Component;

import com.stot.bean.TestBean;

@Component
public class TestDao extends SqlSessionDaoSupport {

	/* �����ͺ��̽� �����ؼ� �����Ͱ������� �׽�Ʈ */
	public List<TestBean> selectAlltest() {
		return this.getSqlSession().selectList("selectAlltest");
	}

}
