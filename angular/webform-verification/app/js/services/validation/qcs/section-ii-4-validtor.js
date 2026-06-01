
(function() {
    angular.module('FGases.services.validation.qcs').factory('SectionII4Validator', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        
        function ($translate, sheetValidationObjectFactory, sheetTransactionValidator) {
            
            function SectionII4Validator(validation_id, validation_label) {
                var that = this;
                this.transactionValidations = {
                    transaction: { id: validation_id, label: validation_label },
                    rules: [
                        that._createRuleQC3017(),

                        that._createRuleQC3018(),
                        that._createRuleQC3019(),
                        that._createRuleQC3020(),
                        that._createRuleQC3021(),

                        that._createRuleQC3022(),
                        that._createRuleQC3023(),
                        that._createRuleQC3024(),
                        that._createRuleQC3025(),
                    ]
                };
            }
            
            SectionII4Validator.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };
            
            SectionII4Validator.prototype._createRuleQC3017 = function() {
                return {
                    qccode: '3017',
                    _validate: function(option) {
                        return (option.option);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        if (!this._validate(section4.option_a)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                part: 'Part 1',
                            });
                            error.gasIndex = 'section-II-4-option-a';
                            result.errors.push(error);
                        }
                        if (!this._validate(section4.option_b)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                part: 'Part 2',
                            });
                            error.gasIndex = 'section-II-4-option-b';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            
            SectionII4Validator.prototype._createRuleQC3018 = function() {
                return {
                    qccode: '3018',
                    _validate: function(option, tr_13D, tr_13D_confirmation) {
                        if (option.option == '1') {
                            if (parseFloat(tr_13D.tco2e) == 0 || tr_13D_confirmation.confirmation_c.checked) {
                                return (!isEmpty(option.reason_1) && option.reason_1.length >= 5);
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_13D = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
                        let tr_13D_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_13D'];

                        if (!this._validate(section4.option_a, tr_13D, tr_13D_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a-1';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            SectionII4Validator.prototype._createRuleQC3019 = function() {
                return {
                    qccode: '3019',
                    _validate: function(option, tr_13D) {
                        if (option.option == '2') {
                            if (parseFloat(tr_13D.tco2e) == 0) {
                                return (!isEmpty(option.reason_2) && option.reason_2.length >= 5);
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_13D = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];

                        if (!this._validate(section4.option_a, tr_13D)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a-2';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            SectionII4Validator.prototype._createRuleQC3020 = function() {
                return {
                    qccode: '3020',
                    _validate: function(option, tr_13D, tr_13D_confirmation) {
                        if (option.option == '3') {
                            if (parseFloat(tr_13D.tco2e) <= 0) {
                                if (tr_13D_confirmation.confirmation_a.checked || tr_13D_confirmation.confirmation_b.checked) {
                                    return (!isEmpty(option.reason_3) && option.reason_3.length >= 5);
                                }
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_13D = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
                        let tr_13D_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_13D'];

                        if (!this._validate(section4.option_a, tr_13D, tr_13D_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a-3';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            SectionII4Validator.prototype._createRuleQC3021 = function() {
                return {
                    qccode: '3021',
                    _validate: function(option, tr_13D, tr_13D_confirmation) {
                        if (tr_13D_confirmation.confirmation_a.checked || tr_13D_confirmation.confirmation_b.checked) {
                            if (parseFloat(tr_13D.tco2e) > 0) {
                                if (option.option == '2' || option.option == '3') {
                                    return false
                                }
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_13D = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
                        let tr_13D_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_13D'];

                        if (!this._validate(section4.option_a, tr_13D, tr_13D_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            
            SectionII4Validator.prototype._createRuleQC3022 = function() {
                return {
                    qccode: '3022',
                    _validate: function(option, tr_12A, tr_12A_confirmation) {
                        if (option.option == '1') {
                            if (parseFloat(tr_12A.tco2e) == 0 || tr_12A_confirmation.confirmation_c.checked) {
                                return (!isEmpty(option.reason_1) && option.reason_1.length >= 5);
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12A = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
                        let tr_12A_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];

                        if (!this._validate(section4.option_b, tr_12A, tr_12A_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-b-1';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            SectionII4Validator.prototype._createRuleQC3023 = function() {
                return {
                    qccode: '3023',
                    _validate: function(option, tr_12A) {
                        if (option.option == '2') {
                            if (parseFloat(tr_12A.tco2e) == 0) {
                                return (!isEmpty(option.reason_2) && option.reason_2.length >= 5);
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12A = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];

                        if (!this._validate(section4.option_b, tr_12A)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-b-2';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            SectionII4Validator.prototype._createRuleQC3024 = function() {
                return {
                    qccode: '3024',
                    _validate: function(option, tr_12A, tr_12A_confirmation) {
                        if (option.option == '3') {
                            if (parseFloat(tr_12A.tco2e) <= 0) {
                                if (tr_12A_confirmation.confirmation_a.checked || tr_12A_confirmation.confirmation_b.checked) {
                                    return (!isEmpty(option.reason_3) && option.reason_3.length >= 5);
                                }
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12A = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
                        let tr_12A_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];

                        if (!this._validate(section4.option_b, tr_12A, tr_12A_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a-3';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            SectionII4Validator.prototype._createRuleQC3025 = function() {
                return {
                    qccode: '3025',
                    _validate: function(option, tr_12A, tr_12A_confirmation) {
                        if (tr_12A_confirmation.confirmation_a.checked || tr_12A_confirmation.confirmation_b.checked) {
                            if (parseFloat(tr_12A.tco2e) > 0) {
                                if (option.option == '2' || option.option == '3') {
                                    return false
                                }
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12A = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
                        let tr_12A_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];

                        if (!this._validate(section4.option_b, tr_12A, tr_12A_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            return SectionII4Validator;
        }
    ]);
})();
