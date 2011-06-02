<cfscript>
	tokenizer = createObject('component','tokenizer').init(session);
	
	if(structKeyExists(form,'xsrf_token') and tokenizer.checkToken('ajaxTest',form.xsrf_token)){
		//Sweet! A usable form!
		//This is where all the processing code would go to handle the form submission.
		
		
		//Remove the token since they should only be good for a single use
		tokenizer.removeToken('ajaxTest');
		
		//recreate it for the next round of ajax submission
		tokenizer.createToken('ajaxTest',300);
		
		/*
			This is where it gets fancy.
			We need to return the new token without effecting the contents of the response (that would probably cause your code problems)
			so we return it as a custom header named xsrf_token. The name is arbitrary, your javascript on the recieveing end just
			needs to know what to look for so it can reset the tokens value on the page.
			
			This can be achieved using <cfheader> as well, I just wanted to keep the example all cfscript.
			
			The code to write the header out from cfscript was borrowed from : http://existdissolve.com/2010/10/cfscript-alternative-to-cfheader/ 
			
		*/
	
		pc = getpagecontext().getresponse();
		pc.setHeader("xsrf_token",tokenizer.getTokenValue('ajaxTest'));	 
		
	}
</cfscript>