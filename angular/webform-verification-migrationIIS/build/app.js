
(function() {
    angular.module('FGases.services.util', []);
    angular.module('FGases.helper', []);
    angular.module('FGases.services.data', [
        'FGases.services.util'
    ]);
    angular.module('FGases.services.ui', [
        'FGases.services.util',
        'ui.bootstrap'
    ]);
    angular.module('FGases.services.validation', [
        'FGases.services.util'
    ]);
    angular.module('FGases.services.validation.qcs', [
        'FGases.services.util',
        'FGases.helper',
        'pascalprecht.translate'
    ]);

    angular.module('FGases.filters', [
        'FGases.services.util'
    ]);

    angular.module('FGases.viewmodel', [
        'FGases.services.util',
        'FGases.services.data',
        'FGases.services.validation.qcs',
        'FGases.helper'
    ]);

    angular.module('FGases.controllers', [
        'FGases.services.util',
        'FGases.services.ui',
        'FGases.viewmodel',
        'ui.bootstrap',
        'pascalprecht.translate'
    ]);

    angular.module('FGases.directives', [
        'FGases.services.util',
        'FGases.services.validation',
        'FGases.services.ui',
        'pascalprecht.translate'
    ]);

    var app = angular.module('FGases', [
        'FGases.filters',
        'FGases.directives',
        'FGases.controllers',
        'FGases.services.data',
        'FGases.services.validation.qcs',
        'FGases.services.ui',
        'ui.bootstrap',
        'ngAnimate',
        'ajoslin.promise-tracker',
        'navigation.navigationBlocker',
        'translate.languageChanger',
        'ui.multiselect',
        'tabs.formTabs',
        'ui.errorMapper',
        'monospaced.elastic',
        'notifications',
        'angularFileUpload']);

    app.run(function($rootScope, promiseTracker, $location, tabService, errorMapperService) {
        $rootScope.loadingTracker = promiseTracker({});
        tabService.setTabs([
            {"id": "Intro",                 "active": true},
            {"id": "CompanyInfo",           "active": false},
            {"id": "ReportIdentification",  "active": false},
            {"id": "BulkHFCsVerification",  "active": false},
            {"id": "EquipmentVerification", "active": false},            
            {"id": "Submission",            "active": false}
        ]);
        //, {"id":"Debug",            "active" : false}

        errorMapperService.addErrorMapping("total100", "Sum of the amounts reported here must be 100");
    });

    // app constanst are defined here
    app.constant('FormConstants', {
        // set defaults
        "HFCsGasGroupId": 1,
        "PFCsGasGroupId": 2,
        "SF6GasGroupId": 14,
        "InhalationGasGroupId": 15,
        "NF3GasGroupId": 16,
        "UnsaturatedHFCsHCFCGasGroupId": 3,
        "FluorinatedEthersAlcoholsGasGroupId": 4,
        "OtherPrefluorinatedCompoundsGasGroupId": 17,
        "NonFluorinatedRefrigerantsGasGroupId": [6, 12],
        "NonFGasesGroupId": 6,
        "CommonlyUsedMixturesGasGroupId": [7, 9],
        "AlphaNumericAndSpaceRegEx": /^\d*[a-zA-Z][a-zA-Z0-9 ,_\.\(\)\-]*$/,
        "StartingAlphaNumeric":      /^[a-zA-Z0-9].+$/,
        "CommentsRegEx":             /.*[a-zA-Z]+.*/,
        "CommentLimit": 15,
        "StartingYear": 2014,
        "PivotYear": 2017,
        "ToBeConfirmedGasesIds": [6, 8, 143],
        "ToBeConfirmedGasesCodes": ['HFC-134', 'HFC-143', 'HFC-152'],
        "ToBeConfirmedGasesCodesA": ['HFC-134a', 'HFC-143a', 'HFC-152a'],
        "UnspecifiedGasMixId": 187,
        OtherComponentId: 128,
        "Gas1A_fs1": "HFC-23",
        "TabIds": [
            "Intro",
            "CompanyInfo",
            "ReportIdentification",
            "BulkHFCsVerification",
            "EquipmentVerification",
            "Submission"
            
        ]
    });// end of constant definitions

    app.config(function(languageChangerProvider) {
        languageChangerProvider.setDefaultLanguage('en');
        languageChangerProvider.setLanguageFilePrefix('fgases-labels-verification-2025-');
        languageChangerProvider.setAvailableLanguages({ "item" :[{
            "code": "bg",
            "label": "Български (bg)"}, {
            "code": "es",
                "label": "Español (es)"}, {
            "code": "cs",
                "label": "Čeština (cs)"}, {
            "code": "da",
                "label": "Dansk (da)"}, {
            "code": "de",
                "label": "Deutsch (de)"}, {
            "code": "et",
                "label": "Eesti (et)"}, {
            "code": "el",
                "label": "ελληνικά (el)"}, {
            "code": "en",
                "label": "English (en)"}, {
            "code": "fr",
                "label": "Français (fr)"}, {
            "code": "hr",
                "label": "Hrvatski (hr)"}, {
            "code": "it",
                "label": "Italiano (it)"}, {
            "code": "lv",
                "label": "Latviešu valoda (lv)"}, {
            "code": "lt",
                "label": "Lietuvių kalba (lt)"}, {
            "code": "hu",
                "label": "Magyar (hu)"}, {
            "code": "hr",
                "label": "Hrvatski (hr)"}, {
            "code": "mt",
                "label": "Malti (mt)"}, {
            "code": "nl",
                "label": "Nederlands (nl)"}, {
            "code": "pl",
                "label": "Polski (pl)"}, {
            "code": "pt",
                "label": "Português (pt)"}, {
            "code": "ro",
                "label": "Română (ro)"}, {
            "code": "sk",
                "label": "Slovenčina (sk)"}, {
            "code": "sl",
                "label": "Slovenščina (sl)"}, {
            "code": "fi",
                "label": "Suomi (fi)"}, {
            "code": "sv",
                "label": "Svenska (sv)"}] });
    });
})();

// Window globals

// request parameters
var baseUri = getParameterByName('base_uri');
var fileId = getParameterByName('fileId');
var companyId = getParameterByName('companyId');
var envelope = getParameterByName('envelope');
var sessionId = getParameterByName('sessionid');
var testCompanyId = getParameterByName('testCompanyId');
var testAuditorId = getParameterByName('testAuditorId');
var isTestSession = false;

// if companyId parameter is missing, then run the form in test mode.
// it is possible to set test company id with testCopmanyId parameter
if (!sessionId) {
    isTestSession = true;
}

var DD_VOCABULARY_BASE_URI = "http://test.tripledev.ee/datadict/vocabulary/";

function isEmpty(value){
    return (!value || value == null || value.length === 0);
}

function getStringValue(object, property) {
    if (object.hasOwnProperty(property)) {
        return "";
    }
    else if (isEmpty(object[property])) {
        return "";
    }
    else{
        return object[property];
    }
}

/**
 * Utility function to calculate weighted GWP
 * @param componentsForGWP
 * @returns {*}
 */
function getWeightedGWP(componentsForGWP){
    var copyOfGasComponentsForGWP = clone(componentsForGWP);
    if (!(copyOfGasComponentsForGWP instanceof Array)){
        copyOfGasComponentsForGWP = [copyOfGasComponentsForGWP];
    }

    var weightedGwp = 0;
    var percentageTotal = 0;
    for (var l = 0; l < copyOfGasComponentsForGWP.length; l++){
        //then component should have values for percentage and
        if (copyOfGasComponentsForGWP[l].GWP_AR4_AnnexIV){
            weightedGwp += parseFloat(copyOfGasComponentsForGWP[l].Percentage) * parseFloat(copyOfGasComponentsForGWP[l].GWP_AR4_AnnexIV);
        }
        percentageTotal += parseFloat(copyOfGasComponentsForGWP[l].Percentage);
    }

    if (percentageTotal > 0){
        return weightedGwp / percentageTotal;
    }

    return null;
}// end of function getWeightedGWP

/**
 * Utility function to calculate weighted HFC GWP
 * @param componentsForGWP
 * @returns {*}
 */
function getWeightedHFCGWP(componentsForGWP){
    var copyOfGasComponentsForGWP = clone(componentsForGWP);
    if (!(copyOfGasComponentsForGWP instanceof Array)){
        copyOfGasComponentsForGWP = [copyOfGasComponentsForGWP];
    }

    var weightedGwp = 0;
    var percentageTotal = 0;
    for (var l = 0; l < copyOfGasComponentsForGWP.length; l++){
        //then component should have values for percentage and
        if (copyOfGasComponentsForGWP[l].GWP_AR4_HFC){
            weightedGwp += parseFloat(copyOfGasComponentsForGWP[l].Percentage) * parseFloat(copyOfGasComponentsForGWP[l].GWP_AR4_HFC);
        }
        percentageTotal += parseFloat(copyOfGasComponentsForGWP[l].Percentage);
    }

    if (percentageTotal > 0){
        return weightedGwp / percentageTotal;
    }

    return null;
}// end of function getWeightedHFCGWP

function getWeightedFullHfcGwp(components) {
    var gwpComponents = components instanceof Array ? components : [ components ];

    for (var i = 0; i < gwpComponents.length; i++) {
        // if gas is HFC or contains at least one HFC
        if (gwpComponents[i].GWP_AR4_HFC) {
            return getWeightedGWP(components);
        }
    }

    return 0;
}

/**
 * Utility function to check if gas or component is HFC or containing HFC.
 * In current implementation, this is determined based on HFC GWP field.
 *
 * @param componentOrGas component or gas
 */
function containsHFCUtilFn(componentOrGas){
    //if GWP_AR4_HFC field is defined and it is value is greater than 0 then it is an HFC.
    if (componentOrGas && typeof componentOrGas.GWP_AR4_HFC !== 'undefined' && componentOrGas.GWP_AR4_HFC && Number(componentOrGas.GWP_AR4_HFC) > 0){
       return true;
    }
    return false;
}// end of function containsHFCUtilFn

function isPreblendedPolyols(componentOrGas) {
    if ((componentOrGas == 17) || (componentOrGas == 16) || (componentOrGas == 146) || (componentOrGas == 148) || (componentOrGas == 200) || (componentOrGas == 191) || (componentOrGas == 70)) {
        return true;
    } else return false;
}

function getWebQUrl(path){
    var url = baseUri + path;
    url += "?fileId=" + fileId;
    if (sessionId && sessionId != null) {
        url += "&sessionid=" + sessionId;
    }
    return url;
}
// helper function for getting query string parameter values. AngularJS solution $location.search() doesn't work in IE8.
function getParameterByName(name) {
    var searchArr = window.location.search.split('?');
    var search = '?' + searchArr[searchArr.length - 1];
    var match = new RegExp('[?&]' + name + '=([^&]*)').exec(search);
    return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
};
function getDomain(url) {
    return url.split("/").slice(0,3).join("/");
}

(function() {

    angular.module('FGases.controllers').controller('BulkHFCsVerificationCtrl', function($rootScope, $scope, modalAdapter) {
        // Functions
        $scope.onConfirmation_a_Changed = function(confirmation_row) {
            $scope._clean_confirmation(confirmation_row.confirmation_b);
            $scope._clean_confirmation(confirmation_row.confirmation_c);
        };
        $scope.onConfirmation_b_Changed = function(translation_prefix, confirmation_row) {
            $scope._clean_confirmation(confirmation_row.confirmation_a);
            $scope._clean_confirmation(confirmation_row.confirmation_c);

            if (confirmation_row.confirmation_b.checked) {
                confirmation_row.confirmation_b.checked = false;
                modalAdapter.open($scope, 'lg', 'hfcs-verification-confirmation.html', 'HFCSCofirmationModalController',
                    {
                        "translation_prefix": translation_prefix,
                        "option": "b",
                        "confirmation": confirmation_row.confirmation_b,
                    },
                );
            }
        };
        $scope.onConfirmation_c_Changed = function(translation_prefix, confirmation_row) {
            $scope._clean_confirmation(confirmation_row.confirmation_a);
            $scope._clean_confirmation(confirmation_row.confirmation_b);

            if (confirmation_row.confirmation_c.checked) {
                confirmation_row.confirmation_c.checked = false;
                modalAdapter.open($scope, 'lg', 'hfcs-verification-confirmation.html', 'HFCSCofirmationModalController',
                    {
                        "translation_prefix": translation_prefix,
                        "option": "c",
                        "confirmation": confirmation_row.confirmation_c,
                    },
                );
            }
        }
    });
})();
(function() {

    angular.module('FGases.controllers').controller('EquipmentVerificationCtrl', function($rootScope, $scope, modalAdapter, $notification) {
        // Functions
        $scope._check_section_II_4_comments = function(transaction_id) {
            // Part 1
            if (transaction_id == 'tr_13D') {
                let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
                if (!$scope.conditionEquipmentPart1Op1()) {
                    if (!isEmpty(section4.option_a.reason_1)) {
                        $notification.warning("", "Due to transaction 13D verification, the comment for Option 1 in Part 1 in Section II-4 was reverted.");
                        section4.option_a.reason_1 = '';
                    }
                }
                if (!$scope.conditionEquipmentPart1Op2()) {
                    if (!isEmpty(section4.option_a.reason_2)) {
                        $notification.warning("", "Due to transaction 13D verification, the comment for Option 2 in Part 1 in Section II-4 was reverted.");
                        section4.option_a.reason_2 = '';
                    }
                }
                if (!$scope.conditionEquipmentPart1Op3()) {
                    if (!isEmpty(section4.option_a.reason_3)) {
                        $notification.warning("", "Due to transaction 13D verification, the comment for Option 3 in Part 1 in Section II-4 was reverted.");
                        section4.option_a.reason_3 = '';
                    }
                }
            }
            // Part 2
            if ((transaction_id == 'tr_12A') || (transaction_id == 'tr_12B')) {
                let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
                if (!$scope.conditionEquipmentPart2Op1()) {
                    if (!isEmpty(section4.option_b.reason_1)) {
                        $notification.warning("", `Due to transaction ${transaction_id.substr(3)} verification, the comment for Option 1 in Part 2 in Section II-4 was reverted.`);
                        section4.option_b.reason_1 = '';
                    }
                }
                if (!$scope.conditionEquipmentPart2Op2()) {
                    if (!isEmpty(section4.option_b.reason_2)) {
                        $notification.warning("", `Due to transaction ${transaction_id.substr(3)} verification, the comment for Option 2 in Part 3 in Section II-4 was reverted.`);
                        section4.option_b.reason_2 = '';
                    }
                }
                if (!$scope.conditionEquipmentPart2Op3()) {
                    if (!isEmpty(section4.option_b.reason_3)) {
                        $notification.warning("", `Due to transaction ${transaction_id.substr(3)} verification, the comment for Option 3 in Part 3 in Section II-4 was reverted.`);
                        section4.option_b.reason_3 = '';
                    }
                }
            }
            // Part 3
            if ((transaction_id == 'tr_12aA') || (transaction_id == 'tr_12aB')) {
                let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
                if (!$scope.conditionEquipmentPart3Op1()) {
                    if (!isEmpty(section4.option_c.reason_1)) {
                        $notification.warning("", `Due to transaction ${transaction_id.substr(3)} verification, the comment for Option 1 in Part 3 in Section II-4 was reverted.`);
                        section4.option_c.reason_1 = '';
                    }
                }
                if (!$scope.conditionEquipmentPart3Op2()) {
                    if (!isEmpty(section4.option_c.reason_2)) {
                        $notification.warning("", `Due to transaction ${transaction_id.substr(3)} verification, the comment for Option 2 in Part 3 in Section II-4 was reverted.`);
                        section4.option_c.reason_2 = '';
                    }
                }
                if (!$scope.conditionEquipmentPart3Op3()) {
                    if (!isEmpty(section4.option_c.reason_3)) {
                        $notification.warning("", `Due to transaction ${transaction_id.substr(3)} verification, the comment for Option 3 in Part 3 in Section II-4 was reverted.`);
                        section4.option_c.reason_3 = '';
                    }
                }
            }
        }
        $scope.onConfirmation_a_Changed = function(confirmation_row, transaction_id) {
            $scope._clean_confirmation(confirmation_row.confirmation_b);
            $scope._clean_confirmation(confirmation_row.confirmation_c);
            $scope._check_section_II_4_comments(transaction_id);
        };
        $scope.onConfirmation_b_Changed = function(translation_prefix, confirmation_row, transaction_id) {
            $scope._clean_confirmation(confirmation_row.confirmation_a);
            $scope._clean_confirmation(confirmation_row.confirmation_c);

            if (confirmation_row.confirmation_b.checked) {
                confirmation_row.confirmation_b.checked = false;
                modalAdapter.open($scope, 'lg', 'hfcs-verification-confirmation.html', 'HFCSCofirmationModalController',
                    {
                        "translation_prefix": translation_prefix,
                        "option": "b",
                        "transaction_id": transaction_id,
                        "confirmation": confirmation_row.confirmation_b,
                    },
                    () => $scope._check_section_II_4_comments(transaction_id),
                );
            }
        };
        $scope.onConfirmation_c_Changed = function (translation_prefix, confirmation_row, transaction_id) {
            $scope._clean_confirmation(confirmation_row.confirmation_a);
            $scope._clean_confirmation(confirmation_row.confirmation_b);

            if (confirmation_row.confirmation_c.checked) {
                confirmation_row.confirmation_c.checked = false;
                modalAdapter.open($scope, 'lg', 'hfcs-verification-confirmation.html', 'HFCSCofirmationModalController',
                    {
                        "translation_prefix": translation_prefix,
                        "option": "c",
                        "transaction_id": transaction_id,
                        "confirmation": confirmation_row.confirmation_c,
                    },
                    () => $scope._check_section_II_4_comments(transaction_id),
                );
            }
        };

        $scope.removeComments = function (option, reason) {
            if (option == "option_a") {
                switch (reason) {
                    case 'reason_1':
                       
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_2 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_3 = '';
                        break;
                    case 'reason_2':
                        
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_3 = '';
                        break;
                    case 'reason_3':
                       
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_2 = '';
                        break;
                    default:
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_2 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_a.reason_3 = '';
                }
            } else if (option == "option_b") {
                switch (reason) {
                    case 'reason_1':
                       
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_b.reason_2 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_b.reason_3 = '';
                        break;
                    case 'reason_2':
                       
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_b.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_b.reason_3 = '';
                        break;
                    case 'reason_3':
                       
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_b.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_b.reason_2 = '';
                        break;
                  
                }
            }
            else if (option == "option_c") {
                switch (reason) {
                    case 'reason_1':

                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_c.reason_2 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_c.reason_3 = '';
                        break;
                    case 'reason_2':

                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_c.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_c.reason_3 = '';
                        break;
                    case 'reason_3':

                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_c.reason_1 = '';
                        $scope.instance.Verification.EquipmentHFCs.section_II_4.option_c.reason_2 = '';
                        break;

                }
            }
            
        }

        $scope.conditionEquipmentPart1Op1 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_13D = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
            let tr_13D_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_13D'];
            if (section4.option_a.option == '1') {
                if (parseFloat(tr_13D.tco2e) == 0 || tr_13D_confirmation.confirmation_c.checked) {
                    return true;
                }
            }
            return false;
        }
        $scope.conditionEquipmentPart1Op2 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_13D = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
            if (section4.option_a.option == '2') {
                if (parseFloat(tr_13D.tco2e) <= 0) {
                    return true;
                }
            }
            return false;
        }
        $scope.conditionEquipmentPart1Op3 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_13D = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
            let tr_13D_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_13D'];
            if (section4.option_a.option == '3') {
                if (parseFloat(tr_13D.tco2e) > 0 && (tr_13D_confirmation.confirmation_a.checked || tr_13D_confirmation.confirmation_b.checked)) {
                    return true;
                }
            }
            return false;
        }

        $scope.conditionEquipmentPart2Op1 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_12A = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
            let tr_12B = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];
            let tr_12A_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];
            let tr_12B_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12B'];
            if ($scope.instance.Verification.VerificationScope.Equipment) {
                if (section4.option_b.option == "1") {
                    if ((parseFloat(tr_12A.tco2e) == 0 && parseFloat(tr_12B.tco2e) == 0) || (tr_12A_confirmation.confirmation_c.checked || tr_12B_confirmation.confirmation_c.checked)) {
                        return true;
                    }
                    else return false;
                }
                return true;
            }
        }
        $scope.conditionEquipmentPart2Op2 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_12A = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
            let tr_12B = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];

            if ($scope.instance.Verification.VerificationScope.Equipment) {
                if (section4.option_b.option == "2") {
                    if ((parseFloat(tr_12A.tco2e) == 0 && parseFloat(tr_12B.tco2e) == 0)) {
                        return true;
                    }
                    else return false;
                }
                return true;
            }
        }
        $scope.conditionEquipmentPart2Op3 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_12A = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
            let tr_12B = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];
            let tr_12A_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];
            let tr_12B_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12B'];

            if ($scope.instance.Verification.VerificationScope.Equipment) {
                if (section4.option_b.option == "3") {

                    let check_12A = (parseFloat(tr_12A.tco2e) > 0) && (tr_12A_confirmation.confirmation_a.checked || tr_12A_confirmation.confirmation_b.checked);
                    let check_12B = (parseFloat(tr_12B.tco2e) > 0) && (tr_12B_confirmation.confirmation_a.checked || tr_12B_confirmation.confirmation_b.checked);
                    if ((check_12A) || (check_12B)) {
                        return true;
                    }
                    else return false;
                }
                return true;
            }
        }

        $scope.conditionEquipmentPart3Op1 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_12aA = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
            let tr_12aB = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];
            let tr_12aA_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12aA'];
            let tr_12aB_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12aB'];
            if ($scope.instance.Verification.VerificationScope.Equipment) {
                if (section4.option_c.option == "1") {

                    if ((parseFloat(tr_12aA.tco2e) == 0 && parseFloat(tr_12aB.tco2e) == 0) || (tr_12aA_confirmation.confirmation_c.checked || tr_12aB_confirmation.confirmation_c.checked)) {
                        return true;
                    }
                    else return false;
                }
                return true;
            }
        }
        $scope.conditionEquipmentPart3Op2 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_12aA = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
            let tr_12aB = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];

           
            if ($scope.instance.Verification.VerificationScope.Equipment) {
                if (section4.option_c.option == "2") {

                    if ((parseFloat(tr_12aA.tco2e) == 0 && parseFloat(tr_12aB.tco2e) == 0)) {
                        return true;
                    }
                    else return false;
                }
                return true;
            }
        }
        $scope.conditionEquipmentPart3Op3 = function () {
            let section4 = $scope.instance.Verification.EquipmentHFCs.section_II_4;
            let tr_12aA = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
            let tr_12aB = $scope.instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];
            let tr_12aA_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12aA'];
            let tr_12aB_confirmation = $scope.instance.Verification.EquipmentHFCs.section_II_2['tr_12aB'];

            if ($scope.instance.Verification.VerificationScope.Equipment) {
                if (section4.option_c.option == "3") {

                    if ((parseFloat(tr_12aA.tco2e) > 0 || parseFloat(tr_12aB.tco2e) > 0) && (tr_12aA_confirmation.confirmation_a.checked || tr_12aB_confirmation.confirmation_a.checked || tr_12aA_confirmation.confirmation_b.checked || tr_12aB_confirmation.confirmation_b.checked)) {
                        return true;
                    }
                    else return false;
                }
                return true;
            }
        }


    });
})();

