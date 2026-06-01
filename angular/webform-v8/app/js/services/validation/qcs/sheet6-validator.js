(function () {
    angular.module('FGases.services.validation.qcs').factory('sheet6Validator', [
        '$translate', 'sheetTransactionValidator', 'sheetValidationObjectFactory', 'objectUtil', 'arrayUtil', 'stringUtil', 'numericUtil',
        function ($translate, sheetTransactionValidator, sheetValidationObjectFactory, objectUtil, arrayUtil, stringUtil, numericUtil) {

            function Sheet6Validator() {
                var that = this;
                this.transactionValidations = [
                    {
                        transaction: {id: 'tr_07A', label: '07A'},
                        rules: [that._createRuleQc2409()]
                    }, {
                        transaction: { id: 'tr_08C', label: '08C' },
                        rules: [that._createRuleQc2456()]
                    }
                ];
            }
            Sheet6Validator.prototype.validate = function(viewModel) {
                var transactionErrors = sheetTransactionValidator.validate(viewModel, this.transactionValidations);
                return transactionErrors;
            };
            Sheet6Validator.prototype._createRuleQc2409 = function () {
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

            /**8C comment validator  */
            Sheet6Validator.prototype._createRuleQc2456 = function () {
                return {
                    qccode: 2456,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var gasAmounts = viewModel.sheet6.section8.getGasAmounts('tr_08C');
                        var that = this;

                        arrayUtil.forEach(gasAmounts, function (gasAmount) {
                            var amount = gasAmount.amount;
                            if (objectUtil.isNull(amount) || amount === 0 || !stringUtil.isEmpty(gasAmount.comment)) {
                                if (!stringUtil.isEmpty(gasAmount.comment)) {
                                    // 8C value with comment => create flag
                                    var flag = sheetValidationObjectFactory.createQcFlag('08C', that.qccode, gasAmount.id);
                                    result.flags.push(flag);
                                }
                            } else {    // 8C value without comment
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount.index;
                                error.message = $translate.instant("validation_messages.qc_2456.error_text");
                                result.errors.push(error);
                            }
                        });

                        return result;
                    }
                };
            };
            /**END 8C comment validator  */

            return new Sheet6Validator();
        }
    ]);
})();

