
(function() {
    angular.module('FGases.viewmodel').factory('ViewModelEquipmentCtrl', [

        'ViewModelObjectBase', 'objectUtil',

        function(ViewModelObjectBase, objectUtil) {

            function ViewModelEquipmentCtrl(viewModel) {
                if (!(this instanceof ViewModelEquipmentCtrl)) {
                    return new ViewModelEquipmentCtrl(viewModel);
                }

                ViewModelObjectBase.call(this, viewModel);
            }

            objectUtil.chainConstructor(ViewModelObjectBase, ViewModelEquipmentCtrl);

            return ViewModelEquipmentCtrl;
        }
    ]);
})();
