
(function() {
    // Definition of bulk-hfcs-cofirmation-modal Controller
    angular.module('FGases.controllers').controller('HFCSCofirmationModalController', function($rootScope, $scope, $modalInstance, modalData, modalExtras, $translate) {
        //define controller variables
        $scope.modalData = modalData;
        var translation_prefix = $scope.modalData.translation_prefix;
        var origin = '';

        if ($scope.modalData.translation_prefix.includes(';')) {
            var parts = $scope.modalData.translation_prefix.split(';');
            translation_prefix = parts[0];
            origin = parts[1];
            $scope.modalData.translation_prefix = translation_prefix;
        }

        if (origin === 'section_I_3' || origin === 'section_II_3') {
            $scope.modalTitle = "Summary verification statement";
        } else if (translation_prefix.includes('section-I-2-table') || translation_prefix.includes('section-II-2-table')) {
            $scope.modalTitle = "Confirmation on reported HFC amounts";
        } else {
            $scope.modalTitle = 'bulk-hfcs-verification.confirmation-modal-title';
        }
        if ($scope.modalData.option == 'b') {
            $scope.header_1          = '(b)';
            $scope.header_2          = 'bulk-hfcs-verification.table-confirmed-b';
            $scope.option_1          = `${$scope.modalData.translation_prefix}-option-b1`;
            $scope.option_2          = `${$scope.modalData.translation_prefix}-option-b2`;
            $scope.option_3          = `${$scope.modalData.translation_prefix}-option-b3`;
            $scope.option_4          = `${$scope.modalData.translation_prefix}-option-b4`;
            $scope.option_1_tooltip  = `${$scope.modalData.translation_prefix}-option-b1-tooltip`;
            $scope.option_2_tooltip  = `${$scope.modalData.translation_prefix}-option-b2-tooltip`;
            $scope.option_3_tooltip  = `${$scope.modalData.translation_prefix}-option-b3-tooltip`;
            $scope.option_4_tooltip  = `${$scope.modalData.translation_prefix}-option-b4-tooltip`;

            $scope.options_error_msg = 'validation_messages.qc_3007.modal_error_text';
            $scope.reason_error_msg  = 'validation_messages.qc_3008.modal_error_text';
        }
        else if ($scope.modalData.option == 'c') {
            $scope.header_1          = '(c)';
            $scope.header_2          = 'bulk-hfcs-verification.table-confirmed-c';
            $scope.option_1          = `${$scope.modalData.translation_prefix}-option-c1`;
            $scope.option_2          = `${$scope.modalData.translation_prefix}-option-c2`;
            $scope.option_3          = `${$scope.modalData.translation_prefix}-option-c3`;
            $scope.option_4          = `${$scope.modalData.translation_prefix}-option-c4`;
            $scope.option_1_tooltip  = `${$scope.modalData.translation_prefix}-option-c1-tooltip`;
            $scope.option_2_tooltip  = `${$scope.modalData.translation_prefix}-option-c2-tooltip`;
            $scope.option_3_tooltip  = `${$scope.modalData.translation_prefix}-option-c3-tooltip`;
            $scope.option_4_tooltip  = `${$scope.modalData.translation_prefix}-option-c4-tooltip`;
    
            $scope.options_error_msg = 'validation_messages.qc_3009.modal_error_text';
            $scope.reason_error_msg  = 'validation_messages.qc_3010.modal_error_text';
        }
        $scope.show_options_1_2_3 = $scope.modalData.transaction_id != 'tr_11P';
        $scope.alerts = [];
        
        //define OK button action function
        $scope.ok = function(result) {
            $scope.alerts = [];

            // Validate values
            if (!$scope.modalData.confirmation.option_1 &&
                !$scope.modalData.confirmation.option_2 &&
                !$scope.modalData.confirmation.option_3 &&
                !$scope.modalData.confirmation.option_4
            ) {
                $scope.alerts.push({
                    type: 'danger',
                    msg: $scope.options_error_msg,
                });
            }
            if ($scope.modalData.confirmation.option_4 &&
                (isEmpty($scope.modalData.confirmation.option_4_reason) || $scope.modalData.confirmation.option_4_reason.length < 5)) {
                $scope.alerts.push({
                    type: 'danger',
                    msg:  $scope.reason_error_msg,
                });
            }

            if ($scope.alerts.length == 0) {
                $scope.modalData.confirmation.checked = true;
                $modalInstance.close();
            }
        };//end of ok function

        //define CANCEL button action function
        $scope.cancel = function() {
            $scope.modalData.confirmation.checked = false;
            $modalInstance.dismiss('cancel');
        };//end of cancel function
    });//end of app controller 'HFCSCofirmationModalController'
})();
