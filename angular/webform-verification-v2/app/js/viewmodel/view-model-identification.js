
(function() {
    angular.module('FGases.viewmodel').factory('ViewModelIdentificationCtrl', [

        'ViewModelObjectBase', 'objectUtil',

        function(ViewModelObjectBase, objectUtil) {

            function ViewModelIdentificationCtrl(viewModel) {
                if (!(this instanceof ViewModelIdentificationCtrl)) {
                    return new ViewModelIdentificationCtrl(viewModel);
                }

                ViewModelObjectBase.call(this, viewModel);
            }

            objectUtil.chainConstructor(ViewModelObjectBase, ViewModelIdentificationCtrl);

            return ViewModelIdentificationCtrl;
        }
    ]);
})();
