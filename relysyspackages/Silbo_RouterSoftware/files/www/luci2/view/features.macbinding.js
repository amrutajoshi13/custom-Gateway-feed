L.ui.view.extend({
        title: L.tr('Mac Address Binding'),
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
	
	    updatemacconfig: L.rpc.declare({
        object: 'rpc-updatemacconfig',
        method: 'configure',
        expect: { output: '' }
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
                             
             
   s.option(L.cbi.DummyValue, 'name', {
                        caption: L.tr('Device Name')
                });
                
        
        s.option(L.cbi.InputValue, 'macaddress', {
                        caption: L.tr('MAC Address'),
                         datatype: 'macaddr',
                        optional: true 
                }).depends({'macbindconfig':'1'});
                
        
        s.option(L.cbi.InputValue, 'ipaddress', {
                        caption: L.tr('IP Address'),
                        datatype: 'ip4addr',
                        optional: true 
                }).depends({'macbindconfig':'1'});
        
         },  
           
		
        RS485ConfigCreateForm: function(mapwidget,RS485ConfigSectionName) 
        {
                var self = this;
                
                if (!mapwidget)
                        mapwidget = L.cbi.Map;
                
                var map = new mapwidget('macconfig', {
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
								return div.append(serialNo);
                                }
                        },
                        {
                                caption: L.tr('Device Name'),
                                        width:'30%',
                                align: 'left',
                                format: function(v,n) {
                                        var div = $('<p />').attr('id', 'RS485DeviceEventName_%s'.format(n));
                                        return div.append('<strong>'+v+'</strong>');
                                }
                        },
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
                                                list.appendTo('#section_mac_binding');
                                }
                        }]
                });
                
             
                for (var key in rv) 
                {
                        if (rv.hasOwnProperty(key)) 
                        {
                                var obj = rv[key];
                                list.row([key,key,key]); 
                        }
                }
                 
               $('#section_mac_binding').append(list.render());	 
        },
		
        RS485ConfigSectionAdd: function () 
        {
                var self = this;
                var RS485ConfigSectionName = $('#field_NewEvent_mac_name').val();
                var  RS485ConfigSection= {name:RS485ConfigSectionName};
                //var sensorSectionOptions = {EEnable:0};
               
               // this.RS485GetUCISections("vpnconfog1","RS485Config").then(function(rv) {
               this.RS485GetUCISections("macconfig","macconfig",RS485ConfigSectionName,RS485ConfigSection).then(function(rv) {
                        var keys = Object.keys(rv);
                        var keysLength=keys.length;
                       // alert(keysLength);
                        if(keysLength>=15)
                        {
                                alert("Only 15 connections can be configured");
                        }
                        else
                        {
                             //   self.RS485CreateUCISection("vpnconfig1","RS485Config",RS485ConfigSectionName,sensorSectionOptions).then(function(rv){
                                  self.RS485CreateUCISection("macconfig","macconfig",RS485ConfigSectionName,RS485ConfigSection ).then(function(rv){
                                        if(rv)
                                        {
                                                if (rv.section)
                                                {
                                                        self.RS485CommitUCISection("macconfig").then(function(res){
                                                              	
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
		//self.RS485DeleteUCISection("vpnconfig1","RS485Config",RS485ConfigSectionName).then(function(rv){
		//self.deletemacconfig('delete').then(function(rv) {
			 //L.ui.loading(false);
		self.RS485DeleteUCISection("macconfig","macconfig",RS485ConfigSectionName).then(function(rv){
			if(rv == 0){
				self.RS485CommitUCISection("macconfig").then(function(res){
					if (res != 0)
                    {
						alert("Error: Delete Configuration");
					}
					else 
                        {
						location.reload();
					}
				});
			};
		});
     //});	
     
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
              
        var m = new L.cbi.Map('macconfig', {
					});
         
          
                 var self = this;
                $('#AddNewmacid').click(function() {  
                        self.RS485ConfigSectionAdd();
                });
              //  self.RS485GetUCISections("vpnconfig1","RS485Config").then(function(rv) {
              self.RS485GetUCISections("macconfig","macconfig").then(function(rv) {
                        self.RS485RenderContents(rv);
                });           
               
              $('#update_mac').click(function() {
            L.ui.loading(true);
            self.updatemacconfig('configure').then(function(rv) {
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
            
   
			                
        }
      
       
            
        
});