(function() {
    // Definition of bulk-hfcs-cofirmation-modal Controller
    angular.module('FGases.controllers').controller('HFCSCofirmationModalController', function($rootScope, $scope, $modalInstance, modalData, modalExtras, $translate) {
        //define controller variables
        $scope.modalData = modalData;
        $scope.modalTitle = 'bulk-hfcs-verification.confirmation-modal-title';
        if ($scope.modalData.option == 'b') {
            $scope.header_1          = '(b)';
            $scope.header_2          = 'bulk-hfcs-verification.table-confirmed-b';
            $scope.option_1          = `${$scope.modalData.translation_prefix}-option-b1`;
            $scope.option_2          = `${$scope.modalData.translation_prefix}-option-b2`;
            $scope.option_3          = `${$scope.modalData.translation_prefix}-option-b3`;
            $scope.option_4          = `${$scope.modalData.translation_prefix}-option-b4`;
            $scope.option_1_tooltip  = `${$scope.modalData.translation_prefix}-option-b1-tooltip`;
            $scope.option_2_tooltip  = `${$scope.modalData.translation_prefix}-option-b2-tooltip`;
            $scope.option_3_tooltip  = `${$scope.modalData.translation_prefix}-option-b3-tooltip`;
            $scope.option_4_tooltip  = `${$scope.modalData.translation_prefix}-option-b4-tooltip`;

            $scope.options_error_msg = 'validation_messages.qc_3007.modal_error_text';
            $scope.reason_error_msg  = 'validation_messages.qc_3008.modal_error_text';
        }
        else if ($scope.modalData.option == 'c') {
            $scope.header_1          = '(c)';
            $scope.header_2          = 'bulk-hfcs-verification.table-confirmed-c';
            $scope.option_1          = `${$scope.modalData.translation_prefix}-option-c1`;
            $scope.option_2          = `${$scope.modalData.translation_prefix}-option-c2`;
            $scope.option_3          = `${$scope.modalData.translation_prefix}-option-c3`;
            $scope.option_4          = `${$scope.modalData.translation_prefix}-option-c4`;
            $scope.option_1_tooltip  = `${$scope.modalData.translation_prefix}-option-c1-tooltip`;
            $scope.option_2_tooltip  = `${$scope.modalData.translation_prefix}-option-c2-tooltip`;
            $scope.option_3_tooltip  = `${$scope.modalData.translation_prefix}-option-c3-tooltip`;
            $scope.option_4_tooltip  = `${$scope.modalData.translation_prefix}-option-c4-tooltip`;
    
            $scope.options_error_msg = 'validation_messages.qc_3009.modal_error_text';
            $scope.reason_error_msg  = 'validation_messages.qc_3010.modal_error_text';
        }
        $scope.show_options_1_2_3 = $scope.modalData.transaction_id != 'tr_11P';
        $scope.alerts = [];
        
        //define OK button action function
        $scope.ok = function(result) {
            $scope.alerts = [];

            // Validate values
            if (!$scope.modalData.confirmation.option_1 &&
                !$scope.modalData.confirmation.option_2 &&
                !$scope.modalData.confirmation.option_3 &&
                !$scope.modalData.confirmation.option_4
            ) {
                $scope.alerts.push({
                    type: 'danger',
                    msg: $scope.options_error_msg,
                });
            }
            if ($scope.modalData.confirmation.option_4 &&
                (isEmpty($scope.modalData.confirmation.option_4_reason) || $scope.modalData.confirmation.option_4_reason.length < 5)) {
                $scope.alerts.push({
                    type: 'danger',
                    msg:  $scope.reason_error_msg,
                });
            }

            if ($scope.alerts.length == 0) {
                $scope.modalData.confirmation.checked = true;
                $modalInstance.close();
            }
        };//end of ok function

        //define CANCEL button action function
        $scope.cancel = function() {
            $scope.modalData.confirmation.checked = false;
            $modalInstance.dismiss('cancel');
        };//end of cancel function
    });//end of app controller 'HFCSCofirmationModalController'
})();

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
(function() {
    angular.module('FGases.controllers').controller("questionnaire", 

        function($scope, $window, $rootScope, dataRepository, languageChanger, $sce, $location, $filter, $translate,
            FormConstants, $notification, FileUploader, $timeout, $anchorScroll, tabService, focus, highlight, $http,
            objectUtil, arrayUtil, numericUtil,
            transactionYearProvider,
            jsonNormalizer, reportStructureNormalizer, reportStructureHelper, dataPrefill,
            viewModel, 
            sheetGeneralValidator,
            SheetBulkHFCSValidator,
            SheetEquipmentValidator,
             ) {
            $scope.viewModel = viewModel;
            $scope.base = $location.host() + $location.port() + getParameterByName('base_uri');
            $scope.availableLanguages = languageChanger.getAvailableLanguages();
            $scope.auditorInfoConfirmed = false;
            $scope.uploadFile = '';
            $scope.uploaders = {
                'bulk-hfcs': new FileUploader(),
                'equipment': new FileUploader(),
            };
            $scope.valMsgIndex = 0;
            $rootScope.euCountries = ['AT', 'BE', 'BG', 'CY', 'CZ', 'DE', 'DK', 'EE', 'ES', 'FI', 'FR', 'GR', 'HR', 'HU', 'IE', 'IT', 'LT', 'LU', 'LV', 'MT', 'NL', 'PL', 'PT', 'RO', 'SE', 'SI', 'SK','UK_NI'];
            $rootScope.allNonEUCountries = [];
            $rootScope.allEUCountries = [];
            $rootScope.currentLanguage = 'en';
           // $rootScope.otherODSGasesList = ['R-11', 'R-12', 'R-12B1', 'R-12B2', 'R-13', 'R-13B1', 'R-13I1', 'R-21', 'R-22', 'R-22B1', 'R-31', 'R-111', 'R-112', 'R-112a', 'R-113', 'R-113a', 'R-114', 'R-114a', 'R-115', 'R-122', 'R-123', 'R-123a', 'R-123b', 'R-124', 'R-124a', 'R-131', 'R-132', 'R-133a', 'R-141', 'R-141b', 'R-142', 'R-142b', 'R-151', 'R-400', 'R-401A', 'R-401B', 'R-401C', 'R-402A', 'R-402B', 'R-403A', 'R-403B', 'R-405A', 'R-406A', 'R-408A', 'R-409A', 'R-409B', 'R-411A', 'R-411B', 'R-412A', 'R-414A', 'R-414B', 'R-415A', 'R-415B', 'R-416A', 'R-418A', 'R-466A', 'R-500', 'R-501', 'R-502', 'R-503', 'R-504', 'R-505', 'R-506', 'R-509A', 'R11', 'R12', 'R12B1', 'R12B2', 'R13', 'R13B1', 'R13I1', 'R21', 'R22', 'R22B1', 'R31', 'R111', 'R112', 'R112a', 'R113', 'R113a', 'R114', 'R114a', 'R115', 'R122', 'R123', 'R123a', 'R123b', 'R124', 'R124a', 'R131', 'R132', 'R133a', 'R141', 'R141b', 'R142', 'R142b', 'R151', 'R400', 'R401A', 'R401B', 'R401C', 'R402A', 'R402B', 'R403A', 'R403B', 'R405A', 'R406A', 'R408A', 'R409A', 'R409B', 'R411A', 'R411B', 'R412A', 'R414A', 'R414B', 'R415A', 'R415B', 'R416A', 'R418A', 'R466A', 'R500', 'R501', 'R502', 'R503', 'R504', 'R505', 'R506', 'R509A', 'Trichlorfluormethane', 'Dichlordifluormethane', 'Bromchlordifluormethane', 'Dibromdifluormethane', 'Chlortrifluormethane', 'Bromtrifluormethane', 'Trifluoriodmethane', 'Dichlorfluormethane', 'Chlordifluormethane', 'Bromdifluormethane', 'Chlorfluormethane', 'Pentachlorfluorethane', 'Chlorpentafluorethane', 'Trichlordifluorethane', 'Trichlorfluorethane', 'Dichlordifluorethane', 'Chlorfluorethane'];
            console.log("selected questionnaire:" + $rootScope.selectedReport);


            //determine ie version, code snippet is taken from: http://msdn.microsoft.com/en-us/library/ms537509%28v=vs.85%29.aspx
            var rv = -1; // Return value assumes failure.
            if (navigator.appName == 'Microsoft Internet Explorer') {
                var ua = navigator.userAgent;
                var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
                if (re.exec(ua) != null)
                    rv = parseFloat(RegExp.$1);
            }
            //see: http://stackoverflow.com/questions/17907445/how-to-detect-ie11
            else if (navigator.appName == 'Netscape') {
                var ua = navigator.userAgent;
                var re = new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})");
                if (re.exec(ua) != null)
                    rv = parseFloat(RegExp.$1);
            }

            $rootScope.ieVersionNumberOutOfCuriosityVariable = rv;
            if (rv > 0 && rv <= 9.0) {
                $rootScope.isIE9 = true;
            } else {
                $rootScope.isIE9 = false;
            }
            $scope.isIE9 = $rootScope.isIE9;
            $rootScope.showConfirmationForThreashold = true;

            //define patterns used with ng-pattern
            $scope.decimalNumberWith3DigitsPattern = /^\d{1,4}(\.\d{1,3})?$/;
            $scope.integerNumber = /^\d+$/;
            $scope.moreThanTwoLetters = /^.{2}.*/;
            $scope.showConfirmationForValueGreaterThanThreshold = true;

            // Definition of gas including elements in instance.FGasesReporting. ADD MORE WHEN NECESSARY
            $scope.gasIncludingElements = reportStructureHelper.getGasIncludingSheets();
            $scope.tradePartnerElements = reportStructureHelper.getTradePartnerTransactions();

            if (!Date.now) {
                Date.now = function() {
                    return new Date().getTime();
                };
            }

            $scope.start = function() {
                dataRepository.getEmptyInstance().error(function() {
                    $notification.error("", "Failed to fetch critical webform resources. Please close the form and try to report again later.");
                }).success(function(instance) {
                    // parseo XML empty instance
                    var XMLParserCtor = (window.fxparser && window.fxparser.XMLParser)
                    || (window.fxp && window.fxp.XMLParser)
                    || (window.XMLParser && window.XMLParser.default);
                    const parser = new XMLParserCtor({
                    ignoreAttributes: false,
                    attributeNamePrefix: '@', // <- CRÍTICO: usa '@' en vez de '_'
                    parseAttributeValue: true,
                    parseTagValue: true
                    });
                    const json = parser.parse(instance); // instance es el string XML
                    $scope.emptyInstance = json;
                    $scope.loadInstance();
                });
            };

            function parseXmlToJson(xmlText) {
                            var XMLParserCtor =
                            (window.fxparser && window.fxparser.XMLParser) ||
                            (window.fxp && window.fxp.XMLParser) ||
                            (window.XMLParser && window.XMLParser.default);
                            if (!XMLParserCtor) throw new Error('Parser XML no cargado');
                            var parser = new XMLParserCtor({
                            ignoreAttributes: false,
                            attributeNamePrefix: '@', // <- CRÍTICO
                            parseAttributeValue: true,
                            parseTagValue: true
                            });
                            return parser.parse(xmlText);
                }
          
          
            $scope.loadInstance = function() {
                dataRepository.getInstance().error(function() {
                    $notification.error("", "Failed to load reporting data. Please close the form and try to report again later.");
                }).success(function(data) {
                    
                     var instance = typeof data === 'string' ? parseXmlToJson(data) : data;
                     reportStructureNormalizer.normalize(instance); 
                    var is_previous_report = dataPrefill.isPreviousReport(instance);
                    if (is_previous_report) {
                        dataRepository.getEmptyInstance().error(function() {
                            $notification.error("", "Failed to read empty instance XML file.");
                        }).success(function(emptyData) {
                            var emptyInstance = typeof emptyData === 'string' ? parseXmlToJson(emptyData) : emptyData;
                            reportStructureNormalizer.normalize(emptyInstance);
                            $scope.setInstance(emptyInstance);
                            dataPrefill.prefil(instance, emptyInstance, {
                                scope: $scope
                            });
                            $scope.onInstanceReady(emptyInstance);
                        });
                    } else {
                        $scope.setInstance(instance);
                        $scope.onInstanceReady(instance);
                    }
                });
            };

            $scope.setInstance = function(instance) {
                $scope.instance = instance;
                viewModel.setDataSource(instance);
            };

            $scope.onInstanceReady = function(instance) {
                $rootScope.currentLanguage = $scope.instance.Verification['@xml:lang'];
                $scope.initTransactionYear();

                if (!companyId) {
                    if ($scope.instance.Verification.GeneralReportData.Company.CompanyId) {
                        companyId = $scope.instance.Verification.GeneralReportData.Company.CompanyId;
                    } else {
                        //companyId is unknown, use test company- just for testing
                        if (!testCompanyId) {
                            companyId = "1234";
                        } else {
                            companyId = testCompanyId;
                        }
                    }
                }
                $scope.filteredReportedGasesForHFCLength = 0;

                // load company info, if it is a first time form loading
                if (isEmpty($scope.instance.Verification.GeneralReportData.Company['@status'])) {
                    $scope.instance.Verification.GeneralReportData.Company['@status'] = 'incomplete';
                }
                if ($scope.instance.Verification.GeneralReportData.Company['@status'] === 'incomplete') {
                    $scope.instance.Verification.GeneralReportData.Company.CompanyId = companyId;
                }
                if (isEmpty($scope.instance.Verification.GeneralReportData['@status'])) {
                    $scope.instance.Verification.GeneralReportData['@status'] = 'incomplete';
                }
                if ($scope.instance.Verification.GeneralReportData['@status'] === 'incomplete') {

                   // $scope.instance.Verification.GeneralReportData.Auditor.AuditorId = auditorId; necesario si el auditor va a venir como par�metro
                   
                    $scope.loadAuditorData();
                    $scope.loadVerificationScope();
                } else {
                    $scope.auditorInfoConfirmed = true;
                    $scope.loadAuditorData();
                    $scope.loadVerificationScope();
                   
                }
            };
      

            $scope.commentLimit = FormConstants.CommentLimit;

           

            $scope.loadAuditorData = function (auditor_uid) {
                
                dataRepository.getAuditorData().error(function () {
                    $notification.error("", "Failed to read auditor data from the registry. Please close the form and try to report again later.");
                }).success(function (auditorInstance) {
                    var auditorIns = auditorInstance;
                    if (angular.isArray(auditorIns)) {
                        auditorIns = $filter('filter')(auditorInstance, { id: auditor_uid })[0];
                    }

                    if (auditorIns) {
                        var auditor = $scope.instance.Verification.GeneralReportData.Auditor;
                        auditor.Auditor_uid = auditorIns.auditor.auditor_uid;               
                        
                        auditor.Company.CompanyName = auditorIns.auditor.name//company.company_name;
                        auditor.Phone = auditorIns.auditor.phone;
                        auditor.Website = auditorIns.auditor.website;
                        auditor.Adress.Street = auditorIns.auditor.address.street;
                        auditor.Adress.Number = auditorIns.auditor.address.number;
                        auditor.Adress.PostalCode = auditorIns.auditor.address.zipcode;
                        auditor.Company.City = auditorIns.auditor.address.city;
                        auditor.Country.Type = auditorIns.auditor.address.country.type;
                        auditor.Country.Name = auditorIns.auditor.address.country.name;
                      

                        auditor.LeadAuditorEmail = auditorIns.leadAuditorEmail;
                        let user = auditorIns.auditor.users.filter((user) => user.email == auditor.LeadAuditorEmail)[0];
                        auditor.leadAuditorFirstName = user?.first_name;
                        auditor.leadAuditorLastName = user?.last_name;

                        $scope.instance.Verification.VerificationScope.SubmissionDate = auditorIns.dataReportReleaseDate;
                        $scope.instance.Verification.GeneralReportData.Company.CompanyName = auditorIns.company.company_name;
                        $scope.instance.Verification.GeneralReportData.Company.Country.Name = auditorIns.company.country;
                        $scope.instance.Verification.GeneralReportData.Company.CompanyId = auditorIns.company.company_id;
                        $scope.instance.Verification.GeneralReportData.Auditor.Country.Type = auditorIns.auditor.address.country.type;

                        dataRepository.getFGasesReportingXmlUrl(auditorIns.dataReportUrl).then(xml_url => {
                            dataRepository.getFGasesReporting(xml_url).then(FGasesReportingInstance => {
                                $scope.instance.Verification.ReportedBulk = FGasesReportingInstance.Bulk;
                                $scope.instance.Verification.ReportedEquipment = FGasesReportingInstance.Equipment;
                                $scope.instance.Verification.GeneralReportData.ReportingYear = FGasesReportingInstance.GeneralReportData.ReportingYear;
                                
                                $scope.instance.Verification.GeneralReportData.EuLegalRepresentativeCompany.Name = FGasesReportingInstance.GeneralReportData.EuLegalRepresentativeCompany.Name;
                                $scope.instance.Verification.GeneralReportData.EuLegalRepresentativeCompany.Country.Name = FGasesReportingInstance.GeneralReportData.EuLegalRepresentativeCompany.Country;
                                $scope.instance.Verification.GeneralReportData.Company.Country.Type = FGasesReportingInstance.GeneralReportData.Company.Country.Type;
                            });
                        });
                    }
                });
            };


            $scope.loadVerificationScope = function () {
                
                dataRepository.getAuditorData().error(function () {
                    $notification.error("", "Failed to read auditor data from the registry. Please close the form and try to report again later.");
                }).success(function (auditorInstance) {
                    var auditorIns = auditorInstance;
               

                    if (auditorIns) {
                        var vS = $scope.instance.Verification.VerificationScope;    
                        vS.DataReportUrl = auditorIns.dataReportUrl;
                        vS.Bulk = auditorIns.verificationOptions.bulk;
                        vS.Equipment = auditorIns.verificationOptions.equipment;
                        
                    }
                });
            };

        
            $scope.modifyCompanyInfo = function() {
                if (confirm('The reporting will end at this stage and you are forwarded to another webpage where company information can be changed. \n Are you sure you want to proceed with modifying company information?')) {
                    $scope.instance.Verification.GeneralReportData.Company['@status'] = 'modified';
                    $scope.saveInstance();
                    window.location = "https://fgas-licensing.ec.europa.eu/fgas/resources/gdpr";

                }
            };           

            $scope.reportingYears = function() {
                return transactionYearProvider.getValidTransactionYears();
            };

            $scope.initTransactionYear = function() {
                $scope.instance.Verification.VerificationScope.TransactionYear = transactionYearProvider.getTransactionYear();
                $scope.previousTransactionYearSelection = transactionYearProvider.getTransactionYear();
            };

         
         /*   $scope.updateActivityUpperCB = function(upperCBPath, innerCBs) {
                // sets upperCBPath to true if any of the innerCBs are true
                var tempUpperCBValue = false;
                for (var i = 0; i < innerCBs.length && tempUpperCBValue == false; i++) {
                    var innerCBValue = $scope.instance.FGasesReporting.GeneralReportData.Activities[innerCBs[i]];
                    innerCBValue = innerCBValue == null ? false : innerCBValue;
                    tempUpperCBValue = tempUpperCBValue || innerCBValue;
                }
                $scope.instance.FGasesReporting.GeneralReportData.Activities[upperCBPath] = tempUpperCBValue;
            };*/

            


          
            dataRepository.loadCodeList();
           // dataRepository.loadFGases();
            $scope.codeList = dataRepository.getCodeList();
            viewModel.initCodeLists($scope.codeList);
            $scope.conversionLink = "";
            $scope.instanceInfo = {};
            dataRepository.loadInstanceInfo().error(function() {
                console.log("Failed to readfile info from server.");
            }).success(function(info) {
                angular.copy(info, $scope.instanceInfo);
                if ($scope.instanceInfo.conversions) {
                    var html_conv = $filter('filter')($scope.instanceInfo.conversions, { resultType: 'HTML' });
                    if (html_conv.length > 0) {
                        var htmlConversionId = html_conv[0].id;
                        $scope.conversionLink = $scope.instanceInfo.conversionLink + htmlConversionId;
                    }

                }
            })

            $scope.initArray = function(arrayElement, last) {
                var tokens = arrayElement.split(".");
                var result = $scope.instance;
                while (tokens.length) {
                    result = result[tokens.shift()];
                }

                if (!(result[last] instanceof Array)) {
                    result[last] = [result[last]];
                }
            };

            // Add new row to ng-repeat
            $scope.addItem = function(path, value) {
                var tokens = path.split(".");
                var result = $scope.instance;
                while (tokens.length) {
                    result = result[tokens.shift()];
                }

                // Need to make copy of object otherwise it gets same $$hashkey and it cannot be used in ng-repeat.
                // Other solution would be to get empty instance every time that would be slower.
                var copyOfEmptyInstance = clone(objectUtil.isNull(value) ? $scope.getInstanceByPath('emptyInstance', path) : value);
                result.push(copyOfEmptyInstance);
                return copyOfEmptyInstance;

            };

     
         
            // Remove row from ng-repeat.
            $scope.remove = function(array, index, rowElement, showConfirmation) {
                //console.log(rowElement);
                //console.log(countNonEmptyProperties(rowElement));
                showConfirmation = typeof showConfirmation !== 'undefined' ? showConfirmation : false;
                if (showConfirmation && countNonEmptyProperties(rowElement) > 0) {
                    if (!confirm('Are you sure you want to delete the data in this row?')) {
                        return;
                    }
                }
                array.splice(index, 1);
            };

      
            // function to find a gas element for given column and row
          /*  $scope.getGasElementFor = function(gasColumn, gasRow) {
                for (var i = 0; i < $scope.gasIncludingElements.length; i++) {
                    var elem = $scope.gasIncludingElements[i];
                    if (angular.isArray($scope.instance.FGasesReporting[elem].Gas)) {
                        var column = $scope.instance.FGasesReporting[elem].Gas[gasColumn];
                        if (angular.isDefined(column[gasRow]) && column[gasRow]) {
                            return column[gasRow];
                        }
                    }
                }
                return null;
            };*/ // end of function getGasElementFor

            // function to find a value of a gas element for given column and row
       /*     $scope.getValueForReportedGasAmountFrom = function (gasColumn, gasRow) {
                var retVal = $scope.getGasElementFor(gasColumn, gasRow);
                if (retVal) {
                    retVal = $scope.getValueForReportedGasAmount(retVal);
                } else {
                    retVal = 0.0;
                }
                return retVal
            }; */// end of function getValueForReportedGasAmountFrom

       

            // delegator function for scope
            $scope.containsHFC = function(gasOrComponent) {
                return containsHFCUtilFn(gasOrComponent) || $scope.isUnspecifiedMix(gasOrComponent);
            }; // delegator function for scope
            $scope.get_gas_by_id = function(gas_id) {
                for (var i = 0; i < $scope.instance.FGasesReporting.ReportedGases.length; i++) {
                    if (gas_id === $scope.instance.FGasesReporting.ReportedGases[i].GasId) {
                        return $scope.instance.FGasesReporting.ReportedGases[i];
                    }
                }
            }

       
            // delegator function for scope
            $scope.containsHFC = function(gasOrComponent) {
                return containsHFCUtilFn(gasOrComponent) || $scope.isUnspecifiedMix(gasOrComponent);
            }; // delegator function for scope

            //utility function to check if validation message has valid gas index
            $scope.validGasIndexForValidationMessage = function(validationMessage) {
                if (validationMessage && angular.isDefined(validationMessage.gasIndex) && validationMessage.gasIndex != null && validationMessage.gasIndex >= 0) {
                    return true;
                }
                return false;
            }; // end of function validGasIndexForValidationMessage

            //utility function to check if validation message has valid trader partner id
            $scope.validTradePartnerForValidationMessage = function(validationMessage) {
                if (validationMessage && angular.isDefined(validationMessage.tradePartnerId) && validationMessage.tradePartnerId != null && validationMessage.tradePartnerId) {
                    return true;
                }
                return false;
            }; // end of function validTradePartnerForValidationMessage

            $scope.goToValidationMessageCause = function(validationMessage) {
                let id = `${validationMessage.transaction}-${validationMessage.gasIndex}`;
                let isBlocker = validationMessage.isBlocker;
                var old = $location.hash();
                $timeout(function() {
                    $location.hash(id);
                    $anchorScroll();
                    focus(id);
                    highlight(id, isBlocker);
                    $location.hash(old);
                }, 200);
            }; //end of function goToValidationMessageCause


        


         
            // ------------------------------------------
            // Starting validation part
            // ------------------------------------------
            $scope.transactionValidationErrorsTemplate = { 'transaction': null, transactionLabel: null, 'errors': [] };
            $scope.validationErrorTemplate = { 'QCCode': null, 'gasIndex': null, 'tradePartnerId': null, 'type': null, 'message': null };
            $scope.validationFlagTemplate = { 'qcCode': null, 'gasId': null, 'tradePartnerId': null, 'transactionCode': null, 'comment': null };

            // valSubCat have to to have the same name from FormConstants.TabIds
            $scope.valSubCat = ['BulkHFCsVerification', 'EquipmentVerification'];
            $scope.errors = {};
            $scope.validationMessages = {};

            for (var i = 0; i < $scope.valSubCat.length; i++) {
                $scope.errors[$scope.valSubCat[i]] = [];
                $scope.validationMessages[$scope.valSubCat[i]] = [];
            }
            
            $scope.pushError = function(group, transactionIndex, code, message) {
                //console.log("Received error: " + group + ": " + $scope.form7transactions[transactionIndex] + " / " + code);
                $scope.errors[group][transactionIndex].errors.push(clone($scope.validationErrorTemplate));
                var index = $scope.errors[group][transactionIndex].errors.length - 1;
                $scope.errors[group][transactionIndex].errors[index].QCCode = code;
                if (message != null && message.length > 0) {
                    $scope.errors[group][transactionIndex].errors[index].message = message;
                }
            };
            $scope.pushWarning = function(group, transactionIndex, code, message) {
                //console.log("Received error: " + group + ": " + $scope.form7transactions[transactionIndex] + " / " + code);
                $scope.errors[group][transactionIndex].errors.push(clone($scope.validationErrorTemplate));
                var index = $scope.errors[group][transactionIndex].errors.length - 1;
                $scope.errors[group][transactionIndex].errors[index].QCCode = code;
                if (message != null && message.length > 0) {
                    $scope.errors[group][transactionIndex].errors[index].message = message;
                }
                $scope.errors[group][transactionIndex].errors[index].isNonBlocker = true;
            };

            $scope.pushFlag = function (group, transactionIndex, code, message) {
                if (!$scope.errors[group][transactionIndex].flags) {
                    $scope.errors[group][transactionIndex].flags = [];
                }
                $scope.errors[group][transactionIndex].flags.push(clone($scope.validationFlagTemplate));
                var index = $scope.errors[group][transactionIndex].flags.length - 1;
                $scope.errors[group][transactionIndex].flags[index].qcCode = code;
                //$scope.errors[group][transactionIndex].flags[index].transactionCode = $scope.form7transactionLabels[j];
                if (message != null && message.length > 0) {
                    $scope.errors[group][transactionIndex].flags[index].comment = message;
                }
            };

            $scope.updateValidationMessages = function (group) {
                var groupValidationMessages = [];
                var groupErrors = objectUtil.defaultIfNull($scope.errors[group], []);

                for (var i = 0; i < groupErrors.length; i++) {
                    var transactionErrorInfo = groupErrors[i];

                    if (transactionErrorInfo.errors != null && transactionErrorInfo.errors.length > 0) {
                        for (var j = 0; j < transactionErrorInfo.errors.length; j++) {
                            var errorInfo = transactionErrorInfo.errors[j];
                            var messageText;

                            if (objectUtil.isNull(errorInfo.message)) {
                                messageText = $translate.instant("validation_messages.qc_" + errorInfo.QCCode + ".error_text");
                            } else {
                                messageText = errorInfo.message;
                            }

                            var message = {
                                'transaction': transactionErrorInfo.transaction,
                                'transactionLabel': transactionErrorInfo.transactionLabel,
                                'qccode': errorInfo.QCCode,
                                'gasIndex': errorInfo.gasIndex,
                                'tradePartnerId': errorInfo.tradePartnerId,
                                'message': messageText,
                                isBlocker: !errorInfo.isNonBlocker
                            };
                            groupValidationMessages.push(message);
                        }
                    }
                }

                groupValidationMessages.sort(function(msg1, msg2) {
                    var cmp = msg1.transaction.localeCompare(msg2.transaction);

                    if (cmp !== 0) return cmp;

                    cmp = Number(msg1.qccode) - Number(msg2.qccode);

                    if (cmp !== 0) return cmp;

                    if (!numericUtil.isNum(msg1.gasIndex) || !numericUtil.isNum(msg2.gasIndex)) {
                        return 0;
                    }

                    return Number(msg1.gasIndex) - Number(msg2.gasIndex);
                });
                $scope.validationMessages[group] = groupValidationMessages;
            };

           /* $scope.refreshValidations = function() {
                arrayUtil.forEach($scope.valSubCat, function(subCat) {
                    var tabErrors = $scope.errors[subCat];

                    if (!objectUtil.isNull(tabErrors) && tabErrors.length > 0) {
                        $scope.validateBySubCat(subCat);
                    }
                });
            };*/
            $scope.validateBySubCat = function (subCat) {
                switch (subCat) {
                    case "BulkHFCsVerification":
                        $scope.validateBulkHFCS();
                        break;
                    case "EquipmentVerification":
                        $scope.validateEquipment();
                        break;               
                }
            };

            $scope.validateBulkHFCS = function() {
                var sheetId = 'BulkHFCsVerification';
                if (!$scope.isTabVisible(sheetId)) return;
                $scope.errors[sheetId] = SheetBulkHFCSValidator.validate(viewModel);
                $scope.updateValidationMessages(sheetId);
            }

            $scope.validateEquipment = function() {
                var sheetId = 'EquipmentVerification';
                if (!$scope.isTabVisible(sheetId)) return;
                $scope.errors[sheetId] = SheetEquipmentValidator.validate(viewModel);
                $scope.updateValidationMessages(sheetId);
            }

         
            //list of functions
            $scope.valFns = [
                $scope.validateBulkHFCS,
                $scope.validateEquipment,
            ];

            // This function calls validation function for given tab index.
            $scope.validateActiveForm = function() {
                let activeTabIndex = tabService.getActiveTabIndex();
                let validationIndex = $scope.getValidationIndex(activeTabIndex);
                if (validationIndex >= 0) {
                    $scope.valMsgIndex = 0;
                    ($scope.valFns[validationIndex])();
                    if ($scope.validationMessages[$scope.valSubCat[validationIndex]].length == 0) {
                        $notification.info("Validation", "No validation errors found on current form.");
                    }
                }
            }; // end of function validateActiveForm

            $scope.getValidationIndex = function(tabIndex) {
                return $scope.valSubCat.indexOf(FormConstants.TabIds[tabIndex]);
            }

            $scope.hasActiveTabValidation = function() {
                let activeTabIndex = tabService.getActiveTabIndex();
                let tabId = FormConstants.TabIds[activeTabIndex];
                return $scope.valSubCat.includes(tabId);
            }

            $scope.hasActiveTabValidationMessages = function() {
                let activeTabIndex = tabService.getActiveTabIndex();
                let validationIndex = $scope.getValidationIndex(activeTabIndex);
                if (validationIndex >= 0) {
                    if ($scope.validationMessages[$scope.valSubCat[validationIndex]].length > 0) {
                        return true;
                    }
                }
                return false;
            }
            $scope.getActiveValidationMessages = function() {
                let activeTabIndex = tabService.getActiveTabIndex();
                let validationIndex = $scope.getValidationIndex(activeTabIndex);
                return $scope.validationMessages[$scope.valSubCat[validationIndex]] || [];
            }

            $scope.getCurrentValidationMessage = function() {
                let messageIndex = $scope.getValMsgIndex();
                return $scope.getActiveValidationMessages()[messageIndex];
            }

            $scope.getGoToFieldLabel = function() {
                return $translate.instant('common.go-to-field');
            }

            $scope.formTotalValidated = false;

            $scope.calculateOverallValidationStatus = function () {
                arrayUtil.forEach($scope.valFns, function(valFn) { objectUtil.call(valFn); });
               // $scope.validateUnusualGasSelection();

                $scope.formTotalValidated = true;

                arrayUtil.forEach($scope.valSubCat, function(valSubCat, loopContext) {
                    var messages = $scope.validationMessages[valSubCat];
                    var hasBlockerErrors = arrayUtil.contains(messages, function(message) { return message.isBlocker; });
                
                    if (hasBlockerErrors) {
                        $scope.formTotalValidated = false;
                        loopContext.breakLoop = true;
                    }
                });

                $scope.instance.Verification.qcWarningFlags = {
                    flag: []
                };

                arrayUtil.forEach(Object.getOwnPropertyNames($scope.errors), function(tabName) {
                    var tabTransactionErrorContainers = $scope.errors[tabName];

                    arrayUtil.forEach(tabTransactionErrorContainers, function(tabTransactionErrorContainer) {
                        if (!objectUtil.isNull(tabTransactionErrorContainer.flags)) {
                            arrayUtil.pushMany( $scope.instance.Verification.qcWarningFlags .flag, tabTransactionErrorContainer.flags);
                        }
                    });
                });
            };

          

          /*  $scope.validateUnusualGasSelection = function() {
                $scope.instance.FGasesReporting.unusualGasChoises = {};
                $scope.instance.FGasesReporting.unusualGasChoises.unusualGas = [];
                $scope.calculateValidateUnusualGasSelection($scope.unusualGasValidationsGroup1, 'unusualGasesG1');
            }*/
                        
         
            
            // ------------------------------------------
            // End of validation part
            // ------------------------------------------


            // ------------------------------------------
            // Start form submission related issues
            // ------------------------------------------

            $scope.submitReport = function() {
                if (transactionYearProvider.getTransactionYear() !== transactionYearProvider._maxTransactionYear()) {
                    alert("In this reporting season, reports on " + transactionYearProvider._maxTransactionYear() + " are expected. This report currently refers to " + transactionYearProvider.getTransactionYear() + " (maybe because you copied an older delivery as a starting point).\n" +
                        "Please note that the transaction year is automatically set to " + transactionYearProvider._maxTransactionYear() + ". Please check the data in your report to make sure it is correct for the " + transactionYearProvider._maxTransactionYear() + " reporting year.");
                    $scope.instance.Verification.VerificationScope.TransactionYear = transactionYearProvider._maxTransactionYear();
                    $scope.onTransactionYearChanged($scope.calculateOverallValidationStatus);
                    return;
                }
                $scope.calculateOverallValidationStatus();
                var save = false;

                if ($scope.formTotalValidated) {
                    $scope.instance.Verification.GeneralReportData['@status'] = "completed";
                   // $scope.instance.Verification.Auditor['@status'] = "completed";
                    save = true;
                } else {
                    save = confirm("Please note that a submission of this report will be automatically rejected as not acceptable.");
                }

                if (!save) {
                    return;
                }

                dataRepository.saveInstanceXml($scope.instance).error(function() {
                    $notification.error("Save", "Data is not saved due to technical problems!");
                }).success(function(response) {
                    if (response.code === 0) {
                        $notification.error("Save", "Data is not saved due to technical problems!");
                        return;
                    }

                    $scope.submitted = true;
                    $scope.appForm.$setPristine(true);
                    $scope.$root.allowNavigation();
                    $notification.success("Save", "Data is saved successfully.");
                    $scope.close();
                });
            };

            $scope.reopenReport = function() {
                $scope.calculateOverallValidationStatus();
                $scope.instance.Verification.GeneralReportData['@status'] = "incomplete";
                if (transactionYearProvider.getTransactionYear() !== transactionYearProvider._maxTransactionYear()) {
                    alert("In this reporting season, reports on " + transactionYearProvider._maxTransactionYear() + " are expected. This report currently refers to " + transactionYearProvider.getTransactionYear() + " (maybe because you copied an older delivery as a starting point).\n" +
                        "Please note that the transaction year is automatically set to " + transactionYearProvider._maxTransactionYear() + ". Please check the data in your report to make sure it is correct for the " + transactionYearProvider._maxTransactionYear() + " reporting year.");
                    $scope.instance.FGasesReporting.GeneralReportData.TransactionYear = transactionYearProvider._maxTransactionYear();
                    $scope.onTransactionYearChanged($scope.calculateOverallValidationStatus);
                    return;
                }
            };

            $scope.isFormSubmitted = function() {
                if ($scope.instance.Verification.GeneralReportData['@status'] == "completed") {
                    return true;
                } else {
                    return false;
                }
            };

            // ------------------------------------------
            // End form submission related issues
            // ------------------------------------------

          
            $scope.removeFirst = function(array) {
                if (!array) {
                    return;
                }

                //For arrays are specified as
                // <item>
                //  <code></code>
                //  <label></label>
                // </item
                if (angular.isDefined(array[0].code) && array[0].code === "") {
                    array.splice(0, 1);
                    return array;
                }

                //For grouped arrays
                //<group>
                //  <name></name>
                //  <additionalInfo></additionalInfo>
                //  <item>
                //      <code/>
                //      <label/>
                //  </item>
                //</group>
                if (angular.isDefined(array[0].item) && array[0].item.code === "") {
                    array.splice(0, 1);
                    return array;
                }

                return array;
            };

            // get code list label by code
            $scope.getCodeListLabel = function(codelist, code) {
                //Do not try to get codeList before it actually exists.
                if (!$scope.codeList) {
                    return;
                }

                //Escape codelists that are not arrays by default (has only one element)
                // This code can be removed when changes are made to codeList file.
                if (!($scope.codeList.FGasesCodelists[codelist].item.length > 0) &&
                    $scope.codeList.FGasesCodelists[codelist].item.code == code) {
                    return $scope.codeList.FGasesCodelists[codelist].item.label;
                }

                var retValue;
                for (var i = 0; i <= $scope.codeList.FGasesCodelists[codelist].item.length - 1; i++) {
                    if ($scope.codeList.FGasesCodelists[codelist].item[i].code == code) {
                        retValue = $scope.codeList.FGasesCodelists[codelist].item[i].label;
                        break;
                    }
                }
                return retValue;
            };

            $scope.getInstanceByPath = function(root, identifier) {
                if (!$scope.instance) {
                    return null;
                }

                var tokens = root.split(".");
                var result = $scope;
                while (tokens.length) {
                    result = result[tokens.shift()];
                    if (!result) {
                        return null;
                    }
                }

                tokens = identifier.split(".");
                while (tokens.length) {
                    result = result[tokens.shift()];
                }

                return result;
            };

            // save instance data.
            $scope.saveInstance = function(saveOptions) {
                $scope.submitted = true;
                var options = objectUtil.defaultIfNull(saveOptions, {});
                dataRepository.saveInstanceXml($scope.instance).error(function() {
                    $notification.error("Save", "System Error. Data is not saved !");
                }).success(function(response) {
                    if (response.code === 0) {
                        $notification.error("Save", "System Error. Data is not saved !");
                        return;
                    }
                    if (!options.validationOff && $scope.appForm.$invalid) {
                        $notification.warning("Save", "Warning! Data is saved, but the questionnaire contains validation errors.");
                    } else {
                        $notification.success("Save", "Data is saved successfully.");
                    }
                });
                $scope.appForm.$setPristine(true);
            };

            $scope.validationOnOff = function() {
                $scope.submitted = !$scope.submitted;
            };

            // save instance data.
            $scope.close = function() {
                if (baseUri == '') {
                    baseUri = "/"
                };
                var windowLocation = (envelope && envelope.length > 0) ? envelope : baseUri;
                if ($scope.appForm.$dirty) {
                    if (confirm('You have made changes in the questionnaire! \n\n Do you want to leave without saving the data?')) {
                        window.location = windowLocation;
                    }
                } else {
                    //console.log("Failed to confirm");
                    window.location = windowLocation;
                }
            };
            // convert XML to HTML in new window.
            $scope.printPreview = function() {
                //$window.open("https://webq2test.eionet.europa.eu/download/convert?fileId=19095&conversionId=522", '_blank');

                dataRepository.saveInstanceXml($scope.instance).success(function() {
                    var result = confirm("The print preview will open in a new popup window. Please make sure your browser does not block it.");
                    if (result) {
                        $window.open($scope.conversionLink, '_blank');
                    }


                    // win.focus;
                });
            };

            $scope.windowSearch = window.location.search;

            $scope.phoneNumberPattern = /^[ 0-9\(\)\+\-]{7,25}$/;
            $scope.positiveIntegerPattern = /^\d+$/;
            $scope.decimalNumberPattern = /^\d*\.?\d*$/;
            $scope.websiteAddressPattern = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/;
            $scope.percentage = (function() {
                return {
                    test: function(value) {

                        if ($scope.decimalNumberPattern.test(value) &&
                            0 <= value &&
                            value <= 100) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                };
            })();

            $scope.isFixedQuestion = function(dataPath) {
                var tokens = dataPath.split('.');
                var lastToken = tokens.pop();
                //console.log(lastToken);
                //console.log(lastToken == 'FixedQuestion');
                return (lastToken == 'FixedQuestion');
            };
            $scope.clearFileSelect = function(id) {
                if (id === 'bulk-hfcs') {
                    document.getElementById('bulk-hfcs-verification-verification-report-upload').value = '';
                }
                else if (id = 'equipment') {
                    document.getElementById('equipment-verification-verification-report-upload').value = '';
                }
            };
            $scope.configureUploader = function (id) {
                var uploadUri;
                var domain = getDomain(window.location.href);

                if (isEmpty(envelope)) {
                    if (baseUri == '') uploadUri = domain + "/" + "uploadXml";
                    else  //just for testing - uploads XML file to WebQ sesison files (does not require authentication).
                        uploadUri = domain + "/" + baseUri + "/uploadXml";
                    $scope.uploaders[id].alias = "userFiles";
                } else {
                    var webqUri = getWebQUrl('/restProxyFileUpload');
                    uploadUri = domain + webqUri + "&uri=" + encodeURIComponent(envelope + "/manage_addDocument");
                }
                $scope.uploaders[id].url = uploadUri;
                $scope.uploaders[id].onErrorItem = function(item, response, status, headers) {
                    alert("Document upload failed! Please try again.");
                    $scope.uploaders[id].clearQueue();
                };
            };
            $scope.configureUploaderBulkHFCS = new function() { $scope.configureUploader('bulk-hfcs'); }
            $scope.configureUploaderEquipment = new function() { $scope.configureUploader('equipment'); }

            FileUploader.FileSelect.prototype.onChangeOrg = FileUploader.FileSelect.prototype.onChange;
            FileUploader.FileSelect.prototype.onChange = function() {
                this.uploader.clearQueue();
                this.onChangeOrg();
            }

            $scope.uploadFile = function(id, documentPath, objectIdentifier, prefix) {
                $scope.uploaders[id].onSuccessItem = function(item, response, status, headers) {
                    documentObj = $scope.getInstanceByPath(documentPath, objectIdentifier);
                    if (!isEmpty(envelope)) {
                        documentObj.Url = envelope + "/" + item.file.name;
                    } else {
                        //testing
                        documentObj.Url = getDomain(window.location.href) + "/" + baseUri + "/" + item.file.name;
                    }
                    $scope.saveInstance({ validationOff: true });
                    $scope.uploaders[id].clearQueue();
                };
                // Do no let upload XML files
                for (var i = 0; i < $scope.uploaders[id].queue.length; i++) {
                    let item = $scope.uploaders[id].queue[i];
                    if (item.file.type == "text/xml") {
                        $notification.error("", $translate.instant('validation_messages.qc_3004.error_text'));
                        $scope.uploaders[id].clearQueue();
                        break;
                    }
                }
                //$files: an array of files selected, each file has name, size, and type.
                for (var i = 0; i < $scope.uploaders[id].queue.length; i++) {
                    let item = $scope.uploaders[id].queue[i];
                    if (!item.file.name.startsWith(prefix)) {
                        item.file.name = `${prefix}${item.file.name}`
                    }
                    item.upload();
                }
                $scope.clearFileSelect(id);
            };

            $scope.removeDocument = function(documentPath, objectIdentifier) {
                documentObj = $scope.getInstanceByPath(documentPath, objectIdentifier);
                if (confirm("Do you want to delete document '" + documentObj.Url + "' ?")) {
                    var deleteUri = undefined;
                    var domain = getDomain(window.location.href);

                    if (!isEmpty(envelope)) {
                        var webqUri = getWebQUrl('/restProxyDeleteFileUpload');
                        deleteUri = domain + webqUri + "&uri=" + encodeURIComponent(envelope + "/delete_files");
                    }
                    if (deleteUri !== undefined) {
                        let file_id = documentObj.Url.split('/').pop();
                        let data = { "files": [file_id] };
                        $http.post(deleteUri, data, { withCredentials: true })
                            .success(function() {
                                documentObj.Url = null;
                                documentObj.Title = null;
                                $scope.saveInstance({ validationOff: true });
                            })
                            .error(function() {
                                $notification.error("", `Error deleting file ${documentObj.Url}`);
                            });
                    }
                }
            };

            $scope.gotoTab = function(tab) {
                $scope.sendCdrPing();
                tabService.gotoTab(tab);
                //call ng click events, when a tab is clicked
                $scope.onTabChange(tab);
            }; //end of method gotoTab
            $scope.sendCdrPing = function() {
                if (!isEmpty(envelope)) {

                    //var url = getWebQUrl('/restProxy') + '&uri=' + encodeURIComponent(envelope + "/webqKeepAlive");
                    var url = envelope + "/webqKeepAlive";
                    $http.get(url, { withCredentials: true }).success(function(data) {});
                }

            }

            // this function contains conditions for each tab (if it is visible or not)
            $scope.isTabVisible = function(tabId) {
                //create two main conditions
                var mainCondition = angular.isDefined($scope.instance) && $scope.instance.Verification.GeneralReportData['@status'] != 'completed';
                var subMainCondition = mainCondition && $scope.instance.Verification.GeneralReportData.Company['@status'] == 'confirmed';
                let BulkHFCsVerificationConfition = subMainCondition && $scope.instance.Verification.VerificationScope.Bulk;
                let EquipmentVerificationConfition = subMainCondition && $scope.instance.Verification.VerificationScope.Equipment;

              
               // var nilSelected = mainCondition && $scope.instance.FGasesReporting.GeneralReportData.Activities['NIL-Report'];
                //switch over tab id
                switch (tabId) {
                    case 'CompanyInfo':
                        return mainCondition;
                    case 'ReportIdentification': 
                        return subMainCondition;
                    case 'BulkHFCsVerification':
                        return BulkHFCsVerificationConfition;
                    case 'EquipmentVerification':
                        return EquipmentVerificationConfition;
                    case 'Submission':
                        return (subMainCondition && (BulkHFCsVerificationConfition || EquipmentVerificationConfition)) ||
                            (angular.isDefined($scope.instance) && $scope.instance.Verification.GeneralReportData['@status'] == 'completed');
                  
                    default:
                        return true;
                }
            }; //end of function isTabVisible

            $scope.onTabChange = function(tabId) {
                $scope.valMsgIndex = 0;

                switch (tabId) {
                    case 'CompanyInfo':
                        break;
                    case 'ReportIdentification':
                        break;
                    case 'BulkHFCsVerification':
                        break;
                    case 'EquipmentVerification':
                        break;
                    case 'Submission':
                        $scope.calculateOverallValidationStatus();
                        //$scope.refreshValidations();
                        break;                  
                    default:
                        break;
                }

                $scope.sendCdrPing();
            };

            $scope.getValMsgIndex = function() {
                return $scope.valMsgIndex;
            };

            $scope.setValMsgIndex = function(value) {
                $scope.valMsgIndex = value;
            };

            $scope.setNextMsgIndex = function() {
                let total = $scope.getActiveValidationMessages().length;
                let newIndex = ($scope.getValMsgIndex() + 1) % total;
                $scope.setValMsgIndex(newIndex);
            }
            $scope.setPrevMsgIndex = function() {
                let total = $scope.getActiveValidationMessages().length;
                let newIndex = ($scope.getValMsgIndex() - 1 + total) % total;
                $scope.setValMsgIndex(newIndex);
            }

            $scope.gotoNextTab = function() {
                let activeTabIndex = tabService.getActiveTabIndex();
                var i = 0;
                for (i = activeTabIndex + 1; i < FormConstants.TabIds.length; i++) {
                    if ($scope.isTabVisible(FormConstants.TabIds[i])) {
                        break;
                    }
                }

                if (i > activeTabIndex && i < FormConstants.TabIds.length) {
                    $scope.gotoTab(FormConstants.TabIds[i]);
                }
            }; //end of method gotoNextTab

            $scope.gotoPreviousTab = function() {
                let activeTabIndex = tabService.getActiveTabIndex();
                var i = 0;
                for (i = activeTabIndex - 1; i >= 0; i--) {
                    if ($scope.isTabVisible(FormConstants.TabIds[i])) {
                        break;
                    }
                }

                if (i < activeTabIndex && i >= 0) {
                    $scope.gotoTab(FormConstants.TabIds[i]);
                }
            }; //end of method gotoPreviousTab

            $scope.isLastTab = function() {
                let activeTabIndex = tabService.getActiveTabIndex();
                var countTabs = 0;
                var currentTabIdx = 0;
                for (var i = 0; i < FormConstants.TabIds.length; i++) {
                    if ($scope.isTabVisible(FormConstants.TabIds[i])) {
                        if (FormConstants.TabIds[i] == FormConstants.TabIds[activeTabIndex]) {
                            currentTabIdx = countTabs;
                        }
                        countTabs++;
                    }
                }
                return currentTabIdx == countTabs - 1;
            }; //end of method gotoNextTab

           

            $scope.gasContainsComment = function(gasArray, propertyName) {
                for (var i = 0; i < gasArray.length; i++) {
                    var gas = gasArray[i];
                    var item = gas[propertyName];
                    if (angular.isUndefined(item.Comment) || item.Comment === null) {
                        return false;
                    }
                }
                return true;
            };
            $scope.valueGreaterThanZero = function(inputValue) {
                return angular.isDefined(inputValue) && inputValue !== null &&
                    inputValue > 0;
            }
            $scope.floatValueGreaterThanZero = function(value) {
                var inputValue = parseFloat(value);
                return $scope.valueGreaterThanZero(inputValue);
            }
            $scope.integerValueGreaterThanZero = function(value) {
                var inputValue = parseInt(value);
                return $scope.valueGreaterThanZero(inputValue);
            }

            $scope.hasValue = function(data) {
                return angular.isDefined(data) && data !== null && data !== "";
            };

            $scope.stringNotEmpty = function(data) {
                return data !== null && angular.isString(data) && data.length > 0;
            };



            getEnvelopeXMLUrl = function (url) {
                
                if (isTestSession) {
                    url = '../../xml/envelopeXML.xml';
                }
                console.log("getEnvelopeXMLUrl" + url);

                $http.get(url, { transformResponse: function (data) { return data; } })
                    .then(function (response) {
                        var parser = new DOMParser();
                        var xmlDoc = parser.parseFromString(response.data, "text/xml");

                        var fileNode = xmlDoc.getElementsByTagName("file")[0];                        
                        $scope.fileLink = fileNode ? fileNode.getAttribute("link") : "Not found";
                        console.log("File link:", $scope.fileLink);
                     
                            
                    })
                    .catch(function (error) {
                        console.error("Error loading XML:", error);
                    });
               
             }

            $scope.resetGasComment = function(data) {
                if (numericUtil.toNum(data.Amount, 0) === 0) {
                    data.Comment = null;
                }
            };
            $scope.isPositiveNumber = function(number) {
                var expression = parseFloat(number) > 0;
                return expression;
            }
            $scope._clean_confirmation = function(confirmation) {
                confirmation.checked = false;
                if (confirmation.hasOwnProperty('option_1')) confirmation.option_1 = false;
                if (confirmation.hasOwnProperty('option_2')) confirmation.option_2 = false;
                if (confirmation.hasOwnProperty('option_3')) confirmation.option_3 = false;
                if (confirmation.hasOwnProperty('option_4')) confirmation.option_4 = false;
                if (confirmation.hasOwnProperty('option_4_reason')) confirmation.option_4_reason = "";
            }

           
            $scope.start();

        }); // end of main controller FGases "questionnaire"


})();

