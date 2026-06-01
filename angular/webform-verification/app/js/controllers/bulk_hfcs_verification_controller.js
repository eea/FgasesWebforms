(function() {

    angular.module('FGases.controllers').controller('BulkHFCsVerificationCtrl', function($rootScope, $scope, modalAdapter) {
        // Functions
        $scope.onConfirmation_a_Changed = function(confirmation_row) {
            $scope._clean_confirmation(confirmation_row.confirmation_b);
            $scope._clean_confirmation(confirmation_row.confirmation_c);
        };
        $scope.onConfirmation_b_Changed = function(translation_prefix, confirmation_row) {
            $scope._clean_confirmation(confirmation_row.confirmation_a);
            $scope._clean_confirmation(confirmation_row.confirmation_c);

            if (confirmation_row.confirmation_b.checked) {
                confirmation_row.confirmation_b.checked = false;
                modalAdapter.open($scope, 'lg', 'hfcs-verification-confirmation.html', 'HFCSCofirmationModalController',
                    {
                        "translation_prefix": translation_prefix,
                        "option": "b",
                        "confirmation": confirmation_row.confirmation_b,
                    },
                );
            }
        };
        $scope.onConfirmation_c_Changed = function(translation_prefix, confirmation_row) {
            $scope._clean_confirmation(confirmation_row.confirmation_a);
            $scope._clean_confirmation(confirmation_row.confirmation_b);

            if (confirmation_row.confirmation_c.checked) {
                confirmation_row.confirmation_c.checked = false;
                modalAdapter.open($scope, 'lg', 'hfcs-verification-confirmation.html', 'HFCSCofirmationModalController',
                    {
                        "translation_prefix": translation_prefix,
                        "option": "c",
                        "confirmation": confirmation_row.confirmation_c,
                    },
                );
            }
        }
    });
})();