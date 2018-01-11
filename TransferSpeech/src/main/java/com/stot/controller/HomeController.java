package com.stot.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HomeController {
	
	@RequestMapping(value ="index.do")
	public ModelAndView indexAction(){
		ModelAndView mav = new ModelAndView();
		mav.setViewName("views/home");
		return mav;
	}
	
	
}
