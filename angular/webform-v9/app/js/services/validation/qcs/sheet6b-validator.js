(function () {
    angular.module('FGases.services.validation.qcs').factory('sheet6bValidator', [
        '$translate', 'sheetTransactionValidator', 'sheetValidationObjectFactory', 'objectUtil', 'arrayUtil', 'stringUtil', 'numericUtil',
        function ($translate, sheetTransactionValidator, sheetValidationObjectFactory, objectUtil, arrayUtil, stringUtil, numericUtil) {

            function Sheet6bValidator() {
                var that = this;
                this.transactionValidations = [
                    {
                        transaction: { id: 'tr_8A1other', label: '8_A1_other' },
                        rules: [that._createRuleQc2456_8A1other()]
                    }, {
                        transaction: { id: 'tr_8A2other', label: '8_A2_other' },
                        rules: [that._createRuleQc2456_8A2other()]
                    }, {
                        transaction: { id: 'tr_8Ba1other', label: '8_Ba1_other' },
                        rules: [that._createRuleQc2456_8Ba1other()]
                    }, {
                        transaction: { id: 'tr_8Ba2other', label: '8_Ba2_other' },
                        rules: [that._createRuleQc2456_8Ba2other()]
                    }, {
                        transaction: { id: 'tr_8Bb1other', label: '8_Bb1_other' },
                        rules: [that._createRuleQc2456_8Bb1other()]
                    }, {
                        transaction: { id: 'tr_8Bb2other', label: '8_Bb2_other' },
                        rules: [that._createRuleQc2456_8Bb2other()]
                    }, {
                        transaction: { id: 'tr_8C1other', label: '8_C1_other' },
                        rules: [that._createRuleQc2456_8C1other()]
                    }, {
                        transaction: { id: 'tr_8C2other', label: '8_C2_other' },
                        rules: [that._createRuleQc2456_8C2other()]
                    }, {
                        transaction: { id: '', label: '' },
                        rules: [that._createRuleQc2457()]
                    }
                ];
            }
            Sheet6bValidator.prototype.validate = function(viewModel) {
                var transactionErrors = sheetTransactionValidator.validate(viewModel, this.transactionValidations);
                return transactionErrors;
            };

            /* 8A1other */
            Sheet6bValidator.prototype._createRuleQc2456_8A1other = function () {
                return {
                    qccode: 2456,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;

                        var gasAmounts08A1other = viewModel.sheet6.section8.getGasAmounts('tr_8A1other');

                        arrayUtil.forEach(gasAmounts08A1other, function (gasAmount08A1other) {
                            if (objectUtil.isNull(gasAmount08A1other.amount) || gasAmount08A1other.amount === 0 || !stringUtil.isEmpty(gasAmount08A1other.comment)) {
                                if (!stringUtil.isEmpty(gasAmount08A1other.comment)) {
                                    // 8A1_other value with comment => create flag
                                    var flag = sheetValidationObjectFactory.createQcFlag('8A1_other', that.qccode, gasAmount08A1other.id);
                                    result.flags.push(flag);
                                }
                            } else {    // 8A1_other value without comment
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1other.index;
                                error.message = $translate.instant("validation_messages.qc_2456.error_text");
                                result.errors.push(error);
                            }

                        });

                        return result;
                    }
                };
            };

            /* 8A2other */
            Sheet6bValidator.prototype._createRuleQc2456_8A2other = function () {
                return {
                    qccode: 2456,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;

                        var gasAmounts08A2other = viewModel.sheet6.section8.getGasAmounts('tr_8A2other');

                        arrayUtil.forEach(gasAmounts08A2other, function (gasAmount08A2other) {
                            if (objectUtil.isNull(gasAmount08A2other.amount) || gasAmount08A2other.amount === 0 || !stringUtil.isEmpty(gasAmount08A2other.comment)) {
                                if (!stringUtil.isEmpty(gasAmount08A2other.comment)) {
                                    // 8A2_other value with comment => create flag
                                    var flag = sheetValidationObjectFactory.createQcFlag('8A2_other', that.qccode, gasAmount08A2other.id);
                                    result.flags.push(flag);
                                }
                            } else {    // 8A2_other value without comment
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A2other.index;
                                error.message = $translate.instant("validation_messages.qc_2456.error_text");
                                result.errors.push(error);
                            }

                        });

                        return result;
                    }
                };
            };

            /* 8Ba1other */
            Sheet6bValidator.prototype._createRuleQc2456_8Ba1other = function () {
                return {
                    qccode: 2456,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;

                        var gasAmounts08Ba1other = viewModel.sheet6.section8.getGasAmounts('tr_8Ba1other');

                        arrayUtil.forEach(gasAmounts08Ba1other, function (gasAmount08Ba1other) {
                            if (objectUtil.isNull(gasAmount08Ba1other.amount) || gasAmount08Ba1other.amount === 0 || !stringUtil.isEmpty(gasAmount08Ba1other.comment)) {
                                if (!stringUtil.isEmpty(gasAmount08Ba1other.comment)) {
                                    // 8Ba1_other value with comment => create flag
                                    var flag = sheetValidationObjectFactory.createQcFlag('8Ba1_other', that.qccode, gasAmount08Ba1other.id);
                                    result.flags.push(flag);
                                }
                            } else {    // 8Ba1_other value without comment
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08Ba1other.index;
                                error.message = $translate.instant("validation_messages.qc_2456.error_text");
                                result.errors.push(error);
                            }

                        });

                        return result;
                    }
                };
            };

            /* 8Ba2other */
            Sheet6bValidator.prototype._createRuleQc2456_8Ba2other = function () {
                return {
                    qccode: 2456,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;

                        var gasAmounts08Ba2other = viewModel.sheet6.section8.getGasAmounts('tr_8Ba2other');

                        arrayUtil.forEach(gasAmounts08Ba2other, function (gasAmount08Ba2other) {
                            if (objectUtil.isNull(gasAmount08Ba2other.amount) || gasAmount08Ba2other.amount === 0 || !stringUtil.isEmpty(gasAmount08Ba2other.comment)) {
                                if (!stringUtil.isEmpty(gasAmount08Ba2other.comment)) {
                                    // 8Ba2_other value with comment => create flag
                                    var flag = sheetValidationObjectFactory.createQcFlag('8Ba2_other', that.qccode, gasAmount08Ba2other.id);
                                    result.flags.push(flag);
                                }
                            } else {    // 8Ba2_other value without comment
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08Ba2other.index;
                                error.message = $translate.instant("validation_messages.qc_2456.error_text");
                                result.errors.push(error);
                            }

                        });

                        return result;
                    }
                };
            };

            /* 8Bb1other */
            Sheet6bValidator.prototype._createRuleQc2456_8Bb1other = function () {
                return {
                    qccode: 2456,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;

                        var gasAmounts08Bb1other = viewModel.sheet6.section8.getGasAmounts('tr_8Bb1other');

                        arrayUtil.forEach(gasAmounts08Bb1other, function (gasAmount08Bb1other) {
                            if (objectUtil.isNull(gasAmount08Bb1other.amount) || gasAmount08Bb1other.amount === 0 || !stringUtil.isEmpty(gasAmount08Bb1other.comment)) {
                                if (!stringUtil.isEmpty(gasAmount08Bb1other.comment)) {
                                    // 8Bb1_other value with comment => create flag
                                    var flag = sheetValidationObjectFactory.createQcFlag('8Bb1_other', that.qccode, gasAmount08Bb1other.id);
                                    result.flags.push(flag);
                                }
                            } else {    // 8Bb1_other value without comment
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08Bb1other.index;
                                error.message = $translate.instant("validation_messages.qc_2456.error_text");
                                result.errors.push(error);
                            }

                        });

                        return result;
                    }
                };
            };

            /* 8Bb2other */
            Sheet6bValidator.prototype._createRuleQc2456_8Bb2other = function () {
                return {
                    qccode: 2456,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;

                        var gasAmounts08Bb2other = viewModel.sheet6.section8.getGasAmounts('tr_8Bb2other');

                        arrayUtil.forEach(gasAmounts08Bb2other, function (gasAmount08Bb2other) {
                            if (objectUtil.isNull(gasAmount08Bb2other.amount) || gasAmount08Bb2other.amount === 0 || !stringUtil.isEmpty(gasAmount08Bb2other.comment)) {
                                if (!stringUtil.isEmpty(gasAmount08Bb2other.comment)) {
                                    // 8Bb2_other value with comment => create flag
                                    var flag = sheetValidationObjectFactory.createQcFlag('8Bb2_other', that.qccode, gasAmount08Bb2other.id);
                                    result.flags.push(flag);
                                }
                            } else {    // 8Bb2_other value without comment
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08Bb2other.index;
                                error.message = $translate.instant("validation_messages.qc_2456.error_text");
                                result.errors.push(error);
                            }

                        });

                        return result;
                    }
                };
            };

            /* 8C1other */
            Sheet6bValidator.prototype._createRuleQc2456_8C1other = function () {
                return {
                    qccode: 2456,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;

                        var gasAmounts08C1other = viewModel.sheet6.section8.getGasAmounts('tr_8C1other');

                        arrayUtil.forEach(gasAmounts08C1other, function (gasAmount08C1other) {
                            if (objectUtil.isNull(gasAmount08C1other.amount) || gasAmount08C1other.amount === 0 || !stringUtil.isEmpty(gasAmount08C1other.comment)) {
                                if (!stringUtil.isEmpty(gasAmount08C1other.comment)) {
                                    // 8C1_other value with comment => create flag
                                    var flag = sheetValidationObjectFactory.createQcFlag('8C1_other', that.qccode, gasAmount08C1other.id);
                                    result.flags.push(flag);
                                }
                            } else {    // 8C1_other value without comment
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08C1other.index;
                                error.message = $translate.instant("validation_messages.qc_2456.error_text");
                                result.errors.push(error);
                            }

                        });

                        return result;
                    }
                };
            };

            /* 8C2other */
            Sheet6bValidator.prototype._createRuleQc2456_8C2other = function () {
                return {
                    qccode: 2456,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;

                        var gasAmounts08C2other = viewModel.sheet6.section8.getGasAmounts('tr_8C2other');

                        arrayUtil.forEach(gasAmounts08C2other, function (gasAmount08C2other) {
                            if (objectUtil.isNull(gasAmount08C2other.amount) || gasAmount08C2other.amount === 0 || !stringUtil.isEmpty(gasAmount08C2other.comment)) {
                                if (!stringUtil.isEmpty(gasAmount08C2other.comment)) {
                                    // 8C2_other value with comment => create flag
                                    var flag = sheetValidationObjectFactory.createQcFlag('8C2_other', that.qccode, gasAmount08C2other.id);
                                    result.flags.push(flag);
                                }
                            } else {    // 8C2_other value without comment
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08C2other.index;
                                error.message = $translate.instant("validation_messages.qc_2456.error_text");
                                result.errors.push(error);
                            }

                        });

                        return result;
                    }
                };
            };

            Sheet6bValidator.prototype._createRuleQc2457 = function () {
                return {
                    qccode: 2457,
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        var that = this;

                        var gasAmounts08A1i = viewModel.sheet6.section8.getGasAmounts('tr_8A1i');
                        var gasAmounts08A1ia = viewModel.sheet6.section8.getGasAmounts('tr_8A1ia');

                        var gasAmounts08A1ii = viewModel.sheet6.section8.getGasAmounts('tr_8A1ii');
                        var gasAmounts08A1iia = viewModel.sheet6.section8.getGasAmounts('tr_8A1iia');

                        var gasAmounts08A1iii = viewModel.sheet6.section8.getGasAmounts('tr_8A1iii');
                        var gasAmounts08A1iiia = viewModel.sheet6.section8.getGasAmounts('tr_8A1iiia');

                        var gasAmounts08A1iv = viewModel.sheet6.section8.getGasAmounts('tr_8A1iv');
                        var gasAmounts08A1iva = viewModel.sheet6.section8.getGasAmounts('tr_8A1iva');

                        var gasAmounts08A1other = viewModel.sheet6.section8.getGasAmounts('tr_8A1other');
                        var gasAmounts08A1othera = viewModel.sheet6.section8.getGasAmounts('tr_8A1othera');

                        var gasAmounts08A2other = viewModel.sheet6.section8.getGasAmounts('tr_8A2other');
                        var gasAmounts08A2othera = viewModel.sheet6.section8.getGasAmounts('tr_8A2othera');

                        var gasAmounts08Ba1i = viewModel.sheet6.section8.getGasAmounts('tr_8Ba1i');
                        var gasAmounts08Ba1ia = viewModel.sheet6.section8.getGasAmounts('tr_8Ba1ia');

                        var gasAmounts08Ba1ii = viewModel.sheet6.section8.getGasAmounts('tr_8Ba1ii');
                        var gasAmounts08Ba1iia = viewModel.sheet6.section8.getGasAmounts('tr_8Ba1iia');

                        var gasAmounts08Ba1other = viewModel.sheet6.section8.getGasAmounts('tr_8Ba1other');
                        var gasAmounts08Ba1othera = viewModel.sheet6.section8.getGasAmounts('tr_8Ba1othera');

                        var gasAmounts08Ba2other = viewModel.sheet6.section8.getGasAmounts('tr_8Ba2other');
                        var gasAmounts08Ba2othera = viewModel.sheet6.section8.getGasAmounts('tr_8Ba2othera');

                        var gasAmounts08Bb1i = viewModel.sheet6.section8.getGasAmounts('tr_8Bb1i');
                        var gasAmounts08Bb1ia = viewModel.sheet6.section8.getGasAmounts('tr_8Bb1ia');

                        var gasAmounts08Bb1ii = viewModel.sheet6.section8.getGasAmounts('tr_8Bb1ii');
                        var gasAmounts08Bb1iia = viewModel.sheet6.section8.getGasAmounts('tr_8Bb1iia');

                        var gasAmounts08Bb1other = viewModel.sheet6.section8.getGasAmounts('tr_8Bb1other');
                        var gasAmounts08Bb1othera = viewModel.sheet6.section8.getGasAmounts('tr_8Bb1othera');

                        var gasAmounts08Bb2other = viewModel.sheet6.section8.getGasAmounts('tr_8Bb2other');
                        var gasAmounts08Bb2othera = viewModel.sheet6.section8.getGasAmounts('tr_8Bb2othera');

                        var gasAmounts08C1other = viewModel.sheet6.section8.getGasAmounts('tr_8C1other');
                        var gasAmounts08C1othera = viewModel.sheet6.section8.getGasAmounts('tr_8C1othera');

                        var gasAmounts08C2other = viewModel.sheet6.section8.getGasAmounts('tr_8C2other');
                        var gasAmounts08C2othera = viewModel.sheet6.section8.getGasAmounts('tr_8C2othera');

                        arrayUtil.forEach(gasAmounts08A1i, function (gasAmount08A1i) {
                            var gasAmount08A1i = arrayUtil.selectSingle(gasAmounts08A1i, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            /* 8A1i */
                            var gasAmount08A1ia = arrayUtil.selectSingle(gasAmounts08A1ia, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08A1i.amount < gasAmount08A1ia.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text",{
                                    category_a: "8_A1_i_a",
                                    category: "8_A1_i"
                                });
                                result.errors.push(error);
                            }

                            /* 8A1ii */
                            var gasAmount08A1ii = arrayUtil.selectSingle(gasAmounts08A1ii, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08A1iia = arrayUtil.selectSingle(gasAmounts08A1iia, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08A1ii.amount < gasAmount08A1iia.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_A1_ii_a",
                                    category: "8_A1_ii"
                                });
                                result.errors.push(error);
                            }

                            /* 8A1iii */
                            var gasAmount08A1iii = arrayUtil.selectSingle(gasAmounts08A1iii, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08A1iiia = arrayUtil.selectSingle(gasAmounts08A1iiia, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08A1iii.amount < gasAmount08A1iiia.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_A1_iii_a",
                                    category: "8_A1_iii"
                                });
                                result.errors.push(error);
                            }

                            /* 8A1iv */
                            var gasAmount08A1iv = arrayUtil.selectSingle(gasAmounts08A1iv, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08A1iva = arrayUtil.selectSingle(gasAmounts08A1iva, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08A1iv.amount < gasAmount08A1iva.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_A1_iv_a",
                                    category: "8_A1_iv"
                                });
                                result.errors.push(error);
                            }

                            /* 8A1other */
                            var gasAmount08A1other = arrayUtil.selectSingle(gasAmounts08A1other, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08A1othera = arrayUtil.selectSingle(gasAmounts08A1othera, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08A1other.amount < gasAmount08A1othera.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_A1_other_a",
                                    category: "8_A1_other"
                                });
                                result.errors.push(error);
                            }

                            /* 8A2other */
                            var gasAmount08A2other = arrayUtil.selectSingle(gasAmounts08A2other, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08A2othera = arrayUtil.selectSingle(gasAmounts08A2othera, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08A2other.amount < gasAmount08A2othera.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_A2_other_a",
                                    category: "8_A2_other"
                                });
                                result.errors.push(error);
                            }

                            /* 8Ba1i */
                            var gasAmount08Ba1i = arrayUtil.selectSingle(gasAmounts08Ba1i, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08Ba1ia = arrayUtil.selectSingle(gasAmounts08Ba1ia, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08Ba1i.amount < gasAmount08Ba1ia.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_Ba1_i_a",
                                    category: "8_Ba1_i"
                                });
                                result.errors.push(error);
                            }

                            /* 8Ba1ii */
                            var gasAmount08Ba1ii = arrayUtil.selectSingle(gasAmounts08Ba1ii, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08Ba1iia = arrayUtil.selectSingle(gasAmounts08Ba1iia, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08Ba1ii.amount < gasAmount08Ba1iia.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_Ba1_ii_a",
                                    category: "8_Ba1_ii"
                                });
                                result.errors.push(error);
                            }

                            /* 8Ba1other */
                            var gasAmount08Ba1other = arrayUtil.selectSingle(gasAmounts08Ba1other, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08Ba1othera = arrayUtil.selectSingle(gasAmounts08Ba1othera, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08Ba1other.amount < gasAmount08Ba1othera.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_Ba1_other_a",
                                    category: "8_Ba1_other"
                                });
                                result.errors.push(error);
                            }

                            /* 8Ba2other */
                            var gasAmount08Ba2other = arrayUtil.selectSingle(gasAmounts08Ba2other, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08Ba2othera = arrayUtil.selectSingle(gasAmounts08Ba2othera, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08Ba2other.amount < gasAmount08Ba2othera.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_Ba2_other_a",
                                    category: "8_Ba2_other"
                                });
                                result.errors.push(error);
                            }

                            /* 8Bb1i */
                            var gasAmount08Bb1i = arrayUtil.selectSingle(gasAmounts08Bb1i, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08Bb1ia = arrayUtil.selectSingle(gasAmounts08Bb1ia, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08Bb1i.amount < gasAmount08Bb1ia.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_Bb1_i_a",
                                    category: "8_Bb1_i"
                                });
                                result.errors.push(error);
                            }

                            /* 8Bb1ii */
                            var gasAmount08Bb1ii = arrayUtil.selectSingle(gasAmounts08Bb1ii, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08Bb1iia = arrayUtil.selectSingle(gasAmounts08Bb1iia, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08Bb1ii.amount < gasAmount08Bb1iia.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_Bb1_ii_a",
                                    category: "8_Bb1_ii"
                                });
                                result.errors.push(error);
                            }

                            /* 8Bb1other */
                            var gasAmount08Bb1other = arrayUtil.selectSingle(gasAmounts08Bb1other, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08Bb1othera = arrayUtil.selectSingle(gasAmounts08Bb1othera, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08Bb1other.amount < gasAmount08Bb1othera.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_Bb1_other_a",
                                    category: "8_Bb1_other"
                                });
                                result.errors.push(error);
                            }

                            /* 8Bb2other */
                            var gasAmount08Bb2other = arrayUtil.selectSingle(gasAmounts08Bb2other, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08Bb2othera = arrayUtil.selectSingle(gasAmounts08Bb2othera, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08Bb2other.amount < gasAmount08Bb2othera.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_Bb2_other_a",
                                    category: "8_Bb2_other"
                                });
                                result.errors.push(error);
                            }

                            /* 8C1other */
                            var gasAmount08C1other = arrayUtil.selectSingle(gasAmounts08C1other, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08C1othera = arrayUtil.selectSingle(gasAmounts08C1othera, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08C1other.amount < gasAmount08C1othera.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_C1_other_a",
                                    category: "8_C1_other"
                                });
                                result.errors.push(error);
                            }

                            /* 8C2other */
                            var gasAmount08C2other = arrayUtil.selectSingle(gasAmounts08C2other, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            var gasAmount08C2othera = arrayUtil.selectSingle(gasAmounts08C2othera, function (gas) {
                                return gas.id === gasAmount08A1i.id;
                            });

                            if (gasAmount08C2other.amount < gasAmount08C2othera.amount) {
                                var error = sheetValidationObjectFactory.createValidationError(that.qccode);
                                error.gasIndex = gasAmount08A1i.index;
                                error.message = $translate.instant("validation_messages.qc_2457.error_text", {
                                    category_a: "8_C2_other_a",
                                    category: "8_C2_other"
                                });
                                result.errors.push(error);
                            }


                        });

                        return result;
                    }
                };
            };

            return new Sheet6bValidator();
        }
    ]);
})();

