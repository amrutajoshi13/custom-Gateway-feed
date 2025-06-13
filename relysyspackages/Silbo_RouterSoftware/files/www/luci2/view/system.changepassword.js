L.ui.view.extend({

    getValues: L.rpc.declare({
        object: 'uci',
        method: 'get',
        params: ['config', 'type'],
        expect: { values: {} }
    }),

    sensorCreateUCISection: L.rpc.declare({
        object: 'uci',
        method: 'add',
        params: ['config', 'type', 'values', 'name']
    }),

    sensorCommitUCISection: L.rpc.declare({
        object: 'uci',
        method: 'commit',
        params: ['config']
    }),

    cryptPassword: L.rpc.declare({
        object: 'luci2.ui',
        method: 'crypt',
        params: [ 'data' ],
        expect: { crypt: '' }
    }),

    updateSection: function (config, type, name, values, errorMsg, successMsg) {
        var self = this;
        L.ui.loading(true);
        self.sensorCreateUCISection(config, type, values, name).then(function (rv) {
            if (rv) {
                L.ui.loading(false);
                if (rv.section) {
                    self.sensorCommitUCISection(config).then(function (res) {
                        if (res != 0) {
                            alert("error");
                            if (errorMsg) {
                                alert(errorMsg);
                            }
                            return false;
                        }
                        else {
                            if (successMsg) {
                                alert("Success : Configuration applied Successfully");
                            }
                            location.reload();
                        }
                    });
                };
            };
        });
    },
 
    execute: function () {
        var self = this;
        var passwordData = {};
        self.getValues('rpcdtemp', 'rpcdtempsection').then(function (rv) {
            passwordData['password'] = rv['rpcdtemp'].password;
        });

        savePassword = function () {
            var currentPassword = document.getElementById('current-password').value;
            var newPassword = document.getElementById('new-password').value;
            var confirmPassword = document.getElementById('confirm-password').value;

            // Password validation
            var passwordPattern = /^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,}$/;

            if (newPassword !== confirmPassword) {
                alert('New Password and Confirm Password do not match. Try Again !');
                return;
            }

            if (!passwordPattern.test(newPassword)) {
                alert('Password must contain at least one uppercase letter, one digit, one special character, and be at least 8 characters long.');
                return;
            }
            if (currentPassword != passwordData['password']) {
                alert("Current Paasword doesnt match. Try Again !");
                return;
            }

            var sectionData = {};
            sectionData['password'] = newPassword;
            sectionData['new_password'] = newPassword;
            sectionData['confirm_password'] = confirmPassword;

            
            self.cryptPassword(newPassword).then(function (rv) {
                var newSectionData = {};
                newSectionData['password'] = rv;
                self.updateSection('rpcdtemp', 'rpcdtempsection', 'rpcdtemp', sectionData);
                self.updateSection('rpcd', 'login', 'admin', newSectionData);
                alert('Password saved successfully!');
            })
        }
    }
})
