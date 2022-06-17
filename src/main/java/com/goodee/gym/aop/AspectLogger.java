package com.goodee.gym.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component 
@Aspect   
public class AspectLogger {

	// 로거
	private final Logger logger = LoggerFactory.getLogger(AspectLogger.class);
	
	@Around("execution(* com.goodee.gym.controller.*Controller.*(..))")
	public Object log(ProceedingJoinPoint point) throws Throwable {
		
		String name = point.getSignature().getName();
		logger.info(name + " : my log");
		
		return point.proceed();
	}
	
	
}
  