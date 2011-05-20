<cfscript>
	// create a singleton of the tokenizer object and initialize it with the session scope for token storage
	tokenizer = createObject('component','com.tokenizer').init(session);
	
	//create the token for use in the form pass it a name and the number of milliseconds it will be valid for
	tokenizer.createToken('otherFileExample',300);
</cfscript>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Post to another file Example</title>
</head>

<body>
<form name="form" action="submit.cfm" method="post">
	<label for="Name">Name: </label>
    <input type="text" name="name" id="Name" />
    <input type="submit" name="submit" value="Submit" />
    <cfscript>
		//write the token to the page
		writeOutput(tokenizer.writeTokenToPage('otherFileExample'));
	</cfscript>
</form>
</body>
</html>