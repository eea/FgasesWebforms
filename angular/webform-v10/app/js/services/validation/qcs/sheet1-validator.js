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
                    rules: [that._createRuleQc2072Plus2073(), that._createRuleQc2028('tr_01B'), that._createRuleQc2029(), that._createRuleQc2088()]
                },
                {
                    transaction: {
                        id: 'tr_01Aa',
                        label: '01Aa'
                    },
                    rules: [that._createRuleQc24115(), that._createRuleQc24113(), that._createRuleQc2450()]
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
                    rules: [that._createRuleQc2455(), that._createRuleQc2089()]
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
                        id: 'tr_02App',
                        label: '02App'
                    },
                    rules: [that._createRuleQc2415('02App'), that._createRuleQc2416('02App')]
                },
                {
                    transaction: {
                        id: 'tr_01A_fs2',
                        label: '01A_fs2'
                    },
                    rules: [that._createRuleQc24119()]
                },
                {
                    transaction: {
                        id: 'tr_02A',
                        label: '02A'
                    },
                    rules: [that._createRuleQc2411(), that._createRuleQc2412(), that._createRuleQC24109(), that._createRuleQC20041(), that._createRuleQC20051()]
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
                        id: 'tr_02I',
                        label: '02I'
                    },
                    rules: [that._createRuleQc2102(), that._createRuleQc2106()]
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
                        id: 'tr_03App',
                        label: '03App'
                    },
                    rules: [that._createRuleQc2415('03App'), that._createRuleQc2416('03App')]
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
                        id: 'tr_04Aa',
                        label: '04Aa'
                    },
                    rules: [that._createRuleQc2107()]
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
                        id: 'tr_04Fa',
                        label: '04Fa'
                    },
                    rules: [that._createRuleQc2108()]
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
                    rules: [that._createRuleQc24118('tr_02A', "tr_02A_Countries")]
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

            Sheet1Validator.prototype._createRuleQc24118 = function (transactionId, transactionCountries) {
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

                                            if (!(((objectUtil.isNull(amount)) || (amount == "")) && ((objectUtil.isNull(amount2)) || (amount2 == "")) && ((objectUtil.isNull(amount3)) || (amount3 == "")) && ((objectUtil.isNull(amount4)) || (amount4 == "")) && ((objectUtil.isNull(amount5)) || (amount5 == "")))) {

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

                                        } else if ((transactionId == "tr_03A") && (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i][transactionId].CountrySpecific.Country != null)) {

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

                        if (gasHelper.calculateSum(gasAmounts01) > 1 || gasHelper.calculateSumOfAllCO2Eq(viewModel.getReportedGases(), gasAmounts01) > 100) {

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

                            if (!objectUtil.isNull(commentedAmount01B)) {
                                error.isNonBlocker = true;
                                const my = this;
                                arrayUtil.forEach(gasAmounts01, function (gasAmount01) { // create a flag for each gas
                                    if (gasHelper.calculateSum([gasAmount01]) > 1 || gasHelper.calculateSumOfAllCO2Eq(viewModel.getReportedGases(), [gasAmount01]) > 100) {
                                        if (transactionId == 'tr_01B') {
                                            var flag = sheetValidationObjectFactory.createQcFlag('1B', my.qccode, gasAmount01.id);
                                        } else {
                                            var flag = sheetValidationObjectFactory.createQcFlag('1A_a_own', my.qccode, gasAmount01.id);
                                        }
                                        result.flags.push(flag);
                                    }
                                });

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

                        var gasAmounts08D = viewModel.sheet6.section8.getGasAmounts('tr_8D');
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

                                if (gasAmount01A_a_own.amount <= gasAmount08D.amount && gasAmount01B.amount <= gasAmount08D.amount) {
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
                                sectionValue2029 = sectionValue2029.toString();
                                sectionMessage2029 = sectionMessage2029.toString();
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

            Sheet1Validator.prototype._createRuleQc2088 = function () {
                return {
                    qccode: 2088,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        var gasAmounts01B = viewModel.sheet1.section1.getGasAmounts('tr_01B');
                        var gasAmounts08D = viewModel.sheet6.section8.getGasAmounts('tr_8Da');

                        var that = this;

                        arrayUtil.forEach(gasAmounts01B, function (gasAmount01B) {

                            if (objectUtil.isNull(gasAmount01B.amount)) {
                                return;
                            }

                            var gasAmount08D = arrayUtil.selectSingle(gasAmounts08D, function (item) {
                                return item.id === gasAmount01B.id;
                            });

                            if (!viewModel.sheetActivities.isD()) {
                                return;
                            }
                            /*if (!gasAmount08D || objectUtil.isNull(gasAmount08D.amount)) {
                                return;
                            }*/
                            var hasMixtureHFC23 = false;
                            if (viewModel.getReportedGasById(gasAmount01B.id).BlendComponents.Component.length > 0) {
                                for (var i = 0; i < viewModel.getReportedGasById(gasAmount01B.id).BlendComponents.Component.length; i++) {
                                    var component = viewModel.getReportedGasById(gasAmount01B.id).BlendComponents.Component[i];
                                    if (component.Code === 'HFC-23') {
                                        hasMixtureHFC23 = true;
                                    }
                                }
                            }
                            if (viewModel.getReportedGasById(gasAmount01B.id).Code === 'HFC-23' || hasMixtureHFC23) {
                                if (gasAmount01B.amount > gasAmount08D.amount) {
                                    var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                    error.gasIndex = gasAmount01B.index;
                                    error.message = $translate.instant('validation_messages.qc_2088.error_text', {
                                        gas: viewModel.getReportedGasById(gasAmount01B.id).Name
                                    });
                                    result.errors.push(error);
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
                        var gasAmounts08D = viewModel.sheet6.section8.getGasAmounts('tr_8D');
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
                        var gasAmounts08D = viewModel.sheet6.section8.getGasAmounts('tr_8D');
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

                        if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        if (viewModel._instance.FGasesReporting[formId].tr_02A_Countries == null) {
                            return result;
                        }

                        if (viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country) {
                            for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country.length; p++) {

                                for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                    var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                    if (viewModel.containsHFC(gas)) {
                                        let country = viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country[p];
                                        let gasAmount02D = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02D.CountrySpecific.Country[p];
                                        if (!objectUtil.isNull(gasAmount02D) && numericUtil.toNum(gasAmount02D.Amount, 0) !== 0 && stringUtil.isEmpty(gasAmount02D.Comment)) {
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
                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE();
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

                        if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        if (viewModel._instance.FGasesReporting[formId].tr_03A_Countries == null) {
                            return result;
                        }

                        for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country.length; p++) {

                            for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode)
                                if (viewModel.containsHFC(gas)) {
                                    let country = viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country[p];
                                    let gasAmount03H = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03H.CountrySpecific.Country[p];
                                    if (!objectUtil.isNull(gasAmount03H) && numericUtil.toNum(gasAmount03H.Amount, 0) !== 0 && stringUtil.isEmpty(gasAmount03H.Comment)) {
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

                        if (!this._isValidationRequired(viewModel)) {
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
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE();
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

                        if (!this._isValidationRequired(viewModel)) {
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
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE();
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

                        if (!this._isValidationRequired(viewModel)) {
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
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE();
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
                            var countryArray = dataGas['tr_01A_fs'].CountrySpecific?.Country;
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

            Sheet1Validator.prototype._createRuleQc2089 = function () {
                return {
                    qccode: 2089,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (viewModel.sheetActivities.isFU()) {
                            return result;
                        }

                        var gasAmounts01A_fs = viewModel.sheet1.section1.getGasTotalAmountForRow('tr_01A_fs');

                        if (objectUtil.isNull(gasAmounts01A_fs)) {
                            return result;
                        }


                        if (gasHelper.calculateSum(gasAmounts01A_fs) > 1 || gasHelper.calculateSumOfAllCO2Eq(viewModel.getReportedGases(), gasAmounts01A_fs) > 1000) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            result.errors.push(error);
                        }

                        return result;
                    }
                };
            };


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

                        if (viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country) {
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
                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE();
                    }
                };
            };

            /*
            * QC_20041 and QC_20051
            */

            Sheet1Validator.prototype._createRuleQC20041 = function () {
                return {
                    qccode: 20041,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        var gasAmounts02A = viewModel.sheet1.section2.getGasTotalAmountForRow('tr_02A');
                        var that = this;

                        var totalAmount2A = 0
                        arrayUtil.forEach(gasAmounts02A, function (gasAmount02A) {
                            if (gasAmount02A.amount > 0) {
                                totalAmount2A = totalAmount2A + gasAmount02A.amount;
                            }
                        });

                        if (totalAmount2A == 0) {
                            var flag = sheetValidationObjectFactory.createQcFlag('2A', that.qccode);
                            result.flags.push(flag);
                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isI_HFC();
                    }
                };
            };

            Sheet1Validator.prototype._createRuleQC20051 = function () {
                return {
                    qccode: 20051,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        var gasAmounts02A = viewModel.sheet1.section2.getGasTotalAmountForRow('tr_02A');
                        var that = this;

                        var totalAmount2A = 0
                        arrayUtil.forEach(gasAmounts02A, function (gasAmount02A) {
                            if (gasAmount02A.amount > 0) {
                                totalAmount2A = totalAmount2A + gasAmount02A.amount;
                            }
                        });

                        if (totalAmount2A == 0) {
                            var flag = sheetValidationObjectFactory.createQcFlag('2A', that.qccode);
                            result.flags.push(flag);
                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isI_Other();
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

                        if (viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country) {
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
                        }


                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE();
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

                        if (viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country) {
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
                        }






                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE();
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


                        if (viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country) {
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
                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE();
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

                        if (viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country) {
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
                        }

                        return result;
                    },
                    _isValidationRequired: function (viewModel) {
                        return viewModel.sheetActivities.isP() || viewModel.sheetActivities.isI() || viewModel.sheetActivities.isE();
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

            Sheet1Validator.prototype._createRuleQc2102 = function () {
                return {
                    qccode: 2102,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        var gasAmounts02I = viewModel.sheet1.section1.getGasAmounts('tr_02I');
                        var gasAmounts06U = viewModel.sheet3.section6.getGasAmounts('tr_06U');

                        var hasError = false;

                        gasAmounts02I.forEach(function (gas02I) {
                            var matchingGas06U = gasAmounts06U.find(function (gas06U) {
                                return gas06U.id === gas02I.id;
                            });


                            if (matchingGas06U) {
                                if (gas02I.amount > matchingGas06U.amount) {
                                    hasError = true;

                                    var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                    error.message = $translate.instant("validation_messages.qc_2102.error_text", {
                                        gasName: viewModel.getReportedGasById(gas02I.id).Name
                                    });
                                    result.errors.push(error);
                                }
                            }
                        }, this);

                        return result;

                    }
                };
            };

            Sheet1Validator.prototype._createRuleQc2106 = function () {
                return {
                    qccode: 2106,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        var gasAmounts02I = viewModel.sheet1.section1.getGasAmounts('tr_02I');
                        var gasAmounts02A = viewModel.sheet1.section1.getGasTotalAmountForRow('tr_02A');
                        var gasAmounts02G = viewModel.sheet1.section1.getGasAmounts('tr_02G');
                        var gasAmounts04C = viewModel.sheet1.section1.getGasAmounts('tr_04C');

                        gasAmounts02I.forEach(function (gas02I) {
                            var matchingGas02A = gasAmounts02A.find(function (gas02A) {
                                return gas02A.id === gas02I.id;
                            });

                            var matchingGas02G = gasAmounts02G.find(function (gas02G) {
                                return gas02G.id === gas02I.id;
                            });

                            var matchingGas04C = gasAmounts04C.find(function (gas04C) {
                                return gas04C.id === gas02I.id;
                            });

                            if (gas02I && gas02I.amount) {
                                if (gas02I.amount > (matchingGas02A.amount + matchingGas02G.amount + matchingGas04C.amount)) {

                                    var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                    error.message = $translate.instant("validation_messages.qc_2106.error_text", {
                                        gasName: viewModel.getReportedGasById(gas02I.id).Name
                                    }); result.errors.push(error);
                                }
                            }
                        }, this);

                        return result;

                    }
                };
            };
            Sheet1Validator.prototype._createRuleQc2107 = function () {
                return {
                    qccode: 2107,
                    validate: function (viewModel) {
                        var that = this;
                        var result = sheetValidationObjectFactory.createValidationResult();

                        var gasAmounts04A = viewModel.sheet1.section4.getGasAmounts('tr_04A');
                        var gasAmounts04Aa = viewModel.sheet1.section4.getGasAmounts('tr_04Aa');

                        arrayUtil.forEach(gasAmounts04Aa, function (gasAmount04Aa) {

                            if (objectUtil.isNull(gasAmount04Aa.amount)) {
                                return;
                            }

                            var match04A = arrayUtil.selectSingle(gasAmounts04A, function (item) {
                                return item.id === gasAmount04Aa.id;
                            });

                            var amount04A = objectUtil.defaultIfNull(match04A?.amount, 0);

                            if (gasAmount04Aa.amount > amount04A) {

                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.message = $translate.instant("validation_messages.qc_2107.error_text", {
                                    gasName: viewModel.getReportedGasById(gasAmount04Aa.id).Name
                                });
                                result.errors.push(error);

                            }
                        });

                        return result;
                    }
                };
            };

            Sheet1Validator.prototype._createRuleQc2108 = function () {
                return {
                    qccode: 2108,
                    validate: function (viewModel) {
                        var that = this;
                        var result = sheetValidationObjectFactory.createValidationResult();

                        var gasAmounts04F = viewModel.sheet1.section4.getGasAmounts('tr_04F');
                        var gasAmounts04Fa = viewModel.sheet1.section4.getGasAmounts('tr_04Fa');

                        arrayUtil.forEach(gasAmounts04Fa, function (gasAmount04Fa) {

                            if (objectUtil.isNull(gasAmount04Fa.amount)) {
                                return;
                            }

                            var match04F = arrayUtil.selectSingle(gasAmounts04F, function (item) {
                                return item.id === gasAmount04Fa.id;
                            });

                            var amount04F = objectUtil.defaultIfNull(match04F?.amount, 0);

                            if (gasAmount04Fa.amount > amount04F) {

                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.message = $translate.instant("validation_messages.qc_2108.error_text", {
                                    gasName: viewModel.getReportedGasById(gasAmount04Fa.id).Name
                                });
                                result.errors.push(error);

                            }
                        });

                        return result;
                    }
                };
            };


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
                        var gasAmounts02G = viewModel.sheet1.section2.getGasAmounts('tr_02G');
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
                            var amount02G = that._getGasAmount(gasAmounts02G, gasAmount04G.id);
                            var amount04B = that._getGasAmount(gasAmounts04B, gasAmount04G.id);

                            if (gasAmount04G.amount > amount01E + amount02A + amount02G + amount04B) {
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
                        var gasAmounts02G = viewModel.sheet1.section2.getGasAmounts('tr_02G');
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
                            var amount02G = that._getGasAmount(gasAmounts02G, gasAmount04H.id);
                            var amount04C = that._getGasAmount(gasAmounts04C, gasAmount04H.id);

                            if (gasAmount04H.amount > amount01E + amount02A + amount02G + amount04C) {
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
                            var gasName = section4Gas.Name;
                            var gasAmount04M = viewModel.sheet1.section4.getGasAmount('tr_04M', gasId);
                            var amount04M = numericUtil.toNum(gasAmount04M.amount, 0);

                            if (amount04M < 0) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = amount04M.index;
                                error.message = $translate.instant('validation_messages.qc_2026.error_text', {
                                    gas: gasName,
                                });
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
                        var tr_01C_a = null;
                        var tr_01E = null;
                        var that = this;
                        for (var i = 0; i < gases.length; i++) {
                            tr_01C_a = viewModel.sheet1.section1.getTotalAmountForRow('tr_01A_fs', gases[i].GasCode);
                            tr_01E = viewModel.sheet1.section1.getGasAmount('tr_01E', gases[i].GasCode);
                            if (tr_01C_a.amount > Math.max(tr_01E.amount,0)) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = tr_01C_a.index;
                                error.message = $translate.instant('validation_messages.qc_20101.error_text', {
                                    gas: viewModel.getReportedGasById(tr_01C_a.id).Name,
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
                            var countryArray = dataGas['tr_01A_fs'].CountrySpecific?.Country;
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

           Sheet1Validator.prototype._createRuleQc2415 = function (transaction) {
                return {
                    qccode: 2415,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }

                        for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {

                            if ((viewModel._instance.FGasesReporting.ReportedGases[i].BlendComponents.Component.length == undefined) || (viewModel._instance.FGasesReporting.ReportedGases[i].BlendComponents.Component.length==1)) { // is not blend
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode).GasId;
                                if (isPreblendedPolyols(gas )) {
                                    if (transaction == "02App") {
                                        if (viewModel._instance.FGasesReporting[formId].tr_02A_Countries) {                                            
                                            if ((viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country) && (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02App.CountrySpecific)) {
                                                for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country.length; p++) {
                                                    //check data in 2A ,2App and comment
                                                    if (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02App.CountrySpecific.Country) {
                                                        amount2A = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02A.CountrySpecific.Country[p].Amount;
                                                        amount2App = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02App.CountrySpecific.Country[p].Amount;
                                                        comment = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02App.CountrySpecific.Country[p].Comment;
                                                        if ((amount2A != null && amount2A != '') && (amount2App == null || amount2App == "") && ((comment != null) && (comment != ""))) {
                                                            var flag = sheetValidationObjectFactory.createQcFlag('02App', that.qccode, viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode, null, comment);
                                                            result.flags.push(flag);
                                                        }
                                                        if ((amount2A != null && amount2A != '') && (amount2App == null || amount2App == "") && ((comment == "") || (comment == null))) {
                                                            let country = viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country[p];
                                                            var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                                            error.gasIndex = i;
                                                            error.message = $translate.instant("validation_messages.qc_2415.error_text", {
                                                                activity: "imports",
                                                                country: country.CountryName,
                                                                section: "2F (formerly 2A_pp)"
                                                            });
                                                            result.errors.push(error);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } else if (transaction == "03App") {
                                        if (viewModel._instance.FGasesReporting[formId].tr_03A_Countries) {
                                           // if (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03A.CountrySpecific.Country) {
                                            if ((viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country) && (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03App.CountrySpecific)) {
                                                for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country.length; p++) {
                                                    //check data in 3A ,3App and comment
                                                    if (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03App.CountrySpecific.Country) {
                                                        amount3A = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03A.CountrySpecific.Country[p].Amount;
                                                        amount3App = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03App.CountrySpecific.Country[p].Amount;
                                                        comment = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03App.CountrySpecific.Country[p].Comment;
                                                        if ((amount3A != null && amount3A != '') && (amount3App == null || amount3App == "") && ((comment != null) && (comment != ""))) {
                                                            var flag = sheetValidationObjectFactory.createQcFlag('03App', that.qccode, viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode, null, comment);
                                                            result.flags.push(flag);
                                                        }
                                                        if ((amount3A != null && amount3A != '') && (amount3App == null || amount3App == "") && ((comment == "") || (comment == null))) {
                                                            var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                                            error.gasIndex = i;
                                                            error.message = $translate.instant("validation_messages.qc_2415.error_text", {
                                                                activity: "exports",
                                                                section: "3J (formerly 3A_pp)"
                                                            });
                                                            result.errors.push(error);
                                                        }
                                                    }
                                                }
                                            }
                                        }
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
           };

            Sheet1Validator.prototype._createRuleQc2416 = function (transaction) {
                
                return {
                    qccode: 2416,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;
                        var formId = 'F1_S1_4_ProdImpExp';

                        if (!this._isValidationRequired(viewModel)) {
                            return result;
                        }

                        viewModel.get_gas_by_id = function (gas_id) {
                            for (var i = 0; i < viewModel._instance.FGasesReporting.ReportedGases.length; i++) {
                                if (gas_id === viewModel._instance.FGasesReporting.ReportedGases[i].GasId) {
                                    return viewModel._instance.FGasesReporting.ReportedGases[i];
                                }
                            }
                        }

                        for (var i = 0; i < viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas.length; i++) {
                            if ((viewModel._instance.FGasesReporting.ReportedGases[i].BlendComponents.Component.length == undefined) || (viewModel._instance.FGasesReporting.ReportedGases[i].BlendComponents.Component.length == 1)) { // is not blend
                                var gas = viewModel.get_gas_by_id(viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode).GasId;
                                if (!isPreblendedPolyols(gas)) {
                                    if (transaction == "02App") {
                                        if (viewModel._instance.FGasesReporting[formId].tr_02A_Countries) {
                                            if ((viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country) && (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02App.CountrySpecific)) {
                                                for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country.length; p++) {
                                                    if (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02App.CountrySpecific.Country) {
                                                        //check data in 2App and comment
                                                        amount2App = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02App.CountrySpecific.Country[p].Amount;
                                                        comment = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_02App.CountrySpecific.Country[p].Comment;
                                                        if ((amount2App != null && amount2App != "") && ((comment != null) && (comment != ""))) {
                                                            var flag = sheetValidationObjectFactory.createQcFlag('02App', that.qccode, viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode, null, comment);
                                                            result.flags.push(flag);
                                                        }
                                                        if ((amount2App != null && amount2App != "") && ((comment == "") || (comment == null))) {
                                                            let country = viewModel._instance.FGasesReporting[formId].tr_02A_Countries.Country[p];
                                                            var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                                            error.gasIndex = i;
                                                            error.message = $translate.instant("validation_messages.qc_2416.error_text", {
                                                                gas: viewModel.getReportedGasById(gas).Name,
                                                                country: country.CountryName,
                                                                section: transaction,
                                                                activity: "imports"
                                                            });
                                                            result.errors.push(error);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } else if (transaction == "03App") {
                                        if (viewModel._instance.FGasesReporting[formId].tr_03A_Countries) {
                                            if ((viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country) && (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03App.CountrySpecific)) {
                                                for (let p = 0; p < viewModel._instance.FGasesReporting[formId].tr_03A_Countries.Country.length; p++) {
                                                    if (viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03App.CountrySpecific.Country) {
                                                        //check data in 3App and comment
                                                        amount3App = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03App.CountrySpecific.Country[p].Amount;
                                                        comment = viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].tr_03App.CountrySpecific.Country[p].Comment;
                                                        if ((amount3App != null && amount3App != "") && ((comment != null) && (comment != ""))) {
                                                            var flag = sheetValidationObjectFactory.createQcFlag('03App', that.qccode, viewModel._instance.FGasesReporting.F1_S1_4_ProdImpExp.Gas[i].GasCode, null, comment);
                                                            result.flags.push(flag);
                                                        }
                                                        if ((amount3App != null && amount3App != "") && ((comment == "") || (comment == null))) {
                                                            var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                                            error.gasIndex = i;
                                                            error.message = $translate.instant("validation_messages.qc_2416.error_text", {
                                                                gas: viewModel.getReportedGasById(gas).Name,
                                                                section: transaction,
                                                                activity: "exports"
                                                            });
                                                            result.errors.push(error);
                                                        }
                                                    }
                                                }
                                            }
                                        }
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
                };

                       
            Sheet1Validator.prototype._createRuleQc24119 = function () {
                return {
                    qccode: 24119,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var dataGases = viewModel.sheet1.section1.getSectionData().Gas;
                        var tr_01Afs2 = null;
                        var gasAmounts01D = viewModel.sheet1.section1.getGasAmounts('tr_01D');
                        var gasAmounts01Ab = viewModel.sheet1.section1.getGasAmounts('tr_01Ab');
                        var gasAmounts04C = viewModel.sheet1.section1.getGasAmounts('tr_04C');
                        var gasAmounts08E = viewModel.sheet6.section8.getGasAmounts('tr_8E');
                        var that = this;

                        arrayUtil.forEach(dataGases, function (dataGas) {
                            var gasAmount01D = arrayUtil.selectSingle(gasAmounts01D, function (gas) {
                                return gas.id === dataGas.GasCode;
                            });
                            var gasAmount01Ab = arrayUtil.selectSingle(gasAmounts01Ab, function (gas) {
                                return gas.id === dataGas.GasCode;
                            });
                            var gasAmount04C = arrayUtil.selectSingle(gasAmounts04C, function (gas) {
                                return gas.id === dataGas.GasCode;
                            });
                            var gasAmount08E = arrayUtil.selectSingle(gasAmounts08E, function (gas) {
                                return gas.id === dataGas.GasCode;
                            });
                            var amount01D = objectUtil.defaultIfNull(gasAmount01D.amount, 0);
                            var amount01Ab = objectUtil.defaultIfNull(gasAmount01Ab.amount, 0);
                            var amount04C = objectUtil.defaultIfNull(gasAmount04C.amount, 0);
                            var amount08E = objectUtil.defaultIfNull(gasAmount08E.amount, 0);
                            var countryArray = dataGas['tr_01A_fs2'].CountrySpecific?.Country;
                            if (!objectUtil.isNull(countryArray) && viewModel.getReportedGasById(dataGas.GasCode).Code === 'HFC-23') {
                                for (var i = 0; i < countryArray.length; i++) {
                                    tr_01Afs2 = viewModel.sheet1.section1.getGasAmountOfCountryGasSpecific('tr_01A_fs2', countryArray[i].CountryId, dataGas.GasCode);

                                    if (objectUtil.isNull(tr_01Afs2.amount))
                                        return;

                                    if ((tr_01Afs2.amount + amount01D) > (amount01Ab + amount04C) || (tr_01Afs2.amount + amount01D) > (amount01Ab + amount08E)) {
                                        var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                        error.gasIndex = tr_01Afs2.index;
                                        error.message = $translate.instant("validation_messages.qc_24119.error_text", {
                                            gas: viewModel.getReportedGasById(tr_01Afs2.id).Name
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

            Sheet1Validator.prototype._createRuleQc2450 = function () {
                return {
                    qccode: 2450,
                    validate: function (viewModel) {
                        var whiteListCompanies = [9503, 91189, 42630, 9465, 9546, 9410, 9428, 39611, 51264, 28372, 9763, 9478, 14806, 62576, 9505, 47790, 74243, 9411, 82718, 9475, 35479, 9697, 29215, 16423, 33587, 9506, 9461, 54215, 9449, 13089, 13408, 9558];
                        var companyId = viewModel._instance.FGasesReporting.GeneralReportData.Company.CompanyId;
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var data = viewModel.sheet1.section1.getSectionData();
                        var gases = data.Gas;
                        var tr_01A = null;
                        var that = this;
                        for (var i = 0; i < gases.length; i++) {
                            tr_01A = viewModel.sheet1.section1.getGasAmount('tr_01A', gases[i].GasCode);
                            if (tr_01A.amount && tr_01A.amount != 0) {
                                if (whiteListCompanies.indexOf(companyId) == -1 ) {
                                    var flag = sheetValidationObjectFactory.createQcFlag('01A', that.qccode, gases[i].GasCode);
                                    result.flags.push(flag);
                                }
                            }
                        }
                        return result;
                    }
                };
            };

            return new Sheet1Validator();
        }
    ]);
})();