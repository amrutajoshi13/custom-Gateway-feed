L.ui.view.extend({
        title: L.tr('Temperature Sensors Configuration'),
        description: L.tr(''),
        
        RS485GetUCISections: L.rpc.declare({
                object: 'uci',
                method: 'get',
                params: [ 'config', 'type'],
                expect: { values: {} }
        }),
        
        RS485CreateUCISection:  L.rpc.declare({
                object: 'uci',
                method: 'add',
                params: [ 'config', 'type', 'name', 'values' ]
        }),
        
        RS485CommitUCISection:  L.rpc.declare({
                object: 'uci',
                method: 'commit',
                params: [ 'config' ]
        }),
        
        RS485DeleteUCISection:  L.rpc.declare({
		object: 'uci',
		method: 'delete',
		params: [ 'config','type','section' ]
	}),
			
        RS485FormCallback: function() 
        {
                var map = this;
                var RS485ConfigSectionName = map.options.RS485ConfigSection;
                var numericExpression = /^[0-9]+$/;
                
                map.options.caption = L.tr(RS485ConfigSectionName+' Configuration');
                
                var s = map.section(L.cbi.NamedSection, RS485ConfigSectionName, {
                        collabsible: true
                });
               
               s.option(L.cbi.InputValue,'TemperatureID' ,{                           
                       caption: L.tr('Temperature ID')                                
               }); 
               
                           
                s.option(L.cbi.InputValue,'Address',{
                        caption: L.tr('Address'),   
                });         
       
           },
		
        RS485ConfigCreateForm: function(mapwidget,RS485ConfigSectionName) 
        {
                var self = this;
                
                if (!mapwidget)
                        mapwidget = L.cbi.Map;
                
                var map = new mapwidget('temperatureconfig', {
                        prepare: self.RS485FormCallback,
                        RS485ConfigSection: RS485ConfigSectionName
                });
                return map;
        },
        
        RS485RenderContents: function(rv) 
        {
                var self = this;

                var list = new L.ui.table({
                        columns: [{
                                caption: L.tr('Sl No'),
                                align: 'left',
                                format: function(v, n) {
                                        var div = $('<p />').attr('id', 'RS485DeviceSerialNo_%s'.format(n));
                                        var serialNo=n+1;
					return div.append('<strong>'+serialNo+'<strong>');
                                }
                             },  
                             
                                                             
					                                               
                            {
                                caption: L.tr('Name'),
                                        width:'30%',
                                align: 'left',
                                format: function(v,n) {
                                        var div = $('<p />').attr('id', 'RS485DeviceEventName_%s'.format(n));
                                        return div.append('<strong>'+v+'</strong>');
                                }
                        },
                        
                        
								
                        { 
									caption: L.tr('TemperatureID'),
									format:  function(v,n) {
										var div = $('<b />').attr('id', 'TemperatureID_%s'.format(n));
										return div.append('<strong>'+v+'</strong>');
									}
								}, 
								
								 { 
									caption: L.tr('Address'),
									format:  function(v,n) {
										var div = $('<b />').attr('id', 'Address_%s'.format(n));
										return div.append('<strong>'+v+'</strong>');
									}
								},
								
								//{ 
									//caption: L.tr('Config'),
									//format:  function(v,n) {
										//var div = $('<b />').attr('id', 'Config_%s'.format(n));
										//return div.append('<strong>'+v+'</strong>');
									//}
								//},  
                         
                        {
                                caption: L.tr('Update'),
                                align: 'left',
                                format: function(v, n) {
                                        return $('<div />')
                                                .addClass('btn-group btn-group-sm')
                                                .append(L.ui.button(L.tr('Edit'),'primary', L.tr('Configure'))
                                                .click({ self: self, RS485ConfigSectionName: v }, self.RS485ConfigSectionEdit))
                                                .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                                .click({ self: self, RS485ConfigSectionName: v }, self.RS485ConfigSectionRemove));
                                }
                        }]
                });
                
                for (var key in rv) 
                {
                        if (rv.hasOwnProperty(key)) 
                        {
                                var obj = rv[key];
                                var TemperatureID=obj.TemperatureID;
                                //alert(InterfaceID);
                                var Address=obj.Address;
                                //var SlaveID=obj.SlaveAddress;
                                //var Baudrate=obj.Baudrate;
                                //var FunctionCode=obj.FunctionalCode;
                                //var Parity=obj.Parity;
                                //var Databits=obj.Databits;
                                //var Stopbits=obj.NoOfStopbits;
                                
                                //let Config = `Sl:${SlaveID} B:${Baudrate} F:${FunctionCode} P:${Parity} D:${Databits} St:${Stopbits}`;
                                                               
                                //alert(MeterID);
                              //  list.row([obj.name,InterfaceID,MeterID,key]); 
                               list.row([key,key,TemperatureID,Address,key]);
                             //   list.row([key,key,InterfaceID,Config,key]); 
                        }
                }
                        
                $('#map').
                        append(list.render());		
        },
		
        RS485ConfigSectionAdd: function () 
        {
                var self = this;
                var RS485ConfigSectionName = $('#field_NewEvent_name').val();
               // var RS485ConfigSectionInterfaceID = $('#field_NewEvent_InterfaceID').val();
               // var sensorSectionOptions = {EEnable:0,InterfaceID:RS485ConfigSectionInterfaceID};
               var sensorSectionOptions = {EEnable:0};
                this.RS485GetUCISections("temperatureconfig","temperatureconfig").then(function(rv) {
                        var keys = Object.keys(rv);
                        var keysLength=keys.length;
                        if(keysLength>8)
                        {
                                alert("Only 8 sensors can be configured");
                        }
                        else
                        {
                                self.RS485CreateUCISection("temperatureconfig","TemperatureConfig",RS485ConfigSectionName,sensorSectionOptions).then(function(rv){
                                        if(rv)
                                        {
                                                if (rv.section)
                                                {
                                                        self.RS485CommitUCISection("temperatureconfig").then(function(res){
                                                              	
								if (res != 0) 
                                                                {
									alert("Error:New Event Configuration");
                                                                }
                                                                else 
                                                                {
                                                                        location.reload();
                                                                }
                                                        });
                                                };
                                        };
                                }); 
                        }
                });
        },
        
        RS485ConfigSectionRemove: function(ev) 
        {
		var self = ev.data.self;
		var RS485ConfigSectionName = ev.data.RS485ConfigSectionName;
		self.RS485DeleteUCISection("temperatureconfig","TemperatureConfig",RS485ConfigSectionName).then(function(rv){
			if(rv == 0){
				self.RS485CommitUCISection("temperatureconfig").then(function(res){
					if (res != 0)
                                        {
						alert("Error: Delete Sensor Configuration");
					}
					else 
                                        {
						location.reload();
					}
				});
			};
		});
	},
        
        RS485ConfigSectionEdit: function(ev) 
        {
                var self = ev.data.self;
                var RS485ConfigSectionName = ev.data.RS485ConfigSectionName;
                return self.RS485ConfigCreateForm(L.cbi.Modal,RS485ConfigSectionName).show();
        },
        
        execute:function()
        {
                var self = this;
                $('#AddNewEvent').click(function() {  
                        self.RS485ConfigSectionAdd();
                });
                self.RS485GetUCISections("temperatureconfig","TemperatureConfig").then(function(rv) {
                        self.RS485RenderContents(rv);
                });
        }
});
