
(function() {
    
    window.angular.module('FGases.services.data').factory('reportStructureHelper', [
        
        function() {
            
            function ReportStructureHelper() { }
            
            ReportStructureHelper.prototype.getGasSelectionLists = function() {
                return ['HFCs', 'PFCs', 'SF6', 'Inhalation', 'NF3', 'UnsaturatedHFCsHCFC', 'FluorinatedEthersAlcohols', 'OtherPrefluorinatedCompounds', 'NonFluorinatedRefrigerants', 'CommonlyUsedMixtures'];
            };
            
            ReportStructureHelper.prototype.getGasIncludingSheets = function() {
                return ["F1_S1_4_ProdImpExp", "F2_S5_exempted_HFCs", "F2a_S5a_exempted_HFCs", "F3A_S6A_IA_HFCs", "F6_FUDest", "F7_s11EquImportTable", "F8_S12"];
            };
            
            ReportStructureHelper.prototype.getTradePartnerTransactions = function() {
                return {
                    F1_S1_4_ProdImpExp: ["tr_01C", "tr_01A_a_other", "tr_02H"],
                    F2_S5_exempted_HFCs: ["tr_05A", "tr_05B", "tr_05C", "tr_05D", "tr_05E", "tr_05F", "tr_05R"]
                };
            };
            
            ReportStructureHelper.prototype.getTradePartnerContainers = function() {
                return {
                    F1_S1_4_ProdImpExp: ["tr_01C_TradePartners", "tr_01A_a_other_ExtDestruction", "tr_02H_TradePartners"],
                    F2_S5_exempted_HFCs: [
                        "tr_05A_TradePartners", "tr_05B_TradePartners", "tr_05C_TradePartners", "tr_05D_TradePartners", 
                        "tr_05E_TradePartners", "tr_05F_TradePartners", "tr_05R_TradePartners"
                    ],
                    F8_S12: ["tr_12A_TradePartners", "tr_12aA_TradePartners", "tr_12B_TradePartners", "tr_12aB_TradePartners"]
                };
            };

            return new ReportStructureHelper();
        }
    ]);
})();
