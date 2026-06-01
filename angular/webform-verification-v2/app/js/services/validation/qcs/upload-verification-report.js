
(function() {
    angular.module('FGases.services.validation.qcs').factory('UploadVerificationReport', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        
        function ($translate, sheetValidationObjectFactory, sheetTransactionValidator) {
            
            function UploadVerificationReport(transaction, label, section_name, section_Identifier) {
                var that = this;
                this.transactionValidations = {
                    transaction: { id: transaction, label: label },
                    rules: [
                        that._createRuleQC3004(section_name, section_Identifier),
                        that._createRuleQC3005(section_name, section_Identifier),
                    ]
                };
            }
            
            UploadVerificationReport.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };

            UploadVerificationReport._getSection = function(viewModel, sectionIdentifier) {
                let section = viewModel._instance.Verification;
                let tokens = sectionIdentifier.split(".");
                while (tokens.length) {
                    section = section[tokens.shift()];
                }
                return section;
            }
            
            UploadVerificationReport.prototype._createRuleQC3004 = function(section_name, section_Identifier) {
                return {
                    qccode: '3004',
                    _validate: function(section) {
                        if (isEmpty(section.VerificationReport.Url)) return true;
                        let file_name = section.VerificationReport.Url.split('/').pop();
                        let file_extension = file_name.split('.').pop();
                        return (file_extension.toLowerCase() != 'xml');
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section = UploadVerificationReport._getSection(viewModel, section_Identifier);
                        if (!this._validate(section)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                section: section_name,
                            });
                            error.gasIndex = 'verification-report';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            UploadVerificationReport.prototype._createRuleQC3005 = function(section_name, section_Identifier) {
                return {
                    qccode: '3005',
                    _validate: function(section) {
                        return !isEmpty(section.VerificationReport.Url);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section = UploadVerificationReport._getSection(viewModel, section_Identifier);
                        if (!this._validate(section)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                section: section_name,
                            });
                            error.gasIndex = 'verification-report-upload';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            
            return UploadVerificationReport;
        }
    ]);
})();
