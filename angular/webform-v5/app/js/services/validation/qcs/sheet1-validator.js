(function () {
    angular.module('FGases.services.validation.qcs').factory('sheet1Validator', [

        '$translate', 'sheetTransactionValidator', 'sheetValidationObjectFactory', 'gasHelper', 'transactionYearProvider',
        'objectUtil', 'arrayUtil', 'stringUtil', 'numericUtil',

        function ($translate, sheetTransactionValidator, sheetValidationObjectFactory, gasHelper, transactionYearProvider,
            objectUtil, arrayUtil, stringUtil, numericUtil) {

            function Sheet1Validator() {
                var that = this;
                this.transactionValidations = [{
                        transaction: {
                            id: 'tr_01B',
                            label: '01B'
                        },
                        rules: [that._createRuleQc2072Plus2073(), that._createRuleQc2028('tr_01B'), that._createRuleQc2029()]
                    },
                    {
                        transaction: {
                            id: 'tr_01Aa',
                            label: '01Aa'
                        },
                        rules: [that._createRuleQc24115(), that._createRuleQc24113()]
                    },
                    {
                        transaction: {
                            id: 'tr_01A_a',
                            label: '01A_a'
                        },
                        rules: [that._createRuleQc24112()]
                    },
                    {
                        transaction: {
                            id: 'tr_01A_a_own',
                            label: '01A_a_own'
                        },
                        rules: [that._createRuleQc2028('tr_01A_a_own')]
                    },
                    {
                        transaction: {
                            id: 'tr_01A_fs',
                            label: '01A_fs'
                        },
                        rules: [that._createRuleQc20101()]
                    },
                    {
                        transaction: {
                            id: 'tr_01A_fs',
                            label: '01A_fs'
                        },
                        rules: [that._createRuleQc2455()]
                    },
                    {
                        transaction: {
                            id: 'tr_01A_fs1',
                            label: '01A_fs1'
                        },
                        rules: [that._createRuleQc24114()]
                    },
                    {
                        transaction: {
                            id: 'tr_02A',
                            label: '02A'
                        },
                        rules: [that._createRuleQc2411(), that._createRuleQc2412(), that._createRuleQC24109()]
                    },
                    {
                        transaction: {
                            id: 'tr_02App',
                            label: '02App'
                        },
                        rules: [that._createRuleQc24106()]
                    },
                    {
                        transaction: {
                            id: 'tr_02B',
                            label: '02B'
                        },
                        rules: [that._createRuleQc2410()]
                    },
                    {
                        transaction: {
                            id: 'tr_02C',
                            label: '02C'
                        },
                        rules: [that._createRuleQc24107()]
                    },
                    {
                        transaction: {
                            id: 'tr_02D',
                            label: '02D'
                        },
                        rules: [that._createRuleQc24108(), that._createRule02DQc2409()]
                    },
                    {
                        transaction: {
                            id: 'tr_02E',
                            label: '02E'
                        },
                        rules: [that._createRuleQc24110()]
                    },
                    {
                        transaction: {
                            id: 'tr_03App',
                            label: '03App'
                        },
                        rules: [that._createRuleQc24105()]
                    },
                    {
                        transaction: {
                            id: 'tr_03G',
                            label: '03G'
                        },
                        rules: [that._createRuleQc24104(), that._createRuleQc24111()]
                    },
                    {
                        transaction: {
                            id: 'tr_03H',
                            label: '03H'
                        },
                        rules: [that._createRuleQc2463(), that._createRule03HQc2409()]
                    },
                    {
                        transaction: {
                            id: 'tr_03I',
                            label: '03I'
                        },
                        rules: [that._createRuleQc24100()]
                    },
                    {
                        transaction: {
                            id: 'tr_04A',
                            label: '04A'
                        },
                        rules: [that._createRuleQc2055('tr_04A', '4A', '4F')]
                    },
                    {
                        transaction: {
                            id: 'tr_04B',
                            label: '04B'
                        },
                        rules: [that._createRuleQc2055('tr_04B', '4B', '4G')]
                    },
                    {
                        transaction: {
                            id: 'tr_04C',
                            label: '04C'
                        },
                        rules: [that._createRuleQc2055('tr_04C', '4C', '4H')]
                    },
                    {
                        transaction: {
                            id: 'tr_04G',
                            label: '04G'
                        },
                        rules: [that._createRuleQc2024()]
                    },
                    {
                        transaction: {
                            id: 'tr_04H',
                            label: '04H'
                        },
                        rules: [that._createRuleQc2025()]
                    },
                    {
                        transaction: {
                            id: 'tr_04M',
                            label: '04M'
                        },
                        rules: [that._createRuleQc2026()]
                    },
                    {
                        transaction: {
                            id: 'tr_02A',
                            label: '02A'
                        },
                        rules: [that._createRuleQc24118('tr_02A',"tr_02A_Countries")]
                    },
                    {
                        transaction: {
                            id: 'tr_03A',
                            label: '03A'
                        },
                        rules: [that._createRuleQc24118('tr_03A', "tr_03A_Countries")]
                    }
                ];
            }

            Sheet1Validator.prototype.validate = function (viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };

            Sheet1Validator.prototype._createRuleQc24118 = function (transactionId,transactionCountries) {
                return {
                    qccode: 24118,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                       // var countryId = viewModel._instance.FGasesReporting[formId].+''+transactionId+''+_Countries

                        /*if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }*/

                        if (viewModel._instance.FGasesReporting[formId][transactionCountries] == null) {
                            return result;
                        }
                        if (viewModel._instance.FGasesReporting[formId][transactionCountries].Country != null) {
                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId][transactionCountries].Country.length; p++) {
                            if (viewModel._instance.FGasesReporting[formId][transactionCountries].Country[p].CountryId == "00") {

                                for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {

                                    //var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)

                                    if ((transactionId == "tr_02A") && (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][transactionId].CountrySpecific.Country != null)) {
                                        let amount = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][transactionId].CountrySpecific.Country[p].Amount;
                                        let amount2 = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02App.CountrySpecific.Country[p].Amount;
                                        let amount3 = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02C.CountrySpecific.Country[p].Amount;
                                        let amount4 = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02D.CountrySpecific.Country[p].Amount;
                                        let amount5 = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02E.CountrySpecific.Country[p].Amount;
                                        
                                        if (!(((objectUtil.isNull(amount)) || (amount == "")) && ((objectUtil.isNull(amount2)) || (amount2 == "")) && ((objectUtil.isNull(amount3)) || (amount3 == "")) && ((objectUtil.isNull(amount4)) || (amount4 == "")) && ((objectUtil.isNull(amount5)) || (amount5 == ""))))  {
                                            
                                            var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                            error.gasIndex = i;
                                            error.isNonBlocker = true;
                                            error.message = $translate.instant("validation_messages.qc_24118.warning_text");/*, {
                                                gas: viewModel.getReportedGasById(gas.GasId).Name,
                                                
                                                section: "2A"
                                            });*/
                                            result.errors.push(error);
                                            var flag = sheetValidationObjectFactory.createQcFlag('2A', that.qccode, viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode);
                                            result.flags.push(flag);


                                        }

                                    } else if ((transactionId == "tr_03A") && (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][transactionId].CountrySpecific.Country!=null)) {

                                        let amount = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][transactionId].CountrySpecific.Country[p].Amount;
                                        let amount2 = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03G.CountrySpecific.Country[p].Amount;
                                        let amount3 = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03H.CountrySpecific.Country[p].Amount;
                                        let amount4 = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03I.CountrySpecific.Country[p].Amount;

                                        if (!((((objectUtil.isNull(amount)) || (amount == "")) && ((objectUtil.isNull(amount2)) || (amount2 == "")) && ((objectUtil.isNull(amount3)) || (amount3 == "")) && ((objectUtil.isNull(amount4)) || (amount4 == ""))))) {
                                           

                                            var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                            error.gasIndex = i;
                                            error.isNonBlocker = true;
                                            error.message = $translate.instant("validation_messages.qc_24118.warning_text");/*, {
                                                gas: viewModel.getReportedGasById(gas.GasId).Name,
                                               
                                                section: "3A"
                                            });*/
                                            result.errors.push(error);
                                            var flag = sheetValidationObjectFactory.createQcFlag('3A', that.qccode, viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode);
                                            result.flags.push(flag);

                                        }
                                    }

                                  
                                }

                            }

                            
                        }

                    }

                        return result;
                    },
                    /*_isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isE();
                    }*/
                };
            };

            Sheet1Validator.prototype._createRuleQc2028 = function (transactionId) {
                return {
                    qccode: 2028,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (viewModel.sheetActivities.isD()) {
                            return result;
                        }

                        var gasAmounts01 = viewModel.sheet1.section1.getGasAmounts(transactionId);

                        if (gasHelper.calculateSum(gasAmounts01) > 1 || gasHelper.calculateSumOfAllCO2Eq(viewModel.getReportedGases(), gasAmounts01) > 1000) {

                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            result.errors.push(error);

                            var sectionValue2028 = [];
                            var sectionMessage2028 = [];
                            if (transactionId == 'tr_01A_a_own') {
                                sectionValue2028.push("1A_a_own")
                            }
                            if (transactionId == 'tr_01B') {
                                sectionValue2028.push("1B")
                            }

                            var commentedAmount01B = null;
                            for (var i = 0; i < gasAmounts01.length; i++) {
                                if (!objectUtil.isNull(gasAmounts01[i].amount) && gasAmounts01[i].amount != 0) {
                                    if (stringUtil.isEmpty(gasAmounts01[i].comment)) {
                                        commentedAmount01B = null;
                                        break;
                                    } else {
                                        commentedAmount01B = gasAmounts01[i];
                                    }
                                }
                            }
                            /*var commentedAmount01B = arrayUtil.forEach(gasAmounts01, function (gasAmounts01) {
                                if (objectUtil.isNull(gasAmounts01.amount) || gasAmounts01.amount != 0) {
                                    if (stringUtil.isEmpty(gasAmounts01.comment)) {
                                        return
                                    } else {
                                        return !stringUtil.isEmpty(gasAmounts01.comment);
                                    }
                                }
                            });*/

                            if (!objectUtil.isNull(commentedAmount01B)) {
                                error.isNonBlocker = true;
                                if (transactionId == 'tr_01B') {
                                    var flag = sheetValidationObjectFactory.createQcFlag('1B', this.qccode, commentedAmount01B.id);
                                } else {
                                    var flag = sheetValidationObjectFactory.createQcFlag('1A_a_own', this.qccode, commentedAmount01B.id);
                                }
                                result.flags.push(flag);
                            } else {
                                error.isNonBlocker = false;
                                if (transactionId == 'tr_01B') {
                                    sectionMessage2028.push("1B");
                                } else {
                                    sectionMessage2028.push("1A_a_own");
                                }
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

            Sheet1Validator.prototype._createRuleQc2029 = function () {
                return {
                    qccode: 2029,
                    validate: function (viewModel) {
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
                            if (gasAmounts05A[0].amount > 0) {
                                return result;
                            }
                        }

                        var gasAmounts08D = viewModel.sheet6.section8.getGasAmounts('tr_08D');
                        var gasAmounts01A_a_own = viewModel.sheet1.section1.getGasAmounts('tr_01A_a_own');
                        var gasAmounts01B = viewModel.sheet1.section1.getGasAmounts('tr_01B');
                        var that = this;

                        arrayUtil.forEach(gasAmounts01A_a_own, function (gasAmount01A) {
                            var gasAmount08D = arrayUtil.selectSingle(gasAmounts08D, function (gas) {
                                return gas.id === gasAmount01A.id;
                            });

                            var gasAmount01A_a_own = arrayUtil.selectSingle(gasAmounts01A_a_own, function (gas) {
                                return gas.id === gasAmount01A.id;
                            });

                            var gasAmount01B = arrayUtil.selectSingle(gasAmounts01B, function (gas) {
                                return gas.id === gasAmount01A.id;
                            });

                            if (objectUtil.isNull(gasAmount01A_a_own.amount) && objectUtil.isNull(gasAmount01B.amount)) {
                                return;
                            }

                            if (objectUtil.isNull(gasAmount08D.amount) || (gasAmount01A_a_own.amount + gasAmount01B.amount) > gasAmount08D.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount01A.index;
                                result.errors.push(error);
                                var sectionValue2029 = [];
                                var sectionMessage2029 = [];
                                if (gasAmount01A_a_own.amount > 0) {
                                    sectionValue2029.push("1A_a_own")
                                }
                                if (gasAmount01B.amount > 0) {
                                    sectionValue2029.push("1B")
                                }

                                if ( gasAmount01A_a_own.amount <= gasAmount08D.amount && gasAmount01B.amount <= gasAmount08D.amount) {
                                    if (!stringUtil.isEmpty(gasAmount01A_a_own.comment) || !stringUtil.isEmpty(gasAmount01B.comment)) {
                                        error.isNonBlocker = true;
                                    } else {
                                        sectionMessage2029 = sectionValue2029;
                                    }
                                } else {
                                    if ((gasAmount01A_a_own.amount > gasAmount08D.amount && stringUtil.isEmpty(gasAmount01A_a_own.comment)) || (gasAmount01B.amount > gasAmount08D.amount && stringUtil.isEmpty(gasAmount01B.comment))) {
                                        error.isNonBlocker = false;
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

            Sheet1Validator.prototype._createRuleQc2072Plus2073 = function () {
                var that = this;

                return {
                    validate: function (viewModel) {
                        var qc2073 = that._createRuleQc2073();
                        var result = qc2073.validate(viewModel);

                        if (result.errors.length > 0) {
                            return result;
                        }

                        var qc2072 = that._createRuleQc2072();

                        return qc2072.validate(viewModel);
                    }
                };
            };

            Sheet1Validator.prototype._createRuleQc2072 = function () {
                return {
                    qccode: 2072,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        var gasAmounts01B = viewModel.sheet1.section1.getGasAmounts('tr_01B');
                        var gasAmounts08D = viewModel.sheet6.section8.getGasAmounts('tr_08D');
                        var that = this;

                        arrayUtil.forEach(gasAmounts01B, function (gasAmount01B) {
                            if (objectUtil.isNull(gasAmount01B.amount)) {
                                return;
                            }

                            var reportedGas = viewModel.getReportedGasById(gasAmount01B.id);

                            if (!viewModel.sheet1.section1.isGasApplicableToTr01B(reportedGas)) {
                                return;
                            }

                            var gasAmount08D = arrayUtil.selectSingle(gasAmounts08D, function (item) {
                                return item.id === gasAmount01B.id;
                            });

                            if (objectUtil.isNull(gasAmount08D.amount) || gasAmount01B.amount > gasAmount08D.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount01B.index;
                                result.errors.push(error);

                                if (!stringUtil.isEmpty(gasAmount01B.comment)) {
                                    error.isNonBlocker = true;
                                    var flag = sheetValidationObjectFactory.createQcFlag('1B', that.qccode, gasAmount01B.id);
                                    result.flags.push(flag);
                                }
                            }
                        });

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() && viewModel.sheetActivities.isD();
                    }
                };
            };

            Sheet1Validator.prototype._createRuleQc2073 = function () {
                return {
                    qccode: 2073,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (!viewModel.sheetActivities.isD() || !viewModel.sheetActivities.isI_HFC()) {
                            return result;
                        }

                        var ownTradePartner = viewModel.sheet2.section5.getTr05AOwnTradePartner();

                        if (objectUtil.isNull(ownTradePartner)) {
                            return result;
                        }

                        var gasAmounts01B = viewModel.sheet1.section1.getGasAmounts('tr_01B');
                        var gasAmounts05A = viewModel.sheet2.section5.getGasAmountsOfTradePartner('tr_05A', ownTradePartner.PartnerId);
                        var gasAmounts08D = viewModel.sheet6.section8.getGasAmounts('tr_08D');
                        var that = this;

                        arrayUtil.forEach(gasAmounts05A, function (gasAmount05A) {
                            var gasAmount01B = arrayUtil.selectSingle(gasAmounts01B, function (item) {
                                return item.id === gasAmount05A.id;
                            });
                            var gasAmount08D = arrayUtil.selectSingle(gasAmounts08D, function (item) {
                                return item.id === gasAmount05A.id;
                            });

                            var amount01B = objectUtil.defaultIfNull(gasAmount01B.amount, 0);
                            var amount05A = objectUtil.defaultIfNull(gasAmount05A.amount, 0);
                            var amount08D = objectUtil.defaultIfNull(gasAmount08D.amount, 0);

                            if (amount05A + amount01B <= amount08D) {
                                return;
                            }

                            var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                            error.gasIndex = gasAmount01B.index;
                            result.errors.push(error);

                            if (!stringUtil.isEmpty(gasAmount01B.comment)) {
                                error.isNonBlocker = true;
                                error.message = $translate.instant('validation_messages.qc_2073.warning_text');
                                var flag = sheetValidationObjectFactory.createQcFlag('1B', that.qccode, gasAmount01B.id);
                                result.flags.push(flag);
                            }
                        });

                        return result;
                    }
                };
            };

            Sheet1Validator.prototype._createRule02DQc2409 = function () {
                return {
                    qccode: 2409,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        if(viewModel._instance.FGasesReporting[formId].tr_02A_Countries == null){
                            return result;
                        }

                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country.length; p++) {

                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {
                                    let country = viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country[p];
                                    let gasAmount02D = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02D.CountrySpecific.Country[p];
                                    if (!objectUtil.isNull(gasAmount02D) && numericUtil.toNum(gasAmount02D.Amount,0) !== 0 && stringUtil.isEmpty(gasAmount02D.Comment)) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = i;
                                        error.message = $translate.instant("validation_messages.qc_2409_partner.error_text", {
                                            gas: viewModel.getReportedGasById(gas.GasId).Name,
                                            country: country.CountryName,
                                            section: "2D"
                                        });
                                        result.errors.push(error);
                                    }
                                }
                            }
                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE() ;
                    }
                };
            };

            Sheet1Validator.prototype._createRule03HQc2409 = function () {
                return {
                    qccode: 2409,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        if(viewModel._instance.FGasesReporting[formId].tr_03A_Countries == null){
                            return result;
                        }

                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country.length; p++) {

                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {
                                    let country = viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country[p];
                                    let gasAmount03H = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03H.CountrySpecific.Country[p];
                                    if (!objectUtil.isNull(gasAmount03H) && numericUtil.toNum(gasAmount03H.Amount,0) !== 0 && stringUtil.isEmpty(gasAmount03H.Comment)) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = i;
                                        error.message = $translate.instant("validation_messages.qc_2409_partner.error_text", {
                                            gas: viewModel.getReportedGasById(gas.GasId).Name,
                                            country: country.CountryName,
                                            section: "3H"
                                        });
                                        result.errors.push(error);
                                    }
                                }
                            }
                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isE();
                    }                    
                };
            };

            Sheet1Validator.prototype._createRuleQc2411 = function () {
                return {
                    qccode: 2411,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var gasAmounts02A = viewModel.sheet1.section2.getGasTotalAmountForRow('tr_02A');
                        var gasAmounts11Q = viewModel.sheet7.section11.getGasAmounts('tr_11Q');
                        var that = this;

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        arrayUtil.forEach(gasAmounts02A, function (gasAmount02A) {
                            var amount02A = objectUtil.defaultIfNull(gasAmount02A.amount, 0);

                            if (amount02A === 0) {
                                return;
                            }

                            var gasAmount11Q = arrayUtil.selectSingle(gasAmounts11Q, function (item) {
                                return item.id === gasAmount02A.id;
                            });
                            var amount11Q = objectUtil.defaultIfNull(gasAmount11Q.amount, 0);

                            if (amount11Q === 0 || Math.abs(amount02A - amount11Q) > 1) {
                                return;
                            }

                            var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                            error.isNonBlocker = true;
                            error.gasIndex = gasAmount02A.index;
                            error.message = $translate.instant('validation_messages.qc_2411.error_text', {
                                gasName: viewModel.getReportedGasById(gasAmount02A.id).Name
                            });
                            result.errors.push(error);
                            var flag = sheetValidationObjectFactory.createQcFlag('2A', that.qccode, gasAmount02A.id);
                            result.flags.push(flag);
                        });

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE() ;
                    }
                };
            };

            Sheet1Validator.prototype._createRuleQc2412 = function () {
                return {
                    qccode: 2412,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var amount09F = viewModel.sheet4.section9.getTr09FAmount();
                        var amount09G = viewModel.sheet4.section9.getTr09GAmount();
                        var gasAmounts02A = viewModel.sheet1.section2.getGasTotalAmountForRow('tr_02A');
                        var that = this;

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        arrayUtil.forEach(gasAmounts02A, function (gasAmount02A, loopContext) {
                            var v09F = numericUtil.toNum(amount09F, 0);
                            var v09G = numericUtil.toNum(amount09G, 0);

                            if (gasAmount02A.amount > 0 && v09F > 0 && v09G === 0) {                                
                                var flag = sheetValidationObjectFactory.createQcFlag('2A', that.qccode, gasAmount02A.id, null, "9F: " + v09F);
                                result.flags.push(flag);
                                loopContext.breakLoop = true;
                            }
                        });
                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE() ;
                    }
                };
            };


            Sheet1Validator.prototype._createRuleQc2055 = function (transactionId, transactionCode, stockTransactionCode) {
                return {
                    qccode: 2055,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var gasAmounts = viewModel.sheet1.section4.getGasAmounts(transactionId);
                        var that = this;

                        arrayUtil.forEach(gasAmounts, function (gasAmount) {
                            var stock = viewModel.getGasStockByTransaction(transactionCode, gasAmount.id); //stocks from previous years are now stored under its transaction code (not stockTransactionCode)

                            if (objectUtil.isNull(stock)) {

                                return;
                            }

                            else if ((gasAmount.amount < stock.amount - 0.5) || ((gasAmount.amount == 0) || (objectUtil.isNull(gasAmount.amount)))) {
                                if (viewModel.sheet1.section4.isProducerOrImporter()) {
                                    /* var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                     error.gasIndex = gasAmount.index;
                                     result.errors.push(error);
                                     var translationKey = "validation_messages.qc_2055.error_text";
                                     error.message = that._formatErrorMessage(translationKey, viewModel, transactionCode, stockTransactionCode, gasAmount, stock);
                                     return;*/
                                    if ((objectUtil.isNull(gasAmount.comment) || stringUtil.isEmpty(gasAmount.comment))/* && (gasAmount.amount > 0)*/) {

                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.isNonBlocker = false;
                                        translationKey = "validation_messages.qc_2055.error_text";
                                        var flag = sheetValidationObjectFactory.createQcFlag(transactionCode, that.qccode, gasAmount.id);
                                        result.flags.push(flag);
                                        result.errors.push(error);
                                        error.message = that._formatErrorMessage(translationKey, viewModel, transactionCode, stockTransactionCode, gasAmount, stock);
                                        return;

                                    } else {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.isNonBlocker = true;
                                        translationKey = "validation_messages.qc_2055.warning_text";
                                        var flag = sheetValidationObjectFactory.createQcFlag(transactionCode, that.qccode, gasAmount.id);
                                        result.flags.push(flag);
                                        result.errors.push(error);
                                        error.message = that._formatErrorMessage(translationKey, viewModel, transactionCode, stockTransactionCode, gasAmount, stock);
                                        return;
                                    }

                                } else {
                                    var flag = sheetValidationObjectFactory.createQcFlag(transactionCode, that.qccode, gasAmount.id);
                                    result.flags.push(flag);
                                }
                                /* if ((objectUtil.isNull(gasAmount.comment) || stringUtil.isEmpty(gasAmount.comment))) {
 
                                     var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                     error.isNonBlocker = false;
                                     translationKey = "validation_messages.qc_2055.error_text";
                                     var flag = sheetValidationObjectFactory.createQcFlag(transactionCode, that.qccode, gasAmount.id);
                                     result.flags.push(flag);
                                     result.errors.push(error);
                                     error.message = that._formatErrorMessage(translationKey, viewModel, transactionCode, stockTransactionCode, gasAmount, stock);
                                     return;
 
                                 } else {
                                     var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                     error.isNonBlocker = true;
                                     translationKey = "validation_messages.qc_2055.warning_text";
                                     var flag = sheetValidationObjectFactory.createQcFlag(transactionCode, that.qccode, gasAmount.id);
                                     result.flags.push(flag);
                                     result.errors.push(error);
                                     error.message = that._formatErrorMessage(translationKey, viewModel, transactionCode, stockTransactionCode, gasAmount, stock);
                                     return;
                                 }*/
                            }


                        });


                        return result;
                    },
                    _formatErrorMessage: function (translationKey, viewModel, transactionCode, stockTransactionCode, gasAmount, stock) {
                        var msg = $translate.instant(translationKey);
                        var reportedGas = viewModel.getReportedGasById(gasAmount.id);
                        msg = msg.replace(/\[gas\]/g, reportedGas.Name);
                        msg = msg.replace(/\[transaction_year\]/g, transactionYearProvider.getTransactionYear().toString());
                        msg = msg.replace(/\[previous_year\]/g, (transactionYearProvider.getTransactionYear() - 1).toString());
                        if (stock == null) msg = msg.replace(/\[stock_value\]/g, 'none');
                        else msg = msg.replace(/\[stock_value\]/g, stock.amount);
                        msg = msg.replace(/\[field_code\]/g, transactionCode);
                        msg = msg.replace(/\[stock_field_code\]/g, stockTransactionCode);

                        return msg;
                    }
                };
            };


            Sheet1Validator.prototype._createRuleQc2410 = function () {
                return {
                    qccode: 2410,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var gasAmounts = viewModel.sheet1.section2.getGasAmounts('tr_02B');
                        var that = this;

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        arrayUtil.forEach(gasAmounts, function (gasAmount) {
                            var amount = gasAmount.amount;

                            if (objectUtil.isNull(amount) || amount === 0)
                                return;

                            if (!stringUtil.isEmpty(gasAmount.comment)) {
                                //2B value with comment => create flag
                                var flag = sheetValidationObjectFactory.createQcFlag('2B', that.qccode, gasAmount.id);
                                result.flags.push(flag);
                                return;
                            }
                            // 2B value without comment
                            var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                            error.gasIndex = gasAmount.index;
                            error.message = $translate.instant("validation_messages.qc_2410.error_text", {
                                gas: viewModel.getReportedGasById(gasAmount.id).Name
                            });
                            result.errors.push(error);
                        });

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE() ;
                    }
                };
            };

            /**START 1A_FS comment validator  */

            /*Sheet1Validator.prototype._createRuleQc2455 = function () {
                return {
                    qccode: 2455,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var gasAmounts = viewModel.sheet1.section1.getGasTotalAmountForRow('tr_01A_fs');
                        var that = this;

                        arrayUtil.forEach(gasAmounts, function (gasAmount) {
                            var amount = gasAmount.amount;

                            if (objectUtil.isNull(amount) || amount === 0)
                                return;

                            if (!stringUtil.isEmpty(gasAmount.comment)) {
                                //1A_FS value with comment => create flag
                                var flag = sheetValidationObjectFactory.createQcFlag('01A_fs', that.qccode, gasAmount.id);
                                result.flags.push(flag);
                                return;
                            }
                            // 1A_FS value without comment
                            var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                            error.gasIndex = gasAmount.index;
                            error.message = $translate.instant("validation_messages.qc_2455.error_text", {
                                gas: viewModel.getReportedGasById(gasAmount.id).Name
                            });
                            result.errors.push(error);
                        });

                        return result;
                    }
                };
            };*/

            Sheet1Validator.prototype._createRuleQc2455 = function () {
                return {
                    qccode: 2455,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var dataGases = viewModel.sheet1.section1.getSectionData().Gas;
                        var that = this;

                        arrayUtil.forEach(dataGases, function (dataGas) {
                            var countryArray = dataGas['tr_01A_fs'].CountrySpecific.Country;
                            if (!objectUtil.isNull(countryArray)) {
                                for (var i = 0; i < countryArray.length; i++) {
                                    var gasAmount = viewModel.sheet1.section1.getGasAmountOfCountryGasSpecific('tr_01A_fs', countryArray[i].CountryId, dataGas.GasCode);
                                    var amount = gasAmount.amount;

                                    /*if (objectUtil.isNull(amount) || amount === 0)
                                        return;

                                    if (!stringUtil.isEmpty(gasAmount.comment)) {
                                        //1A_FS value with comment => create flag
                                        var flag = sheetValidationObjectFactory.createQcFlag('01A_fs', that.qccode, gasAmount.id);
                                        result.flags.push(flag);
                                        return;
                                    }
                                    // 1A_FS value without comment
                                    var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                    error.gasIndex = gasAmount.index;
                                    error.message = $translate.instant("validation_messages.qc_2455.error_text", {
                                        gas: viewModel.getReportedGasById(gasAmount.id).Name
                                    });
                                    result.errors.push(error);*/
                                    if (objectUtil.isNull(amount) || amount === 0 || !stringUtil.isEmpty(gasAmount.comment)) {
                                        if (!stringUtil.isEmpty(gasAmount.comment)) {
                                            //1A_FS value with comment => create flag
                                            var flag = sheetValidationObjectFactory.createQcFlag('01A_fs', that.qccode, gasAmount.id);
                                            result.flags.push(flag);
                                        }
                                    } else {    // 1A_FS value without comment
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = gasAmount.index;
                                        error.message = $translate.instant("validation_messages.qc_2455.error_text", {
                                            gas: viewModel.getReportedGasById(gasAmount.id).Name
                                        });
                                        result.errors.push(error);
                                    }


                                }
                            } else {
                                return;
                            }
                        });

                        return result;
                    }
                };
            };

            /**END 1A_FS comment validator  */


            /** 
             * sum(2C+2D) <= 2A
             * **/
            Sheet1Validator.prototype._createRuleQC24109 = function () {
                return {
                    qccode: 24109,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        if(viewModel._instance.FGasesReporting[formId].tr_02A_Countries == null){
                            return result;
                        }

                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }
                        viewModel.isUnspecifiedMix = function (reportedGas) {
                            if (reportedGas.GasId) {
                                return reportedGas.GasId == 187;
                            }
                            return false;
                        };
                        viewModel.containsHFC = function (gasOrComponent) {
                            return containsHFCUtilFn(gasOrComponent) || viewModel.isUnspecifiedMix(gasOrComponent);
                        }; // delegator function for scope               

                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country.length; p++) {


                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {
                                    let sum2Cand2D = +viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02C.CountrySpecific.Country[p].Amount + +viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02D.CountrySpecific.Country[p].Amount;
                                    if (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02A.CountrySpecific.Country[p].Amount < sum2Cand2D) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = i;/*22;*/
                                        error.message = "2C and 2D indicate the amount of virgin and recycled HFCS imported per country as a subset of overall imports per country and thus can not exceed overall imports per country. Please correct your values and take care that all values have to be reported country specific.";
                                        result.errors.push(error);
                                    }

                                }
                            }

                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE() ;
                    }
                };
            };

            /** 
             * 02App 
             * **/
            Sheet1Validator.prototype._createRuleQc24106 = function () {
                return {
                    qccode: 24106,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var tr02App_gasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_02App');
                        var tr02AgasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_02A');
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }
                        
                        if(viewModel._instance.FGasesReporting[formId].tr_02A_Countries == null){
                            return result;
                        }

                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }
                        viewModel.isUnspecifiedMix = function (reportedGas) {
                            if (reportedGas.GasId) {
                                return reportedGas.GasId == 187;
                            }
                            return false;
                        };
                        viewModel.containsHFC = function (gasOrComponent) {
                            return containsHFCUtilFn(gasOrComponent) || viewModel.isUnspecifiedMix(gasOrComponent);
                        }; // delegator function for scope

                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country.length; p++) {


                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {



                                    if (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02A.CountrySpecific.Country[p].Amount < ((+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02App.CountrySpecific.Country[p].Amount) + (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02C.CountrySpecific.Country[p].Amount) + (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02E.CountrySpecific.Country[p].Amount) + (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02D.CountrySpecific.Country[p].Amount))) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = i;/* 22;*/
                                        error.message = "The subset of overall imports per country per gas can not exceed overall imports per country par gas. Please correct your values and take care that all values have to be reported country specific.";

                                        /*error.message = "2A_pp indicates the amount of HFCs per country imported in pre-blended polyols as a subset of overall imports per country and thus can not exceed overall imports per country. Please correct your values and take care that all values have to be reported country specific.", {
                                            gas: viewModel.getReportedGasById(gas).Name
                                        });*/
                                        result.errors.push(error);
                                    }

                                }
                            }

                        }


                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE() ;
                    }
                };
            };

            /** 
           * 02App 
           * *
            Sheet1Validator.prototype._createRuleQc24106 = function () {
                return {
                    qccode: 24106,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var tr02App_gasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_02App');
                        var tr02AgasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_02A');
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        if (viewModel._instance.FGasesReporting[formId].tr_02A_Countries == null) {
                            return result;
                        }

                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }
                        viewModel.isUnspecifiedMix = function (reportedGas) {
                            if (reportedGas.GasId) {
                                return reportedGas.GasId == 187;
                            }
                            return false;
                        };
                        viewModel.containsHFC = function (gasOrComponent) {
                            return containsHFCUtilFn(gasOrComponent) || viewModel.isUnspecifiedMix(gasOrComponent);
                        }; // delegator function for scope

                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country.length; p++) {


                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {

                                    if (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02A.CountrySpecific.Country[p].Amount < +viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02App.CountrySpecific.Country[p].Amount) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = 22;
                                        error.message = "2A_pp indicates the amount of HFCs per country imported in pre-blended polyols as a subset of overall imports per country and thus can not exceed overall imports per country. Please correct your values and take care that all values have to be reported country specific.";
                                        result.errors.push(error);
                                    }

                                }
                            }

                        }


                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE();
                    }
                };
            };*/

            /** 
             * 02C 
             * **/
            Sheet1Validator.prototype._createRuleQc24107 = function () {
                return {
                    qccode: 24107,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var tr02C_gasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_02C');
                        var tr02AgasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_02A');
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        if(viewModel._instance.FGasesReporting[formId].tr_02A_Countries == null){
                            return result;
                        }

                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }
                        viewModel.isUnspecifiedMix = function (reportedGas) {
                            if (reportedGas.GasId) {
                                return reportedGas.GasId == 187;
                            }
                            return false;
                        };
                        viewModel.containsHFC = function (gasOrComponent) {
                            return containsHFCUtilFn(gasOrComponent) || viewModel.isUnspecifiedMix(gasOrComponent);
                        }; // delegator function for scope

                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country.length; p++) {


                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {

                                    //Since for each Gas with Amount Specific Reporting for A row, the row position is the same as the country position, 
                                    //lets use it. 
                                    if (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02A.CountrySpecific.Country[p].Amount < +viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02C.CountrySpecific.Country[p].Amount) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = 22;
                                        error.message = "2C indicates the amount of used, recycled or reclaimed hydrofluorocarbons imported per country  as a subset of overall imports per country and thus can not exceed overall imports per country. Please correct your values and take care that all values have to be reported country specific.";
                                        result.errors.push(error);
                                    }

                                }
                            }

                        }






                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE() ;
                    }
                };
            };

            /** 
             * 02D 
             * **/
            Sheet1Validator.prototype._createRuleQc24108 = function () {
                return {
                    qccode: 24108,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var tr02D_gasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_02D');
                        var tr02AgasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_02A');
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        if(viewModel._instance.FGasesReporting[formId].tr_02A_Countries == null){
                            return result;
                        }

                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }
                        viewModel.isUnspecifiedMix = function (reportedGas) {
                            if (reportedGas.GasId) {
                                return reportedGas.GasId == 187;
                            }
                            return false;
                        };
                        viewModel.containsHFC = function (gasOrComponent) {
                            return containsHFCUtilFn(gasOrComponent) || viewModel.isUnspecifiedMix(gasOrComponent);
                        }; // delegator function for scope



                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country.length; p++) {


                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {

                                    if (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02A.CountrySpecific.Country[p].Amount < +viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02D.CountrySpecific.Country[p].Amount) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = i;/*22;*/
                                        error.message = "2D indicates the amount of virgin hydrofluorocarbons imported for feedstock use a subset of overall imports per country and thus can not exceed overall imports per country. Please correct your values and take care that all values have to be reported country specific.";
                                        result.errors.push(error);
                                    }

                                }
                            }

                        }
                        
                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE() ;
                    }
                };
            };

            /** 
             * 02E 
             * **/
            Sheet1Validator.prototype._createRuleQc24110 = function () {
                return {
                    qccode: 24110,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var tr02E_gasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_02E');
                        var tr02AgasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_02A');
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if(!this._isValidationRequired(viewModel)){
                            return result;
                        }

                        if(viewModel._instance.FGasesReporting[formId].tr_02A_Countries == null){
                            return result;
                        }

                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }
                        viewModel.isUnspecifiedMix = function (reportedGas) {
                            if (reportedGas.GasId) {
                                return reportedGas.GasId == 187;
                            }
                            return false;
                        };
                        viewModel.containsHFC = function (gasOrComponent) {
                            return containsHFCUtilFn(gasOrComponent) || viewModel.isUnspecifiedMix(gasOrComponent);
                        }; // delegator function for scope

                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country.length; p++) {


                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {

                                    if (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02A.CountrySpecific.Country[p].Amount < +viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02E.CountrySpecific.Country[p].Amount) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = gas.Code;
                                        error.message = "2E indicates the amount  of virgin hydrofluorocarbons imported for uses exempted under the Montreal Protocol as a subset of overall imports per country and thus can not exceed overall imports per country. Please correct your values and take care that all values have to be reported country specific.";
                                        result.errors.push(error);
                                    }

                                }
                            }

                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE() ;
                    }
                };
            };


            /** 
             * 03App 
             * **/
            Sheet1Validator.prototype._createRuleQc24105 = function () {
                return {
                    qccode: 24105,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var tr03App_gasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_03App');
                        var tr03AgasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_03A');
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        if(viewModel._instance.FGasesReporting[formId].tr_03A_Countries == null){
                            return result;
                        }

                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }
                        viewModel.isUnspecifiedMix = function (reportedGas) {
                            if (reportedGas.GasId) {
                                return reportedGas.GasId == 187;
                            }
                            return false;
                        };
                        viewModel.containsHFC = function (gasOrComponent) {
                            return containsHFCUtilFn(gasOrComponent) || viewModel.isUnspecifiedMix(gasOrComponent);
                        }; // delegator function for scope



                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country.length; p++) {


                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {

                                    if (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03A.CountrySpecific.Country[p].Amount < (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03App.CountrySpecific.Country[p].Amount) + (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03G.CountrySpecific.Country[p].Amount) + (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03H.CountrySpecific.Country[p].Amount) + (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03I.CountrySpecific.Country[p].Amount)) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = i;/*gas.Code;*/
                                        error.message = "The partial amounts of HFCs  in section 3 must not exceed the total reported in section 3A for each country and for each gas. Please revise your data.";
                                        result.errors.push(error);


                                    }

                                }
                            }

                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isE();
                    }
                };
            };


            /** 
             * 03App 
             * *
            Sheet1Validator.prototype._createRuleQc24105 = function () {
                return {
                    qccode: 24105,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var tr03App_gasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_03App');
                        var tr03AgasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_03A');
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        if (viewModel._instance.FGasesReporting[formId].tr_03A_Countries == null) {
                            return result;
                        }

                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }
                        viewModel.isUnspecifiedMix = function (reportedGas) {
                            if (reportedGas.GasId) {
                                return reportedGas.GasId == 187;
                            }
                            return false;
                        };
                        viewModel.containsHFC = function (gasOrComponent) {
                            return containsHFCUtilFn(gasOrComponent) || viewModel.isUnspecifiedMix(gasOrComponent);
                        }; // delegator function for scope



                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country.length; p++) {


                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {

                                    if (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03A.CountrySpecific.Country[p].Amount < +viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03App.CountrySpecific.Country[p].Amount) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = gas.Code;
                                        error.message = "The partial amounts of HFCs in pre-blended polyols in section 3 must not exceed the total reported in section 3A for each country. Please revise your data.";
                                        result.errors.push(error);
                                    }

                                }
                            }

                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isE();
                    }
                };
            };*/


            /** 
                      * sum(2C+2D) <= 2A
                       sum(3G+3H) <= 3A
                      * **/
            Sheet1Validator.prototype._createRuleQc24111 = function () {
                return {
                    qccode: 24111,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }
                        
                        if(viewModel._instance.FGasesReporting[formId].tr_03A_Countries == null){
                            return result;
                        }

                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }
                        viewModel.isUnspecifiedMix = function (reportedGas) {
                            if (reportedGas.GasId) {
                                return reportedGas.GasId == 187;
                            }
                            return false;
                        };
                        viewModel.containsHFC = function (gasOrComponent) {
                            return containsHFCUtilFn(gasOrComponent) || viewModel.isUnspecifiedMix(gasOrComponent);
                        }; // delegator function for scope

                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country.length; p++) {

                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {
                                    let sum3Gand3H = +viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03G.CountrySpecific.Country[p].Amount + +viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03H.CountrySpecific.Country[p].Amount;
                                    if (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03A.CountrySpecific.Country[p].Amount < sum3Gand3H) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = i;/*22;*/
                                        error.message = "3G and 3H indicate the amount of virgin and recycled HFCS exported per country as a subset of overallexports per country and thus can not exceed overall exports per country. Please correct your values and take care that all values have to be reported country specific.";
                                        result.errors.push(error);
                                    }

                                }
                            }

                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isE();
                    }
                };
            };


            /** 
             * 03G 
             * **/
            Sheet1Validator.prototype._createRuleQc24104 = function () {
                return {
                    qccode: 24104,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var tr03G_gasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_03G');
                        var tr03AgasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_03A');
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }
                        
                        if(viewModel._instance.FGasesReporting[formId].tr_03A_Countries == null){
                            return result;
                        }
                        
                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }
                        viewModel.isUnspecifiedMix = function (reportedGas) {
                            if (reportedGas.GasId) {
                                return reportedGas.GasId == 187;
                            }
                            return false;
                        };
                        viewModel.containsHFC = function (gasOrComponent) {
                            return containsHFCUtilFn(gasOrComponent) || viewModel.isUnspecifiedMix(gasOrComponent);
                        }; // delegator function for scope

                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country.length; p++) {


                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {

                                    if (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03A.CountrySpecific.Country[p].Amount < +viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03G.CountrySpecific.Country[p].Amount) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = gas.Code;
                                        error.message = "The partial amounts of HFCs in used, recycled or reclaimed hydrofluorocarbons in section 3 must not exceed the total reported in section 3A for each country. Please revise your data.";
                                        result.errors.push(error);
                                    }

                                }
                            }

                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isE();
                    }
                };
            };


            /** 
             * 03H 
             * **/
            Sheet1Validator.prototype._createRuleQc2463 = function () {
                return {
                    qccode: 2463,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var tr03H_gasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_03H');
                        var tr03AgasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_03A');
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }
                        
                        if(viewModel._instance.FGasesReporting[formId].tr_03A_Countries == null){
                            return result;
                        }

                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }
                        viewModel.isUnspecifiedMix = function (reportedGas) {
                            if (reportedGas.GasId) {
                                return reportedGas.GasId == 187;
                            }
                            return false;
                        };
                        viewModel.containsHFC = function (gasOrComponent) {
                            return containsHFCUtilFn(gasOrComponent) || viewModel.isUnspecifiedMix(gasOrComponent);
                        }; // delegator function for scope

                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country.length; p++) {


                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {

                                    if (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03A.CountrySpecific.Country[p].Amount < +viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03H.CountrySpecific.Country[p].Amount) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = gas.Code;
                                        error.message = "The partial amounts of virgin hydrofluorocarbons exported for feedstock use in  section 3 must not exceed the total reported in section 3A for each country. Please revise your data.";
                                        result.errors.push(error);
                                    }

                                }
                            }

                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isE();
                    }
                };
            };

            /** 
             * 03I
             * **/
            Sheet1Validator.prototype._createRuleQc24100 = function () {
                return {
                    qccode: 24100,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var tr03H_gasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_03I');
                        var tr03AgasAmounts = viewModel.sheet1.section1.getGasAmounts('tr_03A');
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if(!this._isValidationRequired(viewModel)) {
                            return result;
                        }
                        
                        if(viewModel._instance.FGasesReporting[formId].tr_03A_Countries == null){
                            return result;
                        }
                        
                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }
                        viewModel.isUnspecifiedMix = function (reportedGas) {
                            if (reportedGas.GasId) {
                                return reportedGas.GasId == 187;
                            }
                            return false;
                        };
                        viewModel.containsHFC = function (gasOrComponent) {
                            return containsHFCUtilFn(gasOrComponent) || viewModel.isUnspecifiedMix(gasOrComponent);
                        }; // delegator function for scope

                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country.length; p++) {


                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {

                                    if (+viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03A.CountrySpecific.Country[p].Amount < +viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03I.CountrySpecific.Country[p].Amount) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = gas.Code;
                                        error.message = "The partial amounts of virgin hydrofluorocarbons exported for feedstock use in  section 3 must not exceed the total reported in section 3A for each country. Please revise your data.";
                                        result.errors.push(error);
                                    }

                                }
                            }

                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isE();
                    }
                };
            };

            Sheet1Validator.prototype._createRuleQc2024 = function () {
                return {
                    qccode: 2024,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        var gasAmounts04G = viewModel.sheet1.section4.getGasAmounts('tr_04G');
                        var gasAmounts01E = viewModel.sheet1.section1.getGasAmounts('tr_01E');
                        var gasAmounts02A = viewModel.sheet1.section2.getGasTotalAmountForRow('tr_02A');
                        var gasAmounts04B = viewModel.sheet1.section4.getGasAmounts('tr_04B');
                        var that = this;

                        arrayUtil.forEach(gasAmounts04G, function (gasAmount04G) {
                            if (objectUtil.isNull(gasAmount04G.amount)) {
                                return;
                            }

                            var reportedGas = viewModel.getReportedGasById(gasAmount04G.id);

                            if (!viewModel.sheet1.section4.isGasApplicableToTr04G(reportedGas)) {
                                return;
                            }

                            var amount01E = that._getGasAmount(gasAmounts01E, gasAmount04G.id);
                            var amount02A = that._getGasAmount(gasAmounts02A, gasAmount04G.id);
                            var amount04B = that._getGasAmount(gasAmounts04B, gasAmount04G.id);

                            if (gasAmount04G.amount > amount01E + amount02A + amount04B) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount04G.index;
                                result.errors.push(error);

                                if (!stringUtil.isEmpty(gasAmount04G.comment)) {
                                    error.isNonBlocker = true;
                                    var flag = sheetValidationObjectFactory.createQcFlag('4G', that.qccode, gasAmount04G.id);
                                    result.flags.push(flag);
                                }
                            }
                        });

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI();
                    },
                    _getGasAmount: function (gasAmounts, gasId) {
                        var gasAmount = arrayUtil.selectSingle(gasAmounts, function (item) {
                            return item.id === gasId;
                        });

                        return objectUtil.defaultIfNull(gasAmount.amount, 0);
                    }
                };
            };

            Sheet1Validator.prototype._createRuleQc2025 = function () {
                return {
                    qccode: 2025,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        var gasAmounts04H = viewModel.sheet1.section4.getGasAmounts('tr_04H');
                        var gasAmounts01E = viewModel.sheet1.section1.getGasAmounts('tr_01E');
                        var gasAmounts02A = viewModel.sheet1.section2.getGasTotalAmountForRow('tr_02A');
                        var gasAmounts04C = viewModel.sheet1.section4.getGasAmounts('tr_04C');
                        var that = this;

                        arrayUtil.forEach(gasAmounts04H, function (gasAmount04H) {
                            if (objectUtil.isNull(gasAmount04H.amount)) {
                                return;
                            }

                            var reportedGas = viewModel.getReportedGasById(gasAmount04H.id);

                            if (!viewModel.sheet1.section4.isGasApplicableToTr04G(reportedGas)) {
                                return;
                            }

                            var amount01E = that._getGasAmount(gasAmounts01E, gasAmount04H.id);
                            var amount02A = that._getGasAmount(gasAmounts02A, gasAmount04H.id);
                            var amount04C = that._getGasAmount(gasAmounts04C, gasAmount04H.id);

                            if (gasAmount04H.amount > amount01E + amount02A + amount04C) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount04H.index;
                                result.errors.push(error);

                                if (!stringUtil.isEmpty(gasAmount04H.comment)) {
                                    error.isNonBlocker = true;
                                    var flag = sheetValidationObjectFactory.createQcFlag('4H', that.qccode, gasAmount04H.id);
                                    result.flags.push(flag);
                                }
                            }
                        });

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI();
                    },
                    _getGasAmount: function (gasAmounts, gasId) {
                        var gasAmount = arrayUtil.selectSingle(gasAmounts, function (item) {
                            return item.id === gasId;
                        });

                        return objectUtil.defaultIfNull(gasAmount.amount, 0);
                    }
                };
            };

            Sheet1Validator.prototype._createRuleQc2026 = function () {
                return {
                    qccode: 2026,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        var section4Gases = viewModel.sheet1.section4.getSectionGases();
                        var that = this;

                        arrayUtil.forEach(section4Gases, function (section4Gas) {
                            var gasId = section4Gas.GasId;
                            var gasAmount04M = viewModel.sheet1.section4.getGasAmount('tr_04M', gasId);
                            var amount04M = numericUtil.toNum(gasAmount04M.amount, 0);
                            var amount04I = numericUtil.toNum(viewModel.sheet1.section4.getGasAmount('tr_04I', gasId).amount, 0);
                            var amount04D = numericUtil.toNum(viewModel.sheet1.section4.getGasAmount('tr_04D', gasId).amount, 0);

                            var amountSubs = Math.round((amount04I - amount04D) * 100) / 100 
                            if (amount04M < amountSubs) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount04M.index;
                                result.errors.push(error);
                            }
                        });

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI();
                    }
                };
            };
            Sheet1Validator.prototype._createRuleQc20101 = function () {
                return {
                    qccode: 20101,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var data = viewModel.sheet1.section1.getSectionData();
                        var gases = data.Gas;
                        var tr_01A_fs = null;
                        var tr_01E = null;
                        var that = this;
                        for (var i = 0; i < gases.length; i++) {
                            tr_01A_fs = viewModel.sheet1.section1.getTotalAmountForRow('tr_01A_fs', gases[i].GasCode);
                            tr_01E = viewModel.sheet1.section1.getGasAmount('tr_01E', gases[i].GasCode);
                            if (tr_01A_fs.amount > tr_01E.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = tr_01A_fs.index;
                                error.message = $translate.instant('validation_messages.qc_20101.error_text', {
                                    gas: viewModel.getReportedGasById(tr_01A_fs.id).Name,
                                });
                                result.errors.push(error);
                            }
                        }
                        return result;
                    }
                };
            };

            Sheet1Validator.prototype._createRuleQc24115 = function () {
                return {
                    qccode: 24115,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var data = viewModel.sheet1.section1.getSectionData();
                        var gases = data.Gas;
                        var tr_01Aa = null;
                        var tr_01A = null;
                        var that = this;
                        for (var i = 0; i < gases.length; i++) {
                            tr_01Aa = viewModel.sheet1.section1.getGasAmount('tr_01Aa', gases[i].GasCode);
                            tr_01A = viewModel.sheet1.section1.getGasAmount('tr_01A', gases[i].GasCode);
                            if (tr_01Aa.amount > tr_01A.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = tr_01Aa.index;
                                error.message = $translate.instant('validation_messages.qc_24115.error_text', {
                                    gas: viewModel.getReportedGasById(tr_01Aa.id).Name,
                                });
                                result.errors.push(error);
                            }
                        }
                        return result;
                    }
                };
            };

            Sheet1Validator.prototype._createRuleQc24112 = function () {
                return {
                    qccode: 24112,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var data = viewModel.sheet1.section1.getSectionData();
                        var gases = data.Gas;
                        var tr_01Aa = null;
                        var tr_01A_a = null;
                        var that = this;
                        for (var i = 0; i < gases.length; i++) {
                            tr_01Aa = viewModel.sheet1.section1.getGasAmount('tr_01Aa', gases[i].GasCode);
                            tr_01A_a = viewModel.sheet1.section1.getGasAmount('tr_01A_a', gases[i].GasCode);
                            if (tr_01A_a.amount > tr_01Aa.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = tr_01A_a.index;
                                error.message = $translate.instant('validation_messages.qc_24112.error_text', {
                                    gas: viewModel.getReportedGasById(tr_01A_a.id).Name,
                                });
                                result.errors.push(error);
                            }
                        }
                        return result;
                    }
                };
            };

            Sheet1Validator.prototype._createRuleQc24113 = function () {
                return {
                    qccode: 24113,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var data = viewModel.sheet1.section1.getSectionData();
                        var gases = data.Gas;
                        var tr_01Aa = null;
                        var tr_01A_a = null;
                        var that = this;
                        for (var i = 0; i < gases.length; i++) {
                            tr_01Aa = viewModel.sheet1.section1.getGasAmount('tr_01Aa', gases[i].GasCode);
                            tr_01A_a = viewModel.sheet1.section1.getGasAmount('tr_01A_a', gases[i].GasCode);
                            if (tr_01A_a.amount < tr_01Aa.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.isNonBlocker = true;
                                error.gasIndex = tr_01Aa.index;
                                error.message = $translate.instant('validation_messages.qc_24113.warning_text', {
                                    gas: viewModel.getReportedGasById(tr_01Aa.id).Name,
                                });
                                result.errors.push(error);
                            }
                        }
                        return result;
                    }
                };
            };

            Sheet1Validator.prototype._createRuleQc24114 = function () {
                return {
                    qccode: 24114,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var dataGases = viewModel.sheet1.section1.getSectionData().Gas;
                        var tr_01Afs = null;
                        var tr_01Afs1 = null;
                        var that = this;

                        arrayUtil.forEach(dataGases, function (dataGas) {
                            var countryArray = dataGas['tr_01A_fs'].CountrySpecific.Country;
                            if (!objectUtil.isNull(countryArray)) {
                                for (var i = 0; i < countryArray.length; i++) {
                                    tr_01Afs = viewModel.sheet1.section1.getGasAmountOfCountryGasSpecific('tr_01A_fs', countryArray[i].CountryId, dataGas.GasCode);
                                    tr_01Afs1 = viewModel.sheet1.section1.getGasAmountOfCountryGasSpecific('tr_01A_fs1', countryArray[i].CountryId, dataGas.GasCode);

                                    if (objectUtil.isNull(tr_01Afs.amount) || objectUtil.isNull(tr_01Afs1.amount))
                                        return;

                                    if (tr_01Afs1.amount > tr_01Afs.amount) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        var countryName;
                                        var countries = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.tr_01A_fs_Countries.Country;
                                        if (countryArray[i].CountryId == countries[i].CountryId) { countryName = countries[i].CountryName; }
                                        error.gasIndex = tr_01Afs.index;
                                        error.message = $translate.instant("validation_messages.qc_24114.error_text", {
                                            gas: viewModel.getReportedGasById(tr_01Afs.id).Name,
                                            country: countryName
                                        });
                                        result.errors.push(error);
                                    }
                                }
                            } else {
                                return;
                            }
                        });
                        return result;
                    }
                };
            };

            return new Sheet1Validator();
        }
    ]);
})();