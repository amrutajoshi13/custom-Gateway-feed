L.ui.view.extend({

    title: L.tr('Port Settings'),
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
    
      updateinterfaceconfig: L.rpc.declare({
        object: 'rpc-updatewanconfig',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
        }),
  
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('portsettings', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'portsettings', {
            caption:L.tr('Port Settings')
        });        
          
     s.option(L.cbi.ListValue,'port0settings',{          
                        caption:L.tr('Port 0'),                    
                }).value("none", L.tr('Please choose')) 
                .value("SW-LAN", L.tr('SW-LAN')); 
        
    s.option(L.cbi.ListValue,'port1settings',{          
                        caption:L.tr('Port 1'),                    
                }).value("none", L.tr('Please choose')) 
                .value("SW-LAN", L.tr('SW-LAN'));
                
                
     s.option(L.cbi.ListValue,'port2settings',{          
                        caption:L.tr('Port 2'),                    
                }).value("none", L.tr('Please choose')) 
                .value("SW-LAN", L.tr('SW-LAN'));  
                
      s.option(L.cbi.ListValue,'port3settings',{          
                        caption:L.tr('Port 3'),                    
                }).value("none", L.tr('Please choose')) 
                .value("SW-LAN", L.tr('SW-LAN'))
                .value("WAN", L.tr('WAN'));  
                
                
     s.option(L.cbi.ListValue,'port4settings',{          
                        caption:L.tr('Port 4'),                    
                }).value("none", L.tr('Please choose')) 
                .value("SW-LAN", L.tr('SW-LAN'))
                .value("WAN", L.tr('WAN'));            
                                                   
                
                //.value("clienttositevpn", L.tr('Client to site VPN'));      
              	                        
        return m.insertInto('#map');
    }
});
