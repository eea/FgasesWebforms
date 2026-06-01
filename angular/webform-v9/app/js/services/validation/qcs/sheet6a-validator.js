(function () {
    angular.module('FGases.services.validation.qcs').factory('sheet6aValidator', [
        '$translate', 'sheetTransactionValidator', 'sheetValidationObjectFactory', 'objectUtil', 'arrayUtil', 'stringUtil', 'numericUtil',
        function ($translate, sheetTransactionValidator, sheetValidationObjectFactory, objectUtil, arrayUtil, stringUtil, numericUtil) {

            function Sheet6aValidator() {
                var that = this;
                this.transactionValidations = [
                    {
                        transaction: {id: 'tr_07A', label: '07A'},
                        rules: [that._createRuleQc2409()]
                    },
                    {
                        transaction: { id: 'tr_07Aa', label: '7A_a' },
                        rules: [that._createRuleQc2105()]
                    }
                ];
            }
            Sheet6aValidator.prototype.validate = function(viewModel) {
                var transactionErrors = sheetTransactionValidator.validate(viewModel, this.transactionValidations);
                return transactionErrors;
            };
            Sheet6aValidator.prototype._createRuleQc2409 = function () {
                return {
                    qccode: 2409,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var gasAmounts = viewModel.sheet6.section7.getGasAmounts('tr_07A');
                        var that = this;

                        arrayUtil.forEach(gasAmounts, function (gasAmount) {
                            if (numericUtil.toNum(gasAmount.amount, 0) === 0 || !stringUtil.isEmpty(gasAmount.comment)) {
                                return;
                            }

                            var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                            error.gasIndex = gasAmount.index;
                            error.message = $translate.instant("validation_messages.qc_2409.error_text", {
                                gas: viewModel.getReportedGasById(gasAmount.id).Name,
                                section:"7A"
                            });
                            result.errors.push(error);
                        });

                        return result;
                    }
                };
            };

            Sheet6aValidator.prototype._createRuleQc2105 = function () {
                return {
                    qccode: 2105,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var gasAmounts7Aa = viewModel.sheet6.section7.getGasAmounts('tr_07Aa');
                        var that = this;

                        if (!viewModel.sheetActivities.isFU()) { // QC should only be applied if Feedstock user is selected
                            return result;
                        }

                        arrayUtil.forEach(gasAmounts7Aa, function (gasAmount7Aa) {
                            var reportedGas = viewModel.getReportedGasById(gasAmount7Aa.id);
                            if (!viewModel.sheet6.section7._isHfc23AndMixtures(reportedGas)) {
                                return result;
                            }
                            var tr_01C_a = viewModel.sheet1.section1.getTotalAmountForRow('tr_01A_fs', gasAmount7Aa.id);
                            if (numericUtil.toNum(tr_01C_a.amount, 0) > numericUtil.toNum(gasAmount7Aa.amount, 0)) {
                                if (stringUtil.isEmpty(gasAmount7Aa.comment)) { // if there isn't comment on 7A_a
                                    var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                    error.gasIndex = gasAmount7Aa.index;
                                    error.message = $translate.instant("validation_messages.qc_2105.error_text");
                                    result.errors.push(error);
                                } else { // with comment
                                    var flag = sheetValidationObjectFactory.createQcFlag('7A_a', that.qccode, gasAmount7Aa.id);
                                    result.flags.push(flag);
                                }
                            }
                            
                        });

                        return result;
                    }
                };
            };


            return new Sheet6aValidator();
        }
    ]);
})();

