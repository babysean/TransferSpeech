package com.stot.bean;

public class TestBean {
	private String userid;
	private String name;

	public TestBean() {
		super();
	}

	public TestBean(String userid, String name) {
		super();
		this.userid = userid;
		this.name = name;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "TestBean [userid=" + userid + ", name=" + name + "]";
	}

}
