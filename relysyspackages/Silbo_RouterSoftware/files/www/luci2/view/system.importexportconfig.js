L.ui.view.extend({
	title: L.tr('Import Export Configuration'),

	testUpgrade: L.rpc.declare({
		object: 'luci2.system',
		method: 'upgrade_test',
		expect: { '': { } }
	}),

	startUpgrade: L.rpc.declare({
		object: 'luci2.system',
		method: 'upgrade_start',
		params: [ 'keep' ]
	}),
	
	RetainConfigstartUpgrade: L.rpc.declare({
        object: 'rpc-sysupgrade',
        method: 'upgrade',
        expect: { output: '' }
    }),

	RebootSystem: L.rpc.declare({
        object: 'rpc-importexport',
        method: 'rebootsys',
        expect: { output: '' }
    }),

	cleanUpgrade: L.rpc.declare({
		object: 'luci2.system',
		method: 'upgrade_clean'
	}),
	
	restoreBackup: L.rpc.declare({
		object: 'luci2.system',
		method: 'backup_restore'
	}),

	cleanBackup: L.rpc.declare({
		object: 'luci2.system',
		method: 'backup_clean'
	}),

	getBackupConfig: L.rpc.declare({
		object: 'luci2.system',
		method: 'backup_config_get',
		expect: { config: '' }
	}),

	setBackupConfig: L.rpc.declare({
		object: 'luci2.system',
		method: 'backup_config_set',
		params: [ 'data' ]
	}),

	listBackup: L.rpc.declare({
		object: 'luci2.system',
		method: 'backup_list',
		expect: { files: [ ] }
	}),

	testReset: L.rpc.declare({
		object: 'luci2.system',
		method: 'reset_test',
		expect: { supported: false }
	}),
	
	 
    TestArchive: L.rpc.declare({
			object: 'rpc-importexport',
			method: 'testarchive',
			params: ['archive'],
			expect: { output: '' }
	}),

	startReset: L.rpc.declare({
		object: 'luci2.system',
		method: 'reset_start'
	}),

	handleFlashUpload: function() {
		var self = this;
		L.ui.upload(
			L.tr('Firmware upload'),
			L.tr('Select the sysupgrade image to flash and click "%s" to proceed.').format(L.tr('Ok')), {
				filename: '/tmp/firmware.bin',
				success: function(info) {
					self.handleFlashVerify(info);
				}
			}
		);
	},
	
	handleFlashUploadRetainConfig: function() {
		var self = this;
		L.ui.upload(
			L.tr('Firmware upload'),
			L.tr('Select the sysupgrade image to flash and click "%s" to proceed.').format(L.tr('Ok')), {
				filename: '/tmp/firmware.bin',
				success: function(info) {
					self.handleFlashVerifyRetainConfig(info);
				}
			}
		);
	},

	handleFlashVerify: function(info) {
		var self = this;
		self.testUpgrade().then(function(res) {
			if (res.code == 0)
			{
				L.ui.dialog(
					L.tr('Verify firmware'), [
						$('<p />').text(L.tr('The firmware image was uploaded completely. Please verify the checksum and file size below, then click "%s" to start the flash procedure.').format(L.tr('Ok'))),
						$('<ul />')
							.append($('<li />')
								.append($('<strong />').text(L.tr('Checksum') + ': '))
								.append(info.checksum))
							.append($('<li />')
								.append($('<strong />').text(L.tr('Size') + ': '))
								.append('%1024mB'.format(info.size))),						
					], {
						style: 'confirm',
						confirm: function() {
							self.startUpgrade().then(function() {
								L.ui.reconnect();
							});

							alert('Flash...');
						}
					}
				);
			}
			else
			{
				L.ui.dialog(
					L.tr('Invalid image'), [
						$('<p />').text(L.tr('Firmware image verification failed, the "sysupgrade" command responded with the message below:')),
						$('<pre />')
							.addClass('alert-message')
							.text(res.stdout || res.stderr),
						$('<p />').text(L.tr('Image verification failed with code %d.').format(res.code))
					], {
						style: 'close',
						close: function() {
							self.cleanUpgrade().then(function() {
								L.ui.dialog(false);
							});
						}
					}
				);
			}
		});
	},
	
	handleFlashVerifyRetainConfig: function(info) {
		var self = this;
		self.testUpgrade().then(function(res) {
			if (res.code == 0)
			{
				L.ui.dialog(
					L.tr('Verify firmware'), [
						$('<p />').text(L.tr('The firmware image was uploaded completely. Please verify the checksum and file size below, then click "%s" to start the flash procedure.').format(L.tr('Ok'))),
						$('<ul />')
							.append($('<li />')
								.append($('<strong />').text(L.tr('Checksum') + ': '))
								.append(info.checksum))
							.append($('<li />')
								.append($('<strong />').text(L.tr('Size') + ': '))
								.append('%1024mB'.format(info.size))),						
					], {
						style: 'confirm',
						confirm: function() {
							self.RetainConfigstartUpgrade().then(function() {
								L.ui.reconnect();
							});

							alert('Flash...');
						}
					}
				);
			}
			else
			{
				L.ui.dialog(
					L.tr('Invalid image'), [
						$('<p />').text(L.tr('Firmware image verification failed, the "sysupgrade" command responded with the message below:')),
						$('<pre />')
							.addClass('alert-message')
							.text(res.stdout || res.stderr),
						$('<p />').text(L.tr('Image verification failed with code %d.').format(res.code))
					], {
						style: 'close',
						close: function() {
							self.cleanUpgrade().then(function() {
								L.ui.dialog(false);
							});
						}
					}
				);
			}
		});
	},

	handleBackupUpload: function() {
		var self = this;
		L.ui.upload(
			L.tr('Backup restore'),
			L.tr('Select the backup archive to restore and click "%s" to proceed.').format(L.tr('Ok')), {
				filename: '/tmp/backup.txt',
				success: function(info) {
					self.handleBackupVerify(info);
				}
			}
		);
	},

	handleBackupVerify: function(info) {
		var self = this;
		L.ui.dialog(
			L.tr('Backup restore'), [
				$('<p />').text(L.tr('The backup archive was uploaded completely. Please verify the checksum and file size below, then click "%s" to restore the archive.').format(L.tr('Apply'))),
				$('<ul />')
					.append($('<li />')
						.append($('<strong />').text(L.tr('Checksum') + ': '))
						.append(info.checksum))
					.append($('<li />')
						.append($('<strong />').text(L.tr('Size') + ': '))
						.append('%1024mB'.format(info.size)))
			], {
				style: 'confirm',
				confirm: function(info) {
					self.handleBackupRestore(info);
				}
			}
		);
	},

	handleBackupRestore: function(info) {
		var self = this;
		var archive=$('[name=filename]').val();

		//self.restoreBackup().then(function(res) {
		self.TestArchive().then(function(TestArchiveOutput){
			
			var res=TestArchiveOutput.localeCompare("")
			
			if (res == 0)
			{
				L.ui.dialog(
					L.tr('Backup restore'), [
						$('<p />').text(L.tr('The backup is successfully restored,Please wait for board to reboot.')),
						$('<input />')
							.addClass('cbi-button')
							.attr('type', 'button')
							.attr('value', L.tr('Rebooting......'))
							//.click(function() {								
								//alert('Rebooting the system...'); 
								//self.RebootSystem().then(function(rv) {
								//alert(rv);
				                   //});
							//})
					]
					//{
						//style: 'close',
						//close: function() {
							//self.cleanBackup().then(function() {
								//L.ui.dialog(false);
							//});
						//}
					//}
				);
			}
			else
			{
				L.ui.dialog(
					L.tr('Backup restore'), [
						$('<p />').text(L.tr('Invalid Archive.Please upload valid archive.')),
						$('<pre />')
							.addClass('alert-message')
							.text(res.stdout || res.stderr),
						//$('<p />').text(L.tr('Backup restoration failed with code %d.').format(res.code))
					], {
						style: 'close',
						close: function() {
							self.cleanBackup().then(function() {
								L.ui.dialog(false);
							});
						}
					}
				);
			}
		});
	},

	handleBackupDownload: function() {
		var form = $('#btn_backup').parent();

		form.find('[name=sessionid]').val(L.globals.sid);
		form.submit();
	},

	handleReset: function() {
		var self = this;
		L.ui.dialog(L.tr('Really reset all changes?'), L.tr('This will reset the system to its initial configuration, all changes made since the initial flash will be lost!'), {
			style: 'confirm',
			confirm: function() {
				self.startReset().then(function() {
					L.ui.reconnect();
				});

				alert('Reset...');
			}
		});
	},

	execute: function() {
		var self = this;
		
//		 var m = new L.cbi.Map('importexportconfig', {
  //      });
        
    //    var s = m.section(L.cbi.NamedSection, 'importexportconfig', {
      //      caption:L.tr('Import/Export')
       // });
        
/*        s.option(L.cbi.CheckboxValue, 'enableretainboardconfig', {
      caption: L.tr('Retain Serial Number/MAC ID'),
      optional: true
      });*/

		self.testReset().then(function(reset_avail) {
			if (!reset_avail) {
				$('#btn_reset').prop('disabled', true);
			}

			if (!self.options.acls.backup) {
				$('#btn_restore, #btn_save, textarea').prop('disabled', true);
			}
			else {
				$('#btn_backup').click(function() { self.handleBackupDownload(); });
				$('#btn_restore').click(function() { self.handleBackupUpload(); });
			}

			if (!self.options.acls.upgrade) {
				$('#btn_flash, #btn_reset','#btn_retainconfig_flash').prop('disabled', true);
			}
			else {
				$('#btn_flash').click(function() { self.handleFlashUpload(); });
				$('#btn_reset').click(function() { self.handleReset(); });
				$('#btn_retainconfig_flash').click(function() { self.handleFlashUploadRetainConfig(); });
			}

			return self.getBackupConfig();
		}).then(function(config) {
			$('textarea')
				.attr('rows', (config.match(/\n/g) || [ ]).length + 1)
				.val(config);

			$('#btn_save')
				.click(function() {
					var data = ($('textarea').val() || '').replace(/\r/g, '').replace(/\n?$/, '\n');
					L.ui.loading(true);
					self.setBackupConfig(data).then(function() {
						$('textarea')
							.attr('rows', (data.match(/\n/g) || [ ]).length + 1)
							.val(data);

						L.ui.loading(false);
					});
				});

			$('#btn_list')
				.click(function() {
					L.ui.loading(true);
					self.listBackup().then(function(list) {
						L.ui.loading(false);
						L.ui.dialog(
							L.tr('Backup file list'),
							$('<textarea />')
								.css('width', '100%')
								.attr('rows', list.length)
								.prop('readonly', true)
								.addClass('form-control')
								.val(list.join('\n')),
							{ style: 'close' }
						);
					});
				});
		});
		
//		 return m.insertInto('#map');

	}
});
