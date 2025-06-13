L.ui.view.extend({

    title: L.tr('Remote Management System'),
      RunUdev:L.rpc.declare({
        object:'command',
        method:'exec',
        params : ['command','args'],
    }),
    
    
     fGetUCISections: L.rpc.declare({
        object: 'uci',
        method: 'get',
        params: [ 'config', 'type']  
       
    }),
    
    
    ////////////////////////////////////////
    
     GetUCISections: L.rpc.declare({
                object: 'uci',
                method: 'get',
                params: [ 'config', 'type' ],
                expect: { values: {} }
        }),
        
        
      nmsGetUCISections: L.rpc.declare({
                object: 'uci',
                method: 'get',
                params: ['config', 'type'],
                expect: { values: {} }
        }),   
    
         deletekeyfile: L.rpc.declare({
		object: 'rpc-updateremoteconfig',
		method: 'delete',
		expect: { output: '' }
	}),
	
	    countkeyfiles: L.rpc.declare({
		object: 'rpc-updateremoteconfig',
		method: 'countkeyfiles',
		expect: { output: '' }
	 }),
    
        updateinterfaceconfig: L.rpc.declare({
        object: 'rpc-updateremoteconfig',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
        }),
                
       updatetrconfig: L.rpc.declare({
        object: 'rpc-updateremoteconfig',
        method: 'trconfigure',
        params: ['application','action'],
        expect: { output: '' }
        }),
        
        updatenmsdisableconfig: L.rpc.declare({
        object: 'rpc-updateremoteconfig',
        method: 'update',
        params: ['application','action'],
        expect: { output: '' }
        }),
        
        updatenmsstatusconfig: L.rpc.declare({
        object: 'rpc-updateremoteconfig',
        method: 'configurestatus',
         params: ['application','action'],
        expect: { output: '' }
		}),

        
        countkeys: L.rpc.declare({
		object: 'updateremoteconfig',
		method: 'countkeyfiles',
		expect: { output: '' }
	 }),
        
	TestArchive: L.rpc.declare({
	object: 'rpc-updateremoteconfig',
	method: 'testarchive',
	params: ['archive'],
}),

   TestArchive: L.rpc.declare({
			object: 'rpc-updateremoteconfig',
			method: 'testarchive',
			params: ['archive'],
	}),
        
     handleArchiveUpload : function() {
        var self = this;  
        L.ui.archiveUpload(
            L.tr('File Upload'),
            L.tr('Select the file and click on "%s" button to proceed.').format(L.tr('Apply')), {
			    success: function(info) {
		          self.handleArchiveVerify(info);
		        }
			}
	    );
	},

	handleArchiveVerify : function(info)
	{
		var self = this;
              var archive=$('[name=filename]').val();
        
       // if((checksumval == info.checksum) &&(sizeval == info.size)) {
			L.ui.loading(true);
            self.TestArchive(archive).then(function(TestArchiveOutput) {
				
				self.updateinterfaceconfig('configure').then(function(rv) {
				               
                });
			    
		    	L.ui.dialog(
						L.tr('File'), [
						$('<p />').text(L.tr('Success')),
						$('<pre />')
						.addClass('alert-success')
						.text("file uploaded and NMS started successfully")	
					],{
							style: 'close',
							
						}
			    );
				L.ui.loading(false);   
		    });

	},
	
		
        NMSStatusRenderContents: function (rv) {

                var self = this;

                var list = new L.ui.table({
                        columns: [
                                {
                                        caption: L.tr('RMS'),
                                        width: '14%',
                                        align: 'left',
                                        format: function (v, n) {
                                                var div = $('<p />').attr('id', 'NMSNeighbor_%s'.format(n));
                                                return div.append('<strong>' + v + '</strong>');
                                        }
                                },
                                {
                                        caption: L.tr('Interface Name'),
                                        width: '20%',
                                        align: 'left',
                                        format: function (v, n) {
                                                var div = $('<p />').attr('id', 'NMSUptime_%s'.format(n));
                                                return div.append(v);
                                        }
                                },
                                {
                                        caption: L.tr('Status'),
                                        width: '20%',
                                        align: 'left',
                                        format: function (v, n) {
                                                var div = $('<p />').attr('id', 'NMSTime_%s'.format(n));
                                                // return div.append('<strong>' + v + '</strong>');
                                                return div.append(v);
                                        }
                                },

                                {
                                        caption: L.tr('IP Address'),
                                        width: '20%',
                                        align: 'left',
                                        format: function (v, n) {
                                                var div = $('<p />').attr('id', 'NMSLocalAS_%s'.format(n));
                                                return div.append(v);
                                        }
                                },

                                {
                                        caption: L.tr('Uptime'),
                                        width: '20%',
                                        align: 'left',
                                        format: function (v, n) {
                                                var div = $('<p />').attr('id', 'NMSConnectTime_%s'.format(n));
                                                return div.append(v);
                                        }
                                },


                        ]
                });

                for (var key in rv) {
                        if (rv.hasOwnProperty(key)) {
                                var obj = rv[key];

                                var name = obj.name;
                                var status = obj.status;
                                var trackingstatus = obj.trackingstatus;
                                var ipaddress =obj.ipaddress
                                var uptime = obj.time;

                                var INV;

                                if (status === "online") {
                                        INV = `<div style="border-radius: 5px; border: 2px solid #90EE90; border-left: 7px solid green; padding-left: 9px; width: 74px;">
                                                                <b>Online</b><br />
                                                                </div>`;
                                }
                                else if (status === "offline") {
                                          INV = `<div style="border-radius: 5px; border: 2px solid #FF6B6B; border-left: 7px solid red; padding-left: 9px; width: 74px;">
                                                                        <b>Offline</b><br />
                                                                        </div>`;
                                }
                                else if (status === "error") {
                                        INV = `<div style="border-radius: 5px; border: 2px solid #ffbc41; border-left: 7px solid #ffbc41; padding-left: 9px; width: 74px;">
                                                                <b>Error</b><br />
                                                                </div>`;
                                }
                                else if (status === "disabled") {
                                        INV = `<div style="border-radius: 5px; border: 2px solid #FF6B6B; border-left: 7px solid red; padding-left: 9px; width: 74px;">
                                                                <b>Disabled</b><br />
                                                                </div>`;
                                }



                                list.row([name,trackingstatus, INV, ipaddress,uptime, key]);

                        }
                }
                $('#section_routing_status').append(list.render());
        },

	
	
	 execute:function()
        {
			
	var self = this;
     
         var m = new L.cbi.Map('remoteconfig', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'general', {
            caption:L.tr('Remote Management System')
        });
       
         s.option(L.cbi.ListValue, 'rmsoption', {
                        caption: L.tr('Choose the RMS')
                }).value("none", L.tr('None'))
                 .value("tr069", L.tr('TR-069'))
                 .value("nms", L.tr('NMS'));   
                 
          
       m.insertInto('#section_vpn_general');  
       
       var m1 = new L.cbi.Map('remoteconfig', {
					});
       
        var s1 = m1.section(L.cbi.NamedSection, 'tr069', {
            caption:L.tr('')
        });
        
        s1.option(L.cbi.CheckboxValue, 'trenable', {
                       caption: L.tr('Enable'),
                       optional: true
                });
			              
         s1.option(L.cbi.CheckboxValue, 'periodic_enable', {
                       caption: L.tr('Periodic Enable'),
                       optional: true
                }).depends({'tr069':'1','trenable' :'1'});   
                
        s1.option(L.cbi.CheckboxValue, 'Server_request_enable', {
                       caption: L.tr('Accept Server Request'),
                       optional: true
                }).depends({'tr069':'1','trenable' :'1' });               
         
        s1.option(L.cbi.InputValue, 'periodic_interval', {
                        caption: L.tr('Serving Interval'),
                        optional: true 
                }).depends({'tr069':'1','trenable' :'1'});
        
        s1.option(L.cbi.InputValue, 'interface', {
                        caption: L.tr('Interface'),
                        optional: true 
                }).depends({'tr069':'1','trenable' :'1'});        
        
        s1.option(L.cbi.InputValue, 'username', {
                        caption: L.tr('Username'),
                        optional: true 
                }).depends({ 'tr069':'1', 'trenable' :'1'});
                
        s1.option(L.cbi.PasswordValue, 'password', {
                        caption: L.tr('Password'),
                        optional: true 
                }).depends({'tr069':'1' , 'trenable':'1'});        
                
        
        s1.option(L.cbi.InputValue, 'url', {
                        caption: L.tr('URL'),
                        placeholder: 'https://ServerIP:Portnumber',
                        optional: true 
                }).depends({'tr069':'1', 'trenable':'1'});
       
                    s1.commit=function(){
                        self.updatetrconfig('trconfigure').then(function(rv) {
                                //console.log("trconfigure Excuted 2nd one")
                                        
                                });
                    }
                
         m1.insertInto('#section_tr'); 
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////   
      
		var self = this;
       self.GetUCISections("remoteconfigstatus", "remote").then(function (rv) {       
                                self.updatenmsstatusconfig('configurestatus').then(function (rv) {
                                });

                                self.NMSStatusRenderContents(rv);

                });


                $('#btn_nmsstatus_refresh').click(function () {

                        L.ui.loading(true);
                        self.updatenmsstatusconfig('configurestatus').then(function (rv) {
                                L.ui.loading(false);
                                L.ui.dialog(
                                        L.tr('Show Status'), [
                                        $('<pre />')
                                                .addClass('alert alert-success')
                                                .text(rv)

                                ],

                                        {
                                                style: 'close',
                                                close: function () {
                                                        location.reload();
                                                }
                                        }

                                );


                        });

                });

                $('#btn_nmsstatus_refresh').show();	
		
       
    //////////////////////////////////////////////////////////////////////////////////////////////////////////   
        var m2 = new L.cbi.Map('remoteconfig', {
        });
        
        var s2 = m2.section(L.cbi.NamedSection, 'nms', {
            caption:L.tr('')
        }); 
        
           //s2.option(L.cbi.CheckboxValue, 'nmsenable', {
		//caption: L.tr('Enable NMS'),
		   //optional:true
		//});
		
          //s2.option(L.cbi.InputValue, 'httpurl', {
	     //caption: L.tr('URL'),
         //placeholder: 'https://example.com or https://IP',
         //}).depends({'nmsenable':'1'});
             
          s2.option(L.cbi.CheckboxValue, 'nmsenable', {
                         caption: L.tr('Enable NMS'),
                         optional: true
                 });

                s2.option(L.cbi.ListValue, 'nmstunneltype', {
                        caption: L.tr('NMS Tunnel Type'),
                }).depends({ 'nmsenable': '1' })
			.value("none", L.tr('Please choose'))
                        .value("openvpn", L.tr('Openvpn'))
                        .value("wireguard", L.tr('Wireguard'));

                s2.option(L.cbi.InputValue, 'httpurl', {
                        caption: L.tr('URL'),
                        placeholder: 'https://example.com or https://IP',
                }).depends({ 'nmsenable': '1' })
                   
             
             
           self.GetUCISections("remoteconfig","remoteconfig").then(function(rv) {

                        for (var key in rv) 
                        {
                                if (rv.hasOwnProperty(key)) 
                                {
                                        var obj = rv[key];
                                        var running = obj.nmsenable;
                                        if(running=='0')
                                         
                                        {
                                                
                                        }
                                        
                                        if(running=='1')
                                        {
								
                                                var AppStopCreateButton=$('<button/>', {
                                                        class: 'btn btn-primary',
                                                        text: 'Upload and Start',
                                                        title: 'Upload the Key file and start NMS',
                                                        style: 'width:110px',
                                                        on : {
                                                                click: function(e) {
                                                                       //  L.ui.loading(true);
                                                                         
                                                                          self.handleArchiveUpload();
                                                                       
                                                                }
                                                                
                                                                                                                       }
                                                });
                                                $("#btn-group").append(AppStopCreateButton);
                                        }
                                }
                        }
                });

                
    //$('#btn_upload').click(function() {
	
					
						 //self.handleArchiveUpload();
										
                //});
       
   s2.commit=function(){
		   
		 	 
		  self.updatenmsdisableconfig('update').then(function(rv) {
                       
				               
                });
                
                //self.updatetrconfig('Update','updateinterface').then(function(rt) {
               
                //});
           }
         
         m2.insertInto('#section_config_nms');         
		
		
		
		
		
		 //self.updatetrconfig('Update','updateinterface').then(function(rv) {
               
                //});  
       
//        self.updatetrconfig('trconfigure').then(function(rv) {
//         console.log("trconfigure Excuted")
//     });
  
		
  
  
}  
   
});

