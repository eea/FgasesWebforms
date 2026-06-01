(function() {

    angular.module('FGases.controllers').controller('EquipmentVerificationCtrl', function($rootScope, $scope, modalAdapter, $notification) {
        // Functions
        $scope._check_section_II_4_comments = function(transaction_id) {
            // Part 1
            if (transaction_id == 'tr_13D') {
                let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
                if (!$scope.conditionEquipmentPart1Op1()) {
                    if (!isEmpty(section4.option_a.reason_1)) {
                        $notification.warning("", "Due to transaction 13D verification, the comment for Option 1 in Part 1 in Section II-4 was reverted.");
                        section4.option_a.reason_1 = '';
                    }
                }
                if (!$scope.conditionEquipmentPart1Op2()) {
                    if (!isEmpty(section4.option_a.reason_2)) {
                        $notification.warning("", "Due to transaction 13D verification, the comment for Option 2 in Part 1 in Section II-4 was reverted.");
                        section4.option_a.reason_2 = '';
                    }
                }
                if (!$scope.conditionEquipmentPart1Op3()) {
                    if (!isEmpty(section4.option_a.reason_3)) {
                        $notification.warning("", "Due to transaction 13D verification, the comment for Option 3 in Part 1 in Section II-4 was reverted.");
                        section4.option_a.reason_3 = '';
                    }
                }
            }
            // Part 2
            if ((transaction_id == 'tr_12A') || (transaction_id == 'tr_12B')) {
                let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
                if (!$scope.conditionEquipmentPart2Op1()) {
                    if (!isEmpty(section4.option_b.reason_1)) {
                        $notification.warning("", `Due to transaction ${transaction_id.substr(3)} verification, the comment for Option 1 in Part 2 in Section II-4 was reverted.`);
                        section4.option_b.reason_1 = '';
                    }
                }
                if (!$scope.conditionEquipmentPart2Op2()) {
                    if (!isEmpty(section4.option_b.reason_2)) {
                        $notification.warning("", `Due to transaction ${transaction_id.substr(3)} verification, the comment for Option 2 in Part 3 in Section II-4 was reverted.`);
                        section4.option_b.reason_2 = '';
                    }
                }
                if (!$scope.conditionEquipmentPart2Op3()) {
                    if (!isEmpty(section4.option_b.reason_3)) {
                        $notification.warning("", `Due to transaction ${transaction_id.substr(3)} verification, the comment for Option 3 in Part 3 in Section II-4 was reverted.`);
                        section4.option_b.reason_3 = '';
                    }
                }
            }
            // Part 3
            if ((transaction_id == 'tr_12aA') || (transaction_id == 'tr_12aB')) {
                let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
                if (!$scope.conditionEquipmentPart3Op1()) {
                    if (!isEmpty(section4.option_c.reason_1)) {
                        $notification.warning("", `Due to transaction ${transaction_id.substr(3)} verification, the comment for Option 1 in Part 3 in Section II-4 was reverted.`);
                        section4.option_c.reason_1 = '';
                    }
                }
                if (!$scope.conditionEquipmentPart3Op2()) {
                    if (!isEmpty(section4.option_c.reason_2)) {
                        $notification.warning("", `Due to transaction ${transaction_id.substr(3)} verification, the comment for Option 2 in Part 3 in Section II-4 was reverted.`);
                        section4.option_c.reason_2 = '';
                    }
                }
                if (!$scope.conditionEquipmentPart3Op3()) {
                    if (!isEmpty(section4.option_c.reason_3)) {
                        $notification.warning("", `Due to transaction ${transaction_id.substr(3)} verification, the comment for Option 3 in Part 3 in Section II-4 was reverted.`);
                        section4.option_c.reason_3 = '';
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
            else if (option == "option_c") {
                switch (reason) {
                    case 'reason_1':

                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_c.reason_2 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_c.reason_3 = '';
                        break;
                    case 'reason_2':

                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_c.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_c.reason_3 = '';
                        break;
                    case 'reason_3':

                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_c.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_c.reason_2 = '';
                        break;

                }
            }
            
        }

        $scope.conditionEquipmentPart1Op1 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_13D = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
            let tr_13D_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_13D'];
            if (section4.option_a.option == '1') {
                if (parseFloat(tr_13D.tco2e) == 0 || tr_13D_confirmation.confirmation_c.checked) {
                    return true;
                }
            }
            return false;
        }
        $scope.conditionEquipmentPart1Op2 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_13D = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
            if (section4.option_a.option == '2') {
                if (parseFloat(tr_13D.tco2e) <= 0) {
                    return true;
                }
            }
            return false;
        }
        $scope.conditionEquipmentPart1Op3 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_13D = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
            let tr_13D_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_13D'];
            if (section4.option_a.option == '3') {
                if (parseFloat(tr_13D.tco2e) > 0 && (tr_13D_confirmation.confirmation_a.checked || tr_13D_confirmation.confirmation_b.checked)) {
                    return true;
                }
            }
            return false;
        }

        $scope.conditionEquipmentPart2Op1 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_12A = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
            let tr_12B = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];
            let tr_12A_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];
            let tr_12B_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12B'];
            if ($scope.instance.Verification.VerificationScope.Equipment) {
                if (section4.option_b.option == "1") {
                    if ((parseFloat(tr_12A.tco2e) == 0 && parseFloat(tr_12B.tco2e) == 0) || (tr_12A_confirmation.confirmation_c.checked || tr_12B_confirmation.confirmation_c.checked)) {
                        return true;
                    }
                    else return false;
                }
                return true;
            }
        }
        $scope.conditionEquipmentPart2Op2 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_12A = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
            let tr_12B = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];

            if ($scope.instance.Verification.VerificationScope.Equipment) {
                if (section4.option_b.option == "2") {
                    if ((parseFloat(tr_12A.tco2e) == 0 && parseFloat(tr_12B.tco2e) == 0)) {
                        return true;
                    }
                    else return false;
                }
                return true;
            }
        }
        $scope.conditionEquipmentPart2Op3 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_12A = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
            let tr_12B = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];
            let tr_12A_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];
            let tr_12B_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12B'];

            if ($scope.instance.Verification.VerificationScope.Equipment) {
                if (section4.option_b.option == "3") {

                    let check_12A = (parseFloat(tr_12A.tco2e) > 0) && (tr_12A_confirmation.confirmation_a.checked || tr_12A_confirmation.confirmation_b.checked);
                    let check_12B = (parseFloat(tr_12B.tco2e) > 0) && (tr_12B_confirmation.confirmation_a.checked || tr_12B_confirmation.confirmation_b.checked);
                    if ((check_12A) || (check_12B)) {
                        return true;
                    }
                    else return false;
                }
                return true;
            }
        }

        $scope.conditionEquipmentPart3Op1 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_12aA = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
            let tr_12aB = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];
            let tr_12aA_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12aA'];
            let tr_12aB_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12aB'];
            if ($scope.instance.Verification.VerificationScope.Equipment) {
                if (section4.option_c.option == "1") {

                    if ((parseFloat(tr_12aA.tco2e) == 0 && parseFloat(tr_12aB.tco2e) == 0) || (tr_12aA_confirmation.confirmation_c.checked || tr_12aB_confirmation.confirmation_c.checked)) {
                        return true;
                    }
                    else return false;
                }
                return true;
            }
        }
        $scope.conditionEquipmentPart3Op2 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_12aA = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
            let tr_12aB = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];

           
            if ($scope.instance.Verification.VerificationScope.Equipment) {
                if (section4.option_c.option == "2") {

                    if ((parseFloat(tr_12aA.tco2e) == 0 && parseFloat(tr_12aB.tco2e) == 0)) {
                        return true;
                    }
                    else return false;
                }
                return true;
            }
        }
        $scope.conditionEquipmentPart3Op3 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_12aA = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
            let tr_12aB = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];
            let tr_12aA_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12aA'];
            let tr_12aB_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12aB'];

            if ($scope.instance.Verification.VerificationScope.Equipment) {
                if (section4.option_c.option == "3") {

                    if ((parseFloat(tr_12aA.tco2e) > 0 || parseFloat(tr_12aB.tco2e) > 0) && (tr_12aA_confirmation.confirmation_a.checked || tr_12aB_confirmation.confirmation_a.checked || tr_12aA_confirmation.confirmation_b.checked || tr_12aB_confirmation.confirmation_b.checked)) {
                        return true;
                    }
                    else return false;
                }
                return true;
            }
        }


    });
})();