(function() {
    angular.module('FGases.directives').directive('staticInclude', function($http, $templateCache, $compile) {
        return function(scope, element, attrs) {
            var templatePath = attrs.staticInclude;
            $http.get(templatePath, { cache: $templateCache }).success(function(response) {
                var contents = element.html(response).contents();
                $compile(contents)(scope);
            });
        };
    });
})();



(function() {
    angular.module('FGases.filters').filter('amountTonnes', [
        
        'objectUtil',
        
        function(objectUtil) {
            return function(input) {
                if (objectUtil.isNull(input) || isNaN(input)) {
                    return '';
                }
                
                return Number(input).toFixed(3);
            };
        }
    ]);
})();


(function() {
    angular.module('FGases.filters').filter('thousandSeparator', [
        
        'objectUtil',
        
        function(objectUtil) {
            var THOUSAND_SEPARATOR = ' ';
            var DECIMAL_SEPARATOR = '.';
            
            return function(input) {
                if (objectUtil.isNull(input) || isNaN(input)) {
                    return input;
                }
                
                var text = input.toString().trim();
                var parts = text.split(DECIMAL_SEPARATOR);
                var intPart = parts[0];
                var result = '';
                
                for (var i = 0; i < intPart.length; ++i) {
                    var digit = intPart.charAt(i);
                    
                    if ((intPart.length - i) % 3 === 0) {
                        result += THOUSAND_SEPARATOR;
                    }
                    
                    result += digit;
                }
                
                if (parts.length > 1) {
                    result += DECIMAL_SEPARATOR + parts[1];
                }
                
                return result;
            };
        }
    ]);
})();


(function() {
    
    window.angular.module('FGases.services.data').factory('dataPrefill', [
        
        'transactionYearProvider', 'reportStructureHelper', 'objectUtil', 'arrayUtil', 'numericUtil',
        
        function(transactionYearProvider, reportStructureHelper, objectUtil, arrayUtil, numericUtil) {
            
            function DataPrefill() { }
            
            DataPrefill.prototype.isPreviousReport = function(instance) {
                             
                return false;
            };
            
            DataPrefill.prototype.prefil = function(source, target, context) {
                this._copyAffiliations(source, target);
                this._copyActivities(source, target);
                this._copyTradePartners(source, target, context);
                this._copyReportedGases(source, target, context);
                this._copySection11TransactionSelection(source, target);
            };
            
            DataPrefill.prototype._copyAffiliations = function(source, target) {
                target.FGasesReporting.GeneralReportData.Company.Affiliations = source.FGasesReporting.GeneralReportData.Company.Affiliations;
            };
            
            DataPrefill.prototype._copyActivities = function(source, target) {
                target.FGasesReporting.GeneralReportData.Activities = source.FGasesReporting.GeneralReportData.Activities;
            };
            
            DataPrefill.prototype._copyTradePartners = function(source, target, context) {
                var tradePartnerContainersBySheet = reportStructureHelper.getTradePartnerContainers();
                
                arrayUtil.forEach(Object.getOwnPropertyNames(tradePartnerContainersBySheet), function(sheetName) {
                    var sourceSheet = source.FGasesReporting[sheetName];
                    var targetSheet = target.FGasesReporting[sheetName];
                    var tradePartnerContainerNames = tradePartnerContainersBySheet[sheetName];
                    
                    arrayUtil.forEach(tradePartnerContainerNames, function(tradePartnerContainerName) {
                        targetSheet[tradePartnerContainerName] = sourceSheet[tradePartnerContainerName];
                    });
                });
                
                arrayUtil.forEach(source.FGasesReporting.F4_S9_IssuedAuthQuata.tr_09A_TradePartners.Partner, function(tradePartner) {
                    var dummyModalResults = {
                        tempPartnerDefinition: tradePartner,
                        index: -1,
                        modalExtras: {
                            arrayToPush: target.FGasesReporting.F4_S9_IssuedAuthQuata.tr_09A_TradePartners.Partner,
                            emptyInstancePath: 'FGasesReporting.F4_S9_IssuedAuthQuata.tr_09A.TradePartner',
                            baseElement: target.FGasesReporting.F4_S9_IssuedAuthQuata,
                            fieldName: 'tr_09A'
                        }
                    };
                    context.scope.tradingPartnerModalWindowCloseCallBackForNonGasForm(dummyModalResults);
                });
                
            };
            
            DataPrefill.prototype._copyReportedGases = function(source, target, context) {
                arrayUtil.forEach(source.FGasesReporting.ReportedGases, function(reportedGas) {
                    context.scope.addGasForReporting(reportedGas);
                });
                
                arrayUtil.forEach(reportStructureHelper.getGasSelectionLists(), function(gasSelectionListName) {
                    target.FGasesReporting.GeneralReportData[gasSelectionListName] = source.FGasesReporting.GeneralReportData[gasSelectionListName];
                });
            };
            
            DataPrefill.prototype._copySection11TransactionSelection = function(source, target) {
                target.FGasesReporting.F7_s11EquImportTable.UISelectedTransactions = source.FGasesReporting.F7_s11EquImportTable.UISelectedTransactions;
            };
            
            return new DataPrefill();
        }
    ]);
})();


(function() {
    angular.module('FGases.services.data').factory('dataProxy', [

        '$rootScope', '$http', 'objectUtil', 'arrayUtil', 'ParseFGasesReportingXml',

        function($rootScope, $http, objectUtil, arrayUtil, ParseFGasesReportingXml) {
            function DataProxy() { }

            DataProxy.prototype.getInstance = function() {
                var url = null;

                if (fileId){
                    url = getWebQUrl("/download/converted_user_file");
                } else{
                    // testing on non-production workflow
                    url = "verification-instance-test.xml";
                }

                return $http.get(url, {responseType: 'text', tracker : $rootScope.loadingTracker});
            };

            DataProxy.prototype.saveInstance = function(data) {
                var url = getWebQUrl("/saveXml");
                return $http.post(url, data, {tracker : $rootScope.loadingTracker});
            };

          /*  DataProxy.prototype.getFGases = function() {
                var convertedJsonGasUrl = "fgases-gases.xml?format=json";

                return $http.get(convertedJsonGasUrl, {tracker : $rootScope.loadingTracker});
            };*/

            DataProxy.prototype.getEmptyInstance = function() {
                //var url = 'fgases-instance-empty-2024.xml?format=json';
                var url = 'verification-instance-empty-2025.xml';
                return $http.get(url, {responseType: 'text', tracker : $rootScope.loadingTracker});
            };

            DataProxy.prototype.getInstanceMetadata = function() {
                var url = getWebQUrl("/file/info");
                return $http.get(url, {tracker : $rootScope.loadingTracker});
            };

            DataProxy.prototype.getCompanyData = function(companyId) {
                var url;
                // https://bdr-test.eionet.europa.eu/european_registry/organisation?id=9989
                var webqUri = getWebQUrl('/restProxy');
                if (!isTestSession) {
                    url = webqUri + "&uri=" +  encodeURIComponent(getDomain(envelope) + "/european_registry/organisation?id=" + companyId);
                }
                else {
                    url = 'fgases-company-info-test.json';
                }
                return $http.get(url, {tracker : $rootScope.loadingTracker});
            };

            DataProxy.prototype.getAuditorData = function () {

                var url;
                // https://bdr-test.eionet.europa.eu/fgases/fi/44420/col_fgas_ver/envz90lra/get_audit_metadata
                var webqUri = getWebQUrl('/restProxy');
                if (!isTestSession) {
                   // url = webqUri + "&uri=" + encodeURIComponent(getDomain(envelope) + "/european_registry/organisation?id=" +companyId);
                    url = webqUri + "&uri=" + encodeURIComponent(envelope + "/get_audit_metadata");
                }
                else {
                    url = 'get_audit_metadata.json';
                }
                return $http.get(url, { tracker: $rootScope.loadingTracker });
            };

            DataProxy.prototype.checkCompanyExistById = function(companyId) {
                var url;
                // https://bdr-test.eionet.europa.eu/european_registry/organisation?id=9989
                var webqUri = getWebQUrl('/restProxy');
                if (!isTestSession) {
                    url = webqUri + "&uri=" +  encodeURIComponent(getDomain(envelope) + "/european_registry/organisation_exists?id=" + companyId);
                }
                else {
                    url = 'fgases-company-reg-code-test.json';
                }
                return $http.get(url, {tracker : $rootScope.loadingTracker});
            };

            DataProxy.prototype.checkCompanyExistByIdAndName = function(companyId, companyName) {
                var url;
                // https://bdr-test.eionet.europa.eu/european_registry/organisation?id=9989
                var webqUri = getWebQUrl('/restProxy');
                if (!isTestSession) {
                    url = webqUri + "&uri=" + encodeURIComponent(getDomain(envelope) + "/european_registry/organisation_exists?id=" + companyId + "&name=" + encodeURIComponent(companyName));
                }
                else {
                    url = 'fgases-company-reg-code-test.json';
                }
                return $http.get(url, {tracker : $rootScope.loadingTracker});
            };

            DataProxy.prototype.checkCompanyExistByIdAndCountryCodeOrVat = function(companyId, countryCode, vat) {
                var url;
                // https://bdr-test.eionet.europa.eu/european_registry/organisation?id=9989
                var webqUri = getWebQUrl('/restProxy');
                if (!isTestSession) {
                    url = webqUri + "&uri=" +  encodeURIComponent(getDomain(envelope) + "/european_registry/organisation_exists?id=" + companyId + "&countrycode=" + countryCode + "&OR_vat=" + vat);
                }
                else {
                    url = 'fgases-company-reg-code-test.json';
                }
                return $http.get(url, {tracker : $rootScope.loadingTracker});
            };

            DataProxy.prototype.checkCompanyExistByIdOrNameOrVat = function(companyId, legalRepresentativeName, legalRepresentativeVat) {
                var url;
                // https://bdr-test.eionet.europa.eu/european_registry/organisation?id=9989
                var webqUri = getWebQUrl('/restProxy');
                if (!isTestSession) {
                    url = webqUri + "&uri=" +  encodeURIComponent(getDomain(envelope) + "/european_registry/organisation_exists?id=" + companyId + "&OR_name==" + encodeURIComponent(legalRepresentativeName) + "&OR_vat=" + legalRepresentativeVat);
                }
                else {
                    url = 'fgases-company-reg-code-test.json';
                }
                return $http.get(url, {tracker : $rootScope.loadingTracker});
            };

            DataProxy.prototype.checkCompanyExistByVat = function(vatCode) {
                var url;
                // https://bdr-test.eionet.europa.eu/european_registry/organisation?id=9989
                var webqUri = getWebQUrl('/restProxy');
                if (!isTestSession) {
                    url = webqUri + "&uri=" +  encodeURIComponent(getDomain(envelope) + "/european_registry/organisation_exists?vat=" + vatCode);
                }
                else {
                    url = 'fgases-company-vat-test.json';
                }
                return $http.get(url, {tracker : $rootScope.loadingTracker});
            };

            DataProxy.prototype.checkCompanyExistByVatAndName = function(vatCode, companyName) {
                var url;
                // https://bdr-test.eionet.europa.eu/european_registry/organisation?id=9989
                var webqUri = getWebQUrl('/restProxy');
                if (!isTestSession) {
                    url = webqUri + "&uri=" +  encodeURIComponent(getDomain(envelope) + "/european_registry/organisation_exists?vat=" + vatCode + "&name=" + encodeURIComponent(companyName)) ;
                }
                else {
                    url = 'fgases-company-vat-test.json';
                }
                return $http.get(url, {tracker : $rootScope.loadingTracker});
            };

            DataProxy.prototype.checkCompanyExistByNameAndCountryCode = function(companyName, countryCode) {
                var url;
                // https://bdr-test.eionet.europa.eu/european_registry/organisation?id=9989
                var webqUri = getWebQUrl('/restProxy');
                if (!isTestSession) {
                    url = webqUri + "&uri=" +  encodeURIComponent(getDomain(envelope) + "/european_registry/organisation_exists?name=" + encodeURIComponent(companyName) + "&countrycode=" + countryCode) ;
                }
                else {
                    url = 'fgases-company-vat-test.json';
                }
                return $http.get(url, {tracker : $rootScope.loadingTracker});
            };

            DataProxy.prototype.getRegistryData = function(companyId, transactionYear, onSuccess, onError) {
                var xmlUri, xsltUri;

                if (isTestSession) {
                    xmlUri = "https://converterstest.eionet.europa.eu/xmlfile/fgases-extra-registry-data-test.xml";
                    xsltUri = "https://converterstest.eionet.europa.eu/xsl/fgases-extra-registry-data.xsl";
                }
                else {
                    xmlUri = getDomain(envelope) + "/xmlexports/fgases/fgases-extra-registry-data-" + transactionYear + ".xml";
                    xsltUri = "https://convertersbdr.eionet.europa.eu/xsl/fgases-extra-registry-data.xsl";
                }

                this._getDataByXsltConversion(companyId, xmlUri, xsltUri).success(function(data) {
                    objectUtil.call(onSuccess, data);
                }).error(onError);
            };

            DataProxy.prototype.getAuthorisationData = function(companyId, transactionYear, onSuccess, onError) {
                var xmlUri, xsltUri;

                if (isTestSession) {
                    xmlUri = "https://converterstest.eionet.europa.eu/xmlfile/fgases-authorisations-test.xml";
                    xsltUri = "https://converterstest.eionet.europa.eu/xsl/fgases-authorisations.xsl";
                }
                else {
                    xmlUri = getDomain(envelope) + "/xmlexports/fgases/fgases-authorisations-" + transactionYear + ".xml";
                    xsltUri = "https://convertersbdr.eionet.europa.eu/xsl/fgases-authorisations.xsl";
                }

                this._getDataByXsltConversion(companyId, xmlUri, xsltUri)
                  .success(function(data) {
                    objectUtil.call(onSuccess, data);
                  })
                  .error(onError);

            };

            DataProxy.prototype.getLabelsFile = function(filename) {
               /* var resourceUrl = filename + '.xml?format=json';
                return $http.get(resourceUrl, {tracker : $rootScope.loadingTracker});*/
                 var url = filename + '.json?';
                return $http.get(url, { tracker: $rootScope.loadingTracker });
            };

            DataProxy.prototype._getDataByXsltConversion = function(companyId, xmlUri, xsltUri, params) {
                var webqUri;

                if (isTestSession) {
                    webqUri = baseUri + "/proxyXmlWithConversion?fileId=0";
                }
                else {
                    webqUri = getWebQUrl('/proxyXmlWithConversion');
                }

                var url = webqUri + "&xmlUri=" + xmlUri + "&xsltUri=" + xsltUri + "&format=json&companyId=" + companyId;
                var extraParams = objectUtil.isNull(params) ? { } : params;

                arrayUtil.forEach(Object.getOwnPropertyNames(extraParams), function(paramName) {
                    var paramValue = extraParams[paramName];

                    if (!objectUtil.isNull(paramValue)) {
                        url += "&" + paramName + "=" + paramValue;
                    }
                });

                return $http.get(url, { tracker : $rootScope.loadingTracker });
            };

            DataProxy.prototype.getFGasesReportingXmlUrl = function(dataReportUrl) {
                var url;
                var webqUri = getWebQUrl('/restProxy');
                if (!isTestSession) {
                    url = webqUri + "&uri=" + encodeURIComponent(`${dataReportUrl}/xml`);
                    return $http.get(url, {tracker : $rootScope.loadingTracker})
                        .then(response => new window.DOMParser().parseFromString(response.data, "text/xml"))
                        .then(xmlNode => xmlNode.querySelectorAll('envelope file')[0].getAttribute('link'));
                }
                else {
                    url = 'fgases-reporting.json';
                    return $http.get(url, {tracker : $rootScope.loadingTracker});
                }
            };

            DataProxy.prototype.getFGasesReporting = function(xml_url) {
                var url;
                var webqUri = getWebQUrl('/restProxy');
                if (!isTestSession) {
                    url = webqUri + "&uri=" + encodeURIComponent(xml_url);
                    return $http.get(url, {tracker : $rootScope.loadingTracker})
                        .then(response => new window.DOMParser().parseFromString(response.data, "text/xml"))
                        .then(FGasesReportingNode => ParseFGasesReportingXml.parse(FGasesReportingNode));
                }
                else {
                    url = 'fgases-reporting.json';
                    return $http.get(url, {tracker : $rootScope.loadingTracker})
                        .then(response => response.data);
                }
            };

            return new DataProxy();
        }
    ]);
})();


