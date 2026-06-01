(function() {
    angular.module('FGases.controllers').controller('CountrySpecificModalInstanceController', function($rootScope, $scope, $modalInstance, modalData, modalExtras) {


        $scope.countrySpecificModalTitle = modalExtras && typeof modalExtras.title !== 'undefined' ? modalExtras.title : 'common.country-specific-modal-title';
        $scope.countryValue = null;

        if (modalData[modalExtras.trCountries].Country == null || modalData[modalExtras.trCountries].Country == 'undefined') {
            modalData[modalExtras.trCountries].Country = [];
        }


        $scope.alerts = [];

        $scope.get_gas_by_id = function(gas_id) {
            for (var i = 0; i < $scope.instance.FGasesReporting.ReportedGases.length; i++) {
                if (gas_id === $scope.instance.FGasesReporting.ReportedGases[i].GasId) {
                    return $scope.instance.FGasesReporting.ReportedGases[i];
                }
            }
        }

        function CountrySpecAmountRow(countryId, amount) {
            this.CountryId = countryId;
            this.Amount = amount;

        }

        //define OK button action function
        $scope.ok = function(result) {
            $scope.alerts = [];
            var results = {};
            if ($scope.NoCountrySpecified == true) {
                // we could copy the code as done below(except the check for existing country), then push this non Existent Country, but we need to discuss further on how to proceed with this
                // with fotis and sylvie.
            } else if ($scope.countryValue != null) {

                var CountrySpec2ARow = {
                    CountryId: $scope.countryValue['@id'],
                    CountryName: $scope.countryValue.prefLabel[0]['@value']

                };

                // check if country added, already exists
                for (var j = 0; j < modalData[modalExtras.trCountries].Country.length; j++) {
                    if (CountrySpec2ARow.CountryId == modalData[modalExtras.trCountries].Country[j].CountryId) {
                        $scope.alerts = [];
                        var alert = {};
                        alert.type = 'danger';
                        alert.msg = 'Country Already exists';
                        $scope.alerts.push(alert);
                    }
                }

                if ($scope.alerts.length == 0) {
                    modalData[modalExtras.trCountries].Country.push(CountrySpec2ARow);
                    for (var i = 0; i < $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                        gas = $scope.get_gas_by_id($scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                        if ($scope.containsHFC(gas)) {
                            //   var CountrySpecAmountRow = {
                            //        CountryId: $scope.countryValue['@id'],
                            //        Amount: ""
                            //    };
                            //Initialize CountrySpecific Array for tr_02A if not exist 
                            for (var c = 0; c < modalExtras.trRows.length; c++) {
                                if ($scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][modalExtras.trRows[c]].CountrySpecific.Country == null || $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][modalExtras.trRows[c]].CountrySpecific.Country == 'undefined') {
                                    $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][modalExtras.trRows[c]].CountrySpecific.Country = [];
                                }
                                if ($scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][modalExtras.trRows[c]].CountrySpecific.Country != null && $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][modalExtras.trRows[c]].CountrySpecific.Country.constructor !== Array) {
                                    var tempCountryReporting = $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][modalExtras.trRows[c]].CountrySpecific.Country;
                                    $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][modalExtras.trRows[c]].CountrySpecific.Country = [];
                                    $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][modalExtras.trRows[c]].CountrySpecific.Country.push(tempCountryReporting);
                                }
                                //  angular.copy(CountrySpecAmountRow, $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][modalExtras.trRows[c]].CountrySpecific.Country);
                                //    var newCountrySpec = Object.create(CountrySpecAmountRow);
                                //  var newCountrySpec = new CountrySpecAmountRow($scope.countryValue['@id'],"");
                                let CountrySpecAmountRow = {
                                    CountryId: $scope.countryValue['@id'],
                                    Amount: ""
                                };
                                $scope.instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][modalExtras.trRows[c]].CountrySpecific.Country.push(CountrySpecAmountRow);
                            }
                        }
                    }

                }
            }

            if ($scope.alerts.length == 0) {
                //         if (modalData != null) {
                //            modalData.push($scope.countryValue);
                //      }
                results.Country = $scope.countryValue;
                $modalInstance.close(results);
            }
        }; //end of ok function

        //define CANCEL button action function
        $scope.cancel = function() {
            $modalInstance.dismiss('cancel');
        }; //end of cancel function
    });
})();