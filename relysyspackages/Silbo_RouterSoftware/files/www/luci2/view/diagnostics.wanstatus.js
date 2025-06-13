L.ui.view.extend({
	
	title: L.tr('WAN Status'),
	//description: L.tr('Please click on Refresh button for latest status.'),	
	
	fGetUCISections: L.rpc.declare({
		object: 'uci',
		method: 'get',
		params: [ 'config', 'type' ],
		expect: { values: {} }
	}),
	
		
/*	fCreateUCISection:  L.rpc.declare({
		object: 'uci',
		method: 'add',
		//params: [ 'config', 'type','name', 'values' ]
		params: [ 'config', 'type','name' ]
	}),*/
	
	fDeleteUCISection:  L.rpc.declare({
		object: 'uci',
		method: 'delete',
		params: [ 'config','type','section' ]
	}),
	
	fCommitUCISection:  L.rpc.declare({
		object: 'uci',
		method: 'commit',
		params: [ 'config' ]
	}),

	updatefirewallconfig: L.rpc.declare({
        object: 'rpc-updatemwan3status',
        method: 'configure',
        expect: { output: '' }
    }),
    
	
	fCreateForm: function(mapwidget, fSectionID, fSectionType)
	{
		var self = this;
		
		if (!mapwidget)
			mapwidget = L.cbi.Map;
		
		if(fSectionType == "Dredirect") {
			var FormContent = self.pfCreateFormCallback;
			//~ alert("create form");
		}
		
		var map = new mapwidget('mwan3statusconfig', {
			prepare:    FormContent,
			fSection:   fSectionID
		});
		//~ alert("after create form");
		return map;
	},
	
	fSectionEdit: function(ev) {
		var self = ev.data.self;
		var fSectionID = ev.data.fSectionID;
		//alert(ev.data.fSectionID);
		var fSectionType = ev.data.fSectionType;
							//location.reload();

		return self.fCreateForm(L.cbi.Modal, fSectionID, fSectionType).show();
					location.reload();

	},
	
	pfCreateFormCallback: function()
	{
		var map = this;
		var pfSectionID = map.options.fSection;
		
		map.options.caption = L.tr('Configuration');
		
		var s = map.section(L.cbi.NamedSection, pfSectionID, {
			collabsible: true,
			anonymous:   true,
			 tabbed:      true
		});
		
		s.option(L.cbi.DummyValue, 'name', {
				caption:     L.tr('Name')
		});
		
		s.option(L.cbi.ComboBox, 'wanpriority', {
			caption:     L.tr('Priority'),
			optional:      'true'
		}).value("1", L.tr('1'))
		  .value("2", L.tr('2'))
		  .value("3", L.tr('3'));
		
		s.option(L.cbi.InputValue, 'trackIp1', {
			caption:     L.tr('TrackIP1'),
			placeholder:     '8.8.8.8', 
		});
		
	    s.option(L.cbi.InputValue, 'trackIp2', {
			caption:     L.tr('TrackIP2'),
			placeholder:     '8.8.8.8', 
		});
		
		s.option(L.cbi.InputValue, 'trackIp3', {
			caption:     L.tr('TrackIP3'),
			placeholder:     '8.8.8.8', 
		});
		
		s.option(L.cbi.InputValue, 'trackIp4', {
			caption:     L.tr('TrackIP4'),
			placeholder:     '8.8.8.8', 
		});
	     	     
   
	},
		
	pfRenderContents: function(rv)
	{
		var self = this;

		var list = new L.ui.table({
			columns: [{
				caption: L.tr('Interface'),
				width: '20%',
        		align: 'left',
				format: function (v, n) {
					var div = $('<p />').attr('id', 'pfName_%s'.format(n));
					return div.append('<strong>'+v+'</strong>');
				}
			},
			/*{ 
				caption: L.tr('Priority'),
				format:  function(v,n) {
					var div = $('<small />').attr('id', 'pfMatch_%s'.format(n));
					return div.append(v);
				}
			},*/

			{
				caption: L.tr('Interface Status'),
				width: '20%',
        		align: 'left',
				format: function (v, n) {
					var div = $('<p />').attr('id', 'pfForwardTo_%s'.format(n));
					return div.append(v);
				}
			},
			{
				caption: L.tr('Internet Status'),
				width: '20%',
				align: 'left',
				format: function (v, n) {
				  var div = $('<p />').attr('id', 'pfForwardTo_%s'.format(n));
				  return div.append(v);
				}
			  },
			{
				caption: L.tr('Tracking Status'),
				width: '20%',
        		align: 'left',
				format: function (v, n) {
					var div = $('<p />').attr('id', 'pfForwardTo_%s'.format(n));
					return div.append('<strong>'+v+'</strong>');
				}
			},
			
			/*{
				caption: L.tr('Actions'),
				format:  function(v, n) {
					return $('<div />')
						.addClass('btn-group btn-group-sm')
						.append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Edit Port Forward'))
							.click({ self: self, fSectionID: v, fSectionType: "Dredirect" }, self.fSectionEdit))
						/*.append(L.ui.button(L.tr('Update'), 'success', L.tr('Update rule'))
							.click({ self: self, pfSectionID: v,fSectionType: "Dredirect" }, self.pfSectionUpdate))
						.append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Port Forward'))
							.click({ self: self, pfSectionID: v }, self.pfSectionRemove));
				}
			}*/]
		});

		for (var key in rv) {
			if (rv.hasOwnProperty(key)) {
				var obj = rv[key];
				var name = obj.name;
				var interfacestatus = obj.interface_status;
				var internetstatus = obj.internet_status;
				var trackingstatus = obj.trackingstatus;
				//var name = obj.name;
				//alert(WanPriority);
				// var status = obj.status;
				// var trackingstatus = obj.trackingstatus;

				/*var SourceIP = obj.src_ip;
				  var SourceZone = obj.src;
				var SourcePort = obj.src_port;
				var SourceMac = obj.src_mac;
				var SourceDIP = obj.src_dip;
				var SourceDPort = obj.src_dport;
				var proto = obj.proto;
				var Target = obj.target;
				var srctxt = '';
				var viatxt = '';
				var Match  = '';	
				var prototxt = '';
				var ForwardTo = '';          
				
				if ( Target != "DNAT" ) {
					continue;
				}

				if (!proto)
					proto = "TCP+UDP";
				var prototxt = "IPv4-"+proto;
				
				if (!SourceZone)
					SourceZone = "any zone";
				if (!SourceIP)
					SourceIP = "any host";
				//if (!SourceDIP)
					//SourceDIP = "any router IP";
			
				if (SourcePort && SourceMac) {
					var srctxt ="From "+"<strong>"+SourceIP+"</strong>"+" in "+"<strong>"+SourceZone+"</strong>"+" with port "+"<strong>"+SourcePort+"</strong>"+" and "+"<strong>"+SourceMac+"</strong>";
				}
				else if (SourcePort) {
					var srctxt = "From "+"<strong>"+SourceIP+"</strong>"+" in "+"<strong>"+SourceZone+"</strong>"+" with port "+"<strong>"+SourcePort+"</strong>";
				} 
				 else if (SourceMac) {
					var srctxt ="From "+"<strong>"+SourceIP+"</strong>"+" in "+"<strong>"+SourceZone+"</strong>" +" with source "+"<strong>"+SourceMac+"</strong>";
				}
				else {
					var srctxt ="From "+"<strong>"+SourceIP+"</strong>"+" in "+"<strong>"+SourceZone+"</strong>";
				}
				//if (SourceDIP && SourceDPort) {
					//var viatxt ="Via "+"<strong>"+SourceDIP+"</strong>"+" at "+"<strong>"+SourceDPort+"</strong>";
				//}
				//else {
					//var viatxt = "Via "+"<strong>"+SourceDIP+"</strong>";
				//}
				var Match =prototxt+"<br />"+srctxt+"<br />"+viatxt ;
				
				var DestnZone = obj.dest_zone;
				var DestnIP = obj.dest_ip;
				var DestnPort = obj.dest_port;
				
				if(!DestnZone)
					DestnZone = "any zone";
				if(!DestnIP)
					DestnIP = "any host";
				if (!DestnPort)
					DestnPort = obj.src_dport;
				
				if (DestnPort) {
					var ForwardTo ="IP "+"<strong>"+DestnIP+"</strong>"+", port "+"<strong>"+DestnPort+"</strong>"+" in "+"<strong>"+DestnZone+"</strong>";
				}
				else {
					var ForwardTo ="IP "+"<strong>"+DestnIP+"</strong>"+" in "+"<strong>"+DestnZone+"</strong>";          
				}*/
				//list.row([ obj.name, Match, ForwardTo, key ]);
				
				//list.row([ obj.name,Priority,TrackIP1,TrackIP2,TrackIP3,TrackIP4,key ]);
				var Interfacestatus;

				if (interfacestatus === "online") {
				  Interfacestatus = `<div style="border-radius: 5px; border: 2px solid #90EE90; border-left: 7px solid green; padding-left: 9px; width: 74px;">
							<b>Online</b><br />
							</div>`;
				}
				else if (interfacestatus === "offline") {
				  Interfacestatus = `<div style="border-radius: 5px; border: 2px solid #FF6B6B; border-left: 7px solid red; padding-left: 9px; width: 74px;">
							<b>Offline</b><br />
							</div>`;
				}
				else if (interfacestatus === "error") {
				  Interfacestatus = `<div style="border-radius: 5px; border: 2px solid #ffbc41; border-left: 7px solid #ffbc41; padding-left: 9px; width: 74px;">
							<b>Error</b><br />
							</div>`;
				}
				else if (interfacestatus === "disabled") {
							Interfacestatus = `<div style="border-radius: 5px; border: 2px solid #FF6B6B; border-left: 7px solid red; padding-left: 9px; width: 74px;">
							<b>Disabled</b><br />
							</div>`;
						}
				var Internetstatus;
		
				if (internetstatus === "online") {
				  Internetstatus = `<div style="border-radius: 5px; border: 2px solid #90EE90; border-left: 7px solid green; padding-left: 9px; width: 74px;">
							<b>Online</b><br />
							</div>`;
				}
				else if (internetstatus === "offline") {
				  Internetstatus = `<div style="border-radius: 5px; border: 2px solid #FF6B6B; border-left: 7px solid red; padding-left: 9px; width: 74px;">
							<b>Offline</b><br />
							</div>`;
				}
				else if (internetstatus === "error") {
				  Internetstatus = `<div style="border-radius: 5px; border: 2px solid #ffbc41; border-left: 7px solid #ffbc41; padding-left: 9px; width: 74px;">
							<b>Error</b><br />
							</div>`;
				}
				else if (internetstatus === "disabled") {
							Internetstatus = `<div style="border-radius: 5px; border: 2px solid #FF6B6B; border-left: 7px solid red; padding-left: 9px; width: 74px;">
							<b>Disabled</b><br />
							</div>`;
						}

				list.row([name, Interfacestatus, Internetstatus,trackingstatus, key]);


			}
		}

		$('#section_firewall_port').
			append(list.render());		
	},


    //~ pfSectionUpdate: function(ev) {
		//~ var self = ev.data.self;
		//~ var pfSectionID = ev.data.pfSectionID;
		//~ L.ui.loading(true);
		//~ self.updatefirewallconfig(pfSectionID).then(function(rv) {
			//~ if(rv == 0){
				//~ alert("Error: Configuration Not Updated");
			//~ }
			//~ else {
				//~ alert("configuration is updated");
				//~ location.reload();
			//~ }
			
		//~ });
	//~ },
    

	//~ pfSectionRemove: function(ev) {
		//~ var self = ev.data.self;
		//~ var pfSectionID = ev.data.pfSectionID;
		
		//~ self.fDeleteUCISection("mwan3statusconfig","redirect",pfSectionID).then(function(rv){
			//~ if(rv == 0){
				//~ self.fCommitUCISection("mwan3statusconfig").then(function(res){
					//~ self.updatefirewallconfig(pfSectionID).then(function(rv) {
						//~ if (res != 0){
							//~ alert("Error: Delete Port Forward Configuration");
						//~ }
						//~ else {
							//~ location.reload();
						//~ }
					//~ });
				//~ });
			//~ };
		//~ });
	//~ },
	
	//~ pfSectionAdd: function () 
	//~ {
		//~ var self = this;
		//~ var pfName = $('#field_firewall_redirect_newRedirect_name').val();		
		//~ //var pfExtZone = $('#field_firewall_redirect_newRedirect_src').val();
		//~ //var pfIntZone = $('#field_firewall_redirect_newRedirect_dest').val();
		//~ //var SectionOptions = {name:pfName,src:pfExtZone,dest:pfIntZone,target:"DNAT"};
          //~ var SectionOptions = {name:pfName};

		//~ //self.fCreateUCISection("mwan3config","redirect",pfName,SectionOptions).then(function(rv){
		//~ self.fCreateUCISection("mwan3statusconfig","redirect",pfName).then(function(rv){
			//~ if(rv){
				//~ if (rv.section){
					//~ self.fCommitUCISection("mwan3statusconfig").then(function(res){
						//~ location.reload();
						//~ if (res != 0) {
							//~ alert("Error: New Port Forward Configuration");
						//~ }
						//~ else {
							//~ location.reload();
						//~ }
					//~ });
					
				//~ };
			//~ };
		//~ });
		
	//~ },
	
	execute: function() {		
		var self = this;
		  L.ui.loading(true);
            self.updatefirewallconfig().then(function(rv) {

			});
			self.fGetUCISections("mwan3statusconfig","redirect").then(function(rv) {
			self.pfRenderContents(rv);   
			});
				
		
		 $('#AddNewPortForward').click(function() {

            L.ui.loading(true);
            self.updatefirewallconfig().then(function(rv) {
                L.ui.loading(false);
                    L.ui.dialog(
                        L.tr('Show Status'),[
                            $('<pre />')
                            .addClass('alert alert-success')
                            .text(rv)
             
                        ],
                       
                        { style: 'close' , 
							close:function()
							{
								location.reload();
							}
						}
                        
                    );
                  //  alert(rv);
                
                    
                   });
                  
            });
             
            $('#AddNewPortForward').show();
            
           	}
	
	             // }
});
