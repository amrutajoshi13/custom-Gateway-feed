L.ui.view.extend({

  title: L.tr('Troubleshoot'),
  RunUdev: L.rpc.declare({
    object: 'command',
    method: 'exec',
    params: ['command', 'args'],
  }),


  fGetUCISections: L.rpc.declare({
    object: 'uci',
    method: 'get',
    // params: [ 'config', 'type', 'section']  
    params: ['config', 'type']

  }),

  updateinterfaceconfig: L.rpc.declare({
    object: 'rpc-tcpdumpupdate',
    method: 'configure',
    expect: { output: '' }
  }),

  // updateinterfaceconfig: L.rpc.declare({
  //   object: 'rpc-tcpdumpupdate',
  //   method: 'configure',
  //   //params: ['application', 'action'],
  //   expect: { output: '' }
  // }),

  handleBackupDownload: function () {
    var form = $('#btn_backup').parent();

    form.find('[name=sessionid]').val(L.globals.sid);
    form.submit();
  },



  execute: function () {
    var self = this;
    var m = new L.cbi.Map('tcpdumpconfig', {
    });

    var s = m.section(L.cbi.NamedSection, 'tcpdump', {
      caption: L.tr('Tcpdump Configuration')
    });

    s.option(L.cbi.ListValue, 'tcpdump_mode', {
      caption: L.tr('Select Tcpdump Mode'),
      optional: true
    }).value('enabled', L.tr('Enable TCP Standard Command'))
      .value('customenabled', L.tr('Enable Custom TCP Command'));
    

    s.option(L.cbi.InputValue, 'customtcp_command', {
      caption: L.tr('Tcp-Custom Command'),
      placeholder: 'tcpdump -nvv -i eth0.5 src 192.168.10.120 and not arp',
    }).depends({ 'tcpdump_mode':'enabled', 'tcpdump_mode':'customenabled' });

    s.option(L.cbi.Ifname_List, 'interface', {
      caption: L.tr('Interfaces'),
      optional: true,
    }).depends({ 'tcpdump_mode':'enabled'})
      .value("any", "Any");

    s.option(L.cbi.InputValue, 'port', {
      caption: L.tr('Port'),
      datatype: 'uinteger_digit',
      placeholder: '80',
      optional: true,
    }).depends({ 'tcpdump_mode':'enabled'});

    s.option(L.cbi.ComboBox, 'proto', {
      caption: L.tr('Protocol'),
    }).depends({ 'tcpdump_mode':'enabled'})
      .value('all', L.tr('ALL'))
      .value('icmp', L.tr('ICMP'))
      .value('udp', L.tr('UDP'))
      .value('tcp', L.tr('TCP'))
      .value('arp', L.tr('ARP'));

    s.option(L.cbi.InputValue, 'timeout', {
      caption: L.tr('Time in seconds (Sec)'),
      description: L.tr('Time should be formatted in seconds'),
      datatype: 'uinteger_digit',
      placeholder: '30',
    }).depends({ 'tcpdump_mode':'enabled'})
    .depends({'tcpdump_mode':'customenabled'});

    s.option(L.cbi.ListValue, 'tcp_inout', {
      caption: L.tr('Packet direction'),
    }).depends({ 'tcpdump_mode':'enabled'})
      .value('inout', L.tr('Incoming/Outgoing'))
      .value('in', L.tr('Incoming'))
      .value('out', L.tr('Outgoing'));

    // List Value for IP Address Selection
    s.option(L.cbi.ListValue, 'ipaddress', {
      caption: L.tr('IP Address'),
    }).value("none", L.tr('Please choose'))
      .value("hostip", L.tr('Host IP'))
      .value("subnetip", L.tr('Subnet IP'))
      .depends({ 'tcpdump_mode':'enabled'});

    // Input Value for Host IP
    s.option(L.cbi.InputValue, 'tcp_host', {
      caption: L.tr('Host IP'),
      optional: true,
      datatype: 'ip4addr',
      placeholder: '192.168.10.1',
    }).depends({ ipaddress: 'hostip','tcpdump_mode':'enabled'});

    // Input Value for Subnet IP
    s.option(L.cbi.InputValue, 'tcp_subnet', {
      caption: L.tr('Subnet IP'),
      datatype: 'cidr4',
      optional: true,
      placeholder: '192.168.10.0/24',
    }).depends({ ipaddress: 'subnetip','tcpdump_mode':'enabled'});


    download_data = function (data) {
      var timeout = parseInt(data, 10);
      document.getElementById('progress-container').style.display = 'block'
      document.getElementById('progress-label').style.display = 'block'
      var P_bar = document.getElementById('progress-bar');
      var P_Label = document.getElementById('progress-label');
      var T_Width = 100;
      var C_Width = 0;
      var interval = T_Width / timeout;

      if (s.progressInterval) clearInterval(s.progressInterval);
      s.progressInterval = setInterval(function () {
        if (C_Width >= T_Width) {
          clearInterval(s.progressInterval);
          document.getElementById('progress-container').style.display = 'none'
          P_Label.textContent = `PCAP tcpdump data run completed with a timeout of ${timeout} seconds`;
          document.getElementById('btn_backup').style.display = 'block'
          return;
        }
        C_Width += interval;
        P_bar.style.width = C_Width + '%';
        P_Label.textContent = `${Math.round((C_Width / T_Width) * timeout)} seconds`;
      }, 1000);

    }

    $('#btn_backup').click(function () { self.handleBackupDownload(); });




    // New Logic 

    s.commit = function () {
      self.fGetUCISections('tcpdumpconfig', 'tcpdump').then(function (rv) {
        console.log(rv)
        var timeout = rv.values.tcpdump.timeout;
        var tcpdump_mode = rv.values.tcpdump.tcpdump_mode;
        console.log("Valuessss",tcpdump_mode)
        //var enabled = rv.values.tcpdump.enabled;
        //var customenable = rv.values.tcpdump.customenabled;

        localStorage.setItem('tcp_dump_Timeout', timeout);
        localStorage.setItem('tcp_dump_status',tcpdump_mode);
        //localStorage.setItem('tcp_dump_customenable', customenable);

      })
    };


    $("#btn_run").click(function () {
      document.getElementById('progress-container').style.display = 'none'
      document.getElementById('progress-label').style.display = 'none'
      document.getElementById('btn_backup').style.display = 'none'
      const enabled = localStorage.getItem('tcp_dump_status')
      // const customenabled = localStorage.getItem(tcpdump_mode)
      //const enabled = localStorage.getItem('tcp_dump_enabled');
      //const customenable = localStorage.getItem('tcp_dump_customenable');
      const loadingIndicator = document.getElementById('loading');

      if (enabled === 'customenabled') {
        loadingIndicator.style.display = "block";
        self.updateinterfaceconfig('configure').then(function (rv) {
          console.log(rv);
          loadingIndicator.style.display = "none";
          const isSuccessResponse = rv.includes('SUCCESS');
          const isSuccessListeningResponse = rv.includes('SUCCESS: tcpdump: listening');
          if (isSuccessListeningResponse) {
            const Timeout = localStorage.getItem('tcp_dump_Timeout');
            download_data(Timeout);
            // console.log("Timeout and interface configuration updated successfully with listening. No download needed.");
          } else if (isSuccessResponse) {
            // console.log("Received success message, but no listening detected. Displaying error.");
            rv = rv.replace('SUCCESS', 'Error Message');
            const errorLabel = document.getElementById('Error-label');
            if (errorLabel) {
              errorLabel.style.display = "block";
              errorLabel.innerHTML = rv;
            }
          }
        })
      } else if (enabled === 'enabled') {
        const Timeout = localStorage.getItem('tcp_dump_Timeout');
        download_data(Timeout);
        self.updateinterfaceconfig('configure').then(function (rv) {
        })
      }
    });
    return m.insertInto('#map');

  }
});