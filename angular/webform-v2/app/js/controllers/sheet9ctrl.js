(function() {

  function empty_if_null(val) {
    // handle NaN, null, undefined, etc..
    return (!val && val !== 0) ? '' : val;
  }

  angular.module('FGases.controllers')
    .controller('Sheet9Ctrl', function($rootScope, $scope){

      $scope.$watch('authorisationData', function(authorisationData){
        $scope.instance.FGasesReporting.F9_S13.AuthBalance.Code = authorisationData ? $scope.authorisationData.authorisation['@companyId'] : null;
        $scope.instance.FGasesReporting.F9_S13.AuthBalance.Amount = authorisationData ? parseFloat($scope.authorisationData.authorisation.AuthBalance) : null;
      });
      // runs on each scope update
      $scope.gases = $scope.instance.FGasesReporting.F8_S12.Gas;

      $scope.tr_13a = function() {
        var value = $scope.instance.FGasesReporting.F9_S13.AuthBalance.Amount;
        return value ? parseFloat(value).toFixed(3) : '';
      };

      $scope.tr_13b = function() {
        var for_gwp = $scope.gases.map(function(gas) {
          return {
            Id: gas.GasCode,
            Amount: gas.Totals.tr_12B
          };
        });

        var result = empty_if_null($scope.calculateSumAllHFCGasesCO2Eq(for_gwp));
        $scope.instance.FGasesReporting.F9_S13.Totals.tr_13B.Amount = result;

        return result;
      };

      $scope.tr_13c = function() {
        var for_gwp = $scope.gases.map(function(gas) {
          return {
            Id: gas.GasCode,
            Amount: gas.tr_12A.SumOfPartnersAmount
          };
        });

        var result = empty_if_null($scope.calculateSumAllHFCGasesCO2Eq(for_gwp));
        $scope.instance.FGasesReporting.F9_S13.Totals.tr_13C.Amount = result;

        return result;
      };

      $scope.tr_13d = function() {
        var for_gwp = $scope.gases.map(function(gas) {
          return {
            Id: gas.GasCode,
            Amount: gas.Totals.tr_12C
          };
        });

        var result = empty_if_null($scope.calculateSumAllHFCGasesCO2Eq(for_gwp));
        $scope.instance.FGasesReporting.F9_S13.Totals.tr_13D.Amount = result;

        return result;
      };

    });
})();
