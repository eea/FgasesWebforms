
(function() {
    angular.module('FGases.services.validation.qcs').factory('Section3Validator', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        
        function ($translate, sheetValidationObjectFactory, sheetTransactionValidator) {
            
            function Section3Validator(validation_id, validation_label, section_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                var that = this;

                if (validation_id == 'bulk-hfcs-verification') {
                    this.transactionValidations = {
                        transaction: { id: validation_id, label: validation_label },
                        rules: [
                            that._createRuleQC3000(section_name, section3_Identifier),
                            that._createRuleQC3001(section_name, section1_Identifier, section2_Identifier, section3_Identifier),
                            that._createRuleQC3002(section_name, section1_Identifier, section2_Identifier, section3_Identifier),
                            that._createRuleQC3003(section_name, section1_Identifier, section2_Identifier, section3_Identifier),
                        ]
                    };
                }
                if (validation_id == 'equipment-verification') {
                    this.transactionValidations = {
                        transaction: { id: validation_id, label: validation_label },
                        rules: [
                            that._createRuleQC3000(section_name, section3_Identifier),
                            that._createRuleQC3013(section2_Identifier, section3_Identifier),
                            that._createRuleQC3014(section2_Identifier, section3_Identifier),
                            that._createRuleQC3015(section3_Identifier),
                            that._createRuleQC3016(section3_Identifier),
                        ]
                    };
                }
            }
            
            Section3Validator.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };

            Section3Validator._getSection = function(viewModel, sectionIdentifier) {
                let section = viewModel._instance.Verification;
                let tokens = sectionIdentifier.split(".");
                while (tokens.length) {
                    section = section[tokens.shift()];
                }
                return section;
            }
            
            Section3Validator.prototype._createRuleQC3000 = function(section_name, section3_Identifier) {
                return {
                    qccode: '3000',
                    _validate: function(confirmation_row) {
                        return ((confirmation_row.confirmation_a.checked + confirmation_row.confirmation_b.checked + confirmation_row.confirmation_c.checked) == 1);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate(section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                section: section_name,
                            });
                            error.gasIndex = 'section-3-confirmation';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            Section3Validator.prototype._createRuleQC3001 = function(section_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3001',
                    _validate: function(section1, section2, section3) {
                        // Option a) should only be chosen if in Tables 1 and 2 in section I only a) was selected.
                        // If somewhere options b) or c) are selected in the tables 1 and 2 in section I and the verifier chooses a) in I-3, there should be a blocking error with the following text:
                        if (!section3.confirmation_a.checked) return true;
                        if (section1.confirmation_b.checked) return false;
                        if (section1.confirmation_c.checked) return false;
                        for (const transaction_code in section2) {
                            if (section2[transaction_code].confirmation_b.checked) return false;
                            if (section2[transaction_code].confirmation_c.checked) return false;
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section1 = Section3Validator._getSection(viewModel, section1_Identifier);
                        let section2 = Section3Validator._getSection(viewModel, section2_Identifier);
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate(section1, section2, section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                section: section_name,
                            });
                            error.gasIndex = 'section-3-confirmation-a';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            Section3Validator.prototype._createRuleQC3002 = function(section_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3002',
                    _validate: function(section1, section2, section3) {
                        // Option b) can only be selected if for none of the entries in Tables 1 and 2 c) was selected.
                        // Thus if a company selects b) in section I-3 while in table 1 or 2 in section I, c) was selected, please introduce a blocking error with the following text:
                        if (!section3.confirmation_b.checked) return true;
                        if (section1.confirmation_c.checked) return false;
                        for (const transaction_code in section2) {
                            if (section2[transaction_code].confirmation_c.checked) return false;
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section1 = Section3Validator._getSection(viewModel, section1_Identifier);
                        let section2 = Section3Validator._getSection(viewModel, section2_Identifier);
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate(section1, section2, section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                section: section_name,
                            });
                            error.gasIndex = 'section-3-confirmation-b';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            Section3Validator.prototype._createRuleQC3003 = function(section_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3003',
                    _validate: function(section1, section2, section3) {
                        // Option c) can not be selected if for none of the entries in Tables 1 and 2 c) was selected.
                        // Thus if option c) is selected in section I-3 and in the tables 1 and 2 in section I, c) was selected nowhere, please introduce a blocking error with the following text:
                        if (!section3.confirmation_c.checked) return true;
                       // if (!section1.confirmation_c.checked)  return false;
                        let valid = true;
                        for (const transaction_code in section2) {
                            if ((!section2[transaction_code].confirmation_c.checked) && (!section1.confirmation_c.checked)) valid= false;
                            else if ((section2[transaction_code].confirmation_c.checked) || (section1.confirmation_c.checked)){ valid= true; break;}
                        }
                        return valid;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section1 = Section3Validator._getSection(viewModel, section1_Identifier);
                        let section2 = Section3Validator._getSection(viewModel, section2_Identifier);
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate(section1, section2, section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                section: section_name,
                            });
                            error.gasIndex = 'section-3-confirmation-c';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };


            Section3Validator.prototype._createRuleQC3013 = function(section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3013',
                    _validate: function(section2, section3) {
                        // Option a) can not be selected if in Table 2 in section II a) was not selected for 13D.
                        // In case the auditor selects a) in II-3 and a) was not selected for 13D please introduce a blocking error
                        if (section3.confirmation_a.checked) {
                            let transaction_code = 'tr_13D';
                            let tr_13D_confirmation_row = section2[transaction_code];
                            if (tr_13D_confirmation_row && !tr_13D_confirmation_row.confirmation_a.checked) return false;
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section2 = Section3Validator._getSection(viewModel, section2_Identifier);
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate(section2, section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-3-confirmation-a';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            Section3Validator.prototype._createRuleQC3014 = function(section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3014',
                    _validate: function(section2, section3) {
                        // Option b) can not be selected if in Table 2 in section II c) was selected for 13D.
                        // In case the auditor selects b) in II-3 and c) was selected for 13D in table II-2, please introduce a blocking error
                        if (section3.confirmation_b.checked) {
                            let transaction_code = 'tr_13D';
                            let tr_13D_confirmation_row = section2[transaction_code];
                            if (tr_13D_confirmation_row && tr_13D_confirmation_row.confirmation_c.checked) return false;
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section2 = Section3Validator._getSection(viewModel, section2_Identifier);
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate(section2, section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-3-confirmation-b';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            Section3Validator.prototype._createRuleQC3015 = function(section3_Identifier) {
                return {
                    qccode: '3015',
                    _validate_b4: function(confirmation) {
                        // If b) or c) are selected in Section II-3, there must be a comment with a length of at least 5 characters.
                        // If the auditor does not enter a text into the comment box, please introduce a blocking error
                        if (!confirmation.checked) return true;
                        if (!confirmation.option_4) return true;
                        return (!isEmpty(confirmation.option_4_reason) && confirmation.option_4_reason.length >= 5);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate_b4(section3.confirmation_b)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-3-confirmation-b';
                            result.errors.push(error);
                        }
                        if (!this._validate_b4(section3.confirmation_c)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-3-confirmation-c';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            Section3Validator.prototype._createRuleQC3016 = function(section3_Identifier) {
                return {
                    qccode: '3016',
                    _validate_b4: function(confirmation_row) {
                        // One and only one of the boxes a), b) or c) in section II-3 must be selected.
                        // If none of the boxes are selected (or more than one is selected), please introduce a blocking error
                        return ((confirmation_row.confirmation_a.checked + confirmation_row.confirmation_b.checked + confirmation_row.confirmation_c.checked) == 1);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate_b4(section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-3-confirmation';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            return Section3Validator;
        }
    ]);
})();
