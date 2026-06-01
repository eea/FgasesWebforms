xquery version "1.0" encoding "UTF-8";



declare namespace xmlconv="http://converters.eionet.europa.eu/fgases";
(: namespace for BDR localisations :)
declare namespace i18n = "http://namespaces.zope.org/i18n";
(: Common utility methods :)

import module namespace cutil = "http://converters.eionet.europa.eu/fgases/cutil" at "fgases-common-util-2024-verification.xquery";
(: UI utility methods for build HTML formatted QA result:)
import module namespace uiutil = "http://converters.eionet.europa.eu/fgases/ui" at "fgases-ui-util-2024-verification.xquery";

declare variable $xmlconv:BLOCKER as xs:string := "BLOCKER";
declare variable $xmlconv:WARNING as xs:string := "WARNING";
declare variable $xmlconv:COMPLIANCE as xs:string := "COMPLIANCE";
declare variable $xmlconv:INFO as xs:string := "INFO";

declare variable $xmlconv:cssStyle as element(style) :=

    <style type="text/css">
        <![CDATA[

.red {
  color:red;
}

.red-bold {
  color:red;
  font-weight:bold;
}

.orange {
  color:orange;
}

.blue {
  color:blue;
  font-size:0.8em;
}

.block {
    display:block;
}

ul.items-list li {
  list-style-type:none;
}

ul.errors-list li span.error-red,
ul.errors-list li span.error-orange {
  font-size: 0.8em;
  color: white;
  padding-left:12px;
  padding-right:12px;
  text-align:center;
}

ul.errors-list li span.error-red {
  background-color: red;
}

ul.errors-list li span.error-orange {
  background-color: orange;
}

ul.errors-list li span.error-name {
  font-weight:bold;
}

.datatable {
  width:100%;
  text-align:left;
}

.datatable tr th {
  width:250px;
  font-weight:normal;
  text-align:left;
}

.datatable tr td sup {
  font-size:0.7em;
  color:blue;
}
.error-details {
    margin-left: 37px;
    padding-top: 5px;
}
.error-details ul {
    margin-top: 5px;
    padding-top: 0px;
}
.errors {
    width:100%;
    margin-top: 10px;
}
.errors h4 {
    font-weight: bold;
    padding: 0.2em 0.4em;
    background-color: rgb(240, 244, 245);
    color: #000000;
    border-top: 1px solid rgb(224, 231, 215);
}
      ]]>
    </style>

;

declare variable $source_url as xs:string external;

(:
  Change it for testing locally:
declare variable $source_url as xs:string external;
declare variable $source_url as xs:string external;
declare variable $source_url := "http://cdrtest.eionet.europa.eu/de/colt_cs2a/colt_ctda/envt_cyoq/questionnaire_fgases.xml";
:)
(:
 : ======================================================================
 :     QA rules
 : ======================================================================
 :)


declare function xmlconv:is-NIL-Report($report as element())
as xs:boolean
{
    $report/NILReport = 'true'
};


(:declare function xmlconv:rule_ReportStatus($doc as element())
as element(div)? {

 check webform status, it has to be completed - click "Close report" button on Finish tab 

    let $err_text := "For a successful submission, the result of automatic validation of consistency must be acknowledged in the Finish tab of the reporting form by clicking the ‘Close web form and proceed to BDR’ button which is green if your reporting has passed the automatic validation.
    If any blocking errors are displayed on that page, they must be corrected first before the report can be successfully submitted."

    let $err_flag := lower-case(data($doc/GeneralReportData/@status)) != "completed"

    return
        if ($err_flag) then
            uiutil:buildRuleResult("status", "", $err_text, $xmlconv:BLOCKER, $err_flag, (), "")
        else
            let $transactionYear := string(data($doc/GeneralReportData/TransactionYear))
            let $actualTransactionYears :=
               (: for $actualYear in (2023 to fn:year-from-date(fn:current-date()) - 1)(:fn:year-from-date(fn:current-date()) - 1:)
                return string($actualYear):)
            if ((fn:number($transactionYear)=fn:year-from-date(fn:current-date())) or  (fn:number($transactionYear)=fn:year-from-date(fn:current-date())-1))then
                 string($transactionYear)
                 else 
                 ()
            let $year_err_flag := not($transactionYear = $actualTransactionYears)
            let $year_err_msg_template := "The data in the submitted envelope refers to a year for which reporting is no longer possible ([year]). If you loaded your previous year's report in order to use it this year, please open the form in order to adjust the year and revise the values, even if your numbers may be identical to last year."
            let $year_err_msg := replace($year_err_msg_template, "\[year\]", $transactionYear)
            return uiutil:buildRuleResult("2900", "", $year_err_msg, $xmlconv:BLOCKER, $year_err_flag, (), "")
};:)


