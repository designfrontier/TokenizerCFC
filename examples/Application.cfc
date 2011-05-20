<cfcomponent displayname="Application" output="true">
	<!--- Set up the application. --->
    <cfscript>
		this.Name = "tokenizerTest";
    	this.ApplicationTimeout = CreateTimeSpan( 0, 0, 1, 0 );
    	this.sessiontimeout = createTimeSpan(0,0,30,0);
		this.SessionManagement = true;
		this.SetClientCookies = true;
		this.clientManagement = false;
	</cfscript>
 
    <cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false" >
	    <cfreturn true />
    </cffunction>
     
    <cffunction name="OnSessionStart" access="public" returntype="void" output="false" >
    </cffunction>
 
 
    <cffunction name="OnRequestStart" access="public" returntype="boolean" output="false">
        <cfargument name="TargetPage" type="string" required="true" />
         
        <cfreturn true />
    </cffunction>
     
    <cffunction name="OnRequest" access="public" returntype="void" output="true">
        <cfargument name="TargetPage" type="string" required="true" />
        <cfinclude template="#ARGUMENTS.TargetPage#" />
     
        <cfreturn />
    </cffunction>
     
    <cffunction name="OnRequestEnd" access="public" returntype="void" output="true">
     
        <cfreturn />
    </cffunction>
     
    <cffunction name="OnSessionEnd" access="public" returntype="void" output="false">
        <cfargument name="SessionScope" type="struct" required="true" />
        <cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
             
        <cfreturn />
    </cffunction>
     
    <cffunction name="OnApplicationEnd" access="public" returntype="void" output="false">
        <cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
         
        <cfreturn />
    </cffunction>
     
    <cffunction name="OnError" access="public" returntype="void" output="true"> 
        <cfargument name="Exception" type="any" required="true" />
        <cfargument name="EventName" type="string" required="false" default="" />
         
        <cfreturn />
    </cffunction>
</cfcomponent>