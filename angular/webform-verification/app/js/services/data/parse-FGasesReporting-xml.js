(function() {
    window.angular.module('FGases.services.data').factory('ParseFGasesReportingXml', [
        '$translate',

        function($translate) {
            function ParseFGasesReportingXml() { }

            ParseFGasesReportingXml.prototype.parse = function(FGasesReportingNode) {
                let FGasesReporting = {
                    GeneralReportData: {
                        ReportingYear: undefined,
                        EuLegalRepresentativeCompany: {
                            Name: undefined,
                            Country: undefined
                        },
                        Company: {
                            Country:{
                                Type:undefined
                            }
                        }
                    },
                    Bulk: {
                        ReportedGases: new Map(),
                        Transactions: new Map(),
                    },
                    Equipment: {
                        ReportedGases: new Map(),
                        Transactions: new Map(),
                    },
                    ReportedGases: new Map(),
                    Transactions: new Map()                    

                   
                };

                // Transaction nodes and attributes
                let transaction_gases_xpath = [
                    'F1_S1_4_ProdImpExp Gas',
                    'F2_S5_exempted_HFCs Gas',
                    'F4_S9_IssuedAuthQuata',
                    'F7_s11EquImportTable Gas',
                    'F8_S12 Gas',
                ];
                let transactions_xpath_tr01_to_tr05 = [
                    'tr_01A',
                    'tr_01A_a_own',
                    'tr_01A_a_other',
                    'tr_01B',
                    'tr_01C',
                    'tr_02A',
                    'tr_02B',
                    'tr_02G',
                    'tr_02H',
                    'tr_02I',
                    'tr_03B',
                    'tr_04C',
                    'tr_04H',
                    'tr_04M',
                    'tr_05A',
                    'tr_05B',
                    'tr_5C_exempted_CO2e',
                    'tr_05D',
                    'tr_05E',
                    'tr_05F',
                    'tr_05I',
                    'tr_05J',
                ];
                let transactions_xpath_tr09 = [
                    'tr_09A_imp',
                    'tr_09A_add',
                    'tr_09A',
                    'tr_09C',
                    'tr_09F',
                    'tr_5C_exempted_CO2e'
                    
                ];
                let transactions_xpath_tr11_to_tr13 = [
                    'tr_11G',
                    'tr_11R',
                    'tr_12A',
                    'tr_12aA',
                    'tr_13D',
                    'tr_11P',
                ];
                let transactions_xpath = transactions_xpath_tr01_to_tr05
                    .concat(transactions_xpath_tr09)
                    .concat(transactions_xpath_tr11_to_tr13);

                // GeneralReportData
                FGasesReporting.GeneralReportData.ReportingYear = FGasesReportingNode.querySelector('TransactionYear').textContent;

                //EuLegalRepresentative
                FGasesReporting.GeneralReportData.EuLegalRepresentativeCompany.Name = FGasesReportingNode.querySelector('EuLegalRepresentativeCompany').querySelector('CompanyName').textContent;
                FGasesReporting.GeneralReportData.EuLegalRepresentativeCompany.Country = FGasesReportingNode.querySelector('EuLegalRepresentativeCompany').querySelector('Country').querySelector('Name').textContent;

                //CountryType
                FGasesReporting.GeneralReportData.Company.Country.Type = FGasesReportingNode.querySelector('GeneralReportData').querySelector('Company ').querySelector('Country').querySelector('Type').textContent;

                // ReportedGases
                for (const reportedGasNode of FGasesReportingNode.querySelectorAll('ReportedGases')) {
                    if (!this._is_HFCs_or_HFC_mixtures(reportedGasNode)) { continue }

                    components = []
                    for (const componentNode of reportedGasNode.querySelectorAll('Component')) {
                        components.push({
                            Code: componentNode.querySelector('Code').textContent,
                            Percentage: this._fix_percentage_decimals(componentNode.querySelector('Percentage').textContent),
                            GWP_AR4_AnnexIV: this._fix_gwp_decimals(componentNode.querySelector('GWP_AR4_AnnexIV').textContent),
                        });
                    }
                    let gas_id = reportedGasNode.querySelector('GasId').textContent;
                    FGasesReporting.ReportedGases.set(gas_id, {
                        GasId: gas_id,
                        Name: reportedGasNode.querySelector('Name').textContent,
                        GWP_AR4_AnnexIV: this._fix_gwp_decimals(reportedGasNode.querySelector('GWP_AR4_AnnexIV').textContent),
                        BlendComponents: { Component: components }
                    });
                }

                // Transactions
                for (const transaction_xpath of transactions_xpath) {
                    let transaction_id = transaction_xpath;
                    let category = undefined;
                    if (transaction_id == 'tr_11P') {
                        category = FGasesReportingNode.querySelector('F7_s11EquImportTable Category tr_11P')?.textContent || undefined;
                    }
                    FGasesReporting.Transactions.set(transaction_id, {
                        id: transaction_id,
                        code: this._get_code_transaction_id(transaction_id, $translate),
                        description: this._get_description_transaction_id(transaction_id, $translate),
                        description2: this._get_description2_transaction_id(transaction_id, $translate),
                        category: category,
                        formula: this._get_formula_transaction_id(transaction_id, $translate),
                        option_a_tooltip: this._get_option_a_tooltip_transaction_id(transaction_id, $translate),
                        option_b_tooltip: this._get_option_b_tooltip_transaction_id(transaction_id, $translate),
                        option_c_tooltip: this._get_option_c_tooltip_transaction_id(transaction_id, $translate),
                        tco2e: undefined,
                        gases: new Map(),
                    });
                    for (const [gas_id, reportedGas] of FGasesReporting.ReportedGases) {
                        FGasesReporting.Transactions.get(transaction_id).gases.set(reportedGas.GasId, {
                            gas_id: gas_id,
                            amount: undefined,
                        });
                    }
                }
                for (const transactionGasNode of FGasesReportingNode.querySelectorAll(transaction_gases_xpath.join(','))) {
                    let gas_id = transactionGasNode.querySelector('GasCode')?.textContent;
                    for (const transactionNone of transactionGasNode.querySelectorAll(transactions_xpath.join(','))) {
                        if (transactions_xpath_tr01_to_tr05.concat(transactions_xpath_tr11_to_tr13).includes(transactionNone.tagName)) {
                            let transaction_id = transactionNone.tagName;
                            let typeOfAmount = "";
                            if (transactionNone.querySelector('SumOfPartnerAmounts'))
                                typeOfAmount = 'SumOfPartnerAmounts';
                            else typeOfAmount = 'Amount';
                            for (const amountNode of transactionNone.querySelectorAll(typeOfAmount)) {
                                let amount = parseFloat(amountNode.textContent) || undefined;
                                if (amount && FGasesReporting.Transactions.get(transaction_id).gases.has(gas_id)) {
                                    if (FGasesReporting.Transactions.get(transaction_id).gases.get(gas_id).amount == undefined) {
                                        FGasesReporting.Transactions.get(transaction_id).gases.get(gas_id).amount = amount;
                                    }
                                    else {
                                        FGasesReporting.Transactions.get(transaction_id).gases.get(gas_id).amount += amount;
                                    }
                                }
                                else if (transaction_id == "tr_5C_exempted_CO2e") {
                                    FGasesReporting.Transactions.get(transaction_id).tco2e = amount;
                                   // FGasesReporting.Transactions.get(transaction_id).gases.get(gas_id).amount = undefined;
                                }
                            }
                        }
                    }
                }
                // Calculate 13D: [13D = 11_R – 12A –12aA]
                for (const [gas_id, gas] of FGasesReporting.Transactions.get('tr_13D').gases) {
                    let amount_11R = FGasesReporting.Transactions.get('tr_11R').gases.get(gas_id).amount || 0;
                    let amount_12A = FGasesReporting.Transactions.get('tr_12A').gases.get(gas_id).amount || 0;
                    let amount_12aA = FGasesReporting.Transactions.get('tr_12aA').gases.get(gas_id).amount || 0;
                    gas.amount = amount_11R - amount_12A - amount_12aA;
                }
                // Format amount decimals
                for (const [transaction_id, transaction] of FGasesReporting.Transactions) {
                    if (!transactions_xpath_tr09.includes(transaction_id)) {
                        for (const [gas_id, gas] of transaction.gases) {
                            let amount = (gas.amount === undefined) ? '0' : gas.amount.toFixed(3);
                            gas.amount = amount;
                        }
                    }
                }

                // Calculate tCO2e
                let tco2e;
               
                for (const [transaction_id, transaction] of FGasesReporting.Transactions) {
                    if (transaction.id != "tr_5C_exempted_CO2e") {
                        tco2e = 0;
                        for (const [gas_id, gas] of transaction.gases) {
                            let GWP = FGasesReporting.ReportedGases.get(gas_id).GWP_AR4_AnnexIV;
                            tco2e += (GWP * gas.amount);
                    }
                    
                        transaction.tco2e = Math.round(tco2e);
                        }
                   }

                // For 9A_imp & 9A_add make sure to display the totals (not the company-specific data as contained in the data report XML)
                // 9A, 9C & 9F can be taken directly from the data report XML
                // 5H CO2e can be taken from the 9D amount in the data report XML - [5H = 4M]
                // 5J CO2e can be taken from the 9E amount in the data report XML
                let tcoe2_pairs = [
                    ['tr_09A_imp SumOfPartnerAmounts', 'tr_09A_imp'],
                    ['tr_09A_add SumOfPartnerAmounts', 'tr_09A_add'],
                    ['tr_09A SumOfPartnerAmounts', 'tr_09A'],
                    ['tr_09C Amount', 'tr_09C'],
                    ['tr_09F Amount', 'tr_09F'],
                    ['tr_09E Amount', 'tr_05J'],
                ];
                for (const [from, to] of tcoe2_pairs) {
                    tco2e = parseFloat(FGasesReportingNode.querySelector(from)?.textContent | 0).toFixed(0);
                    FGasesReporting.Transactions.get(to).tco2e = tco2e;
                }

                FGasesReporting.Bulk.ReportedGases = structuredClone(FGasesReporting.ReportedGases);
                FGasesReporting.Bulk.Transactions = structuredClone(FGasesReporting.Transactions);
                FGasesReporting.Equipment.ReportedGases = structuredClone(FGasesReporting.ReportedGases);
                FGasesReporting.Equipment.Transactions = structuredClone(FGasesReporting.Transactions);
                delete FGasesReporting.ReportedGases;
                delete FGasesReporting.Transactions;

                // Remove ReportedGases that not has (1A>0 or 2A>0 or 2G>0 or 4C>0)
                this._remove_reported_gases_without_tr_for_bulk(FGasesReporting.Bulk);
                // Remove all transaction except 9s if no ReportedGases
                this._remove_transactions_if_no_repoted_gases_for_bulk(FGasesReporting.Bulk, transactions_xpath_tr01_to_tr05.concat(transactions_xpath_tr11_to_tr13));
                // Clean up FGasesReporting.Bulk.Transactions
                this._remove_transactions(FGasesReporting.Bulk.Transactions, transactions_xpath_tr11_to_tr13);

                // Remove ReportedGases that not (11_G>0 or 11_P>0)
                this._remove_reported_gases_without_tr_for_equiment(FGasesReporting.Equipment);
                // Remove tr_11P transaction if do have CO2e calculated
                this._remove_transaction_11p_if_no_tco2e(FGasesReporting.Equipment.Transactions);
                // Clean up FGasesReporting.Equipment.Transactions
                this._remove_transactions(FGasesReporting.Equipment.Transactions, transactions_xpath_tr01_to_tr05.concat(transactions_xpath_tr09));

                // Convert Maps to Array
                this._convert_maps_to_array(FGasesReporting);

                return FGasesReporting;
            }

            // #region format functions
            ParseFGasesReportingXml.prototype._fix_gwp_decimals = function(gwp) {
                return gwp ? parseFloat(parseFloat(gwp).toFixed(8)).toString() : gwp;
            }
            ParseFGasesReportingXml.prototype._fix_percentage_decimals = function(percentage) {
                return percentage ? parseFloat(parseFloat(percentage).toFixed(3)).toString() : percentage;
            }
            // #endregion

            // #region Translations functions
            ParseFGasesReportingXml.prototype._get_code_transaction_id = function(transaction_id, $translate) {
                let translationId = `bulk-hfcs-verification.transactions.${transaction_id}.code`;
                let code = $translate.instant(translationId);
                if ((code == translationId) || (code == "undefined")) {
                    translationId = undefined;
                }
                return translationId;
            }
            ParseFGasesReportingXml.prototype._get_description_transaction_id = function(transaction_id, $translate) {
                let translationId = `bulk-hfcs-verification.transactions.${transaction_id}.description`;
                let description = $translate.instant(translationId);
                if ((description == translationId) || (description == "undefined")) {
                    translationId = undefined;
                }
                return translationId;
            }
            ParseFGasesReportingXml.prototype._get_description2_transaction_id = function(transaction_id, $translate) {
                let translationId = `bulk-hfcs-verification.transactions.${transaction_id}.description2`;
                let description = $translate.instant(translationId);
                if ((description == translationId) || (description == "undefined")) {
                    translationId = undefined;
                }
                return translationId;
            }
            ParseFGasesReportingXml.prototype._get_formula_transaction_id = function(transaction_id, $translate) {
                let translationId = `bulk-hfcs-verification.transactions.${transaction_id}.formula`;
                let formula = $translate.instant(translationId);
                if ((formula == translationId) || (formula == "undefined")) {
                    translationId = undefined;
                }
                return translationId;
            }
            ParseFGasesReportingXml.prototype._get_option_a_tooltip_transaction_id = function(transaction_id, $translate) {
                let translationId = `bulk-hfcs-verification.transactions.${transaction_id}.option_a_tooltip`;
                let option_a_tooltip = $translate.instant(translationId);
                if ((option_a_tooltip == translationId) || (option_a_tooltip == "undefined")) {
                    translationId = undefined;
                }
                return translationId;
            }
            ParseFGasesReportingXml.prototype._get_option_b_tooltip_transaction_id = function(transaction_id, $translate) {
                let translationId = `bulk-hfcs-verification.transactions.${transaction_id}.option_b_tooltip`;
                let option_b_tooltip = $translate.instant(translationId);
                if ((option_b_tooltip == translationId) || (option_b_tooltip == "undefined")) {
                    translationId = undefined;
                }
                return translationId;
            }
            ParseFGasesReportingXml.prototype._get_option_c_tooltip_transaction_id = function(transaction_id, $translate) {
                let translationId = `bulk-hfcs-verification.transactions.${transaction_id}.option_c_tooltip`;
                let option_c_tooltip = $translate.instant(translationId);
                if ((option_c_tooltip == translationId) || (option_c_tooltip == "undefined")) {
                    translationId = undefined;
                }
                return translationId;
            }
            // #endregion

            // #region Filter functions
            ParseFGasesReportingXml.prototype._is_HFCs_or_HFC_mixtures = function(reportedGasNode) {
                let GasGroupId = reportedGasNode.querySelector('GasGroupId')?.textContent | 0;
                GasGroupId = parseInt(GasGroupId);
                if ((GasGroupId == 1) || (GasGroupId == 7)) return true;

                for (const componentNode of reportedGasNode.querySelectorAll('Component')) {
                    GasGroupId = componentNode.querySelector('GasGroupId')?.textContent | 0;
                    GasGroupId = parseInt(GasGroupId);
                    if (GasGroupId == 1) return true;
                }

                return false;
            }

            ParseFGasesReportingXml.prototype._remove_reported_gases_without_tr_for_bulk = function(FGasesReporting) {
                // Find ReportedGases that not (1A>0 or 2A>0 or 2G>0 or 4C>0)
                let gas_ids_to_remove = [];
                for (const [gas_id, reportedGas] of FGasesReporting.ReportedGases) {
                    let amount_1A = undefined;
                    let amount_2A = undefined;
                    let amount_2G = undefined;
                    let amount_4C = undefined;

                    for (const [transaction_id, transaction] of FGasesReporting.Transactions) {
                        for (const [gas_id, gas] of transaction.gases) {
                            if (gas_id == reportedGas.GasId) {
                                if (transaction_id == 'tr_01A') { amount_1A = parseFloat(gas.amount); break}
                                if (transaction_id == 'tr_02A') { amount_2A = parseFloat(gas.amount); break}
                                if (transaction_id == 'tr_02G') { amount_2G = parseFloat(gas.amount); break}
                                if (transaction_id == 'tr_04C') { amount_4C = parseFloat(gas.amount); break}
                            }
                        }
                    }
                    if (!((amount_1A > 0) || (amount_2A > 0) || (amount_2G > 0) || (amount_4C > 0))) {
                        gas_ids_to_remove.push(reportedGas.GasId)
                    }
                }
                // Remove ReportedGases
                gas_ids_to_remove.forEach(id => FGasesReporting.ReportedGases.delete(id));
                // Remove scope.FGasesReporting.Transactions.gases
                for (const [transaction_id, transaction] of FGasesReporting.Transactions) {
                    gas_ids_to_remove.forEach(id => transaction.gases.delete(id));
                }
            }

            ParseFGasesReportingXml.prototype._remove_reported_gases_without_tr_for_equiment = function(FGasesReporting) {
                // Find ReportedGases that not (11_G>0 or 11_P>0)
                let gas_ids_to_remove = [];
                for (const [gas_id, reportedGas] of FGasesReporting.ReportedGases) {
                    let amount_11G = undefined;
                    let amount_11P = undefined;

                    for (const [transaction_id, transaction] of FGasesReporting.Transactions) {
                        for (const [gas_id, gas] of transaction.gases) {
                            if (gas_id == reportedGas.GasId) {
                                if (transaction_id == 'tr_11G') { amount_11G = parseFloat(gas.amount); break}
                                if (transaction_id == 'tr_11P') { amount_11P = parseFloat(gas.amount); break}
                            }
                        }
                    }
                    if (!((amount_11G > 0) || (amount_11P > 0))) {
                        gas_ids_to_remove.push(reportedGas.GasId)
                    }
                }
                // Remove ReportedGases
                gas_ids_to_remove.forEach(id => FGasesReporting.ReportedGases.delete(id));
                // Remove scope.FGasesReporting.Transactions.gases
                for (const [transaction_id, transaction] of FGasesReporting.Transactions) {
                    gas_ids_to_remove.forEach(id => transaction.gases.delete(id));
                }
            }

            ParseFGasesReportingXml.prototype._remove_transaction_11p_if_no_tco2e = function(transactions) {
                let transaction = transactions.get('tr_11P');
                let tco2e = transaction.tco2e;
                if (!tco2e > 0) {
                    transactions.delete('tr_11P');
                }
            }

            ParseFGasesReportingXml.prototype._remove_transactions_if_no_repoted_gases_for_bulk = function(FGasesReporting, transaction_ids) {
                if (FGasesReporting.ReportedGases.size == 0) {
                    transaction_ids.forEach(transaction_id => {
                        let id = transaction_id.slice(3)
                        FGasesReporting.Transactions.delete(id);
                    })
                }
            }

            ParseFGasesReportingXml.prototype._remove_transactions = function(transactions, transaction_ids) {
                for (const transaction_id of transaction_ids) {
                    transactions.delete(transaction_id);
                }
            }

            ParseFGasesReportingXml.prototype._convert_maps_to_array = function(FGasesReporting) {
                FGasesReporting.Bulk.ReportedGases = Array.from(FGasesReporting.Bulk.ReportedGases.values());
                FGasesReporting.Bulk.Transactions = Array.from(FGasesReporting.Bulk.Transactions.values());
                for (const transaction of FGasesReporting.Bulk.Transactions) {
                    transaction.gases = Array.from(transaction.gases.values());
                }

                FGasesReporting.Equipment.ReportedGases = Array.from(FGasesReporting.Equipment.ReportedGases.values());
                FGasesReporting.Equipment.Transactions = Array.from(FGasesReporting.Equipment.Transactions.values());
                for (const transaction of FGasesReporting.Equipment.Transactions) {
                    transaction.gases = Array.from(transaction.gases.values());
                }
            }
            // #endregion

            return new ParseFGasesReportingXml();
        }
    ]);
})();
