L.ui.view.extend({

    title: L.tr('Board Configuration'),
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
    
     
	Configureboard: L.rpc.declare({
        object: 'rpc-boardconfig',
        method: 'configure',
        expect: { output: '' }
    }),
    
  
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('boardconfigfile', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'boardconfigfile', {
            caption:L.tr('Board Configuration')
        }); 
    
    	s.option( L.cbi.InputValue, 'serialnum', {
		caption: L.tr('Router Serial Number'),
		}); 
		
		
		 $('#btn-update').click(function() {
            L.ui.loading(true);
            self.Configureboard('configure').then(function(rv) {
				//alert(rv);
                L.ui.loading(false);
                    L.ui.dialog(
                        L.tr('update configuration'),[
                            $('<pre />')
                            .addClass('alert alert-success')
                            .text(rv)
                        ],
                        { style: 'close'}
                    );
                    
                   });
            });
                                                
		  
       s.commit=function(){
			
                self.updatesiaserverconfig('configure').then(function(rv) {
				               
                });
           }
                   
		                        
        return m.insertInto('#map');
    }
});
