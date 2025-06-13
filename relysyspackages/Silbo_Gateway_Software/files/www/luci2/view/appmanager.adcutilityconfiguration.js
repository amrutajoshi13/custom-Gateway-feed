L.ui.view.extend({
	
    RunUdev:L.rpc.declare({
        object:'command',
        method:'exec',
        params : ['command','args'],
    }),
    
    fGetUCISections: L.rpc.declare({
        object: 'uci',
        method: 'get',
        params: [ 'config', 'type', 'section']  
    }),
    
    updateinterfaceconfig: L.rpc.declare({
        object: 'rpc-adcutilityupdate',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
    }),
    		
        title: L.tr('ADC Utility Configuration'),

        execute: function() {
                 var self = this;
                var m = new L.cbi.Map('ADCUtilityConfigGeneric', {
                        caption: L.tr('')
                });

                var s = m.section(L.cbi.NamedSection, 'adcutilityconfig', {
                       caption: L.tr('ADC  Utility Configuration Settings')
                });
                 
                s.option(L.cbi.ListValue,'SamplingRate',{
                        caption: L.tr('Sampling Rate'),   
                }).value("1",L.tr("1"))
                  .value("2",L.tr("2"))
                  .value("3",L.tr("3"))
                  .value("4",L.tr("4"))
                  .value("5",L.tr("5"))
                  .value("6",L.tr("6"))
                  .value("7",L.tr("7"));   
 
               
                s.option(L.cbi.ListValue,'ConversionMode',{ 
                        caption: L.tr('Conversion Mode'),   
                }).value("0",L.tr("0-Continuous"))
                  .value("1",L.tr("1-Single Shot"));
                  
                 s.option(L.cbi.InputValue,'NoOfSamples',{ 
                        caption: L.tr('No Of Samples'),   
                }); 
                                                         
                s.option(L.cbi.ListValue,'address',{ 
                        caption: L.tr('Address'),   
                }).value("0x49",L.tr("0x49"));
                
			/*	s.option(L.cbi.ListValue,'filename',{ 
                        caption: L.tr('I2C Bus'),   
                }).value("/dev/i2c-1",L.tr("/dev/i2c-1"));*/

        
    
                s.commit=function(){      
                        self.fGetUCISections('ADCUtilityConfigGeneric','adcutilityconfig').then(function(rv) {  
                        self.updateinterfaceconfig('Update','updateinterface').then(function(rv) {
                });
            });
                
			} 
            
            return   m.insertInto('#map');                   
                                      
         }                           
})                             

