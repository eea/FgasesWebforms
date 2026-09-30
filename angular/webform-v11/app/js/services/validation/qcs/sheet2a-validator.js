
(function() {
    angular.module('FGases.services.validation.qcs').factory('sheet2aValidator', ['$translate',
        
        'sheetTransactionValidator', 'sheetValidationObjectFactory', 'gasHelper', 'objectUtil', 'arrayUtil', 'stringUtil',
        
        function($translate, sheetTransactionValidator, sheetValidationObjectFactory, gasHelper, objectUtil, arrayUtil, stringUtil) {
            
            function Sheet2aValidator() { 
                var that = this;
                this.transactionValidations = [
                    
                ];
            }
            
            Sheet2aValidator.prototype.validate = function(viewModel) {
                var transactionErrors = sheetTransactionValidator.validate(viewModel, this.transactionValidations);
                
                return transactionErrors;
            };
            
            
            
            return new Sheet2aValidator();
        }
    ]);
})();
