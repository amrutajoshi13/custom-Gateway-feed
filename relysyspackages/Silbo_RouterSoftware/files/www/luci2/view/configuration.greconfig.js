L.ui.view.extend({
title: L.tr('Tunnel Configuration'),
description: L.tr('<b>Please click on update after editing or deleting any changes.</b>'),
    
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

    updategreconfig: L.rpc.declare({
    object: 'rpc-updateGREConfig',
    method: 'configure',
    expect: { output: '' }
    }),

    deletegreconfig: L.rpc.declare({
    object: 'rpc-updateGREConfig',
    method: 'delete',
    expect: { output: '' }
    }),  
      

    updateipipconfig: L.rpc.declare({
    object: 'rpc-updateIPIPConfig',
    method: 'configure',
    expect: { output: '' }
    }),
     
    deleteipipconfig: L.rpc.declare({
    object: 'rpc-updateIPIPConfig',
    method: 'delete',
    expect: { output: '' }
    }),  
        
    GreFormCallback: function() 
    {
            var map = this;
            var GreConfigSectionName = map.options.GreConfigSection;
            var numericExpression = /^[0-9]+$/;
            
            map.options.caption = L.tr(GreConfigSectionName+' Configuration');
            
            var s = map.section(L.cbi.NamedSection, GreConfigSectionName, {
                    collabsible: true
    });
                                        
       s.option(L.cbi.DummyValue, 'typesettings', {
       caption: L.tr(''),
       }).depends({'ipsecconfig':'1','enableipsec' : '1'})
       .ucivalue=function()
        {
        var id="<h5><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspGRE Tunnel Configuration </b> </h3>";
        return id;
        };
      
       s.option(L.cbi.DummyValue, 'tunnelname', {
       caption: L.tr('Tunnel name'),
       datatype: 'rt_alphanumeric',
       }).depends({'ipsecconfig':'1','enableipsec' : '1'});
     
       
       s.option(L.cbi.InputValue, 'localexternalIP', {
       caption: L.tr('Local external IP'),
       placeholder: '192.168.6.1',
       datatype: 'ip4addr',
       }).depends({'ipsecconfig':'1','enableipsec' : '1'});
     
     
       s.option(L.cbi.InputValue, 'remoteexternalIP', {
       caption: L.tr('Remote external IP'),
       placeholder: '192.168.0.1',
       datatype: 'ip4addr',
       }).depends({'ipsecconfig':'1','enableipsec' : '1'});
       
       s.option(L.cbi.InputValue, 'peertunnelIP', {
       caption: L.tr('Peer tunnel IP'),
       placeholder: '10.1.1.2',
       datatype: 'ip4addr',
       }).depends({'ipsecconfig':'1','enableipsec' : '1'});
     
       s.option(L.cbi.InputValue, 'localtunnelIP', {
       caption: L.tr('Local tunnel IP'),
       placeholder: '10.1.1.12',
       datatype: 'ip4addr',
       }).depends({'ipsecconfig':'1','enableipsec' : '1'});
     
       s.option(L.cbi.InputValue, 'localnetmask', {
       caption: L.tr('Local tunnel net mask'),
       placeholder: '255.255.255.0',
       datatype: 'ip4addr',
       }).depends({'ipsecconfig':'1','enableipsec' : '1'});
     
     
       s.option(L.cbi.InputValue, 'remoteip', {
       caption: L.tr('Remote IP'),
       placeholder: '192.168.10.0/24',
       datatype: 'cidr4',
       }).depends({'ipsecconfig':'1','enableipsec' : '1'});
    
       s.option(L.cbi.CheckboxValue, 'enabletun', {
       caption: L.tr('Enable Tunnel Link'),
       });
 
       
       s.option(L.cbi.ComboBox,'interfacetype',{          
       caption:L.tr('Interface type'),
       optional:      'true'                    
       }).depends({'ipsecconfig':'1','enableipsec' : '1'})
         .depends({'enabletun' : '1'})
         .value("EWAN5", L.tr('EWAN5')) 
         .value("CWAN1_0", L.tr('CWAN1_0'))
         .value("CWAN1_1", L.tr('CWAN1_1'))
         .value("CWAN1", L.tr('CWAN1')); 
            
            
       s.option(L.cbi.InputValue, 'mtu', {
       caption: L.tr('MTU'),
       placeholder: '1476',
       datatype:    'max(1476)',
       }).depends({'ipsecconfig':'1','enableipsec' : '1'});
     
       s.option(L.cbi.InputValue, 'ttl', {
       caption: L.tr('TTL'),
       placeholder: '64',
       datatype:    'range(1,255)',
       }).depends({'ipsecconfig':'1','enableipsec' : '1'});
     
       s.option(L.cbi.InputValue, 'tunnelkey', {
       caption: L.tr('Tunnel key'),
       placeholder: '0-4245967295',
       datatype: 'uinteger',
       }).depends({'ipsecconfig':'1','enableipsec' : '1'});
  
       s.option(L.cbi.CheckboxValue, 'enablekeepalive', {
       caption: L.tr('Enable keep alive'),
       optional: true
       }).depends({'ipsecconfig':'1','enableipsec' : '1'});
    
       s.option(L.cbi.InputValue, 'aliveinterval', {
       caption: L.tr('Keep alive interval'),
       placeholder: '10',
       }).depends({'ipsecconfig':'1','enableipsec' : '1','enablekeepalive' : '1'});
                         
 },

                       
ipipFormCallback: function() 
{
     var map = this;
     var ipipConfigSectionName = map.options.ipipConfigSection;
     var numericExpression = /^[0-9]+$/;
          
     map.options.caption = L.tr(ipipConfigSectionName+' Configuration');
            
     var s1 = map.section(L.cbi.NamedSection, ipipConfigSectionName, {
     collabsible: true
     });
            
     s1.option(L.cbi.DummyValue, 'typesettings', {
     caption: L.tr(''),
     })
     .ucivalue=function()
     {
       var id="<h5><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspIPIPTunnel Configuration </b> </h3>";
       return id;
     };
      
      s1.option(L.cbi.DummyValue, 'tunnelname', {
      caption: L.tr('Tunnel name'),
      datatype: 'rt_alphanumeric',
      });
        
      s1.option(L.cbi.InputValue, 'localexternalIP', {
      caption: L.tr('Local external IP'),
      placeholder: '192.168.6.1',
      datatype: 'ip4addr',
      }).depends({'tempenableipip' : '1'});
    
      s1.option(L.cbi.InputValue, 'remoteexternalIP', {
      caption: L.tr('Remote external IP'),
      placeholder: '192.168.0.1',
      datatype: 'ip4addr',
      }).depends({'ipsecconfig':'1','enableipsec' : '1'});
        
      s1.option(L.cbi.InputValue, 'peertunnelIP', {
      caption: L.tr('Peer tunnel IP'),
      placeholder: '10.1.1.2',
      datatype: 'ip4addr',
      }).depends({'ipsecconfig':'1','enableipsec' : '1'});
     
      s1.option(L.cbi.InputValue, 'localtunnelIP', {
      caption: L.tr('Local tunnel IP'),
      placeholder: '10.1.1.12',
      datatype: 'ip4addr',
      }).depends({'ipsecconfig':'1','enableipsec' : '1'});
     
      s1.option(L.cbi.InputValue, 'localnetmask', {
      caption: L.tr('Local tunnel net mask'),
      placeholder: '255.255.255.0',
      datatype: 'ip4addr',
      }).depends({'ipsecconfig':'1','enableipsec' : '1'});
      
      s1.option(L.cbi.InputValue, 'remoteip', {
      caption: L.tr('Remote IP'),
      placeholder: '192.168.10.0/24',
      datatype: 'cidr4',
      }).depends({'ipsecconfig':'1','enableipsec' : '1'});
       
      s1.option(L.cbi.CheckboxValue, 'enabletun', {
      caption: L.tr('Enable Tunnel Link'),
      });
 
      s1.option(L.cbi.ComboBox,'interfacetype',{          
      caption:L.tr('Interface type'), 
      optional:      'true'                   
      }).depends({'ipsecconfig':'1','enableipsec' : '1'})
        .depends({'enabletun' : '1'})
        .value("none", L.tr('Please choose')) 
        .value("EWAN5", L.tr('EWAN5')) 
        .value("CWAN1_0", L.tr('CWAN1_0'))
        .value("CWAN1_1", L.tr('CWAN1_1'))
        .value("CWAN1", L.tr('CWAN1')); 
             
      s1.option(L.cbi.InputValue, 'mtu', {
      caption: L.tr('MTU'),
      placeholder: '1476',
      datatype:    'max(1476)',
      }).depends({'ipsecconfig':'1','enableipsec' : '1'});
     
      s1.option(L.cbi.InputValue, 'ttl', {
      caption: L.tr('TTL'),
      placeholder: '64',
      datatype:    'range(1,255)',
      }).depends({'ipsecconfig':'1','enableipsec' : '1'});
            
    
      s1.option(L.cbi.InputValue, 'tunnelkey', {
      caption: L.tr('Tunnel key'),
      optional: true,
      placeholder: '0-4245967295',
      datatype: 'uinteger',
      }).depends({'ipsecconfig':'1','enableipsec' : '1'});
    
      s1.option(L.cbi.CheckboxValue, 'enablekeepalive', {
      caption: L.tr('Enable keep alive'),
      optional: true
      }).depends({'ipsecconfig':'1','enableipsec' : '1'});
   
      s1.option(L.cbi.InputValue, 'aliveinterval', {
      caption: L.tr('Keep alive interval'),
      placeholder: '10',
      }).depends({'ipsecconfig':'1','enableipsec' : '1','enablekeepalive' : '1'});

},
  
    GreConfigCreateForm: function(mapwidget,GreConfigSectionName) 
    {
            var self = this;
            
            if (!mapwidget)
                    mapwidget = L.cbi.Map;
            
            var map = new mapwidget('greconfig', {
                    prepare: self.GreFormCallback,
                    GreConfigSection: GreConfigSectionName
            });
            return map;
    },
  
    ipipConfigCreateForm: function(mapwidget,ipipConfigSectionName) 
    {
            var self = this;
            
            if (!mapwidget)
                    mapwidget = L.cbi.Map;
            
            var map = new mapwidget('ipipconfig', {
                    prepare: self.ipipFormCallback,
                    ipipConfigSection: ipipConfigSectionName
            });
            return map;
    },
   
    GreRenderContents: function(rv) 
    {                    
            var self = this;

            var list = new L.ui.table({
                    columns: [{
                            caption: L.tr('Sl No'),
                            align: 'left',
                            format: function(v, n) {
                                    var div = $('<p />').attr('id', 'GreDeviceSerialNo_%s'.format(n));
                                    var serialNo=n+1;
                            return div.append(serialNo);
                            }
                     },
                    {
                            caption: L.tr('Tunnel Name'),
                                    width:'30%',
                            align: 'left',
                            format: function(v,n) {
                                    var div = $('<p />').attr('id', 'GreDeviceEventName_%s'.format(n));
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
                                            .click({ self: self, GreConfigSectionName: v }, self.GreConfigSectionEdit))
                                            .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                            .click({ self: self, GreConfigSectionName: v }, self.GreConfigSectionRemove));
                                        
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
               
          $('#section_vpn_ipsec').append(list.render());	

     },
  
    IPIPRenderContents: function(rv) 
    {
            var self = this;

              var list2 = new L.ui.table({
                    columns: [{
                            caption: L.tr('Sl No'),
                            align: 'left',
                            format: function(v, n) {
                                    var div = $('<p />').attr('id', 'ipipDeviceSerialNo_%s'.format(n));
                                    var serialNo=n+1;
                            return div.append(serialNo);
                            }
                    },
                    {
                            caption: L.tr(' Tunnel Name'),
                                    width:'30%',
                            align: 'left',
                            format: function(v,n) {
                                    var div = $('<p />').attr('id', 'ipipDeviceEventName_%s'.format(n));
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
                                            .click({ self: self, ipipConfigSectionName: v }, self.ipipConfigSectionEdit))
                                            .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                            .click({ self: self, ipipConfigSectionName: v }, self.ipipConfigSectionRemove));
                                          
                            }
                    }]
            });

         for (var key in rv) 
                {
                        if (rv.hasOwnProperty(key)) 
                        {
                                var obj = rv[key];
                                list2.row([key,key,key]); 
                        }
                }
      
         $('#section_vpn_ipip').append(list2.render());
      
    },
  
    GreConfigSectionAdd: function () 
    {
      debugger
      var self = this;
      var GreConfigSectionName = $('#field_NewEvent_name').val();
      var GreConfigSection= {tunnelname:GreConfigSectionName};

      this.RS485GetUCISections("greconfig","greconfig",GreConfigSectionName,GreConfigSection).then(function(rv) {
      var keys = Object.keys(rv);
      var keysLength=keys.length;
      if(keysLength>=5)
      {
        alert("Only 5 connections can be configured");
      }
      else
      {
       self.RS485CreateUCISection("greconfig","greconfig",GreConfigSectionName,GreConfigSection).then(function(rv){
         if(rv)
         {
          if (rv.section)
          {
           self.RS485CommitUCISection("greconfig").then(function(res){
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
 
   ipipConfigSectionAdd: function () 
   {
     var self = this;
     var ipipConfigSectionName = $('#field_NewEvent_name_ipip').val();
     var  ipipConfigSection= {tunnelname:ipipConfigSectionName};
     this.RS485GetUCISections("ipipconfig","ipipconfig",ipipConfigSectionName, ipipConfigSection).then(function(rv) {
     var keys = Object.keys(rv);
     var keysLength=keys.length;
     if(keysLength>=5)
     {
       alert("Only 5 connections can be configured");
     }
     else
     {
       self.RS485CreateUCISection("ipipconfig","ipipconfig",ipipConfigSectionName,ipipConfigSection).then(function(rv){
       if(rv)
       {
          if (rv.section)
          {
             self.RS485CommitUCISection("ipipconfig").then(function(res){
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
    
    GreConfigSectionRemove: function(ev) 
    {
       var self = ev.data.self;
       var GreConfigSectionName = ev.data.GreConfigSectionName;
       self.deletegreconfig('delete').then(function(rv) {
	   self.RS485DeleteUCISection("greconfig","greconfig",GreConfigSectionName).then(function(rv){
         if(rv == 0){
         self.RS485CommitUCISection("greconfig").then(function(res){
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
        });
    },
    
     ipipConfigSectionRemove: function(ev) 
     {
        var self = ev.data.self;
        var ipipConfigSectionName = ev.data.ipipConfigSectionName;
        self.deleteipipconfig('delete').then(function(rv) {
        self.RS485DeleteUCISection("ipipconfig","ipipconfig",ipipConfigSectionName).then(function(rv){
        if(rv == 0){
                    self.RS485CommitUCISection("ipipconfig").then(function(res){
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
       });  
     },
    
    GreConfigSectionEdit: function(ev) 
    {
            var self = ev.data.self;
            var GreConfigSectionName = ev.data.GreConfigSectionName;
            return self.GreConfigCreateForm(L.cbi.Modal,GreConfigSectionName).show();
    },
 
          
    ipipConfigSectionEdit: function(ev) 
    {
            var self = ev.data.self;
            var ipipConfigSectionName = ev.data.ipipConfigSectionName;
            return self.ipipConfigCreateForm(L.cbi.Modal,ipipConfigSectionName).show();
    },       
           
  
    execute:function()
    {
    var self = this;
          
    var m = new L.cbi.Map('greconfig', {
                });
        
    var s = m.section(L.cbi.NamedSection, 'general', {
        caption:L.tr('General Configurations')
    });
    
    
    s.option(L.cbi.CheckboxValue, 'enablegre', {
    caption: L.tr('Enable GRE Tunnel'),         
    optional: true
    });
            
    s.option(L.cbi.CheckboxValue, 'enableipip', {
    caption: L.tr('Enable IPIP Tunnel'),         
    optional: true
    }); 
    
    m.insertInto('#section_vpn_general');  
   
    var self = this;
     //gre
    $('#AddNewconnectionipsec').click(function() { 
    self.GreConfigSectionAdd();
    });
    self.RS485GetUCISections("greconfig","greconfig").then(function(rv) {
    self.GreRenderContents(rv);
    }); 
              
    //ipip
    $('#AddNewconnectionipip').click(function() { 
    self.ipipConfigSectionAdd();
    });
    self.RS485GetUCISections("ipipconfig","ipipconfig").then(function(rv) {
		self.IPIPRenderContents(rv);
    }); 


    $('#update_tunnel').click(function() {
    L.ui.loading(true);
    self.updategreconfig('configure').then(function(rv) {
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
        
     $('#update_tunnel_ipip').click(function() {
        L.ui.loading(true);
        self.updateipipconfig('configure').then(function(rv) {
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


