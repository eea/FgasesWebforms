(function() {

    angular.module('FGases.controllers').controller('EquipmentVerificationCtrl', function($rootScope, $scope, modalAdapter, $notification) {
        // Functions
        $scope._check_section_II_4_comments = function(transaction_id) {
            if (transaction_id == 'tr_13D') {
                let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
                let tr_13D = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
                let tr_13D_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_13D'];

                if (section4.option_a.option == '1') {
                    if (!(tr_13D.tco2e > 0 || tr_13D_confirmation.confirmation_c.checked)) {
                        if (!isEmpty(section4.option_a.reason_1)) {
                            $notification.warning("", "Due to transaction 13D verification, the comment for Option 1 in Part 1 in Section II-4 was reverted.");
                            section4.option_a.reason_1 = '';
                        }
                    }
                }
                if (section4.option_a.option == '2') {
                    if (!(tr_13D.tco2e > 0)) {
                        if (!isEmpty(section4.option_a.reason_2)) {
                            $notification.warning("", "Due to transaction 13D verification, the comment for Option 2 in Part 1 in Section II-4 was reverted.");
                            section4.option_a.reason_2 = '';
                        }
                    }
                }
                if (section4.option_a.option == '3') {
                    if (!((tr_13D.tco2e <= 0) && (tr_13D_confirmation.confirmation_a.checked || tr_13D_confirmation.confirmation_b.checked))) {
                        if (!isEmpty(section4.option_a.reason_3)) {
                            $notification.warning("", "Due to transaction 13D verification, the comment for Option 3 in Part 1 in Section II-4 was reverted.");
                            section4.option_a.reason_3 = '';
                        }
                    }
                }
            }
            
            if (transaction_id == 'tr_12A') {
                let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
                let tr_12A = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
                let tr_12A_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];

                if (section4.option_a.option == '1') {
                    if (!(tr_12A.tco2e > 0 || tr_12A_confirmation.confirmation_c.checked)) {
                        if (!isEmpty(section4.option_a.reason_1)) {
                            $notification.warning("", "Due to transaction 12A' verification, the comment for Option 1 in Part 2 in Section II-4 was reverted.");
                            section4.option_a.reason_1 = '';
                        }
                    }
                }
                if (section4.option_a.option == '2') {
                    if (!(tr_12A.tco2e > 0)) {
                        if (!isEmpty(section4.option_a.reason_2)) {
                            $notification.warning("", "Due to transaction 12A' verification, the comment for Option 2 in Part 2 in Section II-4 was reverted.");
                            section4.option_a.reason_2 = '';
                        }
                    }
                }
                if (section4.option_a.option == '3') {
                    if (!((tr_12A.tco2e <= 0) && (tr_12A_confirmation.confirmation_a.checked || tr_12A_confirmation.confirmation_b.checked))) {
                        if (!isEmpty(section4.option_a.reason_3)) {
                            $notification.warning("", "Due to transaction 12A' verification, the comment for Option 3 in Part 2 in Section II-4 was reverted.");
                            section4.option_a.reason_3 = '';
                        }
                    }
                }
            }
        }
        $scope.onConfirmation_a_Changed = function(confirmation_row, transaction_id) {
            $scope._clean_confirmation(confirmation_row.confirmation_b);
            $scope._clean_confirmation(confirmation_row.confirmation_c);
            $scope._check_section_II_4_comments(transaction_id);
        };
        $scope.onConfirmation_b_Changed = function(translation_prefix, confirmation_row, transaction_id) {
            $scope._clean_confirmation(confirmation_row.confirmation_a);
            $scope._clean_confirmation(confirmation_row.confirmation_c);

            if (confirmation_row.confirmation_b.checked) {
                confirmation_row.confirmation_b.checked = false;
                modalAdapter.open($scope, 'lg', 'hfcs-verification-confirmation.html', 'HFCSCofirmationModalController',
                    {
                        "translation_prefix": translation_prefix,
                        "option": "b",
                        "transaction_id": transaction_id,
                        "confirmation": confirmation_row.confirmation_b,
                    },
                    () => $scope._check_section_II_4_comments(transaction_id),
                );
            }
        };
        $scope.onConfirmation_c_Changed = function (translation_prefix, confirmation_row, transaction_id) {
            $scope._clean_confirmation(confirmation_row.confirmation_a);
            $scope._clean_confirmation(confirmation_row.confirmation_b);

            if (confirmation_row.confirmation_c.checked) {
                confirmation_row.confirmation_c.checked = false;
                modalAdapter.open($scope, 'lg', 'hfcs-verification-confirmation.html', 'HFCSCofirmationModalController',
                    {
                        "translation_prefix": translation_prefix,
                        "option": "c",
                        "transaction_id": transaction_id,
                        "confirmation": confirmation_row.confirmation_c,
                    },
                    () => $scope._check_section_II_4_comments(transaction_id),
                );
            }
        };

        $scope.removeComments = function (option, reason) {
           // alert("aqui");
            if (option == "option_a") {
                switch (reason) {
                    case 'reason_1':
                       
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_2 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_3 = '';
                        break;
                    case 'reason_2':
                        
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_3 = '';
                        break;
                    case 'reason_3':
                       
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_2 = '';
                        break;
                    default:
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_2 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_3 = '';
                }
            } else if (option == "option_b") {
                switch (reason) {
                    case 'reason_1':
                       
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_b.reason_2 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_b.reason_3 = '';
                        break;
                    case 'reason_2':
                       
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_b.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_b.reason_3 = '';
                        break;
                    case 'reason_3':
                       
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_b.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_b.reason_2 = '';
                        break;
                  
                }
            }
            
        }
    });
})();