package com.stot.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.stot.dao.TestDao;

@Controller
public class HomeController {
	
	@Resource
	private TestDao testDao ;
	
	@RequestMapping(value ="index.do")
	public ModelAndView indexAction(){
		ModelAndView mav = new ModelAndView();
		mav.addObject("tester",testDao.selectAlltest());
		mav.setViewName("views/home");
		return mav;
	}
	
	
}
