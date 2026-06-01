(function() {
    // Definition of transaction add/edit modal instance Controller
    angular.module('FGases.controllers').controller('Sheet8Ctrl', function($rootScope, $scope){

        $scope.txids = []; // for tr_12A
        $scope.txids_12aA = [];
        $scope.txids_12B = [];
        $scope.txids_12aB = [];
        $scope.onlyNumbers = /\d+\.?\d*/;
        $scope.emptyTransaction;

        $scope.get_gas_by_id = function(gas_id) {
            for (var i=0; i < $scope.instance.FGasesReporting.ReportedGases.length; i++) {
                if (gas_id === $scope.instance.FGasesReporting.ReportedGases[i].GasId) {
                    return $scope.instance.FGasesReporting.ReportedGases[i];
                }
            }
        }

        $scope.init = function(args) {
            $scope.args = args;

            if (!$scope.transactions12A) {
                $scope.transactions12A = {};
                if (!$scope.emptyTransaction) {
                    $scope.emptyTransaction = clone(this.getInstanceByPath('emptyInstance', 'FGasesReporting.F8_S12.Gas.tr_12A.Transaction'));
                }
                for (var i = 0; i < $scope.args.gasArray.length; i++) {
                    
                    var transactions = $scope.args.gasArray[i].tr_12A.Transaction;
                    if (!Array.isArray(transactions)) {
                        if (transactions !== undefined) {
                            transactions = [transactions];
                        } else {
                            transactions = [];
                        }
                        $scope.args.gasArray[i].tr_12A.Transaction = transactions;
                    }
                    $scope.transactions12A[$scope.args.gasArray[i].GasCode] = transactions;
                    for (var j = 0; j < $scope.transactions12A[$scope.args.gasArray[i].GasCode].length; j++) {
                        if (!$scope.txids[j]) {
                            $scope.txids[j] = {};
                        }
                        var txinfo = $scope.txids[j];
                        txinfo[$scope.args.gasArray[i].GasCode] = $scope.transactions12A[$scope.args.gasArray[i].GasCode][j].TransactionID;
                    }

                }

            }

            if (!$scope.transactions12aA) {
                $scope.transactions12aA = {};
                if (!$scope.emptyTransaction) {
                    $scope.emptyTransaction = clone(this.getInstanceByPath('emptyInstance', 'FGasesReporting.F8_S12.Gas.tr_12aA.Transaction'));
                }
                for (var i = 0; i < $scope.args.gasArray.length; i++) {

                    var transactions = $scope.args.gasArray[i].tr_12aA.Transaction;
                    if (!Array.isArray(transactions)) {
                        if (transactions !== undefined) {
                            transactions = [transactions];
                        } else {
                            transactions = [];
                        }
                        $scope.args.gasArray[i].tr_12aA.Transaction = transactions;
                    }
                    $scope.transactions12aA[$scope.args.gasArray[i].GasCode] = transactions;
                    for (var j = 0; j < $scope.transactions12aA[$scope.args.gasArray[i].GasCode].length; j++) {
                        if (!$scope.txids_12aA[j]) {
                            $scope.txids_12aA[j] = {};
                        }
                        var txinfo_12aA = $scope.txids_12aA[j];
                        txinfo_12aA[$scope.args.gasArray[i].GasCode] = $scope.transactions12aA[$scope.args.gasArray[i].GasCode][j].TransactionID;
                    }

                }

            }

            if (!$scope.transactions12B) {
                $scope.transactions12B = {};
                if (!$scope.emptyTransaction) {
                    $scope.emptyTransaction = clone(this.getInstanceByPath('emptyInstance', 'FGasesReporting.F8_S12.Gas.tr_12B.Transaction'));
                }
                for (var i = 0; i < $scope.args.gasArray.length; i++) {

                    var transactions = $scope.args.gasArray[i].tr_12B.Transaction;
                    if (!Array.isArray(transactions)) {
                        if (transactions !== undefined) {
                            transactions = [transactions];
                        } else {
                            transactions = [];
                        }
                        $scope.args.gasArray[i].tr_12B.Transaction = transactions;
                    }
                    $scope.transactions12B[$scope.args.gasArray[i].GasCode] = transactions;
                    for (var j = 0; j < $scope.transactions12B[$scope.args.gasArray[i].GasCode].length; j++) {
                        if (!$scope.txids_12B[j]) {
                            $scope.txids_12B[j] = {};
                        }
                        var txinfo = $scope.txids_12B[j];
                        txinfo[$scope.args.gasArray[i].GasCode] = $scope.transactions12B[$scope.args.gasArray[i].GasCode][j].TransactionID;
                    }

                }

            }

            if (!$scope.transactions12aB) {
                $scope.transactions12aB = {};
                if (!$scope.emptyTransaction) {
                    $scope.emptyTransaction = clone(this.getInstanceByPath('emptyInstance', 'FGasesReporting.F8_S12.Gas.tr_12aB.Transaction'));
                }
                for (var i = 0; i < $scope.args.gasArray.length; i++) {

                    var transactions = $scope.args.gasArray[i].tr_12aB.Transaction;
                    if (!Array.isArray(transactions)) {
                        if (transactions !== undefined) {
                            transactions = [transactions];
                        } else {
                            transactions = [];
                        }
                        $scope.args.gasArray[i].tr_12aB.Transaction = transactions;
                    }
                    $scope.transactions12aB[$scope.args.gasArray[i].GasCode] = transactions;
                    for (var j = 0; j < $scope.transactions12aB[$scope.args.gasArray[i].GasCode].length; j++) {
                        if (!$scope.txids_12aB[j]) {
                            $scope.txids_12aB[j] = {};
                        }
                        var txinfo = $scope.txids_12aB[j];
                        txinfo[$scope.args.gasArray[i].GasCode] = $scope.transactions12aB[$scope.args.gasArray[i].GasCode][j].TransactionID;
                    }

                }

            }

            $scope.$watch(function() { return $scope.args.s11Array; }, function(){
                for (var i = 0; i < $scope.args.gasArray.length; i++) {
                    gas = $scope.get_gas_by_id($scope.args.gasArray[i].GasCode);
                    if (gas && $scope.containsHFC(gas)) {
                        $scope.args.gasArray[i].Totals.tr_12bA = $scope.args.s11Array[i].tr_11G.Amount;
                        $scope.args.gasArray[i].Totals.tr_12bB = $scope.args.s11Array[i].tr_11J1.Amount;
                        $scope.args.gasArray[i].Totals.tr_12Ca = $scope.args.s11Array[i].tr_11R.Amount;
                        if ($scope.args.gasArray[i].Totals.tr_12bA) {
                            $scope.calculate_sums();
                        }

                    } else {
                        $scope.args.gasArray[i].Totals.tr_12cA = "0.000";
                        $scope.args.gasArray[i].Totals.tr_12bA = "0.000";
                        $scope.args.gasArray[i].Totals.tr_12bB = "0.000";
                        $scope.args.gasArray[i].Totals.tr_12cB = "0.000";
                        $scope.args.gasArray[i].Totals.tr_12Ca = "0.000";
                    }
                }
            }, true);

            $scope.$watch(function() {return $scope.args.gasArray.length;}, function(){
                var gas_txs;
                for (var i = 0; i < $scope.args.gasArray.length; i++) {
                    if (!$scope.transactions12A[$scope.args.gasArray[i].GasCode]) {
                        if (!$scope.transactions12A[$scope.args.gasArray[0].GasCode]) {
                            $scope.transactions12A[$scope.args.gasArray[i].GasCode] = [];
                        } else {
                            $scope.transactions12A[$scope.args.gasArray[i].GasCode] = angular.copy($scope.transactions12A[$scope.args.gasArray[0].GasCode]);
                        }
                        if ($scope.transactions12A[$scope.args.gasArray[i].GasCode]) {
                            for (var j = 0; j < $scope.transactions12A[$scope.args.gasArray[i].GasCode].length; j++) {
                                var new_tx_id = 'transaction_' + Date.now();
                                $scope.transactions12A[$scope.args.gasArray[i].GasCode][j].TransactionID = new_tx_id;
                                $scope.transactions12A[$scope.args.gasArray[i].GasCode][j].Amount = null;
                                $scope.transactions12A[$scope.args.gasArray[i].GasCode][j].Comment = null;
                                $scope.txids[j][$scope.args.gasArray[i].GasCode] = new_tx_id;
                            }
                            $scope.args.gasArray[i].tr_12A.Transaction = $scope.transactions12A[$scope.args.gasArray[i].GasCode];
                        }
                    }
                }
                for (var i = 0; i < $scope.args.gasArray.length; i++) {
                    if (!$scope.transactions12aA[$scope.args.gasArray[i].GasCode]) {
                        if (!$scope.transactions12aA[$scope.args.gasArray[0].GasCode]) {
                            $scope.transactions12aA[$scope.args.gasArray[i].GasCode] = [];
                        } else {
                            $scope.transactions12aA[$scope.args.gasArray[i].GasCode] = angular.copy($scope.transactions12aA[$scope.args.gasArray[0].GasCode]);
                        }
                        if ($scope.transactions12aA[$scope.args.gasArray[i].GasCode]) {
                            for (var j = 0; j < $scope.transactions12aA[$scope.args.gasArray[i].GasCode].length; j++) {
                                var new_tx_id = 'transaction_' + Date.now();
                                $scope.transactions12aA[$scope.args.gasArray[i].GasCode][j].TransactionID = new_tx_id;
                                $scope.transactions12aA[$scope.args.gasArray[i].GasCode][j].Amount = null;
                                $scope.transactions12aA[$scope.args.gasArray[i].GasCode][j].Comment = null;
                                $scope.txids_12aA[j][$scope.args.gasArray[i].GasCode] = new_tx_id;
                            }
                            $scope.args.gasArray[i].tr_12aA.Transaction = $scope.transactions12aA[$scope.args.gasArray[i].GasCode];
                        }
                    }
                }
                for (var i = 0; i < $scope.args.gasArray.length; i++) {
                    if (!$scope.transactions12B[$scope.args.gasArray[i].GasCode]) {
                        if (!$scope.transactions12B[$scope.args.gasArray[0].GasCode]) {
                            $scope.transactions12B[$scope.args.gasArray[i].GasCode] = [];
                        } else {
                            $scope.transactions12B[$scope.args.gasArray[i].GasCode] = angular.copy($scope.transactions12B[$scope.args.gasArray[0].GasCode]);
                        }
                        if ($scope.transactions12B[$scope.args.gasArray[i].GasCode]) {
                            for (var j = 0; j < $scope.transactions12B[$scope.args.gasArray[i].GasCode].length; j++) {
                                var new_tx_id = 'transaction_' + Date.now();
                                $scope.transactions12B[$scope.args.gasArray[i].GasCode][j].TransactionID = new_tx_id;
                                $scope.transactions12B[$scope.args.gasArray[i].GasCode][j].Amount = null;
                                $scope.transactions12B[$scope.args.gasArray[i].GasCode][j].Comment = null;
                                $scope.txids_12B[j][$scope.args.gasArray[i].GasCode] = new_tx_id;
                            }
                            $scope.args.gasArray[i].tr_12B.Transaction = $scope.transactions12B[$scope.args.gasArray[i].GasCode];
                        }
                    }
                }
                for (var i = 0; i < $scope.args.gasArray.length; i++) {
                    if (!$scope.transactions12aB[$scope.args.gasArray[i].GasCode]) {
                        if (!$scope.transactions12aB[$scope.args.gasArray[0].GasCode]) {
                            $scope.transactions12aB[$scope.args.gasArray[i].GasCode] = [];
                        } else {
                            $scope.transactions12aB[$scope.args.gasArray[i].GasCode] = angular.copy($scope.transactions12aB[$scope.args.gasArray[0].GasCode]);
                        }
                        if ($scope.transactions12aB[$scope.args.gasArray[i].GasCode]) {
                            for (var j = 0; j < $scope.transactions12aB[$scope.args.gasArray[i].GasCode].length; j++) {
                                var new_tx_id = 'transaction_' + Date.now();
                                $scope.transactions12aB[$scope.args.gasArray[i].GasCode][j].TransactionID = new_tx_id;
                                $scope.transactions12aB[$scope.args.gasArray[i].GasCode][j].Amount = null;
                                $scope.transactions12aB[$scope.args.gasArray[i].GasCode][j].Comment = null;
                                $scope.txids_12aB[j][$scope.args.gasArray[i].GasCode] = new_tx_id;
                            }
                            $scope.args.gasArray[i].tr_12aB.Transaction = $scope.transactions12aB[$scope.args.gasArray[i].GasCode];
                        }
                    }
                }
                if (Object.keys($scope.transactions12A).length > $scope.args.gasArray.length) {
                    var gascodes = $scope.get_gascodes();
                    var to_remove = [];
                    angular.forEach($scope.transactions12A, function(value, key) {
                        if (gascodes.indexOf(parseInt(key, 10)) === -1) {
                            to_remove.push(parseInt(key, 10));
                        }
                    });
                    for (var i = 0; i < to_remove.length; i++) {
                        delete $scope.transactions12A[to_remove[i]];
                        for (var j = 0; j < $scope.txids.length; j++) {
                            delete $scope.txids[j][to_remove[i]];
                        }
                    }
                }
                if (Object.keys($scope.transactions12aA).length > $scope.args.gasArray.length) {
                    var gascodes = $scope.get_gascodes();
                    var to_remove = [];
                    angular.forEach($scope.transactions12aA, function (value, key) {
                        if (gascodes.indexOf(parseInt(key, 10)) === -1) {
                            to_remove.push(parseInt(key, 10));
                        }
                    });
                    for (var i = 0; i < to_remove.length; i++) {
                        delete $scope.transactions12aA[to_remove[i]];
                        for (var j = 0; j < $scope.txids_12aA.length; j++) {
                            delete $scope.txids_12aA[j][to_remove[i]];
                        }
                    }
                }
                if (Object.keys($scope.transactions12B).length > $scope.args.gasArray.length) {
                    var gascodes = $scope.get_gascodes();
                    var to_remove = [];
                    angular.forEach($scope.transactions12B, function (value, key) {
                        if (gascodes.indexOf(parseInt(key, 10)) === -1) {
                            to_remove.push(parseInt(key, 10));
                        }
                    });
                    for (var i = 0; i < to_remove.length; i++) {
                        delete $scope.transactions12B[to_remove[i]];
                        for (var j = 0; j < $scope.txids_12B.length; j++) {
                            delete $scope.txids_12B[j][to_remove[i]];
                        }
                    }
                }
                if (Object.keys($scope.transactions12aB).length > $scope.args.gasArray.length) {
                    var gascodes = $scope.get_gascodes();
                    var to_remove = [];
                    angular.forEach($scope.transactions12aB, function (value, key) {
                        if (gascodes.indexOf(parseInt(key, 10)) === -1) {
                            to_remove.push(parseInt(key, 10));
                        }
                    });
                    for (var i = 0; i < to_remove.length; i++) {
                        delete $scope.transactions12aB[to_remove[i]];
                        for (var j = 0; j < $scope.txids_12aB.length; j++) {
                            delete $scope.txids_12aB[j][to_remove[i]];
                        }
                    }
                }
            });

        }

        $scope.get_gascodes = function() {
            var gascodes = [];
            for (var i = 0; i < $scope.args.gasArray.length; i++) {
                gascodes.push($scope.args.gasArray[i].GasCode);
            }
            return gascodes;
        }


        $scope.has_partner = function(p_type, txid) {
            var result = false;
            for (var i = 0; i < this.args.gasArray.length; i++) {
                if ($scope.transactions12A[this.args.gasArray[i].GasCode].length > 0){
                    for (var j = 0; j < $scope.transactions12A[this.args.gasArray[i].GasCode].length; j++) {
                        if ($scope.transactions12A[this.args.gasArray[i].GasCode][j].TransactionID == txid[this.args.gasArray[i].GasCode]) {
                            if ($scope.transactions12A[this.args.gasArray[i].GasCode][j][p_type].TradePartnerID) {
                                result = true;
                            }
                        }
                    }
                }
            }
            return result;
        }

        $scope.has_partner_12aA = function (p_type, txid_12aA) {
            var result = false;
            for (var i = 0; i < this.args.gasArray.length; i++) {
                if ($scope.transactions12aA[this.args.gasArray[i].GasCode].length > 0) {
                    for (var j = 0; j < $scope.transactions12aA[this.args.gasArray[i].GasCode].length; j++) {
                        if ($scope.transactions12aA[this.args.gasArray[i].GasCode][j].TransactionID == txid_12aA[this.args.gasArray[i].GasCode]) {
                            if ($scope.transactions12aA[this.args.gasArray[i].GasCode][j][p_type].TradePartnerID) {
                                result = true;
                            }
                        }
                    }
                }
            }
            return result;
        }

        $scope.has_partner_12B = function (p_type, txid_12B) {
            var result = false;
            for (var i = 0; i < this.args.gasArray.length; i++) {
                if ($scope.transactions12B[this.args.gasArray[i].GasCode].length > 0) {
                    for (var j = 0; j < $scope.transactions12B[this.args.gasArray[i].GasCode].length; j++) {
                        if ($scope.transactions12B[this.args.gasArray[i].GasCode][j].TransactionID == txid_12B[this.args.gasArray[i].GasCode]) {
                            if ($scope.transactions12B[this.args.gasArray[i].GasCode][j][p_type].TradePartnerID) {
                                result = true;
                            }
                        }
                    }
                }
            }
            return result;
        }

        $scope.has_partner_12aB = function (p_type, txid_12aB) {
            var result = false;
            for (var i = 0; i < this.args.gasArray.length; i++) {
                if ($scope.transactions12aB[this.args.gasArray[i].GasCode].length > 0) {
                    for (var j = 0; j < $scope.transactions12aB[this.args.gasArray[i].GasCode].length; j++) {
                        if ($scope.transactions12aB[this.args.gasArray[i].GasCode][j].TransactionID == txid_12aB[this.args.gasArray[i].GasCode]) {
                            if ($scope.transactions12aB[this.args.gasArray[i].GasCode][j][p_type].TradePartnerID) {
                                result = true;
                            }
                        }
                    }
                }
            }
            return result;
        }

        $scope.get_partner = function(p_type, partner_id, partnerXml) {
            for (var j = 0; j < partnerXml.Partner.length; j++) {
                if (partner_id == partnerXml.Partner[j].PartnerId) {
                    return {
                            "partner": partnerXml.Partner[j],
                            "p_type": p_type,
                            "index": j
                            };
                }
            }
        }
        // Return the company name of the partner of type p_type
        $scope.get_tx_partner = function(p_type, txid) {
            var partner_id = null;
            var tx_year = null;
            for (var i = 0; i < this.args.gasArray.length; i++) {
                if ($scope.transactions12A[this.args.gasArray[i].GasCode].length > 0){
                    for (var j = 0; j < $scope.transactions12A[this.args.gasArray[i].GasCode].length; j++) {
                        if ($scope.transactions12A[this.args.gasArray[i].GasCode][j].TransactionID == txid[this.args.gasArray[i].GasCode]) {
                            partner_id = $scope.transactions12A[this.args.gasArray[i].GasCode][j][p_type].TradePartnerID;
                            tx_year = $scope.transactions12A[this.args.gasArray[i].GasCode][j][p_type].Year;
                            $scope.calculate_sums();
                        }
                    }
                }
            }

            if (partner_id) {
                var partner = this.get_partner(p_type, partner_id, $scope.instance.FGasesReporting.F8_S12.tr_12A_TradePartners);
                if (partner) {
                    return {
                            'partner': partner.partner,
                            'year': tx_year
                        };
                }
            }
        }

        $scope.get_tx_partner12aA = function (p_type, txid) {
            var partner_id = null;
            var tx_year = null;
            for (var i = 0; i < this.args.gasArray.length; i++) {
                if ($scope.transactions12aA[this.args.gasArray[i].GasCode].length > 0) {
                    for (var j = 0; j < $scope.transactions12aA[this.args.gasArray[i].GasCode].length; j++) {
                        if ($scope.transactions12aA[this.args.gasArray[i].GasCode][j].TransactionID == txid[this.args.gasArray[i].GasCode]) {
                            partner_id = $scope.transactions12aA[this.args.gasArray[i].GasCode][j][p_type].TradePartnerID;
                            tx_year = $scope.transactions12aA[this.args.gasArray[i].GasCode][j][p_type].Year;
                            $scope.calculate_sums();
                        }
                    }
                }
            }

            if (partner_id) {
                var partner = this.get_partner(p_type, partner_id, $scope.instance.FGasesReporting.F8_S12.tr_12aA_TradePartners);
                if (partner) {
                    return {
                        'partner': partner.partner,
                        'year': tx_year
                    };
                }
            }
        }

        $scope.get_tx_partner12B = function (p_type, txid) {
            var partner_id = null;
            var tx_year = null;
            for (var i = 0; i < this.args.gasArray.length; i++) {
                if ($scope.transactions12B[this.args.gasArray[i].GasCode].length > 0) {
                    for (var j = 0; j < $scope.transactions12B[this.args.gasArray[i].GasCode].length; j++) {
                        if ($scope.transactions12B[this.args.gasArray[i].GasCode][j].TransactionID == txid[this.args.gasArray[i].GasCode]) {
                            partner_id = $scope.transactions12B[this.args.gasArray[i].GasCode][j][p_type].TradePartnerID;
                            tx_year = $scope.transactions12B[this.args.gasArray[i].GasCode][j][p_type].Year;
                            $scope.calculate_sums();
                        }
                    }
                }
            }

            if (partner_id) {
                var partner = this.get_partner(p_type, partner_id, $scope.instance.FGasesReporting.F8_S12.tr_12B_TradePartners);
                if (partner) {
                    return {
                        'partner': partner.partner,
                        'year': tx_year
                    };
                }
            }
        }

        $scope.get_tx_partner12aB = function (p_type, txid) {
            var partner_id = null;
            var tx_year = null;
            for (var i = 0; i < this.args.gasArray.length; i++) {
                if ($scope.transactions12aB[this.args.gasArray[i].GasCode].length > 0) {
                    for (var j = 0; j < $scope.transactions12aB[this.args.gasArray[i].GasCode].length; j++) {
                        if ($scope.transactions12aB[this.args.gasArray[i].GasCode][j].TransactionID == txid[this.args.gasArray[i].GasCode]) {
                            partner_id = $scope.transactions12aB[this.args.gasArray[i].GasCode][j][p_type].TradePartnerID;
                            tx_year = $scope.transactions12aB[this.args.gasArray[i].GasCode][j][p_type].Year;
                            $scope.calculate_sums();
                        }
                    }
                }
            }

            if (partner_id) {
                var partner = this.get_partner(p_type, partner_id, $scope.instance.FGasesReporting.F8_S12.tr_12aB_TradePartners);
                if (partner) {
                    return {
                        'partner': partner.partner,
                        'year': tx_year
                    };
                }
            }
        }

        $scope.get_transactions_pairs = function(excl_tx) {
            var gases = this.args.gasArray;
            var pairs = {};
            for (var i = 0; i < gases.length; i++) {
                pairs[gases[i].GasCode] = [];
                for (var j = 0; j < gases[i].tr_12A.Transaction.length; j++) {
                    if (gases[i].tr_12A.Transaction[j].POM.TradePartnerID && gases[i].tr_12A.Transaction[j].Exporter.TradePartnerID) {
                        var pom_partner = $scope.get_partner('POM', gases[i].tr_12A.Transaction[j].POM.TradePartnerID, $scope.instance.FGasesReporting.F8_S12.tr_12A_TradePartners);
                        var exp_partner = $scope.get_partner('Exporter', gases[i].tr_12A.Transaction[j].Exporter.TradePartnerID, $scope.instance.FGasesReporting.F8_S12.tr_12A_TradePartners);
                        if (pom_partner && exp_partner && excl_tx[gases[i].GasCode] !== gases[i].tr_12A.Transaction[j].TransactionID) {
                            pairs[gases[i].GasCode].push(JSON.stringify({
                                'POM': pom_partner.partner.CompanyName,
                                'POMYear': parseInt(gases[i].tr_12A.Transaction[j].POM.Year),
                                'EXP': exp_partner.partner.CompanyName,
                                'EXPYear': parseInt(gases[i].tr_12A.Transaction[j].Exporter.Year)
                                }));
                        }
                    }
                }
            }
            return pairs;
        };

        $scope.get_transactions_pairs_12aA = function (excl_tx) {
            var gases = this.args.gasArray;
            var pairs = {};
            for (var i = 0; i < gases.length; i++) {
                pairs[gases[i].GasCode] = [];
                for (var j = 0; j < gases[i].tr_12aA.Transaction.length; j++) {
                    if (gases[i].tr_12aA.Transaction[j].POM.TradePartnerID && gases[i].tr_12aA.Transaction[j].Exporter.TradePartnerID) {
                        var pom_partner = $scope.get_partner('POM', gases[i].tr_12aA.Transaction[j].POM.TradePartnerID, $scope.instance.FGasesReporting.F8_S12.tr_12aA_TradePartners);
                        var exp_partner = $scope.get_partner('Exporter', gases[i].tr_12aA.Transaction[j].Exporter.TradePartnerID, $scope.instance.FGasesReporting.F8_S12.tr_12aA_TradePartners);
                        if (pom_partner && exp_partner && excl_tx[gases[i].GasCode] !== gases[i].tr_12aA.Transaction[j].TransactionID) {
                            pairs[gases[i].GasCode].push(JSON.stringify({
                                'POM': pom_partner.partner.CompanyName,
                                'POMYear': parseInt(gases[i].tr_12aA.Transaction[j].POM.Year),
                                'EXP': exp_partner.partner.CompanyName,
                                'EXPYear': parseInt(gases[i].tr_12aA.Transaction[j].Exporter.Year)
                            }));
                        }
                    }
                }
            }
            return pairs;
        };

        $scope.get_transactions_pairs_12B = function (excl_tx) {
            var gases = this.args.gasArray;
            var pairs = {};
            for (var i = 0; i < gases.length; i++) {
                pairs[gases[i].GasCode] = [];
                for (var j = 0; j < gases[i].tr_12B.Transaction.length; j++) {
                    if (gases[i].tr_12B.Transaction[j].POM.TradePartnerID && gases[i].tr_12B.Transaction[j].Exporter.TradePartnerID) {
                        var pom_partner = $scope.get_partner('POM', gases[i].tr_12B.Transaction[j].POM.TradePartnerID, $scope.instance.FGasesReporting.F8_S12.tr_12B_TradePartners);
                        var exp_partner = $scope.get_partner('Exporter', gases[i].tr_12B.Transaction[j].Exporter.TradePartnerID, $scope.instance.FGasesReporting.F8_S12.tr_12B_TradePartners);
                        if (pom_partner && exp_partner && excl_tx[gases[i].GasCode] !== gases[i].tr_12B.Transaction[j].TransactionID) {
                            pairs[gases[i].GasCode].push(JSON.stringify({
                                'POM': pom_partner.partner.CompanyName,
                                'POMYear': parseInt(gases[i].tr_12B.Transaction[j].POM.Year),
                                'EXP': exp_partner.partner.CompanyName,
                                'EXPYear': parseInt(gases[i].tr_12B.Transaction[j].Exporter.Year)
                            }));
                        }
                    }
                }
            }
            return pairs;
        };

        $scope.get_transactions_pairs_12aB = function (excl_tx) {
            var gases = this.args.gasArray;
            var pairs = {};
            for (var i = 0; i < gases.length; i++) {
                pairs[gases[i].GasCode] = [];
                for (var j = 0; j < gases[i].tr_12aB.Transaction.length; j++) {
                    if (gases[i].tr_12aB.Transaction[j].POM.TradePartnerID && gases[i].tr_12aB.Transaction[j].Exporter.TradePartnerID) {
                        var pom_partner = $scope.get_partner('POM', gases[i].tr_12aB.Transaction[j].POM.TradePartnerID, $scope.instance.FGasesReporting.F8_S12.tr_12aB_TradePartners);
                        var exp_partner = $scope.get_partner('Exporter', gases[i].tr_12aB.Transaction[j].Exporter.TradePartnerID, $scope.instance.FGasesReporting.F8_S12.tr_12aB_TradePartners);
                        if (pom_partner && exp_partner && excl_tx[gases[i].GasCode] !== gases[i].tr_12aB.Transaction[j].TransactionID) {
                            pairs[gases[i].GasCode].push(JSON.stringify({
                                'POM': pom_partner.partner.CompanyName,
                                'POMYear': parseInt(gases[i].tr_12aB.Transaction[j].POM.Year),
                                'EXP': exp_partner.partner.CompanyName,
                                'EXPYear': parseInt(gases[i].tr_12aB.Transaction[j].Exporter.Year)
                            }));
                        }
                    }
                }
            }
            return pairs;
        };

        $scope.calculate_sums = function() {
            for (var i = 0; i < this.args.gasArray.length; i++) {
                // SUM 12A
                var sum_12A = 0;
                txs_12A = this.args.gasArray[i].tr_12A.Transaction;
                this.args.gasArray[i].tr_12A.Unit = 'metrictonnes';
                for (var j = 0; j < txs_12A.length; j++) {
                    if (isEmpty(txs_12A[j].Amount) || isNaN(txs_12A[j].Amount)) {
                        txs_12A[j].Comment = null;
                    }
                    var val = (isEmpty(txs_12A[j].Amount) || isNaN(txs_12A[j].Amount)) ? 0.0 : parseFloat(txs_12A[j].Amount);
                    sum_12A += val;
                }
                this.args.gasArray[i].tr_12A.SumOfPartnersAmount = parseFloat(sum_12A).toFixed(3);

                // SUM 12aA
                var sum_12aA = 0;
                txs_12aA = this.args.gasArray[i].tr_12aA.Transaction;
                this.args.gasArray[i].tr_12aA.Unit = 'metrictonnes';
                for (var j = 0; j < txs_12aA.length; j++) {
                    if (isEmpty(txs_12aA[j].Amount) || isNaN(txs_12aA[j].Amount)) {
                        txs_12aA[j].Comment = null;
                    }
                    var val = (isEmpty(txs_12aA[j].Amount) || isNaN(txs_12aA[j].Amount)) ? 0.0 : parseFloat(txs_12aA[j].Amount);
                    sum_12aA += val;
                }
                this.args.gasArray[i].tr_12aA.SumOfPartnersAmount = parseFloat(sum_12aA).toFixed(3);

                var tr_12bA_val = this.args.gasArray[i].Totals.tr_12bA;
                var tr_12cA_val = parseFloat(tr_12bA_val - sum_12A - sum_12aA).toFixed(3);
                this.args.gasArray[i].Totals.tr_12cA = tr_12cA_val;

                // SUM 12B
                var sum_12B = 0;
                txs_12B = this.args.gasArray[i].tr_12B.Transaction;
                this.args.gasArray[i].tr_12B.Unit = 'metrictonnes';
                for (var j = 0; j < txs_12B.length; j++) {
                    if (isEmpty(txs_12B[j].Amount) || isNaN(txs_12B[j].Amount)) {
                        txs_12B[j].Comment = null;
                    }
                    var val = (isEmpty(txs_12B[j].Amount) || isNaN(txs_12B[j].Amount)) ? 0.0 : parseFloat(txs_12B[j].Amount);
                    sum_12B += val;
                }
                this.args.gasArray[i].tr_12B.SumOfPartnersAmount = parseFloat(sum_12B).toFixed(3);

                // SUM 12aB
                var sum_12aB = 0;
                txs_12aB = this.args.gasArray[i].tr_12aB.Transaction;
                this.args.gasArray[i].tr_12aB.Unit = 'metrictonnes';
                for (var j = 0; j < txs_12aB.length; j++) {
                    if (isEmpty(txs_12aB[j].Amount) || isNaN(txs_12aB[j].Amount)) {
                        txs_12aB[j].Comment = null;
                    }
                    var val = (isEmpty(txs_12aB[j].Amount) || isNaN(txs_12aB[j].Amount)) ? 0.0 : parseFloat(txs_12aB[j].Amount);
                    sum_12aB += val;
                }
                this.args.gasArray[i].tr_12aB.SumOfPartnersAmount = parseFloat(sum_12aB).toFixed(3);

                // SUM 12cB
                var tr_12bB_val = this.args.gasArray[i].Totals.tr_12bB;
                var tr_12cB_val = parseFloat(tr_12bB_val - sum_12B - sum_12aB).toFixed(3);
                this.args.gasArray[i].Totals.tr_12cB = tr_12cB_val;

                // SUM 12C
                var tr_12Ca_val = this.args.gasArray[i].Totals.tr_12Ca;
                var tr_12c_val = parseFloat(tr_12Ca_val - sum_12A - sum_12aA - sum_12B - sum_12aB).toFixed(3);
                this.args.gasArray[i].Totals.tr_12C = tr_12c_val;

            }
        }

        $scope.add_transaction = function() {
            var tx;
            var txid = 'transaction_' + Date.now();
            for (var i = 0; i < this.args.gasArray.length; i++) {
                this.transactions12A[this.args.gasArray[i].GasCode] = this.args.gasArray[i].tr_12A.Transaction;
                tx = clone(this.emptyTransaction);
                tx.TransactionID = txid;
                var index = this.transactions12A[this.args.gasArray[i].GasCode].push(tx) - 1;
                if (!this.txids[index]) {
                    this.txids[index] = {};
                }
                var txinfo = this.txids[index];
                txinfo[this.args.gasArray[i].GasCode] = txid;
            }
        }

        $scope.remove_transaction = function(transaction) {
            var txid;
            for (var i = 0; i < this.args.gasArray.length; i++) {
                if (this.transactions12A[this.args.gasArray[i].GasCode].length > 0){
                    for (var j = 0; j < this.transactions12A[this.args.gasArray[i].GasCode].length; j++) {
                        if (this.transactions12A[this.args.gasArray[i].GasCode][j].TransactionID == transaction[this.args.gasArray[i].GasCode]) {
                            txid = j;
                        }
                    }
                    if (txid !== undefined) {
                        this.transactions12A[this.args.gasArray[i].GasCode].splice(txid, 1);
                    }
                }
            }
            // Delete the tx from txids
            this.$parent.txids = this.$parent.txids.filter(function(item) { 
                return item !== transaction;
            });
            // Re-Calculate SumOfPartnersAmount
            this.$parent.calculate_sums();
        }

        $scope.add_transaction_12aA = function () {
            var tx;
            var txid = 'transaction_' + Date.now();
            for (var i = 0; i < this.args.gasArray.length; i++) {
                this.transactions12aA[this.args.gasArray[i].GasCode] = this.args.gasArray[i].tr_12aA.Transaction;
                tx = clone(this.emptyTransaction);
                tx.TransactionID = txid;
                var index = this.transactions12aA[this.args.gasArray[i].GasCode].push(tx) - 1;
                if (!this.txids_12aA[index]) {
                    this.txids_12aA[index] = {};
                }
                var txinfo = this.txids_12aA[index];
                txinfo[this.args.gasArray[i].GasCode] = txid;
            }
        }

        $scope.remove_transaction_12aA = function (transaction) {
            var txid;
            for (var i = 0; i < this.args.gasArray.length; i++) {
                if (this.transactions12aA[this.args.gasArray[i].GasCode].length > 0) {
                    for (var j = 0; j < this.transactions12aA[this.args.gasArray[i].GasCode].length; j++) {
                        if (this.transactions12aA[this.args.gasArray[i].GasCode][j].TransactionID == transaction[this.args.gasArray[i].GasCode]) {
                            txid = j;
                        }
                    }
                    if (txid !== undefined) {
                        this.transactions12aA[this.args.gasArray[i].GasCode].splice(txid, 1);
                    }
                }
            }
            // Delete the tx from txids
            this.$parent.txids_12aA = this.$parent.txids_12aA.filter(function (item) {
                return item !== transaction;
            });
            // Re-Calculate SumOfPartnersAmount
            this.$parent.calculate_sums();
        }


        $scope.add_transaction_12B = function () {
            var tx;
            var txid = 'transaction_' + Date.now();
            for (var i = 0; i < this.args.gasArray.length; i++) {
                this.transactions12B[this.args.gasArray[i].GasCode] = this.args.gasArray[i].tr_12B.Transaction;
                tx = clone(this.emptyTransaction);
                tx.TransactionID = txid;
                var index = this.transactions12B[this.args.gasArray[i].GasCode].push(tx) - 1;
                if (!this.txids_12B[index]) {
                    this.txids_12B[index] = {};
                }
                var txinfo = this.txids_12B[index];
                txinfo[this.args.gasArray[i].GasCode] = txid;
            }
        }

        $scope.remove_transaction_12B = function (transaction) {
            var txid;
            for (var i = 0; i < this.args.gasArray.length; i++) {
                if (this.transactions12B[this.args.gasArray[i].GasCode].length > 0) {
                    for (var j = 0; j < this.transactions12B[this.args.gasArray[i].GasCode].length; j++) {
                        if (this.transactions12B[this.args.gasArray[i].GasCode][j].TransactionID == transaction[this.args.gasArray[i].GasCode]) {
                            txid = j;
                        }
                    }
                    if (txid !== undefined) {
                        this.transactions12B[this.args.gasArray[i].GasCode].splice(txid, 1);
                    }
                }
            }
            // Delete the tx from txids
            this.$parent.txids_12B = this.$parent.txids_12B.filter(function (item) {
                return item !== transaction;
            });
            // Re-Calculate SumOfPartnersAmount
            this.$parent.calculate_sums();
        }

        $scope.add_transaction_12aB = function () {
            var tx;
            var txid = 'transaction_' + Date.now();
            for (var i = 0; i < this.args.gasArray.length; i++) {
                this.transactions12aB[this.args.gasArray[i].GasCode] = this.args.gasArray[i].tr_12aB.Transaction;
                tx = clone(this.emptyTransaction);
                tx.TransactionID = txid;
                var index = this.transactions12aB[this.args.gasArray[i].GasCode].push(tx) - 1;
                if (!this.txids_12aB[index]) {
                    this.txids_12aB[index] = {};
                }
                var txinfo = this.txids_12aB[index];
                txinfo[this.args.gasArray[i].GasCode] = txid;
            }
        }

        $scope.remove_transaction_12aB = function (transaction) {
            var txid;
            for (var i = 0; i < this.args.gasArray.length; i++) {
                if (this.transactions12aB[this.args.gasArray[i].GasCode].length > 0) {
                    for (var j = 0; j < this.transactions12aB[this.args.gasArray[i].GasCode].length; j++) {
                        if (this.transactions12aB[this.args.gasArray[i].GasCode][j].TransactionID == transaction[this.args.gasArray[i].GasCode]) {
                            txid = j;
                        }
                    }
                    if (txid !== undefined) {
                        this.transactions12aB[this.args.gasArray[i].GasCode].splice(txid, 1);
                    }
                }
            }
            // Delete the tx from txids
            this.$parent.txids_12aB = this.$parent.txids_12aB.filter(function (item) {
                return item !== transaction;
            });
            // Re-Calculate SumOfPartnersAmount
            this.$parent.calculate_sums();
        }

    });
})();
