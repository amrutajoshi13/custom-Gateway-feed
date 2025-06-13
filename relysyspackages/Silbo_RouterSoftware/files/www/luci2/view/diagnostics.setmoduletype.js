L.ui.view.extend({

    title: L.tr('Module Type Configuration'),
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
        object: 'rpc-updateModuletype',
        method: 'configure',
        expect: { output: '' }
    }),
    
  
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('boardconfigfile', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'boardconfigfile', {
            caption:L.tr('Module Type Configuration')
        }); 
    
		
	   s.option(L.cbi.ListValue, 'moduletype', {
                        caption: L.tr('Module Type'),
                }).value("1",L.tr("1: OnBoard EC200T"))
                .value("2",L.tr("2: Mini-PCIe EC200T"))
                .value("3",L.tr("3: Mini PCIe EC20T"))
                .value("4",L.tr("4: OnBoard EC20T"))
                .value("5",L.tr("5: ZTE Mini PCIe"))
                .value("6",L.tr("6: Mini-PCIe EC25E"))
                .value("7",L.tr("7: Onboard EC25E"))
                .value("8",L.tr("8: OnBoard EC200A"))
                .value("9",L.tr("9: Mini-PCIe EC200A"));          
      	
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
			
                self.Configureboard('configure').then(function(rv) {
				               
                });
           }
                   
		                        
        return m.insertInto('#map');
    }
});

