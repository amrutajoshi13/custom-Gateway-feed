L.ui.view.extend({

	title: L.tr('Device Health Configration'),
	description: L.tr(''),

	SGetUCISections: L.rpc.declare({
		object: 'uci',
		method: 'get',
		params: ['config', 'type'],
		expect: { values: {} }
	}),

	SCreateUCISection: L.rpc.declare({
		object: 'uci',
		method: 'add',
		params: ['config', 'type', 'values']
	}),


	configTypeAddsection: L.rpc.declare({
		object: 'uci',
		method: 'add',
		params: ['config', 'type', 'name', 'values']
	}),


	SDeleteUCISection: L.rpc.declare({
		object: 'uci',
		method: 'delete',
		params: ['config', 'type', 'section']
	}),


	SCommitUCISection: L.rpc.declare({
		object: 'uci',
		method: 'commit',
		params: ['config']
	}),

	// cloud config 

	RunUdev: L.rpc.declare({
		object: 'command',
		method: 'exec',
		params: ['command', 'args'],
	}),

	fGetUCISections: L.rpc.declare({
		object: 'uci',
		method: 'get',
		params: ['config', 'type']

	}),

	GetUCISections: L.rpc.declare({
		object: 'uci',
		method: 'get',
		params: ['config', 'type'],
		expect: { values: {} }
	}),

	deletekeyfile: L.rpc.declare({
		object: 'rpc-cloudconfigNH',
		method: 'delete',
		expect: { output: '' }
	}),

	countcertficates: L.rpc.declare({
		object: 'rpc-cloudconfigNH',
		method: 'countkeyfiles',
		expect: { output: '' }
	}),

	updatecloudconfig: L.rpc.declare({
		object: 'rpc-cloudconfigNH',
		method: 'configure',
		params: ['application', 'action'],
		expect: { output: '' }
	}),

	updatenmsdisableconfig: L.rpc.declare({
		object: 'rpc-cloudconfigNH',
		method: 'update',
		params: ['application', 'action'],
		expect: { output: '' }
	}),

	countkeys: L.rpc.declare({
		object: 'rpc-cloudconfigNH',
		method: 'countkeyfiles',
		expect: { output: '' }
	}),

	TestArchive: L.rpc.declare({
		object: 'rpc-cloudconfigNH',
		method: 'testarchive',
		params: ['archive'],
	}),

	GetUCISections: L.rpc.declare({
		object: 'uci',
		method: 'get',
		params: ['config', 'type'],
		expect: { values: {} }
	}),

	updateinterfaceconfig: L.rpc.declare({
		object: 'rpc-cloudconfigNH',
		method: 'save',
		expect: { output: '' }
	}),





	SCreateForm: function (mapwidget, fSectionID, fSectionType) {
		var self = this;

		if (!mapwidget)
			mapwidget = L.cbi.Map;


		// if(fSectionType == "Dredirect") {
		// 	var FormContent = self.pfCreateFormCallback;
		// }else if(fSectionType == "Sredirect") {
		// 	var FormContent = self.snCreateFormCallback;
		// }else if(fSectionType == "Drule") {
		// 	var FormContent =self.rlCreateFormCallback;
		// }else if(fSectionType == "Srule") {
		// 	var FormContent =self.pcCreateFormCallback;
		if (fSectionType == "Modbus") {
			var FormContent = self.SMCreateFormCallback;
		}
		else if (fSectionType == "Dio") {
			var FormContent = self.SDCreateFormCallback;
		}
		else if (fSectionType == "Ai") {
			var FormContent = self.SACreateFormCallback;
		}
		else if (fSectionType == "RS232") {
			var FormContent = self.RS232CreateFormCallback;
		}
		else if (fSectionType == "snmp") {
			var FormContent = self.SNMPCreateFormCallback;
		}
		else if (fSectionType == "Tmp") {
			var FormContent = self.STCreateFormCallback;
		}
		var map = new mapwidget('Health_Jsonconfig', {
			prepare: FormContent,
			fSection: fSectionID
		});

		return map;
	},

	SSectionEdit: function (ev) {
		var self = ev.data.self;
		var fSectionID = ev.data.fSectionID;
		var fSectionType = ev.data.fSectionType;

		return self.SCreateForm(L.cbi.Modal, fSectionID, fSectionType).show();
	},

	// //////////////////////////MDS///////////////////////////////////

	SMCreateFormCallback: function () {
		var map = this;
		var fSectionID = map.options.fSection;

		map.options.caption = L.tr('Zone Forwarding');

		var s = map.section(L.cbi.SingleSection, fSectionID, {
			anonymous: true,
			tabbed: true
		});



		s.option(L.cbi.ListValue, 'ModbusParameter', {
			caption: L.tr('Field Content'),
		}).value("Device_ID", L.tr("Deviceid"))
			.value("Device_Model", L.tr("DeviceModel"))
			.value("Router_Firmware_Version", L.tr("RouterFirmwareVersion"))
			.value("Gateway_Firmware_Version", L.tr("GatewayFirmwareVersion"))
			.value("Ethernet_WAN_MAC_ID", L.tr("EthernetWANMACID"))
			.value("System_Uptime", L.tr("SystemUptime"))
			.value("Average_CPU_Usage", L.tr("AverageCPUUsage"))
			.value("RAM_Usage", L.tr("RAMUsage"))
			.value("Flash_Usage", L.tr("FlashUsage"))
			.value("WiFi_SSID", L.tr("WiFiSSID"))
			.value("No_of_DHCP_Leases", L.tr("NoofDHCPLeases"))
			.value("Connection_Type", L.tr("ConnectionType"))
			.value("Connection_Status", L.tr("ConnectionStatus"))
			.value("Internet_Uptime", L.tr("InternetUptime"))
			.value("Active_WAN_IP", L.tr("WANIP"))
			.value("LAN_IP", L.tr("LANIP"))
			.value("CPIN_Status", L.tr("CPINStatus"))
			.value("ICCID", L.tr("ICCIDa"))
			.value("IMSI", L.tr("IMSIb"))
			.value("Mobile_Operator_Name", L.tr("MobileOperatorName"))
			.value("Mobile_Operator_Code", L.tr("MobileOperatorCode"))
			.value("CREG_Status", L.tr("CREGStatus"))
			.value("CGATT_Status", L.tr("CGATTStatus"))
			.value("SIM_RAT", L.tr("SIMRAT"))
			.value("Mobile_Signal_CSQ", L.tr("MobileSignalCSQ"))
			.value("RSRP_SINR", L.tr("RSRPSINR"))
			.value("Cellular_WAN_Statistics_Daily", L.tr("daily_datausage"))
			.value("Cellular_WAN_Statistics_Monthly", L.tr("monthly_datausage"))
			.value("Device_Last_PowerOFF_Time", L.tr("PowerOFFTime"))
			.value("Device_Last_PowerOFF_Reason", L.tr("PowerOFFreason"))
			.value("Device_Last_PowerON_Time", L.tr("PowerONTime"))
			.value("Device_Temperature", L.tr("Temperature"))
			.value("Device_UUID", L.tr("DeviceUUID"))
			.value("CPU_avg", L.tr("CPUavg"))
			.value("CSQ", L.tr("DeviceCSQ"))
			.value("Customfield1", L.tr("NHCustomparam1"))
			.value("Customfield2", L.tr("NHCustomparam2"))
			.value("Customfield3", L.tr("NHCustomparam3"));


		s.option(L.cbi.InputValue, 'Parameterkey', {
			caption: L.tr('Field JSON Key Name')
		});

		// s.option(L.cbi.InputValue, 'Parametervalue', {
		// 	caption: L.tr('Field JSON Key Value')
		// }).depends({ 'ModbusParameter': 'Customfield1' })
		// 	.depends({ 'ModbusParameter': 'Customfield2' })
		// 	.depends({ 'ModbusParameter': 'Customfield3' });

		//s.option(L.cbi.InputValue,'RS485CustomParam1' ,{                            
		//caption: L.tr('Field JSON Key Value')                                
		//}).depends({'ModbusParameter':'RS485Customfield1'});
		//s.option(L.cbi.InputValue,'RS485CustomParam2' ,{                            
		//caption: L.tr('Field JSON Key Value')                                
		//}).depends({'ModbusParameter':'RS485Customfield2'});

		//s.option(L.cbi.InputValue,'RS485CustomParam3' ,{                            
		//caption: L.tr('Field JSON Key Value')                                
		//}).depends({'ModbusParameter':'RS485Customfield3'});

		//s.option(L.cbi.InputValue,'RS485CustomParam4' ,{                            
		//caption: L.tr('Field JSON Key Value')                                
		//}).depends({'ModbusParameter':'RS485Customfield4'});

		//s.option(L.cbi.InputValue,'RS485CustomParam5' ,{                            
		//caption: L.tr('Field JSON Key Value')                                
		//}).depends({'ModbusParameter':'RS485Customfield5'});

	},

	SMRenderContents: function (data, rv) {
		var self = this;

		// Clear the previous table content to prevent duplicates
		$('#section_firewall_zonefor').empty();



		var list2 = new L.ui.table({
			columns: [{
				caption: L.tr('Fieldnumber'),
				align: 'left',
				format: function (v, n) {
					var div = $('<p />').attr('id', 'RS485DeviceSerialNo_%s'.format(n));
					var serialNo = n + 1;
					return div.append('<strong>' + serialNo + '<strong>');
				}
			},

			{
				caption: L.tr('Field Content'),
				format: function (v, n) {
					var div = $('<small />').attr('id', 'zfSource_%s'.format(n));
					return div.append(v);
				}
			}, {
				caption: L.tr('JSON Key Name'),
				format: function (v, n) {
					var div = $('<small />').attr('id', 'zfDestination_%s'.format(n));
					return div.append(v);
				}
			}, {
				caption: L.tr('Actions'),
				format: function (v, n) {
					return $('<div />')
						.addClass('btn-group btn-group-sm')
						.append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Edit Configuration'))
							.click({ self: self, fSectionID: v, fSectionType: "Modbus" }, self.SSectionEdit))
						.append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Configuration'))
							.click({ self: self, fSectionID: v }, self.SMSectionRemove));
				}
			}]
		});


		for (var key in data) {
			if (data.hasOwnProperty(key)) {
				var obj = data[key];
				var Modbus = obj.ModbusParameter;
				var Parameter = obj.Parameterkey;

				list2.row([key, Modbus, Parameter, key]); // Modbus is not displaying here
			}
		}

		for (var key in rv) {
			if (rv.hasOwnProperty(key)) {
				var obj = rv[key];
				var Modbus = obj.ModbusParameter;
				var Parameter = obj.Parameterkey;

				var sdata = {
					"Device_ID": "Deviceid",
					"Device_Model": "DeviceModel",
					"Router_Firmware_Version": "RouterFirmwareVersion",
					"Gateway_Firmware_Version": "GatewayFirmwareVersion",
					"Ethernet_WAN_MAC_ID": "EthernetWANMACID",
					"System_Uptime": "SystemUptime",
					"Average_CPU_Usage": "AverageCPUUsage",
					"RAM_Usage": "RAMUsage",
					"Flash_Usage": "FlashUsage",
					"WiFi_SSID": "WiFiSSID",
					"No_of_DHCP_Leases": "NoofDHCPLeases",
					"Connection_Type": "ConnectionType",
					"Connection_Status": "ConnectionStatus",
					"Internet_Uptime": "InternetUptime",
					"Active_WAN_IP": "WANIP",
					"LAN_IP": "LANIP",
					"CPIN_Status": "CPINStatus",
					"ICCID": "ICCIDa",
					"IMSI": "IMSIb",
					"Mobile_Operator_Name": "MobileOperatorName",
					"Mobile_Operator_Code": "MobileOperatorCode",
					"CREG_Status": "CREGStatus",
					"CGATT_Status": "CGATTStatus",
					"SIM_RAT": "SIMRAT",
					"Mobile_Signal_CSQ": "MobileSignalCSQ",
					"RSRP_SINR": "RSRPSINR",
					"Cellular_WAN_Statistics_Daily": "daily_datausage",
					"Cellular_WAN_Statistics_Monthly": "monthly_datausage",
					"Device_Last_PowerOFF_Time": "PowerOFFTime",
					"Device_Last_PowerOFF_Reason": "PowerOFFreason",
					"Device_Last_PowerON_Time": "PowerONTime",
					"Device_Temperature": "Temperature",
					"Device_UUID": "DeviceUUID",
					"CPU_avg": "CPUavg",
					"CSQ": "DeviceCSQ",
					"Customfield1": "NHCustomparam1",
					"Customfield2": "NHCustomparam2",
					"Customfield3": "NHCustomparam3"

				};
				list2.row([key, sdata[Modbus], Parameter, key]);
			}


		}
		$('#section_firewall_zonefor').
			append(list2.render());

	},

	SMSectionRemove: function (ev) {
		var self = ev.data.self;
		var zfSectionID = ev.data.fSectionID;


		self.SDeleteUCISection("Health_Jsonconfig", "JsonRs485Indexconfig", zfSectionID).then(function (rv) {
			if (rv == 0) {

				self.SCommitUCISection("Health_Jsonconfig").then(function (res) {
					if (res != 0) {
						alert("Error: Delete Zone Forwarding");
					}
					else {
						document.cookie = "LastActiveTab=TabZf";
						document.cookie = "LastAction=delete";
						location.reload();
					}

				});
			};
		});
	},

	SMSectionAdd: function () {
		var self = this;
		var zfSource = $('#field_firewall_zone_newZone_src').val();
		var zfDestination = $('#field_firewall_zone_newZone_destzone').val();
		var serialNumber = $('#section_firewall_zonefor tr').length + 0;
		// var AsrTocheck=false;

		if (zfDestination) {
			var SectionOptions = { SerialNumber: serialNumber, ModbusParameter: zfSource, Parameterkey: zfDestination };
			this.SCreateUCISection("Health_Jsonconfig", "JsonRs485Indexconfig", SectionOptions).then(function (rv) {
				if (rv) {
					if (rv.section) {
						self.SCommitUCISection("Health_Jsonconfig").then(function (res) {
							if (res != 0) {
								alert("Error: New Zone Forwarding");
							}
							else {
								document.cookie = "LastActiveTab=TabZf";
								document.cookie = "LastAction=add";
								location.reload();
							}
						});

					};
				};
			});
		}
		else {
			alert("Please Enter JsonKey")
		}

	},


	// //////////////////////////AI Sender///////////////////////////////////

	handleArchiveUpload: function () {
		var self = this;
		L.ui.archiveUploadcertstlshealth(
			L.tr('File Upload'),
			L.tr('Select the file and click on "%s" button to proceed.').format(L.tr('Apply')), {
			success: function (info) {
				self.handleArchiveVerify(info);
			}
		}
		);
	},

	handleArchiveVerify: function (info) {
		var self = this;
		var archive = $('[name=filename]').val();

		// if((checksumval == info.checksum) &&(sizeval == info.size)) {
		L.ui.loading(true);
		self.TestArchive(archive).then(function (TestArchiveOutput) {

			L.ui.dialog(
				L.tr('TestArchive'), [
				$('<p />').text(L.tr('Success')),
				$('<pre />')
					.addClass('alert-success')
					.text("file uploaded successfully")
			], {
				style: 'close',

			}
			);
			L.ui.loading(false);
		});
		//}

	},


	execute: function () {
		var self = this;


		// parameter configration 
		this.SGetUCISections("Health_Jsonconfig", "JsonRs485Indexconfig").then(function (data, rv) {
			self.SMRenderContents(data, rv);

		});

		$('#AddNewzoneForwarding').click(function () {
			self.SMSectionAdd();
		});

		// cloudconfig	
		var m1 = new L.cbi.Map('cloudconfigNH', {
		});

		var s2 = m1.section(L.cbi.NamedSection, 'cloudconfigNH', {
			caption: L.tr('Cloud Configuration')
		});

		s2.option(L.cbi.CheckboxValue, 'enablenwh', {
			caption: L.tr('Enable Network Health')
		});

		s2.option(L.cbi.ReadonlyInputValue, 'SiteID', {
			caption: L.tr('Site ID'),
			editable: false
		}).depends({ 'enablenwh': '1' });

		s2.option(L.cbi.ListValue, 'dataformat', {
			caption: L.tr('Data Format'),
		}).value("json", L.tr('JSON'))
			// .value("csv", L.tr('CSV'))
			.depends({ 'enablenwh': '1' });


		s2.option(L.cbi.InputValue, 'timesec', {
			caption: L.tr('Periodic Interval (min)'),
			description: L.tr('(Minimum 5 min)')
		})
		.depends({ 'enablenwh': '1' })
		.on('change', function() {
			var timesecValue = this.value;  
			if (timesecValue < 5) {
				alert(L.tr('Value must be at least 5 minutes.'));
			}
		});
		
		s2.option(L.cbi.ListValue, 'cloudprotocol', {
			caption: L.tr('Cloud / Protocol'),
		}).value("http", L.tr('HTTP'))
			.value("mqtt", L.tr('MQTT'))
			.depends({ 'enablenwh': '1' });

		/* HTTP */

		s2.option(L.cbi.ListValue, 'HTTPServerURL', {
			caption: L.tr('HTTP URL'),
		}).depends({ 'cloudprotocol': 'http', 'enablenwh': '1' })
			.value("url", L.tr('http://silbo.co.in'))
			.value("2", L.tr('custom'));

		s2.option(L.cbi.InputValue, 'HTTPcustomURL', {
			caption: L.tr('HTTP CustomUrl'),
		}).depends({ 'cloudprotocol': 'http', 'HTTPServerURL': '2', 'enablenwh': '1' });

		s2.option(L.cbi.InputValue, 'HTTPServerPort', {
			caption: L.tr('HTTP Port (Optional)'),
			optional: 'true',
		}).depends({ 'cloudprotocol': 'http', 'HTTPServerURL': '2', 'enablenwh': '1' });

		s2.option(L.cbi.ListValue, 'httpauthenable', {
			caption: L.tr('Enable Authentication'),
		}).depends({ 'cloudprotocol': 'http', 'HTTPServerURL': '2', 'enablenwh': '1' })
			.value("0", L.tr('No Authentication'))
			.value("1", L.tr('Username/Password'))
			.value("2", L.tr('Bearer Token'));

		s2.option(L.cbi.InputValue, 'username', {
			caption: L.tr('Username'),
		}).depends({ 'cloudprotocol': 'http', 'HTTPServerURL': '2', 'httpauthenable': '1', 'enablenwh': '1' });

		s2.option(L.cbi.PasswordValue, 'password', {
			caption: L.tr('Password'),
		}).depends({ 'cloudprotocol': 'http', 'HTTPServerURL': '2', 'httpauthenable': '1', 'enablenwh': '1' });

		s2.option(L.cbi.InputValue, 'entertoken', {
			caption: L.tr('Token'),
		}).depends({ 'cloudprotocol': 'http', 'HTTPServerURL': '2', 'httpauthenable': '2', 'enablenwh': '1' });

		s2.option(L.cbi.CheckboxValue, 'serverresponsevalidationenable', {
			caption: L.tr('Enable Server Response Validation')
		}).depends({ 'cloudprotocol': 'http', 'HTTPServerURL': '2,', 'enablenwh': '1' });

		s2.option(L.cbi.ComboBox, 'serverresponsestring', {
			caption: L.tr('Server Response'),
		}).depends({ 'cloudprotocol': 'http', 'HTTPServerURL': '2', 'serverresponsevalidationenable': '1', 'enablenwh': '1' })
			.value("none", L.tr('--please choose--'))
			.value("Recordid", L.tr('RecordID'));

		s2.option(L.cbi.ListValue, 'HTTPMethod', {
			caption: L.tr('Method'),
		}).depends({ 'cloudprotocol': 'http', 'HTTPServerURL': '2', 'enablenwh': '1' })
			.value("0", L.tr('Post'))
			.value("1", L.tr('Get'));
		/* MQTT */
		s2.option(L.cbi.InputValue, 'host', {
			caption: L.tr('MQTT Host'),
		}).depends({ 'cloudprotocol': 'mqtt', 'enablenwh': '1' });

		s2.option(L.cbi.InputValue, 'mqttport', {
			caption: L.tr('MQTT Port'),
			optional: 'true',
		}).depends({ 'cloudprotocol': 'mqtt', 'enablenwh': '1' });

		s2.option(L.cbi.ListValue, 'mqttauthmode', {
			caption: L.tr('Authentication Mode'),
		}).depends({ 'cloudprotocol': 'mqtt', 'enablenwh': '1' })
			.value("3", L.tr('No Authentication'))
			.value("2", L.tr('Username/Password'))
			.value("1", L.tr('User Name & Password with CA certificate'))
			.value("0", L.tr('TLS'));

		s2.option(L.cbi.InputValue, 'mqttusername', {
			caption: L.tr('Username'),
		}).depends({ 'cloudprotocol': 'mqtt', 'mqttauthmode': '1', 'enablenwh': '1' })
			.depends({ 'cloudprotocol': 'mqtt', 'mqttauthmode': '2', 'enablenwh': '1' });

		s2.option(L.cbi.PasswordValue, 'mqttpassword', {
			caption: L.tr('Password'),
		}).depends({ 'cloudprotocol': 'mqtt', 'mqttauthmode': '1', 'enablenwh': '1' })
			.depends({ 'cloudprotocol': 'mqtt', 'mqttauthmode': '2', 'enablenwh': '1' });

		s2.option(L.cbi.CheckboxValue, 'enablepublishoverlan', {
			caption: L.tr('Enable Publish Over LAN')
		}).depends({ 'cloudprotocol': 'mqtt', 'enablenwh': '1' });

		s2.option(L.cbi.InputValue, 'topicname', {
			caption: L.tr('Topic Name')
		}).depends({ 'cloudprotocol': 'mqtt', 'enablenwh': '1' });

		m1.insertInto('#sectiontab_dio_sender');

		self.GetUCISections("sourceconfig", "sourceconfig").then(function (rv) {
			for (var key in rv) {
				if (rv.hasOwnProperty(key)) {
					var obj = rv[key];

					if (obj.EMeterRS485Line1DataSourceEnable === '1') {
						enablers485 = true;
					}

					// if (obj.EMeterRS232Line1DataSourceEnable === '1') {
					// 	enablers232 = true;
					// }
					//  if (obj.AIODataSourceEnable === '1') {
					// 	enableaio = true;
					// }
					//  if (obj.DIODataSourceEnable === '1') {
					// 	enabledio = true;
					// }
					// if (obj.TEMPERATUREDataSourceEnable === '1') {
					// 	enabletemperature = true;
					// }
				}
			}

		});


		/* Added for testing */
		self.GetUCISections("cloudconfigNH", "cloudconfigNH").then(function (rv) {
			for (var key in rv) {
				if (rv.hasOwnProperty(key)) {
					var obj = rv[key];
					var enabletls = obj.mqttauthmode;
					var cloudprotocol = obj.cloudprotocol
					var status = obj.enablenwh;
					var invurl = obj.HTTPServerURL;

					if (status == '1') {
						$("#Mansection_firewall_zonefor").css("display", "block");
						$("#section_firewall_zonefor").css("display", "block");

					} else {
						$("#Mansection_firewall_zonefor").css("display", "none");
						$("#section_firewall_zonefor").css("display", "none");
						$("#addButton").css("display", "none");
						$("#UpdateZoneForwarding").css("display", "none");
					}

					if (invurl == 'url') {
						$("#Mansection_firewall_zonefor").css("display", "none");
						// $('#section_firewall_zonefor').empty();
						$("#UpdateZoneForwarding").css("display", "none");
					}
					// else {
					// 	$("#Mansection_firewall_zonefor").css("display", "block");
					// }


					if (cloudprotocol == 'mqtt') {
						if (enabletls == '1' || enabletls == '0') {
							$("#Mansectiontab_dio_sender").css("display", "block");
						} else {
							$("#Mansectiontab_dio_sender").css("display", "none");
						}
					} else {
						$("#Mansectiontab_dio_sender").css("display", "none");
					}


					if (cloudprotocol == 'mqtt') {
						if (enabletls == '2' || enabletls == '3') {
							var ErrorMsg = "TLS & CA not selected";
							$("#btn_upload").empty().show();
							$("#btn_upload").append(ErrorMsg);

							$("#btn_delete").empty().show();
							$("#btn_delete").append(ErrorMsg);

						}

						if (enabletls == '0' || enabletls == '1') {
							$('#btn_upload').click(function () {
								//self.handleArchiveUpload();

								self.countcertficates().then(function (rv) {



									//alert(rv);
									var count = '1';
									if (rv < '1') {
										$('#btn_upload').click(function () {
											self.handleArchiveUpload();
										});
									}
									else {
										L.ui.loading(false);
										L.ui.dialog(

											L.tr('Upload Certificates error'), [
											$('<p />').text(L.tr('Output')),
											$('<pre />')
												.addClass('alert alert-danger')
												.text("Please click on Delete button to delete existing files and then click on upload button"),
										],
											{
												style: 'close',
												close: function () {
													location.reload();
												}
											}
										);



									}

								});
							});



						}
					}
					else {
						var ErrorMsg = "Invalid Config";
						$("#btn_upload").empty().show();
						$("#btn_upload").append(ErrorMsg);

						$("#btn_delete").empty().show();
						$("#btn_delete").append(ErrorMsg);
					}
				}
			}
		});

		/* default invendisurl */
		self.GetUCISections("cloudconfigNH", "cloudconfigNH").then(function (rv) {
			for (var key in rv) {
				if (rv.hasOwnProperty(key)) {
					var obj = rv[key];
					var invurl = obj.HTTPServerURL;

					if (invurl === 'url') {
						var data = {
							"Device_ID": {
								"ModbusParameter": "Deviceid",
								"Parameterkey": "Device_ID"
							},
							"Device_Model": {
								"ModbusParameter": "DeviceModel",
								"Parameterkey": "Device_Model"
							},
							"Router_Firmware_Version": {
								"ModbusParameter": "RouterFirmwareVersion",
								"Parameterkey": "Router_Firmware_Version"
							},
							"Gateway_Firmware_Version": {
								"ModbusParameter": "GatewayFirmwareVersion",
								"Parameterkey": "Gateway_Firmware_Version"
							},
							"Ethernet_WAN_MAC_ID": {
								"ModbusParameter": "EthernetWANMACID",
								"Parameterkey": "Ethernet_WAN_MAC_ID"
							},
							"System_Uptime": {
								"ModbusParameter": "SystemUptime",
								"Parameterkey": "System_Uptime"
							},
							"Average_CPU_Usage": {
								"ModbusParameter": "AverageCPUUsage",
								"Parameterkey": "Average_CPU_Usage"
							},
							"RAM_Usage": {
								"ModbusParameter": "RAMUsage",
								"Parameterkey": "RAM_Usage"
							},
							"Flash_Usage": {
								"ModbusParameter": "FlashUsage",
								"Parameterkey": "Flash_Usage"
							},
							"WiFi_SSID": {
								"ModbusParameter": "WiFiSSID",
								"Parameterkey": "WiFi_SSID"
							},
							"No_of_DHCP_Leases": {
								"ModbusParameter": "NoofDHCPLeases",
								"Parameterkey": "No_of_DHCP_Leases"
							},
							"Connection_Type": {
								"ModbusParameter": "ConnectionType",
								"Parameterkey": "Connection_Type"
							},
							"Connection_Status": {
								"ModbusParameter": "ConnectionStatus",
								"Parameterkey": "Connection_Status"
							},
							"Internet_Uptime": {
								"ModbusParameter": "InternetUptime",
								"Parameterkey": "Internet_Uptime"
							},
							"Active_WAN_IP": {
								"ModbusParameter": "WANIP",
								"Parameterkey": "Active_WAN_IP"
							},
							"LAN_IP": {
								"ModbusParameter": "LANIP",
								"Parameterkey": "LAN_IP"
							},
							"CPIN_Status": {
								"ModbusParameter": "CPINStatus",
								"Parameterkey": "CPIN_Status"
							},
							"ICCID": {
								"ModbusParameter": "ICCIDa",
								"Parameterkey": "ICCID"
							},
							"IMSI": {
								"ModbusParameter": "IMSIb",
								"Parameterkey": "IMSI"
							},
							"Mobile_Operator_Name": {
								"ModbusParameter": "MobileOperatorName",
								"Parameterkey": "Mobile_Operator_Name"
							},
							"Mobile_Operator_Code": {
								"ModbusParameter": "MobileOperatorCode",
								"Parameterkey": "Mobile_Operator_Code"
							},
							"CREG_Status": {
								"ModbusParameter": "CREGStatus",
								"Parameterkey": "CREG_Status"
							},
							"CGATT_Status": {
								"ModbusParameter": "CGATTStatus",
								"Parameterkey": "CGATT_Status"
							},
							"SIM_RAT": {
								"ModbusParameter": "SIMRAT",
								"Parameterkey": "SIM_RAT"
							},
							"Mobile_Signal_CSQ": {
								"ModbusParameter": "MobileSignalCSQ",
								"Parameterkey": "Mobile_Signal_CSQ"
							},
							"RSRP_SINR": {
								"ModbusParameter": "RSRPSINR",
								"Parameterkey": "RSRP_SINR"
							},
							"Cellular_WAN_Statistics_Daily": {
								"ModbusParameter": "daily_datausage",
								"Parameterkey": "Cellular_WAN_Statistics_Daily"
							},
							"Cellular_WAN_Statistics_Monthly": {
								"ModbusParameter": "monthly_datausage",
								"Parameterkey": "Cellular_WAN_Statistics_Monthly"
							},
							"Device_Last_PowerOFF_Time": {
								"ModbusParameter": "PowerOFFTime",
								"Parameterkey": "Device_Last_PowerOFF_Time"
							},
							"Device_Last_PowerOFF_Reason": {
								"ModbusParameter": "PowerOFFreason",
								"Parameterkey": "Device_Last_PowerOFF_Reason"
							},
							"Device_Last_PowerON_Time": {
								"ModbusParameter": "PowerONTime",
								"Parameterkey": "Device_Last_PowerON_Time"
							},
							"Device_Temperature": {
								"ModbusParameter": "Temperature",
								"Parameterkey": "Device_Temperature"
							},
							"Device_UUID": {
								"ModbusParameter": "DeviceUUID",
								"Parameterkey": "Device_UUID"
							},
							"CPU_avg": {
								"ModbusParameter": "CPUavg",
								"Parameterkey": "CPU_avg"
							},
							"CSQ": {
								"ModbusParameter": "DeviceCSQ",
								"Parameterkey": "CSQ"
							}
						};
						self.SMRenderContents(data);  // Pass custom data to the rendering function
					}
				}
			}
		});

		/* Test purpose end */
		$('#btn_delete').click(function () {
			self.GetUCISections("cloudconfigNH", "cloudconfigNH").then(function (rv) {
				for (var key in rv) {
					// alert(rv);
					if (rv.hasOwnProperty(key)) {
						var obj = rv[key];
						var enabledelete = obj.enabledelete;
						var cloudprotocol = obj.cloudprotocol
						var mqttauthmode = obj.mqttauthmode;
						//alert(enabledelete);
						//alert(cloudprotocol);

						if (cloudprotocol == 'mqtt' && enabledelete == '1' || mqttauthmode == '0') {
							// if (cloudprotocol == 'mqtt' && enabledelete == '1' && mqttauthmode == '0') {
							self.deletekeyfile().then(function (rv) {
								// alert(rv);

								L.ui.loading(false);
								L.ui.dialog(

									L.tr('Delete certificates'), [
									$('<p />').text(L.tr('Output')),
									$('<pre />')
										.addClass('alert alert-info')
										.text("certificates Deleted"),
								],
									{
										style: 'close',
										close: function () {
											location.reload();
										}
									}
								);
							});
						}
						else {
							var ErrorMsg = "Invalid Config";
							$("#btn_upload").empty().show();
							$("#btn_upload").append(ErrorMsg);

							$("#btn_delete").empty().show();
							$("#btn_delete").append(ErrorMsg);
						}
					}
				}
			});
		});

		/* default json values */
		$("#addButton").click(function () {
			self.GetUCISections("cloudconfigNH", "cloudconfigNH").then(function (rv) {
				for (var key in rv) {
					if (rv.hasOwnProperty(key)) {
						var obj = rv[key];
						var Datafromat = obj.dataformat;
						var cloudprotocol = obj.cloudprotocol
						var status = obj.enablenwh;
						var invurl = obj.HTTPServerURL;

						// If URL is selected, show the table content


						if (status == '1' && cloudprotocol == 'http' && Datafromat == 'json') {
							if (invurl == 'url') {
								$("#jsoninfo").css("display", "block");

								fetch('/healtha_all_parameters.json')
									.then(response => {
										if (!response.ok) {
											throw new Error('Failed to load the JSON file');
										}
										return response.json();
									})
									.then(data => {
										$("#jsoninfo").css("display", "block");
										$("#jsoninfo").val(JSON.stringify(data, null, 4));
									})
									.catch(error => {
										console.error('Error:', error);
										$("#jsoninfo").css("display", "block");
										$("#jsoninfo").val("Failed to load JSON file: " + error.message);
									});
							} else {
								$("#jsoninfo").css("display", "block");

								fetch('/health_parameter.json')
									.then(response => {
										if (!response.ok) {
											throw new Error('Failed to load the JSON file');
										}
										return response.json();
									})
									.then(data => {
										$("#jsoninfo").css("display", "block");
										$("#jsoninfo").val(JSON.stringify(data, null, 4));
									})
									.catch(error => {
										console.error('Error:', error);
										$("#jsoninfo").css("display", "block");
										$("#jsoninfo").val("Failed to load JSON file: " + error.message);
									});
							}
						} else {
							$("#jsoninfo").css("display", "none");
						}
					}
				}
			});
		});

		self.updateinterfaceconfig('save').then(function (rv, ev) {
		});
		
		$("#UpdateZoneForwarding").click(function () {
			alert("Configuration updated successfully!");
    		location.reload();
		});

	}
});




