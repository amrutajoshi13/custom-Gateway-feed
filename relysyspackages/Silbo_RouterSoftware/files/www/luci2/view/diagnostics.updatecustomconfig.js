L.ui.view.extend({

    title: L.tr('Custom Logo Configuration'),
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
        
    GetUCISections: L.rpc.declare({
		object: 'uci',
		method: 'get',
		params: [ 'config', 'type' ],
		expect: { values: {} }
    }),
     
          TestArchive: L.rpc.declare({
			object: 'rpc-updateVPNConfig',
			method: 'testarchive',
			params: ['archive'],
	}),
        
    updatecustomconfig: L.rpc.declare({
        object: 'rpc-updatecustomimageconfig',
        method: 'configure',
        expect: { output: '' }
    }),
                                
     handleArchiveUpload : function() {
        var self = this;  
        L.ui.ImageUpload(
            L.tr('File Upload'),
            L.tr('Select the file and click on "%s" button to proceed.').format(L.tr('Apply')), {
			   filename: '/root/custom_image/custom_logo.svg',
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
			L.ui.loading(true);
           self.updatecustomconfig('configure').then(function(TestArchiveOutput) {
	    	L.ui.dialog(
					L.tr('File'), [
					$('<p />').text(L.tr('Success')),
					$('<pre />')
					.addClass('alert-success')
					.text("logo uploaded successfully")	
				],{
						style: 'close',
						
					}
		    );
			L.ui.loading(false);   
		   });              
	},
	
	
	
	execute:function()
    {		
		var self = this;     
        var m = new L.cbi.Map('customconfig', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'customconfig', {
            caption:L.tr('')
        }); 
        		
        s.option(L.cbi.InputValue, 'manufacturer', {
			caption: L.tr('Manufacturer Name'),
        });
        
         s.option(L.cbi.InputValue, 'manufacturer_url', {
			caption: L.tr('Manufacturer Url'),
        });
        
          s.option(L.cbi.InputValue, 'CustomModelname', {
			caption: L.tr('Model Name'),
        });
                             
		$('#btn_upload').click(function() {					
			self.handleArchiveUpload();										
        });
       				 m.insertInto('#map');         

		s.commit=function(){         	
		}  
	}  
});