declare function xmlconv:qc3006($report as element())
as element(div)*
{
   
    let $pathI1 := ($report/BulkHFCs/section_I_1)
    let $errorTextI1 := 'Please select one of the boxes a), b) or c) in Table 1 in Section I.'

    let $pathI2 := ($report/BulkHFCs/section_I_2/tr_01A, $report/BulkHFCs/section_I_2/tr_01A_a_own, $report/BulkHFCs/section_I_2/tr_01A_a_other, $report/BulkHFCs/section_I_2/tr_01B, $report/BulkHFCs/section_I_2/tr_01C, $report/BulkHFCs/section_I_2/tr_02A, $report/BulkHFCs/section_I_2/tr_02B, $report/BulkHFCs/section_I_2/tr_02G, $report/BulkHFCs/section_I_2/tr_02H, $report/BulkHFCs/section_I_2/tr_02I,$report/BulkHFCs/section_I_2/tr_03B, $report/BulkHFCs/section_I_2/tr_04C, $report/BulkHFCs/section_I_2/tr_04H, $report/BulkHFCs/section_I_2/tr_05A, $report/BulkHFCs/section_I_2/tr_05B, $report/BulkHFCs/section_I_2/tr_05C_exempted, $report/BulkHFCs/section_I_2/tr_05D, $report/BulkHFCs/section_I_2/tr_05E, $report/BulkHFCs/section_I_2/tr_05F, $report/BulkHFCs/section_I_2/tr_09A, $report/BulkHFCs/section_I_2/tr_09C, $report/BulkHFCs/section_I_2/tr_09F)
    let $errorTextI2 := 'Please select one of the boxes a), b) or c) in Table 2 in Section I.'
    
    let $pathII1 := ($report/EquipmentHFCs/section_II_1)
    let $errorTextII1 := 'Please select one of the boxes a), b) or c) in Table 1 in Section II.'

    let $pathII2 := 
    if (exists($report/Transactions[id="tr_11P"])) then
        for $name in ("tr_11G", "tr_12A", "tr_12aA", "tr_13D","tr_11P")
             return $report/EquipmentHFCs/section_II_2/*[name() = $name]            
    else for $name in ("tr_11G", "tr_12A", "tr_12aA", "tr_13D")       
            return $report/EquipmentHFCs/section_II_2/*[name() = $name]  
    let $errorTextII2 := 'Please select one of the boxes a), b) or c) in Table 2 in Section II.'

   
        let $errorsI1 := for $path in $pathI1 
        return if (($path/confirmation_a/checked = "true" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "false") or 
            ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "true" and $path/confirmation_c/checked = "false") or 
            ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "true")) 
            then
                ()
            else if ($report/VerificationScope/Bulk="true") then
                uiutil:buildRuleResult("3006", "", $errorTextI1, $xmlconv:BLOCKER, true(), (), "")
                else ()

    
    let $errorsI2 := for $path in $pathI2 
    return if (($path/confirmation_a/checked = "true" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "false") or 
        ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "true" and $path/confirmation_c/checked = "false") or 
        ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "true")) 
        then
            ()
        else if ($report/VerificationScope/Bulk="true") then
            uiutil:buildRuleResult("3006", name($path), $errorTextI2, $xmlconv:BLOCKER, true(), (), "")
            else ()
    

    let $errorsII1 := for $path in $pathII1 
    return if (($path/confirmation_a/checked = "true" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "false") or 
        ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "true" and $path/confirmation_c/checked = "false") or 
        ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "true")) 
        then
            ()
        else if ($report/VerificationScope/Equipment="true") then        
            uiutil:buildRuleResult("3006", "", $errorTextII1, $xmlconv:BLOCKER, true(), (), "")        
            else ()

    let $errorsII2 := for $path in $pathII2 
    return if (($path/confirmation_a/checked = "true" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "false") or 
        ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "true" and $path/confirmation_c/checked = "false") or 
        ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "true")) 
        then
            ()
        else if ($report/VerificationScope/Equipment="true") then
            uiutil:buildRuleResult("3006", name($path), $errorTextII2, $xmlconv:BLOCKER, true(), (), "")
            else()

    return
        ($errorsI1, $errorsI2, $errorsII1, $errorsII2)

};


declare function xmlconv:qc3007($report as element())
as element(div)*
{

    let $pathI1 := ($report/BulkHFCs/section_I_1)
    let $errorTextI1 := 'Please select at least one of the tickboxes under b) in Table 1 in Section I'

    let $pathI2 := ($report/BulkHFCs/section_I_2/tr_01A, $report/BulkHFCs/section_I_2/tr_01A_a_own, $report/BulkHFCs/section_I_2/tr_01A_a_other, $report/BulkHFCs/section_I_2/tr_01B, $report/BulkHFCs/section_I_2/tr_01C, $report/BulkHFCs/section_I_2/tr_02A, $report/BulkHFCs/section_I_2/tr_02B, $report/BulkHFCs/section_I_2/tr_02G, $report/BulkHFCs/section_I_2/tr_02H, $report/BulkHFCs/section_I_2/tr_02I,$report/BulkHFCs/section_I_2/tr_03B, $report/BulkHFCs/section_I_2/tr_04C, $report/BulkHFCs/section_I_2/tr_04H, $report/BulkHFCs/section_I_2/tr_05A, $report/BulkHFCs/section_I_2/tr_05B, $report/BulkHFCs/section_I_2/tr_05C_exempted, $report/BulkHFCs/section_I_2/tr_05D, $report/BulkHFCs/section_I_2/tr_05E, $report/BulkHFCs/section_I_2/tr_05F, $report/BulkHFCs/section_I_2/tr_09A, $report/BulkHFCs/section_I_2/tr_09C, $report/BulkHFCs/section_I_2/tr_09F)
    let $errorTextI2 := 'Please select at least one of the tickboxes under b) in Table 1 in Section II'

    let $pathII1 := ($report/EquipmentHFCs/section_II_1)
    let $errorTextII1 := 'Please select at least one of the tickboxes under b) in Table 2 in Section I'

    let $pathII2 := ($report/EquipmentHFCs/section_II_2/tr_11G, $report/EquipmentHFCs/section_II_2/tr_12A, $report/EquipmentHFCs/section_II_2/tr_12aA, $report/EquipmentHFCs/section_II_2/tr_13D, $report/EquipmentHFCs/section_II_2/tr_11P )
    let $errorTextII2 := 'Please select at least one of the tickboxes under b) in Table 2 in Section II'


    let $errorsI1 := for $path in $pathI1 
    return if ($path/confirmation_b/checked = "true" and $path/confirmation_b/option_1 = "false" and $path/confirmation_b/option_2 = "false" and $path/confirmation_b/option_3 = "false" and $path/confirmation_b/option_4 = "false")
        then
            uiutil:buildRuleResult("3007", "", $errorTextI1, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

    let $errorsI2 := for $path in $pathI2 
    return if ($path/confirmation_b/checked = "true" and $path/confirmation_b/option_1 = "false" and $path/confirmation_b/option_2 = "false" and $path/confirmation_b/option_3 = "false" and $path/confirmation_b/option_4 = "false")
        then
            uiutil:buildRuleResult("3007", name($path), $errorTextI2, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

    let $errorsII1 := for $path in $pathII1 
    return if ($path/confirmation_b/checked = "true" and $path/confirmation_b/option_1 = "false" and $path/confirmation_b/option_2 = "false" and $path/confirmation_b/option_3 = "false" and $path/confirmation_b/option_4 = "false")
        then
            uiutil:buildRuleResult("3007", "", $errorTextII1, $xmlconv:BLOCKER, true(), (), "")
        else
            ()     

    let $errorsII2 := for $path in $pathII2 
    return if ($path/confirmation_b/checked = "true" and $path/confirmation_b/option_1 = "false" and $path/confirmation_b/option_2 = "false" and $path/confirmation_b/option_3 = "false" and $path/confirmation_b/option_4 = "false")
        then
            uiutil:buildRuleResult("3007", name($path), $errorTextII2, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

    return
        ($errorsI1, $errorsI2, $errorsII1, $errorsII2)

};


declare function xmlconv:qc3008($report as element())
as element(div)*
{

    let $pathI1 := ($report/BulkHFCs/section_I_1)
    let $errorTextI1 := 'Please enter a comment into the textbox b4 in Table 1 in Section I'

    let $pathI2 := ($report/BulkHFCs/section_I_2/tr_01A, $report/BulkHFCs/section_I_2/tr_01A_a_own, $report/BulkHFCs/section_I_2/tr_01A_a_other, $report/BulkHFCs/section_I_2/tr_01B, $report/BulkHFCs/section_I_2/tr_01C, $report/BulkHFCs/section_I_2/tr_02A, $report/BulkHFCs/section_I_2/tr_02B, $report/BulkHFCs/section_I_2/tr_02G, $report/BulkHFCs/section_I_2/tr_02H, $report/BulkHFCs/section_I_2/tr_02I,$report/BulkHFCs/section_I_2/tr_03B, $report/BulkHFCs/section_I_2/tr_04C, $report/BulkHFCs/section_I_2/tr_04H, $report/BulkHFCs/section_I_2/tr_05A, $report/BulkHFCs/section_I_2/tr_05B, $report/BulkHFCs/section_I_2/tr_05C_exempted, $report/BulkHFCs/section_I_2/tr_05D, $report/BulkHFCs/section_I_2/tr_05E, $report/BulkHFCs/section_I_2/tr_05F, $report/BulkHFCs/section_I_2/tr_09A, $report/BulkHFCs/section_I_2/tr_09C, $report/BulkHFCs/section_I_2/tr_09F)
    let $errorTextI2 := 'Please enter a comment into the textbox b4 in Table 1 in Section II'

    let $pathII1 := ($report/EquipmentHFCs/section_II_1)
    let $errorTextII1 := 'Please enter a comment into the textbox b4 in Table 2 in Section I'

    let $pathII2 := ($report/EquipmentHFCs/section_II_2/tr_11G, $report/EquipmentHFCs/section_II_2/tr_12A, $report/EquipmentHFCs/section_II_2/tr_12aA, $report/EquipmentHFCs/section_II_2/tr_13D, $report/EquipmentHFCs/section_II_2/tr_11P )
    let $errorTextII2 := 'Please enter a comment into the textbox b4 in Table 2 in Section II'


    let $errorsI1 := for $path in $pathI1 
    return if ($path/confirmation_b/checked = "true" and $path/confirmation_b/option_4 = "true" and string-length(data($path/confirmation_b/option_4_reason)) < 5)
        then
            uiutil:buildRuleResult("3008", "", $errorTextI1, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

    let $errorsI2 := for $path in $pathI2 
    return if ($path/confirmation_b/checked = "true" and $path/confirmation_b/option_4 = "true" and string-length(data($path/confirmation_b/option_4_reason)) < 5)
        then
            uiutil:buildRuleResult("3008", name($path), $errorTextI2, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

    let $errorsII1 := for $path in $pathII1 
    return if ($path/confirmation_b/checked = "true" and $path/confirmation_b/option_4 = "true" and string-length(data($path/confirmation_b/option_4_reason)) < 5)
        then
            uiutil:buildRuleResult("3008", "", $errorTextII1, $xmlconv:BLOCKER, true(), (), "")
        else
            ()     

    let $errorsII2 := for $path in $pathII2 
    return if ($path/confirmation_b/checked = "true" and $path/confirmation_b/option_4 = "true" and string-length(data($path/confirmation_b/option_4_reason)) < 5)
        then
            uiutil:buildRuleResult("3008", name($path), $errorTextII2, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

    return
        ($errorsI1, $errorsI2, $errorsII1, $errorsII2)

};


declare function xmlconv:qc3009($report as element())
as element(div)*
{

    let $pathI1 := ($report/BulkHFCs/section_I_1)
    let $errorTextI1 := 'Please select at least one of the tickboxes under c) in Table 1 in Section I'

    let $pathI2 := ($report/BulkHFCs/section_I_2/tr_01A, $report/BulkHFCs/section_I_2/tr_01A_a_own, $report/BulkHFCs/section_I_2/tr_01A_a_other, $report/BulkHFCs/section_I_2/tr_01B, $report/BulkHFCs/section_I_2/tr_01C, $report/BulkHFCs/section_I_2/tr_02A, $report/BulkHFCs/section_I_2/tr_02B, $report/BulkHFCs/section_I_2/tr_02G, $report/BulkHFCs/section_I_2/tr_02H, $report/BulkHFCs/section_I_2/tr_02I,$report/BulkHFCs/section_I_2/tr_03B, $report/BulkHFCs/section_I_2/tr_04C, $report/BulkHFCs/section_I_2/tr_04H, $report/BulkHFCs/section_I_2/tr_05A, $report/BulkHFCs/section_I_2/tr_05B, $report/BulkHFCs/section_I_2/tr_05C_exempted, $report/BulkHFCs/section_I_2/tr_05D, $report/BulkHFCs/section_I_2/tr_05E, $report/BulkHFCs/section_I_2/tr_05F, $report/BulkHFCs/section_I_2/tr_09A, $report/BulkHFCs/section_I_2/tr_09C, $report/BulkHFCs/section_I_2/tr_09F)
    let $errorTextI2 := 'Please select at least one of the tickboxes under c) in Table 1 in Section II'

    let $pathII1 := ($report/EquipmentHFCs/section_II_1)
    let $errorTextII1 := 'Please select at least one of the tickboxes under c) in Table 2 in Section I'

    let $pathII2 := ($report/EquipmentHFCs/section_II_2/tr_11G, $report/EquipmentHFCs/section_II_2/tr_12A, $report/EquipmentHFCs/section_II_2/tr_12aA, $report/EquipmentHFCs/section_II_2/tr_13D, $report/EquipmentHFCs/section_II_2/tr_11P )
    let $errorTextII2 := 'Please select at least one of the tickboxes under c) in Table 2 in Section II'


    let $errorsI1 := for $path in $pathI1 
    return if (($path/confirmation_c/checked = "true" and $path/confirmation_c/option_1 = "false" and $path/confirmation_c/option_2 = "false" and $path/confirmation_c/option_3 = "false" and $path/confirmation_c/option_4 = "false")or($path/confirmation_c/checked = "true" and $path/confirmation_c/option_1 = "" and $path/confirmation_c/option_2 = "" and $path/confirmation_c/option_3 = "" and $path/confirmation_c/option_4 = ""))
        then
            uiutil:buildRuleResult("3009", "", $errorTextI1, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

    let $errorsI2 := for $path in $pathI2 
    return if (($path/confirmation_c/checked = "true" and $path/confirmation_c/option_1 = "false" and $path/confirmation_c/option_2 = "false" and $path/confirmation_c/option_3 = "false" and $path/confirmation_c/option_4 = "false")or($path/confirmation_c/checked = "true" and $path/confirmation_c/option_1 = "" and $path/confirmation_c/option_2 = "" and $path/confirmation_c/option_3 = "" and $path/confirmation_c/option_4 = ""))
        then
            uiutil:buildRuleResult("3009", name($path), $errorTextI2, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

    let $errorsII1 := for $path in $pathII1 
    return if (($path/confirmation_c/checked = "true" and $path/confirmation_c/option_1 = "false" and $path/confirmation_c/option_2 = "false" and $path/confirmation_c/option_3 = "false" and $path/confirmation_c/option_4 = "false")or($path/confirmation_c/checked = "true" and $path/confirmation_c/option_1 = "" and $path/confirmation_c/option_2 = "" and $path/confirmation_c/option_3 = "" and $path/confirmation_c/option_4 = ""))
        then
            uiutil:buildRuleResult("3009", "", $errorTextII1, $xmlconv:BLOCKER, true(), (), "")
        else
            ()     

    let $errorsII2 := for $path in $pathII2 
    return if (($path/confirmation_c/checked = "true" and $path/confirmation_c/option_1 = "false" and $path/confirmation_c/option_2 = "false" and $path/confirmation_c/option_3 = "false" and $path/confirmation_c/option_4 = "false")or($path/confirmation_c/checked = "true" and $path/confirmation_c/option_1 = "" and $path/confirmation_c/option_2 = "" and $path/confirmation_c/option_3 = "" and $path/confirmation_c/option_4 = ""))
        then
            uiutil:buildRuleResult("3009", name($path), $errorTextII2, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

    return
        ($errorsI1, $errorsI2, $errorsII1, $errorsII2)

};


declare function xmlconv:qc3010($report as element())
as element(div)*
{

    let $pathI1 := ($report/BulkHFCs/section_I_1)
    let $errorTextI1 := 'Please enter a comment into the textbox c4 in Table 1 in Section I'

    let $pathI2 := ($report/BulkHFCs/section_I_2/tr_01A, $report/BulkHFCs/section_I_2/tr_01A_a_own, $report/BulkHFCs/section_I_2/tr_01A_a_other, $report/BulkHFCs/section_I_2/tr_01B, $report/BulkHFCs/section_I_2/tr_01C, $report/BulkHFCs/section_I_2/tr_02A, $report/BulkHFCs/section_I_2/tr_02B, $report/BulkHFCs/section_I_2/tr_02G, $report/BulkHFCs/section_I_2/tr_02H, $report/BulkHFCs/section_I_2/tr_02I,$report/BulkHFCs/section_I_2/tr_03B, $report/BulkHFCs/section_I_2/tr_04C, $report/BulkHFCs/section_I_2/tr_04H, $report/BulkHFCs/section_I_2/tr_05A, $report/BulkHFCs/section_I_2/tr_05B, $report/BulkHFCs/section_I_2/tr_05C_exempted, $report/BulkHFCs/section_I_2/tr_05D, $report/BulkHFCs/section_I_2/tr_05E, $report/BulkHFCs/section_I_2/tr_05F, $report/BulkHFCs/section_I_2/tr_09A, $report/BulkHFCs/section_I_2/tr_09C, $report/BulkHFCs/section_I_2/tr_09F)
    let $errorTextI2 := 'Please enter a comment into the textbox c4 in Table 1 in Section II'

    let $pathII1 := ($report/EquipmentHFCs/section_II_1)
    let $errorTextII1 := 'Please enter a comment into the textbox c4 in Table 2 in Section I'

    let $pathII2 := ($report/EquipmentHFCs/section_II_2/tr_11G, $report/EquipmentHFCs/section_II_2/tr_12A, $report/EquipmentHFCs/section_II_2/tr_12aA, $report/EquipmentHFCs/section_II_2/tr_13D, $report/EquipmentHFCs/section_II_2/tr_11P )
    let $errorTextII2 := 'Please enter a comment into the textbox c4 in Table 2 in Section II'


    let $errorsI1 := for $path in $pathI1 
    return if ($path/confirmation_c/checked = "true" and $path/confirmation_c/option_4 = "true" and string-length(data($path/confirmation_c/option_4_reason)) < 5)
        then
            uiutil:buildRuleResult("3010", "", $errorTextI1, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

    let $errorsI2 := for $path in $pathI2 
    return if ($path/confirmation_c/checked = "true" and $path/confirmation_c/option_4 = "true" and string-length(data($path/confirmation_c/option_4_reason)) < 5)
        then
            uiutil:buildRuleResult("3010", name($path), $errorTextI2, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

    let $errorsII1 := for $path in $pathII1 
    return if ($path/confirmation_c/checked = "true" and $path/confirmation_c/option_4 = "true" and string-length(data($path/confirmation_c/option_4_reason)) < 5)
        then
            uiutil:buildRuleResult("3010", "", $errorTextII1, $xmlconv:BLOCKER, true(), (), "")
        else
            ()     

    let $errorsII2 := for $path in $pathII2 
    return if ($path/confirmation_c/checked = "true" and $path/confirmation_c/option_4 = "true" and string-length(data($path/confirmation_c/option_4_reason)) < 5)
        then
            uiutil:buildRuleResult("3010", name($path), $errorTextII2, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

    return
        ($errorsI1, $errorsI2, $errorsII1, $errorsII2)

};


declare function xmlconv:qc3011($report as element())
as element(div)*
{

    let $checkpath := $report/BulkHFCs/section_I_2/tr_09F

    let $pathI1 := ($report/BulkHFCs/section_I_1)
    let $pathI2 := ($report/BulkHFCs/section_I_2/tr_01A, $report/BulkHFCs/section_I_2/tr_01A_a_own, $report/BulkHFCs/section_I_2/tr_01A_a_other, $report/BulkHFCs/section_I_2/tr_01B, $report/BulkHFCs/section_I_2/tr_01C, $report/BulkHFCs/section_I_2/tr_02A, $report/BulkHFCs/section_I_2/tr_02B, $report/BulkHFCs/section_I_2/tr_02G, $report/BulkHFCs/section_I_2/tr_02H, $report/BulkHFCs/section_I_2/tr_02I,$report/BulkHFCs/section_I_2/tr_03B, $report/BulkHFCs/section_I_2/tr_04C, $report/BulkHFCs/section_I_2/tr_04H, $report/BulkHFCs/section_I_2/tr_05A, $report/BulkHFCs/section_I_2/tr_05B, $report/BulkHFCs/section_I_2/tr_05C_exempted, $report/BulkHFCs/section_I_2/tr_05D, $report/BulkHFCs/section_I_2/tr_05E, $report/BulkHFCs/section_I_2/tr_05F, $report/BulkHFCs/section_I_2/tr_09A, $report/BulkHFCs/section_I_2/tr_09C )
    let $paths := ($pathI1, $pathI2)

    let $errors := for $path in $paths
         return  if (($path/confirmation_b/checked = "true") or ($path/confirmation_c/checked = "true")) then
                    name($path)
                else()
    let $errorText := 'Option a) can only be chosen for 9F if option a) was chosen for all other transactions impacting 9F. Please revise.'

    return if (($checkpath/confirmation_a/checked = "true") and count($errors) > 0) then
        uiutil:buildRuleResult("3011", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3012($report as element())
as element(div)*
{

    let $checkpath := $report/BulkHFCs/section_I_2/tr_09F

    let $pathI1 := ($report/BulkHFCs/section_I_1)
    let $pathI2 := ($report/BulkHFCs/section_I_2/tr_01A, $report/BulkHFCs/section_I_2/tr_01A_a_own, $report/BulkHFCs/section_I_2/tr_01A_a_other, $report/BulkHFCs/section_I_2/tr_01B, $report/BulkHFCs/section_I_2/tr_01C, $report/BulkHFCs/section_I_2/tr_02A, $report/BulkHFCs/section_I_2/tr_02B, $report/BulkHFCs/section_I_2/tr_02G, $report/BulkHFCs/section_I_2/tr_02H, $report/BulkHFCs/section_I_2/tr_02I,$report/BulkHFCs/section_I_2/tr_03B, $report/BulkHFCs/section_I_2/tr_04C, $report/BulkHFCs/section_I_2/tr_04H, $report/BulkHFCs/section_I_2/tr_05A, $report/BulkHFCs/section_I_2/tr_05B, $report/BulkHFCs/section_I_2/tr_05C_exempted, $report/BulkHFCs/section_I_2/tr_05D, $report/BulkHFCs/section_I_2/tr_05E, $report/BulkHFCs/section_I_2/tr_05F, $report/BulkHFCs/section_I_2/tr_09A, $report/BulkHFCs/section_I_2/tr_09C )
    let $paths := ($pathI1, $pathI2)

    let $errors := for $path in $paths
         return  if ($path/confirmation_c/checked = "true") then
                    name($path)
                else()
    let $errorText := 'Option b) can not be chosen for 9F if reasonable assurance was denied for the HFC selection or any other transaction impacting 9F results. Please revise.'

    return if (($checkpath/confirmation_b/checked = "true") and count($errors) > 0) then
        uiutil:buildRuleResult("3012", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3000($report as element())
as element(div)*
{

    let $pathI3 := ($report/BulkHFCs/section_I_3)
    let $errorTextI3 := 'Please select one of the boxes a), b) or c) in Section I-3'

    let $pathII3 := ($report/EquipmentHFCs/section_II_3)
    let $errorTextII3 := 'Please select one of the boxes a), b) or c) in Section II-3'



    let $errorsI3 := for $path in $pathI3 
    return if (($path/confirmation_a/checked = "true" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "false") or 
        ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "true" and $path/confirmation_c/checked = "false") or 
        ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "true")) 
        then
            ()
        else if ($report/VerificationScope/Bulk="true") then
            uiutil:buildRuleResult("3000", "", $errorTextI3, $xmlconv:BLOCKER, true(), (), "")
        else ()

    let $errorsII3 := for $path in $pathII3 
    return if (($path/confirmation_a/checked = "true" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "false") or 
        ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "true" and $path/confirmation_c/checked = "false") or 
        ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "true")) 
        then
            ()
        else if ($report/VerificationScope/Equipment="true") then
            uiutil:buildRuleResult("3000", "", $errorTextII3, $xmlconv:BLOCKER, true(), (), "")   
        else ()     

    return
        ($errorsI3, $errorsII3)

};


declare function xmlconv:qc3001($report as element())
as element(div)*
{

    let $checkpath := $report/BulkHFCs/section_I_3

    let $pathI1 := ($report/BulkHFCs/section_I_1)
    let $pathI2 := ($report/BulkHFCs/section_I_2/tr_01A, $report/BulkHFCs/section_I_2/tr_01A_a_own, $report/BulkHFCs/section_I_2/tr_01A_a_other, $report/BulkHFCs/section_I_2/tr_01B, $report/BulkHFCs/section_I_2/tr_01C, $report/BulkHFCs/section_I_2/tr_02A, $report/BulkHFCs/section_I_2/tr_02B, $report/BulkHFCs/section_I_2/tr_02G, $report/BulkHFCs/section_I_2/tr_02H, $report/BulkHFCs/section_I_2/tr_02I,$report/BulkHFCs/section_I_2/tr_03B, $report/BulkHFCs/section_I_2/tr_04C, $report/BulkHFCs/section_I_2/tr_04H, $report/BulkHFCs/section_I_2/tr_05A, $report/BulkHFCs/section_I_2/tr_05B, $report/BulkHFCs/section_I_2/tr_05C_exempted, $report/BulkHFCs/section_I_2/tr_05D, $report/BulkHFCs/section_I_2/tr_05E, $report/BulkHFCs/section_I_2/tr_05F, $report/BulkHFCs/section_I_2/tr_09A, $report/BulkHFCs/section_I_2/tr_09C, $report/BulkHFCs/section_I_2/tr_09F )
    let $paths := ($pathI1, $pathI2)

    let $errors := for $path in $paths
         return  if (($path/confirmation_b/checked = "true") or ($path/confirmation_c/checked = "true")) then
                    name($path)
                else()
    let $errorText := 'Option a) can not be selected in case for any of the statements of Table 1 and 2 option a) was not selected. Please revise your selection in section I-3.'

    return if (($checkpath/confirmation_a/checked = "true") and count($errors) > 0) then
        uiutil:buildRuleResult("3001", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3002($report as element())
as element(div)*
{

    let $checkpath := $report/BulkHFCs/section_I_3

    let $pathI1 := ($report/BulkHFCs/section_I_1)
    let $pathI2 := ($report/BulkHFCs/section_I_2/tr_01A, $report/BulkHFCs/section_I_2/tr_01A_a_own, $report/BulkHFCs/section_I_2/tr_01A_a_other, $report/BulkHFCs/section_I_2/tr_01B, $report/BulkHFCs/section_I_2/tr_01C, $report/BulkHFCs/section_I_2/tr_02A, $report/BulkHFCs/section_I_2/tr_02B, $report/BulkHFCs/section_I_2/tr_02G, $report/BulkHFCs/section_I_2/tr_02H, $report/BulkHFCs/section_I_2/tr_02I,$report/BulkHFCs/section_I_2/tr_03B, $report/BulkHFCs/section_I_2/tr_04C, $report/BulkHFCs/section_I_2/tr_04H, $report/BulkHFCs/section_I_2/tr_05A, $report/BulkHFCs/section_I_2/tr_05B, $report/BulkHFCs/section_I_2/tr_05C_exempted, $report/BulkHFCs/section_I_2/tr_05D, $report/BulkHFCs/section_I_2/tr_05E, $report/BulkHFCs/section_I_2/tr_05F, $report/BulkHFCs/section_I_2/tr_09A, $report/BulkHFCs/section_I_2/tr_09C, $report/BulkHFCs/section_I_2/tr_09F )
    let $paths := ($pathI1, $pathI2)

    let $errors := for $path in $paths
         return  if ($path/confirmation_c/checked = "true") then
                    name($path)
                else()
    let $errorText := 'Option b) can not be selected in case for any of the statements of Table 1 and 2 option c) was selected. Please revise your selection in section I-3.'

    return if (($checkpath/confirmation_b/checked = "true") and count($errors) > 0) then
        uiutil:buildRuleResult("3002", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3003($report as element())
as element(div)*
{

    let $checkpath := $report/BulkHFCs/section_I_3

    let $pathI1 := ($report/BulkHFCs/section_I_1)
    let $pathI2 := ($report/BulkHFCs/section_I_2/tr_01A, $report/BulkHFCs/section_I_2/tr_01A_a_own, $report/BulkHFCs/section_I_2/tr_01A_a_other, $report/BulkHFCs/section_I_2/tr_01B, $report/BulkHFCs/section_I_2/tr_01C, $report/BulkHFCs/section_I_2/tr_02A, $report/BulkHFCs/section_I_2/tr_02B, $report/BulkHFCs/section_I_2/tr_02G, $report/BulkHFCs/section_I_2/tr_02H, $report/BulkHFCs/section_I_2/tr_02I,$report/BulkHFCs/section_I_2/tr_03B, $report/BulkHFCs/section_I_2/tr_04C, $report/BulkHFCs/section_I_2/tr_04H, $report/BulkHFCs/section_I_2/tr_05A, $report/BulkHFCs/section_I_2/tr_05B, $report/BulkHFCs/section_I_2/tr_05C_exempted, $report/BulkHFCs/section_I_2/tr_05D, $report/BulkHFCs/section_I_2/tr_05E, $report/BulkHFCs/section_I_2/tr_05F, $report/BulkHFCs/section_I_2/tr_09A, $report/BulkHFCs/section_I_2/tr_09C, $report/BulkHFCs/section_I_2/tr_09F )
    let $paths := ($pathI1, $pathI2)

    let $pathc := for $path in $paths
         return  if ($path/confirmation_c/checked = "true") then
                    name($path)
                else()
    let $errorText := 'Option c) can not be selected in case for none of the statements of Tables 1 and 2 option c) was selected. Please revise your selection in section I-3.'

    return if (($checkpath/confirmation_c/checked = "true") and count($pathc) = 0) then
        uiutil:buildRuleResult("3003", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3004($report as element())
as element(div)*
{

    let $pathI4 := ($report/BulkHFCs/section_I_4/VerificationReport/Url)
    let $pathII5 := ($report/EquipmentHFCs/section_II_5/VerificationReport/Url )
    let $paths := ($pathI4, $pathII5)
    let $errorText := 'Please note that you must not upload XML documents here. Please use a different format.'

    let $pathc := for $path in $paths
         return  if (substring($path, string-length($path) - 3, 4) = ".xml" ) then
                    $path
                else()


    return if (count($pathc) > 0) then
        uiutil:buildRuleResult("3004", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3005($report as element())
as element(div)*
{

    let $pathI4 := ($report/BulkHFCs/section_I_4/VerificationReport/Url)
    let $errorTextI4 := 'Please upload a verification report in section I-4. Please note that your report can not be accepted if no document has been uploaded.'

    let $errorsI4 := for $path in $pathI4 
    return if (($path = '') and ($report/VerificationScope/Bulk="true"))
        then 
            uiutil:buildRuleResult("3005", "", $errorTextI4, $xmlconv:BLOCKER, true(), (), "")
        else
            () 

    let $pathII5 := ($report/EquipmentHFCs/section_II_5/VerificationReport/Url )
    let $errorTextII5 := 'Please upload a verification report in section II-5. Please note that your report can not be accepted if no document has been uploaded.'

    let $errorsII5 := for $path in $pathII5 
    return if (($path = '') and ($report/VerificationScope/Equipment="true"))
        then
            uiutil:buildRuleResult("3005", "", $errorTextII5, $xmlconv:BLOCKER, true(), (), "")
        else
            () 

    return ($errorsI4, $errorsII5)
};


declare function xmlconv:qc3026($report as element())
as element(div)*
{

    let $checkpath := $report/EquipmentHFCs/section_II_2/tr_13D

    let $pathII1 := ($report/EquipmentHFCs/section_II_1)

    let $pathII2 := ($report/EquipmentHFCs/section_II_2/tr_11G, $report/EquipmentHFCs/section_II_2/tr_12A, $report/EquipmentHFCs/section_II_2/tr_12aA, $report/EquipmentHFCs/section_II_2/tr_11P )
    let $errorText := 'Option a) can not be selected in case for any of the statements of Table 1 and 2 option a) was not selected. Please revise your selection on 13D summary statement.'
    let $paths := ($pathII1, $pathII2)

    let $errors := for $path in $paths
         return  if (($path/confirmation_b/checked = "true") or ($path/confirmation_c/checked = "true")) then
                    name($path)
                else()

    return if (($checkpath/confirmation_a/checked = "true") and count($errors) > 0) then
        uiutil:buildRuleResult("3026", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3027($report as element())
as element(div)*
{

    let $checkpath := $report/EquipmentHFCs/section_II_2/tr_13D

    let $pathII1 := ($report/EquipmentHFCs/section_II_1)

    let $pathII2 := ($report/EquipmentHFCs/section_II_2/tr_11G, $report/EquipmentHFCs/section_II_2/tr_12A, $report/EquipmentHFCs/section_II_2/tr_12aA, $report/EquipmentHFCs/section_II_2/tr_11P )
    let $errorText := 'Option b) can not be selected in case for any of the statements of Table 1 and 2 option c) was selected. Please revise your selection on 13D summary statement.'
    let $paths := ($pathII1, $pathII2)

    let $errors := for $path in $paths
         return  if (($path/confirmation_c/checked = "true")) then
                    name($path)
                else()

    return if (($checkpath/confirmation_b/checked = "true") and count($errors) > 0) then
        uiutil:buildRuleResult("3027", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3028($report as element())
as element(div)*
{
    let $checkpath := $report/ReportedEquipment/Transactions[id = 'tr_11P']
    let $path := $report/EquipmentHFCs/section_II_2/tr_11P
    let $errorText := 'You must select a statement for 11_P.'

    return if ((xmlconv:getDouble($checkpath/tco2e) > 0) and (($path/confirmation_a/checked = "false" or $path/confirmation_a/checked = "" ) and ($path/confirmation_b/checked = "false" or $path/confirmation_b/checked = "") and ($path/confirmation_c/checked = "false" or  $path/confirmation_c/checked = "" ))) then
        uiutil:buildRuleResult("3028", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3029($report as element())
as element(div)*
{
    
    let $path := $report/EquipmentHFCs/section_II_2/tr_11P
    let $errorText := 'Please enter a statement explaining your verdict on 11_P.'

    return if (($path/confirmation_b/checked = "true" and $path/confirmation_b/option_4 = "true" and string-length(data($path/confirmation_b/option_4_reason)) < 5) or ($path/confirmation_c/checked = "true" and $path/confirmation_c/option_4 = "true" and string-length(data($path/confirmation_c/option_4_reason)) < 5)) then
        uiutil:buildRuleResult("3029", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3013($report as element())
as element(div)*
{
    
    let $path := $report/EquipmentHFCs/section_II_2/tr_13D
    let $checkpath := $report/EquipmentHFCs/section_II_3
    let $errorText := 'Option a) can not be selected in Section II-3 if the veracity of 13D HFC data reported for products/equipment transactions was not fully confirmed for 13D in Table 2 in section II-2. Please revise.'

    return if ( $path/confirmation_a/checked = "false" and $checkpath/confirmation_a/checked = "true" ) then
        uiutil:buildRuleResult("3013", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3014($report as element())
as element(div)*
{
    
    let $path := $report/EquipmentHFCs/section_II_2/tr_13D
    let $checkpath := $report/EquipmentHFCs/section_II_3
    let $errorText := 'Option b) can not be selected in Section II-3 if reasonable assurance was denied for the veracity of 13D HFC data reported for products/equipment transactions in Table 2 in section II-2. Please revise.'

    return if ( $path/confirmation_c/checked = "true" and $checkpath/confirmation_b/checked = "true" ) then
        uiutil:buildRuleResult("3014", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3015($report as element())
as element(div)*
{
    
    let $path := $report/EquipmentHFCs/section_II_3
    let $errorText := 'Please enter a comment in section II-3.'

    return if (($path/confirmation_b/checked = "true" and $path/confirmation_b/option_4 = "true" and string-length(data($path/confirmation_b/option_4_reason)) < 5) or ($path/confirmation_c/checked = "true" and $path/confirmation_c/option_4 = "true" and string-length(data($path/confirmation_c/option_4_reason)) < 5)) then
        uiutil:buildRuleResult("3015", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3016($report as element())
as element(div)*
{
    if ($report/VerificationScope/Equipment="true") then
        let $path := $report/EquipmentHFCs/section_II_3
        let $errorText := 'You must select one of the boxes in section II-3.'

        return if (($path/confirmation_a/checked = "true" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "false") or 
            ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "true" and $path/confirmation_c/checked = "false") or 
            ($path/confirmation_a/checked = "false" and $path/confirmation_b/checked = "false" and $path/confirmation_c/checked = "true")) 
            then
                ()
            else
                uiutil:buildRuleResult("3016", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else ()
};


declare function xmlconv:qc3018($report as element())
as element(div)*
{
    let $checkpath := $report/ReportedEquipment/Transactions[id = 'tr_13D']
    let $pathII2 := $report/EquipmentHFCs/section_II_2/tr_13D
    let $pathII4 := $report/EquipmentHFCs/section_II_4
    let $errorText := 'Please enter a comment for Option 1 in Part 1 in Section II-4.'

    return if ((xmlconv:getDouble($checkpath/tco2e) = 0 or ($pathII2/confirmation_c/checked = "true")) and $pathII4/option_a/option = "1" and string-length($pathII4/option_a/reason_1) = 0) then
        uiutil:buildRuleResult("3018", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3019($report as element())
as element(div)*
{
    let $checkpath := $report/ReportedEquipment/Transactions[id = 'tr_13D']
    let $pathII4 := $report/EquipmentHFCs/section_II_4
    let $errorText := 'Please enter a comment for Option 2 in Part 1 in Section II-4.'

    return if (xmlconv:getDouble($checkpath/tco2e) = 0 and $pathII4/option_a/option = "2" and string-length($pathII4/option_a/reason_2) = 0) then
        uiutil:buildRuleResult("3019", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3020($report as element())
as element(div)*
{
    let $checkpath := $report/ReportedEquipment/Transactions[id = 'tr_13D']
    let $pathII2 := $report/EquipmentHFCs/section_II_2/tr_13D
    let $pathII4 := $report/EquipmentHFCs/section_II_4
    let $errorText := 'Please enter a comment for Option 3 in Part 1 in Section II-4.'

    return if (xmlconv:getDouble($checkpath/tco2e) = 0 and ($pathII2/confirmation_a/checked = "true" or $pathII2/confirmation_b/checked = "true" ) and $pathII4/option_a/option = "3" and string-length($pathII4/option_a/reason_3) = 0) then
        uiutil:buildRuleResult("3020", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3021($report as element())
as element(div)*
{
    let $checkpath := $report/ReportedEquipment/Transactions[id = 'tr_13D']
    let $pathII2 := $report/EquipmentHFCs/section_II_2/tr_13D
    let $pathII3 := $report/EquipmentHFCs/section_II_3
    let $pathII4 := $report/EquipmentHFCs/section_II_4
    let $errorText := 'It is not plausible that you choose option (2) or (3) for the Declaration of Conformity (Part 1 of section II-4) when HFCs >0 are reported and confirmed for 13D (section II-2) and option a) or b) was selected for the summary verification statement (section II-3). Please reconsider the selected statements.'

    return if (xmlconv:getDouble($checkpath/tco2e) > 0 and ($pathII2/confirmation_a/checked = "true" or $pathII2/confirmation_b/checked = "true" ) and ($pathII3/confirmation_a/checked = "true" or $pathII3/confirmation_b/checked = "true") and ($pathII4/option_a/option = "2" or $pathII4/option_a/option = "3")) then
        uiutil:buildRuleResult("3021", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3022($report as element())
as element(div)*
{
    let $checkpath := $report/ReportedEquipment/Transactions[id = 'tr_12A']
    let $pathII2 := $report/EquipmentHFCs/section_II_2/tr_12A
    let $pathII4 := $report/EquipmentHFCs/section_II_4
    let $errorText := 'Please enter a comment for Option 1 in Part 2 in Section II-4.'

    return if ((xmlconv:getDouble($checkpath/tco2e) = 0 or ($pathII2/confirmation_c/checked = "true")) and $pathII4/option_b/option = "1" and string-length($pathII4/option_b/reason_1) = 0) then
        uiutil:buildRuleResult("3022", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3023($report as element())
as element(div)*
{
    let $checkpath := $report/ReportedEquipment/Transactions[id = 'tr_12A']
    let $pathII4 := $report/EquipmentHFCs/section_II_4
    let $errorText := 'Please enter a comment for Option 2 in Part 2 in Section II-4.'

    return if (xmlconv:getDouble($checkpath/tco2e) = 0 and $pathII4/option_b/option = "2" and string-length($pathII4/option_b/reason_2) < 5) then
        uiutil:buildRuleResult("3023", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3024($report as element())
as element(div)*
{
    let $checkpath := $report/ReportedEquipment/Transactions[id = 'tr_12A']
    let $pathII2 := $report/EquipmentHFCs/section_II_2/tr_12A
    let $pathII4 := $report/EquipmentHFCs/section_II_4
    let $errorText := 'Please enter a comment for Option 3 in Part 2 in Section II-4.'

    return if (xmlconv:getDouble($checkpath/tco2e) = 0 and ($pathII2/confirmation_a/checked = "true" or $pathII2/confirmation_b/checked = "true" ) and $pathII4/option_b/option = "3" and string-length($pathII4/option_b/reason_3) = 0) then
        uiutil:buildRuleResult("3024", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3025($report as element())
as element(div)*
{
    let $checkpath := $report/ReportedEquipment/Transactions[id = 'tr_12A']
    let $pathII2 := $report/EquipmentHFCs/section_II_2/tr_12A
    let $pathII3 := $report/EquipmentHFCs/section_II_3
    let $pathII4 := $report/EquipmentHFCs/section_II_4
    let $errorText := 'It is not plausible that you choose option (2) or (3) for the Declaration of Conformity (Part 2 of section II-4) when HFCs >0 are reported and confirmed for 12A (Table 2 in section II-2) and option a) or b) was selected for the summary verification statement (section II-3). Please reconsider the selected statements.'

    return if (xmlconv:getDouble($checkpath/tco2e) > 0 and ($pathII2/confirmation_a/checked = "true" or $pathII2/confirmation_b/checked = "true" ) and ($pathII3/confirmation_a/checked = "true" or $pathII3/confirmation_b/checked = "true") and ($pathII4/option_b/option = "2" or $pathII4/option_b/option = "3")) then
        uiutil:buildRuleResult("3025", "", $errorText, $xmlconv:BLOCKER, true(), (), "")
    else()
};


declare function xmlconv:qc3017($report as element())
as element(div)*
{
    if ($report/VerificationScope/Equipment="true") then
        let $pathII4_a := $report/EquipmentHFCs/section_II_4/option_a
        let $errorTextII4_a := 'One of the boxes in section II-4, Part 1 must be selected.'

        let $pathII4_b := $report/EquipmentHFCs/section_II_4/option_b
        let $errorTextII4_b := 'One of the boxes in section II-4, Part 2 must be selected.'


        let $errorsII4_a := 
        if ($pathII4_a/option = "1" or $pathII4_a/option = "2" or $pathII4_a/option = "3")
            then
                ()
            else
                uiutil:buildRuleResult("3017", "", $errorTextII4_a, $xmlconv:BLOCKER, true(), (), "")

        let $errorsII4_b := 
        if ($pathII4_b/option = "1" or $pathII4_b/option = "2" or $pathII4_b/option = "3")
            then
                ()
            else
                uiutil:buildRuleResult("3017", "", $errorTextII4_b, $xmlconv:BLOCKER, true(), (), "")

        return
            ($errorsII4_a, $errorsII4_b)
    else ()

};


declare function xmlconv:getInt($elem) as xs:integer {
    if ($elem castable as xs:integer) then
        xs:integer($elem)
    else
        0
};
declare function xmlconv:getDouble($elem) as xs:double {
    if ($elem castable as xs:double) then
        xs:double($elem)
    else
        0
};

(:
    End of rules
:)

declare function xmlconv:validateReport($url as xs:string)
as element(div)
{
    let $doc := fn:doc($url)/Verification

    (:let $rStatus := xmlconv:rule_ReportStatus($doc):)
    (: for NIL reports only return the status check :)
    let $nilReport := xmlconv:is-NIL-Report($doc)

    (:let $nilReport := false():)
    
    let $resultDiv :=
        if(not($nilReport))
        then
            let $r3006 := xmlconv:qc3006($doc)
            let $r3007 := xmlconv:qc3007($doc)
            let $r3008 := xmlconv:qc3008($doc)
            let $r3009 := xmlconv:qc3009($doc)
            let $r3010 := xmlconv:qc3010($doc)
            let $r3011 := xmlconv:qc3011($doc)
            let $r3012 := xmlconv:qc3012($doc)
            let $r3000 := xmlconv:qc3000($doc)
            let $r3001 := xmlconv:qc3001($doc)
            let $r3002 := xmlconv:qc3002($doc)
            let $r3003 := xmlconv:qc3003($doc)
            let $r3004 := xmlconv:qc3004($doc)
            let $r3005 := xmlconv:qc3005($doc)
            let $r3026 := xmlconv:qc3026($doc)
            let $r3027 := xmlconv:qc3027($doc)
            let $r3028 := xmlconv:qc3028($doc)
            let $r3029 := xmlconv:qc3029($doc)
            let $r3013 := xmlconv:qc3013($doc)
            let $r3014 := xmlconv:qc3014($doc)
            let $r3015 := xmlconv:qc3015($doc)
            let $r3016 := xmlconv:qc3016($doc)
            let $r3018 := xmlconv:qc3018($doc)
            let $r3019 := xmlconv:qc3019($doc)
            let $r3020 := xmlconv:qc3020($doc)
            let $r3021 := xmlconv:qc3021($doc)
            let $r3022 := xmlconv:qc3022($doc)
            let $r3023 := xmlconv:qc3023($doc)
            let $r3024 := xmlconv:qc3024($doc)
            let $r3025 := xmlconv:qc3025($doc)
            let $r3017 := xmlconv:qc3017($doc)

            return
                <div class="errors">
                    <!--{$rStatus}-->
                    {$r3006}
                    {$r3007}
                    {$r3008}
                    {$r3009}
                    {$r3010}
                    {$r3011}
                    {$r3012}
                    {$r3000}
                    {$r3001}
                    {$r3002}
                    {$r3003}
                    {$r3004}
                    {$r3005}
                    {$r3026}
                    {$r3027}
                    {$r3028}
                    {$r3029}
                    {$r3013}
                    {$r3014}
                    {$r3015}
                    {$r3016}
                    {$r3018}
                    {$r3019}
                    {$r3020}
                    {$r3021}
                    {$r3022}
                    {$r3023}
                    {$r3024}
                    {$r3025}
                    {$r3017}

                </div>
        else
            <div>
                
                    <!--{$rStatus}-->
            </div>

    return $resultDiv

};

declare function xmlconv:getMostCriticalErrorClass($ruleResults as element()?)
as xs:string {
    if (count($ruleResults//span[@errorLevel='BLOCKER']) > 0) then
        "BLOCKER"
    else if (count($ruleResults//span[@errorLevel='WARNING']) > 0) then
        "WARNING"
    else if (count($ruleResults//span[@errorLevel='COMPLIANCE']) > 0) then
            "WARNING"
        else
            "INFO"
};
declare function xmlconv:getErrorText($class as xs:string) as xs:string {
    if ($class = "BLOCKER") then
        "The delivery is not acceptable. Please see the QA output."
    else if ($class = "WARNING") then
        "The delivery is acceptable but some of the information has to be checked. Please see the QA output."
    else if ($class = "INFO") then
            "The delivery is acceptable."
        else
            "The delivery status is unknown."
};
(:
 : ======================================================================
 : Main function
 : ======================================================================
 :)
declare function xmlconv:proceed($source_url as xs:string)
as element(div){

    let $results := xmlconv:validateReport($source_url)

    let $class := xmlconv:getMostCriticalErrorClass($results)
    let $errorText := xmlconv:getErrorText($class)

    let $resultErrors := uiutil:getResultErrors($results)

    (: Display all QC messages for maximum possible feedback to the user #68660 :)
    let $hasOnlyStatusError := false()

    return
        uiutil:buildScriptResult($results, $class, $errorText, $hasOnlyStatusError, $xmlconv:cssStyle)
};

(:
Return report validation message depending on the num and type of error items.
:)
declare function xmlconv:getReportValidationMessage($blockerItems as element()*,
        $warningItems as element()*, $infoItems as element()*) as xs:string {

    if (count($blockerItems) > 0 ) then
        "The delivery is not acceptable. Please see the QA output."
    else if (count($warningItems) > 0 ) then
        "The delivery is acceptable but some of the information has to be checked. Please see the QA output."
    else if (count($infoItems) > 0 ) then
            "The delivery is acceptable."
        else
            "The delivery status is unknown."

};


xmlconv:proceed( $source_url )


