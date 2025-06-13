L.ui.view.extend({
    
    title:L.tr('Modem Status'),                                                                                                          
    
    description:L.tr('This page shows status of Cellular WAN interfaces'), 
    
    getLastWANStatus:L.rpc.declare({
        object:'interfacemanager',
        method:'laststatus',
        params : ['interface']
    }),
    
    getCurrentWANStatus:L.rpc.declare({
        object:'interfacemanager',
        method:'currentstatus',
        params : ['interface']
    }),
    
    msGetUCISections: L.rpc.declare({
        object: 'uci',
        method: 'get',
        params: [ 'config', 'type' ],
        expect: { values: {} }
    }),
    
    updatefirewallconfig: L.rpc.declare({
        object: 'rpc-querymodemstatus',
        method: 'configure',
        expect: { output: '' }
    }),
    
    updateinterfacestatus: L.rpc.declare({
        object: 'rpc-querymodemstatus',
        method: 'check',
        expect: { output: '' }
    }),
      

    
    DispModemStatus:function(ModemConfig) {
        
        var self=this;

        $.each(ModemConfig,function(key){
            
            if (ModemConfig.hasOwnProperty(key)) {
               
                var obj = ModemConfig[key];
                var ModemEnable = obj.modemenable;
                var DataPort = obj.device;
                var SMSPort = obj.smsport;
                var ComPort = obj.comport;
                var MonitorEnable = obj.monitorenable;
               
                var parentDiv=$('<div/>', {
                            class: 'panel panel-default',
                        });
                        var headingDiv=$('<div/>', {
                            class: 'panel-heading',
                        });
                      
                        var bodyDiv=$('<div/>', {
                            class: 'panel-body',
                        });
                        var PannelTitle=$('<h3/>', {
                            class: 'panel-title',
                            id:'panel_title_'+key,
                            text: key +' Analytics'
                        });
                        var PannelContent=$('<div/>', {
                            id: 'interface_table_'+key
                        });
                        var IfaceContentTable=new L.ui.grid({
                            caption: L.tr('Interface Status'),
                            columns :[{ width:4},{ 
                                        width:8, nowrap:true
                                    }]
                        });
                        var ModemContentTable=new L.ui.grid({                                      
                            caption:  L.tr('Modem Status'),                                       
                            columns :[{ width:4},{ 
                                        width:8, nowrap:true
                                    }]                                               
                        });
               
               
        if ( ModemEnable == 1 && MonitorEnable == 1) 
        {
						
		   self.updateinterfacestatus('check').then(function(rv) { 
			                    //   alert(rv);

			if (rv == "1" )
			{
			ModemContentTable.rows([
                                [ L.tr('Status'), "Cellular WAN interface is Down"]
                            ]);
                            
                bodyDiv.append(PannelContent);

                        var interfaceAppend=parentDiv.append(headingDiv).append(bodyDiv);
                        $('#map').append(interfaceAppend); 
                        
                ModemContentTable.appendTo('#interface_table_'+key);
             
            }
            else if (rv == "2")
            {
				
				ModemContentTable.rows([
                                [ L.tr('Status'), "Cellular interface is disabled"]
                            ]);
                            
                bodyDiv.append(PannelContent);

                        var interfaceAppend=parentDiv.append(headingDiv).append(bodyDiv);
                        $('#map').append(interfaceAppend); 
                        
                ModemContentTable.appendTo('#interface_table_'+key);
             
				
			}
            else
            {                
						
				self.updatefirewallconfig('configure').then(function(rv) {  

						  str=rv.split(',');
                      // alert(rv);
                           
                        //if (rv.code == 0 ) {
                        
                            ModemContentTable.rows([   
								[ L.tr('Network Operator '), str[0]],											
                                [ L.tr('Network Technology '), str[1]],
                                [ L.tr('Network Mode '), str[2]],
                                [ L.tr('Mobile Country Code'), str[3]],
                                [ L.tr('Mobile Network Code'), str[4]],
                                [ L.tr('Location Area Code'), str[5]],
                                [ L.tr('Cell ID'), str[6]],
                                [ L.tr('BSIC / PCI'), str[7]],
                                [ L.tr('RF Channel Number'), str[8]],
                                [ L.tr('Frequency Band'), str[9]],
                                [ L.tr('Upload Bandwidth'), str[10]],
                                [ L.tr('Download Bandwidth'), str[11]],
                                [ L.tr('Tracking Area Code'), str[12]],
                                [ L.tr('Reference Signal Received Power (dBm)'), str[13]],
                                [ L.tr('Reference Signal Received Quality (dBm)'), str[14]],
                                [ L.tr('Received signal strength indication (dB)'), str[15]],
                                [ L.tr('Signal to Noise Ratio (dB)'), str[16]],                       
                            ]);
                           
                           /*else
                           {
							   ModemContentTable.rows([
                                [ L.tr('Status'), "Cellular WAN interface Down"]
                            ]);
							   } */        
  
                        bodyDiv.append(PannelContent);

                        var interfaceAppend=parentDiv.append(headingDiv).append(bodyDiv);
                        $('#map').append(interfaceAppend);
                      //  IfaceContentTable.insertInto('#interface_table_'+key);

                        //if(rv.code == 0 || rv.code == 1) {
                            
                            //var PacketLossProgressBar=new L.ui.grid({
                                //columns :[{ width:4},{
                                    //format: function(v) {
                                        //return new L.ui.progress({
                                            //value: rv.interfaceanalytics.PacketsReceived,
                                            //max: rv.interfaceanalytics.PacketsTransmitted,
                                            //format: '%d/%d(%d%%)'
                                        //}).render();
                                    //}
                                //}]
                            //});
                            
                            //PacketLossProgressBar.rows([
                                //[ L.tr('Packet Received'), rv.interfaceanalytics.PacketLoss ]
                            //]);
                            //PacketLossProgressBar.appendTo('#interface_table_'+key);
                        //}
                        
                        ModemContentTable.appendTo('#interface_table_'+key);
                        
                        //if(rv.code == 0 || rv.code == 2) {
                            
                            //var SignalProgressBar=new L.ui.grid({
                                //columns :[{ width:4},{
                                    //format: function(v) {
                                        //return new L.ui.progress({
                                            //value:  v,
                                            //max:    31,
                                            //format: '%d/%d(%d%%)'
                                        //}).render();
                                    //}
                                //}]
                            //});
                            
                            //SignalProgressBar.rows([
                                //[ L.tr('Signal Strength'), rv.modematanalytics.CSQ ]
                            //]);
                            //SignalProgressBar.appendTo('#interface_table_'+key);
                        //}
                        
                    });
						
				}		
					});
					
					
                    
              //      return self.getLastWANStatus(key).then (function(rv) {
 
                }
            }
        });
    },

    execute: function() {
        var self = this;
        
        L.ui.loading(true);
        
          //self.updateinterfacestatus('check').then(function(rv) { 
			  //alert(rv); 
			//});
        
                  
        self.msGetUCISections("modem","interface").then(function(ModemConfig,rv) {
                self.DispModemStatus(ModemConfig,rv);
                document.getElementById('AddNewPortForward').style.visibility='hidden';

			});
		//});
	        
      	/*	 $('#AddNewPortForward').click(function() {
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
                  
            });  */   
       }
});

