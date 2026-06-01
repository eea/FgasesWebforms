(function () {
    angular.module('FGases.services.validation.qcs').factory('sheet8Validator', [
        '$translate', 'sheetTransactionValidator', 'sheetValidationObjectFactory', 'objectUtil', 'arrayUtil', 'stringUtil', 'numericUtil',
        function ($translate, sheetTransactionValidator, sheetValidationObjectFactory, objectUtil, arrayUtil, stringUtil, numericUtil) {

            function Sheet8Validator() {
                var that = this;
                this.transactionValidations = [
                    {
                        transaction: {id: 'tr_12C', label: 'tr_12C'},
                        rules: [
                            that._createRuleQc21201(),
                            that._createRuleCheckIntegrityQC2201()
                        ]
                    }, {
                        transaction: { id: 'tr_12cA', label: 'tr_12cA' },
                        rules: [
                            that._createRuleQc21213()
                        ]
                    }, {
                        transaction: { id: 'tr_12cB', label: 'tr_12cB' },
                        rules: [
                            that._createRuleQc21214()
                        ]
                    }
                ];
            }
            Sheet8Validator.prototype.validate = function(viewModel) {
                var transactionErrors = sheetTransactionValidator.validate(viewModel, this.transactionValidations);
                return transactionErrors;
            };
            Sheet8Validator.prototype._createRuleQc21201 = function () {
                return {
                    qccode: 21201,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        var section_data = viewModel.sheet8.section12.getSectionData();

                        arrayUtil.forEach(section_data.Gas, function (gas12) {
                            var amount12C = parseFloat(gas12.Totals.tr_12C);
                            if (amount12C < 0) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.message = $translate.instant("validation_messages.qc_21201.error_text", {
                                    gas: viewModel.getReportedGasById(gas12.GasCode).Name
                                });
                                result.errors.push(error);
                            }
                        });
                        return result;
                    }
                };
            };
            Sheet8Validator.prototype._createRuleCheckIntegrityQC2201 = function () {
                return {
                    qccode: [2201],
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var section_data = viewModel.sheet8.section12.getSectionData();
                        var rep_gases = viewModel.getReportedGases();
                        var is_rachp = viewModel.sheetActivities.isEq_I_RACHP_HFC();
                        if (is_rachp && rep_gases.length !== section_data.Gas.length) {
                            var qc2201_error = sheetValidationObjectFactory.createValidationError(2201);
                            qc2201_error.message = $translate.instant("validation_messages.qc_2201.error_text");
                            result.errors.push(qc2201_error);
                        }
                        return result;
                    }
                };
            };
            Sheet8Validator.prototype._createRuleQc21213 = function () {
                return {
                    qccode: 21213,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        var section_data = viewModel.sheet8.section12.getSectionData();

                        arrayUtil.forEach(section_data.Gas, function (gas12) {
                            var amount12cA = parseFloat(gas12.Totals.tr_12cA);
                            if (amount12cA < 0) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.message = $translate.instant("validation_messages.qc_21213.error_text", {
                                    gas: viewModel.getReportedGasById(gas12.GasCode).Name
                                });
                                result.errors.push(error);
                            }
                        });
                        return result;

                    }
                };
            };
            Sheet8Validator.prototype._createRuleQc21214 = function () {
                return {
                    qccode: 21214,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        var section_data = viewModel.sheet8.section12.getSectionData();

                        arrayUtil.forEach(section_data.Gas, function (gas12) {
                            var amount12cB = parseFloat(gas12.Totals.tr_12cB);
                            if (amount12cB < 0) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.message = $translate.instant("validation_messages.qc_21214.error_text", {
                                    gas: viewModel.getReportedGasById(gas12.GasCode).Name
                                });
                                result.errors.push(error);
                            }
                        });
                        return result;

                    }
                };
            };
            return new Sheet8Validator();
        }
    ]);
})();

