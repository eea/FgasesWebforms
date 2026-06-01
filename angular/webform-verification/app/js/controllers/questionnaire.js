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
                    $scope.emptyInstance = instance;
                    $scope.loadInstance();
                });
            };
          
            $scope.loadInstance = function() {
                dataRepository.getInstance().error(function() {
                    $notification.error("", "Failed to load reporting data. Please close the form and try to report again later.");
                }).success(function(instance) {
                    
                     reportStructureNormalizer.normalize(instance); 
                    var is_previous_report = dataPrefill.isPreviousReport(instance);
                    if (is_previous_report) {
                        dataRepository.getEmptyInstance().error(function() {
                            $notification.error("", "Failed to read empty instance XML file.");
                        }).success(function(emptyInstance) {
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
                        
                        auditor.Company.CompanyName = auditorIns.company.company_name;
                        auditor.Phone = auditorIns.auditor.phone;
                        auditor.Website = auditorIns.auditor.website;
                        auditor.Adress.Street = auditorIns.auditor.address.street;
                        auditor.Adress.Number = auditorIns.auditor.address.number;
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