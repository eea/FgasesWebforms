
(function() {
    angular.module('FGases.viewmodel').factory('viewModel', [

        'ViewModelObjectBase', 'ViewModelActivities', 'ViewModelIdentificationCtrl', 'ViewModelBulkHFCsVerification',
        'ViewModelSubmission', 'objectUtil', 'arrayUtil',

        function (ViewModelObjectBase, ViewModelActivities, ViewModelIdentificationCtrl, ViewModelBulkHFCsVerification,
                    ViewModelSubmission, objectUtil, arrayUtil) {

            function ViewModel() {
                ViewModelObjectBase.call(this, null);
                this.sheetActivities = new ViewModelActivities(this);
                this.identificationReport = new ViewModelIdentificationCtrl(this);
                this.bulkHFCsVerification = new ViewModelBulkHFCsVerification(this);
               
                this.submission = new ViewModelSubmission(this);
                this._stocks = [];
                this._stocksSuccessfullyRetrieved = false;
                this._nerStatusSuccessfullyRetrieved = false;
                this._companySizeSuccessfullyRetrieved = false;
            }

            objectUtil.chainConstructor(ViewModelObjectBase, ViewModel);

            ViewModel.prototype.getDataSource = function() {
                return this._instance;
            };

            ViewModel.prototype.setDataSource = function(instance) {
                this._instance = instance;
            };

            ViewModel.prototype.getReportedGases = function() {
                return this.getDataSource().FGasesReporting.ReportedGases;
            };

            ViewModel.prototype.getReportedGasById = function(gasId) {
                return arrayUtil.selectSingle(this.getReportedGases(), function(reportedGas) {
                    return reportedGas.GasId === gasId;
                });
            };

            ViewModel.prototype.isReporterInNerList = function() {
                return this._existsInNerList;
            };

            ViewModel.prototype.setReporterInNerList = function(isInNerList) {
                this._existsInNerList = isInNerList;
                this._nerStatusSuccessfullyRetrieved = true;
            };

            ViewModel.prototype.isNerStatusDefined = function() {
                return this._nerStatusSuccessfullyRetrieved;
            };

            ViewModel.prototype.isLargeCompany = function() {
                return this._largeCompany;
            };

            ViewModel.prototype.setLargeCompany = function(value) {
                this._largeCompany = value;
                this._companySizeSuccessfullyRetrieved = true;
            };

            ViewModel.prototype.isCompanySizeInfoDefined = function() {
                return this._companySizeSuccessfullyRetrieved;
            };

            ViewModel.prototype.initCompanyStocks = function(stocks) {
                this._stocks = [];
                arrayUtil.pushMany(this._stocks, stocks);
                this._stocksSuccessfullyRetrieved = true;
            };

            ViewModel.prototype.isStocksInfoDefined = function() {
                return this._stocksSuccessfullyRetrieved;
            };

            ViewModel.prototype.initCompanyQuota = function(quota) {
                this._quota = {
                    allocatedQuota: quota.allocatedQuota,
                    availableQuota: quota.availableQuota
                };
            };

            ViewModel.prototype.isQuotaInfoDefined = function() {
                return !objectUtil.isNull(this._quota);
            };

            ViewModel.prototype.initCodeLists = function(codeLists) {
                this._codeLists = codeLists;
            };

            ViewModel.prototype.getCompanyStocks = function() {
                return this._stocks;
            };

            ViewModel.prototype.getGasStocksByTransaction = function(transactionCode) {
                return arrayUtil.select(this._stocks, function(stock) {
                    return stock.transactionCode === transactionCode;
                });
            };

            ViewModel.prototype.getGasStockByTransaction = function(transactionCode, gasId) {
                return arrayUtil.selectSingle(this._stocks, function(stock) {
                    return stock.transactionCode === transactionCode && Number(stock.gasId) === gasId;
                });
            };

            ViewModel.prototype.getAvailableGases = function() {
                return this._codeLists.FGasesCodelists.FGases.Gas;
            };

            return new ViewModel();
        }
    ]);
})();
