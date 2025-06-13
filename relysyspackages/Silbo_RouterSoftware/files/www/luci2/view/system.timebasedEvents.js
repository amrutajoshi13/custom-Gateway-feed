L.ui.view.extend({

        title: L.tr('Time Based Events'),
        description: L.tr(''),
        
        timeGetUCISections: L.rpc.declare({
                object: 'uci',
                method: 'get',
                params: [ 'config', 'type' ],
                expect: { values: {} }
        }),
        
        timeCreateUCISection:  L.rpc.declare({
                object: 'uci',
                method: 'add',
                params: [ 'config', 'type', 'name', 'values' ]
        }),
        
        timeCommitUCISection:  L.rpc.declare({
                object: 'uci',
                method: 'commit',
                params: [ 'config' ]
        }),
        
        timeDeleteUCISection:  L.rpc.declare({
		object: 'uci',
		method: 'delete',
		params: [ 'config','type','section']
	}),

        timeActionCreateFormCallback: function() {
                var map = this;
                var timeActionSectionName = map.options.timeActionSection;
                
                map.options.caption = L.tr(timeActionSectionName+' Configuration');
                
                var s = map.section(L.cbi.SingleSection, timeActionSectionName, {
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
                	
                s.taboption('event', L.cbi.CheckboxValue, 'enable', {
                        caption: L.tr('Enable'),
                        optional: true
                });
                
                s.taboption('event', L.cbi.TimeValue, 'eventTime', {
                        caption: L.tr('Time')
                }).depends({'enable':'1'});
                
                s.taboption('action1', L.cbi.ListValue, 'a1Type', {
                        caption: L.tr('Type')
                }).depends({'enable':'1'})
                .value("none", L.tr("None"))
                //.value("relay", L.tr("Relay Control"))
                .value("reboot", L.tr("Maintenance Reboot"));
                                                
                s.taboption('action1', L.cbi.ListValue, 'a1RebootType', {
                        caption: L.tr('Reboot Type'),
                        optional: true
                }).depends({'enable':'1','a1Type':'reboot'})
                .value("system", L.tr("Software"))
                .value("hardware", L.tr("Hardware"));
        },
		
        timeActionCreateForm: function(mapwidget,timeActionSectionName) {
                var self = this;
                if (!mapwidget)
                        mapwidget = L.cbi.Map;
                
                var map = new mapwidget('TimeBasedEventsActions', {
                        prepare: self.timeActionCreateFormCallback,
                        timeActionSection: timeActionSectionName
                });
                return map;
        },
		
        timeRenderContents: function(rv) {
                var self = this;

                var list = new L.ui.table({
                        columns: [{
                                caption: L.tr('Name'),
                                        width:'30%',
                                align: 'left',
                                format: function(v,n) {
                                        var div = $('<p />').attr('id', 'timeEventName_%s'.format(n));
                                        return div.append('<strong>'+v+'</strong>');
                                }
                        },{
                                caption: L.tr('Description'),
                                align: 'left',
                                format: function(v, n) {
                                        var div = $('<small />').attr('id', 'timeEventDesc__%s'.format(n));
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
                                                .click({ self: self, timeActionSectionName: v }, self.timeActionSectionEdit))
                                                .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                                .click({ self: self, timeActionSectionName: v }, self.timeSectionRemove));
                                }
                        }]
                });
                
                for (var key in rv) {
                        if (rv.hasOwnProperty(key)) {
                                var obj = rv[key];
                                var enable = obj.enable;
                                var time = obj.eventTime;
                                var DescIOCardType = obj.a1IOCardType;
                                var DescActionType = obj.a1Type;
                                var DescIOCardNo = obj.a1IOCardNo;
                                var DescRebootType = obj.a1RebootType;
                                var Description;
                                if(enable==1)
                                {
                                        var Description1 = "EVENT: Time- " + time;
                                        if(DescActionType=="relay") {
                                                if (DescIOCardType == 'AI4DIO22')
                                                        DescDINo=obj.a1AI4DIO22_RelayNo;
                                                else if (DescIOCardType == 'DIO16')
                                                        DescDINo=obj.a1DIO16_RelayNo;
                                                var Description2 = "ACTION: "+ DescDINo + " of IOCard-"+DescIOCardNo ;
                                        
                                        }
                                        else if(DescActionType=="reboot")
                                        {
                                                var Description2 = "ACTION: Reboot (" +DescRebootType+ ")";
                                        }
                                        else {
                                                var Description2 = "ACTION: None" ;
                                        }
                                        
                                        Description=Description1+"<br/>"+Description2 ;
                                }
                                else
                                {
                                        Description="Event Disabled";
                                }
                                
                                list.row([ key,Description,key]); 
                        }
                }
			
                $('#map').
                        append(list.render());		
        },
        
        timeActionSectionEdit: function(ev) {
                var self = ev.data.self;
                var timeActionSectionName = ev.data.timeActionSectionName;
                return self.timeActionCreateForm(L.cbi.Modal,timeActionSectionName).show();
        },
        
        timeSectionAdd: function () 
        {
                var self = this;
                var EventName = $('#field_NewEvent_name').val();
                var EventTime = $('#field_NewEvent_time').val();

                var SectionOptions = {enable:1,eventTime:EventTime};
                
                this.timeCreateUCISection("TimeBasedEventsActions","TimeBasedEventsActions",EventName,SectionOptions).then(function(rv){
                        if(rv){
                                if (rv.section){
                                        self.timeCommitUCISection("TimeBasedEventsActions").then(function(res){
                                                alert(res);
						if (res != 0) {
                                                        alert("Error:New Event Configuration");
                                                }
                                                else {
                                                        location.reload();
                                                }
                                        });
                                };
                        };
                });
        },
        
        timeSectionRemove: function(ev) {
		var self = ev.data.self;
		var timeSectionName = ev.data.timeActionSectionName;
		self.timeDeleteUCISection("TimeBasedEventsActions","TimeBasedEventsActions",timeSectionName).then(function(rv){
			if(rv == 0){
				self.timeCommitUCISection("TimeBasedEventsActions").then(function(res){
					if (res != 0){
						alert("Error: Delete Timebased Configuration");
					}
					else {
						location.reload();
					}
					
				});
			};
		});
	},
        
        execute:function()
        {
                var self = this;

		$('#field_NewEvent_time').combodate();

                $('#AddNewEvent').click(function() {  
                        self.timeSectionAdd();
                });
                return self.timeGetUCISections("TimeBasedEventsActions","TimeBasedEventsActions").then(function(rv) {
                        return self.timeRenderContents(rv);
                });
        }
});
