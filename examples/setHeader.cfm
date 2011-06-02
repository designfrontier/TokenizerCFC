<cfscript>
	tokenizer = createObject('component','tokenizer').init(session);
	
	if(tokenizer.checkToken('ajaxTest',form.xsrf_token)){
		tokenizer.removeToken('ajaxTest');
		
		tokenizer.createToken('ajaxTest',300);
		
		pc = getpagecontext().getresponse();
		pc.setHeader("xsrf_token",tokenizer.getTokenValue('ajaxTest'));	 
		//borrowed from : http://existdissolve.com/2010/10/cfscript-alternative-to-cfheader/ written by @exitdissolve
	}
</cfscript>