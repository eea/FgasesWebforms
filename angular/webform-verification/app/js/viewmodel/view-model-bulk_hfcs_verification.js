
(function() {
    angular.module('FGases.viewmodel').factory('ViewModelBulkHFCsVerification', [

        'ViewModelObjectBase', 'objectUtil',

        function(ViewModelObjectBase, objectUtil) {

            function ViewModelBulkHFCsVerification(viewModel) {
                if (!(this instanceof ViewModelBulkHFCsVerification)) {
                    return new ViewModelBulkHFCsVerification(viewModel);
                }

                ViewModelObjectBase.call(this, viewModel);
            }

            objectUtil.chainConstructor(ViewModelObjectBase, ViewModelBulkHFCsVerification);

            return ViewModelBulkHFCsVerification;
        }
    ]);
})();
