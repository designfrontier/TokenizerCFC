<cfscript>
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
<script>
	var ajaxCall = function(){
	 	var geturl;
		geturl = $.ajax({
			type: "POST",
			data: $('#bob').serialize(),
			url: 'setHeader.cfm',
			success: function () {
			var headers = geturl.getAllResponseHeaders();
			h = headers.split('\n');
			
			pattern = /xsrf/;
			
			for(i=0; i < h.length - 1; i++){
				if(h[i].match(pattern)){
					$('#xsrf_token').val($.trim(h[i].split(':')[1]));
				}
			}
			  alert("done!"+ headers);
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