(function() {
    // get instance data and save instance data
    angular.module('FGases.services.data').factory('dataRepository', [

        '$rootScope', '$http', 'FormConstants', 'dataProxy', 'jsonNormalizer', 'objectUtil', 'arrayUtil', 'numericUtil', 'stringUtil',

        function($rootScope, $http, FormConstants, dataProxy, jsonNormalizer, objectUtil, arrayUtil, numericUtil, stringUtil) {
            var codeLists = {};
            //var fgasesVocabularySetBaseUri = "http://localhost:8080/datadict/vocabulary/fgases/"; //DD_VOCABULARY_BASE_URI + 'fgases/';
            //var vocabularies = ['HFCGases', 'PFCGases', 'SF6Gases', 'UnsaturatedHFCAndHCFCGases', 'FluorinatedEthersAlcohols', 'OtherPrefluorinatedCompounds', 'CommonlyUsedMixtures', 'GasListForMixtureDefinition'];
            var commonVocabularySetBaseUri = "https://dd.eionet.europa.eu/vocabulary/fgases/"; //DD_VOCABULARY_BASE_URI + 'common/'
            var commonVocabularies = ['countries'];
            //create a container
            var codeListDefinitionVocabSets = [{"base": commonVocabularySetBaseUri, "vocabs": commonVocabularies}];

            //define undefined members
            codeLists.FGasesCodelists = {};
            for (var i = 0; i < codeListDefinitionVocabSets.length; i++){
                for (var j = 0; j < codeListDefinitionVocabSets[i].vocabs.length; j++) {
                    codeLists.FGasesCodelists[codeListDefinitionVocabSets[i].vocabs[j]] = {};
                }
            }
            codeLists.FGasesCodelists.FGases = {};
            codeLists.FGasesCodelists.AllFGases = {};
            codeLists.FGasesCodelists.FGasesOrderedAndFilteredForMixtureDefinition = {};
            codeLists.FGasesCodelists.FGasesOrderedAndFilteredForMixtureDefinition.Gas = [];
            codeLists.FGasesCodelists.NonFGasesOrderedAndFilteredForMixtureDefinition = {};
            codeLists.FGasesCodelists.NonFGasesOrderedAndFilteredForMixtureDefinition.Gas = [];
            

            return {
                _registryDataPerYear: { },
                _authorisationData: null,

                getInstance: function() {
                    return dataProxy.getInstance();
                },
                saveInstanceXml: function (data) {
                    return dataProxy.saveInstance(data);
                },
                getCodeList: function() {
                    return codeLists;
                },
                loadCodeList: function(language) {
                    //finds file in project folder
                    var defaultlanguage = 'en';
                    var currentLanguage = !language? defaultlanguage : language;

                    //get codelists of fgases webform
                    for (var i = 0; i < codeListDefinitionVocabSets.length; i++){
                        var baseUriOfVocabulary = codeListDefinitionVocabSets[i].base;
                        for (var j = 0; j < codeListDefinitionVocabSets[i].vocabs.length; j++) {
                            var vocabularyIdentifier = codeListDefinitionVocabSets[i].vocabs[j];
                            var url =  baseUriOfVocabulary + vocabularyIdentifier + '/json?lang=' + currentLanguage;

                            if ($rootScope.isIE9 || window.isIE9){
                                url = baseUri + '/restProxy?uri=' + encodeURIComponent(url);
                            }

                            $http.get(url, {tracker: $rootScope.loadingTracker})
                                .error((function(vocabularyIdentifier){return function(data, status, headers, config){
                                    alert("Failed to read code lists '" + vocabularyIdentifier + "'. Data = " +  data + ", status = " + status);
                                    angular.copy(dummyGasList, codeLists.FGasesCodelists[vocabularyIdentifier]);
                                }})(vocabularyIdentifier))
                                .success((function(vocabularyIdentifier){return function (newCodeList) {
                                    codeLists.FGasesCodelists[vocabularyIdentifier] = {concepts:[]};
                                    if (vocabularyIdentifier == 'countries') {
                                        // ignore EU countries - QC 1066
                                        angular.forEach(newCodeList.concepts, function (concept) {
                                            if ($rootScope.euCountries.indexOf(concept['@id']) == -1) {
                                                /*if (["AX", "GF", "GP", "MQ", "RE", "MF"].indexOf(concept['@id']) == -1) {
                                                    this.push(concept);
                                                }*/
                                                if ((["GB"].indexOf(concept['@id']) == -1)) { //don't include United Kingdom
                                                    this.push(concept);
                                                    $rootScope.allNonEUCountries.push(concept);
                                                }

                                            } else {
                                                $rootScope.allEUCountries.push(concept);
                                            }
                                  
                                        }, codeLists.FGasesCodelists[vocabularyIdentifier].concepts);
                                        var nonSpecifiedCountryConcept = {
                                            '@id': '00',
                                            '@type':'skos:Concept',
                                            prefLabel:[{
                                                '@value':'EU intermediate storage under customs warehousing after inward processing'
                                            }]
                                        };
                                         $rootScope.allNonEUCountries.push(nonSpecifiedCountryConcept);
                                        //$rootScope.nonEuCountries = angular.copy(codeLists.FGasesCodelists[vocabularyIdentifier]);
                                    }
                                    else {
                                        angular.copy(newCodeList, codeLists.FGasesCodelists[vocabularyIdentifier]);
                                    }
                                }})(vocabularyIdentifier));
                        }
                    }
                },
               /* loadFGases: function() {
                    dataProxy.getFGases().success(function (data) {
                        angular.copy(data.FGases, codeLists.FGasesCodelists.AllFGases);
                        codeLists.FGasesCodelists.FGases.Gas = [];
                        codeLists.FGasesCodelists.FGases.Component = [];
                        angular.copy(data.FGases.Component, codeLists.FGasesCodelists.FGases.Component);
                        var fgasGroups = [FormConstants.HFCsGasGroupId, FormConstants.UnsaturatedHFCsHCFCGasGroupId, FormConstants.PFCsGasGroupId, FormConstants.SF6GasGroupId, FormConstants.InhalationGasGroupId, FormConstants.NF3GasGroupId,  FormConstants.FluorinatedEthersAlcoholsGasGroupId, FormConstants.OtherPrefluorinatedCompoundsGasGroupId];
                        for (var j = 0; j < codeLists.FGasesCodelists.AllFGases.Gas.length; j++) {
                            var gas = codeLists.FGasesCodelists.AllFGases.Gas[j];
                            if (gas && gas.IsShortlisted === true) {
                                codeLists.FGasesCodelists.FGases.Gas.push(gas);
                            }
                        }
                        // Filter for mixture definition gases
                        for (var i = 0; i < fgasGroups.length; i++){
                            var groupId = fgasGroups[i];
                            for (var j = 0; j < codeLists.FGasesCodelists.FGases.Gas.length; j++){
                                var gas = codeLists.FGasesCodelists.FGases.Gas[j];
                                if (gas.GasGroupId == groupId){
                                    codeLists.FGasesCodelists.FGasesOrderedAndFilteredForMixtureDefinition.Gas.push(gas);
                                }
                            }
                        }
                        // Filter for non-fluorinated gases
                        var fgasGroupsNonFluor = FormConstants.NonFluorinatedRefrigerantsGasGroupId;
                        for (var i = 0; i < fgasGroupsNonFluor.length; i++) {
                            var groupId = fgasGroupsNonFluor[i];
                            for (var j = 0; j < codeLists.FGasesCodelists.FGases.Gas.length; j++) {
                                var gas = codeLists.FGasesCodelists.FGases.Gas[j];
                                if (gas.GasGroupId == groupId) {
                                    codeLists.FGasesCodelists.NonFGasesOrderedAndFilteredForMixtureDefinition.Gas.push(gas);
                                }
                            }
                        }

                    }).error(function (data) {
                        alert("Failed to read FGases lists. Data = " +  data + ", status = " + status);
                    });
                },*/
                getEmptyInstance: function() {
                    return dataProxy.getEmptyInstance();
                },
                loadInstanceInfo: function() {
                    return dataProxy.getInstanceMetadata();
                },
                getCompanyData: function(companyId) {
                    return dataProxy.getCompanyData(companyId);
                },
                getAuditorData: function () {
                    return dataProxy.getAuditorData();
                },
                checkCompanyExistById: function(companyId) {
                    return dataProxy.checkCompanyExistById(companyId);
                },
                checkCompanyExistByIdAndName: function(companyId, companyName) {
                    return dataProxy.checkCompanyExistByIdAndName(companyId, companyName);
                },
                checkCompanyExistByIdAndCountryCodeOrVat: function(companyId, countryCode, vat) {
                    return dataProxy.checkCompanyExistByIdAndCountryCodeOrVat(companyId, countryCode, vat);
                },
                checkCompanyExistByIdOrNameOrVat: function(companyId, legalRepresentativeName, legalRepresentativeVat) {
                    return dataProxy.checkCompanyExistByIdOrNameOrVat(companyId, legalRepresentativeName, legalRepresentativeVat);
                },
                checkCompanyExistByVat: function(vatCode) {
                    return dataProxy.checkCompanyExistByVat(vatCode);
                },
                checkCompanyExistByVatAndName: function(vatCode, companyName) {
                    return dataProxy.checkCompanyExistByVatAndName(vatCode, companyName);
                },
                checkCompanyExistByNameAndCountryCode: function(companyName, countryCode) {
                    return dataProxy.checkCompanyExistByNameAndCountryCode(companyName, countryCode);
                },
                getRegistryData: function(companyId, transactionYear, onSuccess, onError) {
                    if (!objectUtil.isNull(this._registryDataPerYear[transactionYear])) {
                        objectUtil.call(onSuccess, this._registryDataPerYear[transactionYear]);
                        return;
                    }

                    var that = this;
                    dataProxy.getRegistryData(companyId, transactionYear, function(data) {
                        if (objectUtil.isNull(data.registryData)) {
                            objectUtil.call(onError);
                            return;
                        }

                        var registryData = {
                            stocks: that._fixStocks(data.registryData),
                            quota: that._fixQuota(data.registryData),
                            large: that._fixLargeStatus(data.registryData),
                            ner: that._fixNerStatus(data.registryData)
                        };
                        that._registryDataPerYear[transactionYear] = registryData;
                        objectUtil.call(onSuccess, registryData);
                    }, onError);
                },
                getAuthorisationData: function(companyId, transactionYear, onSuccess, onError) {
                    if (!objectUtil.isNull(this._authorisationData)) {
                        objectUtil.call(onSuccess, this._authorisationData);
                        return;
                    }
                    var that = this;
                    dataProxy.getAuthorisationData(companyId, transactionYear, function(data) {
                        if (objectUtil.isNull(data)) {
                            objectUtil.call(onError);
                            return;
                        }

                        that._authorisationData = data.authorisation;
                        objectUtil.call(onSuccess, data);
                    }, onError);
                },
                _fixStocks: function(companyData) {
                    jsonNormalizer.normalizeObjectProperty(companyData, 'stocks');
                    jsonNormalizer.normalizeArrayProperty(companyData.stocks, 'stock');
                    return arrayUtil.map(companyData.stocks.stock, function(stock) {
                        return {
                            transactionCode: stock.transactionCode,
                            gasId: numericUtil.toNum(stock.gasId),
                            gasName: stock.gasName,
                            amount: numericUtil.toNum(stock.amount)
                        };
                    });
                },
                _fixQuota: function(companyData) {
                    jsonNormalizer.normalizeObjectProperty(companyData, 'quota');
                    var quota = { };
                    quota.allocatedQuota = numericUtil.toNum(companyData.quota.allocatedQuota); // 9A_registry
                    quota.allocatedQuotaDate = companyData.quota.allocatedQuotaDate;
                    quota.availableQuota = numericUtil.toNum(companyData.quota.availableQuota); // 9G
                    quota.availableQuotaDate = companyData.quota.availableQuotaDate;
                    if (typeof (quota.allocatedQuotaDate) == "undefined") {
                        quota.allocatedQuotaDate = null;
                    }

                    jsonNormalizer.normalizeArrayProperty(companyData.quota, 'quota9A_imp');
                    quota.quota9A_imp = companyData.quota.quota9A_imp;
                    var baseDate = Date.now();

                    arrayUtil.forEach(quota.quota9A_imp, function(quotaEntry) {
                        quotaEntry.amount = Number(quotaEntry.amount);
                        quotaEntry.tradePartner.PartnerId = "TradePartner_" + baseDate++;
                        quotaEntry.tradePartner.isEUBased = !stringUtil.isBlank(quotaEntry.tradePartner.EUVAT);
                        quotaEntry.tradePartner.QCWarning = [];
                    });

                    return quota;
                },
                _fixLargeStatus: function(companyData) {
                    return objectUtil.isNull(companyData.large) ? false : companyData.large;
                },
                _fixNerStatus: function(companyData) {
                    return objectUtil.isNull(companyData.ner) ? false : companyData.ner;
                },
                getFGasesReportingXmlUrl: function(dataReportUrl) {
                    return dataProxy.getFGasesReportingXmlUrl(dataReportUrl);
                },
                getFGasesReporting: function(xml_url) {
                    return dataProxy.getFGasesReporting(xml_url);
                }
            };
        }
    ]);
})();


