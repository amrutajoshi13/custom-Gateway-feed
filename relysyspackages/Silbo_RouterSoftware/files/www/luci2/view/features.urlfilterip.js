L.ui.view.extend({
        title: L.tr('URL Filtering Configuration'),
        description: L.tr(''),

        RS485GetUCISections: L.rpc.declare({
                object: 'uci',
                method: 'get',
                params: ['config', 'type'],
                expect: { values: {} }
        }),

        ModechangeCreateUCISection: L.rpc.declare({
                object: 'uci',
                method: 'add',
                params: ['config', 'type', 'name', 'values']
        }),


        RS485CreateUCISection: L.rpc.declare({
                object: 'uci',
                method: 'add',
                params: ['config', 'type', 'values']
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

        updatefirewallconfig: L.rpc.declare({
                object: 'rpc-updateurlconfig',
                method: 'configure',
                expect: { output: '' }
        }),

        TestArchive: L.rpc.declare({
                object: 'rpc-updateurlconfig',
                method: 'testarchive',
                params: ['archive'],
        }),

        handleArchiveUpload: function () {
                var self = this;
                L.ui.archiveUpload(
                        L.tr('Archive Upload'),
                        L.tr('Select the archive and click on "%c" button to proceed.').format(L.tr('Apply')), {
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

        RS485FormCallback: function () {
                var map = this;
                var RS485ConfigSectionName = map.options.RS485ConfigSection;
                var numericExpression = /^[0-9]+$/;

                map.options.caption = L.tr(RS485ConfigSectionName + ' Configuration');

                var s = map.section(L.cbi.NamedSection, RS485ConfigSectionName, {

                        collabsible: true
                });
                console.log(RS485ConfigSectionName)
                s.option(L.cbi.CheckboxValue, 'Enable', {
                        caption: L.tr('Enable/Disable')
                })

                s.option(L.cbi.InputValue, 'RS485ConfigSectionName', {

                        caption: L.tr('Url Blocking'),
                        datatype: 'url',
                }).depends({ 'Enable': '1' });

        },

        RS485RenderContents: function (rv) {
                var self = this;
                configdata = function () {
                        return rv;
                }
                var list = new L.ui.table({
                        columns: [{
                                caption: L.tr('Sl No'),
                                align: 'center',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'remoteserverIP%s'.format(n));
                                        var serialNo = n + 1;
                                        return div.append(serialNo);
                                }
                        },

                        {
                                caption: L.tr('Url Blocking'),
                                width: '30%',
                                align: 'center',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'remoteserverIP%s'.format(n));
                                        return div.append(v);

                                }
                        },
                        {
                                caption: L.tr('Mode'),
                                width: '30%',
                                align: 'center',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'remoteserverIP%s'.format(n));
                                        return div.append(v);
                                }
                        },
                        {
                                caption: L.tr('Status'),
                                width: '30%',
                                align: 'center',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'remoteserverIP%s'.format(n));
                                        return div.append(v);
                                }
                        },
                        {
                                caption: L.tr('Update'),
                                align: 'center',
                                format: function (v, n) {
                                        return $('<div />')
                                                .addClass('btn-group btn-group-sm')
                                                .append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Configure'))
                                                        .click({ self: self, RS485ConfigSectionName: v }, self.RS485ConfigSectionEdit))
                                                .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                                        .click({ self: self, RS485ConfigSectionName: v }, self.RS485ConfigSectionRemove));

                                }
                        }]
                });
                for (var key in rv) {
                        if (rv.hasOwnProperty(key)) {
                                var obj = rv[key];
                                console.log(obj);
                                var RS485ConfigSectionName = obj.RS485ConfigSectionName
                                // RS485ConfigSectionName = RS485ConfigSectionName.replaceAll("/", "")
                                var status = obj.UrlfilteringSwitch;
                                var Accesspolicy = obj.Accesspolicy;
                                if (status == "1") {
                                        status = "Enabled"
                                }
                                else {
                                        status = "Disabled"
                                }
                                list.row([key, RS485ConfigSectionName, Accesspolicy, status, key]);


                        }
                }
                $('#section_vpn_ipsec').append(list.render());
        },

        RS485ConfigSectionAdd: function (id) {
                var self = this;
                var UrlfilteringSwitch = $('#UrlfilteringSwitch')[0].checked;
                var RS485ConfigSectionName = $('#UrlBlocking').val();
                // RS485ConfigSectionName = RS485ConfigSectionName.replaceAll("/", "")
                // RS485ConfigSectionName = "/" + RS485ConfigSectionName + "/";
                var Accesspolicy = $('#Accesspolicy1').val();

                // if (UrlfilteringSwitch == 1) {
                //         var Accesspolicy = $('#Accesspolicy1').val();
                // }
                // else {
                //         var Accesspolicy = "Disable";
                // }
                var sensorSectionOptions = { EEnable: 0, UrlfilteringSwitch: UrlfilteringSwitch, Accesspolicy: Accesspolicy, RS485ConfigSectionName: RS485ConfigSectionName };

                this.RS485GetUCISections("urlipconfig", "urlipconfig").then(function (rv) {
                        var keys = Object.keys(rv);
                        var uniquedevicename = [];

                        for (var key in rv) {
                                var obj = rv[key];
                                uniquedevicename.push(obj.RS485ConfigSectionName)
                        }
                        var keysLength = keys.length;
                        if (id != "") {
                                console.log(id);

                        }
                        if (keysLength >= 100) {
                                alert("Only 100 connections can be configured");
                        }
                        else {
                                if (id != "") {
                                        var editfields = rv[id]
                                        var key = editfields.RS485ConfigSectionName;
                                        console.log(key);
                                        self.RS485DeleteUCISection("urlipconfig", "urlipconfig", id).then(function (rv) {
                                                if (rv == 0) {
                                                        self.RS485CommitUCISection("urlipconfig").then(function (res) {
                                                                if (res != 0) {
                                                                        alert("Error: Delete Configuration");
                                                                }
                                                                else {
                                                                        location.reload();
                                                                }
                                                        });
                                                };
                                        });
                                        self.RS485CreateUCISection("urlipconfig", "urlipconfig", sensorSectionOptions).then(function (rv) {
                                                if (rv) {
                                                        if (rv.section) {
                                                                self.RS485CommitUCISection("urlipconfig").then(function (res) {

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
                                // else {
                                //         debugger;
                                //         let uniquekey = uniquedevicename.includes(RS485ConfigSectionName)
                                //         if (uniquekey) {
                                //                 alert("Url Already Exists Please Enter different url")
                                //         }
                                else {
                                        self.RS485CreateUCISection("urlipconfig", "urlipconfig", sensorSectionOptions).then(function (rv) {
                                                if (rv) {
                                                        if (rv.section) {
                                                                self.RS485CommitUCISection("urlipconfig").then(function (res) {

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
                                console.log(uniquekey);

                                //  }
                        }
                });
        },

        ModeConfigSectionAdd1: function (id) {
                var self = this;
                var Accesspolicy = $('#Accesspolicy1').val();
                //var UrlfilteringSwitch = 1;
                alert(Accesspolicy + '_Updated Succesfully')
                var sensorSectionOptions = { EEnable: 1, Accesspolicy: Accesspolicy };

                // this.MACFilteringUCISections("vpnconfog1","MACFilteringConfig").then(function(rv) {
                this.RS485GetUCISections("urlipconfig", "urlipconfig").then(function (rv) {

                        var keys = Object.keys(rv);
                        for (var key in rv) {
                                self.ModechangeCreateUCISection("urlipconfig", "urlipconfig", key, sensorSectionOptions).then(function (rv) {
                                        if (rv) {
                                                if (rv.section) {
                                                        self.RS485CommitUCISection("urlipconfig").then(function (res) {

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
                        // }


                });
                this.RS485GetUCISections("urlipconfig", "Mode").then(function (rv) {

                        var keys = Object.keys(rv);
                        for (var key in rv) {
                                self.ModechangeCreateUCISection("urlipconfig", "Mode", key, sensorSectionOptions).then(function (rv) {
                                        if (rv) {
                                                if (rv.section) {
                                                        self.RS485CommitUCISection("urlipconfig").then(function (res) {

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
                        // }


                });
        },

        RS485ConfigSectionRemove: function (ev) {
                debugger;
                var self = ev.data.self;
                var RS485ConfigSectionName = ev.data.RS485ConfigSectionName;
                self.RS485DeleteUCISection("urlipconfig", "urlipconfig", RS485ConfigSectionName).then(function (rv) {
                        if (rv == 0) {
                                self.RS485CommitUCISection("urlipconfig").then(function (res) {
                                        if (res != 0) {
                                                alert("Error: Delete Configuration");
                                        }
                                        else {
                                                location.reload();
                                        }
                                });
                        };
                });
        },

        RS485ConfigSectionEdit: function (ev) {
                $("#Applyconfig").css("display", "none")
                $("#editconfig").css("display", "inline")
                console.log(ev);
                var key = ev.data.RS485ConfigSectionName;
                editkey = function () {
                        return key;
                }
                var porteditdata = configdata();
                var editfields = porteditdata[key];
                console.log(editfields);

                var status = editfields.UrlfilteringSwitch
                if (status == "1") {
                        status = true;
                }
                else {
                        status = false;
                }
                var urlfiltering = editfields.RS485ConfigSectionName
                urlfiltering = urlfiltering.replaceAll("/", "")
                $('#UrlBlocking').val(urlfiltering);
                document.getElementById("UrlfilteringSwitch").checked = status;
                $("#exampleModal").modal('show');
        },

        execute: function () {
                $('#addnew').click(function () {
                        $('#UrlBlocking').val("");
                        document.getElementById("UrlfilteringSwitch").checked = true;
                });
                $("#editconfig").css("display", "none")
                $("#Applyconfig").css("display", "inline")
                var self = this;

                var m = new L.cbi.Map('urlipconfig', {
                });

                var s = m.section(L.cbi.NamedSection, 'general', {
                        caption: L.tr('General Configurations')
                });


                var m1 = new L.cbi.Map('urlipconfig', {
                });

                var self = this;
                $('#Applyconfig').click(function () {
                        var res = "";
                        debugger

                        var url = document.getElementById("UrlBlocking").value;
                        var validationResult = document.getElementById("validationResult");

                        // if (
                        //         url.match(
                        //                 /([w]{3}\.)[-a-zA-Z0-9@:%.\+#=]{2,256}\.[a-z]{2,3}\b([-a-zA-Z0-9@:%\+.#?&=]*)/g
                        //         )
                        // ) {

                        self.RS485ConfigSectionAdd("");
                        // } else {
                        //         console.log("Invalid");
                        //         res = "Must be a valid url";
                        // }
                        validationResult.innerHTML = res;




                });
                $('#editconfig').click(function () {
                        var res = "";
                        debugger

                        var url = document.getElementById("UrlBlocking").value;
                        var validationResult = document.getElementById("validationResult");

                        // if (
                        //         url.match(
                        //                 /([w]{3}\.)[-a-zA-Z0-9@:%.\+#=]{2,256}\.[a-z]{2,3}\b([-a-zA-Z0-9@:%\+.#?&=]*)/g
                        //         )
                        // ) {
                        var key = editkey()

                        self.RS485ConfigSectionAdd(key);
                        // } else {
                        //         console.log("Invalid");
                        //         res = "Must be a valid url";
                        // }
                        validationResult.innerHTML = res;
                });
                self.RS485GetUCISections("urlipconfig", "urlipconfig").then(function (rv) {
                        self.RS485RenderContents(rv);
                });

                $('#update_ipsec').click(function () {
                        L.ui.loading(true);
                        self.updatefirewallconfig('configure').then(function (rv) {
                                L.ui.dialog(
                                        L.tr('update configuration'), [
                                        $('<pre />')
                                                .addClass('alert alert-success')
                                                .text(rv)
                                ],
                                        {
                                                style: 'close',
                                                buttons: [
                                                        {
                                                                text: 'Close',
                                                                click: function () {
                                                                        $(this).dialog('close');
                                                                        location.reload(true);  // Reload the page when the dialog is closed
                                                                }
                                                        }
                                                ],
                                                close: function () {
                                                        location.reload(true);  // Ensure page reloads if the dialog is closed in any way
                                                }
                                        }
                                );
                                L.ui.loading(false);
                        });
                });
                //URL List    
                $('#btn_upload').click(function () {


                        self.handleArchiveUpload();

                });


                $('#ChangeMode1').click(function () {
                        self.ModeConfigSectionAdd1(1);
                })

                s.commit = function () {

                        self.updateopenvpnconfig('enableopenvpn').then(function (rv) {

                        });
                }
        }
});


