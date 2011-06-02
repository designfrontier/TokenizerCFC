<cfscript>
	//create and initialize tokenizer as usual
	tokenizer = createObject('component','tokenizer').init(session);
	tokenizer.createToken('ajaxTest',300);
</cfscript>
<form id="bob">
	<input name="name" id="name" type="text" />
	<cfoutput>
    	#tokenizer.writeTokenToPage('ajaxTest')#
    </cfoutput>
</form>
<a href="#" id="ajax">Save me!</a>
<!--- up to this point the implementation is pretty much the same as posting to a seperate page
	The JS below handles sending the request, and parsing out the headers on the response.
	--->
<script>
	var ajaxCall = function(){
	 	var getReq;
		getReq = $.ajax({
			type: "POST",
			data: $('#bob').serialize(),
			url: 'setHeader.cfm',
			success: function () {
				var headers = getReq.getAllResponseHeaders(); //Get the headers as a string
				h = headers.split('\n'); //split the string into an array on new line chars
				
				pattern = /xsrf/;  //regexp pattern for identifying the correct header
				
				for(i=0; i < h.length - 1; i++){  //loop over the header array
					if(h[i].match(pattern)){  //check to see if this is the returned header and if so...
						$('#xsrf_token').val($.trim(h[i].split(':')[1])); // update the value of the xsrf_token element created by tokenizer with the new value from the header
					}
				}
			}
		});	
	}
	$(document).ready(function(){
		$('#ajax').click(function(){
			ajaxCall();
		});
	});
</script>
<cfdump var="#session#">