L.ui.view.extend({

	title: L.tr('Routing'),
	//description: L.tr('Please update after editing any changes.'),		

	fGetUCISections: L.rpc.declare({
		object: 'uci',
		method: 'get',
		params: ['config', 'type'],
		expect: { values: {} }
	}),

	fCreateUCISection: L.rpc.declare({
		object: 'uci',
		method: 'add',
		params: ['config', 'type', 'values']
	}),

	fDeleteUCISection: L.rpc.declare({
		object: 'uci',
		method: 'delete',
		params: ['config', 'type', 'section']
	}),

	fCommitUCISection: L.rpc.declare({
		object: 'uci',
		method: 'commit',
		params: ['config']
	}),

	updateroutingconfig: L.rpc.declare({
		object: 'rpc-updateroutingconfig',
		method: 'configure',
		expect: { output: '' }
	}),

	deleteroutingconfig: L.rpc.declare({
		object: 'rpc-updateroutingconfig',
		method: 'delete',
		expect: { output: '' }
	}),


	fCreateForm: function (mapwidget, fSectionID, fSectionType) {
		var self = this;

		if (!mapwidget)
			mapwidget = L.cbi.Map;

		if (fSectionType == "Droutes") {
			var FormContent = self.srCreateFormCallback;
		} else if (fSectionType == "Sroutes") {
			var FormContent = self.AsrCreateFormCallback;
		} 
		// else if (fSectionType == "Rroutes") {
		// 	var FormContent = self.AsrttCreateFormCallback;
		// }
		// else if(fSectionType == "Troutes") {
		// 	var FormContent = self.AsrtCreateFormCallback;
		// }

		var map = new mapwidget('routingconfig', {
			prepare: FormContent,
			fSection: fSectionID
		});
		return map;
	},



	fSectionEdit: function (ev) {
		var self = ev.data.self;
		var fSectionID = ev.data.fSectionID;
		var fSectionType = ev.data.fSectionType;

		return self.fCreateForm(L.cbi.Modal, fSectionID, fSectionType).show();

	},

	srCreateFormCallback: function () {
		var map = this;
		var srSectionID = map.options.fSection;

		map.options.caption = L.tr('Port Forward Configuration');

		var s = map.section(L.cbi.NamedSection, srSectionID, {
			collabsible: true,
			anonymous: true,
			tabbed: true
		});

		s.option(L.cbi.ListValue, 'routetype', {
			caption: L.tr('Route type'),
			optional: 'true'
		}).value("unicast", L.tr('Unicast'))
			.value("blackhole", L.tr('Blackhole'))
			.value("prohibit", L.tr('Prohibit'))
			.value("unreachable", L.tr('Unreachable'))
			.value("throw", L.tr('Throw'))
			.value("broadcast", L.tr('Broadcast'))
			.value("multicast", L.tr('Multicast'));

		s.option(L.cbi.ComboBox, 'tableid', {
			caption: L.tr('Table ID'),
			optional: 'true'
		}).value("table main", L.tr('Table Main'));



		s.option(L.cbi.InputValue, 'target', {
			caption: L.tr('Target'),
			datatype: 'ip4addr',
			optional: true
		});

		s.option(L.cbi.InputValue, 'ipv4netmask', {
			caption: L.tr('IPV4 Netmask'),
			datatype: 'netmask4',
			optional: true,
		});

		s.option(L.cbi.InputValue, 'ipv4gateway', {
			caption: L.tr('IPV4 Gateway'),
			datatype: 'ip4addr',
			optional: true,
		});

		s.option(L.cbi.ComboBox, 'interface', {
			caption: L.tr('Interface'),
			optional: 'true'
		}).value("eth0", L.tr('eth0'))
			.value("eth0.1", L.tr('eth0.1'))
			.value("eth0.5", L.tr('eth0.5'))
			.value("lo", L.tr('lo'))
			.value("ra0", L.tr('ra0'))
			.value("ra1", L.tr('ra1'))
			.value("usb0", L.tr('usb0'))
			.value("wwan0", L.tr('wwan0'));

		s.option(L.cbi.InputValue, 'metric', {
			caption: L.tr('Metric'),
			placeholder: "0",
			datatype: 'uinteger',
			optional: true,

		});

	},


	srRenderContents: function (rv) {
		var self = this;

		var list = new L.ui.table({
			columns: [{
				caption: L.tr('Route type'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'srRoutetype_%s'.format(n));
					return div.append('<strong>' + v + '</strong>');
				}
			}, {
				caption: L.tr('Table ID'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'srRoutetype_%s'.format(n));
					return div.append(v);
				}
			}, {
				caption: L.tr('Target'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'srTarget_%s'.format(n));
					return div.append(v);
				}
			}, {
				caption: L.tr('IPV4 Netmask'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'srIPV4Netmask_%s'.format(n));
					return div.append(v);
				}
			}, {
				caption: L.tr('IPV4 Gateway'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'srIPV4Gateway_%s'.format(n));
					return div.append(v);
				}
			}, {
				caption: L.tr('Interface'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'srInterface_%s'.format(n));
					return div.append(v);
				}
			}, {
				caption: L.tr('Metric'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'srMetric_%s'.format(n));
					return div.append(v);
				}
			}, {
				caption: L.tr('Actions'),
				format: function (v, n) {
					return $('<div />')
						.addClass('btn-group btn-group-sm')
						.append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Edit Custom Routes'))
							.click({ self: self, fSectionID: v, fSectionType: "Droutes" }, self.fSectionEdit))
						.append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Custom Routes'))
							.click({ self: self, srSectionID: v }, self.srSectionRemove));
				}
			}]
		});

		for (var key in rv) {
			if (rv.hasOwnProperty(key)) {
				var obj = rv[key];
				var Sourcemap = obj.interface
				var SourceIP = obj.target;
				var SourceNetmask = obj.ipv4netmask
				var Sourcemetric = obj.metric
				var Sourcegateway = obj.ipv4gateway
				var Sourcetype = obj.routetype
				var Tableid = obj.tableid

				list.row([Sourcetype, Tableid, SourceIP, SourceNetmask, Sourcegateway, Sourcemap, Sourcemetric, key]);
			}
		}


		$('#section_staticroutes_port').append(list.render());

	},


	srSectionRemove: function (ev) {
		var self = ev.data.self;
		var srSectionID = ev.data.srSectionID;

		self.deleteroutingconfig('delete').then(function (rv) {
			self.fDeleteUCISection("routingconfig", "routes", srSectionID).then(function (rv) {
				if (rv == 0) {
					self.fCommitUCISection("routingconfig").then(function (res) {
						if (res != 0) {
							alert("Error: Delete Static Routes Configuration");
						}
						else {
							location.reload();
						}
					});
				};
			});
		});

	},



	srSectionAdd: function () {
		var self = this;
		var srInterface = $('#field_staticroutes_routes_newRoutes_interface').val();
		var srTarget = $('#field_staticroutes_routes_newRoutes_target').val();
		var srIPV4Netmask = $('#field_staticroutes_routes_newRoutes_ipv4netmask').val();
		var srMetric = $('#field_staticroutes_routes_newRoutes_metric').val();
		var srIPV4Gateway = $('#field_staticroutes_routes_newRoutes_ipv4gateway').val();
		var srRoutetype = $('#field_staticroutes_routes_newRoutes_routetype').val();
		var srTable = $('#field_staticroutes_routes_newRoutes_Table').val();
		var srTargetcheck = false;

		if (srInterface === "custom") {
			srInterface = $('#field_staticroutes_routes_newRoutes_inter').val();
		}

		if (srTable === "custom") {
			srTable = $('#field_staticroutes_routes_newRoutes_Table1').val();
		}
		// Regular expression pattern for IPv4 validation
		var ipv4Pattern = /^(\d{1,3}\.){3}\d{1,3}$/;

		// Check if the input matches the IPv4 pattern
		if (ipv4Pattern.test(srTarget)) {
			srTargetcheck = true; // Valid IPv4 address
		}
		var SectionOptions = { interface: srInterface, target: srTarget, ipv4netmask: srIPV4Netmask, metric: srMetric, ipv4gateway: srIPV4Gateway, routetype: srRoutetype, tableid: srTable };
		self.fCreateUCISection("routingconfig", "routes", SectionOptions).then(function (rv) {
			if (rv) {
				if (rv.section) {
					self.fCommitUCISection("routingconfig").then(function (res) {
						if (res != 0) {
							alert("Error: New Static Routes Configuration");
						}
						else {
							location.reload();
						}
					});

				};
			};
		});


	},

	AsrCreateFormCallback: function () {
		var map = this;
		var AsrSectionID = map.options.fSection;

		map.options.caption = L.tr('Port Forward Configuration');

		var s = map.section(L.cbi.NamedSection, AsrSectionID, {
			collabsible: true,
			anonymous: true,
			tabbed: true
		});

		s.option(L.cbi.ListValue, 'ruletype', {
			caption: L.tr('Rule type'),
			optional: 'true'
		}).value("lookup", L.tr('Lookup'))
			.value("prohibit", L.tr('Prohibit'))
			.value("blackhole", L.tr('Blackhole'))
			.value("unreachable", L.tr('Unreachable'));

		s.option(L.cbi.InputValue, 'table', {
			caption: L.tr('Table ID'),
			placeholder: "100",
			datatype: 'uinteger',
			optional: true,
		});


		s.option(L.cbi.InputValue, 'to', {
			caption: L.tr('	Target(To)'),
			datatype: 'ip4addr',
			optional: true
		});

		s.option(L.cbi.InputValue, 'ipv4netmask', {
			caption: L.tr('IPV4 Netmask'),
			datatype: 'netmask4',
			optional: true,
		});


		s.option(L.cbi.InputValue, 'from', {
			caption: L.tr('From'),
			datatype: 'ip4addr',
			optional: true,
		});

		s.option(L.cbi.InputValue, 'priority', {
			caption: L.tr('Priority'),
			optional: 'true'
		});

		s.option(L.cbi.CheckboxValue, 'enable_iif', {
			caption: L.tr('Enable IIF'),
		});

		s.option(L.cbi.Ifname_List, 'interface_iif', {
			caption: L.tr('Interface'),
			optional: true
		}).depends({ 'enable_iif': "1" });

		s.option(L.cbi.CheckboxValue, 'enable_oif', {
			caption: L.tr('Enable OIF'),
		});

		s.option(L.cbi.Ifname_List, 'interface_oif', {
			caption: L.tr('Interface'),
			optional: true
		}).depends({ 'enable_oif': "1" });

		s.option(L.cbi.CheckboxValue, 'enable_fwmark', {
			caption: L.tr('Enable fwmark'),
		});

		s.option(L.cbi.InputValue, 'Hex_fwmark', {
			caption: L.tr('Interface'),
			datatype: 'rt_hexadecimal',
			optional: true
		}).depends({ 'enable_fwmark': "1" });

	},

	AsrRenderContents: function (rv) {
		var self = this;

		var list = new L.ui.table({
			columns: [{
				caption: L.tr('Rule Type'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'AsrInterface_%s'.format(n));
					return div.append('<strong>' + v + '</strong>');
				}
			}, {
				caption: L.tr('Table ID'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'AsrTable_%s'.format(n));
					return div.append(v);
				}
			},
			{
				caption: L.tr('Target(To)'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'AsrTo_%s'.format(n));
					return div.append(v);
				}
			}, {
				caption: L.tr('IPV4 Netmask'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'AsrIPV4Netmask_%s'.format(n));
					return div.append(v);
				}
			}, {
				caption: L.tr('From'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'AsrFrom_%s'.format(n));
					return div.append(v);
				}
			}, {
				caption: L.tr('Priority'),
				format: function (v, n) {
					var div = $('<p />').attr('id', 'AsrPriority_%s'.format(n));
					return div.append(v);
				}
			}, {
				caption: L.tr('Actions'),
				format: function (v, n) {
					return $('<div />')
						.addClass('btn-group btn-group-sm')
						.append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Edit Custom Tables Rules'))
							.click({ self: self, fSectionID: v, fSectionType: "Sroutes" }, self.fSectionEdit))
						.append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Custom Tables Rules'))
							.click({ self: self, AsrSectionID: v }, self.AsrSectionRemove));
				}
			}]
		});

		for (var key in rv) {
			if (rv.hasOwnProperty(key)) {
				var obj = rv[key];
				var Ruletype = obj.ruletype
				var Sourceto = obj.to
				var Sourcenetmask = obj.ipv4netmask
				var Sourcetable = obj.table
				var Sourcefrom = obj.from
				var Sourcepriority = obj.priority

				list.row([Ruletype, Sourcetable, Sourceto, Sourcenetmask, Sourcefrom, Sourcepriority, key]);
			}
		}


		$('#section_advancedstaticroutes_Asr').append(list.render());

	},

	AsrSectionRemove: function (ev) {
		var self = ev.data.self;

		var AsrSectionID = ev.data.AsrSectionID;

		self.deleteroutingconfig('Delete').then(function (rv) {


			self.fDeleteUCISection("routingconfig", "rule", AsrSectionID).then(function (rv) {
				if (rv == 0) {
					self.fCommitUCISection("routingconfig").then(function (res) {

						if (res != 0) {
							alert("Error: Delete Advanced Static Routes Configuration");
						}
						else {
							document.cookie="LastActiveTab=TabAsr";
							document.cookie="LastAction=delete";
							location.reload();
						}
						//});
					});
				};
			});
		});

	},



	AsrSectionAdd: function () {
		var self = this;
		var Asrruletype = $('#section_advancedstaticroutes_Asr_ruletype').val();
		var AsrTo = $('#section_advancedstaticroutes_Asr_to').val();
		var AsrIPV4Netmask = $('#section_advancedstaticroutes_Asr_ipv4netmask').val();
		var AsrTable = $('#section_advancedstaticroutes_Asr_table').val();
		var AsrFrom = $('#section_advancedstaticroutes_Asr_from').val();
		var AsrPriority = $('#section_advancedstaticroutes_Asr_priority').val();
		var AsrTocheck = false;


		if (AsrTable === "custom") {
			AsrTable = $('#section_advancedstaticroutes_Asr_table1').val();
		}


		// Regular expression pattern for IPv4 validation
		var ipv4Pattern = /^(\d{1,3}\.){3}\d{1,3}$/;

		// Check if the input matches the IPv4 pattern
		if (ipv4Pattern.test(AsrTo)) {
			AsrTocheck = true; // Valid IPv4 address
		}

		var SectionOptions = { to: AsrTo, ipv4netmask: AsrIPV4Netmask, ruletype: Asrruletype, from: AsrFrom, table: AsrTable, from: AsrFrom, priority: AsrPriority };
		self.fCreateUCISection("routingconfig", "rule", SectionOptions).then(function (rv) {
			if (rv) {
				if (rv.section) {
					self.fCommitUCISection("routingconfig").then(function (res) {
						if (res != 0) {
							alert("Error:New Advanced Static Routes Configuration");
						}
						else {
							document.cookie="LastActiveTab=TabAsr";
							document.cookie="LastAction=add";
							location.reload();
						}
					});

				};
			};
		});


	},

	// AsrttCreateFormCallback: function () {
	// 	var map = this;
	// 	var AsrttSectionID = map.options.fSection;

	// 	map.options.caption = L.tr('Port Forward Configuration');

	// 	var s = map.section(L.cbi.NamedSection, AsrttSectionID, {
	// 		collabsible: true,
	// 		anonymous: true,
	// 		tabbed: true
	// 	});

	// 	s.option(L.cbi.ComboBox, 'interface', {
	// 		caption: L.tr('Interface'),
	// 		optional: 'true'
	// 	}).value("eth0", L.tr('eth0'))
	// 		.value("eth0.1", L.tr('eth0.1'))
	// 		.value("eth0.5", L.tr('eth0.5'))
	// 		.value("lo", L.tr('lo'))
	// 		.value("ra0", L.tr('ra0'))
	// 		.value("ra1", L.tr('ra1'))
	// 		.value("usb0", L.tr('usb0'))
	// 		.value("wwan0", L.tr('wwan0'));


	// 	s.option(L.cbi.InputValue, 'target', {
	// 		caption: L.tr('Target'),
	// 		datatype: 'ip4addr',
	// 		optional: true
	// 	});

	// 	s.option(L.cbi.InputValue, 'ipv4netmask', {
	// 		caption: L.tr('IPV4 Netmask'),
	// 		datatype: 'netmask4',
	// 		optional: true,
	// 	});


	// 	s.option(L.cbi.InputValue, 'metric', {
	// 		caption: L.tr('Metric'),
	// 		placeholder: "0",
	// 		datatype: 'uinteger',
	// 		optional: true,

	// 	});

	// 	s.option(L.cbi.InputValue, 'ipv4gateway', {
	// 		caption: L.tr('IPV4 Gateway'),
	// 		datatype: 'ip4addr',
	// 		optional: true,
	// 	});

	// 	s.option(L.cbi.InputValue, 'tableid', {
	// 		caption: L.tr('Table ID'),
	// 		optional: 'true'
	// 	});



	// },


	// AsrttRenderContents: function (rv) {
	// 	var self = this;

	// 	var list = new L.ui.table({
	// 		columns: [{
	// 			caption: L.tr('Interface'),
	// 			format: function (v, n) {
	// 				var div = $('<p />').attr('id', 'srInterface_%s'.format(n));
	// 				return div.append('<strong>' + v + '</strong>');
	// 			}
	// 		}, {
	// 			caption: L.tr('Target'),
	// 			format: function (v, n) {
	// 				var div = $('<p />').attr('id', 'sAsrttarget_%s'.format(n));
	// 				return div.append(v);
	// 			}
	// 		}, {
	// 			caption: L.tr('IPV4 Netmask'),
	// 			format: function (v, n) {
	// 				var div = $('<p />').attr('id', 'srIPV4Netmask_%s'.format(n));
	// 				return div.append(v);
	// 			}
	// 		}, {
	// 			caption: L.tr('Metric'),
	// 			format: function (v, n) {
	// 				var div = $('<p />').attr('id', 'srMetric_%s'.format(n));
	// 				return div.append(v);
	// 			}
	// 		}, {
	// 			caption: L.tr('IPV4 Gateway'),
	// 			format: function (v, n) {
	// 				var div = $('<p />').attr('id', 'srIPV4Gateway_%s'.format(n));
	// 				return div.append(v);
	// 			}
	// 		},
	// 		{
	// 			caption: L.tr('Table ID'),
	// 			format: function (v, n) {
	// 				var div = $('<p />').attr('id', 'srIPV4Gateway_%s'.format(n));
	// 				return div.append(v);
	// 			}
	// 		},

	// 		{
	// 			caption: L.tr('Actions'),
	// 			format: function (v, n) {
	// 				return $('<div />')
	// 					.addClass('btn-group btn-group-sm')
	// 					.append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Edit Static Routes'))
	// 						.click({ self: self, fSectionID: v, fSectionType: "Rroutes" }, self.fSectionEdit))
	// 					.append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Static Routes'))
	// 						.click({ self: self, AsrttSectionID: v }, self.AsrttSectionRemove));
	// 			}
	// 		}]
	// 	});

	// 	for (var key in rv) {
	// 		if (rv.hasOwnProperty(key)) {
	// 			var obj = rv[key];
	// 			var Sourcemap = obj.interface
	// 			var SourceIP = obj.target;
	// 			var SourceNetmask = obj.ipv4netmask
	// 			var Sourcemetric = obj.metric
	// 			var Sourcegateway = obj.ipv4gateway
	// 			var TableID = obj.tableid

	// 			list.row([Sourcemap, SourceIP, SourceNetmask, Sourcemetric, Sourcegateway, TableID, key]);
	// 		}
	// 	}


	// 	$('#section_routingtable_portAsrtt').append(list.render());

	// },


	// AsrttSectionRemove: function (ev) {
	// 	var self = ev.data.self;
	// 	var AsrttSectionID = ev.data.AsrttSectionID;

	// 	self.deleteroutingconfig('delete').then(function (rv) {
	// 		self.fDeleteUCISection("routingconfig", "route", AsrttSectionID).then(function (rv) {
	// 			if (rv == 0) {
	// 				self.fCommitUCISection("routingconfig").then(function (res) {
	// 					if (res != 0) {
	// 						alert("Error: Delete Static Routes Configuration");
	// 					}
	// 					else {
	// 						document.cookie="LastActiveTab=TabAsrtt";
	// 					    document.cookie="LastAction=delete";
	// 						location.reload();
	// 					}
	// 				});
	// 			};
	// 		});
	// 	});

	// },



	// AsrttSectionAdd: function () {
	// 	var self = this;
	// 	var AsrttInterface = $('#field_Advancedroutes_routes_newRoutes_interface').val();
	// 	var AsrttTarget = $('#field_Advancedroutes_routes_newRoutes_target').val();
	// 	var AsrttIPV4Netmask = $('#field_Advancedroutes_routes_newRoutes_ipv4netmask').val();
	// 	var AsrttMetric = $('#field_Advancedroutes_routes_newRoutes_metric').val();
	// 	var AsrttIPV4Gateway = $('#field_Advancedroutes_routes_newRoutes_ipv4gateway').val();
	// 	var Asrtttableid = $('#field_Advancedroutes_routes_newRoutes_tableid').val();
	// 	var AsrttTargetcheck = false;

	// 	if (AsrttInterface === "custom") {
	// 		AsrttInterface = $('#field_Advancedroutes_routes_newRoutes_inter').val();
	// 	}

	// 	// if (AsrttRoutetype === "custom")
	// 	// {
	// 	// 	AsrttRoutetype = $('#field_Advancedroutes_routes_newRoutes_routetype1').val();
	// 	// }
	// 	// Regular expression pattern for IPv4 validation
	// 	var ipv4Pattern = /^(\d{1,3}\.){3}\d{1,3}$/;

	// 	// Check if the input matches the IPv4 pattern
	// 	if (ipv4Pattern.test(AsrttTarget)) {
	// 		AsrttTargetcheck = true; // Valid IPv4 address
	// 	}

	// 	var SectionOptions = { interface: AsrttInterface, target: AsrttTarget, ipv4netmask: AsrttIPV4Netmask, metric: AsrttMetric, ipv4gateway: AsrttIPV4Gateway, tableid: Asrtttableid };
	// 	self.fCreateUCISection("routingconfig", "route", SectionOptions).then(function (rv) {
	// 		if (rv) {
	// 			if (rv.section) {
	// 				self.fCommitUCISection("routingconfig").then(function (res) {
	// 					if (res != 0) {
	// 						alert("Error: New Advanced Routes Configuration");
	// 					}
	// 					else {
	// 						document.cookie="LastActiveTab=TabAsrtt";
	// 						document.cookie="LastAction=add";
	// 						location.reload();
	// 					}
	// 				});

	// 			};
	// 		};
	// 	});

	// },



	getCookie: function (cname) {
		var name = cname + "=";
		var ca = document.cookie.split(';');

		for (var i = 0; i < ca.length; i++) {
			var c = ca[i];

			while (c.charAt(0) == ' ')
				c = c.substring(1);
			if (c.indexOf(name) == 0)
				return c.substring(name.length, c.length);
		}
		return "";
	},

	execute: function () {
		var self = this;
		var activeTab = self.getCookie("LastActiveTab");
		var action = self.getCookie("LastAction");
		if (action) {
			$('.TabC').removeClass('active');
			$('.' + activeTab).addClass('active');
			document.cookie = "LastAction=";
		}
		else {
			$('.TabC').removeClass('active');
			$('.Tabsr').addClass('active');
		}
		this.fGetUCISections("routingconfig", "routes").then(function (rv) {
			self.srRenderContents(rv);
		});
		this.fGetUCISections("routingconfig", "rule").then(function (rv) {
			self.AsrRenderContents(rv);
		});
		this.fGetUCISections("routingconfig", "route").then(function (rv) {
			self.AsrttRenderContents(rv);
		});
		// this.fGetUCISections("routingconfig","table").then(function(rv) {
		// 	self.AsrtRenderContents(rv);   
		// });



		$('#AddNewStaticRoutes').click(function () {
			self.srSectionAdd();
		});

		$('#AddNewAdvancedstaticRule').click(function () {
			self.AsrSectionAdd();
		});

		$('#AddNew_AsrttStaticRoutes').click(function () {
			self.AsrttSectionAdd();
		});

		// $('#AddNewAdvancedstatictable').click(function() {          
		// 	self.AsrtSectionAdd();
		// });



		$('#btn_update').click(function () {
			L.ui.loading(true);
			self.updateroutingconfig('configure').then(function (rv) {
				L.ui.loading(false);
				L.ui.dialog(
					L.tr('Updated routing configuration'), [
					$('<pre />')
						.addClass('alert alert-success')
						.text(rv)
				],
					{ style: 'close' }
				);

			});

		});
	}
});
