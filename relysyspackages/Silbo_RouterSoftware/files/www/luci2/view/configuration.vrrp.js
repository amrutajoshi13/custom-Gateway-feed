L.ui.view.extend({
        title: L.tr('VRRP Configuration'),
        description: L.tr(''),

        RS485GetUCISections: L.rpc.declare({
                object: 'uci',
                method: 'get',
                params: ['config', 'type'],
                expect: { values: {} }
        }),

        RS485CreateUCISection: L.rpc.declare({
                object: 'uci',
                method: 'add',
                params: ['config', 'type', 'name', 'values']
        }),

        RS485CommitUCISection: L.rpc.declare({
                object: 'uci',
                method: 'commit',
                params: ['config']
        }),

        RS485DeleteUCISection: L.rpc.declare({
                object: 'uci',
                method: 'delete',
                params: ['config', 'type', 'section']
        }),

        updatevrrpd: L.rpc.declare({
                object: 'rpc-updatevrrpdconfig',
                method: 'configure',
                expect: { output: '' }
        }),

        deletevrrpd: L.rpc.declare({
                object: 'rpc-updatevrrpdconfig',
                method: 'delete',
                expect: { output: '' }
        }),

        vrrpdFormCallback: function () {
                var map = this;
                var vrrpdSectionName = map.options.vrrpdSection;
                var numericExpression = /^[0-9]+$/;

                map.options.caption = L.tr(vrrpdSectionName + ' Configuration');

                var s = map.section(L.cbi.NamedSection, vrrpdSectionName, {
                        collabsible: true
                });



                s.option(L.cbi.DummyValue, 'typesettings', {
                        caption: L.tr(''),
                })
                        .ucivalue = function () {
                                var id = "<h5><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspVRRP Configuration settings </b> </h3>";
                                return id;
                        };

                // s.option(L.cbi.InputValue, 'name', {
                //         caption: L.tr('Tunnel name'),
                //         datatype: 'rt_alphanumeric',
                // });

                s.option(L.cbi.ListValue, 'state', {
                        caption: L.tr('Role'),
                }).value("none", L.tr('Please choose'))
                        .value("MASTER", L.tr('Master'))
                        .value("BACKUP", L.tr('Backup'));

                s.option(L.cbi.InputValue, 'virtual_router_id', {
                        caption: L.tr('Virtual ID'),
                        placeholder: "0",
                        datatype: 'uinteger',
                        optional: true,
                });
                s.option(L.cbi.InputValue, 'priority', {
                        caption: L.tr('Priority'),
                        description: L.tr('The priority should always be higher for the Master and lower for the Backup.'),
                        placeholder: "100",
                        datatype: 'uinteger',
                        optional: true,
                });
                s.option(L.cbi.lanInterfaceList, 'interface', {
                        caption: L.tr('Interface'),
                        optional: true
                });

                s.option(L.cbi.InputValue, 'unicast_src_ip', {
                        caption: L.tr('Source IP'),
                        placeholder: "0.0.0.0",
                        datatype: 'ip4addr',
                        optional: true,
                });
                s.option(L.cbi.InputValue, 'unicast_peer', {
                        caption: L.tr('Peer IP'),
                        placeholder: "0.0.0.0",
                        datatype: 'ip4addr',
                        optional: true,
                });


                s.option(L.cbi.InputValue, 'virtual_ipaddress', {
                        caption: L.tr('Virtual IP address'),
                        placeholder: "192.168.10.100/24",
                        datatype: 'cidr4',
                        optional: true,

                });

                s.option(L.cbi.CheckboxValue, 'authentication', {
                        caption: L.tr('Enable Authentication'),
                        optional: true
                });

                s.option(L.cbi.PasswordValue, 'password', {
                        caption: L.tr('Password'),
                        placeholder: "*******",
                        optional: true,
                }).depends({
                        'authentication': '1',
                });

                // s.option(L.cbi.lanInterfaceList, 'track_interface', {
                //         caption: L.tr('Track Interface'),
                //         optional: true
                // });




        },

        vrrpdCreateForm: function (mapwidget, vrrpdSectionName) {
                var self = this;

                if (!mapwidget)
                        mapwidget = L.cbi.Map;

                var map = new mapwidget('vrrpd', {
                        prepare: self.vrrpdFormCallback,
                        vrrpdSection: vrrpdSectionName
                });
                return map;
        },

        vrrpdRenderContents: function (rv) {
                configdata6 = function () {
                        return rv;
                }

                var self = this;

                var list = new L.ui.table({
                        columns: [
                                {
                                        caption: L.tr('Instance Name'),
                                        // width: '30%',
                                        align: 'left',
                                        format: function (v, n) {
                                                var div = $('<p />').attr('id', 'vrrpdDeviceEventName_%s'.format(n));
                                                return div.append('<strong>' + v + '</strong>');
                                        }
                                },
                                {
                                        caption: L.tr('Role'),
                                        width: '20%',
                                        align: 'left',
                                        format: function (v, n) {
                                                var div = $('<p />').attr('id', 'vrrpdDeviceEventName_%s'.format(n));
                                                return div.append(v);
                                        }
                                },
                                {
                                        caption: L.tr('VRRP Details'),
                                        // width: '24%',
                                        align: 'left',
                                        format: function (v, n) {
                                                var div = $('<p />').attr('id', 'vrrpdDeviceEventName_%s'.format(n));
                                                return div.append(v);
                                        }
                                },
                                {
                                        caption: L.tr('Enable/Disable'),
                                        // width: '14%',
                                        align: 'center',
                                        format: function (v, n) {

                                                console.log(this.Enabled)
                                                var div = $('<label />').attr('id', 'vrrpdConfig_%s'.format(n)).attr('class', 'switch');
                                                return div.append(`<input type="checkbox" ${v}   id="vrrpdforwardingstatusSwitch${n}" onclick="vrrpdenablebutton(${n})">
          <span class="slider round"></span>`);

                                        }

                                },
                                {
                                        caption: L.tr('Update'),
                                        align: 'center',
                                        format: function (v, n) {
                                                return $('<div />')
                                                        .addClass('btn-group btn-group-sm')
                                                        .append(L.ui.button(L.tr('Edit'), 'primary', L.tr('edit configuration'))
                                                                .click({ self: self, vrrpdSectionName: v }, self.vrrpdSectionEdit))
                                                        .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('delete configuration'))
                                                                .click({ self: self, vrrpdSectionName: v }, self.vrrpdSectionRemove));

                                        }
                                }]
                });
                for (var key in rv) {
                        if (rv.hasOwnProperty(key)) {
                                var obj = rv[key];
                                var Name = obj.name;
                                var Enable = obj.enable;
                                var R1 = obj.virtual_router_id !== undefined ? obj.virtual_router_id : '-';
                                var R2 = obj.priority !== undefined ? obj.priority : '-';
                                // Ensure Master has an uppercase M and Backup has an uppercase B
                                var Role = obj.state !== undefined ? obj.state.toLowerCase() : '-';
                                if (Role === "master") {
                                        Role = "Master";
                                } else if (Role === "backup") {
                                        Role = "Backup";
                                }
                                // Handle virtual IP addresses
                                var virtualIPAddresses = obj.virtual_ipaddress;
                                var virtualIPList = "";
                                if (Array.isArray(virtualIPAddresses)) {
                                        virtualIPList = virtualIPAddresses.join(', ');
                                } else {
                                        virtualIPList = virtualIPAddresses !== undefined ? virtualIPAddresses : '-';
                                }

                                vrrp = "<b>Virtual ID:</b> " + R1 + "<br />" + "<b>Priority:</b> " + R2 + "<br />" + "<b>Virtual IP:</b> " + virtualIPList;

                                if (Enable == "1") {
                                        Enable = "checked";
                                } else {
                                        Enable = "";
                                }
                                list.row([Name, Role, vrrp, Enable, key]);
                        }
                }

                $('#section_vpn_ipsec').append(list.render());


        },

        vrrpdSectionAdd: function () {
                debugger
                var self = this;
                var vrrpdSectionName = $('#field_NewEvent_name').val();
                var vrrpdSection = { name: vrrpdSectionName, enable: '1' };

                this.RS485GetUCISections("vrrpd", "vrrpd", vrrpdSectionName, vrrpdSection).then(function (rv) {
                        var keys = Object.keys(rv);
                        var keysLength = keys.length;
                        if (keysLength >= 1) {
                                alert("Only 1 connections can be configured");
                        }
                        else {
                                self.RS485CreateUCISection("vrrpd", "vrrpd", vrrpdSectionName, vrrpdSection).then(function (rv) {
                                        if (rv) {
                                                if (rv.section) {
                                                        self.RS485CommitUCISection("vrrpd").then(function (res) {
                                                                if (res != 0) {
                                                                        alert("Error:New Event Configuration");
                                                                }
                                                                else {
                                                                        location.reload();
                                                                }
                                                        });
                                                };
                                        };
                                });
                        }
                });
        },


        vrrpdSectionRemove: function (ev) {
                var self = ev.data.self;
                var vrrpdSectionName = ev.data.vrrpdSectionName;
                // self.deletevrrpd('delete').then(function (rv) {
                self.RS485DeleteUCISection("vrrpd", "vrrpd", vrrpdSectionName).then(function (rv) {
                        if (rv == 0) {
                                self.RS485CommitUCISection("vrrpd").then(function (res) {
                                        if (res != 0) {
                                                alert("Error: Delete Configuration");
                                        }
                                        else {
                                                location.reload();
                                        }
                                });
                        };
                });
                //});
        },

        vrrpdSectionEdit: function (ev) {
                var self = ev.data.self;
                var vrrpdSectionName = ev.data.vrrpdSectionName;
                return self.vrrpdCreateForm(L.cbi.Modal, vrrpdSectionName).show();
        },


        execute: function () {
                var self = this;

                var m = new L.cbi.Map('vrrpd', {
                });

                var s = m.section(L.cbi.NamedSection, 'general', {
                        caption: L.tr('General Configurations')
                });


                s.option(L.cbi.CheckboxValue, 'enablevrrpd', {
                        caption: L.tr('Enable VRRP'),
                        optional: true
                });

                //s.option(L.cbi.CheckboxValue, 'enableipip', {
                //caption: L.tr('Enable IPIP Tunnel'),         
                //optional: true
                //}); 

                m.insertInto('#section_vpn_general');

                var self = this;
                //vrrpd
                $('#AddNewconnectionipsec').click(function () {
                        self.vrrpdSectionAdd();
                });
                self.RS485GetUCISections("vrrpd", "vrrpd").then(function (rv) {
                        self.vrrpdRenderContents(rv);
                });


                $('#update_tunnel').click(function () {
                        L.ui.loading(true);
                        self.updatevrrpd('configure').then(function (rv) {
                                L.ui.dialog(
                                        L.tr('update configuration'), [
                                        $('<pre />')
                                                .addClass('alert alert-success')
                                                .text(rv)
                                ],
                                        { style: 'close' }
                                );
                        });
                        L.ui.loading(false);
                });
                vrrpdenablebutton = function (n) {
                        var checkbox = $("#vrrpdforwardingstatusSwitch" + n)[0].checked
                        var porteditdata = configdata6();

                        var portName = Object.keys(porteditdata)[n]
                        console.log(portName)

                        var sensorSectionOptions = { enable: "0" };
                        console.log(checkbox);
                        if (checkbox) {
                                document.getElementById("vrrpdforwardingstatusSwitch" + n).checked = true;
                                sensorSectionOptions = { enable: "1" };

                        }
                        else {
                                document.getElementById("vrrpdforwardingstatusSwitch" + n).checked = false;
                                sensorSectionOptions = { enable: "0" };

                        }
                        self.RS485CreateUCISection("vrrpd", "vrrpd", portName, sensorSectionOptions).then(function (rv) {
                                if (rv) {
                                        if (rv.section) {
                                                self.RS485CommitUCISection("vrrpd").then(function (res) {
                                                        if (res != 0) {
                                                                alert("Error:New Event Configuration");
                                                        }
                                                        else {
                                                                location.reload();
                                                        }
                                                });
                                        };
                                };
                        });
                }

        }
});


