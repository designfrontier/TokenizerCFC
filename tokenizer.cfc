<!---TOKENIZER v. 1.2
NOTES ON IMPLEMENTATION
The process of implementation goes something like this:
Step 1 -> Create a tokenizer instance and pass it the session scope (if the page posts to itself place this at the very top,
before the form processing that will save you having to complete step 4 later)
tokenizer = createObject('component','admin.com.tokenizer').init(session);
Name of the tokenizer variable doesn't really matter here.
Step 2 -> Create a new token. This takes two arguments: 1) The name of the token (no spaces, must be a valid variable name)  				2) the time in seconds before the token expires (make this reasonable considering the length of the form)
IMPORTANT:: If the form self posts then this should be done after the form processing code but before the 
display of the form itself.
tokenizer.createToken('tokenName',300);
Step 3 -> Write the token to the page with in the 
<form>
<cfoutput>#tokenizer.writeTokenToPage('tokenName')#</cfoutput>
The rest of the implementation happens in your form processing code
Step 4 -> Create an instance of the tokenizer if you are self-posting this form and you followed Step 1 (hint hint) then you
can skip this step and collect $200.
tokenizer = createObject('component','admin.com.tokenizer').init(session);
Step 5 -> in the IF statement that kicks off form processing add the following
AND tokenizer.checkToken('tokenName',form.xsrf_token)
This does all the checking to ensure that the token is valid
Step 6 -> inside the form processing IF statement and after you are done with all the form processing add this line
<cfset tokenizer.removeToken('tokenName')>
This removes the token and prevents the form from being double posted.
--->
<cfcomponent hint="Tokenizer v.1.2">
<cffunction name="init" access="public" returntype="tokenizer">
	<cfargument name="sessionScope" type="struct" required="yes">
	<cfscript>
	variables.sessionScope = arguments.sessionScope;
	if(not StructKeyExists(variables.sessionScope,'tokenStore')){
	//create the token store if it does not exist
	variables.sessionScope.tokenStore = structnew();	
	}
	// variables.tokenStore = variables.sessionScope.tokenStore;
	return this;
	</cfscript>
</cffunction>
<cffunction name="createToken" access="public" returntype="void">
	<cfargument name="tokenName" required="true" type="string">
	<cfargument name="tokenExpires" required="false" type="numeric" hint="The number of seconds before the token expires" default="900">
	<cfscript>
	if(not structKeyExists(variables.sessionScope.tokenStore,arguments.tokenName) OR isTokenExpired(arguments.tokenName)){
	// Token is either expired or does not exist so we will create it
	variables.sessionScope.tokenStore[arguments.tokenName] = {
	token = Hash(CreateUUID(),'SHA-256'),
	expires = dateAdd('s',arguments.tokenExpires,now())
	};
	}
	</cfscript>
</cffunction>
<cffunction name="writeTokenToPage" access="public" returntype="string" hint="creates the hidden form input for doing tokenization">
	<cfargument name="tokenName" required="true" type="string">
	<cfscript>
	return '<input type="hidden" name="xsrf_token" id="xsrf_token" value="' & variables.sessionScope.tokenStore[arguments.tokenName].token & '" />';
	</cfscript>
</cffunction>
<cffunction name="isTokenExpired" access="public" returntype="boolean">
	<cfargument name="tokenName" required="true" type="string">
	<cfscript>
	return structKeyExists(variables.sessionScope.tokenStore,arguments.tokenName) AND dateDiff('s',variables.sessionScope.tokenStore[arguments.tokenName].expires,now()) gte 0;			
	</cfscript>
</cffunction>
<cffunction name="checkToken" access="public" returntype="boolean">
	<cfargument name="tokenName" required="true" type="string">
	<cfargument name="tokenValue" required="true" type="string">
	
	<cfset var local = StructNew() >
	<cfset local.checkToken = false>
	
	<cfif  arguments.tokenValue eq getTokenValue(arguments.tokenName)
	and NOT isTokenExpired(arguments.tokenName)>
		<cfset local.checkToken = true>
	</cfif>
	
<!--- 	
	<h2>checktoken function</h2>
	<h2>session</h2><cfdump var="#session#">
	
	<cfdump var="#local.tokenValue#">
	<h2>variables</h2>
	<cfdump var="#variables#">
	<cfdump var="#variables.sessionScope.tokenStore#"><br><hr><br>
	<cfdump var="#arguments.tokenName#">
	<cfdump var="#structKeyExists(variables.sessionScope.tokenStore,arguments.tokenName)#"><br><hr><br> 
--->

	<cfreturn local.checkToken>
</cffunction>
<cffunction name="removeToken" access="public" returntype="void">
	<cfargument name="tokenName" type="string" required="true">
	<cfscript>
	if(structKeyExists(variables.sessionScope.tokenStore,arguments.tokenName)){
	structDelete(variables.sessionScope.tokenStore,arguments.tokenName);	
	}
	</cfscript>
</cffunction>
<cffunction name="getTokenValue" access="public" returntype="string">
	<cfargument name="tokenName" type="string" required="true">
	
<!--- 	
	<h2>getTokenValue function</h2>
	<cfdump var="#arguments.tokenName#">
	<cfdump var="#structKeyExists(variables.sessionScope.tokenStore,arguments.tokenName)#"><br><hr><br>
	<h2>session</h2><cfdump var="#session#">
	<h2>variables</h2>
	<cfdump var="#variables#">
	<cfdump var="#variables.sessionScope.tokenStore#"><br><hr><br>
	<cfdump var="#variables#"> 
--->
	<cfset var local = StructNew() >
	<cfset local.tokenValue = 'no token value'>
	
	<cfif(structKeyExists(variables.sessionScope.tokenStore,arguments.tokenName))>
		<cfset local.tokenValue =  variables.sessionScope.tokenStore[arguments.tokenName].token>
	</cfif>
	
	<cfreturn local.tokenValue /> 
</cffunction>
</cfcomponent>
