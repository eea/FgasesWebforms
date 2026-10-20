(function() {

  function empty_if_null(val) {
    // handle NaN, null, undefined, etc..
    return (!val && val !== 0) ? '' : val;
  }

    angular.module('FGases.controllers')
        .controller('Sheet9Ctrl', function ($rootScope, $scope) {

        $scope.$watch('authorisationData', function (authorisationData) {
            $scope.instance.FGasesReporting.F9_S13.AuthBalance.Code = authorisationData ? $scope.authorisationData.authorisation['@companyId'] : null;
            $scope.instance.FGasesReporting.F9_S13.AuthBalance.Amount = authorisationData ? parseFloat($scope.authorisationData.authorisation.AuthBalance) : null;
            $scope.instance.FGasesReporting.F9_S13.tr_13A_date = authorisationData ? $scope.authorisationData.authorisation.ExtractDate : null;
        });
        // runs on each scope update
        $scope.gases = $scope.instance.FGasesReporting.F8_S12.Gas;

        $scope.tr_13a = function () {
            var value = $scope.instance.FGasesReporting.F9_S13.AuthBalance.Amount;
            //return value ? parseFloat(value).toFixed(3) : '';
            return value ? parseInt(value) : '';
        };

        $scope.tr_13b = function () {
            var for_gwp = $scope.gases.map(function (gas) {
                return {
                    Id: gas.GasCode,
                    Amount: Number(gas.Totals.tr_12bA) || 0
                };
            });

            var result = $scope.calculateSumAllHFCGasesCO2Eq(for_gwp);

            if ($scope.instance.FGasesReporting.F9_S13.Totals.tr_13B)
                $scope.instance.FGasesReporting.F9_S13.Totals.tr_13B.Amount = result;

            return result;
        };
        $scope.tr_13Ba = function () {
            var for_gwp = $scope.gases.map(function (gas) {
                return {
                    Id: gas.GasCode,
                    Amount: Number(gas.Totals.tr_12bB) || 0
                };
            });

            var result = $scope.calculateSumAllHFCGasesCO2Eq(for_gwp);

            if ($scope.instance.FGasesReporting.F9_S13.Totals.tr_13Ba)
                $scope.instance.FGasesReporting.F9_S13.Totals.tr_13Ba.Amount = result;

            return result;

        };
        $scope.tr_13Bb = function () {
            var for_gwp = $scope.gases.map(function (gas) {
                return {
                    Id: gas.GasCode,
                    Amount: Number(gas.Totals.tr_12Ca) || 0
                };
            });

            var result = $scope.calculateSumAllHFCGasesCO2Eq(for_gwp);

            if ($scope.instance.FGasesReporting.F9_S13.Totals.tr_13Bb)
                $scope.instance.FGasesReporting.F9_S13.Totals.tr_13Bb.Amount = result;

            return result;

        };

        $scope.tr_13c = function () {
            var for_gwp_tr_12A = $scope.gases.map(function (gas) {
                return {
                    Id: gas.GasCode,
                    Amount: Number(gas.tr_12A.SumOfPartnersAmount) || 0
                };
            });

            var for_gwp_tr_12aA = $scope.gases.map(function (gas) {
                return {
                    Id: gas.GasCode,
                    Amount: Number(gas.tr_12aA.SumOfPartnersAmount) || 0
                };
            });

            var sum_tr_12A = $scope.calculateSumAllHFCGasesCO2Eq(for_gwp_tr_12A);
            var sum_tr_12aA = $scope.calculateSumAllHFCGasesCO2Eq(for_gwp_tr_12aA);

            var total = sum_tr_12A + sum_tr_12aA;

            if ($scope.instance.FGasesReporting.F9_S13.Totals.tr_13C)
                $scope.instance.FGasesReporting.F9_S13.Totals.tr_13C.Amount = total;

            return total;
        };

        $scope.tr_13Ca = function () {
            var for_gwp_tr_12B = $scope.gases.map(function (gas) {
                return {
                    Id: gas.GasCode,
                    Amount: Number(gas.tr_12B.SumOfPartnersAmount) || 0
                };
            });

            var for_gwp_tr_12aB = $scope.gases.map(function (gas) {
                return {
                    Id: gas.GasCode,
                    Amount: Number(gas.tr_12aB.SumOfPartnersAmount) || 0
                };
            });

            var sum_tr_12B = $scope.calculateSumAllHFCGasesCO2Eq(for_gwp_tr_12B);
            var sum_tr_12aB = $scope.calculateSumAllHFCGasesCO2Eq(for_gwp_tr_12aB);

            var total = sum_tr_12B + sum_tr_12aB;

            if ($scope.instance.FGasesReporting.F9_S13.Totals.tr_13Ca)
                $scope.instance.FGasesReporting.F9_S13.Totals.tr_13Ca.Amount = total;

            return total;
        };


        $scope.tr_13d = function () {

            var for_gwp = $scope.gases.map(function (gas) {
                return {
                    Id: gas.GasCode,
                    Amount: Number(gas.Totals.tr_12C) || 0
                };
            });

            var result = $scope.calculateSumAllHFCGasesCO2Eq(for_gwp);

            if ($scope.instance.FGasesReporting.F9_S13.Totals.tr_13D)
                $scope.instance.FGasesReporting.F9_S13.Totals.tr_13D.Amount = result;

            return result;

        };

        $scope.tr_13e1 = function () {
            var value = $scope.instance.FGasesReporting.F9_S13.AuthBalance.Amount;
            var finalValue = value ? parseInt(value) : ''
            if ($scope.instance.FGasesReporting.F9_S13.Totals.tr_13E1)
                $scope.instance.FGasesReporting.F9_S13.Totals.tr_13E1.Amount = finalValue;
            return finalValue;
        };

        $scope.tr_13e2 = function () {
            var tr13e2_value = 0;
            var tr13e1_value = 0;
            var tr13d_value = 0;
            if ($scope.instance.FGasesReporting.F9_S13.Totals.tr_13E1)
                tr13e1_value = parseInt($scope.instance.FGasesReporting.F9_S13.Totals.tr_13E1.Amount || 0);
            if ($scope.instance.FGasesReporting.F9_S13.Totals.tr_13D)
                tr13d_value = parseInt($scope.instance.FGasesReporting.F9_S13.Totals.tr_13D.Amount || 0);
            tr13e2_value = tr13e1_value - tr13d_value;
            if ($scope.instance.FGasesReporting.F9_S13.Totals.tr_13E2)
                $scope.instance.FGasesReporting.F9_S13.Totals.tr_13E2.Amount = tr13e2_value;

            return tr13e2_value;

        };


      });
})();

