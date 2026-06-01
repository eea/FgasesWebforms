
(function() {
    angular.module('FGases.services.validation.qcs').factory('sheetGeneralValidator', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        
        function ($translate, sheetValidationObjectFactory,  sheetTransactionValidator) {
            
            function sheetGeneralValidator() {
                var that = this;
                this.transactionValidations = [
                  /*  {
                        transaction: { id: 'ext-company-data', label: 'Additional company data' },
                        rules: [ that._createRule() ]
                    },*/
                    {
                        transaction: { id: 'ext-company-data', label: 'Additional company data' },
                        rules: [that._createRuleQC24120()]
                    }
                ];
            }
            
           sheetGeneralValidator.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };
            
           /* sheetGeneralValidator.prototype._createRule = function() {
                return {
                    qccode: '2501',
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        if (!viewModel.isStocksInfoDefined() || !viewModel.isQuotaInfoDefined() || !viewModel.isCompanySizeInfoDefined() || !viewModel.isNerStatusDefined()) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            result.errors.push(error);
                        }
                        
                        return result;
                    }
                };
            };*/
            
            sheetGeneralValidator.prototype._createRuleQC24120 = function () {
                return {
                    qccode: '24120',
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (viewModel._instance.Verification.GeneralReportData.Company.CompanyId == "" ||
                            viewModel._instance.Verification.GeneralReportData.Company.CompanyId == null ||
                            viewModel._instance.Verification.GeneralReportData.Company.CompanyName == "" ||
                            viewModel._instance.Verification.GeneralReportData.Company.CompanyName == null
                        ) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            result.errors.push(error);
                        }

                        return result;
                    }
                };
            };
            
            return new sheetGeneralValidator();
        }
    ]);
})();
