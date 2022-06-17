package com.goodee.gym.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.goodee.gym.service.MemberService;


@Controller
public class MemberController {

	@Autowired
	private MemberService memberService;
}
