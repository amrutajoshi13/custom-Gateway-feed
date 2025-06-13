L.ui.view.extend({

    title: L.tr('Modem Configuration'),
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
    
      updatemodemconfig: L.rpc.declare({
        object: 'rpc-updateModemConfig',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
        }),
  
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('modemconfig', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'modemconfig', {
            caption:L.tr('Modem')
        }); 
        
               
 //#################################################################################################################
 // 
 //					Cellular Settings
 //
 // ##################################################################################################################                        

       s.tab({
            id: 'cellularconfig',
            caption: L.tr('Cellular Settings')
        });
        
        /* s.tab({
            id: 'simconfig',
            caption: L.tr('Cellular sim Settings')
        }).depends({'cellularconfig':'1'});*/
        
              
             
           //============================General settings ==============================================

           
              s.taboption('cellularconfig',L.cbi.DummyValue, 'Modem1Setting', {
		  caption: L.tr(''),
		//  caption: L.tr(a),
        }).depends({'ethernetconfig':'1'})
        .ucivalue=function()
          {
            var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspModem 1 settings </b> </h3>";
            return id;
          };   
          
          s.taboption('cellularconfig',L.cbi.CheckboxValue, 'enablemodem1config', {
         caption: L.tr('Enable Modem 1 configuration'),
         optional: true
         }).depends({'cellularconfig' : '1'});
          
                s.taboption('cellularconfig',L.cbi.ListValue, 'cellularmodem1', {
                        caption: L.tr('Cellular Modem 1'),
                }).depends({'cellularconfig':'1'})
               // .depends({'enablecellular':'1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','enablemodem1config':'1'})
                .value("QuectelEC200T",L.tr("Quectel:EC200-T"))
                .value("QuectelEC200A",L.tr("Quectel:EC200-A"))
                .value("QuectelEC25E",L.tr("Quectel:EC25-E"))
                .value("QuectelEC20",L.tr("Quectel:EC20"))
                .value("custom",L.tr("Custom")); 
                
                /*************Custom settings for module 1 ****************************/
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'Manufacturer1', {
                        caption: L.tr('Manufacturer 1'),
                }).depends({'cellularconfig':'1'})
               // .depends({'enablecellular':'1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'});
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'model1', {
                        caption: L.tr('Model 1'),
                }).depends({'cellularconfig' : '1'})
                 .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                 .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                 .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'});
                   
               /*   s.taboption('cellularconfig',L.cbi.InputValue, 'usbbuspath1', {
                  caption: L.tr('USB Bus Path 1'),
                }).depends({'cellularconfig' : '1'})
                 .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','enablemodem1config':'1'})
                 .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','enablemodem1config':'1'})
                 .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','enablemodem1config':'1'});*/
                                     
                     
               
                s.taboption('cellularconfig',L.cbi.ListValue, 'porttype1', {
                caption: L.tr('Port Type 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})  
                .value("none",L.tr("Choose Option"))
                .value("ttyUSB",L.tr("USB"))
                .value("ttyACM",L.tr("ACM"))
                .value("serail",L.tr("SERIAL"));
          
              s.taboption('cellularconfig',L.cbi.InputValue, 'vendorid1', {
                        caption: L.tr('Vendor ID 1'),
                }).depends({'cellularconfig' : '1'})
                  .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})  ; 
                
                s.taboption('cellularconfig',L.cbi.InputValue, 'productid1', {
                        caption: L.tr('Product ID 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})  ;
                
                  s.taboption('cellularconfig',L.cbi.InputValue, 'dataport1', {
                        caption: L.tr('Data Port 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})  ;  
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'comport1', {
                        caption: L.tr('Communication Port 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})  ; 
                
                  s.taboption('cellularconfig',L.cbi.InputValue, 'smsport1', {
                        caption: L.tr('SMS Port 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom','enablemodem1config':'1'})  ;
                
                
                /****************************Display Preconfigured Quectel:EC200-T Modem 1 configurations ************************************/
                
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200TManufacturer1', {
           caption: L.tr('Manufacturer 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'});   
                
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tmodel1', {
           caption: L.tr('Model 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tporttype1', {
           caption: L.tr('Port type 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tvendorid1', {
           caption: L.tr('Vendor ID 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tproductid1', {
           caption: L.tr('Product ID 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'});       
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tdataport1', {
           caption: L.tr('Data Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'});  
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tcomport1', {
           caption: L.tr('Communication Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'});  
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tsmsport1', {
           caption: L.tr('SMS Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T','enablemodem1config':'1'});  
           
 
                /****************************Display Preconfigured Quectel:EC200-A Modem 1 configurations ************************************/
                
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200AManufacturer1', {
           caption: L.tr('Manufacturer 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'});   
                
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Amodel1', {
           caption: L.tr('Model 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Aporttype1', {
           caption: L.tr('Port type 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
            .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'});
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Avendorid1', {
           caption: L.tr('Vendor ID 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
            .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Aproductid1', {
           caption: L.tr('Product ID 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Adataport1', {
           caption: L.tr('Data Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
            .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'});
            
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Acomport1', {
           caption: L.tr('Communication Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Asmsport1', {
           caption: L.tr('SMS Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
            .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200A','enablemodem1config':'1'});
          
         
          
          
          
          
          
           
          
        
                /****************************Display Preconfigured Quectel:EC25-E Modem 1 configurations ************************************/
                
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25EManufacturer1', {
           caption: L.tr('Manufacturer 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'});   
                
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Emodel1', {
           caption: L.tr('Model 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Eporttype1', {
           caption: L.tr('Port type 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Evendorid1', {
           caption: L.tr('Vendor ID 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Eproductid1', {
           caption: L.tr('Product ID 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'});       
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Edataport1', {
           caption: L.tr('Data Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'});  
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Ecomport1', {
           caption: L.tr('Communication Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'});  
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Esmsport1', {
           caption: L.tr('SMS Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E','enablemodem1config':'1'});                   
            
       
       
       
       
       
       
       
       
       
       
       
       
       
        /****************************Display Preconfigured Quectel:EC20 Modem 1 configurations ************************************/
                
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC20Manufacturer1', {
           caption: L.tr('Manufacturer 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'});   
                
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC20model1', {
           caption: L.tr('Model 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC20porttype1', {
           caption: L.tr('Port type 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC20vendorid1', {
           caption: L.tr('Vendor ID 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC20productid1', {
           caption: L.tr('Product ID 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'});       
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC20dataport1', {
           caption: L.tr('Data Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'});  
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC20comport1', {
           caption: L.tr('Communication Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'});  
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC20smsport1', {
           caption: L.tr('SMS Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC20','enablemodem1config':'1'});  
 
        
        
        
        
        
        /***************Modem 2 ***********************************************************/  
        
        
        
       /*  s.taboption('cellularconfig',L.cbi.CheckboxValue, 'enablemodem2config', {
         caption: L.tr('Enable Modem 2 configuration'),      
         }).depends({'cellularconfig' : '1'});   */
           
        /* s.taboption('cellularconfig',L.cbi.DummyValue, 'Modem2Setting', {
		  caption: L.tr(''),
		//  caption: L.tr(a),
        }).depends({'ethernetconfig':'1','enablemodule2config':'1','enablemodem2config':'1'})
        .ucivalue=function()
          {
            var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspModem 2 settings </b> </h3>";
            return id;
          };   
                                       
             s.taboption('cellularconfig',L.cbi.ListValue, 'cellularmodem2', {
                        caption: L.tr('Cellular Modem 2'),
                }).depends({'cellularconfig':'1'})
               .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','enablemodem2config':'1'})
                .value("QuectelEC200T",L.tr("Quectel:EC200-T"))
                .value("QuectelEC25E",L.tr("Quectel:EC25-E"))
                .value("custom",L.tr("Custom"));   
                
                
                s.taboption('cellularconfig',L.cbi.InputValue, 'Manufacturer2', {
                        caption: L.tr('Manufacturer 2'),
                }).depends({'cellularconfig':'1'})
               // .depends({'enablecellular':'1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'});
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'model2', {
                        caption: L.tr('Model 2'),
                }).depends({'cellularconfig' : '1'})
                 .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                 .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                 .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'});
                           
                  s.taboption('cellularconfig',L.cbi.InputValue, 'usbbuspath2', {
                  caption: L.tr('USB Bus Path 2'),
                }).depends({'cellularconfig' : '1'})
                 .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','enablemodem2config':'1'})
                 .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','enablemodem2config':'1'})
                 .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','enablemodem2config':'1'});
                                      
                s.taboption('cellularconfig',L.cbi.ListValue, 'porttype2', {
                caption: L.tr('Port Type 2'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})  
                .value("none",L.tr("Choose Option"))
                .value("ttyUSB",L.tr("USB"))
                .value("ttyACM",L.tr("ACM"))
                .value("serail",L.tr("SERIAL"));
          
              s.taboption('cellularconfig',L.cbi.InputValue, 'vendorid2', {
                        caption: L.tr('Vendor ID 2'),
                }).depends({'cellularconfig' : '1'})
                  .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})  ; 
                
                s.taboption('cellularconfig',L.cbi.InputValue, 'productid2', {
                        caption: L.tr('Product ID 2'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})  ;
                
                  s.taboption('cellularconfig',L.cbi.InputValue, 'dataport2', {
                        caption: L.tr('Data Port 2'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})  ;  
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'comport2', {
                        caption: L.tr('Communication Port 2'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})  ; 
                
                  s.taboption('cellularconfig',L.cbi.InputValue, 'smsport2', {
                        caption: L.tr('SMS Port 2'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom','enablemodem2config':'1'})  ;*/
                
                /****************Display Preconfigured MOdem 2 - EC200 -T Configuration*****************************/        
       
           /* s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200TManufacturer2', {
           caption: L.tr('Manufacturer 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T','enablemodem2config':'1'});
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tmodel2', {
           caption: L.tr('Model 2'),
           }).depends({'cellularconfig':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T','enablemodem2config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tporttype2', {
           caption: L.tr('Port type 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T','enablemodem2config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tvendorid2', {
           caption: L.tr('Vendor ID 2'),
           }).depends({'cellularconfig':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T','enablemodem2config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tproductid2', {
           caption: L.tr('Product ID 2'),
           }).depends({'cellularconfig':'1'})
          .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T','enablemodem2config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tdataport2', {
           caption: L.tr('Data Port 2'),
           }).depends({'cellularconfig':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T','enablemodem2config':'1'});
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tcomport2', {
           caption: L.tr('Communication Port 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T','enablemodem2config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tsmsport2', {
           caption: L.tr('SMS Port 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T','enablemodem2config':'1'});*/
           
             
           /***********************Display Preconfigured MOdem 2 EC25E configuration**********************************************************************/
           
          /*   s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25EManufacturer2', {
           caption: L.tr('Manufacturer 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E','enablemodem2config':'1'});
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Emodel2', {
           caption: L.tr('Model 2'),
           }).depends({'cellularconfig':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E','enablemodem2config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Eporttype2', {
           caption: L.tr('Port type 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E','enablemodem2config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Evendorid2', {
           caption: L.tr('Vendor ID 2'),
           }).depends({'cellularconfig':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E','enablemodem2config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Eproductid2', {
           caption: L.tr('Product ID 2'),
           }).depends({'cellularconfig':'1'})
          .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E','enablemodem2config':'1'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Edataport2', {
           caption: L.tr('Data Port 2'),
           }).depends({'cellularconfig':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E','enablemodem2config':'1'});
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Ecomport2', {
           caption: L.tr('Communication Port 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E','enablemodem2config':'1'});
           
          s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Esmsport2', {
           caption: L.tr('SMS Port 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E','enablemodem2config':'1'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E','enablemodem2config':'1'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'QuectelEC25E','enablemodem2config':'1'});    */               
                                          
     		
       s.commit=function(){
			
                self.updatemodemconfig('Update','updatemodemconfig').then(function(rv) {
				               
                });
           }
                   
		                        
        return m.insertInto('#map');
    }
});
