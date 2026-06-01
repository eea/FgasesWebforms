
(function() {
    angular.module('FGases.services.validation.qcs').factory('ConfirmValidator', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        
        function ($translate, sheetValidationObjectFactory,  sheetTransactionValidator) {
            
            function ConfirmValidator(transaction, label, table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                var that = this;
                this.transactionValidations = {
                    transaction: { id: transaction, label: label },
                    rules: [
                        that._createRuleQC3006(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier),
                        that._createRuleQC3007(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier),
                        that._createRuleQC3008(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier),
                        that._createRuleQC3009(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier),
                        that._createRuleQC3010(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier),
                    ]
                };
            }
            
            ConfirmValidator.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };

            ConfirmValidator._getSection = function(viewModel, sectionIdentifier) {
                let section = viewModel._instance.Verification;
                let tokens = sectionIdentifier.split(".");
                while (tokens.length) {
                    section = section[tokens.shift()];
                }
                return section;
            }
            
            ConfirmValidator.prototype._createRuleQC3006 = function(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3006',
                    _validate_confirmation_row: function(confirmation_row) {
                        return ((confirmation_row.confirmation_a.checked + confirmation_row.confirmation_b.checked + confirmation_row.confirmation_c.checked) == 1);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 1
                        let section1 = ConfirmValidator._getSection(viewModel, section1_Identifier);
                        if (!this._validate_confirmation_row(section1)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'confirmation';
                            result.errors.push(error);
                        }
                        // Section 2
                        let section2 = ConfirmValidator._getSection(viewModel, section2_Identifier);
                        for (const transaction_code in section2) {
                            // tr_11P has it own validator
                            if (transaction_code == 'tr_11P') { continue }
                            let confirmation_row = section2[transaction_code];
                            if (!this._validate_confirmation_row(confirmation_row)) {
                                error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                    table: table_name,
                                    section: section2_name,
                                });
                                error.gasIndex = `confirmation-${transaction_code}`;
                                result.errors.push(error);
                            }
                        }
                        return result;
                    }
                };
            };
            ConfirmValidator.prototype._createRuleQC3007 = function(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3007',
                    _validate_confirmation_b: function(confirmation_b) {
                        if (!confirmation_b.checked) return true;
                        return (confirmation_b.option_1 || confirmation_b.option_2 || confirmation_b.option_3 || confirmation_b.option_4);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 1
                        let section1 = ConfirmValidator._getSection(viewModel, section1_Identifier);
                        if (!this._validate_confirmation_b(section1.confirmation_b)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name
                            });
                            error.gasIndex = 'confirmation';
                            result.errors.push(error);
                        }
                        // Section 2
                        let section2 = ConfirmValidator._getSection(viewModel, section2_Identifier);
                        for (const transaction_code in section2) {
                            // tr_11P has it own validator
                            if (transaction_code == 'tr_11P') { continue }
                            let confirmation_b = section2[transaction_code].confirmation_b;
                            if (!this._validate_confirmation_b(confirmation_b)) {
                                error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                    table: table_name,
                                    section: section2_name,
                                });
                                error.gasIndex = `confirmation-${transaction_code}`;
                                result.errors.push(error);
                            }
                        }
                        // Section 3
                        /*let section3 = ConfirmValidator._getSection(viewModel, section3_Identifier);
                        if (!this._validate_confirmation_b(section3.confirmation_b)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'section-3-confirmation';
                            result.errors.push(error);
                        }*/
                        return result;
                    }
                };
            };
            ConfirmValidator.prototype._createRuleQC3008 = function(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3008',
                    _validate_confirmation_b4: function(confirmation_b) {
                        if (!confirmation_b.checked) return true;
                        if (!confirmation_b.option_4) return true;
                        return (!isEmpty(confirmation_b.option_4_reason) && confirmation_b.option_4_reason.length >= 5);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 1
                        let section1 = ConfirmValidator._getSection(viewModel, section1_Identifier);
                        if (!this._validate_confirmation_b4(section1.confirmation_b)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                                transaction: '',
                            });
                            error.gasIndex = 'confirmation';
                            result.errors.push(error);
                        }
                        // Section 2
                        let section2 = ConfirmValidator._getSection(viewModel, section2_Identifier);
                        for (const transaction_code in section2) {
                            // tr_11P has it own validator
                            if (transaction_code == 'tr_11P') { continue }
                            let confirmation_b = section2[transaction_code].confirmation_b;
                            if (!this._validate_confirmation_b4(confirmation_b)) {
                                error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                    table: table_name,
                                    section: section2_name,
                                });
                                error.gasIndex = `confirmation-${transaction_code}`;
                                result.errors.push(error);
                            }
                        }
                        // Section 3
                        /*let section3 = ConfirmValidator._getSection(viewModel, section3_Identifier);
                        if (!this._validate_confirmation_b4(section3.confirmation_b)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'section-3-confirmation';
                            result.errors.push(error);
                        }*/
                        return result;
                    }
                };
            };
            ConfirmValidator.prototype._createRuleQC3009 = function(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3009',
                    _validate_confirmation_c: function(confirmation_c) {
                        if (!confirmation_c.checked) return true;
                        return (confirmation_c.option_1 || confirmation_c.option_2 || confirmation_c.option_3 || confirmation_c.option_4);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 1
                        let section1 = ConfirmValidator._getSection(viewModel, section1_Identifier);
                        if (!this._validate_confirmation_c(section1.confirmation_c)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'confirmation';
                            result.errors.push(error);
                        }
                        // Section 2
                        let section2 = ConfirmValidator._getSection(viewModel, section2_Identifier);
                        for (const transaction_code in section2) {
                            // tr_11P has it own validator
                            if (transaction_code == 'tr_11P') { continue }
                            let confirmation_c = section2[transaction_code].confirmation_c;
                            if (!this._validate_confirmation_c(confirmation_c)) {
                                error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                    table: table_name,
                                    section: section2_name,
                                });
                                error.gasIndex = `confirmation-${transaction_code}`;
                                result.errors.push(error);
                            }
                        }
                        // Section 3
                        /*let section3 = ConfirmValidator._getSection(viewModel, section3_Identifier);
                        if (!this._validate_confirmation_c(section3.confirmation_c)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'section-3-confirmation';
                            result.errors.push(error);
                        }*/
                        return result;
                    }
                };
            };
            ConfirmValidator.prototype._createRuleQC3010 = function(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3010',
                    _validate_confirmation_c4: function(confirmation_c) {
                        if (!confirmation_c.checked) return true;
                        if (!confirmation_c.option_4) return true;
                        return (!isEmpty(confirmation_c.option_4_reason) && confirmation_c.option_4_reason.length >= 5);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 1
                        let section1 = ConfirmValidator._getSection(viewModel, section1_Identifier);
                        if (!this._validate_confirmation_c4(section1.confirmation_c)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'confirmation';
                            result.errors.push(error);
                        }
                        // Section 2
                        let section2 = ConfirmValidator._getSection(viewModel, section2_Identifier);
                        for (const transaction_code in section2) {
                            // tr_11P has it own validator
                            if (transaction_code == 'tr_11P') { continue }
                            let confirmation_c = section2[transaction_code].confirmation_c;
                            if (!this._validate_confirmation_c4(confirmation_c)) {
                                error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                    table: table_name,
                                    section: section2_name,
                                });
                                error.gasIndex = `confirmation-${transaction_code}`;
                                result.errors.push(error);
                            }
                        }
                        // Section 3
                        /*let section3 = ConfirmValidator._getSection(viewModel, section3_Identifier);
                        if (!this._validate_confirmation_c4(section3.confirmation_c)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'section-3-confirmation';
                            result.errors.push(error);
                        }*/
                        return result;
                    }
                };
            };
            
            return ConfirmValidator;
        }
    ]);
})();
