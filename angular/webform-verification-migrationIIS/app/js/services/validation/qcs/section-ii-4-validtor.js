
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
                        that._createRuleQC3030(),
                        that._createRuleQC3031(),
                        that._createRuleQC3032(),
                       /* that._createRuleQC3033(),*/
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
                        if (!this._validate(section4.option_c)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                part: 'Part 3',
                            });
                            error.gasIndex = 'section-II-4-option-c';
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
                            if (parseFloat(tr_13D.tco2e) <= 0) {
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
                    _validate: function (section3,option, tr_13D, tr_13D_confirmation) {
                        let section3_check = (section3.confirmation_a.checked || section3.confirmation_b.checked);
                        if ((tr_13D_confirmation.confirmation_a.checked || tr_13D_confirmation.confirmation_b.checked)&& section3_check ){
                            
                            if (parseFloat(tr_13D.tco2e) > 0) {
                                if (option.option == '2') {// || option.option == '3'
                                    return false
                                }
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section3 = viewModel._instance.Verification.EquipmentHFCs.section_II_3;
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_13D = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
                        let tr_13D_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_13D'];

                        if (!this._validate(section3,section4.option_a, tr_13D, tr_13D_confirmation)) {
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
                    _validate: function(option, tr_12A, tr_12B, tr_12A_confirmation, tr_12B_confirmation) {
                        if (option.option == '1') {                           
                            if ((parseFloat(tr_12A.tco2e) == 0 && parseFloat(tr_12B.tco2e) == 0) || (tr_12A_confirmation.confirmation_c.checked || tr_12B_confirmation.confirmation_c.checked)) {
                                return (!isEmpty(option.reason_1) && option.reason_1.length >= 5);
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12A = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
                        let tr_12B = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];
                        let tr_12A_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];
                        let tr_12B_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12B'];

                        if (!this._validate(section4.option_b, tr_12A, tr_12B, tr_12A_confirmation, tr_12B_confirmation)) {
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
                    _validate: function(option, tr_12A, tr_12B) {
                        if (option.option == '2') {
                            if ((parseFloat(tr_12A.tco2e) == 0) && (parseFloat(tr_12B.tco2e) == 0)) {
                                return (!isEmpty(option.reason_2) && option.reason_2.length >= 5);
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12A = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
                        let tr_12B = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];

                        if (!this._validate(section4.option_b, tr_12A, tr_12B)) {
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
                    _validate: function(option, tr_12A, tr_12B, tr_12A_confirmation, tr_12B_confirmation) {
                        if (option.option == '3') {
                            let check_12A = (parseFloat(tr_12A.tco2e) > 0) && (tr_12A_confirmation.confirmation_a.checked || tr_12A_confirmation.confirmation_b.checked);
                            let check_12B = (parseFloat(tr_12B.tco2e) > 0) && (tr_12B_confirmation.confirmation_a.checked || tr_12B_confirmation.confirmation_b.checked);
                            if ((check_12A) || (check_12B)) {
                                return (!isEmpty(option.reason_3) && option.reason_3.length >= 5);
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12A = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
                        let tr_12B = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];
                        let tr_12A_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];
                        let tr_12B_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12B'];

                        if (!this._validate(section4.option_b, tr_12A, tr_12B, tr_12A_confirmation, tr_12B_confirmation)) {
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
                    _validate: function(option, section3, tr_12A, tr_12B, tr_12A_confirmation, tr_12B_confirmation) {
                        let tr_12A_check = (tr_12A_confirmation.confirmation_a.checked || tr_12A_confirmation.confirmation_b.checked) && (parseFloat(tr_12A.tco2e) > 0);
                        let tr_12B_check = (tr_12B_confirmation.confirmation_a.checked || tr_12B_confirmation.confirmation_b.checked) && (parseFloat(tr_12B.tco2e) > 0);
                        let section3_check = (section3.confirmation_a.checked || section3.confirmation_b.checked);
                        if ((tr_12A_check || tr_12B_check) && section3_check) {
                            if (option.option == '2' || option.option == '3') {
                                return false;
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section3 = viewModel._instance.Verification.EquipmentHFCs.section_II_3;
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12A = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
                        let tr_12B = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];
                        let tr_12A_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];
                        let tr_12B_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12B'];

                        if (!this._validate(section4.option_b, section3, tr_12A, tr_12B, tr_12A_confirmation, tr_12B_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            SectionII4Validator.prototype._createRuleQC3030 = function () {
                return {
                    qccode: '3030',
                    _validate: function (option, tr_12aA, tr_12aB, tr_12aA_confirmation, tr_12aB_confirmation) {
                        
                        if (option.option == '1') {                           
                            if ((parseFloat(tr_12aA.tco2e) == 0 && parseFloat(tr_12aB.tco2e) == 0) || (tr_12aA_confirmation.confirmation_c.checked || tr_12aB_confirmation.confirmation_c.checked)) {
                                return (!isEmpty(option.reason_1) && option.reason_1.length >= 5);
                            }
                        }
                        
                        
                        return true;
                    },
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12aA = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
                        let tr_12aB = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];
                        let tr_12aA_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12aA'];
                        let tr_12aB_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12aB'];

                        if (!this._validate(section4.option_c, tr_12aA, tr_12aB, tr_12aA_confirmation, tr_12aB_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-c-1';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            SectionII4Validator.prototype._createRuleQC3031 = function () {
                return {
                    qccode: '3031',
                    _validate: function (option, tr_12aA, tr_12aB) {

                        if (option.option == '2') {
                            if ((parseFloat(tr_12aA.tco2e) == 0 && parseFloat(tr_12aB.tco2e) == 0) ) {
                                return (!isEmpty(option.reason_2) && option.reason_2.length >= 5);
                            }
                        }


                        return true;
                    },
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12aA = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
                        let tr_12aB = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];
                       

                        if (!this._validate(section4.option_c, tr_12aA, tr_12aB)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-c-2';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            SectionII4Validator.prototype._createRuleQC3032 = function () {
                return {
                    qccode: '3032',
                    _validate: function (option, tr_12aA, tr_12aB, tr_12aA_confirmation, tr_12aB_confirmation) {

                        if (option.option == '3') {
                            if ((parseFloat(tr_12aA.tco2e) > 0 || parseFloat(tr_12aB.tco2e) > 0) && (tr_12aA_confirmation.confirmation_a.checked || tr_12aB_confirmation.confirmation_a.checked || tr_12aA_confirmation.confirmation_b.checked || tr_12aB_confirmation.confirmation_b.checked)) {
                                return (!isEmpty(option.reason_3) && option.reason_3.length >= 5);
                            }
                        }


                        return true;
                    },
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12aA = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
                        let tr_12aB = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];
                        let tr_12aA_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12aA'];
                        let tr_12aB_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12aB'];

                        if (!this._validate(section4.option_c, tr_12aA, tr_12aB, tr_12aA_confirmation, tr_12aB_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-c-1';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
          /*  SectionII4Validator.prototype._createRuleQC3033 = function () {
                return {
                    qccode: '3033',
                    _validate: function (section3, section4, tr_12aA, tr_12aA_confirmation, tr_12aB, tr_12aB_confirmation) {
                        if (section4.option_c.option == '2' || section4.option_c.option == '3') {
                            if (section3.confirmation_a.checked || section3.confirmation_b.checked) {
                                if ((parseFloat(tr_12aA.tco2e) > 0) && (tr_12aA_confirmation.confirmation_a.checked || tr_12aA_confirmation.confirmation_b.checked)) {
                                    return false;
                                }
                                if ((parseFloat(tr_12aB.tco2e) > 0) && (tr_12aB_confirmation.confirmation_a.checked || tr_12aB_confirmation.confirmation_b.checked)) {
                                    return false;
                                }
                            }
                        }
                        return true;
                    },
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section3 = viewModel._instance.Verification.EquipmentHFCs.section_II_3;
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12aA = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
                        let tr_12aB = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];
                        let tr_12aA_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12aA'];
                        let tr_12aB_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12aB'];

                        if (!this._validate(section3, section4, tr_12aA, tr_12aA_confirmation, tr_12aB, tr_12aB_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = `section-II-4-option-c-${section4.option_c.option}`;
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };*/
            return SectionII4Validator;
        }
    ]);
})();
