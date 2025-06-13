L.ui.view.extend({

    title: L.tr('Maintenance Reboot'),
    
    
    fGetUCISections: L.rpc.declare({
        object: 'uci',
        method: 'get',
        params: [ 'config', 'type', 'section']  
    }),
    
    updateinterfaceconfig: L.rpc.declare({
        object: 'rpc-maintenancereboot',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
    }),
    
    RebootSystem: L.rpc.declare({
        object: 'rpc-importexport',
        method: 'rebootsys',
        expect: { output: '' }
    }),
    
    execute:function() {
		var self = this;
        var m = new L.cbi.Map('MaintenanceRebootAction', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'event', {
            caption:L.tr('Maintenance Reboot Configurations')
        });
        
        
        
        s.option( L.cbi.CheckboxValue, 'enable', {
            caption: L.tr('Enable Maintenance Reboot')
        });
        
         s.option( L.cbi.ListValue, 'SelectReboot', {
                        caption: L.tr('Type')
                }).depends({'enable':'1'})
                .value("reboot", L.tr("Maintenance Reboot"));
                
        s.option( L.cbi.ListValue, 'RebootType', {
                        caption: L.tr('Reboot Type'),
                        optional: true
                }).depends({'enable':'1','SelectReboot':'reboot'})
                //.value("system", L.tr("Software"))
                .value("hardware", L.tr("Hardware"));
                
         var MinuteVal = s.option( L.cbi.DynamicList, 'Minutes', {
            caption: L.tr('Minutes'),
            optional: true,
            listlimit: 60,
            listcustom: false
        }).depends({'enable':'1','SelectReboot':'reboot'})
        .value('',L.tr('-- Please choose --'))
        .value('*', L.tr('All'));

        MinuteVal.load = function(sid) {
            var minutes = [ ];
            for (var i = 0; i < 60; i++)
                minutes.push(i);
            minutes.sort();
            for (var i = 0; i < minutes.length; i++)
                MinuteVal.value(i);
        };

        var HourVal = s.option( L.cbi.DynamicList, 'Hours', {
            caption: L.tr('Hours'),
            optional: true,
            listlimit: 24,
            listcustom:false,
        }).depends({'enable':'1','SelectReboot':'reboot'})
        .value('',L.tr('-- Please choose --'))
        .value('*', L.tr('All'));

        HourVal.load = function(sid) {
            var hours = [ ];
            for (var i = 0; i < 24; i++)
                hours.push(i);
            hours.sort();
            for (var i = 0; i < hours.length; i++)
                HourVal.value(i);
        };

        var DaysVal = s.option( L.cbi.DynamicList, 'DayOfMonth', {
            caption: L.tr('Day Of Month'),
            optional: true,
            listlimit: 31,
            listcustom:false
        }).depends({'enable':'1','SelectReboot':'reboot'})
        .value('',L.tr('-- Please choose --'))
        .value('*', L.tr('All'));

        DaysVal.load = function(sid) {
            var days = [ ];
            for (var i = 1; i <= 31; i++)
                days.push(i);
            days.sort();
            for (var i = 1; i <= days.length; i++)
                DaysVal.value(i);
        };

        s.option( L.cbi.DynamicList, 'Month', {
            caption: L.tr('Month'),
            optional: true,
            listlimit: 12,
            listcustom:false
        }).depends({'enable':'1','SelectReboot':'reboot'})
        .value('*', L.tr('All'))
        .value('1', L.tr('January'))
        .value('2', L.tr('February'))
        .value('3', L.tr('March'))
        .value('4', L.tr('April'))
        .value('5', L.tr('May'))
        .value('6', L.tr('June'))
        .value('7', L.tr('July'))
        .value('8', L.tr('August'))
        .value('9', L.tr('September'))
        .value('10', L.tr('October'))
        .value('11', L.tr('November'))
        .value('12', L.tr('December'));

        s.option( L.cbi.DynamicList, 'DayOfWeek', {
            caption: L.tr('Day Of Week'),
            optional: true,
            listlimit: 12,
            listcustom:false
        }).depends({'enable':'1','SelectReboot':'reboot'})
        .value('*', L.tr('All'))
        .value('0', L.tr('Sunday'))
        .value('1', L.tr('Monday'))
        .value('2', L.tr('Tuesday'))
        .value('3', L.tr('Wednesday'))
        .value('4', L.tr('Thursday'))
        .value('5', L.tr('Friday'))
        .value('6', L.tr('Saturday'));
        
         $('#btn-reboot').click(function() 	{
							//L.ui.loading(true);
							alert('Rebooting the system...'); 
								self.RebootSystem().then(function(rv) {
				                   });				
                   });
        
        s.commit=function(){
                self.fGetUCISections('MaintenanceRebootAction','event').then(function(rv) {  
                self.updateinterfaceconfig('Update','updatemaintenancereboot').then(function(rv) {
               
                });
            });
        }
       
        
              return  m.insertInto('#map');   

        
    }
});
