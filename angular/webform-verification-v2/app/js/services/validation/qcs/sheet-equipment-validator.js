
(function() {
    angular.module('FGases.services.validation.qcs').factory('SheetEquipmentValidator', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        'ConfirmValidator', 'Section3Validator', 'SectionII4Validator', 'UploadVerificationReport',
        
        function ($translate, sheetValidationObjectFactory, sheetTransactionValidator,
                    ConfirmValidator, Section3Validator, SectionII4Validator, UploadVerificationReport) {
            
            function SheetEquipmentValidator() {
                var that = this;
                let validation_id = 'equipment-verification';
                let validation_label = 'Equipment verification';
                let table_name = 'Table 2'; // 'Equipment verification';
                

                this.confirmValidator = new ConfirmValidator(
                    validation_id, validation_label, table_name,
                    'Section II-1', 'Section II-2', 'Section II-3',
                    'EquipmentHFCs.section_II_1', 'EquipmentHFCs.section_II_2', 'EquipmentHFCs.section_II_3'
                );
                this.section3Validator = new Section3Validator(
                    validation_id, validation_label,
                    'Section II-3',
                    'EquipmentHFCs.section_II_1', 'EquipmentHFCs.section_II_2', 'EquipmentHFCs.section_II_3',
                );
                this.sectionII4Validator = new SectionII4Validator(validation_id, validation_label);
                this.uploadVerificationReport = new UploadVerificationReport(
                    validation_id, validation_label,
                    'Section II-5', 'EquipmentHFCs.section_II_5',
                );
                this.transactionValidations = [
                    this.confirmValidator.transactionValidations,
                    this.section3Validator.transactionValidations,
                    this.sectionII4Validator.transactionValidations,
                    this.uploadVerificationReport.transactionValidations,
                    {
                        transaction: { id: validation_id, label: validation_label },
                        rules: [
                            that._createRuleQC3026(),
                            that._createRuleQC3027(),
                            that._createRuleQC3028(),
                            that._createRuleQC3029(),
                        ]
                    },
                ];
            }
            
           SheetEquipmentValidator.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };

            SheetEquipmentValidator.prototype._createRuleQC3026 = function() {
                return {
                    qccode: '3026',
                    _validate_confirmation_row: function(confirmation_row, section2,section1) {
                        if (confirmation_row.confirmation_a.checked) {
                            if (!section1.confirmation_a.checked) return false;
                            for (const transaction_code in section2) {
                                let other_confirmation_row = section2[transaction_code];
                                if (confirmation_row == other_confirmation_row) { continue }
                                if (other_confirmation_row.confirmation_b.checked) return false;
                                if (other_confirmation_row.confirmation_c.checked) return false;
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 2
                        let section2 = viewModel._instance.Verification.EquipmentHFCs.section_II_2;
                        let section1 = viewModel._instance.Verification.EquipmentHFCs.section_II_1;
                        let transaction_code = 'tr_13D';
                        let confirmation_row = section2[transaction_code];
                        if (confirmation_row && !this._validate_confirmation_row(confirmation_row, section2,section1)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = `confirmation-${transaction_code}`;
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            SheetEquipmentValidator.prototype._createRuleQC3027 = function() {
                return {
                    qccode: '3027',
                    _validate_confirmation_row: function (confirmation_row, section2, section1) {
                        if (confirmation_row.confirmation_b.checked) {
                            if (section1.confirmation_c.checked) return false;
                            for (const transaction_code in section2) {
                                let other_confirmation_row = section2[transaction_code];
                                if (confirmation_row == other_confirmation_row) { continue }
                                //if (other_confirmation_row.confirmation_a.checked) return false;
                                if (other_confirmation_row.confirmation_c.checked) return false;
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 2
                        let section2 = viewModel._instance.Verification.EquipmentHFCs.section_II_2;
                        let section1 = viewModel._instance.Verification.EquipmentHFCs.section_II_1;
                        let transaction_code = 'tr_13D';
                        let confirmation_row = section2[transaction_code];
                        if (confirmation_row && !this._validate_confirmation_row(confirmation_row, section2, section1)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = `confirmation-${transaction_code}`;
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            SheetEquipmentValidator.prototype._createRuleQC3028 = function() {
                return {
                    qccode: '3028',
                    _validate_confirmation_row: function(confirmation_row) {
                        return ((confirmation_row.confirmation_a.checked + confirmation_row.confirmation_b.checked + confirmation_row.confirmation_c.checked) == 1);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 2
                        let section2 = viewModel._instance.Verification.EquipmentHFCs.section_II_2;
                        let transactions = viewModel._instance.Verification.ReportedEquipment.Transactions;
                        let validate3028 = false;
                       

                        for (var i = 0; i < transactions.length; i++) {
                            if (transactions[i].id == 'tr_11P'){
                                validate3028 = true;
                                break;
                            }
                        }
                        if (validate3028) {

                            let transaction_code = 'tr_11P';
                            let confirmation_row = section2[transaction_code];
                            if (confirmation_row && !this._validate_confirmation_row(confirmation_row)) {
                                error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                                error.gasIndex = `confirmation-${transaction_code}`;
                                result.errors.push(error);
                            }
                        }
                        return result;
                    }
                };
            };

            SheetEquipmentValidator.prototype._createRuleQC3029 = function() {
                return {
                    qccode: '3029',
                    _validate_confirmation_row: function(confirmation_row) {
                        if (confirmation_row.confirmation_b.checked) {
                            return (!isEmpty(confirmation_row.confirmation_b.option_4_reason) && confirmation_row.confirmation_b.option_4_reason.length >= 5);
                        }
                        if (confirmation_row.confirmation_c.checked) {
                            return (!isEmpty(confirmation_row.confirmation_c.option_4_reason) && confirmation_row.confirmation_c.option_4_reason.length >= 5);
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 2
                        let section2 = viewModel._instance.Verification.EquipmentHFCs.section_II_2;
                        let transaction_code = 'tr_11P';
                        let confirmation_row = section2[transaction_code];
                        if (confirmation_row && !this._validate_confirmation_row(confirmation_row)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = `confirmation-${transaction_code}`;
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            
            return new SheetEquipmentValidator();
        }
    ]);
})();
