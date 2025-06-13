L.ui.view.extend({

    title: L.tr('LTE Module Firmware Upgrade'),

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
    
    
      updatefirmware: L.rpc.declare({
        object: 'rpc-ltemodulefirmwareupgrade',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
        }),
        
   

   
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('ltemodulefirmwareupgrade', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'ltemodulefirmwareupgrade', {
            caption:L.tr('LTE Module Firmware Upgrade')
        }); 
    
    		/* s.option('L.cbi.InputValue, 'port', {
				caption: L.tr('Port'),
		});*/
		
	    s.option( L.cbi.CheckboxValue, 'Authenable', {
		caption: L.tr('Enable Authentication'),
		});
		
		s.option(L.cbi.InputValue, 'firmwareversion', {
            caption: L.tr('Firmware Version'),
            datatype: 'string'
        }).depends({'Authenable':'1'});

		
    s.option(L.cbi.InputValue, 'user', {
            caption: L.tr('user name')
        }).depends({'Authenable':'1'});
        
        s.option(L.cbi.PasswordValue, 'password', {
            caption: L.tr('password')
        }).depends({'Authenable':'1'});
        
        s.option(L.cbi.InputValue, 'url', {
            caption: L.tr('Server Address/URL')
        });
        
       s.option(L.cbi.InputValue, 'connectiontimeout', {
            caption: L.tr('connectiontimeout'),
            datatype: 'uinteger'
        });

        s.option(L.cbi.InputValue, 'operationtimeout', {
            caption: L.tr('operationtimeout'),
            datatype: 'uinteger'
        });
     
   $('#btn_upgrade').click(function() {
            L.ui.loading(true);
            self.updatefirmware('configure').then(function(rv) {
				//alert(rv);
                L.ui.loading(false);
                    L.ui.dialog(
                        L.tr('Upgrade'),[
                            $('<pre />')
                            .addClass('alert alert-success')
                            .text(rv)
                        ],
                        { style: 'close'}
                    );
                    
                   });
            });
                
       		     		
       //s.commit=function(){
			
                //self.updatefirmware('configure').then(function(rv) {
				               
                //});
           //}
                   
		                        
        return m.insertInto('#map');
    }
});
