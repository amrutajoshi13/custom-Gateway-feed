	L.ui.view.extend({
        title: L.tr('Wireless Mac id Filtering'),
        description: L.tr(''),

        MACFilteringUCISections: L.rpc.declare({
                object: 'uci',
                method: 'get',
                params: ['config', 'type'],
                expect: { values: {} }
        }),
        ModechangeCreateUCISection:L.rpc.declare({
                object: 'uci',
                method: 'add',
                params: ['config', 'type','name', 'values']
        }),

        MACFilteringCreateUCISection: L.rpc.declare({
                object: 'uci',
                method: 'add',
                params: ['config', 'type', 'values']
        }),

        MACFilteringCommitUCISection: L.rpc.declare({
                object: 'uci',
                method: 'commit',
                params: ['config']
        }),

        MACFilteringDeleteUCISection: L.rpc.declare({
                object: 'uci',
                method: 'delete',
                params: ['config', 'type', 'section']
        }),

        updatefirewallconfig: L.rpc.declare({
                object: 'rpc-updatemacidconfig',
                method: 'configure',
                expect: { output: '' }
        }),

        updateopenvpnconfig: L.rpc.declare({
                object: 'rpc-updatemacidconfig',
                method: 'enableopenvpn',
                expect: { output: '' }
        }),

        deletecertficates: L.rpc.declare({
                object: 'rpc-updatemacidconfig',
                method: 'delete',
                expect: { output: '' }
        }),

        countcertficates: L.rpc.declare({
                object: 'rpc-updatemacidconfig',
                method: 'countcertfiles',
                expect: { output: '' }
        }),

        startopenvpnservice: L.rpc.declare({
                object: 'rpc-updatemacidconfig',
                method: 'startopenvpn',
                expect: { output: '' }
        }),

        stopopenvpnservice: L.rpc.declare({
                object: 'rpc-updatemacidconfig',
                method: 'stopopenvpn',
                expect: { output: '' }
        }),



        TestArchive: L.rpc.declare({
                object: 'rpc-updatemacidconfig',
                method: 'testarchive',
                params: ['archive'],
        }),


        handleArchiveUpload: function () {
                var self = this;
                L.ui.archiveUploadcerts(
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

        MACFilteringFormCallback: function () {
                var map = this;
                var MACFilteringConfigSectionName = map.options.MACFilteringConfigSection;
                var numericExpression = /^[0-9]+$/;

                map.options.caption = L.tr(MACFilteringConfigSectionName + ' Configuration');

                var s = map.section(L.cbi.NamedSection, MACFilteringConfigSectionName, {

                        collabsible: true
                });
                console.log(MACFilteringConfigSectionName)
                s.option(L.cbi.CheckboxValue, 'Enable', {
                        caption: L.tr('Enable/Disable')
                })

                s.option(L.cbi.InputValue, 'MACFilteringConfigSectionName', {

                        caption: L.tr('Url Blocking'),
                        datatype: 'url',
                }).depends({ 'Enable': '1' });

        },



        MACFilteringRenderContents: function (rv) {
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
                                caption: L.tr('Mac id'),
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
                                        console.log(this.status)
                                        var div = $('<label />').attr('id', 'MACFilteringDeviceEventName_%s'.format(n)).attr('class', 'switch');
                                        return div.append(`<input type="checkbox" ${v} disabled  id="PortforwardingstatusSwitch${n}" onclick="changestatus(${n})">
          <span class="slider round"></span>`);
                                }
                        },
                        {
                                caption: L.tr('Update'),
                                align: 'center',
                                format: function (v, n) {
                                        return $('<div />')
                                                .addClass('btn-group btn-group-sm')
                                                .append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Configure'))
                                                        .click({ self: self, MACID: v }, self.MACFilteringConfigSectionEdit))
                                                .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                                        .click({ self: self, MACID: v }, self.MACFilteringConfigSectionRemove));

                                }
                        }]
                });
               
               
                var list2 = new L.ui.table({
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
                                caption: L.tr('Mac id'),
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
                                        console.log(this.status)
                                        var div = $('<label />').attr('id', 'MACFilteringDeviceEventName_%s'.format(n)).attr('class', 'switch');
                                        return div.append(`<input type="checkbox" ${v} disabled  id="PortforwardingstatusSwitch${n}" onclick="changestatus(${n})">
          <span class="slider round"></span>`);
                                }
                        },
                        {
                                caption: L.tr('Update'),
                                align: 'center',
                                format: function (v, n) {
                                        return $('<div />')
                                                .addClass('btn-group btn-group-sm')
                                                .append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Configure'))
                                                        .click({ self: self, MACID: v }, self.MACFilteringConfigSectionEdit))
                                                .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                                        .click({ self: self, MACID: v }, self.MACFilteringConfigSectionRemove));

                                }
                        }]
                });
                for (var key in rv) {
                        if (rv.hasOwnProperty(key)) {
                                var obj = rv[key];
                                console.log(obj);
                                var MACID = obj.MACID
                                var Accesspolicy = obj.Accesspolicy
                                
                                var status = obj.MACfilteringSwitch;
                                var NetworkMode=obj.NetworkMode;
                                if (status == "1") {
                                        status = "checked"
                                }
                                else {
                                        status = ""
                                }
                                if(NetworkMode == '1'){
                                        list.row([key, MACID,Accesspolicy, status, key]);
                                }
                                else{
                                        list2.row([key, MACID,Accesspolicy, status, key]);
                                }
                                
                        }
                }
                $('#networktype1').append(list.render());
                $('#networktype2').append(list2.render());
        },

        MACFilteringConfigSectionAdd: function (id) {
                debugger;
                var self = this;
                var MACfilteringSwitch = $('#MACfilteringSwitch')[0].checked;
                console.log(MACfilteringSwitch)
                var MACID = $('#MACID').val();
                var Accesspolicy = $('#Accesspolicy1').val();
                var NetworkMode = $('#NetworkMode').val();
                
                if(MACfilteringSwitch == 1){
                        var Accesspolicy = $('#Accesspolicy1').val(); 
                }
                else{
                        var Accesspolicy = "Disable";
                }
                var sensorSectionOptions = { EEnable: 1, MACfilteringSwitch: MACfilteringSwitch, MACID: MACID,Accesspolicy:Accesspolicy,NetworkMode:NetworkMode};

                // this.MACFilteringUCISections("vpnconfog1","MACFilteringConfig").then(function(rv) {
                this.MACFilteringUCISections("macidconfig", "macidconfig").then(function (rv) {
                        var keys = Object.keys(rv);
                        var uniquedevicename = [];

                        for (var key in rv) {
                                var obj = rv[key];
                                uniquedevicename.push(obj.MACID)
                        }
                        var keysLength = keys.length;
                        if (id != "") {

                        }
                        // alert(keysLength);
                        if (keysLength >= 15) {
                                alert("Only 15 connections can be configured");
                        }
                        else {
                                if (id != "") {
                                        var editfields = rv[id]
                                        var key = editfields.MACID;
                                        console.log(key);
                                        self.MACFilteringDeleteUCISection("macidconfig", "macidconfig", id).then(function (rv) {
                                                if (rv == 0) {
                                                        self.MACFilteringCommitUCISection("macidconfig").then(function (res) {
                                                                if (res != 0) {
                                                                        alert("Error: Delete Configuration");
                                                                }
                                                                else {
                                                                        location.reload();
                                                                }
                                                        });
                                                };
                                        });
                                        //   self.MACFilteringCreateUCISection("vpnconfig1","MACFilteringConfig",MACFilteringConfigSectionName,sensorSectionOptions).then(function(rv){
                                        self.MACFilteringCreateUCISection("macidconfig", "macidconfig", sensorSectionOptions).then(function (rv) {
                                                if (rv) {
                                                        if (rv.section) {
                                                                self.MACFilteringCommitUCISection("macidconfig").then(function (res) {

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
                                
                                        else {
                                                self.MACFilteringCreateUCISection("macidconfig", "macidconfig", sensorSectionOptions).then(function (rv) {
                                                        if (rv) {
                                                                if (rv.section) {
                                                                        self.MACFilteringCommitUCISection("macidconfig").then(function (res) {

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

                                }
                        })
        },

     
        ModeConfigSectionAdd1: function (id) {
                var self = this;
                var Accesspolicy = $('#Accesspolicy'+id).val();
                alert(Accesspolicy + '_Updated Succesfully' )
                var MACfilteringSwitch=1;
                var sensorSectionOptions = { EEnable: 1,Accesspolicy:Accesspolicy,MACfilteringSwitch:MACfilteringSwitch };

                // this.MACFilteringUCISections("vpnconfog1","MACFilteringConfig").then(function(rv) {
                this.MACFilteringUCISections("macidconfig", "macidconfig").then(function (rv) {
                       
                        var keys = Object.keys(rv);
                        for (var key in rv) {
                                var networkmode=rv[key].NetworkMode
                                if(networkmode==id){
                                self.ModechangeCreateUCISection("macidconfig", "macidconfig",key,sensorSectionOptions).then(function (rv) {
                                        if (rv) {
                                                if (rv.section) {
                                                        self.MACFilteringCommitUCISection("macidconfig").then(function (res) {

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
        },


        MACFilteringConfigSectionRemove: function (ev) {
                debugger;
                var self = ev.data.self;
                var MACID = ev.data.MACID;
                //self.MACFilteringDeleteUCISection("vpnconfig1","MACFilteringConfig",MACFilteringConfigSectionName).then(function(rv){
                self.MACFilteringDeleteUCISection("macidconfig", "macidconfig", MACID).then(function (rv) {
                        if (rv == 0) {
                                self.MACFilteringCommitUCISection("macidconfig").then(function (res) {
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

        MACFilteringConfigSectionEdit: function (ev) {
                $("#Applyconfig").css("display", "none")
                $("#editconfig").css("display", "inline")
                console.log(ev);
                var key = ev.data.MACID;
                editkey = function () {
                        return key;
                }
                var porteditdata = configdata();
                var editfields = porteditdata[key];
                console.log(editfields);

                var status = editfields.MACfilteringSwitch
                if (status == "1") {
                        status = true;
                }
                else {
                        status = false;
                }
                var MACID = editfields.MACID
               
                $('#MACID').val(MACID);
                document.getElementById("MACfilteringSwitch").checked = status;
                // $('#LANIP').val(editfields.LANIP);
                //  return self.MACFilteringConfigCreateForm(L.cbi.Modal,MACFilteringConfigSectionName).show();
                $("#exampleModal").modal('show');
        },

        execute: function () {
                $('#addnew').click(function () {
                        $('#UrlBlocking').val("");
                        document.getElementById("MACfilteringSwitch").checked = true;
                });
                $("#editconfig").css("display", "none")
                $("#Applyconfig").css("display", "inline")
                var self = this;

                var m = new L.cbi.Map('macidconfig', {
                });

                var s = m.section(L.cbi.NamedSection, 'general', {
                        caption: L.tr('General Configurations')
                });


                s.option(L.cbi.CheckboxValue, 'enableipsecgeneral', {
                        caption: L.tr('Enable IPSEC'),
                        optional: true
                });

                s.option(L.cbi.CheckboxValue, 'enableopenvpngeneral', {
                        caption: L.tr('Enable Openvpn'),
                        optional: true
                });

                s.option(L.cbi.CheckboxValue, 'enablepptp', {
                        caption: L.tr('Enable PPTP'),
                        optional: true
                });


                m.insertInto('#section_vpn_general');

                var m1 = new L.cbi.Map('macidconfig', {
                });

                var s1 = m1.section(L.cbi.NamedSection, 'pptp', {
                        caption: L.tr('PPTP Configurations')
                });


            



                var self = this;
                $('#Applyconfig').click(function () {
                        var res = "";
                        debugger

                        var url = document.getElementById("MACID").value;
                        var validationResult = document.getElementById("validationResult");

                        if (
                                url.match(
                                        /^[a-fA-F0-9:]{17}|[a-fA-F0-9]{12}$/g
                                )
                        ) {

                                self.MACFilteringConfigSectionAdd("");
                        } else {
                                console.log("Invalid");
                                res = "Must be a valid MacID";
                        }
                        validationResult.innerHTML = res;




                });
                $('#editconfig').click(function () {
                        var res = "";
                        debugger

                        var url = document.getElementById("MACID").value;
                        var validationResult = document.getElementById("validationResult");

                        if (
                                url.match(
                                        /^[a-fA-F0-9:]{17}|[a-fA-F0-9]{12}$/g
                                )
                        ) {
                                var key = editkey()

                                self.MACFilteringConfigSectionAdd(key);
                        } else {
                                console.log("Invalid");
                                res = "Must be a valid MacID";
                        }
                        validationResult.innerHTML = res;




                });
                //  self.MACFilteringUCISections("vpnconfig1","MACFilteringConfig").then(function(rv) {
                self.MACFilteringUCISections("macidconfig", "macidconfig").then(function (rv) {
                        self.MACFilteringRenderContents(rv);
                });
                $('#update_ipsec').click(function () {
                        L.ui.loading(true);
                        self.updatefirewallconfig('configure').then(function (rv) {
                                //alert(rv);
                                // L.ui.loading(false);
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

              
            
                $('#ChangeMode1').click(function(){
                        self.ModeConfigSectionAdd1(1);
                })
                $('#ChangeMode2').click(function(){
                        self.ModeConfigSectionAdd1(2);
                })
                //Openvpn     
                $('#btn_upload').click(function () {

                        self.countcertficates().then(function (rv) {



                                //alert(rv);
                                //var count = '1';
                                if (rv < '1') {
                                        self.handleArchiveUpload();
                                }
                                else {
                                        L.ui.loading(false);
                                        L.ui.dialog(

                                                L.tr('Upload Certificates error'), [
                                                $('<p />').text(L.tr('Output')),
                                                $('<pre />')
                                                        .addClass('alert alert-danger')
                                                        .text("Please click on Delete button to delete existing .ovpn files and then click on Upload button to upload the new .ovpn file."),
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

                $('#btn_delete').click(function () {

                        self.deletecertficates().then(function (rv) {

                                L.ui.loading(false);
                                L.ui.dialog(

                                        L.tr('Delete Openvpn certificates'), [
                                        $('<p />').text(L.tr('Output')),
                                        $('<pre />')
                                                .addClass('alert alert-info')
                                                .text("Openvpn certificates Deleted"),
                                ],
                                        {
                                                style: 'close',
                                                close: function () {
                                                        location.reload();
                                                }
                                        }
                                );
                        });
                });

                self.MACFilteringUCISections("macidconfig", "macidconfig").then(function (rv) {
                        for (var key in rv) {
                                if (rv.hasOwnProperty(key)) {
                                        var obj = rv[key];
                                        var running = obj.openvpnrunning;
                                        if (running == '0') {
                                                var AppstartCreateButton = $('<button/>', {
                                                        class: 'btn btn-primary',
                                                        text: 'Start',
                                                        id: 'start',
                                                        title: 'Start the Apps',
                                                        style: 'width:110px',
                                                        on: {
                                                                click: function (e) {
                                                                        L.ui.loading(true);
                                                                        self.startopenvpnservice().then(function (rv) {
                                                                                L.ui.loading(false);
                                                                                L.ui.dialog(

                                                                                        L.tr('Started the openvpn service'), [
                                                                                        $('<p />').text(L.tr('Output')),
                                                                                        $('<pre />')
                                                                                                .addClass('alert alert-info')
                                                                                                .text(rv),
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
                                                        }
                                                });
                                                $("#btn-group").append(AppstartCreateButton);
                                        }

                                        if (running == '1') {
                                                var AppStopCreateButton = $('<button/>', {
                                                        class: 'btn btn-danger',
                                                        text: 'Stop',
                                                        title: 'Stop the Apps',
                                                        style: 'width:110px',
                                                        on: {
                                                                click: function (e) {
                                                                        L.ui.loading(true);
                                                                        self.stopopenvpnservice().then(function (rv) {
                                                                                L.ui.loading(false);
                                                                                L.ui.dialog(
                                                                                        L.tr('Stopped the openvpn service'), [
                                                                                        $('<pre />')
                                                                                                .addClass('alert alert-danger')
                                                                                                .text(rv),
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
                                                        }
                                                });
                                                $("#btn-group").append(AppStopCreateButton);
                                        }
                                }
                        }
                });


                //m.insertInto('#map');
                //  m.appendTo('#sectiontab_vpn_general');

                s.commit = function () {

                        self.updateopenvpnconfig('enableopenvpn').then(function (rv) {
                                //alert("Enabling openvpn");

                        });
                }

        }




});


