L.ui.view.extend({

    title: L.tr('NMS Configuration'),

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
    
    GetUCISections: L.rpc.declare({
                object: 'uci',
                method: 'get',
                params: [ 'config', 'type' ],
                expect: { values: {} }
        }),
    
         deletekeyfile: L.rpc.declare({
		object: 'rpc-nmsconfig',
		method: 'delete',
		expect: { output: '' }
	}),
	
	    countkeyfiles: L.rpc.declare({
		object: 'rpc-nmsconfig',
		method: 'countkeyfiles',
		expect: { output: '' }
	 }),
    
      updatenmsconfig: L.rpc.declare({
        object: 'rpc-nmsconfig',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
        }),
        
          updatenmsdisableconfig: L.rpc.declare({
        object: 'rpc-nmsconfig',
        method: 'update',
        params: ['application','action'],
        expect: { output: '' }
        }),
        
        countkeys: L.rpc.declare({
		object: 'rpc-nmsconfig',
		method: 'countkeyfiles',
		expect: { output: '' }
	 }),
        
	TestArchive: L.rpc.declare({
	object: 'rpc-nmsconfig',
	method: 'testarchive',
	params: ['archive'],
}),

   TestArchive: L.rpc.declare({
			object: 'rpc-nmsconfig',
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
				
				self.updatenmsconfig('configure').then(function(rv) {
				               
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
		    
		    
		//}
               
	},


   
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('nmsconfig', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'nmsconfig', {
            caption:L.tr('NMS Configuration')
        }); 
    
    		/* s.option('L.cbi.InputValue, 'port', {
				caption: L.tr('Port'),
		});*/
		
	    s.option( L.cbi.CheckboxValue, 'nmsenable', {
		caption: L.tr('Enable NMS'),
		});
		
		
		
     s.option( L.cbi.InputValue, 'httpurl', {
	caption: L.tr('URL'),
  //  datatype: 'ipaddr'
     placeholder: 'https://example.com or https://IP'
       }).depends({'nmsenable' : '1'});
       
       /* Added for testing */
       
           self.GetUCISections("nmsconfig","nmsconfig").then(function(rv) {
                        for (var key in rv) 
                        {
                                if (rv.hasOwnProperty(key)) 
                                {
                                        var obj = rv[key];
                                        var running = obj.nmsenable;
                                        if(running=='0')
                                        {
                                                //var AppstartCreateButton=$('<button/>', {
                                                        //class: 'btn btn-primary',
                                                        //text: 'Start',
                                                        //id: 'start',
                                                        //title: 'Start the Apps',
                                                        //style: 'width:110px',
                                                        //on : {
                                                                //click: function(e) {
                                                                        //L.ui.loading(true);
                                                                        //self.applicationmanagerinit('ReAPapps','start').then(function(rv) {
                                                                                //L.ui.loading(false);
                                                                                //L.ui.dialog(
                                                                                        //L.tr('Started the app'),[
                                                                                               //$('<p />').text(L.tr('Output')),
                                                                                                //$('<pre />')
                                                                                                        //.addClass('alert alert-info')
                                                                                                        //.text(rv),
                                                                                        //],
                                                                                        //{ style: 'close',
                                                                                                //close:function()
                                                                                                //{
                                                                                                        //location.reload();
                                                                                                //}
                                                                                        //}
                                                                                //);
                                                                       //});
                                                                //}
                                                             //}
                                                //});
                                                //$("#btn-group").append(AppstartCreateButton);
                                                
                                               // alert("Enable NMS");
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
                                                                        //self.applicationmanagerinit('ReAPapps','stop').then(function(rv) {
                                                                                //L.ui.loading(false);
                                                                                //L.ui.dialog(
                                                                                        //L.tr('File Uploaded. Starting NMS...'),[
                                                                                                //$('<pre />')
                                                                                                        //.addClass('alert alert-info')
                                                                                                        //.text(rv),
                                                                                        //],
                                                                                        //{ style: 'close',
                                                                                                //close:function()
                                                                                                //{
																									//self.updatenmsconfig('configure').then(function(rv) {
																										
																										//location.reload();
				               
																								//});
                                                                                                        
                                                                                                //}
                                                                                        //}
                                                                                //);
                                                                       ////});
                                                                       
                                                                       
                                                                }
                                                                
                                                                                                                       }
                                                });
                                                $("#btn-group").append(AppStopCreateButton);
                                        }
                                }
                        }
                });
            
            
            /* Test purpose end */
       
       
       
       
     
                
    $('#btn_upload').click(function() {
	
					
						 self.handleArchiveUpload();
										
                });
                
                  		     		
       s.commit=function(){
		   
		 	 
		  self.updatenmsdisableconfig('update').then(function(rv) {
				               
                });
           }
                   
		  
        return m.insertInto('#map');
    }
    
   
});
