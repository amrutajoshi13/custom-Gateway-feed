L.ui.view.extend({
        title: L.tr('Sensor Events'),
        description: L.tr(''),
        
        sensorGetUCISections: L.rpc.declare({
                object: 'uci',
                method: 'get',
                params: [ 'config', 'type'],
                expect: { values: {} }
        }),
        
        sensorCreateUCISection:  L.rpc.declare({
                object: 'uci',
                method: 'add',
                params: [ 'config', 'type', 'name', 'values' ]
        }),
        
        sensorCommitUCISection:  L.rpc.declare({
                object: 'uci',
                method: 'commit',
                params: [ 'config' ]
        }),
        
        sensorDeleteUCISection:  L.rpc.declare({
		object: 'uci',
		method: 'delete',
		params: [ 'config','type','section' ]
	}),
			
        sensorActionCreateFormCallback: function() 
        {
                var map = this;
                var sensorActionSectionName = map.options.sensorActionSection;
                var numericExpression = /^[0-9]+$/;
                
                map.options.caption = L.tr(sensorActionSectionName+' Configuration');
                
                var s = map.section(L.cbi.SingleSection, sensorActionSectionName, {
                        collabsible: true
                });
                
                s.tab({
                        id: 'event',
                        caption: L.tr('Event')
                });
                
                s.tab({
                        id: 'action1',
                        caption: L.tr('Action1')
                });
        
                 s.tab({
                        id: 'action2',
                        caption: L.tr('Action2')
                });
                
                s.taboption('event', L.cbi.CheckboxValue, 'EEnable', {
                        caption: L.tr('Enable'),
                        optional: true
                });
                
				s.taboption('event', L.cbi.ListValue, 'SensorType', {
                        caption: L.tr('Sensor Type')
                }).depends({'EEnable':'1'})
                .value("0", L.tr("Digital Input"))
                .value("1", L.tr("Relay"))
                .value("2", L.tr("Analog Input"))
                .value("3", L.tr("Temperature sensor"));
                                        
                s.taboption('event', L.cbi.InputValue, 'DINo', {     
                        caption: L.tr('Digital Input No'),
                        datatype: function divalid(num) {
                                var CDINo = parseInt(num);
                                if(CDINo>4 ||CDINo==0|| (! num.match(numericExpression)))
                                        return L.tr('Digital Input number must not be greater than 4');
                                        return false; 
                        }
                }).depends({'EEnable':'1','SensorType':'0'});
                
                s.taboption('event', L.cbi.InputValue, 'RelayNo', {     
                        caption: L.tr('Relay No'),
                        datatype: function divalid(num) {
                                var CDINo = parseInt(num);
                                if(CDINo>4||CDINo==0 || (! num.match(numericExpression)))
                                        return L.tr('Relay number must not be greater than 4');
                                        return false; 
                        }
                }).depends({'EEnable':'1','SensorType':'1'});
                
                s.taboption('event', L.cbi.ListValue, 'AlarmActiveState', {     
                        caption: L.tr('Alarm Active State'),
                }).depends({'EEnable':'1','SensorType':'0'})
                .depends({'EEnable':'1','SensorType':'1'})
                .value("0", L.tr("0"))
                .value("1", L.tr("1"));
                
                s.taboption('event', L.cbi.InputValue, 'AINo', {     
                        caption: L.tr('Analog Input No'),
                        datatype: function divalid(num) {
                                var CDINo = parseInt(num);
                                if(CDINo>2 ||CDINo==0 || (! num.match(numericExpression)))
                                        return L.tr('Analog input number must not be greater than 2');
                                        return false; 
                        }
                }).depends({'EEnable':'1','SensorType':'2'});
                
                s.taboption('event', L.cbi.InputValue, 'TempSensorNo', {     
                        caption: L.tr('Temperature Sensor No'),
                }).depends({'EEnable':'1','SensorType':'3'});
                
                (s.taboption('action1',L.cbi.DummyValue, '__Action1ActiveDigitalInput', {
                        caption:        L.tr('')
                }).depends({'EEnable':'1','SensorType':'0'})
                .depends({'EEnable':'1','SensorType':'1'}))
                .ucivalue=function()     
                {
                        var id="<h4><b>&nbsp &nbsp &nbsp &nbsp &nbsp Alarm Active Status</b> </h4>";
                        return id;
                };
                
                (s.taboption('action1',L.cbi.DummyValue, '__Action1ActiveAnalogInput', {
                        caption:        L.tr('')
                }).depends({'EEnable':'1','SensorType':'2'})
                .depends({'EEnable':'1','SensorType':'3'}))
                .ucivalue=function()     
                {
                        var id="<h4><b>&nbsp &nbsp &nbsp Above Maximum Threshold Level</b> </h4>";
                        return id;
                };
                	
                s.taboption('action1', L.cbi.ListValue, 'Action1ActiveType', {
                        caption: L.tr('Type')
                }).depends({'EEnable':'1'})
                .value("none", L.tr("None"))
                .value("relay", L.tr("Relay Control"));
                
                s.taboption('action1', L.cbi.ListValue, 'Action1ActiveRelayNo', {
                        caption: L.tr('Relay Number'),
                        optional:true,
                }).depends({'EEnable':'1','Action1ActiveType':'relay'})
                .value("1", L.tr("Relay1"))
                .value("2", L.tr("Relay2"))
                .value("3", L.tr("Relay3"))
                .value("4", L.tr("Relay4"));
			
                s.taboption( 'action1', L.cbi.ListValue, 'Action1ActiveRelayAction', {
                        caption: L.tr('Relay Action')
                }).depends({'EEnable':'1','Action1ActiveType':'relay'})
                .value("0", L.tr("Continuous On"))
                .value("1", L.tr("Continuous Off"))
                .value("2", L.tr("On with Timeout"))
                .value("3", L.tr("Off with Timeout"))
                .value("4", L.tr("On & Off"));
                
                s.taboption('action1', L.cbi.InputValue, 'Action1ActiveRelayOnTimeOut', {
                        caption: L.tr('On Timeout'),
                        description: L.tr('In seconds'),
                        datatype:'integer',
                        initial: 30
                }).depends({'EEnable':'1','Action1ActiveType':'relay','Action1ActiveRelayAction':'2'})
                .depends({'EEnable':'1','Action1ActiveType':'relay','Action1ActiveRelayAction':'4'});
  
                s.taboption('action1', L.cbi.InputValue, 'Action1ActiveRelayOffTimeOut', {
                        caption: L.tr('Off Timeout'),
                        description: L.tr('In seconds'),
                        datatype:'integer',
                        initial: 30
                }).depends({'EEnable':'1','Action1ActiveType':'relay','Action1ActiveRelayAction':'3'})
                .depends({'EEnable':'1','Action1ActiveType':'relay','Action1ActiveRelayAction':'4'});
                
                (s.taboption('action1',L.cbi.DummyValue, '__Action1InactiveDigitalInput', {
                        caption: L.tr('')
                }).depends({'EEnable':'1','SensorType':'0'})
                .depends({'EEnable':'1','SensorType':'1'}))
                .ucivalue=function()     
                {
                        var id="<h4><b>&nbsp &nbsp &nbsp &nbsp &nbsp Alarm Inactive Status</b> </h4>";
                        return id;
                };
                
                (s.taboption('action1',L.cbi.DummyValue, '__Action1InactiveAnalogInput', {
                        caption:        L.tr('')
                }).depends({'EEnable':'1','SensorType':'2'})
                .depends({'EEnable':'1','SensorType':'3'}))
                .ucivalue=function()     
                {
                        var id="<h4><b>&nbsp &nbsp &nbsp Between Threshold Level</b> </h4>";
                        return id;
                };
                
                s.taboption('action1', L.cbi.ListValue, 'Action1InactiveType', {
                        caption: L.tr('Type')
                }).depends({'EEnable':'1'})
                .value("none", L.tr("None"))
                .value("relay", L.tr("Relay Control"));
                
                s.taboption('action1', L.cbi.ListValue, 'Action1InactiveRelayNo', {
                        caption: L.tr('Relay Number'),
                        optional: true
                }).depends({'EEnable':'1','Action1InactiveType':'relay'})
                .value("1", L.tr("Relay1"))
                .value("2", L.tr("Relay2"))
                .value("3", L.tr("Relay3"))
                .value("4", L.tr("Relay4"));
                
                s.taboption( 'action1', L.cbi.ListValue, 'Action1InactiveRelayAction', {
                        caption: L.tr('Relay Action'),
                }).depends({'EEnable':'1','Action1InactiveType':'relay'})
                .value("0", L.tr("Continuous On"))
                .value("1", L.tr("Continuous Off"))
                .value("2", L.tr("On with Timeout"))
                .value("3", L.tr("Off with Timeout"))
                .value("4", L.tr("On & Off"));
                
                s.taboption('action1', L.cbi.InputValue, 'Action1InactiveRelayOnTimeOut', {
                        caption: L.tr('On Timeout'),
                        description: L.tr('In seconds'),
                        datatype:'integer',
                        initial: 30
                }).depends({'EEnable':'1','Action1InactiveType':'relay','Action1InactiveRelayAction':'2'})
                .depends({'EEnable':'1','Action1InactiveType':'relay','Action1InactiveRelayAction':'4'});
                
                s.taboption('action1', L.cbi.InputValue, 'Action1InactiveRelayOffTimeOut', {
                        caption: L.tr('Off Timeout'),
                        description: L.tr('In seconds'),
                        datatype:'integer',
                        initial: 30
                }).depends({'EEnable':'1','Action1InactiveType':'relay','Action1InactiveRelayAction':'3'})
                .depends({'EEnable':'1','Action1InactiveType':'relay','Action1InactiveRelayAction':'4'});

                (s.taboption('action1',L.cbi.DummyValue, '__Action1NormalAnalogInput', {
                        caption:        L.tr('')
                }).depends({'EEnable':'1','SensorType':'2'})
                .depends({'EEnable':'1','SensorType':'3'}))
                .ucivalue=function()     
                {
                        var id="<h4><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp Below Minimum Threshold Level</b> </h4>";
                        return id;
                };
                
                s.taboption('action1', L.cbi.ListValue, 'Action1NormalType', {
                        caption: L.tr('Type')
                }).depends({'EEnable':'1','SensorType':'2'})
                .depends({'EEnable':'1','SensorType':'3'})
                .value("none", L.tr("None"))
                .value("relay", L.tr("Relay Control"));
                
                s.taboption('action1', L.cbi.ListValue, 'Action1NormalRelayNo', {
                        caption: L.tr('Relay Number'),
                        optional:true,
                }).depends({'EEnable':'1','SensorType':'2','Action1NormalType':'relay'})
                .depends({'EEnable':'1','SensorType':'3','Action1NormalType':'relay'})
                .value("1", L.tr("Relay1"))
                .value("2", L.tr("Relay2"))
                .value("3", L.tr("Relay3"))
                .value("4", L.tr("Relay4"));
			
                s.taboption( 'action1', L.cbi.ListValue, 'Action1NormalRelayAction', {
                        caption: L.tr('Relay Action')
                }).depends({'EEnable':'1','SensorType':'2','Action1NormalType':'relay'})
                .depends({'EEnable':'1','SensorType':'3','Action1NormalType':'relay'})
                .value("0", L.tr("Continuous On"))
                .value("1", L.tr("Continuous Off"))
                .value("2", L.tr("On with Timeout"))
                .value("3", L.tr("Off with Timeout"))
                .value("4", L.tr("On & Off"));
                
                s.taboption('action1', L.cbi.InputValue, 'Action1NormalRelayOnTimeOut', {
                        caption: L.tr('On Timeout'),
                        description: L.tr('In seconds'),
                        datatype:'integer',
                        initial: 30
                }).depends({'EEnable':'1','SensorType':'2','Action1NormalType':'relay','Action1NormalRelayAction':'2'})
                .depends({'EEnable':'1','SensorType':'2','Action1NormalType':'relay','Action1NormalRelayAction':'4'})
                .depends({'EEnable':'1','SensorType':'3','Action1NormalType':'relay','Action1NormalRelayAction':'2'})
                .depends({'EEnable':'1','SensorType':'3','Action1NormalType':'relay','Action1NormalRelayAction':'4'});
  
                s.taboption('action1', L.cbi.InputValue, 'Action1NormalRelayOffTimeOut', {
                        caption: L.tr('Off Timeout'),
                        description: L.tr('In seconds'),
                        datatype:'integer',
                        initial: 30
                }).depends({'EEnable':'1','SensorType':'2','Action1NormalType':'relay','Action1NormalRelayAction':'3'})
                .depends({'EEnable':'1','SensorType':'2','Action1NormalType':'relay','Action1NormalRelayAction':'4'})
                .depends({'EEnable':'1','SensorType':'3','Action1NormalType':'relay','Action1NormalRelayAction':'3'})
                .depends({'EEnable':'1','SensorType':'3','Action1NormalType':'relay','Action1NormalRelayAction':'4'});
                
                (s.taboption('action2',L.cbi.DummyValue, '__Action2ActiveDigitalInput', {
                        caption:        L.tr('')
                }).depends({'EEnable':'1','SensorType':'0'})
                .depends({'EEnable':'1','SensorType':'1'}))
                .ucivalue=function()     
                {
                        var id="<h4><b>&nbsp &nbsp &nbsp &nbsp &nbsp Alarm Active Status</b> </h4>";
                        return id;
                };
                
                (s.taboption('action2',L.cbi.DummyValue, '__Action2ActiveAnalogInput', {
                        caption:        L.tr('')
                }).depends({'EEnable':'1','SensorType':'2'})
                .depends({'EEnable':'1','SensorType':'3'}))
                .ucivalue=function()     
                {
                        var id="<h4><b>&nbsp &nbsp &nbsp Above Maximum Threshold Level</b> </h4>";
                        return id;
                };
                	
                s.taboption('action2', L.cbi.ListValue, 'Action2ActiveType', {
                        caption: L.tr('Type')
                }).depends({'EEnable':'1'})
                .value("none", L.tr("None"))
                .value("relay", L.tr("Relay Control"));
                
                s.taboption('action2', L.cbi.ListValue, 'Action2ActiveRelayNo', {
                        caption: L.tr('Relay Number'),
                        optional:true,
                }).depends({'EEnable':'1','Action2ActiveType':'relay'})
                .value("1", L.tr("Relay1"))
                .value("2", L.tr("Relay2"))
                .value("3", L.tr("Relay3"))
                .value("4", L.tr("Relay4"));
			
                s.taboption( 'action2', L.cbi.ListValue, 'Action2ActiveRelayAction', {
                        caption: L.tr('Relay Action')
                }).depends({'EEnable':'1','Action2ActiveType':'relay'})
                .value("0", L.tr("Continuous On"))
                .value("1", L.tr("Continuous Off"))
                .value("2", L.tr("On with Timeout"))
                .value("3", L.tr("Off with Timeout"))
                .value("4", L.tr("On & Off"));
                
                s.taboption('action2', L.cbi.InputValue, 'Action2ActiveRelayOnTimeOut', {
                        caption: L.tr('On Timeout'),
                        description: L.tr('In seconds'),
                        datatype:'integer',
                        initial: 30
                }).depends({'EEnable':'1','Action2ActiveType':'relay','Action2ActiveRelayAction':'2'})
                .depends({'EEnable':'1','Action2ActiveType':'relay','Action2ActiveRelayAction':'4'});
  
                s.taboption('action2', L.cbi.InputValue, 'Action2ActiveRelayOffTimeOut', {
                        caption: L.tr('Off Timeout'),
                        description: L.tr('In seconds'),
                        datatype:'integer',
                        initial: 30
                }).depends({'EEnable':'1','Action2ActiveType':'relay','Action2ActiveRelayAction':'3'})
                .depends({'EEnable':'1','Action2ActiveType':'relay','Action2ActiveRelayAction':'4'});
                
                (s.taboption('action2',L.cbi.DummyValue, '__Action2InactiveDigitalInput', {
                        caption: L.tr('')
                }).depends({'EEnable':'1','SensorType':'0'})
                .depends({'EEnable':'1','SensorType':'1'}))
                .ucivalue=function()     
                {
                        var id="<h4><b>&nbsp &nbsp &nbsp &nbsp &nbsp Alarm Inactive Status</b> </h4>";
                        return id;
                };
                
                (s.taboption('action2',L.cbi.DummyValue, '__Action2InactiveAnalogInput', {
                        caption:        L.tr('')
                }).depends({'EEnable':'1','SensorType':'2'})
                .depends({'EEnable':'1','SensorType':'3'}))
                .ucivalue=function()     
                {
                        var id="<h4><b>&nbsp &nbsp &nbsp Between Threshold Level</b> </h4>";
                        return id;
                };
                
                s.taboption('action2', L.cbi.ListValue, 'Action2InactiveType', {
                        caption: L.tr('Type')
                }).depends({'EEnable':'1'})
                .value("none", L.tr("None"))
                .value("relay", L.tr("Relay Control"));
                
                s.taboption('action2', L.cbi.ListValue, 'Action2InactiveRelayNo', {
                        caption: L.tr('Relay Number'),
                        optional: true
                }).depends({'EEnable':'1','Action2InactiveType':'relay'})
                .value("1", L.tr("Relay1"))
                .value("2", L.tr("Relay2"))
                .value("3", L.tr("Relay3"))
                .value("4", L.tr("Relay4"));
                
                s.taboption( 'action2', L.cbi.ListValue, 'Action2InactiveRelayAction', {
                        caption: L.tr('Relay Action'),
                }).depends({'EEnable':'1','Action2InactiveType':'relay'})
                .value("0", L.tr("Continuous On"))
                .value("1", L.tr("Continuous Off"))
                .value("2", L.tr("On with Timeout"))
                .value("3", L.tr("Off with Timeout"))
                .value("4", L.tr("On & Off"));
                
                s.taboption('action2', L.cbi.InputValue, 'Action2InactiveRelayOnTimeOut', {
                        caption: L.tr('On Timeout'),
                        description: L.tr('In seconds'),
                        datatype:'integer',
                        initial: 30
                }).depends({'EEnable':'1','Action2InactiveType':'relay','Action2InactiveRelayAction':'2'})
                .depends({'EEnable':'1','Action2InactiveType':'relay','Action2InactiveRelayAction':'4'});
                
                s.taboption('action2', L.cbi.InputValue, 'Action2InactiveRelayOffTimeOut', {
                        caption: L.tr('Off Timeout'),
                        description: L.tr('In seconds'),
                        datatype:'integer',
                        initial: 30
                }).depends({'EEnable':'1','Action2InactiveType':'relay','Action2InactiveRelayAction':'3'})
                .depends({'EEnable':'1','Action2InactiveType':'relay','Action2InactiveRelayAction':'4'});

                (s.taboption('action2',L.cbi.DummyValue, '__Action2NormalAnalogInput', {
                        caption:        L.tr('')
                }).depends({'EEnable':'1','SensorType':'2'})
                .depends({'EEnable':'1','SensorType':'3'}))
                .ucivalue=function()     
                {
                        var id="<h4><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp Below Minimum Threshold Level</b> </h4>";
                        return id;
                };
                
                s.taboption('action2', L.cbi.ListValue, 'Action2NormalType', {
                        caption: L.tr('Type')
                }).depends({'EEnable':'1','SensorType':'2'})
                .depends({'EEnable':'1','SensorType':'3'})
                .value("none", L.tr("None"))
                .value("relay", L.tr("Relay Control"));
                
                s.taboption('action2', L.cbi.ListValue, 'Action2NormalRelayNo', {
                        caption: L.tr('Relay Number'),
                        optional:true,
                }).depends({'EEnable':'1','SensorType':'2','Action2NormalType':'relay'})
                .depends({'EEnable':'1','SensorType':'3','Action2NormalType':'relay'})
                .value("1", L.tr("Relay1"))
                .value("2", L.tr("Relay2"))
                .value("3", L.tr("Relay3"))
                .value("4", L.tr("Relay4"));
			
                s.taboption( 'action2', L.cbi.ListValue, 'Action2NormalRelayAction', {
                        caption: L.tr('Relay Action')
                }).depends({'EEnable':'1','SensorType':'2','Action2NormalType':'relay'})
                .depends({'EEnable':'1','SensorType':'3','Action2NormalType':'relay'})
                .value("0", L.tr("Continuous On"))
                .value("1", L.tr("Continuous Off"))
                .value("2", L.tr("On with Timeout"))
                .value("3", L.tr("Off with Timeout"))
                .value("4", L.tr("On & Off"));
                
                s.taboption('action2', L.cbi.InputValue, 'Action2NormalRelayOnTimeOut', {
                        caption: L.tr('On Timeout'),
                        description: L.tr('In seconds'),
                        datatype:'integer',
                        initial: 30
                }).depends({'EEnable':'1','SensorType':'2','Action2NormalType':'relay','Action2NormalRelayAction':'2'})
                .depends({'EEnable':'1','SensorType':'2','Action2NormalType':'relay','Action2NormalRelayAction':'4'})
                .depends({'EEnable':'1','SensorType':'3','Action2NormalType':'relay','Action2NormalRelayAction':'2'})
                .depends({'EEnable':'1','SensorType':'3','Action2NormalType':'relay','Action2NormalRelayAction':'4'});
  
                s.taboption('action2', L.cbi.InputValue, 'Action2NormalRelayOffTimeOut', {
                        caption: L.tr('Off Timeout'),
                        description: L.tr('In seconds'),
                        datatype:'integer',
                        initial: 30
                }).depends({'EEnable':'1','SensorType':'2','Action2NormalType':'relay','Action2NormalRelayAction':'3'})
                .depends({'EEnable':'1','SensorType':'2','Action2NormalType':'relay','Action2NormalRelayAction':'4'})
                .depends({'EEnable':'1','SensorType':'3','Action2NormalType':'relay','Action2NormalRelayAction':'3'})
                .depends({'EEnable':'1','SensorType':'3','Action2NormalType':'relay','Action2NormalRelayAction':'4'});

        },
		
        SensorActionCreateForm: function(mapwidget,sensorActionSectionName) 
        {
                var self = this;
                
                if (!mapwidget)
                        mapwidget = L.cbi.Map;
                
                var map = new mapwidget('BLControlSensorEventsActions', {
                        prepare: self.sensorActionCreateFormCallback,
                        sensorActionSection: sensorActionSectionName
                });
                return map;
        },
        
        sensorRenderContents: function(rv) 
        {
                var self = this;

                var list = new L.ui.table({
                        columns: [{
                                caption: L.tr('Sl No'),
                                align: 'left',
                                format: function(v, n) {
                                        var div = $('<p />').attr('id', 'sensorSerialNo_%s'.format(n));
                                        var serialNo=n+1;
					return div.append(serialNo);
                                }
                        },
                        {
                                caption: L.tr('Name'),
                                        width:'30%',
                                align: 'left',
                                format: function(v,n) {
                                        var div = $('<p />').attr('id', 'sensorEventName_%s'.format(n));
                                        return div.append('<strong>'+v+'</strong>');
                                }
                        },{
                                caption: L.tr('Description'),
                                align: 'left',
                                format: function(v, n) {
                                        var div = $('<small />').attr('id', 'sensorDescription_%s'.format(n));
                                        return div.append(v);
                                }
                        },
                        {
                                caption: L.tr('Update'),
                                align: 'left',
                                format: function(v, n) {
                                        return $('<div />')
                                                .addClass('btn-group btn-group-sm')
                                                .append(L.ui.button(L.tr('Edit'),'primary', L.tr('Configure'))
                                                .click({ self: self, sensorActionSectionName: v }, self.SensorActionSectionEdit))
                                                .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                                .click({ self: self, sensorActionSectionName: v }, self.SensorSectionRemove));
                                }
                        }]
                });
                
                for (var key in rv) 
                {
                        if (rv.hasOwnProperty(key)) 
                        {
                                var obj = rv[key];
                                var enable = obj.EEnable;
                                
                                var SensorType = obj.SensorType;
                                var Action1ActiveType = obj.Action1ActiveType;
                                var Action1InactiveType = obj.Action1InactiveType;
                                var Action1NormalType = obj.Action1NormalType;
                                
                                var Description;
                                var Description1;
                                var Description2;
                                var Description3;
                                
                                if(enable == 1)
                                {
									//event configuration
									if(SensorType == 0)
									{
										var SensorNo = obj.DINo;
										Description1="EVENT : DI-"+SensorNo;
									}
									else if(SensorType == 1)
									{
										var SensorNo = obj.RelayNo;
										Description1="EVENT : Relay-"+SensorNo;
									}
									else if(SensorType == 2)
									{
										var SensorNo = obj.AINo;
										Description1="EVENT : AI-"+SensorNo;
									}
									else if(SensorType == 3)
									{
										var SensorNo = obj.TempSensorNo;
										Description1="EVENT : Temperature Sensor-"+SensorNo;
									}
									else
									{
										Description1="None";
									}
									
									//action1 configuration
									if(Action1ActiveType == "relay")		
									{
										var Action1ActiveRelayNo = obj.Action1ActiveRelayNo;
										Description2="ACTION1 : Relay-"+Action1ActiveRelayNo+",";
									}
									else
									{
										Description2="ACTION1 : None,";	
									}		
									
									if((Action1InactiveType == "relay") && (SensorType > 1))
									{
										var Action1InactiveRelayNo = obj.Action1InactiveRelayNo;
										Description2=Description2+" Relay-"+Action1InactiveRelayNo+",";
									}
									else if(SensorType > 1)
									{
										Description2=Description2+" None,";
									}
									else if(Action1InactiveType == "relay")
									{
										var Action1InactiveRelayNo = obj.Action1InactiveRelayNo;
										Description2=Description2+" Relay-"+Action1InactiveRelayNo;
									}
									else
									{
										Description2=Description2+" None";
									}
									
									if(SensorType > 1)
									{
										if(Action1NormalType == "relay")
										{
											var Action1NormalRelayNo = obj.Action1NormalRelayNo;
											Description2=Description2+" Relay-"+Action1NormalRelayNo;
										}
										else
										{
											Description2=Description2+" None";
										}
									}	
									
									//action2 configuration
									if(Action1ActiveType == "relay")		
									{
										var Action1ActiveRelayNo = obj.Action1ActiveRelayNo;
										Description3="ACTION2 : Relay-"+Action1ActiveRelayNo+",";
									}
									else
									{
										Description3="ACTION2 : None,";	
									}
									
									if((Action1InactiveType == "relay") && (SensorType > 1))
									{
										var Action1InactiveRelayNo = obj.Action1InactiveRelayNo;
										Description3=Description3+" Relay-"+Action1InactiveRelayNo+",";
									}
									else if(SensorType > 1)
									{
										Description3=Description3+" None,";
									}
									else if(Action1InactiveType == "relay")
									{
										var Action1InactiveRelayNo = obj.Action1InactiveRelayNo;
										Description3=Description3+" Relay-"+Action1InactiveRelayNo;
									}
									else
									{
										Description3=Description3+" None";
									}
										
									if(SensorType > 1)
									{
										if(Action1NormalType == "relay")
										{
											var Action1NormalRelayNo = obj.Action1NormalRelayNo;
											Description3=Description3+" Relay-"+Action1NormalRelayNo;
										}
										else
										{
											Description3=Description3+" None";
										}
									}
									
									Description=Description1+"<br />"+Description2+"<br />"+Description3;
								}
								else
                                {
                                        Description ="Event Disabled";
                                }
                                list.row([key,key,Description,key]); 
                        }
                }
                        
                $('#map').
                        append(list.render());		
        },
		
        sensorSectionAdd: function () 
        {
                var self = this;
                var sensorSectionName = $('#field_NewEvent_name').val();
                var sensorSectionOptions = {name:sensorSectionName,EEnable:0};
               
                this.sensorGetUCISections("BLControlSensorEventsActions","SensorEventsActions").then(function(rv) {
                        var keys = Object.keys(rv);
                        var keysLength=keys.length;
                        if(keysLength>=50)
                        {
                                alert("Only 50 Sensor Events can be configured");
                        }
                        else
                        {
                                self.sensorCreateUCISection("BLControlSensorEventsActions","SensorEventsActions",sensorSectionName,sensorSectionOptions).then(function(rv){
                                        if(rv)
                                        {
                                                if (rv.section)
                                                {
                                                        self.sensorCommitUCISection("BLControlSensorEventsActions").then(function(res){
                                                              	
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
        
        SensorSectionRemove: function(ev) 
        {
		var self = ev.data.self;
		var sensorSectionName = ev.data.sensorActionSectionName;
		self.sensorDeleteUCISection("BLControlSensorEventsActions","SensorEventsActions",sensorSectionName).then(function(rv){
			if(rv == 0){
				self.sensorCommitUCISection("BLControlSensorEventsActions").then(function(res){
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
        
        SensorActionSectionEdit: function(ev) 
        {
                var self = ev.data.self;
                var sensorActionSectionName = ev.data.sensorActionSectionName;
                return self.SensorActionCreateForm(L.cbi.Modal,sensorActionSectionName).show();
        },
        
        execute:function()
        {
                var self = this;
                $('#AddNewEvent').click(function() {  
                        self.sensorSectionAdd();
                });
                self.sensorGetUCISections("BLControlSensorEventsActions","SensorEventsActions").then(function(rv) {
                        self.sensorRenderContents(rv);
                });
        }
});
