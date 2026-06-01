
(function() {
    angular.module('FGases.services.validation.qcs').factory('sheet4Validator', [
        
        '$translate', 'sheetTransactionValidator', 'sheetValidationObjectFactory', 'objectUtil', 'arrayUtil', 'stringUtil', 'numericUtil',
        
        function($translate, sheetTransactionValidator, sheetValidationObjectFactory, objectUtil, arrayUtil, stringUtil, numericUtil) {
            
            function Sheet4Validator() {
                var that = this;
                this.transactionValidations = [
                    {
                        transaction: {},
                        rules: [that._createRuleQc2103()]
                    },
                    {
                        transaction: { id: 'tr_09A_imp', label: '09A_imp'},
                        rules: [ that._createRuleQc2404() ]
                    },
                    {
                        transaction: { id: 'tr_09A_add', label: '09A_add'},
                        rules: [ that._createRuleQc2405(), that._createRuleQc24041(), that._createRuleQc24042(),  that._createRuleQc24043() ]
                    },
                    // {
                    //     transaction: { id: 'tr_09A', label: '09A'},
                    //     isValidationRequired: function(viewModel) {
                    //         return viewModel.sheetActivities.isAuth();
                    //     },
                    //     rules: [ that._createRuleQc2007() ]
                    // },
                    {
                        transaction: { id: 'tr_09C', label: '09C' },
                        rules: [ that._createRuleQc2044() ]
                    },
                    {
                        transaction: { id: 'tr_09F', label: '09F' },
                        rules: [ that._createRuleQc2403() ]
                    },
                    {
                        transaction: { id: 'tr_09F', label: '09F' },
                        rules: [ that._createRuleQc24031() ]
                    },
                    {
                        transaction: { id: 'tr_09A', label: '09A' },
                        rules: [ that._createRuleQc2997() ]
                    }                    
                ];
            }
            
            Sheet4Validator.prototype.validate = function(viewModel) {
                var transactionErrors = sheetTransactionValidator.validate(viewModel, this.transactionValidations);
                
                return transactionErrors;
            };

            Sheet4Validator.prototype._createRuleQc2007 = function() {
                return {
                    qccode: 2007,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (!this.isValid(viewModel)) {
                            result.errors.push(sheetValidationObjectFactory.createValidationError(this.qccode));
                        }

                        return result;
                    },
                    isValid: function(viewModel) {
                        var sum09A = viewModel.sheet4.section9.getTr09ASum();

                        return viewModel.getReportedGases().length > 0 && (!objectUtil.isNull(sum09A) && sum09A > 0);
                    }
                };
            };

            Sheet4Validator.prototype._createRuleQc2103 = function () {
                return {
                    qccode: 2103,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (!this.isValid(viewModel)) {
                            result.errors.push(sheetValidationObjectFactory.createValidationError(this.qccode));
                        }

                        return result;
                    },
                    isValid: function (viewModel) {
                        if (!viewModel.sheetActivities.isRQA()) {
                            return true;
                        }
                        var hasValue4MField = false;
                        var section4Gases = viewModel.sheet1.section4.getSectionGases();

                        var gasAmounts01A = viewModel.sheet1.section1.getGasAmounts('tr_01A');
                        var gasAmounts02A = viewModel.sheet1.section1.getGasTotalAmountForRow('tr_02A');
                        var gasAmounts02G = viewModel.sheet1.section1.getGasAmounts('tr_02G');
                        var gasAmounts04C = viewModel.sheet1.section1.getGasAmounts('tr_04C');

                        arrayUtil.forEach(section4Gases, function (section4Gas) {
                            if (section4Gas.GasGroup == 'HFCs' || section4Gas.GasGroup == 'HFC mixtures' || (section4Gas.GasGroup == 'CustomMixture' && section4Gas.BlendComponents.Component && section4Gas.BlendComponents.Component.filter(f => (f.GasGroupId == 1)).length > 0)) {
                                var gasId = section4Gas.GasId;

                                var matchingGas01A = gasAmounts01A.find(function (gas01A) {
                                    return gas01A.id === gasId;
                                });

                                var matchingGas02A = gasAmounts02A.find(function (gas02A) {
                                    return gas02A.id === gasId;
                                });

                                var matchingGas02G = gasAmounts02G.find(function (gas02G) {
                                    return gas02G.id === gasId;
                                });

                                var matchingGas04C = gasAmounts04C.find(function (gas04C) {
                                    return gas04C.id === gasId;
                                });

                                if ((matchingGas01A && matchingGas01A.amount > 0) || (matchingGas02A && matchingGas02A.amount > 0) || (matchingGas02G && matchingGas02G.amount > 0) || (matchingGas04C && matchingGas04C.amount > 0)) {
                                    hasValue4MField = true;
                                }
                            }
                        });

                        var sum09A = numericUtil.toNum(viewModel.sheet4.section9.getSectionData().tr_09A.SumOfPartnerAmounts, 0);
                        if (hasValue4MField || sum09A > 0) {
                            return true;
                        }

                        return viewModel.sheet4.section9.getSectionData().NilReportConfirmed;
                    }
                };
            };
            
            Sheet4Validator.prototype._createRuleQc2405 = function() {
                return {
                    qccode: 2405,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        var sum09A = viewModel.sheet4.section9.getTr09ASum();
                        //var sum09A_add = viewModel.sheet4.section9.getTr09A_addSumOfPartnerAmounts();
                        
                        if (objectUtil.isNull(sum09A) || sum09A === 0) {
                            return result;
                        }
                        
                        var invalidTradePartner = arrayUtil.selectSingle(viewModel.sheet4.section9.getTr09ATradePartners(), function(tradePartner) {
                            if (!viewModel.isOwnCompany(tradePartner)) {
                                return false;
                            }
                            
                            var tradePartnerAmount = viewModel.sheet4.section9.getTr09AAmountOfTradePartner(tradePartner.PartnerId);
                            
                            return !objectUtil.isNull(tradePartnerAmount.amount) && tradePartnerAmount.amount > 0;
                        });
                        
                        if (!objectUtil.isNull(invalidTradePartner)) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.isNonBlocker = true;
                            result.errors.push(error);
                            var flag = sheetValidationObjectFactory.createQcFlag('9A_add', this.qccode, null, invalidTradePartner.PartnerId);
                            result.flags.push(flag);
                        }
                        
                        return result;
                    }
                };
            };
            
            Sheet4Validator.prototype._createRuleQc2404 = function() {
                return {
                    qccode: 2404,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        if (!this.isValid(viewModel)) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.isNonBlocker = false;
                            result.errors.push(error);
                            var flag = sheetValidationObjectFactory.createQcFlag('09A_imp', this.qccode);
                            result.flags.push(flag);
                        }
                        
                        return result;
                    },
                    isValid: function(viewModel) {
                        var sum_tr09A_imp = viewModel.sheet4.section9.getTr09A_impSumOfPartnerAmounts();

                        if (objectUtil.isNull(sum_tr09A_imp) || sum_tr09A_imp === 0) {
                            return true;
                        }

                        if (viewModel.sheetActivities.isNilReport()) {
                            return false;
                        }

                        if (!viewModel.sheetActivities.isAuth()) {
                            return false;
                        }

                        return true;
                    }
                };
            };
            
            Sheet4Validator.prototype._createRuleQc2044 = function() {
                return {
                    qccode: 2044,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        if (!this.isValid(viewModel)) {
                            result.errors.push(sheetValidationObjectFactory.createValidationError(this.qccode));
                        }
                        
                        return result;
                    },
                    isValid: function(viewModel) {
                        var amount09C = viewModel.sheet4.section9.getTr09CAmount();
                        
                        if (objectUtil.isNull(amount09C) || amount09C < 1000) {
                            return true;
                        }
                        
                        return viewModel.sheet4.section9.getSectionData().Verified;
                    }
                };
            };
            
            Sheet4Validator.prototype._createRuleQc2403 = function() {
                return {
                    qccode: 2403,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        if (!this.isValid(viewModel)) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.isNonBlocker = true;
                            result.errors.push(error);
                        }
                        
                        return result;
                    },
                    isValid: function(viewModel) {
                        var amount09F = viewModel.sheet4.section9.getTr09FAmount();
                        return objectUtil.isNull(amount09F) || amount09F <= viewModel.sheet4.section9.getTr09GAmount();
                    }
                };
            };

            Sheet4Validator.prototype._createRuleQc2997 = function() {
                return {
                    qccode: 2997,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        if(!this._isValidationRequired(viewModel)){
                            return result;
                        }

                        var sum09A = viewModel.sheet4.section9.getTr09ASum();
                        var sum09A_imp = viewModel.sheet4.section9.getTr09A_impSumOfPartnerAmounts();
                        var sum09A_add =  viewModel.sheet4.section9.getTr09A_addSumOfPartnerAmounts();
                        if (   (objectUtil.isNull(sum09A) || sum09A === 0)
                            && (objectUtil.isNull(sum09A_imp) || sum09A_imp <= 0)
                            && (objectUtil.isNull(sum09A_add) || sum09A_add <= 0)
                            ) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.isNonBlocker = false;
                            result.errors.push(error);
                        }                                                
                        
                        return result;
                    },
                    _isValidationRequired: function(viewModel) {
                        return viewModel.sheetActivities.isAuth();
                    }
                };
            };
            
            Sheet4Validator.prototype._createRuleQc24031 = function() {
                return {
                    qccode: 24031,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var amount09F = viewModel.sheet4.section9.getTr09FAmount();
                        
                        if (numericUtil.toNum(amount09F, 0)  < 0) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.isNonBlocker = true;
                            result.errors.push(error);
                            var flag = sheetValidationObjectFactory.createQcFlag('9F', this.qccode);
                            result.flags.push(flag);
                        }
                        return result;
                    }
                };
            };
            
            Sheet4Validator.prototype._createRuleQc24041 = function() {
                return {
                    qccode: 24041,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        
                        arrayUtil.forEach(viewModel.sheet4.section9.getTr09ATradePartners(), function(tradePartner, ctx) {
                            var tpAmount = viewModel.sheet4.section9.getTr09A_addAmountOfTradePartner(tradePartner.PartnerId);
                            
                            if (objectUtil.isNull(tpAmount.amount) || tpAmount.amount === 0) {
                                return;
                            }
                            if ( stringUtil.isBlank(tpAmount.comment)){
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                result.errors.push(error);
                                ctx.breakLoop = true; // show only once
                            }
                        });
                        return result;
                    }
                };
            };

            Sheet4Validator.prototype._createRuleQc24042 = function() {
                return {
                    qccode: 24042,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        var found = 0;

                        arrayUtil.forEach(viewModel.sheet4.section9.getTr09ATradePartners(), function(tradePartner) {
                            var tpAmount = viewModel.sheet4.section9.getTr09A_addAmountOfTradePartner(tradePartner.PartnerId);

                            if (objectUtil.isNull(tpAmount.amount) || tpAmount.amount === 0) {
                                return;
                            }

                            if (!stringUtil.isBlank(tpAmount.comment)) {
                                if (!( found) ++ ) {
                                    var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                    error.isNonBlocker = true;
                                    result.errors.push(error);
                                }

                                var flag = sheetValidationObjectFactory.createQcFlag('9A_add', 24041, null, tradePartner.PartnerId); // WARNING THE FLAG IS WITH OTHER QC CODE
                                result.flags.push(flag);

                            }
                        });

                        return result;
                    }
                };
            };
            
            Sheet4Validator.prototype._createRuleQc24043 = function() {
                return {
                    qccode: 24043,
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var sum09A_add = numericUtil.toNum(viewModel.sheet4.section9.getSectionData().tr_09A_add.SumOfPartnerAmounts, 0);
                        
                        if (sum09A_add < 0) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.isNonBlocker = true;
                            result.errors.push(error);
                            var that = this;
                            var vm = viewModel;
                            
                            arrayUtil.forEach(viewModel.sheet4.section9.getTr09ATradePartners(), function(tradePartner) {
                                if (numericUtil.toNum( vm.sheet4.section9.getTr09A_addAmountOfTradePartner(tradePartner.PartnerId).amount , 0) !== 0 ) {
                                    var flag = sheetValidationObjectFactory.createQcFlag('9A_add', that.qccode, null, tradePartner.PartnerId);
                                    result.flags.push(flag);
                                }
                            });
                        }
                        
                        return result;
                    }
                };
            };
            
            return new Sheet4Validator();
        }
    ]);
})();
