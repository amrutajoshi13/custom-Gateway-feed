L.ui.view.extend({

    title: L.tr('SIM Switch Configuration'),
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
    
      updatesimswitchconfig: L.rpc.declare({
        object: 'rpc-simswitchconfig',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
        }),
  
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('simswitchconfig', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'simswitchconfig', {
            caption:L.tr('SIM Switch')
        }); 
        
               
 //#################################################################################################################
 // 
 //					SIM Switch Settings
 //
 // ##################################################################################################################                        

       s.tab({
            id: 'cellularconfig',
            caption: L.tr('Cellular Settings')
        });
        
        
         s.taboption('cellularconfig',L.cbi.ListValue, 'simswitch', {
                        caption: L.tr('SIM Switch Based on'),
                }).depends({'cellularconfig' : '1'})
                  .value('none', L.tr('None'))  
                  .value('signalstren', L.tr('Signal Strength'))
                  .value('datalim', L.tr('Data Limit'));  
                
               s.taboption('cellularconfig',L.cbi.InputValue, 'threshrsrp', {
                        caption: L.tr('Threshold RSRP'),
                        description: L.tr('This Needs to be set appropriately. Incorrect setting may cause unnecessary SIM switching.( In General a BAD RSRP value range is -140 to -115 and FAIR RSRP value range is -115 to -105)'),
                        optional: true
                }).depends({'cellularconfig' : '1'})
                .depends({'simswitch' : 'signalstren' });

               s.taboption('cellularconfig',L.cbi.InputValue, 'threshsinr', {
                        caption: L.tr('Threshold SINR'),
                         description: L.tr('This Needs to be set appropriately. Incorrect setting may cause unnecessary SIM switching.( In General a BAD SNR value range is -20 to 0 and FAIR SNR value range is 0 to 13)'),
                        optional: true
                }).depends({'cellularconfig' : '1'})
                .depends({'simswitch' : 'signalstren' });

        
        
      //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'cellulardataswitchlimitenable', {
                        //caption: L.tr('Cellular Data switch Limit Enable'),
                        //optional: true
                //}) .depends({'cellularconfig':'1'})
                   //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable':'1','enablecellular':'1'});   

                s.taboption('cellularconfig',L.cbi.InputValue, 'sim1datausagelimit', {
                        caption: L.tr('SIM 1 Data Usage Limit (In MB)'),
                        optional: true 
                })
                .depends({'cellularconfig' : '1'})
                .depends({'simswitch' : 'datalim' })
				.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable':'1','enablecellular':'1','cellulardataswitchlimitenable':'1'});   
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'sim2datausagelimit', {
                        caption: L.tr('SIM 2 Data Usage Limit (In MB)'),
                        optional: true 
                })
                .depends({'cellularconfig' : '1'})
                .depends({'simswitch' : 'datalim' })
                .depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable':'1','enablecellular':'1','cellulardataswitchlimitenable':'1'});   
                
               
                s.taboption('cellularconfig',L.cbi.ListValue, 'cellulardatausagemanagerperiodicity', {
                        caption: L.tr('Periodicity'),
                })
                //.depends({'cellularconfig' : '1','CellularOperationMode' : 'singlecellulardualsim','CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable':'1'})
                 .depends({'cellularconfig' : '1'})
                 .depends({'simswitch' : 'datalim' })
                .depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable':'1','enablecellular':'1','cellulardataswitchlimitenable':'1'})
                 .value('none', L.tr('Select'))
                .value('monthly', L.tr('Monthly'))
                .value('daily', L.tr('Daily'));  
                
                
            var DaysVal = s.taboption('cellularconfig', L.cbi.ListValue, 'dayofmonth', {
            caption: L.tr('Day Of Month'),
            optional: true,
            listlimit: 31,
            listcustom:false
        }).depends({'cellulardatausagemanagerperiodicity':'monthly'})
        .value('',L.tr('-- Please choose --'))
        DaysVal.load = function(sid) {
            var days = [ ];
            for (var i = 1; i <= 31; i++)
                days.push(i);
            days.sort();
            for (var i = 1; i <= days.length; i++)
                DaysVal.value(i);
        };

       s.commit=function(){
			
                 self.updatesimswitchconfig('configure').then(function(rv) {
				               
                });
           }
                   
		                        
        return m.insertInto('#map');
    }
});
