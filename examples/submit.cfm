<cfscript>	
	tokenizer = createObject('component','com.tokenizer').init(session);	
	
	if(structKeyExists(form,'xsrf_token') and tokenizer.checkToken('otherFileExample',form.xsrf_token)){
		//the form has been submitted and the token is valid so we will do our form processing here
		//in this case we'll just dump it to the page
		writeOutput('<h1>Success!</h1><p>Form contents are dumped below...</p>');
		writeDump(form);
		
		//now that we are done remove the token so that it can't be reused
		tokenizer.removeToken('otherFileExample');
	}else{
		location('other.cfm',false);
	}
</cfscript>