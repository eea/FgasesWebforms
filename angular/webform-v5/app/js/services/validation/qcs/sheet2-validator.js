
(function() {
    angular.module('FGases.services.validation.qcs').factory('sheet2Validator', ['$translate',
        
        'sheetTransactionValidator', 'sheetValidationObjectFactory', 'gasHelper', 'objectUtil', 'arrayUtil', 'stringUtil',
        
        function($translate, sheetTransactionValidator, sheetValidationObjectFactory, gasHelper, objectUtil, arrayUtil, stringUtil) {
            
            function Sheet2Validator() { 
                var that = this;
                this.transactionValidations = [
                    {
                        transaction: { id: 'tr_05A', label: '05A' },
                        rules: [that._createRuleQc2028(), that._createRuleQc2029(), that._createRuleQc2039(), that._createRuleQc2400() ]
                    },
                    {
                        transaction: { id: 'tr_05B', label: '05B' },
                        rules: [ that._createRuleQc2031(), that._createRuleQc2071(), that._createRuleQc2409() ]
                    },
                    {
                        transaction: { id: 'tr_05C', label: '05C_exempted' },
                        rules: [ that._createRuleQc2044() ]
                    },
                    {
                        transaction: { id: 'tr_13aB', label: '13aB' },
                        rules: [ that._createRuleQc24101(), that._createRuleQc24102(), that._createRuleQc13aB() ]
                    }
                ];
            }
            
            Sheet2Validator.prototype.validate = function(viewModel) {
                var transactionErrors = sheetTransactionValidator.validate(viewModel, this.transactionValidations);
                
                return transactionErrors;
            };
            
            Sheet2Validator.prototype._createRuleQc2028 = function() {
                return {
                    qccode: 2028,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        if (viewModel.sheetActivities.isD()) {
                            return result;
                        }
                        
                        var ownTradePartner = viewModel.sheet2.section5.getTr05AOwnTradePartner();
                        
                        if (objectUtil.isNull(ownTradePartner)) {
                            var gasAmounts05A = viewModel.sheet2.section5.getGasAmounts('tr_05A');
                        } else {
                            var gasAmounts05A = viewModel.sheet2.section5.getGasAmountsOfTradePartner('tr_05A', ownTradePartner.PartnerId);
                        }
                        
                        if ((gasHelper.calculateSum(gasAmounts05A) > 1 || gasHelper.calculateSumOfAllCO2Eq(viewModel.getReportedGases(), gasAmounts05A) > 1000)) {

                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            result.errors.push(error);

                            var sectionValue2028 = [];
                            var sectionMessage2028 = [];
                            sectionValue2028.push("5A")

                            var commentedAmount05A = null;
                            for (var i = 0; i < gasAmounts05A.length; i++) {
                                if (!objectUtil.isNull(gasAmounts05A[i].amount) && gasAmounts05A[i].amount != 0) {
                                    if (stringUtil.isEmpty(gasAmounts05A[i].comment)) {
                                        commentedAmount05A = null;
                                        break;
                                    } else {
                                        commentedAmount05A = gasAmounts05A[i];
                                    }
                                }
                            }

                            /*var commentedAmount05A = arrayUtil.selectSingle(gasAmounts05A, function (gasAmounts05A) {
                                if (objectUtil.isNull(gasAmounts05A.amount) || gasAmounts05A.amount != 0)
                                    return !stringUtil.isEmpty(gasAmounts05A.comment);
                            });*/
                            
                            if (!objectUtil.isNull(commentedAmount05A)) {
                                error.isNonBlocker = true;
                                var flag = sheetValidationObjectFactory.createQcFlag('5A', this.qccode, commentedAmount05A.id, ownTradePartner.PartnerId);
                                result.flags.push(flag);
                            } else {
                                sectionMessage2028.push("5A");
                            }

                            error.message = $translate.instant("validation_messages.qc_2028.error_text", {
                                sectionValue: sectionValue2028,
                                sectionMessage: sectionMessage2028
                            });
                        }
                        
                        return result;
                    }
                };
            };
            
            Sheet2Validator.prototype._createRuleQc2029 = function() {
                return {
                    qccode: 2029,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        if (!viewModel.sheetActivities.isD()) {
                            return result;
                        }
                        
                        var ownTradePartner = viewModel.sheet2.section5.getTr05AOwnTradePartner();

                        if (objectUtil.isNull(ownTradePartner)) {
                            var gasAmounts05A = viewModel.sheet2.section5.getGasAmounts('tr_05A');
                        } else {
                            var gasAmounts05A = viewModel.sheet2.section5.getGasAmountsOfTradePartner('tr_05A', ownTradePartner.PartnerId);
                        }

                        if (!objectUtil.isNull(gasAmounts05A[0])) {
                            if (!(gasAmounts05A[0].amount > 0)) {
                                return result;
                            }
                        }
                        
                        var gasAmounts08D = viewModel.sheet6.section8.getGasAmounts('tr_08D');
                        var gasAmounts01A_a_own = viewModel.sheet1.section1.getGasAmounts('tr_01A_a_own');
                        var gasAmounts01B = viewModel.sheet1.section1.getGasAmounts('tr_01B');
                        var that = this;
                        
                        arrayUtil.forEach(gasAmounts05A, function(gasAmount05A) {
                            /*if (objectUtil.isNull(gasAmount05A.amount)) {
                                return;
                            }*/
                            
                            var gasAmount08D = arrayUtil.selectSingle(gasAmounts08D, function(gas) {
                                return gas.id === gasAmount05A.id;
                            });

                            var gasAmount01A_a_own = arrayUtil.selectSingle(gasAmounts01A_a_own, function (gas) {
                                return gas.id === gasAmount05A.id;
                            });

                            var gasAmount01B = arrayUtil.selectSingle(gasAmounts01B, function (gas) {
                                return gas.id === gasAmount05A.id;
                            });

                            if (objectUtil.isNull(ownTradePartner) && objectUtil.isNull(gasAmount01A_a_own.amount) && objectUtil.isNull(gasAmount01B.amount)) {
                                return;
                            }
                            
                            if (objectUtil.isNull(gasAmount08D.amount) || (gasAmount05A.amount + gasAmount01A_a_own.amount + gasAmount01B.amount) > gasAmount08D.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount05A.index;
                                result.errors.push(error);
                                var sectionValue2029 = [];
                                var sectionMessage2029 = [];
                                if (gasAmount05A.amount > 0) {
                                    sectionValue2029.push("5A")
                                }
                                if (gasAmount01A_a_own.amount > 0) {
                                    sectionValue2029.push("1A_a_own")
                                }
                                if (gasAmount01B.amount > 0) {
                                    sectionValue2029.push("1B")
                                }

                                if (gasAmount05A.amount <= gasAmount08D.amount && gasAmount01A_a_own.amount <= gasAmount08D.amount && gasAmount01B.amount <= gasAmount08D.amount) {
                                    if (!stringUtil.isEmpty(gasAmount05A.comment) || !stringUtil.isEmpty(gasAmount01A_a_own.comment) || !stringUtil.isEmpty(gasAmount01B.comment)) {
                                        error.isNonBlocker = true;
                                    } else {
                                        sectionMessage2029 = sectionValue2029;
                                    }
                                } else {
                                    if ((gasAmount05A.amount > gasAmount08D.amount && stringUtil.isEmpty(gasAmount05A.comment)) || (gasAmount01A_a_own.amount > gasAmount08D.amount && stringUtil.isEmpty(gasAmount01A_a_own.comment)) || (gasAmount01B.amount > gasAmount08D.amount && stringUtil.isEmpty(gasAmount01B.comment))) {
                                        error.isNonBlocker = false;
                                        if (gasAmount05A.amount > gasAmount08D.amount && stringUtil.isEmpty(gasAmount05A.comment)) {
                                            sectionMessage2029.push("5A");
                                        }
                                        if (gasAmount01A_a_own.amount > gasAmount08D.amount && stringUtil.isEmpty(gasAmount01A_a_own.comment)) {
                                            sectionMessage2029.push("1A_a_own");
                                        }
                                        if (gasAmount01B.amount > gasAmount08D.amount && stringUtil.isEmpty(gasAmount01B.comment)) {
                                            sectionMessage2029.push("1B");
                                        }
                                    } else {
                                        error.isNonBlocker = true;
                                    }
                                }
                                error.message = $translate.instant("validation_messages.qc_2029.error_text", {
                                    sectionValue: sectionValue2029,
                                    sectionMessage: sectionMessage2029
                                });
                                if (error.isNonBlocker) {
                                    for (var i = 0; i < sectionValue2029.length; i++) {
                                        if (sectionValue2029[i] == "5A") {
                                            if (objectUtil.isNull(ownTradePartner)) {
                                                var flag = sheetValidationObjectFactory.createQcFlag('5A', that.qccode, gasAmount05A.id);
                                            } else {
                                                var flag = sheetValidationObjectFactory.createQcFlag('5A', that.qccode, gasAmount05A.id, ownTradePartner.PartnerId);
                                            }
                                        }
                                        if (sectionValue2029[i] == "1A_a_own") {
                                            var flag = sheetValidationObjectFactory.createQcFlag('1A_a_own', that.qccode, gasAmount01A_a_own.id);
                                        }
                                        if (sectionValue2029[i] == "1B") {
                                            var flag = sheetValidationObjectFactory.createQcFlag('1B', that.qccode, gasAmount01B.id);
                                        }
                                        result.flags.push(flag);
                                    }
                                }
                            }
                        });
                        
                        return result;
                    }
                };
            };

            Sheet2Validator.prototype._createRuleQc2400 = function () {
                return {
                    qccode: 2400,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        var that = this;

                        arrayUtil.selectSingle(viewModel.sheet2.section5.getSectionData().tr_05A_TradePartners.Partner, function (tradePartner) {
                            if (!viewModel.isOwnCompany(tradePartner)) {
                                var flag = sheetValidationObjectFactory.createQcFlag('5A', that.qccode, '', tradePartner.PartnerId);
                                result.flags.push(flag);
                            }
                        });

                        arrayUtil.selectSingle(viewModel.sheet1.section1.getSectionData().tr_01C_TradePartners.Partner, function (tradePartner) {
                            if (!viewModel.isOwnCompany(tradePartner)) {
                                var flag = sheetValidationObjectFactory.createQcFlag('1C', that.qccode, '', tradePartner.PartnerId);
                                result.flags.push(flag);
                            }
                        });

                        arrayUtil.selectSingle(viewModel.sheet1.section1.getSectionData().tr_01A_a_other_ExtDestruction.Partner, function (tradePartner) {
                            if (!viewModel.isOwnCompany(tradePartner)) {
                                var flag = sheetValidationObjectFactory.createQcFlag('1A_a_other', that.qccode, '', tradePartner.PartnerId);
                                result.flags.push(flag);
                            }
                        });

                        return result;
                    }
                };
            };
            
            Sheet2Validator.prototype._createRuleQc2031 = function() {
                return {
                    qccode: 2031,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        if (viewModel.sheetActivities.isFU()) {
                            return result;
                        }
                        
                        var ownTradePartner = viewModel.sheet2.section5.getTr05BOwnTradePartner();
                        
                        if (objectUtil.isNull(ownTradePartner)) {
                            return result;
                        }
                        
                        var gasAmounts = viewModel.sheet2.section5.getGasAmountsOfTradePartner('tr_05B', ownTradePartner.PartnerId);
                        
                        if (gasHelper.calculateSumOfAllCO2Eq(viewModel.getReportedGases(), gasAmounts) > 1000) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            result.errors.push(error);
                        }
                        
                        return result;
                    }
                };
            };
            
            Sheet2Validator.prototype._createRuleQc2071 = function() {
                return {
                    qccode: 2071,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        if (!viewModel.sheetActivities.isFU()) {
                            return result;
                        }
                        
                        var ownTradePartner = viewModel.sheet2.section5.getTr05BOwnTradePartner();
                        
                        if (objectUtil.isNull(ownTradePartner)) {
                            return result;
                        }
                        
                        var gasAmounts05B = viewModel.sheet2.section5.getGasAmountsOfTradePartner('tr_05B', ownTradePartner.PartnerId);
                        var gasAmounts07A = viewModel.sheet6.section8.getGasAmounts('tr_07A');
                        var that = this;
                        
                        arrayUtil.forEach(gasAmounts05B, function(gasAmount05B) {
                            if (objectUtil.isNull(gasAmount05B.amount)) {
                                return;
                            }
                            
                            var gasAmount07A = arrayUtil.selectSingle(gasAmounts07A, function(gas) {
                                return gas.id === gasAmount05B.id;
                            });
                            
                            if ((objectUtil.isNull(gasAmount07A.amount) || gasAmount05B.amount > gasAmount07A.amount)) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount05B.index;
                                error.isNonBlocker = !stringUtil.isEmpty(gasAmount05B.comment);
                                result.errors.push(error);
                                var flag = sheetValidationObjectFactory.createQcFlag('5B', that.qccode, gasAmount05B.id, ownTradePartner.PartnerId);
                                result.flags.push(flag);
                            }
                        });
                        
                        return result;
                    }
                };
            };
            
            Sheet2Validator.prototype._createRuleQc2409 = function() {
                return {
                    qccode: 2409,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        
                        arrayUtil.forEach(viewModel.sheet2.section5.getTr05BTradePartners(), function(tradePartner) {
                            var gasAmounts05B = viewModel.sheet2.section5.getGasAmountsOfTradePartner('tr_05B', tradePartner.PartnerId);
                            
                            arrayUtil.forEach(gasAmounts05B, function(gasAmount05B) {
                                var amount = gasAmount05B.amount;
                                
                                if (!objectUtil.isNull(amount) && amount !== 0 && stringUtil.isEmpty(gasAmount05B.comment)) {
                                    var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                    error.gasIndex = gasAmount05B.index;
                                    error.message = $translate.instant("validation_messages.qc_2409_partner.error_text", {
                                        gas: viewModel.getReportedGasById(gasAmount05B.id).Name,
                                        partner: tradePartner.CompanyName,
                                        section:"5B"
                                    });
                                    result.errors.push(error);
                                }
                            });
                        });
                        
                        return result;
                    }
                };
            };
            
            Sheet2Validator.prototype._createRuleQc2044 = function() {
                return {
                    qccode: 2044,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        if (!this.isValid(viewModel)) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            result.errors.push(error);
                        }
                        
                        return result;
                    },
                    isValid: function(viewModel) {
                        return !viewModel.sheet2.section5.hasTr05C_ExemptedNonZeroValues() || viewModel.sheet4.section9.getSectionData().Verified;
                    }
                };
            };

            Sheet2Validator.prototype._createRuleQc24101 = function() {
                return {
                    qccode: 24101,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        var gasAmounts13aA = viewModel.sheet2.section5.getGasAmounts('tr_13aA');
                        var gasAmounts13aB = viewModel.sheet2.section5.getGasAmounts('tr_13aB');
                        var gasAmounts4D = viewModel.sheet1.section4.getGasAmounts('tr_04D');
        
                        var that = this;

                        arrayUtil.forEach(gasAmounts13aA, function(gasAmount13aA) {
                            if (objectUtil.isNull(gasAmount13aA.amount)) {
                                gasAmount13aA.amount = 0;
                            }        

                            var gasSelector = function(gasAmount) {
                                return gasAmount.id === gasAmount13aA.id;
                            };
                            
                            var gasAmount13aB = arrayUtil.selectSingle(gasAmounts13aB, gasSelector);
                            var gasAmount4D = arrayUtil.selectSingle(gasAmounts4D, gasSelector);
                            if (gasAmount13aA.amount >= 0) {
                                if (((-gasAmount4D.amount) > gasAmount13aB.amount) || (gasAmount13aB.amount > (gasAmount13aA.amount + gasAmount4D.amount))) {
                                //if (gasAmount13aB.amount > (gasAmount13aA.amount + gasAmount4D.amount - gasAmount4I.amount)) {
                                    var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                    error.gasIndex = gasAmount13aA.index;
                                    error.message = $translate.instant("validation_messages.qc_24101.error_text", {
                                        gas: viewModel.getReportedGasById(gasAmount13aA.id).Name
                                    });
                                    result.errors.push(error);                                    
                                }                               
                            }
                        });
                        
                        return result;
                    }
                };
            };     

            /*Sheet2Validator.prototype._createRuleQc24101 = function() {
                return {
                    qccode: 24101,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        var gasAmounts13aA = viewModel.sheet2.section5.getGasAmounts('tr_13aA');
                        var gasAmounts13aB = viewModel.sheet2.section5.getGasAmounts('tr_13aB');

                        var that = this;

                        arrayUtil.forEach(gasAmounts13aA, function(gasAmount13aA) {
                            if (objectUtil.isNull(gasAmount13aA.amount)) {
                                gasAmount13aA.amount = 0;
                            }

                            var gasSelector = function(gasAmount) {
                                return gasAmount.id === gasAmount13aA.id;
                            };

                            var gasAmount13aB = arrayUtil.selectSingle(gasAmounts13aB, gasSelector);
                            if (gasAmount13aA.amount >= 0 ) {
                                if(gasAmount13aB.amount > gasAmount13aA.amount) {
                                    var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                    error.gasIndex = gasAmount13aA.index;
                                    error.message = $translate.instant("validation_messages.qc_24101.error_text", {
                                        gas: viewModel.getReportedGasById(gasAmount13aA.id).Name
                                    });
                                    result.errors.push(error);
                                }
                            }
                        });

                        return result;
                    }
                };
            };            */

            Sheet2Validator.prototype._createRuleQc24102 = function() {
                return {
                    qccode: 24102,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        var gasAmounts13aA = viewModel.sheet2.section5.getGasAmounts('tr_13aA');
                        var gasAmounts13aB = viewModel.sheet2.section5.getGasAmounts('tr_13aB');
                        var gasAmounts4D = viewModel.sheet1.section4.getGasAmounts('tr_04D');

        
                        var that = this;

                        arrayUtil.forEach(gasAmounts13aA, function(gasAmount13aA) {
                            if (objectUtil.isNull(gasAmount13aA.amount)) {
                                gasAmount13aA.amount = 0;
                            }        

                            var gasSelector = function(gasAmount) {
                                return gasAmount.id === gasAmount13aA.id;
                            };
                            
                            var gasAmount13aB = arrayUtil.selectSingle(gasAmounts13aB, gasSelector);
                            var gasAmount4D = arrayUtil.selectSingle(gasAmounts4D, gasSelector);
                            if (gasAmount13aA.amount < 0) {
                                if (((-gasAmount4D.amount) > gasAmount13aB.amount) || (gasAmount13aB.amount > (gasAmount13aA.amount + gasAmount4D.amount))) {
                                 //if (gasAmount13aB.amount > (gasAmount13aA.amount + gasAmount4D.amount - gasAmount4I.amount)) {
                                    var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                    error.gasIndex = gasAmount13aA.index;
                                    error.message = $translate.instant("validation_messages.qc_24102.error_text", {
                                        gas: viewModel.getReportedGasById(gasAmount13aA.id).Name
                                    });
                                    result.errors.push(error);                                    
                                }  
                            }
                        });
                        
                        return result;
                    }
                };
            };          

            Sheet2Validator.prototype._createRuleQc13aB = function() {
                return {
                    qccode: 24103,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        var gasAmounts13aA = viewModel.sheet2.section5.getGasAmounts('tr_13aA');
                        var gasAmounts13aB = viewModel.sheet2.section5.getGasAmounts('tr_13aB');
                        var companyData = viewModel._instance.FGasesReporting.GeneralReportData.Company;
        
                        var that = this;

                        arrayUtil.forEach(gasAmounts13aA, function(gasAmount13aA) {
                            if (objectUtil.isNull(gasAmount13aA.amount)) {
                                gasAmount13aA.amount = 0;
                            }        

                            var gasSelector = function(gasAmount) {
                                return gasAmount.id === gasAmount13aA.id;
                            };
                            
                            var gasAmount13aB = arrayUtil.selectSingle(gasAmounts13aB, gasSelector);

                            if (objectUtil.isNull(gasAmount13aB.amount)) {
                                gasAmount13aB.amount = 0;
                            }
                            if(companyData.Country.Code === 'UK' || (!angular.isUndefined(companyData.EuLegalRepresentativeCompany) && 
                                !isEmpty(companyData.EuLegalRepresentativeCompany) && companyData.EuLegalRepresentativeCompany.Country.Code === "UK")) {
                                if (gasAmount13aA.amount !== 0 ) {
                                    if(gasAmount13aB.amount === 0) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.isNonBlocker = true;
                                        error.gasIndex = gasAmount13aA.index;
                                        error.message = $translate.instant("validation_messages.qc_24103.warning_text", {
                                            gas: viewModel.getReportedGasById(gasAmount13aB.id).Name
                                        });
                                        result.errors.push(error);
                                    }
                                } 
                            }
                        });
                        
                        return result;
                    }
                };
            };     

            Sheet2Validator.prototype._createRuleQc2039 = function() {
                return {
                    qccode: 2039,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        var gasAmounts05G = viewModel.sheet2.section5.getGasAmounts('tr_05G');
                        var gasAmounts04M = viewModel.sheet1.section4.getGasAmounts('tr_04M');
                        var gasAmounts04D = viewModel.sheet1.section4.getGasAmounts('tr_04D');
                        var gasAmounts04I = viewModel.sheet1.section4.getGasAmounts('tr_04I');
                        var gasAmounts05R = viewModel.sheet2.section5.getTradePartnerSumGasAmounts('tr_05R');
                        
                        var that = this;
                        
                        arrayUtil.forEach(gasAmounts05G, function(gasAmount05G) {
                            if (objectUtil.isNull(gasAmount05G.amount)) {
                                gasAmount05G.amount = 0;
                            }
                                                        
                            var gasSelector = function(gasAmount) {
                                return gasAmount.id === gasAmount05G.id;
                            };
                            var gasAmount04M = arrayUtil.selectSingle(gasAmounts04M, gasSelector);
                            var gasAmount04D = arrayUtil.selectSingle(gasAmounts04D, gasSelector);
                            var gasAmount04I = arrayUtil.selectSingle(gasAmounts04I, gasSelector);
                            var gasAmount05R = arrayUtil.selectSingle(gasAmounts05R, gasSelector);
                            
                            var g04M = objectUtil.defaultIfNull(gasAmount04M.amount, 0) * 1000;
                            var g04D = objectUtil.defaultIfNull(gasAmount04D.amount, 0) * 1000;
                            var g04I = objectUtil.defaultIfNull(gasAmount04I.amount, 0) * 1000;
                            var g05R = objectUtil.defaultIfNull(gasAmount05R.amount, 0) * 1000;
                            
                            if (gasAmount05G.amount * 1000 > g04M + g04D - g04I - g05R) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount05G.index;
                                error.message = $translate.instant("validation_messages.qc_2039.error_text", {
                                    gas: viewModel.getReportedGasById(gasAmount05G.id).Name
                                });
                                result.errors.push(error);
                            }
                        });
                        
                        return result;
                    }
                };
            };
            
            return new Sheet2Validator();
        }
    ]);
})();
