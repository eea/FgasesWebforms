
(function() {
    angular.module('FGases.services.validation.qcs').factory('SheetBulkHFCSValidator', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        'ConfirmValidator', 'Section3Validator', 'UploadVerificationReport',
        
        function ($translate, sheetValidationObjectFactory, sheetTransactionValidator, ConfirmValidator, Section3Validator, UploadVerificationReport) {
            
            function SheetBulkHFCSValidator() {
                var that = this;
                let validation_id = 'bulk-hfcs-verification';
                let validation_label = 'Bulk HFCs verification';
                let table_name = 'Table 1'; // 'Bulk HFCs verification';

                this.confirmValidator = new ConfirmValidator(
                    validation_id, validation_label, table_name,
                    'Section I-1', 'Section I-2', 'Section I-3',
                    'BulkHFCs.section_I_1', 'BulkHFCs.section_I_2', 'BulkHFCs.section_I_3'
                );
                this.section3Validator = new Section3Validator(
                    validation_id, validation_label,
                    'Section I-3',
                    'BulkHFCs.section_I_1', 'BulkHFCs.section_I_2', 'BulkHFCs.section_I_3',
                );
                this.uploadVerificationReport = new UploadVerificationReport(
                    validation_id, validation_label,
                    'Section I-4', 'BulkHFCs.section_I_4',
                );
                this.transactionValidations = [
                    this.confirmValidator.transactionValidations,
                    this.section3Validator.transactionValidations,
                    this.uploadVerificationReport.transactionValidations,
                    {
                        transaction: { id: validation_id, label: validation_label },
                        rules: [
                            that._createRuleQC3011(),
                            that._createRuleQC3012(),
                        ]
                    }
                ];
            }
            
           SheetBulkHFCSValidator.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };

            SheetBulkHFCSValidator.prototype._createRuleQC3011 = function() {
                return {
                    qccode: '3011',
                    _validate: function(section_I_1, section_I_2) {
                        // Option a) can not be selected for field 9F in Table 2 in section I if for any of the other statements in table 1 or table 2 in Section I something other than a) was selected.
                        // When the auditor chooses a) for 9F and in table 1 or 2 in section I there was a selection of b) or c), please introduce a blocking error with the following text:
                        // 9F can this have a) as a verdict, even if the verdict on 5F is not a).
                        if (section_I_1.confirmation_b.checked || section_I_1.confirmation_c.checked) return false;
                        for (const transaction_code in section_I_2) {
                            if ((transaction_code != 'tr_09F') && (transaction_code != 'tr_05F')) {
                                if (section_I_2[transaction_code].confirmation_b.checked || section_I_2[transaction_code].confirmation_c.checked) return false;
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section_I_1 = viewModel._instance.Verification.BulkHFCs.section_I_1;
                        let section_I_2 = viewModel._instance.Verification.BulkHFCs.section_I_2;
                        let transaction_code = 'tr_09F';
                        if (section_I_2[transaction_code].confirmation_a.checked && !this._validate(section_I_1, section_I_2)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = `confirmation-${transaction_code}`;
                            result.errors.push(error);
                        }
                        return result;
                    }
                }
            }
            SheetBulkHFCSValidator.prototype._createRuleQC3012 = function() {
                return {
                    qccode: '3012',
                    _validate: function(section_I_1, section_I_2) {
                        // Option b) can not be selected for field 9F in Table 2 in section I if for any of the other statements in table 1 or table 2 in Section I c) was selected.
                        // When the auditor chooses b) for 9F and in table 1 or 2 in section I there was a selection of c), please introduce a blocking error with the following text:
                        // 9F can this have b) as a verdict, even if the verdict on 5F is not c).
                        if (section_I_1.confirmation_c.checked) return false;
                        for (const transaction_code in section_I_2) {
                            if ((transaction_code != 'tr_09F') && (transaction_code != 'tr_05F')) {
                                if (section_I_2[transaction_code].confirmation_c.checked) return false;
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section_I_1 = viewModel._instance.Verification.BulkHFCs.section_I_1;
                        let section_I_2 = viewModel._instance.Verification.BulkHFCs.section_I_2;
                        let transaction_code = 'tr_09F';
                        if (section_I_2[transaction_code].confirmation_b.checked && !this._validate(section_I_1, section_I_2)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = `confirmation-${transaction_code}`;
                            result.errors.push(error);
                        }
                        return result;
                    }
                }
            }
            
            return new SheetBulkHFCSValidator();
        }
    ]);
})();
