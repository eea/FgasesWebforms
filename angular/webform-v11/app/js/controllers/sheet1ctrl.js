(function() {

    angular.module('FGases.controllers').controller('Sheet1Ctrl', function($rootScope, $scope) {
        $scope.txids = [];
        $scope.txids_12aA = [];
        $scope.onlyNumbers = /\d+\.?\d*/;
        $scope.emptyTransaction;
        $scope.tr2AcountrySpecificGases = [];
        var F1_S1_4_ProdImpExpTrCountries = ["tr_01A_fs_Countries","tr_02A_Countries","tr_03A_Countries"];

        //Initialize Country Arrays 
        for (var f = 0; f < F1_S1_4_ProdImpExpTrCountries.length; f++) {


            if ($scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[F1_S1_4_ProdImpExpTrCountries[f]] == null) {
                var Country = {};
                $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[F1_S1_4_ProdImpExpTrCountries[f]] = Country;
            }

            if ($scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[F1_S1_4_ProdImpExpTrCountries[f]].Country == null || $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[F1_S1_4_ProdImpExpTrCountries[f]].Country == 'undefined') {
                $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[F1_S1_4_ProdImpExpTrCountries[f]].Country = [];

            }
            if ($scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[F1_S1_4_ProdImpExpTrCountries[f]].Country != null && $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[F1_S1_4_ProdImpExpTrCountries[f]].Country.constructor !== Array) {
                //We got A Country Object but not an Array. SO we convert it.
                var tempCountry = $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[F1_S1_4_ProdImpExpTrCountries[f]].Country;
                $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[F1_S1_4_ProdImpExpTrCountries[f]].Country = [];
                $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[F1_S1_4_ProdImpExpTrCountries[f]].Country.push(tempCountry);

            }
        }

        $scope.get_gas_by_id = function(gas_id) {
            for (var i = 0; i < $scope.instance.FGasesReporting.ReportedGases.length; i++) {
                if (gas_id === $scope.instance.FGasesReporting.ReportedGases[i].GasId) {
                    return $scope.instance.FGasesReporting.ReportedGases[i];
                }
            }
        }

        //Convert Gases With Country Specific, To Contain Country Array.
        for (var i = 0; i < $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
            gas = $scope.get_gas_by_id($scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
          //  if ($scope.containsHFC(gas)) //(modalExtras.trCountries == "tr_01A_fs_Countries")) $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[F1_S1_4_ProdImpExpTrCountries[f]] {
           // {

                //Initialize CountrySpecific Arrays
            var HFCCountrySpecificGasRows = ["tr_01A_fs", "tr_01A_fs1", "tr_01A_fs2","tr_02A", "tr_02App", "tr_02C", "tr_02D", "tr_02E","tr_03A","tr_03App","tr_03G","tr_03H","tr_03I"];
                for (var g = 0; g < HFCCountrySpecificGasRows.length; g++) {
                    if ($scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][HFCCountrySpecificGasRows[g]].CountrySpecific != null) {
                        if ($scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][HFCCountrySpecificGasRows[g]].CountrySpecific.Country != null && $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][HFCCountrySpecificGasRows[g]].CountrySpecific.Country.constructor !== Array) {
                            var tempCountryReporting = $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][HFCCountrySpecificGasRows[g]].CountrySpecific.Country;
                            $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][HFCCountrySpecificGasRows[g]].CountrySpecific.Country = [];
                            $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][HFCCountrySpecificGasRows[g]].CountrySpecific.Country.push(tempCountryReporting);
                        }
                    }
                }
           // }
        }

        $scope.remove_Country = function(countryIndex, country, section) {
            var sectionToCountryRows = {
                "tr_01A_fs_Countries": ["tr_01A_fs", "tr_01A_fs1", "tr_01A_fs2"],
                "tr_02A_Countries": ["tr_02A", "tr_02App", "tr_02C", "tr_02D", "tr_02E"],
                "tr_03A_Countries": ["tr_03A","tr_03App","tr_03G","tr_03H","tr_03I"]
            };

            if (countryIndex > -1) {
                if ($scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[section].Country != null && 
                    $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[section].Country.constructor === Array) {

                    $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp[section].Country.splice(countryIndex, 1);
                    //Remove the Gas CountrySpecific country
                    for (var i = 0; i < $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                        gas = $scope.get_gas_by_id($scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                        if ($scope.containsHFC(gas)) {
                            for (var k = 0; k < sectionToCountryRows[section].length; k++) {
                                var countryRow = sectionToCountryRows[section][k];
                                if ($scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][countryRow].CountrySpecific.Country != null && $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][countryRow].CountrySpecific.Country.constructor === Array) {
                                    $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][countryRow].CountrySpecific.Country.splice(countryIndex, 1);
                                    $scope.doCalculationTotalForRow('F1_S1_4_ProdImpExp', countryRow);
                                }
                            }
                        }
                    }   
                }
            }
        }

    });
})();