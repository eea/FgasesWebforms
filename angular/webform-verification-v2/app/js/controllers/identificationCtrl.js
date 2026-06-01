(function() {

    angular.module('FGases.controllers').controller('IdentificationCtrl', function($rootScope, $scope) {
        $scope.onlyNumbers = /\d+\.?\d*/;
        $scope.emptyTransaction;
        $scope.showLegalRepresentative = false;
        if ($scope.instance.Verification.GeneralReportData.Company.Country.Type != "EU_TYPE")
        $scope.showLegalRepresentative =true;
        
        $scope.DataReportUrl = $scope.instance.Verification.VerificationScope.DataReportUrl;
        $scope.DateReport = $scope.instance.Verification.VerificationScope.SubmissionDate;
        $scope.TransactionYear = $scope.instance.Verification.VerificationScope.TransactionYear;
        $scope.CompanyID = $scope.instance.Verification.GeneralReportData.Company.CompanyId;
        $scope.CompanyName = $scope.instance.Verification.GeneralReportData.Company.CompanyName;
        $scope.CompanyCountry = $scope.instance.Verification.GeneralReportData.Company.Country.Name;

        $scope.EuLegalRepresentativeName = $scope.instance.Verification.GeneralReportData.EuLegalRepresentativeCompany.Name;        
        $scope.EuLegalRepresentativeCountry = $scope.instance.Verification.GeneralReportData.EuLegalRepresentativeCompany.Country.Name;


    });
})();