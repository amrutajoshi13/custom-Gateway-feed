L.ui.view.extend({

    title: L.tr('WebServer Configuration'),
      RunUdev:L.rpc.declare({
        object:'command',
        method:'exec',
        params : ['command','args'],
    }),
    
    
     fGetUCISections: L.rpc.declare({
        object: 'uci',
        method: 'get',
       // params: [ 'config', 'type', 'section']  
              params: [ 'config', 'type']  
       
    }),
    
      updatewebserverconfig: L.rpc.declare({
        object: 'rpc-webserverConfig',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
        }),
  
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('webserverconfig', {
			description: L.tr('If any of the configuration is changed , please reboot the board.'),
        });
        
        var s = m.section(L.cbi.NamedSection, 'webserverconfig', {
            caption:L.tr('WebServer Configuration')
        }); 
    
        s.option( L.cbi.CheckboxValue, 'enable_http', {
		caption: L.tr('Enable HTTP'),
		});
           
            
         s.option( L.cbi.InputValue, 'http_port', {
            caption: L.tr('HTTP Port'),
            datatype: 'port',
            optional: true
        }).depends({'enable_http' : '1'});  
        
                  s.option( L.cbi.CheckboxValue, 'enable_https', {
		caption: L.tr('Enable HTTPS'),
		});
           
        
        s.option( L.cbi.InputValue, 'https_port', {
            caption: L.tr('HTTPS Port'),
            datatype: 'port',
            optional: true
        }).depends({'enable_https' : '1'});  
       
         s.option( L.cbi.CheckboxValue, 'redirect_https', {         
                caption: L.tr('Redirect HTTPS'),    
                });   
        
          s.option( L.cbi.InputValue, 'sessiontimeout', {
            caption: L.tr('Session Timeout(In Minutes)'),
        });  
        
         s.option( L.cbi.CheckboxValue, 'rfc1918_filter', {
		caption: L.tr('RFC1918 Filter'),
		});
        
		s.option( L.cbi.CheckboxValue, 'enablentpsync', {
		caption: L.tr('Enable NTP Sync'),
		});
		
		 s.option( L.cbi.DynamicList, 'ntpserver', {
		caption: L.tr('NTP Server'),
		datatype: 'host'
		}).depends({'enablentpsync':'1'});                                      
		  
		 s.option( L.cbi.InputValue, 'ntpsyncinterval', {
		caption: L.tr('NTP Sync Interval(In Minutes)'),
		}).depends({'enablentpsync':'1'});                                      
     		
       s.commit=function(){
           	 L.ui.WebpageFileCall()	
                self.updatewebserverconfig('configure').then(function(rv) {
				               
                });
           }
                   
		                        
        return m.insertInto('#map');
    }
});