(function() {
    
    window.angular.module('FGases.services.data').factory('jsonNormalizer', [
        
        'objectUtil',
        
        function(objectUtil) {
            
            function JsonNormalizer() { }
            
            JsonNormalizer.prototype.normalizeObjectProperty = function(obj, propertyName) {
                if (objectUtil.isNull(obj[propertyName])) {
                    obj[propertyName] = new Object();
                }
            };
            
            JsonNormalizer.prototype.normalizeArrayProperty = function(obj, propertyName, excludeValuePredicate) {
                var propertyValue = obj[propertyName];

                if (objectUtil.isNull(propertyValue)) {
                    obj[propertyName] = [];
                    return;
                }

                if (window.angular.isArray(propertyValue)) {
                    return;
                }

                var arrayValue = [];
                
                if (objectUtil.isNull(excludeValuePredicate) || !excludeValuePredicate.call(null, propertyValue)) {
                    arrayValue.push(propertyValue);
                }
                
                obj[propertyName] = arrayValue;
            };
            
            JsonNormalizer.prototype.getArrayPropertyValue = function(obj, propertyName) {
                var propertyValue = obj[propertyName];

                if (objectUtil.isNull(propertyValue)) {
                    return [];
                }

                if (window.angular.isArray(propertyValue)) {
                    return propertyValue;
                }

                return [ propertyValue ];
            };
            
            return new JsonNormalizer();
        }
    ]);
})();

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
                    'tr_05C',
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
                ];
                let transactions_xpath_tr11_to_tr13 = [
                    'tr_11G',
                    'tr_11J1',
                    'tr_11R',
                    'tr_11P',
                    'tr_12A',
                    'tr_12aA',
                    'tr_12B',                   
                    'tr_12aB',
                    'tr_13D',
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
                    if (transaction_id == 'tr_05C') {
                        continue;
                    }
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
                            else if (transactionNone.querySelector('SumOfPartnersAmount'))
                                typeOfAmount = 'SumOfPartnersAmount';
                            else
                                typeOfAmount = 'Amount';
                            for (const amountNode of transactionNone.querySelectorAll(typeOfAmount)) {
                                let amount = parseFloat(amountNode.textContent) || undefined;
                                if (transaction_id == "tr_5C_exempted_CO2e") {
                                    if (amount == 0.000)
                                        FGasesReporting.Transactions.get(transaction_id).tco2e = round(amount) || 0;
                                    else FGasesReporting.Transactions.get(transaction_id).tco2e = amount || 0;
                                }
                                else if (transaction_id == "tr_05C") {
                                    let gas = FGasesReporting.Transactions.get("tr_5C_exempted_CO2e").gases.get(gas_id);
                                    if (FGasesReporting.Transactions.get("tr_5C_exempted_CO2e").gases.get(gas_id) == 0.000)
                                        if (gas) gas.amount = round(amount) || 0;
                                     else if (gas) gas.amount = amount || 0;
                                }
                                else if (amount && FGasesReporting.Transactions.get(transaction_id).gases.has(gas_id)) {
                                    if (FGasesReporting.Transactions.get(transaction_id).gases.get(gas_id).amount == undefined) {
                                        FGasesReporting.Transactions.get(transaction_id).gases.get(gas_id).amount = amount;
                                    }
                                    else {
                                        FGasesReporting.Transactions.get(transaction_id).gases.get(gas_id).amount += amount;
                                    }
                                }
                            }
                        }
                    }
                }
                // Calculated: [5I = 5A + 5B + 5C_exempted + 5D + 5E]
                for (const [gas_id, gas] of FGasesReporting.Transactions.get('tr_05I').gases) {
                    let amount_5A = FGasesReporting.Transactions.get('tr_05A').gases.get(gas_id).amount || 0;
                    let amount_5B = FGasesReporting.Transactions.get('tr_05B').gases.get(gas_id).amount || 0;
                    let amount_5C_exempted = Math.round(FGasesReporting.Transactions.get('tr_5C_exempted_CO2e').gases.get(gas_id).amount) || 0;
                    let amount_5D = FGasesReporting.Transactions.get('tr_05D').gases.get(gas_id).amount || 0;
                    let amount_5E = FGasesReporting.Transactions.get('tr_05E').gases.get(gas_id).amount || 0;
                    gas.amount = amount_5A + amount_5B + amount_5C_exempted + amount_5D + amount_5E;
                    if (gas.amount == 0) gas.amount = undefined;
                }
                // Calculated: [5J = 4M – 5I]
                for (const [gas_id, gas] of FGasesReporting.Transactions.get('tr_05J').gases) {
                    let amount_4M = FGasesReporting.Transactions.get('tr_04M').gases.get(gas_id).amount || 0;
                    let amount_5I = FGasesReporting.Transactions.get('tr_05I').gases.get(gas_id).amount || 0;
                    gas.amount = amount_4M - amount_5I;
                    if (gas.amount == 0) gas.amount = undefined;
                }
                
                // Calculated: [13D = 12C = 11_R - 12A -12aA - 12B - 12aB]
                for (const [gas_id, gas] of FGasesReporting.Transactions.get('tr_13D').gases) {
                    let amount_11R = FGasesReporting.Transactions.get('tr_11R').gases.get(gas_id).amount || 0;
                    let amount_12A = FGasesReporting.Transactions.get('tr_12A').gases.get(gas_id).amount || 0;0
                    let amount_12aA = FGasesReporting.Transactions.get('tr_12aA').gases.get(gas_id).amount || 0;
                    let amount_12B = FGasesReporting.Transactions.get('tr_12B').gases.get(gas_id).amount || 0;
                    let amount_12aB = FGasesReporting.Transactions.get('tr_12aB').gases.get(gas_id).amount || 0;
                    gas.amount = amount_11R - amount_12A - amount_12aA - amount_12B - amount_12aB;
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
                    // ['tr_09A SumOfPartnerAmounts', 'tr_09A'],
                    ['tr_09C Amount', 'tr_09C'],
                    // ['tr_09F Amount', 'tr_09F'],
                    // ['tr_09E Amount', 'tr_05J'],
                ];
                for (const [from, to] of tcoe2_pairs) {
                    tco2e = parseFloat(FGasesReportingNode.querySelector(from)?.textContent | 0).toFixed(0);
                    FGasesReporting.Transactions.get(to).tco2e = tco2e;
                }
                
                // Calculated: [9A = 9A_imp + 9A_add]
                FGasesReporting.Transactions.get('tr_09A').tco2e = parseFloat(FGasesReporting.Transactions.get('tr_09A_imp').tco2e) +
                    parseFloat(FGasesReporting.Transactions.get('tr_09A_add').tco2e);
                // Calculated: [9F = 5J + 9A]
                FGasesReporting.Transactions.get('tr_09F').tco2e = FGasesReporting.Transactions.get('tr_05J').tco2e +
                    FGasesReporting.Transactions.get('tr_09A').tco2e;


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

                // Remove ReportedGases that not (11_G>0 or 11_P>0 or 11_J1>0)
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
                // Find ReportedGases that not (11_G>0 or 11_P>0 or 11_J1>0)
                let gas_ids_to_remove = [];
                for (const [gas_id, reportedGas] of FGasesReporting.ReportedGases) {
                    let amount_11G = undefined;
                    let amount_11P = undefined;
                    let amount_11J1 = undefined;

                    for (const [transaction_id, transaction] of FGasesReporting.Transactions) {
                        for (const [gas_id, gas] of transaction.gases) {
                            if (gas_id == reportedGas.GasId) {
                                if (transaction_id == 'tr_11G') { amount_11G = parseFloat(gas.amount); break}
                                if (transaction_id == 'tr_11P') { amount_11P = parseFloat(gas.amount); break}
                                if (transaction_id == 'tr_11J1') { amount_11J1 = parseFloat(gas.amount); break}
                            }
                        }
                    }
                    if (!((amount_11G > 0) || (amount_11P > 0) || (amount_11J1 > 0))) {
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


(function() {
    
    window.angular.module('FGases.services.data').factory('reportStructureNormalizer', [
        
        'jsonNormalizer', 'reportStructureHelper', 'arrayUtil', 'objectUtil',
        
        function(jsonNormalizer, reportStructureHelper, arrayUtil, objectUtil) {
            
            function ReportStructureNormalizer() { }
            
            ReportStructureNormalizer.prototype.normalize = function(instance) {
               // this._normalizeGasSelectionLists(instance);
               // jsonNormalizer.normalizeArrayProperty(instance.Verification.GeneralReportData.Company.ContactPersons, 'ContactPerson');
               // jsonNormalizer.normalizeArrayProperty(instance.FGasesReporting, 'ReportedGases');
               // this._normalizeCompanyAffiliations(instance);
              //  this._normalizeTradePartnerContainers(instance);
              //  this._normalizeGasIncludingSheets(instance);
              //  this._normalizeTradePartnerTransactions(instance);
              //  this._normalizeSheet4(instance);
              //  jsonNormalizer.normalizeObjectProperty(instance.FGasesReporting, 'unusualGasChoises');
             //   jsonNormalizer.normalizeObjectProperty(instance.FGasesReporting, 'attachedCompanyData');
              //  jsonNormalizer.normalizeObjectProperty(instance.FGasesReporting.attachedCompanyData, 'stocks');
            };
            
           /* ReportStructureNormalizer.prototype._normalizeGasSelectionLists = function(instance) {
                arrayUtil.forEach(reportStructureHelper.getGasSelectionLists(), function(gasSelectionListName) {
                    jsonNormalizer.normalizeObjectProperty(instance.FGasesReporting.GeneralReportData, gasSelectionListName);
                    jsonNormalizer.normalizeArrayProperty(instance.FGasesReporting.GeneralReportData[gasSelectionListName], 'GasName');
                });
            };*/
            
           /* ReportStructureNormalizer.prototype._normalizeCompanyAffiliations = function(instance) {
                jsonNormalizer.normalizeObjectProperty(instance.FGasesReporting.GeneralReportData.Company, 'Affiliations');
                jsonNormalizer.normalizeArrayProperty(instance.FGasesReporting.GeneralReportData.Company.Affiliations, 'Affiliation', function(affiliation) {
                    return objectUtil.isNull(affiliation.CompanyName);
                });
            };*/
            
          /*  ReportStructureNormalizer.prototype._normalizeTradePartnerContainers = function(instance) {
                var tradePartnerContainersBySheet = reportStructureHelper.getTradePartnerContainers();
                
                arrayUtil.forEach(Object.getOwnPropertyNames(tradePartnerContainersBySheet), function(sheetName) {
                    jsonNormalizer.normalizeObjectProperty(instance.FGasesReporting, sheetName);
                    var sheet = instance.FGasesReporting[sheetName];
                    var tradePartnerContainerNames = tradePartnerContainersBySheet[sheetName];
                    
                    arrayUtil.forEach(tradePartnerContainerNames, function(tradePartnerContainerName) {
                        jsonNormalizer.normalizeObjectProperty(sheet, tradePartnerContainerName);
                        jsonNormalizer.normalizeArrayProperty(sheet[tradePartnerContainerName], 'Partner');
                    });
                });
            };*/
            
          /*  ReportStructureNormalizer.prototype._normalizeGasIncludingSheets = function(instance) {
                arrayUtil.forEach(reportStructureHelper.getGasIncludingSheets(), function(sheetName) {
                    jsonNormalizer.normalizeObjectProperty(instance.FGasesReporting, sheetName);
                    jsonNormalizer.normalizeArrayProperty(instance.FGasesReporting[sheetName], 'Gas', function(gas) {
                        return objectUtil.isNull(gas.GasCode);
                    });
                });
            };*/
            
           /* ReportStructureNormalizer.prototype._normalizeTradePartnerTransactions = function(instance) {
                var tradePartnerTransactionsBySheet = reportStructureHelper.getTradePartnerTransactions();
                
                arrayUtil.forEach(Object.getOwnPropertyNames(tradePartnerTransactionsBySheet), function(sheetName) {
                    jsonNormalizer.normalizeObjectProperty(instance.FGasesReporting, sheetName);
                    var sheet = instance.FGasesReporting[sheetName];
                    var tradePartnerTransactionNames = tradePartnerTransactionsBySheet[sheetName];
                    
                    arrayUtil.forEach(sheet.Gas, function(gasAmount) {
                        arrayUtil.forEach(tradePartnerTransactionNames, function(transactionName) {
                            jsonNormalizer.normalizeObjectProperty(gasAmount, transactionName);
                            jsonNormalizer.normalizeArrayProperty(gasAmount[transactionName], 'TradePartner', function(tradePartnerAmount) {
                                return objectUtil.isNull(tradePartnerAmount.TradePartnerID);
                            });
                        });
                    });
                });
            };*/
            
          /*  ReportStructureNormalizer.prototype._normalizeSheet4 = function(instance) {
                this._normalizeSheet4TradePartnerField(instance, '09A_imp');
                this._normalizeSheet4TradePartnerField(instance, '09A_add');
                this._normalizeSheet4_9A(instance);

            };*/
            
           /* ReportStructureNormalizer.prototype._normalizeSheet4TradePartnerField = function(instance, transactionCode) {
                var transactionFieldName = 'tr_' + transactionCode;
                
                if (objectUtil.isNull(instance.FGasesReporting.F4_S9_IssuedAuthQuata[transactionFieldName])) {
                    instance.FGasesReporting.F4_S9_IssuedAuthQuata[transactionFieldName] = {
                        Code: transactionCode,
                        SumOfPartnerAmounts: null,
                        Unit: null,
                        Comment: null,
                        TradePartner: []
                    };
                }
                else {
                    jsonNormalizer.normalizeArrayProperty(instance.FGasesReporting.F4_S9_IssuedAuthQuata[transactionFieldName], 'TradePartner', function(tradePartnerAmount) {
                        return objectUtil.isNull(tradePartnerAmount.TradePartnerID);
                    });
                }
                
                var tradePartnerFieldName = transactionFieldName + '_TradePartners';
                
                if (objectUtil.isNull(instance.FGasesReporting.F4_S9_IssuedAuthQuata[tradePartnerFieldName])) {
                    instance.FGasesReporting.F4_S9_IssuedAuthQuata[tradePartnerFieldName] = { Partner: [] };
                }
                else {
                    jsonNormalizer.normalizeObjectProperty(instance.FGasesReporting.F4_S9_IssuedAuthQuata, tradePartnerFieldName);
                    jsonNormalizer.normalizeArrayProperty(instance.FGasesReporting.F4_S9_IssuedAuthQuata[tradePartnerFieldName], 'Partner');
                }
            };*/

          /*  ReportStructureNormalizer.prototype._normalizeSheet4_9A = function(instance) {
                // remove deprecated 9A Trade Partner values
                if ( instance.FGasesReporting.F4_S9_IssuedAuthQuata.tr_09A.TradePartner)
                     delete instance.FGasesReporting.F4_S9_IssuedAuthQuata.tr_09A.TradePartner ;

                instance.FGasesReporting.F4_S9_IssuedAuthQuata['tr_09A_TradePartners'] = {} ;

            };*/
            
         /*   ReportStructureNormalizer.prototype._normalizeSheet7 = function(instance) {
                jsonNormalizer.normalizeObjectProperty(instance.FGasesReporting.F7_s11EquImportTable, 'SupportingDocuments');
                jsonNormalizer.normalizeArrayProperty(instance.FGasesReporting.F7_s11EquImportTable.SupportingDocuments, 'Document', function(doc) {
                    return objectUtil.isNull(doc.Url);
                });
            };*/
            
            return new ReportStructureNormalizer();
        }
    ]);
})();


(function() {
    angular.module('FGases.services.data').factory('transactionYearProvider', [
        
        'viewModel', 'objectUtil', 'numericUtil',
        
        function(viewModel, objectUtil, numericUtil){
            var TransactionYearProvider = function() { };

            TransactionYearProvider.prototype.getTransactionYear = function() {
                var instanceYear = numericUtil.toNum(viewModel.getDataSource().Verification.VerificationScope.TransactionYear);
                
                return objectUtil.isNull(instanceYear) ? this._maxTransactionYear() : instanceYear; // TO CHANGE IN NEXT REPORTING
            };
            
            TransactionYearProvider.prototype.getValidTransactionYears = function() {
                var years = [];
                for (var year = 2015; year <= this._maxTransactionYear(); year++) { // TO CHANGE IN NEXT REPORTING
                    years.push(year);
                }
                
                return years;
            };
            
            TransactionYearProvider.prototype._maxTransactionYear = function () {
                return new Date().getFullYear() - 1;
            };

            return new TransactionYearProvider();
        }
    ]);
})();


(function() {
    //Includes method to focus and element with id
    angular.module('FGases.services.ui').factory('focus', function($timeout) {
        return function(id) {
            $timeout(function() {
                var element = document.getElementById(id);
                if(element) {
                    element.focus();
                }
            });
        };
    });
})();


(function() {
    //Includes method to focus and element with id
    angular.module('FGases.services.ui').factory('highlight', function($timeout) {
        return function(id, is_blocker) {
            $timeout(function() {
                var element = document.getElementById(id);
                if (element) {
                    let css_classes = ["alert", is_blocker ? "alert-danger" : "alert-warning"];
                    css_classes.forEach(css_class => element.classList.toggle(css_class));
                    $timeout(() => {
                        css_classes.forEach(css_class => element.classList.toggle(css_class));
                    }, 1000);
                }
            });
        };
    });
})();


(function() {
    
    window.angular.module('FGases.services.ui').factory('modalAdapter', [
        
        '$modal', 
        
        function ($modal) {
            return {
                open: function ($scope, size, templateUrl, controller, modalData, onConfirmCallback, onCancelCallback, extras) {
                    // if no callback is set , set empty function
                    onConfirmCallback = onConfirmCallback || angular.noop;
                    onCancelCallback = onCancelCallback || angular.noop;
                    //create modalInstance
                    var modalInstance = $modal.open({
                        templateUrl: templateUrl,
                        controller: controller,
                        keyboard: true,
                        backdrop: 'static',
                        size: size,
                        scope: $scope,
                        windowClass: 'app-modal-window',
                        resolve: {
                            modalData: function () {
                                return modalData;
                            },
                            modalExtras: function () {
                                return extras && typeof extras !== 'undefined' ? extras : {};
                            }
                        }
                    });
                    modalInstance.result.then(onConfirmCallback, onCancelCallback);
                }
            };
        }
    ]);
})();


(function() {
    angular.module('FGases.services.util').factory('arrayUtil', [
        
        'objectUtil',
        
        function(objectUtil) {
            function ArrayUtil() { }
            
            ArrayUtil.prototype.forEach = function(array, callback) {
                var loopContext = { breakLoop: false };
                
                for (var i = 0; i < array.length; ++i) {
                    loopContext.index = i;
                    objectUtil.call(callback, array[i], loopContext);
                    
                    if (loopContext.breakLoop) {
                        break;
                    }
                }
            };
            
            ArrayUtil.prototype.pushMany = function(array, items) {
                this.forEach(items, function(item) {
                    array.push(item);
                });
            };
            
            ArrayUtil.prototype.select = function(array, predicate) {
                var matches = [];
                this.forEach(array, function(item) {
                    if (objectUtil.call(predicate, item)) {
                        matches.push(item);
                    }
                });
                
                return matches;
            };
            
            ArrayUtil.prototype.selectSingle = function(array, predicate) {
                var index = this.indexOf(array, predicate);

                return index < 0 ? null : array[index];
            };
            
            ArrayUtil.prototype.contains = function(array, predicate) {
                return !objectUtil.isNull(this.selectSingle(array, predicate));
            };
            
            ArrayUtil.prototype.indexOf = function(array, predicate) {
                var index = -1;
                
                this.forEach(array, function(item, loopContext) {
                    if (objectUtil.call(predicate, item)) {
                        index = loopContext.index;
                        loopContext.breakLoop = true;
                    }
                });
                
                return index;
            };
            
            ArrayUtil.prototype.map = function(array, mapper) {
                var mapped = [];
                
                this.forEach(array, function(arrayItem, loopContext) {
                    var mappedItem = objectUtil.call(mapper, arrayItem, loopContext);
                    
                    if (!objectUtil.isNull(mappedItem)) {
                        mapped.push(mappedItem);
                    }
                });
                
                return mapped;
            };
            
            return new ArrayUtil();
        }
    ]);
})();


(function() {
    angular.module('FGases.services.util').factory('numericUtil', [
        
        'objectUtil',
        
        function(objectUtil) {
            
            function NumericUtil() { }
            
            NumericUtil.prototype.isNum = function(value) {
                return !objectUtil.isNull(value) && !isNaN(value);
            };
            
            NumericUtil.prototype.toNum = function(value, defaultValue) {
                if (!this.isNum(value)) {
                    return this.isNum(defaultValue) ? defaultValue : null;
                }
                
                return Number(value);
            };
            
            NumericUtil.prototype.sum = function(/* varargs */) {
                var result = null;
                
                for (var i = 0; i < arguments.length; i++) {
                    var value = arguments[i];
                    
                    if (!this.isNum(value)) {
                        continue;
                    }
                    
                    if (!this.isNum(result)) {
                        result = 0;
                    }
                    
                    result += value;
                }
                
                return result;
            };
            
            return new NumericUtil();
        }
    ]);
})();


(function() {
    angular.module('FGases.services.util').factory('objectUtil', [
        function() {
            function ObjectUtil() { }
            
            ObjectUtil.prototype.isNull = function(value) {
                return angular.isUndefined(value) || value === null;
            };
            
            ObjectUtil.prototype.defaultIfNull = function(value, defaultValue) {
                return this.isNull(value) ? defaultValue : value;
            };
            
            ObjectUtil.prototype.call = function(func) {
                if (!func) return;

                var args = [];

                for (var i = 1; i < arguments.length; ++i) {
                    args.push(arguments[i]);
                }

                return func.apply(null, args);
            };
            
            ObjectUtil.prototype.chainConstructor = function(sourceConstructor, targetConstructor) {
                this.chainPrototype(sourceConstructor.prototype, targetConstructor);
            };
            
            ObjectUtil.prototype.chainPrototype = function(sourcePrototype, targetConstructor) {
                targetConstructor.prototype = Object.create(sourcePrototype, {
                    constructor: {
                        configurable: true,
                        enumerable: true,
                        writable: true,
                        value: targetConstructor
                    }
                });
            };
            
            return new ObjectUtil();
        }
    ]);
})();


(function() {
    angular.module('FGases.services.util').factory('stringUtil', [
        'objectUtil',
        function(objectUtil) {
            function StringUtil() { }
            
            StringUtil.prototype.isEmpty = function(text) {
                return objectUtil.isNull(text) || text === '';
            };
            
            StringUtil.prototype.isBlank = function(text) {
                return this.isEmpty(text) || text.trim() === '';
            };
            
            StringUtil.prototype.toLowerCase = function(string) {
                if (this.isEmpty(string)) {
                    return string;
                }
                
                return string.toLowerCase();
            };
            
            StringUtil.prototype.toUpperCase = function(string) {
                if (this.isEmpty(string)) {
                    return string;
                }
                
                return string.toUpperCase();
            };
            
            StringUtil.prototype.equalsIgnoreCase = function(string1, string2) {
                return this.toUpperCase(string1) === this.toUpperCase(string2);
            };
            
            StringUtil.prototype.contains = function(text, searchText) {
                return text.indexOf(searchText) > -1;
            };
            
            StringUtil.prototype.startsWith = function(text, preffix) {
                if (preffix.length > text.length) {
                    return false;
                }
                
                return text.substring(0, preffix.length) === preffix;
            };
            
            return new StringUtil();
        }
    ]);
})();


(function() {
    angular.module('FGases.services.validation.qcs').factory('ConfirmValidator', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        
        function ($translate, sheetValidationObjectFactory,  sheetTransactionValidator) {
            
            function ConfirmValidator(transaction, label, table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                var that = this;
                this.transactionValidations = {
                    transaction: { id: transaction, label: label },
                    rules: [
                        that._createRuleQC3006(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier),
                        that._createRuleQC3007(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier),
                        that._createRuleQC3008(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier),
                        that._createRuleQC3009(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier),
                        that._createRuleQC3010(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier),
                    ]
                };
            }
            
            ConfirmValidator.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };

            ConfirmValidator._getSection = function(viewModel, sectionIdentifier) {
                let section = viewModel._instance.Verification;
                let tokens = sectionIdentifier.split(".");
                while (tokens.length) {
                    section = section[tokens.shift()];
                }
                return section;
            }
            
            ConfirmValidator.prototype._createRuleQC3006 = function(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3006',
                    _validate_confirmation_row: function(confirmation_row) {
                        return ((confirmation_row.confirmation_a.checked + confirmation_row.confirmation_b.checked + confirmation_row.confirmation_c.checked) == 1);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 1
                        let section1 = ConfirmValidator._getSection(viewModel, section1_Identifier);
                        if (!this._validate_confirmation_row(section1)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'confirmation';
                            result.errors.push(error);
                        }
                        // Section 2
                        let section2 = ConfirmValidator._getSection(viewModel, section2_Identifier);
                        for (const transaction_code in section2) {
                            // tr_11P has it own validator
                            if (transaction_code == 'tr_11P') { continue }
                            let confirmation_row = section2[transaction_code];
                            if (!this._validate_confirmation_row(confirmation_row)) {
                                error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                    table: table_name,
                                    section: section2_name,
                                });
                                error.gasIndex = `confirmation-${transaction_code}`;
                                result.errors.push(error);
                            }
                        }
                        return result;
                    }
                };
            };
            ConfirmValidator.prototype._createRuleQC3007 = function(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3007',
                    _validate_confirmation_b: function(confirmation_b) {
                        if (!confirmation_b.checked) return true;
                        return (confirmation_b.option_1 || confirmation_b.option_2 || confirmation_b.option_3 || confirmation_b.option_4);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 1
                        let section1 = ConfirmValidator._getSection(viewModel, section1_Identifier);
                        if (!this._validate_confirmation_b(section1.confirmation_b)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name
                            });
                            error.gasIndex = 'confirmation';
                            result.errors.push(error);
                        }
                        // Section 2
                        let section2 = ConfirmValidator._getSection(viewModel, section2_Identifier);
                        for (const transaction_code in section2) {
                            // tr_11P has it own validator
                            if (transaction_code == 'tr_11P') { continue }
                            let confirmation_b = section2[transaction_code].confirmation_b;
                            if (!this._validate_confirmation_b(confirmation_b)) {
                                error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                    table: table_name,
                                    section: section2_name,
                                });
                                error.gasIndex = `confirmation-${transaction_code}`;
                                result.errors.push(error);
                            }
                        }
                        // Section 3
                        /*let section3 = ConfirmValidator._getSection(viewModel, section3_Identifier);
                        if (!this._validate_confirmation_b(section3.confirmation_b)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'section-3-confirmation';
                            result.errors.push(error);
                        }*/
                        return result;
                    }
                };
            };
            ConfirmValidator.prototype._createRuleQC3008 = function(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3008',
                    _validate_confirmation_b4: function(confirmation_b) {
                        if (!confirmation_b.checked) return true;
                        if (!confirmation_b.option_4) return true;
                        return (!isEmpty(confirmation_b.option_4_reason) && confirmation_b.option_4_reason.length >= 5);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 1
                        let section1 = ConfirmValidator._getSection(viewModel, section1_Identifier);
                        if (!this._validate_confirmation_b4(section1.confirmation_b)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                                transaction: '',
                            });
                            error.gasIndex = 'confirmation';
                            result.errors.push(error);
                        }
                        // Section 2
                        let section2 = ConfirmValidator._getSection(viewModel, section2_Identifier);
                        for (const transaction_code in section2) {
                            // tr_11P has it own validator
                            if (transaction_code == 'tr_11P') { continue }
                            let confirmation_b = section2[transaction_code].confirmation_b;
                            if (!this._validate_confirmation_b4(confirmation_b)) {
                                error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                    table: table_name,
                                    section: section2_name,
                                });
                                error.gasIndex = `confirmation-${transaction_code}`;
                                result.errors.push(error);
                            }
                        }
                        // Section 3
                        /*let section3 = ConfirmValidator._getSection(viewModel, section3_Identifier);
                        if (!this._validate_confirmation_b4(section3.confirmation_b)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'section-3-confirmation';
                            result.errors.push(error);
                        }*/
                        return result;
                    }
                };
            };
            ConfirmValidator.prototype._createRuleQC3009 = function(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3009',
                    _validate_confirmation_c: function(confirmation_c) {
                        if (!confirmation_c.checked) return true;
                        return (confirmation_c.option_1 || confirmation_c.option_2 || confirmation_c.option_3 || confirmation_c.option_4);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 1
                        let section1 = ConfirmValidator._getSection(viewModel, section1_Identifier);
                        if (!this._validate_confirmation_c(section1.confirmation_c)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'confirmation';
                            result.errors.push(error);
                        }
                        // Section 2
                        let section2 = ConfirmValidator._getSection(viewModel, section2_Identifier);
                        for (const transaction_code in section2) {
                            // tr_11P has it own validator
                            if (transaction_code == 'tr_11P') { continue }
                            let confirmation_c = section2[transaction_code].confirmation_c;
                            if (!this._validate_confirmation_c(confirmation_c)) {
                                error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                    table: table_name,
                                    section: section2_name,
                                });
                                error.gasIndex = `confirmation-${transaction_code}`;
                                result.errors.push(error);
                            }
                        }
                        // Section 3
                        /*let section3 = ConfirmValidator._getSection(viewModel, section3_Identifier);
                        if (!this._validate_confirmation_c(section3.confirmation_c)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'section-3-confirmation';
                            result.errors.push(error);
                        }*/
                        return result;
                    }
                };
            };
            ConfirmValidator.prototype._createRuleQC3010 = function(table_name, section1_name, section2_name, section3_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3010',
                    _validate_confirmation_c4: function(confirmation_c) {
                        if (!confirmation_c.checked) return true;
                        if (!confirmation_c.option_4) return true;
                        return (!isEmpty(confirmation_c.option_4_reason) && confirmation_c.option_4_reason.length >= 5);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 1
                        let section1 = ConfirmValidator._getSection(viewModel, section1_Identifier);
                        if (!this._validate_confirmation_c4(section1.confirmation_c)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'confirmation';
                            result.errors.push(error);
                        }
                        // Section 2
                        let section2 = ConfirmValidator._getSection(viewModel, section2_Identifier);
                        for (const transaction_code in section2) {
                            // tr_11P has it own validator
                            if (transaction_code == 'tr_11P') { continue }
                            let confirmation_c = section2[transaction_code].confirmation_c;
                            if (!this._validate_confirmation_c4(confirmation_c)) {
                                error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                    table: table_name,
                                    section: section2_name,
                                });
                                error.gasIndex = `confirmation-${transaction_code}`;
                                result.errors.push(error);
                            }
                        }
                        // Section 3
                        /*let section3 = ConfirmValidator._getSection(viewModel, section3_Identifier);
                        if (!this._validate_confirmation_c4(section3.confirmation_c)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                table: table_name,
                                section: section1_name,
                            });
                            error.gasIndex = 'section-3-confirmation';
                            result.errors.push(error);
                        }*/
                        return result;
                    }
                };
            };
            
            return ConfirmValidator;
        }
    ]);
})();

