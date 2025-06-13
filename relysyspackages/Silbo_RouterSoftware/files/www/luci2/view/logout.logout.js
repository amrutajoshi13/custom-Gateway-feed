L.ui.view.extend({
    
    //title:L.tr('Logout'),                                                                                                          
    
    description:L.tr('Please Login again'), 
    
    
    updatefirewallconfig: L.rpc.declare({
        object: 'rpc-logout',
        method: 'configure',
        expect: { output: '' }
    }),
        
    execute: function() {
        var self = this;
           L.ui.loading(true);
            self.updatefirewallconfig().then(function(rv) {
				if((rv === "1") == true)
                {
			        L.ui.loading(false);
                    L.ui.dialog(
                        L.tr('Logout Status'),[
                            $('<pre />')
                            .addClass('alert alert-success')
                            .text("Failure : Log out")
                           ],
                       
                        { style: 'close' , 
							close:function()
							{
								L.ui.loading(true);
							}
						}                        
                    );
			   }
			   else
			   {
				 L.ui.loading(false);
                    L.ui.dialog(
                        L.tr('Logout Status'),[
                            $('<pre />')
                            .addClass('alert alert-success')
                            .text("Success : Log out")
                           ],
                       
                        { style: 'close' , 
							close:function()
							{
								location.href = rv;
								L.ui.loading(true);
								L.ui.login(true);
							}
						}                        
                    );
			    }    
           });
	         
       }
});

