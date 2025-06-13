L.ui.view.extend({

    title: L.tr('URL Filtering using Proxy'),
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
        object: 'rpc-updatemacconfig',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
        }),
  
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('urlproxyconfig', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'urlproxyconfig', {
            caption:L.tr('URL Filtering using Proxy')
        });
        
        
       s.tab({
            id: 'macbindconfig',
            caption: L.tr('Mac Address Binding Settings')
        });
        
        s.taboption('macbindconfig',L.cbi.InputValue, 'name', {
                        caption: L.tr('Device Name'),
                        optional: true 
                }).depends({'macbindconfig':'1'});
                
        
        s.taboption('macbindconfig',L.cbi.InputValue, 'macaddress', {
                        caption: L.tr('MAC Address'),
                         datatype: 'macaddr',
                        optional: true 
                }).depends({'macbindconfig':'1'});
                
        
        s.taboption('macbindconfig',L.cbi.InputValue, 'ipaddress', {
                        caption: L.tr('IP Address'),
                        datatype: 'ip4addr',
                        optional: true 
                }).depends({'macbindconfig':'1'});
        
        
        
  s.commit=function(){
        self.updateinterfaceconfig('Update','updateinterface').then(function(rv) {
               
                });
        }
		                        
        return m.insertInto('#map');
        
   }     

});