(function() {
    angular.module('FGases.services.validation.qcs').factory('SectionII4Validator', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        
        function ($translate, sheetValidationObjectFactory, sheetTransactionValidator) {
            
            function SectionII4Validator(validation_id, validation_label) {
                var that = this;
                this.transactionValidations = {
                    transaction: { id: validation_id, label: validation_label },
                    rules: [
                        that._createRuleQC3017(),

                        that._createRuleQC3018(),
                        that._createRuleQC3019(),
                        that._createRuleQC3020(),
                        that._createRuleQC3021(),

                        that._createRuleQC3022(),
                        that._createRuleQC3023(),
                        that._createRuleQC3024(),
                        that._createRuleQC3025(),
                        that._createRuleQC3030(),
                        that._createRuleQC3031(),
                        that._createRuleQC3032(),
                       /* that._createRuleQC3033(),*/
                    ]
                };
            }
            
            SectionII4Validator.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };
            
            SectionII4Validator.prototype._createRuleQC3017 = function() {
                return {
                    qccode: '3017',
                    _validate: function(option) {
                        return (option.option);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        if (!this._validate(section4.option_a)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                part: 'Part 1',
                            });
                            error.gasIndex = 'section-II-4-option-a';
                            result.errors.push(error);
                        }
                        if (!this._validate(section4.option_b)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                part: 'Part 2',
                            });
                            error.gasIndex = 'section-II-4-option-b';
                            result.errors.push(error);
                        }
                        if (!this._validate(section4.option_c)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                part: 'Part 3',
                            });
                            error.gasIndex = 'section-II-4-option-c';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            
            SectionII4Validator.prototype._createRuleQC3018 = function() {
                return {
                    qccode: '3018',
                    _validate: function(option, tr_13D, tr_13D_confirmation) {
                        if (option.option == '1') {
                            if (parseFloat(tr_13D.tco2e) == 0 || tr_13D_confirmation.confirmation_c.checked) {
                                return (!isEmpty(option.reason_1) && option.reason_1.length >= 5);
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_13D = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
                        let tr_13D_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_13D'];

                        if (!this._validate(section4.option_a, tr_13D, tr_13D_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a-1';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            SectionII4Validator.prototype._createRuleQC3019 = function() {
                return {
                    qccode: '3019',
                    _validate: function(option, tr_13D) {
                        if (option.option == '2') {
                            if (parseFloat(tr_13D.tco2e) <= 0) {
                                return (!isEmpty(option.reason_2) && option.reason_2.length >= 5);
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_13D = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];

                        if (!this._validate(section4.option_a, tr_13D)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a-2';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            SectionII4Validator.prototype._createRuleQC3020 = function() {
                return {
                    qccode: '3020',
                    _validate: function(option, tr_13D, tr_13D_confirmation) {
                        if (option.option == '3') {
                            if (parseFloat(tr_13D.tco2e) <= 0) {
                                if (tr_13D_confirmation.confirmation_a.checked || tr_13D_confirmation.confirmation_b.checked) {
                                    return (!isEmpty(option.reason_3) && option.reason_3.length >= 5);
                                }
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_13D = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
                        let tr_13D_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_13D'];

                        if (!this._validate(section4.option_a, tr_13D, tr_13D_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a-3';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            SectionII4Validator.prototype._createRuleQC3021 = function() {
                return {
                    qccode: '3021',
                    _validate: function (section3,option, tr_13D, tr_13D_confirmation) {
                        let section3_check = (section3.confirmation_a.checked || section3.confirmation_b.checked);
                        if ((tr_13D_confirmation.confirmation_a.checked || tr_13D_confirmation.confirmation_b.checked)&& section3_check ){
                            
                            if (parseFloat(tr_13D.tco2e) > 0) {
                                if (option.option == '2') {// || option.option == '3'
                                    return false
                                }
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section3 = viewModel._instance.Verification.EquipmentHFCs.section_II_3;
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_13D = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_13D')[0];
                        let tr_13D_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_13D'];

                        if (!this._validate(section3,section4.option_a, tr_13D, tr_13D_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            
            SectionII4Validator.prototype._createRuleQC3022 = function() {
                return {
                    qccode: '3022',
                    _validate: function(option, tr_12A, tr_12B, tr_12A_confirmation, tr_12B_confirmation) {
                        if (option.option == '1') {                           
                            if ((parseFloat(tr_12A.tco2e) == 0 && parseFloat(tr_12B.tco2e) == 0) || (tr_12A_confirmation.confirmation_c.checked || tr_12B_confirmation.confirmation_c.checked)) {
                                return (!isEmpty(option.reason_1) && option.reason_1.length >= 5);
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12A = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
                        let tr_12B = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];
                        let tr_12A_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];
                        let tr_12B_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12B'];

                        if (!this._validate(section4.option_b, tr_12A, tr_12B, tr_12A_confirmation, tr_12B_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-b-1';
                            result.errors.push(error);
                        }

                        return result;
                    }
                };
            };
            SectionII4Validator.prototype._createRuleQC3023 = function() {
                return {
                    qccode: '3023',
                    _validate: function(option, tr_12A, tr_12B) {
                        if (option.option == '2') {
                            if ((parseFloat(tr_12A.tco2e) == 0) && (parseFloat(tr_12B.tco2e) == 0)) {
                                return (!isEmpty(option.reason_2) && option.reason_2.length >= 5);
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12A = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
                        let tr_12B = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];

                        if (!this._validate(section4.option_b, tr_12A, tr_12B)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-b-2';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            SectionII4Validator.prototype._createRuleQC3024 = function() {
                return {
                    qccode: '3024',
                    _validate: function(option, tr_12A, tr_12B, tr_12A_confirmation, tr_12B_confirmation) {
                        if (option.option == '3') {
                            let check_12A = (parseFloat(tr_12A.tco2e) > 0) && (tr_12A_confirmation.confirmation_a.checked || tr_12A_confirmation.confirmation_b.checked);
                            let check_12B = (parseFloat(tr_12B.tco2e) > 0) && (tr_12B_confirmation.confirmation_a.checked || tr_12B_confirmation.confirmation_b.checked);
                            if ((check_12A) || (check_12B)) {
                                return (!isEmpty(option.reason_3) && option.reason_3.length >= 5);
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12A = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
                        let tr_12B = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];
                        let tr_12A_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];
                        let tr_12B_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12B'];

                        if (!this._validate(section4.option_b, tr_12A, tr_12B, tr_12A_confirmation, tr_12B_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a-3';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            SectionII4Validator.prototype._createRuleQC3025 = function() {
                return {
                    qccode: '3025',
                    _validate: function(option, section3, tr_12A, tr_12B, tr_12A_confirmation, tr_12B_confirmation) {
                        let tr_12A_check = (tr_12A_confirmation.confirmation_a.checked || tr_12A_confirmation.confirmation_b.checked) && (parseFloat(tr_12A.tco2e) > 0);
                        let tr_12B_check = (tr_12B_confirmation.confirmation_a.checked || tr_12B_confirmation.confirmation_b.checked) && (parseFloat(tr_12B.tco2e) > 0);
                        let section3_check = (section3.confirmation_a.checked || section3.confirmation_b.checked);
                        if ((tr_12A_check || tr_12B_check) && section3_check) {
                            if (option.option == '2' || option.option == '3') {
                                return false;
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section3 = viewModel._instance.Verification.EquipmentHFCs.section_II_3;
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12A = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12A')[0];
                        let tr_12B = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12B')[0];
                        let tr_12A_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12A'];
                        let tr_12B_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12B'];

                        if (!this._validate(section4.option_b, section3, tr_12A, tr_12B, tr_12A_confirmation, tr_12B_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-a';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            SectionII4Validator.prototype._createRuleQC3030 = function () {
                return {
                    qccode: '3030',
                    _validate: function (option, tr_12aA, tr_12aB, tr_12aA_confirmation, tr_12aB_confirmation) {
                        
                        if (option.option == '1') {                           
                            if ((parseFloat(tr_12aA.tco2e) == 0 && parseFloat(tr_12aB.tco2e) == 0) || (tr_12aA_confirmation.confirmation_c.checked || tr_12aB_confirmation.confirmation_c.checked)) {
                                return (!isEmpty(option.reason_1) && option.reason_1.length >= 5);
                            }
                        }
                        
                        
                        return true;
                    },
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12aA = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
                        let tr_12aB = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];
                        let tr_12aA_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12aA'];
                        let tr_12aB_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12aB'];

                        if (!this._validate(section4.option_c, tr_12aA, tr_12aB, tr_12aA_confirmation, tr_12aB_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-c-1';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            SectionII4Validator.prototype._createRuleQC3031 = function () {
                return {
                    qccode: '3031',
                    _validate: function (option, tr_12aA, tr_12aB) {

                        if (option.option == '2') {
                            if ((parseFloat(tr_12aA.tco2e) == 0 && parseFloat(tr_12aB.tco2e) == 0) ) {
                                return (!isEmpty(option.reason_2) && option.reason_2.length >= 5);
                            }
                        }


                        return true;
                    },
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12aA = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
                        let tr_12aB = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];
                       

                        if (!this._validate(section4.option_c, tr_12aA, tr_12aB)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-c-2';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            SectionII4Validator.prototype._createRuleQC3032 = function () {
                return {
                    qccode: '3032',
                    _validate: function (option, tr_12aA, tr_12aB, tr_12aA_confirmation, tr_12aB_confirmation) {

                        if (option.option == '3') {
                            if ((parseFloat(tr_12aA.tco2e) > 0 || parseFloat(tr_12aB.tco2e) > 0) && (tr_12aA_confirmation.confirmation_a.checked || tr_12aB_confirmation.confirmation_a.checked || tr_12aA_confirmation.confirmation_b.checked || tr_12aB_confirmation.confirmation_b.checked)) {
                                return (!isEmpty(option.reason_3) && option.reason_3.length >= 5);
                            }
                        }


                        return true;
                    },
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12aA = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
                        let tr_12aB = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];
                        let tr_12aA_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12aA'];
                        let tr_12aB_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12aB'];

                        if (!this._validate(section4.option_c, tr_12aA, tr_12aB, tr_12aA_confirmation, tr_12aB_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-II-4-option-c-1';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
          /*  SectionII4Validator.prototype._createRuleQC3033 = function () {
                return {
                    qccode: '3033',
                    _validate: function (section3, section4, tr_12aA, tr_12aA_confirmation, tr_12aB, tr_12aB_confirmation) {
                        if (section4.option_c.option == '2' || section4.option_c.option == '3') {
                            if (section3.confirmation_a.checked || section3.confirmation_b.checked) {
                                if ((parseFloat(tr_12aA.tco2e) > 0) && (tr_12aA_confirmation.confirmation_a.checked || tr_12aA_confirmation.confirmation_b.checked)) {
                                    return false;
                                }
                                if ((parseFloat(tr_12aB.tco2e) > 0) && (tr_12aB_confirmation.confirmation_a.checked || tr_12aB_confirmation.confirmation_b.checked)) {
                                    return false;
                                }
                            }
                        }
                        return true;
                    },
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section3 = viewModel._instance.Verification.EquipmentHFCs.section_II_3;
                        let section4 = viewModel._instance.Verification.EquipmentHFCs.section_II_4;
                        let tr_12aA = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aA')[0];
                        let tr_12aB = viewModel._instance.Verification.ReportedEquipment.Transactions.filter((tr) => tr.id == 'tr_12aB')[0];
                        let tr_12aA_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12aA'];
                        let tr_12aB_confirmation = viewModel._instance.Verification.EquipmentHFCs.section_II_2['tr_12aB'];

                        if (!this._validate(section3, section4, tr_12aA, tr_12aA_confirmation, tr_12aB, tr_12aB_confirmation)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = `section-II-4-option-c-${section4.option_c.option}`;
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };*/
            return SectionII4Validator;
        }
    ]);
})();

(function() {
    angular.module('FGases.services.validation.qcs').factory('Section3Validator', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        
        function ($translate, sheetValidationObjectFactory, sheetTransactionValidator) {
            
            function Section3Validator(validation_id, validation_label, section_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                var that = this;

                if (validation_id == 'bulk-hfcs-verification') {
                    this.transactionValidations = {
                        transaction: { id: validation_id, label: validation_label },
                        rules: [
                            that._createRuleQC3000(section_name, section3_Identifier),
                            that._createRuleQC3001(section_name, section1_Identifier, section2_Identifier, section3_Identifier),
                            that._createRuleQC3002(section_name, section1_Identifier, section2_Identifier, section3_Identifier),
                            that._createRuleQC3003(section_name, section1_Identifier, section2_Identifier, section3_Identifier),
                        ]
                    };
                }
                if (validation_id == 'equipment-verification') {
                    this.transactionValidations = {
                        transaction: { id: validation_id, label: validation_label },
                        rules: [
                            that._createRuleQC3000(section_name, section3_Identifier),
                            that._createRuleQC3013(section2_Identifier, section3_Identifier),
                            that._createRuleQC3014(section2_Identifier, section3_Identifier),
                            that._createRuleQC3015(section3_Identifier),
                            that._createRuleQC3016(section3_Identifier),
                        ]
                    };
                }
            }
            
            Section3Validator.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };

            Section3Validator._getSection = function(viewModel, sectionIdentifier) {
                let section = viewModel._instance.Verification;
                let tokens = sectionIdentifier.split(".");
                while (tokens.length) {
                    section = section[tokens.shift()];
                }
                return section;
            }
            
            Section3Validator.prototype._createRuleQC3000 = function(section_name, section3_Identifier) {
                return {
                    qccode: '3000',
                    _validate: function(confirmation_row) {
                        return ((confirmation_row.confirmation_a.checked + confirmation_row.confirmation_b.checked + confirmation_row.confirmation_c.checked) == 1);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate(section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                section: section_name,
                            });
                            error.gasIndex = 'section-3-confirmation';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            Section3Validator.prototype._createRuleQC3001 = function(section_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3001',
                    _validate: function(section1, section2, section3) {
                        // Option a) should only be chosen if in Tables 1 and 2 in section I only a) was selected.
                        // If somewhere options b) or c) are selected in the tables 1 and 2 in section I and the verifier chooses a) in I-3, there should be a blocking error with the following text:
                        if (!section3.confirmation_a.checked) return true;
                        if (section1.confirmation_b.checked) return false;
                        if (section1.confirmation_c.checked) return false;
                        for (const transaction_code in section2) {
                            if (section2[transaction_code].confirmation_b.checked) return false;
                            if (section2[transaction_code].confirmation_c.checked) return false;
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section1 = Section3Validator._getSection(viewModel, section1_Identifier);
                        let section2 = Section3Validator._getSection(viewModel, section2_Identifier);
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate(section1, section2, section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                section: section_name,
                            });
                            error.gasIndex = 'section-3-confirmation-a';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            Section3Validator.prototype._createRuleQC3002 = function(section_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3002',
                    _validate: function(section1, section2, section3) {
                        // Option b) can only be selected if for none of the entries in Tables 1 and 2 c) was selected.
                        // Thus if a company selects b) in section I-3 while in table 1 or 2 in section I, c) was selected, please introduce a blocking error with the following text:
                        if (!section3.confirmation_b.checked) return true;
                        if (section1.confirmation_c.checked) return false;
                        for (const transaction_code in section2) {
                            if (section2[transaction_code].confirmation_c.checked) return false;
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section1 = Section3Validator._getSection(viewModel, section1_Identifier);
                        let section2 = Section3Validator._getSection(viewModel, section2_Identifier);
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate(section1, section2, section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                section: section_name,
                            });
                            error.gasIndex = 'section-3-confirmation-b';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            Section3Validator.prototype._createRuleQC3003 = function(section_name, section1_Identifier, section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3003',
                    _validate: function(section1, section2, section3) {
                        // Option c) can not be selected if for none of the entries in Tables 1 and 2 c) was selected.
                        // Thus if option c) is selected in section I-3 and in the tables 1 and 2 in section I, c) was selected nowhere, please introduce a blocking error with the following text:
                        if (!section3.confirmation_c.checked) return true;
                       // if (!section1.confirmation_c.checked)  return false;
                        let valid = true;
                        for (const transaction_code in section2) {
                            if ((!section2[transaction_code].confirmation_c.checked) && (!section1.confirmation_c.checked)) valid= false;
                            else if ((section2[transaction_code].confirmation_c.checked) || (section1.confirmation_c.checked)){ valid= true; break;}
                        }
                        return valid;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section1 = Section3Validator._getSection(viewModel, section1_Identifier);
                        let section2 = Section3Validator._getSection(viewModel, section2_Identifier);
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate(section1, section2, section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                section: section_name,
                            });
                            error.gasIndex = 'section-3-confirmation-c';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };


            Section3Validator.prototype._createRuleQC3013 = function(section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3013',
                    _validate: function(section2, section3) {
                        // Option a) can not be selected if in Table 2 in section II a) was not selected for 13D.
                        // In case the auditor selects a) in II-3 and a) was not selected for 13D please introduce a blocking error
                        if (section3.confirmation_a.checked) {
                            let transaction_code = 'tr_13D';
                            let tr_13D_confirmation_row = section2[transaction_code];
                            if (tr_13D_confirmation_row && !tr_13D_confirmation_row.confirmation_a.checked) return false;
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section2 = Section3Validator._getSection(viewModel, section2_Identifier);
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate(section2, section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-3-confirmation-a';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            Section3Validator.prototype._createRuleQC3014 = function(section2_Identifier, section3_Identifier) {
                return {
                    qccode: '3014',
                    _validate: function(section2, section3) {
                        // Option b) can not be selected if in Table 2 in section II c) was selected for 13D.
                        // In case the auditor selects b) in II-3 and c) was selected for 13D in table II-2, please introduce a blocking error
                        if (section3.confirmation_b.checked) {
                            let transaction_code = 'tr_13D';
                            let tr_13D_confirmation_row = section2[transaction_code];
                            if (tr_13D_confirmation_row && tr_13D_confirmation_row.confirmation_c.checked) return false;
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section2 = Section3Validator._getSection(viewModel, section2_Identifier);
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate(section2, section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-3-confirmation-b';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            Section3Validator.prototype._createRuleQC3015 = function(section3_Identifier) {
                return {
                    qccode: '3015',
                    _validate_b4: function(confirmation) {
                        // If b) or c) are selected in Section II-3, there must be a comment with a length of at least 5 characters.
                        // If the auditor does not enter a text into the comment box, please introduce a blocking error
                        if (!confirmation.checked) return true;
                        if (!confirmation.option_4) return true;
                        return (!isEmpty(confirmation.option_4_reason) && confirmation.option_4_reason.length >= 5);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate_b4(section3.confirmation_b)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-3-confirmation-b';
                            result.errors.push(error);
                        }
                        if (!this._validate_b4(section3.confirmation_c)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-3-confirmation-c';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            Section3Validator.prototype._createRuleQC3016 = function(section3_Identifier) {
                return {
                    qccode: '3016',
                    _validate_b4: function(confirmation_row) {
                        // One and only one of the boxes a), b) or c) in section II-3 must be selected.
                        // If none of the boxes are selected (or more than one is selected), please introduce a blocking error
                        return ((confirmation_row.confirmation_a.checked + confirmation_row.confirmation_b.checked + confirmation_row.confirmation_c.checked) == 1);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section3 = Section3Validator._getSection(viewModel, section3_Identifier);
                        if (!this._validate_b4(section3)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = 'section-3-confirmation';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            return Section3Validator;
        }
    ]);
})();

(function() {
    angular.module('FGases.services.validation.qcs').factory('SheetBulkHFCSValidator', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        'ConfirmValidator', 'Section3Validator', 'UploadVerificationReport',
        
        function ($translate, sheetValidationObjectFactory, sheetTransactionValidator, ConfirmValidator, Section3Validator, UploadVerificationReport) {
            
            function SheetBulkHFCSValidator() {
                var that = this;
                let validation_id = 'bulk-hfcs-verification';
                let validation_label = 'Bulk HFCs verification';
                let table_name = 'Table 1'; // 'Bulk HFCs verification';

                this.confirmValidator = new ConfirmValidator(
                    validation_id, validation_label, table_name,
                    'Section I-1', 'Section I-2', 'Section I-3',
                    'BulkHFCs.section_I_1', 'BulkHFCs.section_I_2', 'BulkHFCs.section_I_3'
                );
                this.section3Validator = new Section3Validator(
                    validation_id, validation_label,
                    'Section I-3',
                    'BulkHFCs.section_I_1', 'BulkHFCs.section_I_2', 'BulkHFCs.section_I_3',
                );
                this.uploadVerificationReport = new UploadVerificationReport(
                    validation_id, validation_label,
                    'Section I-4', 'BulkHFCs.section_I_4',
                );
                this.transactionValidations = [
                    this.confirmValidator.transactionValidations,
                    this.section3Validator.transactionValidations,
                    this.uploadVerificationReport.transactionValidations,
                    {
                        transaction: { id: validation_id, label: validation_label },
                        rules: [
                            that._createRuleQC3011(),
                            that._createRuleQC3012(),
                        ]
                    }
                ];
            }
            
           SheetBulkHFCSValidator.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };

            SheetBulkHFCSValidator.prototype._createRuleQC3011 = function() {
                return {
                    qccode: '3011',
                    _validate: function(section_I_1, section_I_2) {
                        // Option a) can not be selected for field 9F in Table 2 in section I if for any of the other statements in table 1 or table 2 in Section I something other than a) was selected.
                        // When the auditor chooses a) for 9F and in table 1 or 2 in section I there was a selection of b) or c), please introduce a blocking error with the following text:
                        // 9F can this have a) as a verdict, even if the verdict on 5F is not a).
                        if (section_I_1.confirmation_b.checked || section_I_1.confirmation_c.checked) return false;
                        for (const transaction_code in section_I_2) {
                            if ((transaction_code != 'tr_09F') && (transaction_code != 'tr_05F')) {
                                if (section_I_2[transaction_code].confirmation_b.checked || section_I_2[transaction_code].confirmation_c.checked) return false;
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section_I_1 = viewModel._instance.Verification.BulkHFCs.section_I_1;
                        let section_I_2 = viewModel._instance.Verification.BulkHFCs.section_I_2;
                        let transaction_code = 'tr_09F';
                        if (section_I_2[transaction_code].confirmation_a.checked && !this._validate(section_I_1, section_I_2)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = `confirmation-${transaction_code}`;
                            result.errors.push(error);
                        }
                        return result;
                    }
                }
            }
            SheetBulkHFCSValidator.prototype._createRuleQC3012 = function() {
                return {
                    qccode: '3012',
                    _validate: function(section_I_1, section_I_2) {
                        // Option b) can not be selected for field 9F in Table 2 in section I if for any of the other statements in table 1 or table 2 in Section I c) was selected.
                        // When the auditor chooses b) for 9F and in table 1 or 2 in section I there was a selection of c), please introduce a blocking error with the following text:
                        // 9F can this have b) as a verdict, even if the verdict on 5F is not c).
                        if (section_I_1.confirmation_c.checked) return false;
                        for (const transaction_code in section_I_2) {
                            if ((transaction_code != 'tr_09F') && (transaction_code != 'tr_05F')) {
                                if (section_I_2[transaction_code].confirmation_c.checked) return false;
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section_I_1 = viewModel._instance.Verification.BulkHFCs.section_I_1;
                        let section_I_2 = viewModel._instance.Verification.BulkHFCs.section_I_2;
                        let transaction_code = 'tr_09F';
                        if (section_I_2[transaction_code].confirmation_b.checked && !this._validate(section_I_1, section_I_2)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = `confirmation-${transaction_code}`;
                            result.errors.push(error);
                        }
                        return result;
                    }
                }
            }
            
            return new SheetBulkHFCSValidator();
        }
    ]);
})();

(function() {
    angular.module('FGases.services.validation.qcs').factory('SheetEquipmentValidator', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        'ConfirmValidator', 'Section3Validator', 'SectionII4Validator', 'UploadVerificationReport',
        
        function ($translate, sheetValidationObjectFactory, sheetTransactionValidator,
                    ConfirmValidator, Section3Validator, SectionII4Validator, UploadVerificationReport) {
            
            function SheetEquipmentValidator() {
                var that = this;
                let validation_id = 'equipment-verification';
                let validation_label = 'Equipment verification';
                let table_name = 'Table 2'; // 'Equipment verification';
                

                this.confirmValidator = new ConfirmValidator(
                    validation_id, validation_label, table_name,
                    'Section II-1', 'Section II-2', 'Section II-3',
                    'EquipmentHFCs.section_II_1', 'EquipmentHFCs.section_II_2', 'EquipmentHFCs.section_II_3'
                );
                this.section3Validator = new Section3Validator(
                    validation_id, validation_label,
                    'Section II-3',
                    'EquipmentHFCs.section_II_1', 'EquipmentHFCs.section_II_2', 'EquipmentHFCs.section_II_3',
                );
                this.sectionII4Validator = new SectionII4Validator(validation_id, validation_label);
                this.uploadVerificationReport = new UploadVerificationReport(
                    validation_id, validation_label,
                    'Section II-5', 'EquipmentHFCs.section_II_5',
                );
                this.transactionValidations = [
                    this.confirmValidator.transactionValidations,
                    this.section3Validator.transactionValidations,
                    this.sectionII4Validator.transactionValidations,
                    this.uploadVerificationReport.transactionValidations,
                    {
                        transaction: { id: validation_id, label: validation_label },
                        rules: [
                            that._createRuleQC3026(),
                            that._createRuleQC3027(),
                            that._createRuleQC3028(),
                            that._createRuleQC3029(),
                        ]
                    },
                ];
            }
            
           SheetEquipmentValidator.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };

            SheetEquipmentValidator.prototype._createRuleQC3026 = function() {
                return {
                    qccode: '3026',
                    _validate_confirmation_row: function(confirmation_row, section2,section1) {
                        if (confirmation_row.confirmation_a.checked) {
                            if (!section1.confirmation_a.checked) return false;
                            for (const transaction_code in section2) {
                                let other_confirmation_row = section2[transaction_code];
                                if (confirmation_row == other_confirmation_row) { continue }
                                if (other_confirmation_row.confirmation_b.checked) return false;
                                if (other_confirmation_row.confirmation_c.checked) return false;
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 2
                        let section2 = viewModel._instance.Verification.EquipmentHFCs.section_II_2;
                        let section1 = viewModel._instance.Verification.EquipmentHFCs.section_II_1;
                        let transaction_code = 'tr_13D';
                        let confirmation_row = section2[transaction_code];
                        if (confirmation_row && !this._validate_confirmation_row(confirmation_row, section2,section1)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = `confirmation-${transaction_code}`;
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            SheetEquipmentValidator.prototype._createRuleQC3027 = function() {
                return {
                    qccode: '3027',
                    _validate_confirmation_row: function (confirmation_row, section2, section1) {
                        if (confirmation_row.confirmation_b.checked) {
                            if (section1.confirmation_c.checked) return false;
                            for (const transaction_code in section2) {
                                let other_confirmation_row = section2[transaction_code];
                                if (confirmation_row == other_confirmation_row) { continue }
                                //if (other_confirmation_row.confirmation_a.checked) return false;
                                if (other_confirmation_row.confirmation_c.checked) return false;
                            }
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 2
                        let section2 = viewModel._instance.Verification.EquipmentHFCs.section_II_2;
                        let section1 = viewModel._instance.Verification.EquipmentHFCs.section_II_1;
                        let transaction_code = 'tr_13D';
                        let confirmation_row = section2[transaction_code];
                        if (confirmation_row && !this._validate_confirmation_row(confirmation_row, section2, section1)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = `confirmation-${transaction_code}`;
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };

            SheetEquipmentValidator.prototype._createRuleQC3028 = function() {
                return {
                    qccode: '3028',
                    _validate_confirmation_row: function(confirmation_row) {
                        return ((confirmation_row.confirmation_a.checked + confirmation_row.confirmation_b.checked + confirmation_row.confirmation_c.checked) == 1);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 2
                        let section2 = viewModel._instance.Verification.EquipmentHFCs.section_II_2;
                        let transactions = viewModel._instance.Verification.ReportedEquipment.Transactions;
                        let validate3028 = false;
                       

                        for (var i = 0; i < transactions.length; i++) {
                            if (transactions[i].id == 'tr_11P'){
                                validate3028 = true;
                                break;
                            }
                        }
                        if (validate3028) {

                            let transaction_code = 'tr_11P';
                            let confirmation_row = section2[transaction_code];
                            if (confirmation_row && !this._validate_confirmation_row(confirmation_row)) {
                                error = sheetValidationObjectFactory.createValidationError(this.qccode);
                                error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                                error.gasIndex = `confirmation-${transaction_code}`;
                                result.errors.push(error);
                            }
                        }
                        return result;
                    }
                };
            };

            SheetEquipmentValidator.prototype._createRuleQC3029 = function() {
                return {
                    qccode: '3029',
                    _validate_confirmation_row: function(confirmation_row) {
                        if (confirmation_row.confirmation_b.checked) {
                            return (!isEmpty(confirmation_row.confirmation_b.option_4_reason) && confirmation_row.confirmation_b.option_4_reason.length >= 5);
                        }
                        if (confirmation_row.confirmation_c.checked) {
                            return (!isEmpty(confirmation_row.confirmation_c.option_4_reason) && confirmation_row.confirmation_c.option_4_reason.length >= 5);
                        }
                        return true;
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        // Section 2
                        let section2 = viewModel._instance.Verification.EquipmentHFCs.section_II_2;
                        let transaction_code = 'tr_11P';
                        let confirmation_row = section2[transaction_code];
                        if (confirmation_row && !this._validate_confirmation_row(confirmation_row)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`);
                            error.gasIndex = `confirmation-${transaction_code}`;
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            
            return new SheetEquipmentValidator();
        }
    ]);
})();

(function() {
    angular.module('FGases.services.validation.qcs').factory('sheetGeneralValidator', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        
        function ($translate, sheetValidationObjectFactory,  sheetTransactionValidator) {
            
            function sheetGeneralValidator() {
                var that = this;
                this.transactionValidations = [
                  /*  {
                        transaction: { id: 'ext-company-data', label: 'Additional company data' },
                        rules: [ that._createRule() ]
                    },*/
                    {
                        transaction: { id: 'ext-company-data', label: 'Additional company data' },
                        rules: [that._createRuleQC24120()]
                    }
                ];
            }
            
           sheetGeneralValidator.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };
            
           /* sheetGeneralValidator.prototype._createRule = function() {
                return {
                    qccode: '2501',
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        
                        if (!viewModel.isStocksInfoDefined() || !viewModel.isQuotaInfoDefined() || !viewModel.isCompanySizeInfoDefined() || !viewModel.isNerStatusDefined()) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            result.errors.push(error);
                        }
                        
                        return result;
                    }
                };
            };*/
            
            sheetGeneralValidator.prototype._createRuleQC24120 = function () {
                return {
                    qccode: '24120',
                    validate: function (viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();

                        if (viewModel._instance.Verification.GeneralReportData.Company.CompanyId == "" ||
                            viewModel._instance.Verification.GeneralReportData.Company.CompanyId == null ||
                            viewModel._instance.Verification.GeneralReportData.Company.CompanyName == "" ||
                            viewModel._instance.Verification.GeneralReportData.Company.CompanyName == null
                        ) {
                            var error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            result.errors.push(error);
                        }

                        return result;
                    }
                };
            };
            
            return new sheetGeneralValidator();
        }
    ]);
})();


(function() {
    angular.module('FGases.services.validation.qcs').factory('sheetTransactionValidator', [
        
        'sheetValidationObjectFactory', 'objectUtil', 'arrayUtil',
        
        function(sheetValidationObjectFactory, objectUtil, arrayUtil) {
            function sheetTransactionValidator() { }
            
            sheetTransactionValidator.prototype.validate = function(viewModel, transactionValidations) {
                var transactionErrorContainers = [];
                
                arrayUtil.forEach(transactionValidations, function(transactionValidation) {
                    if (!objectUtil.isNull(transactionValidation.isValidationRequired) && !transactionValidation.isValidationRequired(viewModel)) {
                        return;
                    }
                    
                    var ruleErrors = [];
                    var ruleFlags = [];
                    
                    arrayUtil.forEach(transactionValidation.rules, function(qcRule) {
                        var result = qcRule.validate(viewModel);
                        arrayUtil.pushMany(ruleErrors, result.errors);
                        arrayUtil.pushMany(ruleFlags, result.flags);
                    });
                    
                    if (ruleErrors.length > 0 || ruleFlags.length > 0) {
                        var id = transactionValidation.transaction.id;
                        var label = transactionValidation.transaction.label;
                        var transactionErrorContainer = sheetValidationObjectFactory.createTransactionErrorContainer(id, label);
                        transactionErrorContainer.errors = ruleErrors;
                        transactionErrorContainer.flags = ruleFlags;
                        transactionErrorContainers.push(transactionErrorContainer);
                    }
                });
                
                return transactionErrorContainers;
            };
            
            return new sheetTransactionValidator();
        }
    ]);
})();


(function() {

    angular.module('FGases.services.validation.qcs').factory('sheetValidationObjectFactory', [
        
        'objectUtil',
        
        function(objectUtil) {
            function SheetValidationObjectFactory() { }
            
            SheetValidationObjectFactory.prototype.createTransactionErrorContainer = function(transaction, transactionLabel) {
                return {
                    transaction: angular.isUndefined(transaction) ? null : transaction, 
                    transactionLabel: angular.isUndefined(transactionLabel) ? null : transactionLabel, 
                    errors: []
                };
            };
            
            SheetValidationObjectFactory.prototype.createValidationError = function(qcCode) {
                return {
                    QCCode: angular.isUndefined(qcCode) ? null : qcCode, 
                    gasIndex: null, 
                    tradePartnerId: null, 
                    type: null, 
                    message: null,
                    isNonBlocker: false
                };
            };
            
            SheetValidationObjectFactory.prototype.createValidationResult = function() {
                return {
                    errors: [],
                    flags: []
                };
            };
            
            SheetValidationObjectFactory.prototype.createQcFlag = function(transactionCode, qcCode, gasId, tradePartnerId, comment) {
                return {
                    transactionCode: objectUtil.isNull(transactionCode) ? null : transactionCode,
                    qcCode: objectUtil.isNull(qcCode) ? null : qcCode,
                    gasId: objectUtil.isNull(gasId) ? null : gasId,
                    tradePartnerId: objectUtil.isNull(tradePartnerId) ? null : tradePartnerId,
                    comment: objectUtil.isNull(comment) ? null : comment,
                };
            };
            
            return new SheetValidationObjectFactory();
        }
    ]);
    
})();


(function() {
    angular.module('FGases.services.validation.qcs').factory('UploadVerificationReport', [
        
        '$translate', 'sheetValidationObjectFactory', 'sheetTransactionValidator',
        
        function ($translate, sheetValidationObjectFactory, sheetTransactionValidator) {
            
            function UploadVerificationReport(transaction, label, section_name, section_Identifier) {
                var that = this;
                this.transactionValidations = {
                    transaction: { id: transaction, label: label },
                    rules: [
                        that._createRuleQC3004(section_name, section_Identifier),
                        that._createRuleQC3005(section_name, section_Identifier),
                    ]
                };
            }
            
            UploadVerificationReport.prototype.validate = function(viewModel) {
                return sheetTransactionValidator.validate(viewModel, this.transactionValidations);
            };

            UploadVerificationReport._getSection = function(viewModel, sectionIdentifier) {
                let section = viewModel._instance.Verification;
                let tokens = sectionIdentifier.split(".");
                while (tokens.length) {
                    section = section[tokens.shift()];
                }
                return section;
            }
            
            UploadVerificationReport.prototype._createRuleQC3004 = function(section_name, section_Identifier) {
                return {
                    qccode: '3004',
                    _validate: function(section) {
                        if (isEmpty(section.VerificationReport.Url)) return true;
                        let file_name = section.VerificationReport.Url.split('/').pop();
                        let file_extension = file_name.split('.').pop();
                        return (file_extension.toLowerCase() != 'xml');
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section = UploadVerificationReport._getSection(viewModel, section_Identifier);
                        if (!this._validate(section)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                section: section_name,
                            });
                            error.gasIndex = 'verification-report';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            UploadVerificationReport.prototype._createRuleQC3005 = function(section_name, section_Identifier) {
                return {
                    qccode: '3005',
                    _validate: function(section) {
                        return !isEmpty(section.VerificationReport.Url);
                    },
                    validate: function(viewModel) {
                        var result = sheetValidationObjectFactory.createValidationResult();
                        let section = UploadVerificationReport._getSection(viewModel, section_Identifier);
                        if (!this._validate(section)) {
                            error = sheetValidationObjectFactory.createValidationError(this.qccode);
                            error.message = $translate.instant(`validation_messages.qc_${this.qccode}.error_text`, {
                                section: section_name,
                            });
                            error.gasIndex = 'verification-report-upload';
                            result.errors.push(error);
                        }
                        return result;
                    }
                };
            };
            
            return UploadVerificationReport;
        }
    ]);
})();

(function() {
    angular.module('FGases.viewmodel').factory('ViewModelActivities', [
       
        'ViewModelObjectBase', 'objectUtil',
        
        function(ViewModelObjectBase, objectUtil) {
            
            function ViewModelActivities(viewModel) {
                if (!(this instanceof ViewModelActivities)) {
                    return new ViewModelActivities(viewModel);
                }
                
                ViewModelObjectBase.call(this, viewModel);
            }
            
            objectUtil.chainConstructor(ViewModelObjectBase, ViewModelActivities);
            
            ViewModelActivities.prototype.getSectionData = function() {
                return this.getRoot().getDataSource().FGasesReporting.GeneralReportData.Activities;
            };
            
            ViewModelActivities.prototype.isP = function() {
                return this._is("P");
            };
            
            ViewModelActivities.prototype.isP_HFC = function() {
                return this._is("P-HFC");
            };
            
            ViewModelActivities.prototype.isP_Other = function() {
                return this._is("P-other");
            };
            
            ViewModelActivities.prototype.isI = function() {
                return this._is("I");
            };
            
            ViewModelActivities.prototype.isI_HFC = function() {
                return this._is("I-HFC");
            };
            
            ViewModelActivities.prototype.isI_Other = function() {
                return this._is("I-other");
            };
            
            ViewModelActivities.prototype.isE = function() {
                return this._is("E");
            };

            ViewModelActivities.prototype.isRC = function () {
                return this._is("RC");
            };

            ViewModelActivities.prototype.isRQ = function () {
                return this._is("RQ");
            };

            ViewModelActivities.prototype.isRH = function () {
                return this._is("RH");
            };
            
            ViewModelActivities.prototype.isFU = function() {
                return this._is("FU");
            };
            
            ViewModelActivities.prototype.isD = function() {
                return this._is("D");
            };
            
            ViewModelActivities.prototype.isEq_I = function() {
                return this._is("Eq-I");
            };
            
            ViewModelActivities.prototype.isEq_I_RACHP_HFC = function() {
                return this._is("Eq-I-RACHP-HFC");
            };
            
            ViewModelActivities.prototype.isEq_I_other = function() {
                return this._is("Eq-I-other");
            };
            
            ViewModelActivities.prototype.isAuth = function() {
                return this._is("auth");
            };

            ViewModelActivities.prototype.isRQA = function () {
                return this._is("RQA");
            };
            
            ViewModelActivities.prototype.isNilReport = function() {
                return this._is("NIL-Report");
            };
            
            ViewModelActivities.prototype._is = function(activityCode) {
                return this.getSectionData()[activityCode] == true;
            };
            
            return ViewModelActivities;
        }
    ]);
})();


(function() {
    angular.module('FGases.viewmodel').factory('ViewModelBulkHFCsVerification', [

        'ViewModelObjectBase', 'objectUtil',

        function(ViewModelObjectBase, objectUtil) {

            function ViewModelBulkHFCsVerification(viewModel) {
                if (!(this instanceof ViewModelBulkHFCsVerification)) {
                    return new ViewModelBulkHFCsVerification(viewModel);
                }

                ViewModelObjectBase.call(this, viewModel);
            }

            objectUtil.chainConstructor(ViewModelObjectBase, ViewModelBulkHFCsVerification);

            return ViewModelBulkHFCsVerification;
        }
    ]);
})();

(function() {
    angular.module('FGases.viewmodel').factory('ViewModelEquipmentCtrl', [

        'ViewModelObjectBase', 'objectUtil',

        function(ViewModelObjectBase, objectUtil) {

            function ViewModelEquipmentCtrl(viewModel) {
                if (!(this instanceof ViewModelEquipmentCtrl)) {
                    return new ViewModelEquipmentCtrl(viewModel);
                }

                ViewModelObjectBase.call(this, viewModel);
            }

            objectUtil.chainConstructor(ViewModelObjectBase, ViewModelEquipmentCtrl);

            return ViewModelEquipmentCtrl;
        }
    ]);
})();


(function() {
    angular.module('FGases.viewmodel').factory('ViewModelIdentificationCtrl', [

        'ViewModelObjectBase', 'objectUtil',

        function(ViewModelObjectBase, objectUtil) {

            function ViewModelIdentificationCtrl(viewModel) {
                if (!(this instanceof ViewModelIdentificationCtrl)) {
                    return new ViewModelIdentificationCtrl(viewModel);
                }

                ViewModelObjectBase.call(this, viewModel);
            }

            objectUtil.chainConstructor(ViewModelObjectBase, ViewModelIdentificationCtrl);

            return ViewModelIdentificationCtrl;
        }
    ]);
})();


(function() {
    angular.module('FGases.viewmodel').factory('ViewModelObjectBase', [
        
        'objectUtil',
        
        function(objectUtil) {
            function ViewModelObjectBase(parentViewModelObject) { 
                this._parent = parentViewModelObject;
            }
            
            ViewModelObjectBase.prototype.getParent = function() {
                return this._parent;
            };
            
            ViewModelObjectBase.prototype.getRoot = function() {
                if (objectUtil.isNull(this._root)) {
                    var viewModelObject = this;
                
                    while(!objectUtil.isNull(viewModelObject.getParent())) {
                        viewModelObject = viewModelObject.getParent();
                    }

                    this._root = viewModelObject;
                }
                
                return this._root;
            };
            
            return ViewModelObjectBase;
        }
    ]).factory('ViewModelSectionBase', [
        
        'ViewModelObjectBase', 'objectUtil', 'arrayUtil',
        
        function(ViewModelObjectBase, objectUtil, arrayUtil) {
            
            function ViewModelSectionBase(parentViewModelObject) {
                ViewModelObjectBase.call(this, parentViewModelObject);
            }
            
            objectUtil.chainConstructor(ViewModelObjectBase, ViewModelSectionBase);
            
            ViewModelSectionBase.prototype.getSectionGases = function() {
                var that = this;
                return arrayUtil.select(this.getRoot().getReportedGases(), function(gas) {
                    return that._isSectionGas(gas.GasId);
                });
            };
            
            ViewModelSectionBase.prototype.getSectionGasEntries = function() {
                var that = this;
                return arrayUtil.select(this.getSectionData().Gas, function(gasEntry) {
                    return that._isSectionGas(gasEntry.GasCode);
                });
            };
            
            ViewModelSectionBase.prototype.getBindableGasAmount = function(transactionField, gasId) {
                var gasData = arrayUtil.selectSingle(this.getSectionGasEntries(), function(gasEntry) {
                    return gasEntry.GasCode === gasId;
                });
                
                if (objectUtil.isNull(gasData)) {
                    return null;
                }
                
                return gasData[transactionField];
            };
            
            ViewModelSectionBase.prototype.getBindableGasAmountOfTradePartner = function(transactionField, tradePartnerId, gasId) {
                var gasData = arrayUtil.selectSingle(this.getSectionGasEntries(), function(gasEntry) {
                    return gasEntry.GasCode === gasId;
                });
                
                if (objectUtil.isNull(gasData)) {
                    return null;
                }
                
                var result = arrayUtil.selectSingle(gasData[transactionField].TradePartner, function(tradePartnerAmount) {
                    return tradePartnerAmount.TradePartnerID === tradePartnerId;
                });
                
                return result;
            };
            
            ViewModelSectionBase.prototype.getGasAmount = function(transactionField, gasId) {
                if (!this._isSectionGas(gasId)) {
                    return null;
                }
                    
                var gasEntryIndex = arrayUtil.indexOf(this.getSectionData().Gas, function(gasEntry) {
                    return gasEntry.GasCode === gasId;
                });
                
                if (gasEntryIndex < 0) {
                    return null;
                }
                
                var gasEntry = this.getSectionData().Gas[gasEntryIndex];
                var transactionAmount = gasEntry[transactionField];
                
                return this._createGasAmount(gasEntry.GasCode, gasEntryIndex, transactionAmount.Amount, transactionAmount.Comment);
            };

            ViewModelSectionBase.prototype.getTotalAmountForRow = function (transactionField, gasId) {
                if (!this._isSectionGas(gasId)) {
                    return null;
                }

                var gasEntryIndex = arrayUtil.indexOf(this.getSectionData().Gas, function (gasEntry) {
                    return gasEntry.GasCode === gasId;
                });

                if (gasEntryIndex < 0) {
                    return null;
                }

                var gasEntry = this.getSectionData().Gas[gasEntryIndex];
                var transactionAmount = gasEntry[transactionField];

                return this._createGasAmount(gasEntry.GasCode, gasEntryIndex, transactionAmount.totalAmountForRow, transactionAmount.Comment);
            };
            
            ViewModelSectionBase.prototype.getGasAmounts = function(transactionField) {
                var that = this;
                
                return arrayUtil.map(this.getSectionData().Gas, function(gasEntry, loopContext) {
                    if (!that._isSectionGas(gasEntry.GasCode)) {
                        return null;
                    }
                    
                    var transactionAmount = gasEntry[transactionField];
                    
                    return that._createGasAmount(gasEntry.GasCode, loopContext.index, transactionAmount.Amount, transactionAmount.Comment);
                });
            };
            
            ViewModelSectionBase.prototype.getTradePartnerSumGasAmounts = function(transactionField) {
                var that = this;
                
                return arrayUtil.map(this.getSectionData().Gas, function(gasEntry, loopContext) {
                    if (!that._isSectionGas(gasEntry.GasCode)) {
                        return null;
                    }
                    
                    var transactionAmount = gasEntry[transactionField];
                    
                    return that._createGasAmount(gasEntry.GasCode, loopContext.index, transactionAmount.SumOfPartnerAmounts, transactionAmount.Comment);
                });
            };
            
            ViewModelSectionBase.prototype.getGasAmountsOfTradePartner = function(transactionField, tradePartnerId) {
                var that = this;
                
                return arrayUtil.map(this.getSectionData().Gas, function(gasEntry, loopContext) {
                    if (!that._isSectionGas(gasEntry.GasCode)) {
                        return null;
                    }
                    
                    var partnerAmount = arrayUtil.selectSingle(gasEntry[transactionField].TradePartner, function(tradePartnerAmount) {
                        return tradePartnerAmount.TradePartnerID === tradePartnerId;
                    });

                    if(!partnerAmount) {
                        return null;
                    }
                    
                    return that._createGasAmount(gasEntry.GasCode, loopContext.index, partnerAmount.amount, partnerAmount.Comment);
                });
            };

            ViewModelSectionBase.prototype.getGasAmountsOfCountrySpecific = function(transactionField,countryId) {
                var that = this;
                
                return arrayUtil.map(this.getSectionData().Gas, function(gasEntry, loopContext) {
                    if (!that._isSectionGas(gasEntry.GasCode)) {
                        return null;
                    }
                    
                    var countryAmount = arrayUtil.selectSingle(gasEntry[transactionField].CountrySpecific.Country, function(tradeCountryAmount) {
                        return tradeCountryAmount.CountryId === countryId;
                    });

                    return that._createGasAmount(gasEntry.GasCode, loopContext.index, countryAmount.Amount, countryAmount.Comment);
                });
            };

            ViewModelSectionBase.prototype.getGasAmountOfCountryGasSpecific = function (transactionField, countryId, gasId) {
                var that = this;

                if (!this._isSectionGas(gasId)) {
                    return null;
                }

                var gasEntryIndex = arrayUtil.indexOf(this.getSectionData().Gas, function (gasEntry) {
                    return gasEntry.GasCode === gasId;
                });

                if (gasEntryIndex < 0) {
                    return null;
                }

                var gasEntry = this.getSectionData().Gas[gasEntryIndex];

                var countryAmount = arrayUtil.selectSingle(gasEntry[transactionField].CountrySpecific.Country, function (tradeCountryAmount) {
                    return tradeCountryAmount.CountryId === countryId;
                });

                return that._createGasAmount(gasEntry.GasCode, gasEntryIndex, countryAmount.Amount, countryAmount.Comment);
            };

            ViewModelSectionBase.prototype.getGasTotalAmountForRow = function(transactionField) {
                var that = this;
                
                return arrayUtil.map(this.getSectionData().Gas, function(gasEntry, loopContext) {
                    if (!that._isSectionGas(gasEntry.GasCode)) {
                        return null;
                    }
                    
                    var totalAmountForRow = gasEntry[transactionField].totalAmountForRow;

                    return that._createGasAmount(gasEntry.GasCode, loopContext.index, totalAmountForRow, '');
                });
            };
            
            ViewModelSectionBase.prototype._isSectionGas = function(gasId) {
                return objectUtil.isNull(this.isAcceptableGas) || this.isAcceptableGas(gasId);
            };
            
            ViewModelSectionBase.prototype._createGasAmount = function(gasId, gasIndex, amount, comment) {
                return {
                    id: gasId,
                    index: gasIndex,
                    amount: isNaN(amount) || objectUtil.isNull(amount) ? null : Number(amount),
                    comment: comment
                };
            };
            
            return ViewModelSectionBase;
        }
    ]);
})();


(function() {
    angular.module('FGases.viewmodel').factory('ViewModelSubmission', [
       
        '$translate', 'ViewModelObjectBase', 'objectUtil',
        
        function($translate, ViewModelObjectBase, objectUtil) {
            function ViewModelSubmission(viewModel) {
                if (!(this instanceof ViewModelSubmission)) {
                    return new ViewModelSubmission(viewModel);
                }
                
                ViewModelObjectBase.call(this, viewModel);
            }
            
            objectUtil.chainConstructor(ViewModelObjectBase, ViewModelSubmission);
            
            ViewModelSubmission.prototype.getErrorCategoryName = function(errorMessage) {
                var id;
                
                if (errorMessage.isBlocker) {
                    id = "submission.error-level-blocker";
                }
                else {
                    id = "submission.error-level-warning";
                }
                
                return $translate.instant(id);
            };
            
            ViewModelSubmission.prototype.getErrorCategoryClass = function(errorMessage) {
                if (errorMessage.isBlocker) {
                    return "text-danger";
                }
                else {
                    return "text-warning";
                }
            };
            
            return ViewModelSubmission;
        }
    ]);
})();


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

/**
 * Created by argoaava on 13.05.14.
 */

angular.module('ui.errorMapper', [])
    .service('errorMapperService', function() {
        this.errorMappings = {
            "required" : "This is a required field",
            "pattern_decimal" : "Please provide a number greater than 0",
            "pattern_integer" : "Please provide a whole number greater than 0",
            "pattern_telephone" : "Please enter a valid telephone number (at least 7 digits)",
            "pattern_email" : "Please enter a valid email address",
            "pattern_url" : "Please enter a valid URL"};

        this.getErrorMappings = function() {
            return this.errorMappings;
        }

        this.addErrorMapping = function(key, message) {
            this.errorMappings[key] = message;
        }

        this.setErrorMappings = function(errorMappings) {
            this.errorMappings = errorMappings;
        }
    })
    .controller("ErrorController", function ($scope, errorMapperService) {

        $scope.errorMappings = errorMapperService.getErrorMappings();
        $scope.showCurrentError = false;

        $scope.getErrorMessage = function(errorCode) {
            return $scope.errorMappings[errorCode];
        };

        $scope.getController = function(attributes) {
            if (!attributes.watchView) {
                return null;
            }
            var tokens = attributes.watchView.split(".");
            var result = $scope;
            while(tokens.length) {
                result = result[tokens.shift()];
                if (!result) {
                    return null;
                }
            }
            return result;
        };

        $scope.parseErrors = function(ctrl, attributes) {
            var fieldNameIdentifier = !attributes.watchView? attributes.errorMapper : attributes.watchView;
            var nameTokens = fieldNameIdentifier.split('.');
            var name = nameTokens[1];

            var fieldController = !ctrl[name]? $scope.getController(attributes) : ctrl[name];
            if (!fieldController) {
                if (!attributes.radioButtonValues) {
                    throw Error("input field controller not found for " + attributes.errorMapper);
                } else {
                    var radioButtonValues = JSON.parse(attributes.radioButtonValues);
                    $scope.showCurrentError = !radioButtonValues.value && $scope.submitted && radioButtonValues.required;
                    $scope.currentErrorCode = 'required';
                    return;
                }
            }

            var controllerErrors = fieldController.$error;
            var errorsToShowAsArray = JSON.parse(attributes.errorsToShow);

            for (var i = 0; i < errorsToShowAsArray.length; i++) {
                var splitErrorString = errorsToShowAsArray[i].split('_');
                var strippedErrorString = splitErrorString[0];
                if (controllerErrors[strippedErrorString]) {
                    $scope.showCurrentError = $scope.showError(fieldController, strippedErrorString);
                    $scope.currentErrorCode = errorsToShowAsArray[i];
                    break;
                } else {
                    $scope.showCurrentError = false;
                }
            }
        }

        $scope.showError = function(modelController, errorCode) {
            return ($scope.submitted || modelController.$dirty) && modelController.$error[errorCode] && modelController.$invalid;
        };
    })

    // Error mapper directive to simplify showing errors for input fields and get rid of some
    // boilerplate code.
    //
    // Usage:
    //
    // <input name="Money" ng-model="instance.MMRArticle17Questionnaire.Table1.Money" type="text"
    //      ng-pattern="decimalNumberPattern" required/>
    // <div class="invalid-msg" td-error-mapper watch-elements='["Table1.OtherDescription"]'
    //      watch-view="Form.InputName" errors-to-show='["required", "pattern_decimal"]'></div>
    // ...
    // Where <div> with 'td-error-mapper' attribute is used as error div and all functionality is applied.
    //
    // Configuration parameters:
    // td-error-mapper - identifier for error mapper and scope parameter watcher e.g td-error-mapper="userName". Whenever
    //                   $scope.userName changes it is picked up by mapper and correct error is shown when identified.
    // watch-view      - Used to watch view value of the field. Useful for watching number fields etc. when actual scope
    //                   value does not change on invalid field value.
    //                   Should be used as {FormName}.{InputName} so InputName can be extracted to get correct controller.
    // watch-elements  - Array of string that is parsed and registered for watching. Whenever 'Table1.OtherDescription'
    //                   changes then parse function is called and correct errors show for current input.
    // errors-to-show  - Errors to be shown as array. This string is parsed and errors are shown in the same order
    //                   as array. Names can be used for different kind of messages as follows e.g "pattern_decimal"
    //                   means error type is pattern and message type decimal. First part is extracted used together with
    //                   angular ng-pattern directive to get correct result.
    .directive('errorMapper',function () {
        return {
            restrict: 'A',
            require: '?^form',
            scope: true,
            controller: 'ErrorController',
            template: '<span ng-show=\"showCurrentError\">{{getErrorMessage(currentErrorCode)}}</span>',
            link: function(scope, element, attrs, ctrl) {
                if (!attrs.watchView) {
                    scope.$watch(attrs.errorMapper, function() {
                        scope.parseErrors(ctrl, attrs);
                    });
                } else {
                    scope.$watch(attrs.watchView + ".$viewValue", function() {
                        scope.parseErrors(ctrl, attrs);
                    });
                }

                scope.$watch('submitted', function() {
                    scope.parseErrors(ctrl, attrs);
                });

                //For watching other values that this error depends on
                if (attrs.watchElements) {
                    var watchArray = JSON.parse(attrs.watchElements);
                    for (var i = 0; i < watchArray.length; i++) {
                        scope.$watch(watchArray[i] + ".$viewValue", function() {
                            scope.parseErrors(ctrl, attrs);
                        });
                    }
                }

            }
        };
    });
/**
 * Created by argoaava on 13.05.14.
 */


// Module that contains functionality for tab navigation. User must fill 'tabService' with
// available tabs as follows:
//
// app.run(function($rootScope, promiseTracker, $location, tabService) {
//      tabService.setTabs([
//          {"id":"Table1","active" : true},
//          {"id":"Table2","active" : false},
//          {"id":"Table3","active" : false},
//          {"id":"Table4","active" : false},
//          {"id":"Table5","active" : false}]);
// });
//
// then 'TabController' must be set to elements that want to interact with
// tabService.
//
// <ul tabset ng-cloak ng-controller="TabController">
//      <div ng-class="{'invalidTab' : isInvalidTab('Table1')}">
//          <li tab heading="Table 1" active="tabs[getTabIndex('Table1')].active">
//          </li>
//      </div>
// </ul>
//
// or
//
// <div class="animate-show" ng-show="showMenu" style="float:right" ng-controller="TabController">
//      <input type="button" ng-click="previousTab()" value="Prev" class="btn btn-default btn-primary" ng-disabled="getActiveTabIndex() == 0">
//      <input type="button" ng-click="nextTab()" value="Next" class="btn btn-default btn-primary" ng-disabled="getActiveTabIndex() == (tabs.length - 1)"/>
// </div>
//
angular.module('tabs.formTabs', [])
    .service('tabService', function() {
        this.tabs = [];
        this.showValidationMessages = true;

        this.getTabs = function() {
            return this.tabs;
        };

        this.setTabs = function(tabs) {
            this.tabs = tabs;
        };

        this.gotoTab = function(tab) {
            var tabs = this.getTabs();
            for (var i = 0; i < tabs.length; i++) {
                if (tabs[i].id == tab) {
                    tabs[i].active = true;
                } else {
                    tabs[i].active = false;
                }
            }
        };

        this.getActiveTabIndex = function() {
            var tabs = this.getTabs();
            for (var i = 0; i < tabs.length; i++) {
                if (tabs[i].active == true) {
                    return i;
                }
            }
            return 0;
        };
    })
    .controller("TabController", function ($scope, $location, $timeout, $anchorScroll, tabService) {

        if (tabService.getTabs().length == 0) {
            throw Error("You must configure tabService");
        }

        $scope.tabs = tabService.tabs;

        $scope.hideValidationMessages = function () {
            tabService.showValidationMessages = false;
        };
        $scope.setShowValidationMessages = function () {
            $scope.valMsgIndex = 0;
            tabService.showValidationMessages = true;
        };
        $scope.isShowValidationMessages = function () {
            return tabService.showValidationMessages;
        };

        $scope.goto = function (tab, id){
            for (var i = 0; i < $scope.tabs.length; i++) {
                if ($scope.tabs[i].id == tab) {
                    $scope.tabs[i].active = true;
                } else {
                    $scope.tabs[i].active = false;
                }
            }

            var old = $location.hash();
            $timeout(function() {
                $location.hash(id);
                $anchorScroll();
                $location.hash(old);
            }, 200);
            $scope.valMsgIndex = 0;
        };

        $scope.getActiveTabIndex = function() {
            for (var i = 0; i < $scope.tabs.length; i++) {
                if ($scope.tabs[i].active == true) {
                    return i;
                }
            }
            return 0;
        };

        $scope.getTabIndex = function(tabId) {
            for (var i = 0; i < $scope.tabs.length; i++) {
                if ($scope.tabs[i].id == tabId) {
                    return i;
                }
            }
            return -1;
        };

        $scope.nextTab = function(){
            var activeTabIndex = $scope.getActiveTabIndex();
            var nextTab = (activeTabIndex + 1 <= $scope.tabs.length)? activeTabIndex + 1 : activeTabIndex;
            $scope.goto($scope.tabs[nextTab].id, 'beginning');
        };

        $scope.previousTab = function(){
            var activeTabIndex = $scope.getActiveTabIndex();
            var previousTab = (activeTabIndex - 1 >= 0)? activeTabIndex - 1 : activeTabIndex;
            $scope.goto($scope.tabs[previousTab].id, 'beginning');
        };

        $scope.isInvalidTab = function(tabId) {
            return $scope.submitted && $scope.appForm[tabId].$invalid;
        };
    });
//# sourceMappingURL=fxparser.min.js.map
/**
 * Created by argoaava on 22.04.14.
 */

// Module that provides language changing functionality to webform.
//
// Module needs configuration and <div td-language-changer></div> or <td-language-changer/> tags.
// td-language-changer component is replaced with language select input that is configured to use
// pre-configured values.
//
// Example configuration of languageChanger
//
// app.config(["languageChangerProvider", function(languageChangerProvider) {
//    languageChangerProvider.setDefaultLanguage('en');
//    languageChangerProvider.setLanguageFilePrefix('en-labels-');
//    languageChangerProvider.setAvailableLanguages({"item" :[{
//        "code": "bg",
//        "label": "Български (bg)"}, {
//        "code": "cs",
//        "label": "čeština (cs)"}, {
//        "code": "hr",
//        "label": "Hrvatski (hr)"}, {
//        "code": "da",
//        "label": "Dansk (da)"}, {
//        "code": "nl",
//        "label": "Nederlands (nl)"}, {
//        "code": "el",
//        "label": "ελληνικά (el)"}, {
//        "code": "en",
//        "label": "English (en)"}, {
//        "code": "et",
//        "label": "Eesti (et)"}, {
//        "code": "fi",
//        "label": "Suomi (fi)"}, {
//        "code": "fr",
//        "label": "Français (fr)"}, {
//        "code": "de",
//        "label": "Deutsch (de)"}, {
//        "code": "hu",
//        "label": "Magyar (hu)"}, {
//        "code": "is",
//        "label": "Íslenska (is)"}, {
//        "code": "it",
//        "label": "Italiano (it)"}, {
//        "code": "lv",
//        "label": "Latviešu (lv)"}, {
//        "code": "lt",
//        "label": "Lietuvių (lt)"}, {
//        "code": "mt",
//        "label": "Malti (mt)"}, {
//        "code": "no",
//        "label": "Norsk (no)"}, {
//        "code": "pl",
//        "label": "Polski (pl)"}, {
//        "code": "pt",
//        "label": "Português (pt)"}, {
//        "code": "ro",
//        "label": "Română (ro)"}, {
//        "code": "sk",
//        "label": "Slovenčina (sk)"}, {
//        "code": "sl",
//        "label": "Slovenščina (sl)"}, {
//        "code": "es",
//        "label": "Español (es)"}, {
//        "code": "sv",
//        "label": "Svenska (sv)"}, {
//        "code": "tr",
//        "label": "Türkçe (tr)"}]})
//}]);


angular.module('translate.languageChanger', ['pascalprecht.translate'])
    .factory('customLoader', function ($q, languageChanger, dataProxy) {
        return function (options) {
            var deferred = $q.defer();

            if (!languageChanger.getLanguageFilePrefix()) {
                throw new Error("Language file prefix must be defined when using languageChanger component.");
            }

            var labelsFileName = languageChanger.getLanguageFilePrefix() + options.key;
            
            dataProxy.getLabelsFile(labelsFileName).success(function (data) {
                deferred.resolve(data.labels);
                //alert('label-' + options.key + '.json' +' success');
            }).error(function () {
                deferred.reject(options.key);
                //alert('label-' + options.key + '.json' +' error');
            });
            //alert(options.key);
            return deferred.promise;
        };
    })

    .provider('languageChanger', function languageChangerProvider() {

        this.currentLanguage = 'en';
        this.availableLanguages = [];
        this.languageFilePrefix = '';

        this.setDefaultLanguage = function(defaultLanguage) {
            this.currentLanguage = defaultLanguage;
        };

        this.setLanguageFilePrefix = function(prefix) {
            this.languageFilePrefix = prefix;
        };

        this.setAvailableLanguages = function(availableLanguages) {
            this.availableLanguages = availableLanguages;
        };

        this.$get = function() {
            var availableLanguages = this.availableLanguages;
            var currentLanguage = this.currentLanguage;
            var prefix = this.languageFilePrefix;
            return {
                getLanguage : function() {return currentLanguage;},
                setLanguage : function(newLanguage) {currentLanguage = newLanguage;},
                getAvailableLanguages : function() {return availableLanguages;},
                getLanguageFilePrefix : function() {return prefix;}
            }
        };
    })

    .config( function ($translateProvider) {
        $translateProvider.useLoader('customLoader', {});
        // load 'en' table on startup
        $translateProvider.preferredLanguage('en');
    })

    .controller('LanguageCtrl', ['$scope', '$rootScope', '$translate', 'languageChanger', 'dataRepository', function ($scope, $rootScope, $translate, languageChanger, dataRepository) {

        $scope.currentLanguage = languageChanger.getLanguage();
        $scope.availableLanguages = languageChanger.getAvailableLanguages();

        $scope.changeLang = function () {
            languageChanger.setLanguage($scope.currentLanguage)
            $translate.use(languageChanger.getLanguage());
            dataRepository.loadCodeList(languageChanger.getLanguage());
            if (languageChanger.getLanguage() != $rootScope.currentLanguage) {
                $rootScope.currentLanguage = languageChanger.getLanguage()
            }
        };
        $rootScope.$watch('currentLanguage', function(newValue, oldValue) {
            if (!newValue) {
                return;
            } else {
                if (!oldValue || (languageChanger.getLanguage() != $rootScope.currentLanguage)) {
                    $scope.currentLanguage = $rootScope.currentLanguage;
                    $scope.changeLang();
                }
            }
        })
    }])

    .directive("languageChanger", function () {
        return {
            restrict: 'A',
            controller: 'LanguageCtrl',
            template: "<div ng-show=\"availableLanguages.item.length > 0\" class=\"span2\" ng-controller=\"LanguageCtrl\" style=\"float: right;\"><select name=\"FormLanguage\" class=\"input-medium\" ng-model=\"currentLanguage\" ng-options=\"language.code as language.label for language in availableLanguages.item\" ng-change=\"changeLang()\"></select></div>"
        }
    })
// Module that provides multiselect box to webform from json-ld format.
//
// Usage Example:
// <div multiselect class="multiselect" name="TypeOfUse" multiple="true"
//      ng-model="row.TypeOfUse"
//      options="gas.GasId as gas.Code for gas in codeList.FGasesCodelists.FGases.Gas"
//      change="selected()" required></div>
//
// Note! options instead of ng-options is used.
angular.module('ui.multiselect', [
        'multiselect.tpl.html'
    ])

    //from bootstrap-ui typeahead parser
    .factory('optionParser', ['$parse', function ($parse) {

        //                      00000111000000000000022200000000000000003333333333333330000000000044000
        var TYPEAHEAD_REGEXP = /^\s*(.*?)(?:\s+as\s+(.*?))?\s+for\s+(?:([\$\w][\$\w\d]*))\s+in\s+(.*)$/;

        return {
            parse: function (input) {

                var match = input.match(TYPEAHEAD_REGEXP), modelMapper, viewMapper, source;
                if (!match) {
                    throw new Error(
                        "Expected typeahead specification in form of '_modelValue_ (as _label_)? for _item_ in _collection_'" +
                            " but got '" + input + "'.");
                }

                return {
                    itemName: match[3],
                    source: $parse(match[4]),
                    viewMapper: $parse(match[2] || match[1]),
                    modelMapper: $parse(match[1])
                };
            }
        };
    }])

    .directive('multiselect', ['$parse', '$document', '$compile', '$interpolate', 'optionParser',

        function ($parse, $document, $compile, $interpolate, optionParser) {
            return {
                restrict: 'AE',
                require: 'ngModel',
                link: function (originalScope, element, attrs, modelCtrl) {

                    var exp = attrs.options,
                        parsedResult = optionParser.parse(exp),
                        isMultiple = (attrs.multiple === "true") ? true : false,
                        showCheckAll = (attrs.showcheckall === "true") ? true : false,
                        showFilter = (attrs.showfilter === "true") ? true : false,
                        showGroups = (attrs.showgroups === "true") ? true : false,
                        dataFormat = (attrs.dataformat || 'default'),
                        //TODO a better solution can be provided
                        modelIdFieldName = attrs.modelidfieldname || 'GasId',
                        required = false,
                        scope = originalScope.$new(),
                        changeHandler = attrs.change || angular.noop;

                    scope.groups = [];
                    scope.header = 'Select';
                    scope.multiple = isMultiple;
                    scope.disabled = false;
                    scope.showCheckAll = showCheckAll;
                    scope.showFilter = showFilter;
                    scope.dataFormat = dataFormat;
                    scope.showGroups = showGroups;
                    scope.modelIdFieldName = modelIdFieldName;

                    originalScope.$on('$destroy', function () {
                        scope.$destroy();
                    });

                    var popUpEl = angular.element('<multiselect-popup></multiselect-popup>');

                    //required validator
                    if (attrs.required || attrs.ngRequired) {
                        required = true;
                    }
                    attrs.$observe('required', function(newVal) {
                        required = newVal;
                    });

                    //watch disabled state
                    scope.$watch(function () {
                        return $parse(attrs.disabled)(originalScope);
                    }, function (newVal) {
                        scope.disabled = newVal;
                    });

                    //watch single/multiple state for dynamically change single to multiple
                    scope.$watch(function () {
                        return $parse(attrs.multiple)(originalScope);
                    }, function (newVal) {
                        isMultiple = newVal || false;
                    });

                    //watch option changes for options that are populated dynamically
                    scope.$watch(function () {
                        return parsedResult.source(originalScope);
                    }, function (newVal) {
                        if (angular.isDefined(newVal))
                            parseModel();
                    }, true);

                    //watch model change
                    scope.$watch(function () {
                        return modelCtrl.$modelValue;
                    }, function (newVal, oldVal) {
                        //when directive initialize, newVal usually undefined. Also, if model value already set in the controller
                        //for preselected list then we need to mark checked in our scope item. But we don't want to do this every time
                        //model changes. We need to do this only if it is done outside directive scope, from controller, for example.
                        if (angular.isDefined(newVal)) {
                            markChecked(newVal);
                            scope.$eval(changeHandler);
                        }
                        getHeaderText();
                        modelCtrl.$setValidity('required', scope.valid());
                    }, true);

                    //TODO this code should be updated to be more generic
                    function parseModel() {
                        scope.groups.length = 0;
                        var model = parsedResult.source(originalScope);
                        var groupIndex = 0;
                        var groupIdIndexMap = {};
                        var defaultGroup = {};
                        defaultGroup.items = [];
                        if(!angular.isDefined(model)) return;

                        switch (scope.dataFormat){
                            case 'json-ld':
                                //TODO not working properly, for json-ld data format, this part should be updated!
                                for (var i = 0; i < model.length; i++) {
                                    if (angular.isDefined(model[i].narrower) && model[i].narrower.length > 0){
                                        //now we have groups
                                        scope.groups[groupIndex] = { "name" : model[i].prefLabel[0]['@value'], "items" : []};
                                        groupIdIndexMap[model[i]['@id']] = groupIndex;
                                        groupIndex++;
                                        continue;
                                    }

                                    var group = defaultGroup; //if there is no group or group cannot be found, then add it to default group
                                    if (angular.isDefined(model[i].broader) && model[i].broader.length == 1 && angular.isDefined(groupIdIndexMap[model[i].broader[0]['@id']])) {
                                        //now we have a sub element
                                        group = scope.groups[groupIdIndexMap[model[i].broader[0]['@id']]];
                                    }

                                    var local = {};
                                    local[parsedResult.itemName] = model[i];
                                    var checked = false;
                                    if (modelCtrl.$modelValue) {
                                        if(!(modelCtrl.$modelValue instanceof Array) && model[i]['@id'] === modelCtrl.$modelValue) {
                                            checked = true;
                                        } else if((modelCtrl.$modelValue instanceof Array) && contains(modelCtrl.$modelValue, model[i]['@id'])) {
                                            checked = true;
                                        }
                                    }

                                    group.items.push({
                                        label: parsedResult.viewMapper(local),
                                        model: model[i]['@id'],
                                        checked: checked
                                    });
                                }

                                // now add default group
                                scope.groups[groupIndex] = defaultGroup;
                                break; //end of json-ld data format parsing
                            case 'default':
                            default:
                                for (var i = 0; i < model.length; i++) {
                                    var group = defaultGroup;
                                    if (angular.isDefined(model[i].GasGroupId) && model[i].GasGroupId != null) {
                                        //now we have groups
                                        var groupId = model[i].GasGroupId;
                                        var groupName = model[i].GasGroupName;
                                        var codeId = model[i][scope.modelIdFieldName];
                                        // different display groups for blends: 404A, 407C,410A & 507A
                                        if (groupId == 7) {
                                            if (codeId == 26 || codeId == 27 || codeId == 28 || codeId == 29) {
                                                groupId = "77";
                                                groupName = "Most commonly used mixtures";
                                            } else {
                                                groupName = "Other commonly used mixtures";
                                            }
                                        }

                                        if (angular.isDefined(groupIdIndexMap[groupId])) {
                                            group = scope.groups[groupIdIndexMap[groupId]];
                                        } else {
                                            scope.groups[groupIndex] = { name: groupName, items: [] };
                                            groupIdIndexMap[groupId] = groupIndex;
                                            group = scope.groups[groupIndex];
                                            groupIndex++;
                                        }
                                    }


                                    var local = {};
                                    local[parsedResult.itemName] = model[i];
                                    var checked = false;
                                    if (modelCtrl.$modelValue) {
                                        if (!(modelCtrl.$modelValue instanceof Array) && model[i][scope.modelIdFieldName] === modelCtrl.$modelValue) {
                                            checked = true;
                                        } else if ((modelCtrl.$modelValue instanceof Array) && contains(modelCtrl.$modelValue, model[i][scope.modelIdFieldName])) {
                                            checked = true;
                                        }
                                    }

                                    group.items.push({
                                        label: parsedResult.viewMapper(local),
                                        model: model[i][scope.modelIdFieldName],
                                        checked: checked
                                    });
                                }

                                scope.groups[groupIndex] = defaultGroup;
                                //Reorder: first Most commonly, then Other commonly
                                scope.groups.sort(function (a, b) {
                                    if (a.name === "Most commonly used mixtures") return -1;
                                    if (b.name === "Most commonly used mixtures") return 1;
                                    return 0;
                                });

                                break;
                        }
                    } //end of function parseModel

                    function contains(array, needle) {
                        for (var i = 0; i < array.length; i++){
                            if (array[i] == needle) {
                                return true;
                            }
                        }
                        return false;
                    }

                    parseModel();

                    element.append($compile(popUpEl)(scope));

                    function getHeaderText() {
                        var defaultHeader = 'Select';

                        if (!modelCtrl.$modelValue) return scope.header = attrs.msHeader || defaultHeader;

                        if (modelCtrl.$modelValue && modelCtrl.$modelValue instanceof Array) {
                            if (attrs.msSelected) {
                                scope.header = $interpolate(attrs.msSelected)(scope);
                            } else {
                                scope.header = modelCtrl.$modelValue[0] != ''? modelCtrl.$modelValue.length + ' ' + 'selected' : defaultHeader;
                            }

                        } else if(modelCtrl.$modelValue && typeof 0){
                            scope.header = '1 selected';
                        } else {
                            var local = {};
                            local[parsedResult.itemName] = modelCtrl.$modelValue;
                            scope.header = parsedResult.viewMapper(local);
                        }
                    }

                    function is_empty(obj) {
                        if (!obj) return true;
                        if (obj.length && obj.length > 0) return false;
                        for (var prop in obj) if (obj[prop]) return false;
                        return true;
                    };

                    scope.valid = function validModel() {
                        if(!required) return true;
                        var value = modelCtrl.$modelValue;
                        return (angular.isArray(value) && value.length > 0) || (!angular.isArray(value) && value != null);
                    };

                    function selectSingle(item) {
                        if (item.checked) {
                            scope.uncheckAll();
                        } else {
                            scope.uncheckAll();
                            item.checked = !item.checked;
                        }
                        setModelValue(false);
                    }

                    function selectMultiple(item) {
                        item.checked = !item.checked;
                        setModelValue(true);
                    }

                    function setModelValue(isMultiple) {
                        var value;

                        if (isMultiple) {
                            value = [];
                            angular.forEach(scope.groups, function (group) {
                                angular.forEach(group.items, function (item) {
                                    if (item.checked == true){
                                        value.push(item.model);
                                    }
                                })
                            })
                        } else {
                            angular.forEach(scope.groups, function (group) {
                                angular.forEach(group.items, function (item) {
                                    if (item.checked == true) {
                                        value = item.model;
                                        return false;
                                    }
                                })
                            })
                        }
                        modelCtrl.$setViewValue(value);
                        modelCtrl.$render();
                    }

                    function markChecked(newVal) {
                        if (!angular.isArray(newVal)) {
                            if (!!newVal && typeof newVal !== "string") {
                                newVal = newVal.toString();
                            }
                            angular.forEach(scope.groups, function (group) {
                                angular.forEach(group.items, function (item) {
                                    if (angular.equals(item.model, newVal)) {
                                        item.checked = true;
                                        return false;
                                    }
                                })
                            });
                        } else {
                            angular.forEach(scope.groups, function (group) {
                                angular.forEach(group.items, function (item) {
                                    item.checked = false;
                                    angular.forEach(newVal, function (i) {
                                        if (!!i && typeof i !== "string") {
                                            i = i.toString();
                                        }
                                        if (angular.equals(item.model.toString(), i)) {
                                            item.checked = true;
                                        }
                                    });
                                })
                            });
                        }
                    }

                    scope.checkAll = function () {
                        if (!isMultiple) return;
                        angular.forEach(scope.groups, function (group) {
                            angular.forEach(group.items, function (item) {
                                item.checked = true;
                            })
                        });
                        setModelValue(true);
                    };

                    scope.uncheckAll = function () {
                        angular.forEach(scope.groups, function (group) {
                            angular.forEach(group.items, function (item) {
                                item.checked = false;
                            })
                        });
                        setModelValue(true);
                    };

                    scope.select = function (item) {
                        if (isMultiple === false) {
                            selectSingle(item);
                            scope.toggleSelect();
                        } else {
                            selectMultiple(item);
                        }
                    }
                }
            };
        }])

    .directive('multiselectPopup', ['$document', function ($document) {
        return {
            restrict: 'AE',
            scope: false,
            replace: true,
            templateUrl: 'multiselect.tpl.html',
            link: function (scope, element, attrs) {

                scope.isVisible = false;

                scope.toggleSelect = function () {
                    if (element.hasClass('open')) {
                        element.removeClass('open');
                        $document.unbind('click', clickHandler);
                    } else {
                        element.addClass('open');
                        $document.bind('click', clickHandler);
                        //scope.focus();
                    }
                };

                function clickHandler(event) {
                    if (elementMatchesAnyInArray(event.target, element.find(event.target.tagName)))
                        return;
                    element.removeClass('open');
                    $document.unbind('click', clickHandler);
                    scope.$apply();
                }

//                scope.focus = function focus(){
//                    var searchBox = element.find('input')[0];
//                    searchBox.focus();
//                }

                var elementMatchesAnyInArray = function (element, elementArray) {
                    for (var i = 0; i < elementArray.length; i++)
                        if (element == elementArray[i])
                            return true;
                    return false;
                }
            }
        }
    }]);

angular.module('multiselect.tpl.html', [])

    .run(['$templateCache', function($templateCache) {
        $templateCache.put('multiselect.tpl.html',

            "<div class=\"dropdown\">\n" +
                "  <button type=\"button\" class=\"btn btn-default\" ng-click=\"toggleSelect()\" ng-disabled=\"disabled\" ng-class=\"{'error': !valid()}\">\n" +
                "    {{header}} <span class=\"caret\"></span>\n" +
                "  </button>\n" +
                "  <ul class=\"dropdown-menu\">\n" +
                "    <li ng-show=\"showFilter\">\n" +
                "      <input class=\"form-control input-sm\" type=\"text\" ng-model=\"searchText.label\" autofocus=\"autofocus\" placeholder=\"Filter\" />\n" +
                "    </li>\n" +
                "    <li ng-show=\"multiple && showCheckAll\" role=\"presentation\" class=\"\">\n" +
                "      <button class=\"btn btn-link btn-xs\" ng-click=\"checkAll()\" type=\"button\"><i class=\"glyphicon glyphicon-ok\"></i> Check all</button>\n" +
                "      <button class=\"btn btn-link btn-xs\" ng-click=\"uncheckAll()\" type=\"button\"><i class=\"glyphicon glyphicon-remove\"></i> Uncheck all</button>\n" +
                "    </li>\n" +
                "    <div ng-repeat=\"i in groups\">\n" +
                "       <div ng-show=\"showGroups\" class=\"multiselect-group-heading\">\n" +
                "           <h5>{{i.name}}</h5>"+
                "       </div>\n" +
                "       <div class=\"dropdown-container\" ng-repeat=\"j in i.items | filter:searchText\">\n" +
                "           <a ng-click=\"select(j); focus()\">\n" +
                //"             <i ng-class=\"{'glyphicon glyphicon-ok': j.checked, 'glyphicon glyphicon-empty': !j.checked}\"></i> {{j.label}}</a>\n" + updated from habides multiselect
                "               <span ng-if=\"j.checked\" class=\"glyphicon glyphicon-ok\"></span><span ng-if=\"!j.checked\" class=\"glyphicon glyphicon-empty\"></span><label><span ng-if=\"showCode\" >{{j.model}} - </span>{{j.label}}</label></a>\n" +
                "       </div>\n" +
                "    </div>\n" +
                "  </ul>\n" +
                "</div>");
    }]);
/**
 * Created by argoaava on 22.04.14.
 */

// Module that provides functionality to ask confirmation from user when
// form has changed and user tries to leave page without saving.
//
// Usage example:
//
// <div ng-form="appForm" novalidate class="css-form" ng-class="{ 'submitted' : submitted }" td-navigation-blocker-form>
//
// 'td-navigation-blocker-form' must be specified as attribute for the form that confirmation functionality
// must apply to.

//FIXME should be able to make it so that rootScope is not used.
angular.module('navigation.navigationBlocker', [])
    .run(['$rootScope', '$location', function ($rootScope, $location) {
        var _preventNavigation = false;
        var _preventNavigationUrl = null;

        $rootScope.allowNavigation = function() {
            _preventNavigation = false;
        };

        $rootScope.preventNavigation = function() {
            _preventNavigation = true;
            _preventNavigationUrl = $location.absUrl();
        }

        $rootScope.$on('$locationChangeStart', function (event, newUrl, oldUrl) {
            // Allow navigation if our old url wasn't where we prevented navigation from
            if (_preventNavigationUrl != oldUrl || _preventNavigationUrl == null) {
                $rootScope.allowNavigation();
                return;
            }

            if (_preventNavigation && !confirm("You have unsaved changes, do you want to continue?")) {
                event.preventDefault();
            }
            else {
                $rootScope.allowNavigation();
            }
        });

        // Take care of preventing navigation out of our angular app
        window.onbeforeunload = function() {
            // Use the same data that we've set in our angular app
            if (_preventNavigation && $location.absUrl() == _preventNavigationUrl) {
                return "You have unsaved changes, do you want to continue?";
            }
        }
    }])

    .directive("blockFormNavigation", function () {
        return {
            restrict: 'A',
            require: ['^form'],
            link: function (scope, element, attrs, formController) {
                scope.$watch(attrs.ngForm + '.$dirty', function (dirty) {
                    if (dirty) {
                        scope.$root.preventNavigation();
                    } else {
                        scope.$root.allowNavigation();
                    }
                });
            }
        }
    })


//  Service for creating notifications.
//  Origin: https://github.com/DerekRies/Angular-Notifications
//
//  Dependencies:
//      It use Bootstrab component:  http://getbootstrap.com/components/

//  Installation:
//      1. Add script file:
//          <script src="notification.js"></script>
//
//      2. Add css to your webform:
//          <link rel="stylesheet" href="notification.css"/>
//
//      3. Add notifications module as a dependency of your app module:
//          e.g angular.module('ngcomponentsApp', ['notifications'])
//
//      4. Add a div to your body tag somewhere and give it a
//          notifications directive specifying its position like so:
//              <div notifications="bottom right"></div>
//
// Usage Example:
//      You can use these methods with the following
//      line of code (userData parameter is optional, currently title is not used):
//
//    $notification.info(title, content, userData);
//    $notification.warning(title, content, userData);
//    $notification.error("Save", "Data is not saved !");
//    $notification.success("Save", "Data is saved successfully.");
//
angular.module('notifications', []).
    factory('$notification', ['$timeout',function($timeout){

        //console.log('notification service online');
        var notifications = JSON.parse(localStorage.getItem('$notifications')) || [],
            queue = [];

        var settings = {
            info: { duration: 5000, enabled: true },
            warning: { duration: 5000, enabled: true },
            error: { duration: 5000, enabled: true },
            success: { duration: 5000, enabled: true },
            progress: { duration: 0, enabled: true },
            custom: { duration: 35000, enabled: true },
            details: true,
            localStorage: false,
            html5Mode: false,
            html5DefaultIcon: 'icon.png'
        };

        function html5Notify(icon, title, content, ondisplay, onclose){
            if(window.webkitNotifications.checkPermission() === 0){
                if(!icon){
                    icon = 'favicon.ico';
                }
                var noti = window.webkitNotifications.createNotification(icon, title, content);
                if(typeof ondisplay === 'function'){
                    noti.ondisplay = ondisplay;
                }
                if(typeof onclose === 'function'){
                    noti.onclose = onclose;
                }
                noti.show();
            }
            else {
                settings.html5Mode = false;
            }
        }


        return {

            /* ========== SETTINGS RELATED METHODS =============*/

            disableHtml5Mode: function(){
                settings.html5Mode = false;
            },

            disableType: function(notificationType){
                settings[notificationType].enabled = false;
            },

            enableHtml5Mode: function(){
                // settings.html5Mode = true;
                settings.html5Mode = this.requestHtml5ModePermissions();
            },

            enableType: function(notificationType){
                settings[notificationType].enabled = true;
            },

            getSettings: function(){
                return settings;
            },

            toggleType: function(notificationType){
                settings[notificationType].enabled = !settings[notificationType].enabled;
            },

            toggleHtml5Mode: function(){
                settings.html5Mode = !settings.html5Mode;
            },

            requestHtml5ModePermissions: function(){
                if (window.webkitNotifications){
                    //console.log('notifications are available');
                    if (window.webkitNotifications.checkPermission() === 0) {
                        return true;
                    }
                    else{
                        window.webkitNotifications.requestPermission(function(){
                            if(window.webkitNotifications.checkPermission() === 0){
                                settings.html5Mode = true;
                            }
                            else{
                                settings.html5Mode = false;
                            }
                        });
                        return false;
                    }
                }
                else{
                    //console.log('notifications are not supported');
                    return false;
                }
            },


            /* ============ QUERYING RELATED METHODS ============*/

            getAll: function(){
                // Returns all notifications that are currently stored
                return notifications;
            },

            getQueue: function(){
                return queue;
            },

            /* ============== NOTIFICATION METHODS ==============*/

            info: function(title, content, userData){
                //console.log(title, content);
                return this.awesomeNotify('info','info-sign', title, content, userData);
            },

            error: function(title, content, userData){
                return this.awesomeNotify('error', 'remove-sign', title, content, userData);
            },

            success: function(title, content, userData){
                return this.awesomeNotify('success', 'ok-sign', title, content, userData);
            },

            warning: function(title, content, userData){
                return this.awesomeNotify('warning', 'exclamation-sign', title, content, userData);
            },

            awesomeNotify: function(type, icon, title, content, userData){
                /**
                 * Supposed to wrap the makeNotification method for drawing icons using font-awesome
                 * rather than an image.
                 *
                 * Need to find out how I'm going to make the API take either an image
                 * resource, or a font-awesome icon and then display either of them.
                 * Also should probably provide some bits of color, could do the coloring
                 * through classes.
                 */
                // image = '<i class="icon-' + image + '"></i>';
                return this.makeNotification(type, false, icon, title, content, userData);
            },

            notify: function(image, title, content, userData){
                // Wraps the makeNotification method for displaying notifications with images
                // rather than icons
                return this.makeNotification('custom', image, true, title, content, userData);
            },

            makeNotification: function(type, image, icon, title, content, userData){
                var notification = {
                    'type': type,
                    'image': image,
                    'icon': icon,
                    'title': title,
                    'content': content,
                    'timestamp': +new Date(),
                    'userData': userData
                };
                notifications.push(notification);

                if(settings.html5Mode){
                    html5Notify(image, title, content, function(){
                        //console.log("inner on display function");
                    }, function(){
                        //console.log("inner on close function");
                    });
                }
                else{
                    queue.push(notification);
                    $timeout(function removeFromQueueTimeout(){
                        queue.splice(queue.indexOf(notification), 1);
                    }, settings[type].duration);

                }

                this.save();
                return notification;
            },


            /* ============ PERSISTENCE METHODS ============ */

            save: function(){
                // Save all the notifications into localStorage
                // console.log(JSON);
                if(settings.localStorage){
                    localStorage.setItem('$notifications', JSON.stringify(notifications));
                }
                // console.log(localStorage.getItem('$notifications'));
            },

            restore: function(){
                // Load all notifications from localStorage
            },

            clear: function(){
                notifications = [];
                this.save();
            }

        };
    }]).
    directive('notifications', ['$notification', '$compile', function($notification, $compile){
        /**
         *
         * It should also parse the arguments passed to it that specify
         * its position on the screen like "bottom right" and apply those
         * positions as a class to the container element
         *
         * Finally, the directive should have its own controller for
         * handling all of the notifications from the notification service
         */
        //console.log('this is a new directive');
        var html =
            '<div class="dr-notification-wrapper" ng-repeat="noti in queue">' +
                '<div class="dr-notification-close-btn" ng-click="removeNotification(noti)">' +
                    '<i class="glyphicon glyphicon-remove"></i>' +
                '</div>' +
                '<div class="dr-notification noti-back-ground-{{noti.type}}">' +
                    '<div class="dr-notification-image dr-notification-type-{{noti.type}}" ng-switch on="noti.image">' +
                        '<i class="glyphicon glyphicon-{{noti.icon}}" ng-switch-when="false"></i>' +
                        '<img ng-src="{{noti.image}}" ng-switch-default />' +
                    '</div>' +
                    '<div class="dr-notification-content">' +
                        /*'<h3 class="dr-notification-title">{{noti.title}}</h3>' + */
                        '<p class="dr-notification-text">{{noti.content}}</p>' +
                    '</div>' +
                '</div>' +
            '</div>';


        function link(scope, element, attrs){
            var position = attrs.notifications;
            position = position.split(' ');
            element.addClass('dr-notification-container');
            for(var i = 0; i < position.length ; i++){
                element.addClass(position[i]);
            }
        }


        return {
            restrict: 'A',
            scope: {},
            template: html,
            link: link,
            controller: ['$scope', function NotificationsCtrl( $scope ){
                $scope.queue = $notification.getQueue();

                $scope.removeNotification = function(noti){
                    $scope.queue.splice($scope.queue.indexOf(noti), 1);
                };
            }
            ]

        };
    }]);

/**
 * Created by argoaava on 13.05.14.
 */

//Checks if array is empty.
function isEmptyArray(array) {
    if (!(array instanceof Array)) {
        throw Error("Element not array");
    }

    for (var i = 0; i < array.length; i++) {
        if (!array[i]) {
            continue;
        } else {
            return false;
        }
    }
    return true;
}

// Counts all properties of an object or array.
// Reduces the count by one when object is considered fixed question
// in this case first element of object is prefilled and must not be counted.
function countNonEmptyProperties(objectOrArray, isFixedQuestion) {
    var count = 0;

    if (!(objectOrArray instanceof Array)) {
        count = countObjectProperties(objectOrArray);
    } else {
        for (var i = 0; i < objectOrArray.length; i++) {
            var objectCount = countObjectProperties(objectOrArray[i]);

            if (isFixedQuestion) {
                objectCount -= 1;
            }

            count += objectCount;
        }
    }
    return count;
};

// Counts only
function countObjectProperties(object) {
    var count = 0;

    //For primitives
    if (!(typeof object === 'object') &&
        !(typeof object === 'array')) {
            return 1;
    }

    for (var i in object) {
        if (object.hasOwnProperty(i)
            && !!object[i]
            && (i != '$$hashKey')) {

            if (typeof object[i] === 'object') {
                var objectElementCount = countNonEmptyProperties(object[i]);
                count += objectElementCount;
            } else {
                count++;
            }
        }
    }
    return count;
};

// Clears object or array data. When object is array all other elements except
// first are deleted.
function clearObject(object, keepFirst) {
    if (!(object instanceof Array)) {

        var indexCounter = 0;
        for (var i in object) {
            if (object.hasOwnProperty(i)) {
                if (indexCounter == 0 && keepFirst) {
                } else {
                    object[i] = null;
                }
            }
            indexCounter++;
        }
    } else {
        clearArray(object, keepFirst);
    }

}

// Deletes all other array elements expect first one and
// clears all data from first element.
function clearArray(array, keepRow) {
    for (var i = array.length; i > 0; i--) {
        if (keepRow) {
            clearObject(array[i], keepRow);
        } else {
            array.splice(i, 1);
        }
    }
    clearObject(array[0], keepRow);

    // For arrays that contain primitives. Last element must be
    // left but has to be empty so element is still present after
    // conversion to xml.
    if (!(array[0] instanceof Object)) {
        array[0] = "";
        return;
    }
}

//Clone object.
function clone(obj) {
    // Handle the 3 simple types, and null or undefined
    if (null == obj || "object" != typeof obj) return obj;

    // Handle Date
    if (obj instanceof Date) {
        var copy = new Date();
        copy.setTime(obj.getTime());
        return copy;
    }

    // Handle Array
    if (obj instanceof Array) {
        var copy = [];
        for (var i = 0, len = obj.length; i < len; i++) {
            copy[i] = clone(obj[i]);
        }
        return copy;
    }

    // Handle Object
    if (obj instanceof Object) {
        var copy = {};
        for (var attr in obj) {
            if (obj.hasOwnProperty(attr)) copy[attr] = clone(obj[attr]);
        }
        return copy;
    }

    throw new Error("Unable to copy obj! Its type isn't supported.");
}

// Function is used before saving JSON object back to XML file. When deleting field on the form
// angular sets it to undefined which breaks the order of elements if converted to XML.
function fixUndefined(obj) {
    var isArray = obj instanceof Array;
    for (var j in obj) {
        if (obj.hasOwnProperty(j)) {
            if (typeof(obj[j]) == "object") {
                fixUndefined(obj[j]);
            } else if(!isArray && j != '$$hashkey') {
                if (typeof obj[j] == 'undefined') {
                    obj[j] = null;
                }
            }
        }
    }
}

// helper function for getting query string parameter values. AngularJS solution $location.search() doesn't work in IE8.
function getParameterByName(name) {
    // FIXME - WebQ instance param is not escaped
    var searchArr = window.location.search.split('?');
    var search = '?' + searchArr[searchArr.length - 1];
    var match = new RegExp('[?&]' + name + '=([^&]*)').exec(search);
    return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
};
