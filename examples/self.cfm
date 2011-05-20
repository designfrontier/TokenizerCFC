<cfscript>
	// create a singleton of the tokenizer object and initialize it with the session scope for token storage
	tokenizer = createObject('component','com.tokenizer').init(session);
	
	if(structKeyExists(form,'xsrf_token') and tokenizer.checkToken('selfPostTest',form.xsrf_token)){
		//the form has been submitted and the token is valid so we will do our form processing here
		//in this case we'll just dump it to the page
		writeOutput('<h1>Success!</h1><p>Form contents are dumped below...</p>');
		writeDump(form);
		
		//now that we are done remove the token so that it can't be reused
		tokenizer.removeToken('selfPostTest');
	}
	
	//create the token for use in the form pass it a name and the number of milliseconds it will be valid for
	tokenizer.createToken('selfPostTest',300);
</cfscript>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Self Post Example</title>
</head>

<body>
<form name="form1" action="" method="post">
	<label for="Name">Name: </label>
    <input type="text" name="name" id="Name" />
    <input type="submit" name="submit" value="Submit" />
    <cfscript>
		//write the token to the page
		writeOutput(tokenizer.writeTokenToPage('selfPostTest'));
	</cfscript>
</form>
</body>
</html>