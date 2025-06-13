L.ui.view.extend({

    title: L.tr('SIA Configuration'),

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
    
      updatesiaserverconfig: L.rpc.declare({
        object: 'rpc-siaserverConfig',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
        }),
  
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('siaserverconfig', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'siaserverconfig', {
            caption:L.tr('SIA Configuration')
        }); 
    
    		/* s.option('L.cbi.InputValue, 'port', {
				caption: L.tr('Port'),
		});*/
		
		s.option( L.cbi.DummyValue, 'sialocalconfig', {
		  caption: L.tr(''),
		//  caption: L.tr(a),
        }).ucivalue=function()
          {
            var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspSIA Local Settings </b> </h3>";
            return id;
          };   
			
		s.option( L.cbi.DummyValue, 'serialnum', {
		caption: L.tr('Router Serial Number'),
		});                                      
		  
		s.option( L.cbi.InputValue, 'receivernumber', {
		caption: L.tr('Receiver Number'),
		datatype:'rangelengthint(6,6)'
		});
		
		s.option( L.cbi.InputValue, 'linenumber', {
		caption: L.tr('Line Number'),
		datatype:'rangelengthint(6,6)'
		});

		s.option( L.cbi.InputValue, 'accountnumber', {
		caption: L.tr('Account Number'),
		datatype:'rangelengthint(5,6)'
		});
		
		s.option( L.cbi.CheckboxValue, 'enablehealthpacketpublish', {
		caption: L.tr('Enable Health Packet Publish'),
		});
		
		s.option( L.cbi.InputValue, 'healthpacketpublishinterval', {
		caption: L.tr('Health Packet Publish Interval (In Minutes)'),
		datatype:'rt-fraction(5)'
		}).depends({'enablehealthpacketpublish':'1'});                                                                           
		
		s.option( L.cbi.CheckboxValue, 'enablecrcprocessing', {
		caption: L.tr('Enable CRC Processing'),
		});                                       
		
		
		s.option( L.cbi.DummyValue, 'siaserverconfig', {
		  caption: L.tr(''),
		//  caption: L.tr(a),
        }).ucivalue=function()
          {
            var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspSIA Server Settings </b> </h3>";
            return id;
          };   	
           
            s.option( L.cbi.InputValue, 'siaipaddress', {
            caption: L.tr('Server IP Address/URL'),
          //  datatype: 'ipaddr'
        });  
          
         s.option( L.cbi.InputValue, 'port', {
            caption: L.tr('Port'),
            datatype: 'port'
        });  
        
		     		
       s.commit=function(){
			
                self.updatesiaserverconfig('configure').then(function(rv) {
				               
                });
           }
                   
		                        
        return m.insertInto('#map');
    }
});
