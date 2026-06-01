(function() {

  function empty_if_null(val) {
    // handle NaN, null, undefined, etc..
    return (!val && val !== 0) ? '' : val;
  }

    angular.module('FGases.controllers')
        .controller('SheetGasCtrl', function ($rootScope, $scope) {

            $scope.updateReportedGasesValues();
            //$scope.calculateForm7Totals();

      });
})();

