xquery version "1.0" encoding "UTF-8";
(:
 : Module Name: FGases dataflow (Main module)
 :
 : Version:     $Id: fgases-2024.xquery 22084 2024-03-10 13:31:33Z katsanas $
 : Created:     20 November 2014
 : Copyright:   European Environment Agency
 :)
(:~
 : Reporting Obligation: http://rod.eionet.europa.eu/obligations/713
 : XML Schema: http://dd.eionet.europa.eu/schemas/fgases-2024/FGasesReporting.xsd
 :
 : F-Gases QA Rules implementation
 :
 : @author Enriko Käsper
 :)


declare namespace xmlconv="http://converters.eionet.europa.eu/fgases";
(: namespace for BDR localisations :)
declare namespace i18n = "http://namespaces.zope.org/i18n";
(: Common utility methods :)

import module namespace cutil = "http://converters.eionet.europa.eu/fgases/cutil" at "fgases-common-util-2024.xquery";
(: UI utility methods for build HTML formatted QA result:)
import module namespace uiutil = "http://converters.eionet.europa.eu/fgases/ui" at "fgases-ui-util-2024.xquery";
import module namespace fgases = 'http://converters.eionet.europa.eu/fgases/helper' at "fgases-helper-2024.xquery";

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

declare function xmlconv:rule_ReportStatus($doc as element())
as element(div)? {

(: check webform status, it has to be completed - click "Close report" button on Finish tab :)

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
};


declare function xmlconv:qc2002($report as element())
as element(div) ?
{
    let $errorText := 'You selected "HFC producer"in the activity selection. Please report on production of HFCs in section 1A or unselect the activity.'
    return
        if(not(fgases:is-P-HFC($report))) then
            ()
        else
            let $gasAmounts1A := fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_01A")
            let $gases:=
                for $gas in $gasAmounts1A
                let $reportedGas := fgases:get-reported-gas-by-id($report, $gas/gasId)
                let $amount := fgases:get-amount-of-gas-amount($gas)
                where not(fgases:is-blend($reportedGas)) and not(fgases:is-unspecified-mix($reportedGas)) and fgases:contains-HFC($reportedGas) and $amount > 0
                return $gas
            return
                if (count($gases) > 0) then
                    ()
                else
                    uiutil:buildRuleResult("2002", "1A", $errorText, $xmlconv:BLOCKER, true(), (), "")
};




declare function xmlconv:qc2003($report as element())
as element(div) ?
{
    let $errorText := 'You selected "non-HFC producer" in the activity selection. Please report on production of non-HFCs in section 1A or unselect the activity.'
    return
        if(not(fgases:is-P-other($report))) then
            ()
        else
            let $gasAmounts1A := fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_01A")
            let $gases:=
                for $gas in $gasAmounts1A
                let $reportedGas := fgases:get-reported-gas-by-id($report, $gas/gasId)
                let $amount := fgases:get-amount-of-gas-amount($gas)
                where not(fgases:is-blend($reportedGas)) and not(fgases:is-unspecified-mix($reportedGas)) and not(fgases:contains-HFC($reportedGas)) and $amount > 0
                return $gas
            return
                if (count($gases) > 0) then
                    ()
                else
                    uiutil:buildRuleResult("2003", "1A", $errorText, $xmlconv:BLOCKER, true(), (), "")
};


declare function xmlconv:qc2004($report as element())
as element(div)*
{
    let $errorText := 'You selected "HFC importer" in the activity selection. Please report on import of HFCs or HFC-containing mixtures in section 2A or unselect the activity.'
    return
        if (not(fgases:is-I-HFC($report))) then
            ()
        else
            let $gasAmounts2A := fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_02A")
            let $gases :=
                for $gas in $gasAmounts2A
                let $reportedGas := fgases:get-reported-gas-by-id($report, $gas/gasId)
                let $amount := cutil:getZeroIfNotNumber($report/F1_S1_4_ProdImpExp/Gas[GasCode = $gas/gasId]/tr_02A/totalAmountForRow)
                where not(fgases:is-blend($reportedGas))
                      and not(fgases:is-unspecified-mix($reportedGas))
                      and fgases:contains-HFC($reportedGas)
                      and $amount > 0
                return $gas
            return
                if (count($gases) > 0) then
                    ()
                else
                    let $gasAmountsExtended := (
                        fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_02G"),
                        for $gas in $report/F1_S1_4_ProdImpExp/Gas
                        return (
                            if ($gas/tr_02H/SumOfPartnerAmounts) then
                                <Gas>
                                    <gasId>{$gas/GasCode/text()}</gasId>
                                    <amount>{$gas/tr_02H/SumOfPartnerAmounts/text()}</amount>
                                </Gas>
                            else ()
                        ),
                        fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_02I"),
                        fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_04A"),
                        fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_04B"),
                        fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_04C"),
                        fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_04F")
                    )
                    let $gases :=
                        for $gas in $gasAmountsExtended
                        let $reportedGas := fgases:get-reported-gas-by-id($report, $gas/gasId)
                        let $amount :=
                            if ($gas/amount) then number($gas/amount)
                            else 0
                        where not(fgases:is-blend($reportedGas))
                              and not(fgases:is-unspecified-mix($reportedGas))
                              and ($amount > 0)
                        return $gas
                    return
                        if (count($gases) > 0) then
                            ()
                        else
                            uiutil:buildRuleResult("2004", "2A", $errorText, $xmlconv:BLOCKER, true(), (), "")
};


declare function xmlconv:qc2005($report as element())
as element(div)* 
{
    let $errorText := 'You selected "non-HFC importer" in the activity selection. Please report in section 2A on import of non-HFCs or mixtures not containing HFCs or unselect the activity.'
    return
        if(not(fgases:is-I-other($report))) then
            ()
        else
            let $gasAmounts2A := fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_02A")
            let $gases := 
                for $gas in $gasAmounts2A
                let $reportedGas := fgases:get-reported-gas-by-id($report, $gas/gasId)
                let $amount := 
                    if ($gas/amount) then xs:decimal($gas/amount) 
                    else if ($gas/SumOfPartnerAmounts) then xs:decimal($gas/SumOfPartnerAmounts) 
                    else 0
                where not(fgases:is-blend($reportedGas)) 
                      and not(fgases:is-unspecified-mix($reportedGas)) 
                      and not(fgases:contains-HFC($reportedGas)) 
                      and $amount > 0
                return $gas
            return
                if (count($gases) > 0) then
                    ()
                else
                    let $gasAmountsExtended := (
                        fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_02G"),
                        for $gas in $report/F1_S1_4_ProdImpExp/Gas
                        return (
                            if ($gas/tr_02H/SumOfPartnerAmounts) then
                                <Gas>
                                    <gasId>{$gas/GasCode/text()}</gasId>
                                    <amount>{$gas/tr_02H/SumOfPartnerAmounts/text()}</amount>
                                </Gas>
                            else ()
                        ),
                        fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_02I"),
                        fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_04A"),
                        fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_04B"),
                        fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_04C"),
                        fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_04F")
                    )
                    let $gases :=
                        for $gas in $gasAmountsExtended
                        let $reportedGas := fgases:get-reported-gas-by-id($report, $gas/gasId)
                        let $amount := 
                            if ($gas/amount) then number($gas/amount)
                            else 0
                        where not(fgases:is-blend($reportedGas)) 
                              and not(fgases:is-unspecified-mix($reportedGas)) 
                              and not(fgases:contains-HFC($reportedGas)) 
                              and ($amount > 0)
                        return $gas
                    return
                        if (count($gases) > 0) then
                            ()
                        else
                            uiutil:buildRuleResult("2005", "2A", $errorText, $xmlconv:BLOCKER, true(), (), "")
};

declare function xmlconv:qc2006($report as element())
as element(div)*
{
    let $errorText := 'You selected "Exporter" in the activity selection. Please report on export in section 3A or unselect the activity.'

    let $sum_tr03A := 
        for $totalAmountForRow in $report/F1_S1_4_ProdImpExp/Gas/*[local-name(.) = "tr_03A"]/totalAmountForRow
        return cutil:getZeroIfNotNumber($totalAmountForRow)
    let $authIsSelected := cutil:is-activity-selected($report/GeneralReportData/Activities/E)

    return
         if($sum_tr03A > 0) then
            ()
        else
            if($authIsSelected and  $sum_tr03A = 0) then
                uiutil:buildRuleResult("2006", "3A", $errorText, $xmlconv:BLOCKER, true(), (), "")
            else
                ()
};

(:declare function xmlconv:qc2007($doc as element()) as element(div)* {:)
(: apply to QC 2007 :)
(:let $errorText := 'You selected "Provider of authorisations to other companies" in the activity selection. Please report on authorisations that were given out in section 9A or unselect the activity.':)
(:let $authIsSelected := cutil:is-activity-selected($doc/GeneralReportData/Activities/auth):)
(:let $amounts := $doc/F4_S9_IssuedAuthQuata/tr_09A/TradePartner/amount:)
(:return:)
(:if(not(count($amounts) > 0)) then:)
(:():)
(:else:)
(:let $sumOfPartnerAmounts := cutil:sum-numbers($amounts):)
(:return:)
(:if($authIsSelected and  $sumOfPartnerAmounts = 0) then:)
(:uiutil:buildRuleResult("2007", "09A", $errorText, $xmlconv:BLOCKER, true(), (), ""):)
(:else:)
(:():)
(:};:)

declare function xmlconv:qc2008($report as element())
as element(div)*
{
    let $errorText := 'You selected "Feedstock user" in the activity selection. Please report on feedstock use in section 7A or unselect the activity.'

    let $sum_tr07A:= fgases:sum-of-gas-for-transaction($report/F6_FUDest, "tr_07A")
    let $authIsSelected := cutil:is-activity-selected($report/GeneralReportData/Activities/FU)
    return
        if($sum_tr07A > 0) then
            ()
        else
            if($authIsSelected and  $sum_tr07A = 0) then
                uiutil:buildRuleResult("2008", "7A", $errorText, $xmlconv:BLOCKER, true(), (), "")
            else
                ()
};


declare function xmlconv:qc2009($report as element())
as element(div)*
{
    let $errorText := 'You selected "Destruction company" in the activity selection. Please report on destruction in section 8 or unselect the activity.'

    let $authIsSelected := cutil:is-activity-selected($report/GeneralReportData/Activities/D)

    let $invalidGases :=
        for $gas in $report/F6_FUDest/Gas
        where $authIsSelected and (not($gas/tr_08D/Amount) or $gas/tr_08D/Amount = 0)
        return $gas/GasId

    return
        if(count($invalidGases) > 0) then
            uiutil:buildRuleResult("2009", "8D", $errorText, $xmlconv:BLOCKER, true(), $invalidGases, "Invalid gases:")
        else
            ()
};


declare function xmlconv:qc2010($report as element())
as element(div)*
{
    let $errorText := 'You selected "Importer of refrigeration, air conditioning or heat pump equipment pre-charged with HFCs or HFC-containing mixtures" in the activity selection. Please report on HFCs or HFC-containing mixtures in section 11A-11F or unselect the activity.'
    return
        if(not(fgases:is-Eq-I-RACHP-HFC($report))) then
            ()
        else
            let $gases := fgases:get-gas-amounts($report/F7_s11EquImportTable, "tr_11G")
            let $total :=
                for $gas in $gases
                let $reportedGas := fgases:get-reported-gas-by-id($report, $gas/gasId)

                where fgases:contains-HFC($reportedGas)
                return $gas/amount
            let $sum11J1 :=  fgases:sum-of-gas-for-transaction($report/F7_s11EquImportTable, "tr_11J1")
            return
                if(sum($total) > 0 or $sum11J1 > 0) then
                    ()
                else
                    uiutil:buildRuleResult("2010", "11G", $errorText, $xmlconv:BLOCKER, true(), (), "")

};

declare function xmlconv:qc2011($report as element())
as element(div)* {

  let $errorText := 'You selected "Importer of other products or equipment" in the activity selection. Please report on section 11H-11P or on non-HFCs or mixtures not containing HFCs in section 11A-11F or unselect the activity.'

  return
    if (not(fgases:is-Eq-I-other($report)) or not(fgases:contains-HFC($report))) then
      ()
    else
      let $reportedGases := $report/ReportedGases
      let $hasGases := exists($reportedGases)

      let $gases := $report/F7_s11EquImportTable/Gas

      let $sumHFC :=
        sum((
          for $gas in $gases
          return sum((
            for $amount in (
              $gas/tr_11H1/Amount,
              $gas/tr_11H2/Amount,
              $gas/tr_11H3/Amount,
              $gas/tr_11H4/Amount,
              $gas/tr_11I/Amount,
              $gas/tr_11J/Amount,
              $gas/tr_11K/Amount,
              $gas/tr_11L/Amount,
              $gas/tr_11M/Amount,
              $gas/tr_11N/Amount,
              $gas/tr_11O/Amount,
              $gas/tr_11P/Amount
            )
            where normalize-space($amount) != ''
            return xs:double($amount)
          ))
        ))

      return
        if (not($hasGases) or ($sumHFC = 0)) then
          uiutil:buildRuleResult("2011", "11G", $errorText, $xmlconv:BLOCKER, true(), (), "")
        else
          ()
};

declare function xmlconv:qc2012($report as element())
as element(div)*
{
    let $errorText := 'You selected "EU recipient of quota exempted HFCs referred to in Article16(2)" in the activity section. Please report on quota exempted HFCs in section 5a or unselect the activity.'

    let $sum_tr05aD := fgases:sum-of-gas-for-transaction($report/F2a_S5a_exempted_HFCs, "tr_05aD")
    let $sum_tr05aE := fgases:sum-of-gas-for-transaction($report/F2a_S5a_exempted_HFCs, "tr_05aE")
    let $recipIsSelected := cutil:is-activity-selected($report/GeneralReportData/Activities/RQ)

    return
         if($sum_tr05aD > 0 or $sum_tr05aE > 0) then
            ()
        else
            if($recipIsSelected and  $sum_tr05aD = 0 and $sum_tr05aE = 0) then
                uiutil:buildRuleResult("2012", "5aD", $errorText, $xmlconv:BLOCKER, true(), (), "")
            else
                ()
};

declare function xmlconv:qc2013($report as element())
as element(div)*
{
    let $errorText := 'You selected "EU recipient of HFCs for the manufacture of metered dose inhalers for the delivery of pharmaceutical ingredients" in the activity section. Please report in section 5aF or unselect the activity.'

    let $sum_tr05aF := fgases:sum-of-gas-for-transaction($report/F2a_S5a_exempted_HFCs, "tr_05aF")
    let $recipIsSelected := cutil:is-activity-selected($report/GeneralReportData/Activities/RH)

    return
         if($sum_tr05aF > 0) then
            ()
        else
            if($recipIsSelected and  $sum_tr05aF = 0) then
                uiutil:buildRuleResult("2013", "5aF", $errorText, $xmlconv:BLOCKER, true(), (), "")
            else
                ()
};


declare function xmlconv:qc2017($doc as element(), $tran as xs:string)
as element(div)* {

(: apply to rule 2017 :)

    let $err_text := "A negative amount here is implausible, please revise your data."

    let $err_flag :=
        for $gas in $doc/F1_S1_4_ProdImpExp/Gas
        where $gas/*[name()=concat('tr_0', $tran)][Amount castable as xs:decimal and number(Amount) < 0]
        return
            data($doc/ReportedGases[GasId = $gas/GasCode]/Name)

    return uiutil:buildRuleResult("2017", $tran, $err_text, $xmlconv:BLOCKER, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};

declare function xmlconv:qc2019($report as element())
as element(div)* {
  
    let $errorTextTemplate := "It is not plausible that your exports from own production/imports (3B) of [gas] are higher than you total exports (3A) of [gas]. Please revise your data."    
    return
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
        let $reportedGas := fgases:get-reported-gas-by-id($report, $gas/GasCode)
        let $isHFC := fgases:contains-HFC($gas/GasCode) 

        let $sum_tr03A := 
            if ($isHFC) 
            then sum($gas/tr_03A/Amount)
            else cutil:numberIfEmpty($gas/tr_03A/totalAmountForRow, 0)

        let $tr03BAmount := cutil:numberIfEmpty($gas/tr_03B/Amount, 0)

        return
            if ($sum_tr03A >= $tr03BAmount) then
                ()
            else
                let $err_text := replace($errorTextTemplate, "\[gas\]", string($reportedGas/Name))
                return uiutil:buildRuleResult("2019", "3B", $err_text, $xmlconv:BLOCKER, true(), (), "")
};

declare function xmlconv:qc2020($report as element())
as element(div)* {

    let $isD := $report/GeneralReportData/Activities/D = 'true'
    let $isP := $report/GeneralReportData/Activities/P = 'true'
    let $isI := $report/GeneralReportData/Activities/I = 'true'

    let $err_text := "Total stocks of [gas] reported in 4A must not be less than the sum of stocks waiting for reclamation (4Aa) and stocks waiting for destruction (8_E)."
    return
        if(not($isD and ($isP or $isI))) then
            ()
        else
            for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $gasCode := $gas/GasCode
            let $reportedGas := fgases:get-reported-gas-by-id($report, $gasCode)
            let $tr_4A := cutil:numberIfEmpty($gas/tr_04A/Amount, 0)
            let $tr_4Aa := cutil:numberIfEmpty($gas/tr_04Aa/Amount, 0)
            let $tr_08EAmount := cutil:numberIfEmpty($report/F6_FUDest/Gas[GasCode=$gasCode]/tr_8E/Amount, 0)
            return
                if($tr_4A >= ($tr_4Aa + $tr_08EAmount)) then
                    ()
                else
                    let $err_text := replace($err_text, "\[gas\]", string($reportedGas/Name))
                    return
                        uiutil:buildRuleResult("2020", "4A" , $err_text, $xmlconv:BLOCKER, true(), (),"")
};

declare function xmlconv:qc2023($report as element())
as element(div)* {

    let $isD := $report/GeneralReportData/Activities/D = 'true'
    let $isP := $report/GeneralReportData/Activities/P = 'true'
    let $isI := $report/GeneralReportData/Activities/I = 'true'

    let $err_text := "Total stocks of [gas] reported in 4F must not be less than the sum of stocks waiting for reclamation (4Fa) and stocks waiting for destruction (8_F)."
    return
        if( not($isD and ($isP or $isI))) then
            ()
        else
            for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $gasCode := $gas/GasCode
            let $reportedGas := fgases:get-gas-by-id($gasCode)
            let $tr04F := cutil:numberIfEmpty($gas/tr_04F/Amount, 0)
            let $tr04Fa := cutil:numberIfEmpty($gas/tr_04Fa/Amount, 0)
            let $tr08F := cutil:numberIfEmpty($report/F6_FUDest/Gas[GasCode=$gasCode]/tr_8F/Amount, 0)
            where fgases:is-P($report) or fgases:is-I($report) or not(fgases:contains-HFC($reportedGas))
            return
                if($tr04F >= ($tr04Fa + $tr08F)) then
                    ()
                else
                    let $err_text := replace($err_text, "\[gas\]", string($reportedGas/Name))
                    return
                        uiutil:buildRuleResult("2023", "4F" , $err_text, $xmlconv:BLOCKER, true(), (),"")
};

declare function xmlconv:qc2024($report as element())
as element(div)* {
    let $err_text := "The increase in stocks between 1st January and 31st December appears to be implausibly high. Please revise data or add an explanation to the 31st December value."
    return
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
        let $reportedGas := fgases:get-reported-gas-by-id($report, $gas/GasCode)
        let $tr_4G := cutil:numberIfEmpty($gas/tr_04G/Amount, 0)
        let $tr_1E := cutil:numberIfEmpty($gas/tr_01E/Amount, 0)
        let $tr_2A := cutil:numberIfEmpty($gas/tr_02A/totalAmountForRow, 0)
        let $tr_2G := cutil:numberIfEmpty($gas/tr_02G/Amount, 0)
        let $tr_4B := cutil:numberIfEmpty($gas/tr_04B/Amount, 0)
        let $errorType := if(fn:string-length($gas/tr_04G/Comment) > 0) then $xmlconv:WARNING else $xmlconv:BLOCKER
        where
            fgases:is-section-4-applicable-gas($report, $reportedGas)
            and $tr_4G > 0
            and not($tr_4G <= round-half-to-even(sum(($tr_1E, $tr_2A, $tr_2G, $tr_4B)), 3))
        return uiutil:buildRuleResult("2024", "4G", $err_text, $errorType, true(), (), "")
};


declare function xmlconv:qc2025($report as element())
as element(div)* {
    let $err_text := "The increase in stocks between 1st January and 31st December appears to be implausibly high. Please revise data or add an explanation to the 31st December value."

    return
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
        let $tr_4H := cutil:numberIfEmpty($gas/tr_04H/Amount, 0)
        let $tr_1E := cutil:numberIfEmpty($gas/tr_01E/Amount, 0)
        let $tr_2A := cutil:numberIfEmpty($gas/tr_02A/totalAmountForRow, 0)
        let $tr_2G := cutil:numberIfEmpty($gas/tr_02G/Amount, 0)
        let $tr_4C := cutil:numberIfEmpty($gas/tr_04C/Amount, 0)
        let $errorType := if(fn:string-length($gas/tr_04H/Comment) > 0) then $xmlconv:WARNING else $xmlconv:BLOCKER
        where
            $tr_4H > 0 and $tr_4H > sum( ($tr_1E, $tr_2A, $tr_2G, $tr_4C) )
        return uiutil:buildRuleResult("2025", "4H", $err_text, $errorType, true(), (), "")
};



declare function xmlconv:qc2026($doc as element())
as element(div)* {

    let $err_text := "For gas "

    let $invalid_gases := 
        for $gas in $doc/F1_S1_4_ProdImpExp/Gas
        let $amount04M := cutil:getZeroIfNotNumber($gas/*[name()='tr_04M']/Amount)
        where $amount04M < 0
        let $gas_name := data($doc/ReportedGases[GasId = $gas/GasCode]/Name)
        return $gas_name

    let $errors :=
        for $gas_name in $invalid_gases
        return uiutil:buildRuleResult(
            "2026", 
            "4M", 
            concat($err_text, $gas_name, ", it is not plausible that the amount in section 4M (amount placed on the market, determined from reported values) is negative. Please double-check and revise your data reported in sections 1 – 4."),
            $xmlconv:BLOCKER, 
            true(), 
            $gas_name, 
            "Invalid gases are: "
        )

    return $errors
};

declare function xmlconv:qc2028 ($doc as element())
as element(div)*
{
(: apply to rule 2028 :)
    let $errorText := "You reported import for own destruction in section [5A, 1A_a_own or 1B]. Please accordingly select to be a destruction company in the activity selection and report subsequently in section 8 or add an explanation in section [5A, 1A_a_own or 1B]."
    let $isD := $doc/GeneralReportData/Activities/D = 'true'
    let $sumThreshold := 1
    let $sumOfAllCO2EqThreshold := 100
    return
        if($isD) then
            ()
        else
            let $companyData := $doc/GeneralReportData/Company
            let $partnerId :=
                for $tradePartnerData in $doc/F2_S5_exempted_HFCs/tr_05A_TradePartners/Partner
                where cutil:isOnwCompany($companyData, $tradePartnerData)
                return $tradePartnerData/PartnerId
            let $companyId := distinct-values($partnerId)
            let $gasAmounts1B := sum($doc/F1_S1_4_ProdImpExp/Gas/tr_01B/cutil:getZeroIfNotNumber(Amount))
            let $gasAmounts1A_a_own := sum($doc/F1_S1_4_ProdImpExp/Gas/tr_01A_a_own/cutil:getZeroIfNotNumber(Amount))
            return
                if((empty($companyId)) and ($gasAmounts1B < 1) and ($gasAmounts1A_a_own < 1)) then
                    ()
                else
                    let $gasAmounts5A := $doc/F2_S5_exempted_HFCs/Gas/tr_05A/TradePartner[TradePartnerID=$companyId]
                    return
                        if((count($gasAmounts5A) = 0) and ($gasAmounts1B < 1) and ($gasAmounts1A_a_own < 1)) then
                            ()
                        else
                            let $total5A := for $item in $gasAmounts5A return cutil:numberIfEmpty($item/amount, 0)
                            let $sum5A := sum($total5A)
                            let $gasAmounts1BComment := $doc/F1_S1_4_ProdImpExp/Gas/tr_01B
                            let $gasAmounts1A_a_ownComment := $doc/F1_S1_4_ProdImpExp/Gas/tr_01A_a_own
                            return
                                let $erroLevel := if((count($gasAmounts5A[not(cutil:isMissingOrEmpty(Comment))]) > 0) or (count($gasAmounts1BComment[not(cutil:isMissingOrEmpty(Comment))]) > 0) or (count($gasAmounts1A_a_ownComment[not(cutil:isMissingOrEmpty(Comment))]) > 0)) then
                                    $xmlconv:WARNING
                                else
                                    $xmlconv:BLOCKER
                                return
                                    if (($sum5A > $sumThreshold) or ($gasAmounts1B > $sumThreshold) or ($gasAmounts1A_a_own > $sumThreshold)) then
                                        uiutil:buildRuleResult("2028", "05A", $errorText, $erroLevel, true(), (), "")
                                    else
                                        let $sumOfAllCO2Eq5A := cutil:calculateSumOfAllCO2Eq($doc/ReportedGases, $gasAmounts5A)
                                        return
                                            if($sumOfAllCO2Eq5A > $sumOfAllCO2EqThreshold) then
                                                uiutil:buildRuleResult("2028", "05A", $errorText, $erroLevel, true(), (), "")
                                            else
                                                ()

};

declare function xmlconv:qc2029($report)
as element(div)* 
{
    let $isD := exists($report/GeneralReportData/Activities/D[. = 'true'])
    return
        if (not($isD)) then
            ()
        else
            let $companyData := $report/GeneralReportData/Company
            let $partnerId :=
                for $tradePartnerData in $report/F2_S5_exempted_HFCs/tr_05A_TradePartners/Partner
                where cutil:isOnwCompany($companyData, $tradePartnerData)
                return $tradePartnerData/PartnerId
            let $ownTradePartnerId := distinct-values($partnerId)
            return
                for $gas in $report/F2_S5_exempted_HFCs/Gas
                let $gasCode := $gas/GasCode
                let $gasName := data($report/ReportedGases[GasId = $gasCode]/Name)
                let $ownTr05AReported := $gas/tr_05A/TradePartner[TradePartnerID = $ownTradePartnerId]
                let $ownTr05AreportedAmount := sum(cutil:numberIfEmpty($ownTr05AReported/amount, 0))
                let $tr08DAmount := cutil:numberIfEmpty($report/F6_FUDest/Gas[GasCode = $gasCode]/tr_08D/Amount, 0)
                let $tr01A_a_ownAmount := cutil:numberIfEmpty($report/F1_S1_4_ProdImpExp/Gas[GasCode = $gasCode]/tr_01A_a_own/Amount, 0)
                let $tr01BAmount := cutil:numberIfEmpty($report/F1_S1_4_ProdImpExp/Gas[GasCode = $gasCode]/tr_01B/Amount, 0)

                where (not(empty($ownTr05AReported)) or ($tr01A_a_ownAmount > 0) or ($tr01BAmount > 0))
                return
                    let $tr05A_exceeds := $ownTr05AreportedAmount > $tr08DAmount
                    let $tr01A_exceeds := $tr01A_a_ownAmount > $tr08DAmount
                    let $tr01B_exceeds := $tr01BAmount > $tr08DAmount
                    
                    let $gasAmount1BComment := $report/F1_S1_4_ProdImpExp/Gas[GasCode = $gasCode]/tr_01B/Comment
                    let $gasAmount1A_a_ownComment := $report/F1_S1_4_ProdImpExp/Gas[GasCode = $gasCode]/tr_01A_a_own/Comment
                    let $hasComment01A := string-length($gasAmount1A_a_ownComment) > 0
                    let $hasComment01B := string-length($gasAmount1BComment) > 0
                    let $hasComment05A := some $c in $ownTr05AReported/Comment satisfies string-length($c) > 0

                    let $errorSections := 
                        (
                            if ($tr05A_exceeds) then "5A" else (),
                            if ($tr01A_exceeds) then "1A_a_own" else (),
                            if ($tr01B_exceeds) then "1B" else ()
                        )
                    let $formattedErrorSections := string-join($errorSections, ", ")
                    let $formattedGasName := string($gasName)
                    
                    let $errorText := concat(
                        "It appears implausible that your import for own destruction reported in [", 
                        $formattedErrorSections, 
                        "] for gas [", 
                        $formattedGasName,
                        "] exceeds total destruction reported in section 8. Please revise your data or add an explanation in section [", 
                        $formattedErrorSections, "].")
                    
                    let $errorType := 
                        if (not($hasComment05A) and not($hasComment01A) and not($hasComment01B)) then 
                            $xmlconv:BLOCKER 
                        else 
                            $xmlconv:WARNING
                    
                    return
                        if ($tr05A_exceeds or $tr01A_exceeds or $tr01B_exceeds) then
                            uiutil:buildRuleResult("2029", "5A", $errorText, $errorType, true(), (), "")
                        else
                            ()
};


declare function xmlconv:qc2031($doc) as element(div)*
{
(: QC 2031 :)
    let $errorText := "You reported supply for own feedstock use in section 5B. Please accordingly select to be a destruction company in the activity selection and report subsequently in section 7."
    let $isFU := $doc/GeneralReportData/Activities/FU = 'true'
    let $threshold := 1000
    return
        if($isFU) then
            ()
        else
            let $companyData := $doc/GeneralReportData/Company
            let $partnerId :=
                for $tradePartnerData in $doc/F2_S5_exempted_HFCs/tr_05B_TradePartners/Partner
                where cutil:isOnwCompany($companyData, $tradePartnerData)
                return $tradePartnerData/PartnerId
            let $companyId := distinct-values($partnerId)
            return
                if(cutil:isEmptyString($companyId)) then
                    ()
                else
                    let $ownTradePartner := $doc/F2_S5_exempted_HFCs/Gas/tr_05B/TradePartner[TradePartnerID=$companyId]

                    let $gasCode := $ownTradePartner/../../GasCode
                    let $reportedGas := $doc/ReportedGases[GasId=$gasCode]
                    return
                        if(empty($ownTradePartner) or empty($reportedGas)) then
                            ()
                        else
                            let $total :=
                                for $item in $ownTradePartner
                                let $amount := cutil:numberIfEmpty($item/amount, 0)
                                let $co2eq := cutil:calculateSumOfAllCO2Eq($reportedGas, $item)
                                return $co2eq
                            let $sum := sum($total)
                            return
                                if ($sum > $threshold) then
                                    uiutil:buildRuleResult("2031", "05B", $errorText, $xmlconv:BLOCKER, true(), (), "")
                                else
                                    ()
};

declare function xmlconv:qc2040($doc as element())
as element(div)* {

(: apply to rule 2040 :)

    let $err_text := "Please explain the 'other' intended application
    / why the application is unknown."

    let $err_flag :=
        for $gas in $doc/F3A_S6A_IA_HFCs/Gas
        where $gas/tr_06T[Amount castable as xs:decimal and number(Amount) > 0]
        return
            if (cutil:isEmpty($gas/tr_06T/Comment))
            then data($doc/ReportedGases[GasId = $gas/GasCode]/Name)
            else ()

    return uiutil:buildRuleResult("2040", "6T", $err_text, $xmlconv:BLOCKER, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};


declare function xmlconv:qc2041($doc as element())
as element(div)* {

(: apply to rule 2041 :)

    let $err_text := "Please provide an explanation for accountancy adjustments."

    let $err_flag :=
        for $gas in $doc/F3A_S6A_IA_HFCs/Gas
        where $gas/tr_06V[Amount castable as xs:decimal and number(Amount) != 0]
        return
            if (cutil:isEmpty($gas/tr_06V/Comment))
            then data($doc/ReportedGases[GasId = $gas/GasCode]/Name)
            else ()

    return uiutil:buildRuleResult("2041", "6V", $err_text, $xmlconv:BLOCKER, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};


declare function xmlconv:qc2042($doc as element())
as element(div)* {

(: apply to rule 2042 :)

    let $err_text := "The totals reported for intended applications (6W)
    should match the totals reported as placed on the Union market (6X).
    Please revise your data."

    let $err_flag :=
        for $gas in $doc/F3A_S6A_IA_HFCs/Gas
        return
            if(not($gas/tr_06W/Amount castable as xs:double) or not($gas/tr_06X/Amount castable as xs:double)) then
                ()
            else
                let $tr06W_Amount := xs:double($gas/tr_06W/Amount)
                let $tr06X_Amount := xs:double($gas/tr_06X/Amount)
                return
                    if ($tr06X_Amount != $tr06W_Amount) then
                        data($doc/ReportedGases[GasId = $gas/GasCode]/Name)
                    else
                        ()
    return if(count($err_flag)>0) then
        uiutil:buildRuleResult("2042", "6W", $err_text, $xmlconv:BLOCKER, count($err_flag)>0, $err_flag, "Invalid gases are: ")
    else
        ()
};


declare function xmlconv:qc2043($doc as element())
as element(div)* {

(: apply to rule 2043 :)

    let $err_text := "The totals calculated in 6X must not be negative.
    Please check amounts reported for production, imports, exports,
    and stocks (sections 1 to 4)."

    let $err_flag :=
        for $gas in $doc/F3A_S6A_IA_HFCs/Gas
        where $gas/tr_06X[Amount castable as xs:decimal and number(Amount) < 0]
        return data($doc/ReportedGases[GasId = $gas/GasCode]/Name)

    return uiutil:buildRuleResult("2043", "6X", $err_text, $xmlconv:BLOCKER, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};

declare function xmlconv:qc20601($doc as element())
as element(div)* {
    let $err_text := "The totals calculated in 6X must match the formula 6x=1E+2A-2B-3B+4B-4G+4K.
    Please check amounts reported for production, imports, exports,
    and stocks (sections 1 to 4)."

    let $err_flag :=
        for $gas in $doc/F3A_S6A_IA_HFCs/Gas
        let $tr_01E_amount := cutil:numberIfEmpty(data($doc/F1_S1_4_ProdImpExp/Gas[GasCode = $gas/GasCode]/tr_01E/Amount), 0)
        let $tr_02A_amount := cutil:numberIfEmpty(data($doc/F1_S1_4_ProdImpExp/Gas[GasCode = $gas/GasCode]/tr_02A/Amount), 0)
        let $tr_02B_amount := cutil:numberIfEmpty(data($doc/F1_S1_4_ProdImpExp/Gas[GasCode = $gas/GasCode]/tr_02B/Amount), 0)
        let $tr_03B_amount := cutil:numberIfEmpty(data($doc/F1_S1_4_ProdImpExp/Gas[GasCode = $gas/GasCode]/tr_03B/Amount), 0)
        let $tr_04B_amount := cutil:numberIfEmpty(data($doc/F1_S1_4_ProdImpExp/Gas[GasCode = $gas/GasCode]/tr_04B/Amount), 0)
        let $tr_04G_amount := cutil:numberIfEmpty(data($doc/F1_S1_4_ProdImpExp/Gas[GasCode = $gas/GasCode]/tr_04G/Amount), 0)
        let $tr_04K_amount := cutil:numberIfEmpty(data($doc/F1_S1_4_ProdImpExp/Gas[GasCode = $gas/GasCode]/tr_04K/Amount), 0)
        where $gas/tr_06X/Amount != $tr_01E_amount + $tr_02A_amount - $tr_02B_amount - $tr_03B_amount +
                $tr_04B_amount - $tr_04G_amount + $tr_04K_amount
        return data($doc/ReportedGases[GasId = $gas/GasCode]/Name)

    return uiutil:buildRuleResult("20430", "6X", $err_text, $xmlconv:BLOCKER,
            count($err_flag) > 0, $err_flag, "Invalid gases are: ")
};

declare function xmlconv:qc2048($report as element())
as element(div)*
{
    let $errorText := "Please explain the equipment category: "
    
    let $selectedCategories := (
        "tr_11A1a4", "tr_11A1b4", "tr_11A1c4",
        "tr_11A2a1iii", "tr_11A2b1iii", "tr_11A2a2iii", 
        "tr_11A2a3iii", "tr_11A2b2iii", "tr_11A2b3iii",
        "tr_11B5", "tr_11C1b", "tr_11C2b", 
        "tr_11D", "tr_11E4", "tr_11F9"
    )
    
    let $selected := 
        for $cat in $selectedCategories
        where $report/F7_s11EquImportTable/UISelectedTransactions/*[name() = $cat] = "true"
        return $cat
    
    let $invalidCategories := 
        for $cat in $selected
        let $category := $report/F7_s11EquImportTable/Category/*[name() = $cat]
        let $amount := $report/F7_s11EquImportTable/SumOfAllGasesS1/*[name() = $cat]/Amount

        where (empty($category) or string-length($category) = 0 or $category = "") 
              and $amount > 0
        return replace(substring-after($cat, "tr_"), "^11", "11_")

    return 
        if (not(empty($invalidCategories))) then
            uiutil:buildRuleResult("2048", string-join($invalidCategories, ", "), $errorText, $xmlconv:BLOCKER, true(), (), "")
        else ()
};

declare function xmlconv:qc2050($doc as element(), $tran as xs:string, $tran_unit as xs:string)
as element(div)* {

(: apply to rule 2050 :)

    let $err_text := "Please specify a measurement unit for the
    amount of products/equipment imported."

    let $err_flag :=
        if ($doc/F7_s11EquImportTable/UISelectedTransactions/*[name()= $tran] = 'true')
        then
            for $gas in $doc/F7_s11EquImportTable/Gas
            where ($gas/*[name()= $tran][Amount castable as xs:decimal and number(Amount) > 0])
            return
                if (cutil:isMissingOrEmpty($doc/F7_s11EquImportTable/*[name()=concat('TR_', $tran_unit, '_Unit')]))
                then data($doc/ReportedGases[GasId = $gas/GasCode]/Name)
                else ()
        else ()

    return uiutil:buildRuleResult("2050", replace(substring-after($tran, "tr_"), "^11", "11_"), $err_text, $xmlconv:BLOCKER, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};

declare function xmlconv:qc2051($doc as element(), $tran as xs:string)
as element(div)* {

(: apply to rule 2051 :)

    let $err_text := "You reported on the amount of imported products/equipment. Please report on the amount of contained gases, as well (unit: metric tonnes of gases)."

    let $transactionIsSelected := $doc/F7_s11EquImportTable/UISelectedTransactions/*[name()= $tran] = 'true'
    let $amount := $doc/F7_s11EquImportTable/AmountOfImportedEquipment/*[name()= $tran]/Amount
    let $invalidGasNames :=
        if ($transactionIsSelected = true() and cutil:isPositiveNumber($amount)) then
            let $sum :=
                for $gas in $doc/F7_s11EquImportTable/Gas/*[name() =  $tran]
                return cutil:numberIfEmpty($gas/Amount, 0)
            return
                if($sum > 0) then
                    ()
                else
                    let $gasCodes := $doc/F7_s11EquImportTable/Gas[*/name() = $tran]/GasCode
                    return
                        for $gasCode in $gasCodes
                        let $gasName := cutil:getGasNameByGasCode($doc, $gasCode)
                        return $gasName
        else
            ()
    return
        if(count($invalidGasNames) > 0) then
            uiutil:buildRuleResult("2051", replace(substring-after($tran, "tr_"), "^11", "11_"), $err_text, $xmlconv:BLOCKER, true(), $invalidGasNames, "Invalid gases are: ")
        else
            ()
};

declare function xmlconv:qc2100($report as element())
    as element(div)*
    {
        let $errorText := "Your company received a quota allocation by the European Commission pursuant to Article 17(4) or a quota transfer pursuant to Article 21(1) of the F-Gas regulation. Please acknowledge by clicking the corresponding box in the activity section."
        let $recipIsSelected := exists($report/GeneralReportData/Activities/RQA[text() = 'true'])
    let $nilReportSelected := exists($report/GeneralReportData/Activities/NIL-Report[text() = 'true'])
    let $xmlCompanyId := xs:integer($report/GeneralReportData/Company/CompanyId)


        let $arrayObligatedCompanies := (12707, 12491, 10080, 10078, 10076, 10084, 10083, 10082, 10081, 10074, 10072, 11928, 9998, 9996, 9994, 9992, 9990, 9989, 9986, 10008, 10007, 10005, 10004, 10003, 9967, 9963, 9965, 9959, 9961, 9956, 9982, 9984, 9978, 9974, 9976, 9971, 9973, 10041, 10047, 10038, 10037, 10040, 10056, 10060, 10058, 10049, 10016, 10018, 10019, 10021, 10009, 10011, 10015, 10029, 10022, 10023, 10025, 10027, 9871, 9867, 9879, 9877, 9875, 9873, 9887, 9883, 9881, 9895, 9893, 9891, 9889, 9842, 9840, 9847, 9853, 9855, 9849, 9851, 9863, 9859, 9927, 9931, 9929, 9937, 9943, 9947, 9945, 9952, 9897, 9899, 9901, 9902, 9904, 9906, 9908, 9910, 9914, 9922, 9923, 11926, 11469, 9401, 9403, 9405, 9407, 9409, 9410, 9411, 9413, 9415, 9527, 9526, 9524, 9522, 9521, 9519, 9517, 9515, 9513, 9511, 9510, 9508, 9503, 9502, 9497, 9499, 9493, 9495, 9489, 9491, 9487, 9481, 9483, 9478, 9480, 9475, 9477, 9469, 9474, 9472, 9463, 9467, 9465, 9457, 9456, 9458, 9450, 9449, 9454, 9452, 9441, 9443, 9445, 9447, 9435, 9439, 9428, 9430, 9432, 9421, 9422, 9424, 9635, 9633, 9631, 9630, 9643, 9641, 9639, 9637, 9618, 9616, 9615, 9626, 9624, 9622, 9605, 9602, 9614, 9611, 9590, 9592, 9587, 9589, 9598, 9600, 9596, 9573, 9571, 9577, 9575, 9581, 9579, 9585, 9583, 9558, 9566, 9565, 9569, 9567, 9543, 9545, 9546, 9548, 9552, 9554, 9556, 9529, 9531, 9533, 9535, 9537, 9538, 9541, 9719, 9716, 9718, 9713, 9714, 9711, 9712, 9734, 9729, 9726, 9728, 9724, 9700, 9699, 9698, 9697, 9693, 9692, 9709, 9707, 9706, 9705, 9704, 9703, 9702, 9701, 9679, 9680, 9681, 9682, 9672, 9676, 9678, 9687, 9689, 9690, 9691, 9683, 9684, 9685, 9686, 9654, 9655, 9647, 9650, 9649, 9665, 9670, 9669, 9659, 9658, 9663, 9661, 9820, 9822, 9818, 9824, 9825, 9829, 9830, 9837, 9838, 9795, 9802, 9801, 9799, 9797, 9809, 9805, 9812, 9810, 9762, 9767, 9780, 9781, 9783, 9785, 9787, 9737, 9745, 9743, 9747, 9746, 9749, 9755, 9753, 9757, 11207, 12889, 12706, 13110, 13273, 13250, 12507, 13370, 13431, 13494, 13336, 13548, 13569, 13687, 13692, 13701, 13717, 13714, 13407, 13777, 13810, 13891, 13915, 13916, 13401, 14052, 13853, 13988, 14021, 14065, 14110, 14139, 14033, 12209, 14145, 14170, 14181, 14186, 14207, 14228, 14237, 14324, 14286, 14328, 14066, 14371, 14360, 14285, 14471, 14447, 14442, 14508, 14556, 14617, 14609, 14549, 14531, 14534, 14422, 14614, 14486, 15031, 14537, 14536, 15466, 15508, 15531, 15748, 15809, 15836, 15875, 15907, 15888, 15934, 15950, 15953, 15970, 16008, 16030, 14125, 15986, 16067, 16069, 15894, 16054, 16092, 16072, 16151, 16071, 16134, 16133, 16132, 16147, 15946, 16179, 16192, 16207, 16231, 16267, 16277, 16140, 16139, 16138, 16141, 16142, 16272, 16291, 16351, 16349, 16346, 16327, 16325, 14631, 16321, 16319, 16363, 16359, 16352, 16280, 16286, 16290, 16376, 16381, 16314, 16412, 16423, 16420, 16424, 16361, 16382, 16418, 16416, 16408, 16411, 16414, 16310, 16439, 16177, 16191, 16247, 16276, 16288, 16284, 16506, 17706, 13784, 18131, 18138, 18510, 18654, 18689, 18747, 18989, 19160, 19209, 19176, 19166, 19338, 19315, 19370, 19413, 19284, 19159, 19517, 18847, 19787, 20087, 20279, 20431, 20194, 20371, 20372, 20373, 20575, 20609, 20534, 19283, 20627, 20639, 20657, 20681, 20676, 20740, 20758, 20764, 20846, 20759, 20642, 21012, 21008, 21034, 21137, 20844, 21022, 20873, 20871, 20867, 20896, 20936, 20894, 20995, 20907, 20996, 21013, 21149, 21187, 20931, 16354, 20946, 20948, 20719, 20919, 21068, 21124, 20739, 21106, 20915, 20772, 21253, 20751, 20906, 20724, 21173, 20796, 21112, 20700, 21031, 20768, 20902, 20909, 21029, 20818, 20810, 20766, 21087, 21098, 21100, 21033, 20737, 21193, 20688, 20924, 20933, 20814, 20695, 20780, 20774, 20792, 20729, 21122, 21096, 21036, 20710, 20788, 21154, 20749, 20930, 20893, 20812, 20776, 21133, 20786, 21077, 20706, 20770, 21108, 20708, 20754, 21227, 20800, 20802, 20734, 21072, 20950, 20816, 20732, 20704, 20624, 21256, 21027, 20922, 21074, 21157, 20714, 21081, 21172, 20686, 21208, 21188, 20702, 21159, 21084, 20804, 20784, 20794, 20808, 20698, 20735, 20716, 21102, 20721, 20726, 21088, 21014, 21207, 21164, 20790, 20778, 21048, 21110, 21092, 21135, 21116, 20742, 21131, 21104, 21215, 20917, 21091, 20911, 20927, 21118, 21050, 21007, 20806, 21120, 21114, 20747, 20798, 21094, 21041, 21078, 20782, 21082, 21024, 21020, 21199, 20934, 20944, 21315, 21318, 21322, 21311, 20678, 20820, 21297, 21791, 21805, 21907, 22336, 22883, 23428, 23488, 23672, 23851, 23852, 24214, 23178, 24773, 24702, 24901, 25315, 25511, 25440, 25646, 26111, 26348, 26411, 26724, 26729, 26743, 16814, 26767, 26772, 26766, 26769, 26768, 26783, 26746, 26792, 26827, 26846, 26893, 26944, 26962, 26976, 26929, 26984, 26987, 26935, 26991, 27001, 26971, 27008, 27009, 26920, 27047, 27067, 27085, 27076, 27156, 27171, 27192, 27196, 27199, 27130, 27232, 27395, 27159, 27054, 27073, 27071, 27245, 27226, 27407, 27058, 27418, 27477, 27503, 27430, 27523, 27478, 26953, 27390, 27558, 27429, 27428, 27525, 27527, 27526, 27464, 27480, 27580, 27466, 27571, 27568, 27448, 27549, 27471, 27530, 27469, 27506, 27467, 27462, 27470, 27620, 27205, 27690, 27175, 27174, 27621, 27660, 27648, 27645, 27656, 27691, 27693, 27639, 27785, 27632, 27560, 27563, 27788, 27574, 27579, 27695, 27782, 27689, 27652, 27754, 27481, 27696, 27425, 27704, 27672, 27628, 27662, 27511, 27516, 27557, 27498, 27680, 27747, 27789, 27722, 27732, 27741, 27731, 27742, 27753, 27752, 27757, 27738, 27711, 27794, 27762, 27271, 27266, 27268, 27797, 27824, 27823, 27409, 27367, 27408, 27814, 27363, 27366, 27364, 27362, 27361, 27360, 27101, 27099, 27103, 27104, 27105, 27106, 27803, 27818, 27107, 27109, 27108, 27809, 27805, 27110, 27111, 27811, 27112, 27113, 27114, 27116, 27117, 27118, 27119, 27120, 27121, 27122, 27123, 27124, 27125, 27126, 27127, 27128, 27129, 27206, 27207, 27209, 27208, 27211, 27212, 27210, 27213, 27214, 27215, 27219, 27821, 27836, 27218, 27229, 27230, 27231, 27624, 27273, 27274, 27275, 27276, 27277, 27279, 27667, 27870, 27787, 28119, 28329, 28243, 29371, 29276, 29215, 29266, 29677, 26443, 29778, 29904, 30082, 30123, 30164, 30198, 30213, 30265, 30447, 30467, 30466, 30127, 30555, 30522, 30523, 30524, 30630, 30629, 30788, 29888, 31073, 31068, 30642, 31280, 30764, 27350, 27829, 27323, 27298, 27278, 27330, 27348, 27833, 27338, 27331, 27855, 27920, 27828, 27314, 27343, 27293, 27744, 27280, 27847, 27291, 27292, 27305, 27320, 27306, 27308, 27840, 27885, 27826, 27115, 27287, 27286, 27282, 27336, 27333, 27311, 27780, 27352, 27332, 27301, 27358, 27339, 27312, 27349, 27319, 27281, 27302, 27355, 27345, 27307, 27294, 27296, 27300, 27884, 27325, 27894, 27317, 27335, 27749, 27290, 27718, 27891, 27356, 27315, 27303, 27327, 27289, 27284, 27309, 27283, 27316, 27887, 27357, 27347, 27344, 27340, 27295, 27297, 27324, 27304, 27351, 27285, 27665, 27318, 27869, 27337, 27353, 27313, 27860, 27843, 27812, 27346, 27816, 27326, 27310, 27512, 27329, 26834, 27341, 27322, 27321, 27850, 27502, 27334, 27299, 31335, 31403, 30767, 31380, 28812, 31605, 31511, 31617, 31649, 31655, 30392, 31743, 31685, 31790, 31646, 31783, 31836, 31842, 31947, 31903, 32114, 32134, 32143, 31752, 31943, 32078, 31944, 32077, 32279, 32220, 32199, 32365, 32265, 32263, 32269, 32267, 32200, 32390, 32298, 32028, 32107, 32468, 32401, 32473, 32105, 32373, 32083, 32509, 32227, 32504, 32367, 32502, 32568, 32492, 32510, 32549, 32449, 28399, 32608, 32562, 32632, 32634, 31624, 32662, 32667, 32672, 32475, 32611, 32657, 32664, 32493, 32095, 31911, 32582, 32601, 32417, 32321, 32415, 32828, 32673, 32709, 32380, 32844, 32730, 32641, 32863, 32553, 32791, 32598, 32452, 32539, 32806, 32559, 32798, 32802, 32883, 32621, 32782, 32952, 32950, 32946, 32213, 32913, 32936, 31621, 32853, 32770, 33019, 32286, 32619, 32544, 33018, 32191, 32960, 32624, 32884, 33052, 32925, 33062, 31893, 33074, 32948, 32938, 33090, 33101, 32930, 32935, 33141, 33165, 33098, 33192, 32642, 33231, 33251, 32910, 32912, 33146, 32891, 33336, 33397, 33108, 33114, 32944, 33346, 33449, 33139, 33493, 33076, 33514, 33404, 33278, 33376, 33555, 32901, 33066, 33703, 33070, 33461, 33770, 32920, 33421, 33814, 33353, 33319, 33490, 33281, 33639, 33855, 33411, 33835, 32880, 33872, 33148, 33861, 33824, 33850, 33860, 33557, 33788, 33408, 33827, 33011, 33410, 33891, 33755, 34006, 33888, 34013, 33953, 32865, 33725, 34025, 34030, 33540, 33020, 32749, 32747, 32754, 32753, 34019, 33986, 34059, 33021, 33848, 33856, 33881, 33075, 33284, 34057, 33904, 33089, 33106, 33897, 33150, 33905, 33174, 33175, 33424, 34178, 33587, 33939, 34501, 32490, 33832, 34188, 33619, 34490, 33973, 34174, 34215, 33821, 34382, 34011, 33970, 33167, 34486, 33166, 33448, 33168, 33172, 34172, 33170, 34230, 34532, 34229, 33155, 33406, 33180, 33818, 34253, 32157, 33516, 34183, 33491, 33412, 34293, 33355, 33914, 34204, 33849, 33808, 34371, 33151, 34235, 33088, 33955, 33950, 34240, 34206, 34306, 34208, 33968, 34242, 34679, 34678, 34211, 34677, 33956, 34198, 34586, 31820, 34736, 34329, 34697, 34667, 33819, 33102, 34698, 34199, 33176, 32350, 33657, 33067, 32546, 33153, 33670, 33807, 34583, 34620, 34634, 34267, 34258, 34695, 34598, 34589, 34663, 34780, 34627, 34646, 34653, 34647, 34654, 34887, 34435, 34683, 34436, 34832, 34781, 34392, 34411, 34522, 34440, 34957, 34868, 33617, 34419, 33216, 34869, 34422, 34937, 34633, 34691, 34825, 33965, 34047, 35011, 34128, 34595, 34656, 34542, 34799, 35028, 32576, 35051, 35063, 34184, 35067, 35087, 34062, 35108, 35109, 35104, 33794, 35061, 34572, 32755, 34186, 32448, 35141, 34880, 35155, 33498, 35030, 35039, 35159, 35165, 35064, 35034, 33509, 33512, 33521, 33515, 33523, 33526, 33531, 33529, 33533, 33542, 33539, 33535, 33545, 33547, 33549, 33551, 33559, 33553, 33564, 33561, 33571, 33573, 33568, 33576, 33580, 33578, 33583, 33585, 33590, 33592, 33588, 33596, 33603, 33599, 33601, 33608, 33606, 33627, 33610, 33629, 33631, 33638, 33635, 33644, 33650, 33648, 33646, 33655, 33652, 33660, 33666, 33671, 33664, 33673, 33676, 33684, 33678, 33680, 33682, 33689, 33686, 33691, 33693, 33695, 33701, 33699, 33697, 33719, 33716, 33709, 33713, 33722, 33729, 33727, 33739, 33736, 33733, 33745, 33743, 33748, 33752, 33754, 33761, 33758, 33763, 33765, 33774, 33767, 33769, 33776, 33780, 33772, 33778, 33782, 33787, 33785, 34876, 34958, 34962, 34956, 34594, 34223, 34424, 34785, 35018, 34232, 35187, 33398, 35101, 35070, 33995, 35179, 35198, 35238, 35125, 35202, 33507, 35025, 33806, 34924, 34932, 35231, 35282, 34001, 35149, 35122, 32557, 35242, 32763, 35268, 33633, 35227, 35229, 35138, 33594, 35213, 35121, 35211, 35127, 35294, 34372, 35240, 35195, 35292, 35191, 35296, 35190, 35236, 34931, 35181, 34651, 34652, 35306, 32718, 35311, 34669, 32716, 34798, 35304, 35261, 35326, 34824, 33801, 34715, 34692, 34688, 35054, 35298, 35284, 35254, 35331, 34345, 35215, 35209, 35288, 35313, 35363, 35140, 35267, 35354, 34428, 35356, 34432, 35360, 34170, 35099, 34802, 34807, 34809, 34806, 34805, 34209, 34803, 34801, 34808, 35318, 35378, 35375, 35234, 32750, 35380, 34563, 34505, 32723, 35273, 34718, 34701, 34666, 34945, 32752, 35383, 35205, 35172, 33907, 34936, 34661, 34933, 35283, 35262, 35255, 35407, 35353, 35392, 35368, 35389, 34682, 35409, 35429, 35449, 14446, 35454, 35166, 32690, 35500, 35434, 35339, 35157, 35459, 35095, 35370, 35323, 35505, 34379, 35518, 34509, 35347, 35199, 35196, 35343, 35059, 35345, 35057, 35248, 35243, 35493, 35452, 35055, 35450, 35457, 35462, 35485, 35427, 35479, 35420, 35542, 32720, 35475, 35455, 32688, 35673, 35849, 33455, 36066, 36328, 36363, 36429, 36561, 36609, 35892, 36266, 37233, 37063, 35681, 37542, 37562, 37550, 37780, 37808, 37816, 37922, 38019, 37848, 38021, 37578, 38449, 33222, 38437, 38378, 38550, 38604, 38745, 38662, 38668, 38849, 38852, 38863, 38846, 38887, 38927, 38956, 38982, 38953, 39054, 39072, 39088, 39191, 38934, 39228, 39225, 39175, 39345, 38652, 39383, 39177, 39176, 39439, 39344, 39189, 39076, 39170, 39172, 39510, 39508, 39475, 39592, 39671, 38789, 39691, 39686, 39666, 39680, 39433, 38213, 39640, 39710, 39648, 39678, 39777, 39690, 39780, 39827, 39822, 39811, 39870, 39826, 39885, 39833, 39649, 39891, 39752, 39874, 39646, 39884, 39166, 38370, 39931, 39787, 39978, 39190, 39676, 37948, 30423, 32165, 35386, 35534, 35516, 35553, 38119, 39876, 39794, 40097, 39955, 39983, 40018, 40058, 39668, 40078, 35537, 40076, 40140, 40141, 40178, 40132, 40130, 40218, 40229, 39817, 39823, 40272, 39810, 39807, 39819, 40084, 40314, 40319, 39466, 40388, 40353, 40419, 40444, 40381, 40234, 40194, 40463, 39754, 40512, 40199, 40528, 40531, 40493, 40535, 40290, 40203, 40544, 40546, 40603, 40416, 40420, 39985, 40637, 40495, 40500, 40730, 40737, 40749, 40746, 40754, 40305, 40062, 40747, 40792, 40717, 40893, 40785, 40807, 40702, 40769, 40803, 40906, 40931, 40964, 40966, 40961, 40370, 40913, 41040, 41067, 41069, 40988, 40887, 41072, 40652, 41075, 41077, 41031, 41033, 40830, 41018, 41045, 41065, 40985, 40983, 41043, 41102, 40889, 41094, 41117, 41122, 41126, 40818, 41131, 41013, 40932, 41133, 40997, 41062, 40960, 40832, 40977, 40729, 41171, 41179, 41174, 41186, 41189, 40759, 40757, 40720, 40755, 40958, 41193, 41025, 41201, 41020, 41079, 40704, 41028, 40816, 41147, 41221, 41051, 40761, 41211, 41234, 41235, 41180, 41240, 41242, 41250, 41254, 41141, 41257, 41261, 41058, 41089, 41253, 41264, 41266, 41268, 41106, 40874, 41286, 41161, 41293, 41279, 40965, 41223, 41344, 41397, 41376, 41416, 40776, 41498, 41504, 41144, 41601, 40975, 40762, 41625, 35561, 41573, 41574, 41145, 40763, 40801, 40797, 40843, 40812, 40814, 40845, 40849, 40858, 40859, 40805, 40799, 40855, 40834, 40853, 40902, 40822, 41621, 41787, 41815, 40154, 41662, 41598, 40733, 40774, 41930, 41943, 42012, 41946, 41949, 41854, 41852, 41850, 41847, 42020, 42120, 40506, 42249, 42190, 42364, 42394, 42368, 42400, 42321, 42568, 42957, 43387, 43454, 43506, 43598, 31942, 44160, 44413, 44718, 44964, 45028, 45033, 45375, 45382, 45613, 45735, 45915, 45943, 46018, 46033, 46076, 46095, 46128, 46171, 46177, 46310, 46358, 46364, 46544, 46565, 46668, 46706, 46785, 46852, 46872, 46945, 46952, 46957, 46964, 46966, 46969, 46995, 46996, 46998, 47000, 47001, 47008, 47015, 47018, 47020, 47025, 47027, 47031, 47033, 47048, 47053, 47054, 47058, 47061, 47064, 47065, 47068, 47073, 47092, 47094, 47101, 47106, 47126, 47287, 47357, 47421, 47433, 47436, 47616, 47651, 47770, 47790, 47829, 47905, 48193, 48201, 48524, 48572, 48690, 49403, 49406, 49572, 49592, 49964, 50080, 50098, 50167, 50199, 50310, 50342, 50365, 50366, 50367, 50449, 50465, 50512, 50521, 50526, 50544, 50593, 50595, 50619, 50666, 50706, 50708, 50765, 50770, 50840, 50844, 50851, 50885, 50895, 50914, 50936, 50938, 50941, 50951, 50962, 50965, 50995, 50996, 51012, 51033, 51049, 51088, 51094, 51137, 51157, 51165, 51166, 51171, 51176, 51178, 51183, 51185, 51188, 51193, 51195, 51199, 51203, 51223, 51228, 51237, 51264, 51265, 51280, 51287, 51292, 51294, 51313, 51316, 51321, 51324, 51331, 51337, 51357, 51361, 51369, 51376, 51379, 51381, 51388, 51397, 51442, 51476, 51518, 51565, 51577, 51579, 51581, 51604, 51606, 51630, 51669, 51670, 51691, 51711, 51730, 51739, 51745, 51794, 51807, 51840, 51846, 51859, 51877, 51884, 51899, 51902, 51921, 51923, 51924, 51926, 51953, 51978, 51992, 52003, 52045, 52060, 52086, 52090, 52091, 52112, 52216, 52260, 52279, 52291, 52306, 52336, 52337, 52378, 52380, 52382, 52397, 52410, 52845, 52917, 53457, 53513, 53599, 53786, 53806, 53821, 53823, 53962, 53979, 53983, 54215, 54220, 54275, 54309, 54314, 54363, 54377, 54403, 54469, 54670, 54677, 54834, 54998, 55090, 55155, 55401, 55430, 55513, 55516, 55570, 55572, 55709, 55832, 55834, 55929, 56270, 56371, 56871, 56949, 57009, 57209, 57549, 57811, 57830, 57892, 58269, 58552, 58609, 58631, 58633, 58635, 58850, 59051, 59493, 59690, 59750, 59752, 59754, 59952, 59969, 60129, 60409, 60381, 60609, 60811, 60991, 61032, 61050, 61055, 61109, 61110, 61056, 61111, 61058, 61060, 61149, 61150, 61061, 61062, 61189, 61174, 61406, 61459, 61472, 61479, 61558, 61630, 61641, 61652, 61654, 61657, 61678, 61691, 61693, 61695, 61696, 61698, 61700, 61711, 61715, 61717, 61773, 61783, 61787, 61789, 61809, 61813, 61815, 61818, 61819, 61821, 61822, 61849, 61850, 61889, 61933, 61940, 61956, 61976, 61978, 61979, 61980, 61991, 61997, 62001, 62003, 62011, 62016, 62018, 62020, 62067, 62068, 62090, 62092, 62094, 62111, 62114, 62116, 62117, 62119, 62120, 62124, 62125, 62149, 62152, 62154, 62155, 62158, 62164, 62166, 62169, 62171, 62176, 62188, 62194, 62201, 62206, 62210, 62211, 62212, 62213, 62214, 62261, 62264, 62266, 62267, 62268, 62269, 62270, 62272, 62273, 62274, 62283, 62285, 62288, 62331, 62342, 62352, 62357, 62361, 62373, 62376, 62391, 62389, 62408, 62422, 62426, 62529, 62609, 62613, 62621, 62622, 62623, 62624, 62684, 62692, 62721, 62783, 62789, 62890, 62909, 62915, 62919, 62961, 62993, 63037, 63093, 63095, 63650, 64038, 64230, 64470, 64569, 64989, 65209, 65310, 65469, 65530, 65572, 65931, 66010, 66070, 66273, 66294, 66413, 66572, 66610, 66735, 66770, 66791, 66811, 66816, 66945, 66969, 67029, 67070, 67094, 67114, 67143, 67175, 67349, 67399, 67419, 67432, 67465, 67471, 67551, 67652, 67770, 68051, 68292, 68369, 68529, 68689, 68770, 68772, 68830, 68890, 69213, 69271, 69376, 69379, 69411, 69518, 69533, 69609, 69672, 69674, 69676, 69680, 69682, 69720, 69735, 69752, 69852, 69901, 69917, 69919, 69921, 69998, 70005, 70034, 70039, 70041, 70060, 70074, 70091, 70094, 70123, 70134, 70156, 70157, 70159, 70162, 70190, 70259, 70261, 70270, 70297, 70315, 70319, 70322, 70324, 70326, 70328, 70330, 70332, 70334, 70336, 70355, 70369, 70406, 70419, 70425, 70428, 70429, 70451, 70490, 70520, 70530, 70596, 70608, 70614, 70616, 70627, 70650, 70665, 70667, 70669, 70675, 70677, 70695, 70700, 70707, 70708, 70745, 70747, 70756, 70759, 70762, 70765, 70783, 70785, 70787, 70791, 70802, 70809, 70811, 70820, 70823, 70824, 70826, 70830, 70833, 70835, 70843, 70844, 70845, 70853, 70858, 70863, 70864, 70866, 70867, 70868, 70890, 70895, 70898, 70899, 70900, 70901, 70902, 70903, 70904, 70905, 70906, 70907, 70908, 70909, 70910, 70911, 70912, 70913, 70915, 70916, 70917, 70918, 70919, 70920, 70921, 70922, 70923, 70924, 70925, 70931, 70943, 70959, 70970, 70979, 70991, 71002, 71015, 71018, 71023, 71028, 71040, 71041, 71043, 71050, 71053, 71070, 71073, 71077, 71098, 71099, 71110, 71111, 71114, 71128, 71139, 71149, 71151, 71153, 71178, 71185, 71188, 71192, 71194, 71197, 71198, 71199, 71201, 71203, 71204, 71208, 71210, 71214, 71219, 71221, 71225, 71227, 71232, 71235, 71238, 71239, 71240, 71243, 71246, 71247, 71249, 71271, 71273, 71282, 71284, 71286, 71291, 71307, 71314, 71315, 71319, 71320, 71326, 71333, 71334, 71338, 71349, 71350, 71353, 71358, 71359, 71360, 71365, 71371, 71377, 71378, 71380, 71392, 71393, 71396, 71405, 71408, 71416, 71425, 71429, 71430, 71433, 71435, 71436, 71439, 71443, 71445, 71471, 71476, 71478, 71483, 71485, 71486, 71488, 71492, 71493, 71496, 71501, 71502, 71504, 71505, 71510, 71520, 71523, 71526, 71532, 71537, 71571, 71949, 72036, 72046, 72047, 72048, 72106, 72119, 73157, 73184, 73252, 73610, 73650, 73678, 74128, 74515, 74710, 75218, 75358, 75591, 75593, 75595, 75611, 75613, 75691, 75731, 75751, 75882, 75890, 76398, 76463, 76485, 76490, 76607, 76720)
       
        let $isObligated := $xmlCompanyId = $arrayObligatedCompanies

        return 
            if ($isObligated and not($recipIsSelected) and not($nilReportSelected)) then
                uiutil:buildRuleResult("2100", "Activity", $errorText, $xmlconv:BLOCKER, true(), (), "")
            else
                ()
};

declare function fgases:is-non-F-only-mix($report as element()) as xs:boolean {
    let $components := $report/F1_S1_CustomMix/Component
    return every $component in $components satisfies $component/IsNonFGas = true()
};

declare function xmlconv:qc2102($report as element())
as element(div)*
{
    let $errorText := "Amounts emitted under customs procedures (2I) must not exceed amounts reported under 6U : Leakage during storage, transport or transfer, and emissions occurring at production. Please revise your data."
    
    let $invalidGases :=
      for $gas in $report/F1_S1_4_ProdImpExp/Gas
          let $gasId := $gas/GasCode
          let $gasName := $report/ReportedGases[GasId eq $gasId]/Name
          let $tr02I := $gas/tr_02I/Amount
          let $tr06U := $report/F3A_S6A_IA_HFCs/Gas[GasCode=$gasId]/tr_06U/Amount
          
          let $value02I := if (normalize-space($tr02I) != "") then xs:decimal($tr02I) else 0
          let $value06U := if (normalize-space($tr06U) != "") then xs:decimal($tr06U) else 0
          
          where $value02I > $value06U
            return($gasName)
            
         return if(count($invalidGases) > 0) then
              uiutil:buildRuleResult("2102", "02I", $errorText, $xmlconv:BLOCKER, true(), $invalidGases, "Invalid gases are: ")
          else
              ()

};


declare function xmlconv:qc2103($report as element())
as element(div)*
{
    let $errorText := 'Your company received a quota allocation by the European Commission pursuant to Article 17(4) or a quota transfer pursuant to Article 21(1) of the F-Gas regulation and you did not report any activities on HFCs in 1A, 2A, 2G or 4C. Please confirm by clicking the box for "Quota recipient NIL report" in section 9.'

    let $recipIsSelected := exists($report/GeneralReportData/Activities/RQA[text() = 'true'])
    let $quotaNILSelected :=  exists($report/F4_S9_IssuedAuthQuata/NilReportConfirmed[text() = 'true'])
    
    let $hfcGases :=
        for $gas in $report/ReportedGases
        where fgases:contains-HFC($gas)
        return $gas/GasId

    let $tr04M_HFC := 
        sum(
            for $gas in $hfcGases
            let $tr01AAmount := cutil:numberIfEmpty($report/F1_S1_4_ProdImpExp/Gas[GasCode = $gas]/tr_01A/Amount, 0)
            let $tr02AAmount := cutil:numberIfEmpty($report/F1_S1_4_ProdImpExp/Gas[GasCode = $gas]/tr_02A/totalAmountForRow, 0)
            let $tr02GAmount := cutil:numberIfEmpty($report/F1_S1_4_ProdImpExp/Gas[GasCode = $gas]/tr_02G/Amount, 0)
            let $tr04CAmount := cutil:numberIfEmpty($report/F1_S1_4_ProdImpExp/Gas[GasCode = $gas]/tr_04C/Amount, 0)
            let $totalValid := $tr01AAmount + $tr02AAmount + $tr02GAmount + $tr04CAmount
            return $totalValid
        )
        
    let $tr09A_HFC := cutil:numberIfEmpty($report/F4_S9_IssuedAuthQuata/tr_09A/SumOfPartnerAmounts, 0)
        
    return 
        if ($recipIsSelected and $tr04M_HFC = 0 and $tr09A_HFC = 0 and not($quotaNILSelected)) 
        then uiutil:buildRuleResult("2103", "Quota recipient NIL report", $errorText, $xmlconv:BLOCKER, true(), (), "")
        else ()
};


declare function xmlconv:qc2104($report as element())
as element(div)*
{
    let $errorText := "Amounts of virgin gases used as feedstock can not be higher than total amounts used as feedstock. Please revise your data."
    for $gas in $report/F6_FUDest/Gas
        let $tr07AAmount := cutil:numberIfEmpty($gas/tr_07A/Amount, 0)
        let $tr07AaAmount := cutil:numberIfEmpty($gas/tr_07Aa/Amount, 0)
        where ($tr07AAmount < $tr07AaAmount)
        return
            uiutil:buildRuleResult("2104", "07Aa", $errorText, $xmlconv:BLOCKER, true(), (), "")
};

declare function xmlconv:qc2105($report as element())
as element(div)*
{
    let $errorText := "It is not plausible that the amount of HFC-23 produced for feedstock use is higher than the amount of virgin HFC-23 used as feedstock reported in 7A_a. Please revise your data."


    let $selectedGases := 
        for $gas in $report/ReportedGases
        let $gasName := normalize-space(data($gas/Code))
        where $gasName = "HFC-23"
        return $gas
        
    return
        for $gas in $selectedGases
        let $gasId := normalize-space(data($gas/GasId))

        let $tr01CaAmount_raw := normalize-space($report/F1_S1_4_ProdImpExp/Gas[normalize-space(GasCode) = normalize-space($gasId)]/tr_01A_fs/totalAmountForRow)
        let $tr07AaAmount_raw := normalize-space($report/F6_FUDest/Gas[normalize-space(GasCode) = normalize-space($gasId)]/tr_07Aa[Code = '07A_a']/Amount)
        let $tr07Aacomment_raw := normalize-space($report/F6_FUDest/Gas[normalize-space(GasCode) = normalize-space($gasId)]/tr_07Aa[Code = '07A_a']/Comment)

        let $value1Ca := if ($tr01CaAmount_raw != "") then xs:decimal($tr01CaAmount_raw) else ()
        let $value07Aa := if ($tr07AaAmount_raw != "") then xs:decimal($tr07AaAmount_raw) else ()

        where exists($value1Ca) and exists($value07Aa) and $value1Ca > $value07Aa and $tr07Aacomment_raw = ""
        return
            uiutil:buildRuleResult("2105", "01C_a", $errorText, $xmlconv:BLOCKER, true(), (), "")
};

declare function xmlconv:qc2106($report as element())
as element(div)*
{
    let $errorText := "It is not plausible that the amount of [gas] emitted under special customs procedures (2I) is higher than the amounts imported, amounts under special customs procedures (2G) and stocks not placed on the market (4C). Please revise your data."

         for $gas in $report/F1_S1_4_ProdImpExp/Gas
          let $gasId := $gas/GasCode
          let $gasCode := $report/ReportedGases[GasId eq $gasId]/Code
          let $tr02IAmount := cutil:numberIfEmpty($gas/tr_02I/Amount, 0)
          let $tr02AAmount := cutil:numberIfEmpty($gas/tr_02A/totalAmountForRow, 0)
          let $tr02GAmount := cutil:numberIfEmpty($gas/tr_02G/Amount, 0)
          let $tr04CAmount := cutil:numberIfEmpty($gas/tr_04C/Amount, 0)
          let $totalValid := $tr02AAmount + $tr02GAmount + $tr04CAmount
            where ($tr02IAmount > $totalValid)
        return
            uiutil:buildRuleResult("2106", "02I", replace($errorText, "\[gas\]", $gasCode), $xmlconv:BLOCKER, true(), (), "")

};

declare function xmlconv:qc2071($report as element())
as element(div)*
{
    let $errorText := "It appears implausible that your supply for own feedstock use reported in 5B exceeds total feedstock use reported in section 7A.
        Please revise your data or add an explanation to your comment in section 5B."
    return
        if(not(fgases:is-FU($report))) then
            ()
        else
            let $ownTradePartnerId := fgases:get-own-tradepartner-id($report,
                    $report/GeneralReportData/Company,
                    $report/F2_S5_exempted_HFCs/tr_05B_TradePartners/Partner)
            return
                if(string-length($ownTradePartnerId) = 0) then
                    ()
                else
                    let $tr05B := fgases:get-gas-amounts-of-trade-partner($report/F2_S5_exempted_HFCs/Gas/tr_05B, $ownTradePartnerId)
                    for $gas in $tr05B
                    let $tr07Amount :=  cutil:numberIfEmpty($report/F6_FUDest/Gas[GasCode=$gas/gasId]/tr_07A/Amount, 0)
                    let $tr05BAmount := cutil:numberIfEmpty($gas/amount, 0)
                    let $errorType := if(fn:string-length($gas/Comment) > 0) then $xmlconv:WARNING else $xmlconv:BLOCKER
                    where $tr05BAmount > 0
                    return
                        if($tr05BAmount <= $tr07Amount ) then
                            ()
                        else
                            uiutil:buildRuleResult("2071", "5B", $errorText, $errorType, true(), (), "")
};

declare function xmlconv:qc2072($report)
as element(div)*
{
    let $errorText := "It appears implausible that destruction of your own by-production (1B) exceeds total destruction reported in section 8. Please revise your data or add an explanation in section 1B."
    return
        if(not(fgases:is-D($report))) then
            ()
        else
            let $tr01BGases := fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_01B" )
            let $tr08DGases := fgases:get-gas-amounts($report/F6_FUDest, "tr_08D" )
            for $gas in $tr01BGases
            let $tr08DSameGas := $tr08DGases[gasId=$gas/gasId]
            let $errorType := if(fn:string-length($gas/Comment) > 0) then $xmlconv:WARNING else $xmlconv:BLOCKER
            where not(empty($tr08DSameGas))
            return
                if(cutil:numberIfEmpty($gas/amount, 0) <= cutil:numberIfEmpty($tr08DSameGas/amount, 0)) then
                    ()
                else
                    uiutil:buildRuleResult("2072", "1B", $errorText, $errorType, true(), (), "")
};

declare function xmlconv:qc2073($report)
as element(div)*
{
    let $errorText := "It appears implausible that destruction of your own by-production (1B) exceeds total destruction reported in section 8. Please revise your data or add an explanation in section 1B."
    let $ownTradePartnerId :=
        fgases:get-own-tradepartner-id($report, $report/GeneralReportData/Company, $report/F2_S5_exempted_HFCs/tr_05A_TradePartners/Partner)
    return
        if(string-length($ownTradePartnerId) = 0) then
            ()
        else
            if(fgases:is-D($report) and fgases:is-I-HFC($report)) then
                let $tr01BGases := fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, "tr_01B" )
                let $tr08DGases := fgases:get-gas-amounts($report/F6_FUDest, "tr_08D" )
                for $gas in $tr01BGases
                let $tr08DSameGas := $tr08DGases[gasId=$gas/gasId]
                let $tr05AGas := fgases:get-gas-amounts-of-trade-partner($report/F2_S5_exempted_HFCs/Gas/tr_05A, $ownTradePartnerId)
                where $gas/amount > 0
                return
                    let $tr01BAmount := cutil:numberIfEmpty($gas/amount, 0)
                    let $tr08DAmount := cutil:numberIfEmpty($tr08DSameGas/amount, 0)
                    let $tr05AAmount :=
                        if(empty($tr05AGas[gasId=$gas/gasId])) then
                            0
                        else
                            cutil:numberIfEmpty($tr05AGas[gasId=$gas/gasId]/amount, 0)
                    return
                        if( sum($tr01BAmount, $tr05AAmount) <= $tr08DAmount ) then
                            ()
                        else
                            uiutil:buildRuleResult("2073", "1B", $errorText, $xmlconv:BLOCKER, true(), (), "")
            else
                ()
};

declare function xmlconv:rule_09($doc as element(), $tran as xs:string,
        $exempt_tran as xs:string, $rule as xs:string)
as element(div)* {

(: apply to rules 2091, 2092, 2093, 2094, 2095, 2096 :)

    let $err_text := "The amount reported for exempted supply for export in 5C_exempted must
    not exceed the amount reported for the intended application 'export' in 6A.
    Please revise your data."

    let $gases :=
        for $gas in $doc/ReportedGases
        where $gas/IsBlend = 'true'
        return $gas/GasId

    let $err_flag :=
        for $gas in $gases

        let $node_gas := $doc/F3A_S6A_IA_HFCs/Gas[GasCode=$gas]/*[name()=concat('tr_0', $tran)]/Amount
        let $node_exempted := $doc/F2_S5_exempted_HFCs/Gas[GasCode=$gas]/*[name()=concat('tr_0', $exempt_tran)]/SumOfPartnerAmounts

        return
            if (fn:not(cutil:isMissingOrEmpty($node_exempted) or cutil:isMissingOrEmpty($node_gas))
                    and $node_gas castable as xs:decimal and $node_exempted castable as xs:decimal and fn:number($node_gas) lt fn:number($node_exempted))
            then data($doc/ReportedGases[GasId eq $gas]/Name)
            else ()

    return uiutil:buildRuleResult($rule, $tran, $err_text, $xmlconv:BLOCKER,
            count($err_flag)>0, $err_flag, "Invalid gases are: ")
};

declare function xmlconv:validateTransactionAmountRange($doc as element(),
        $tran as xs:string,
        $range_min as xs:decimal,
        $range_max as xs:decimal,
        $range_unit as xs:string,
        $rule as xs:string)
as element(div)* {

(: apply to rules 2300 :)

    let $err_text := concat("The calculated specific charge of F-gases is not in the expected range
        (", $range_min," and ", $range_max, " ", $range_unit, "). Please make sure you correctly reported the amounts of gases in
        units of tonnes, not in kilograms. Please revise your data or provide an explanation to the
        calculated specific charge.")

    let $warning_text := concat("The calculated specific charge of F-gases per ",$range_unit ," in section ", $tran," is outside the expected range (", $range_min," ",$range_unit," - ",$range_max," ",$range_unit,"). The explanation provided will be taken into account when evaluating the report.")
    let $err_text := concat("The calculated specific charge of F-gases per ",$range_unit," in section ",$tran," is outside the expected range (",$range_min," ",$range_unit," - ",$range_max," ",$range_unit,"). Please make sure you correctly reported the amounts of gases (in units of tonnes, not in kilograms). Please revise your data or provide an explanation to the calculated specific charge.")
    let $transaction := $tran
    let $hasValues := cutil:atLeastOneNumber($doc/F7_s11EquImportTable/Gas/*[name()=$transaction])
    return
        if($hasValues) then
            if ($doc/F7_s11EquImportTable/UISelectedTransactions/*[name()= $transaction] = 'true' and
                    fn:not(cutil:isMissingOrEmpty($doc/F7_s11EquImportTable/AmountOfImportedEquipment))) then
                let $gasAmounts := $doc/F7_s11EquImportTable/Gas/*[name()=$transaction]
                let $pieces := $doc/F7_s11EquImportTable/AmountOfImportedEquipment/*[name()=$transaction]/Amount
                return
                    if($pieces castable as xs:double and $pieces > 0) then
                        let $num := cutil:average($gasAmounts, $pieces)
                        let $inRange := cutil:checkInRange($num, $range_min, $range_max)
                        return
                            if($num = 0) then
                                ()
                            else
                                if ($inRange) then
                                    ()
                                else
                                    if (cutil:isMissingOrEmpty($doc/F7_s11EquImportTable/Comment/*[name()=$transaction])) then
                                        uiutil:buildRuleResult($rule, replace(substring-after($tran, 'tr_'), "^11", "11_"), $err_text, $xmlconv:BLOCKER, true(), (), "")
                                    else
                                        uiutil:buildRuleResult($rule, replace(substring-after($tran, 'tr_'), "^11", "11_"), $warning_text, $xmlconv:WARNING, true(), (), "")
                    else
                        ()
            else
                ()
        else
            ()
};

declare function xmlconv:sumForm7GasesPerTransaction($doc, $transaction)
{
    let $elems := $doc/F7_s11EquImportTable/F7_s11EquImportTable/Gas/*[name()=$transaction]
    let $items := for $item in $elems return if($item/Amount castable as xs:decimal) then number($item/Amount) else 0
    return sum($items)
};

declare function xmlconv:qc2065($doc as element(), $tran as xs:string)
as element(div)* {

(: apply to rule 2065 :)

    let $err_text := "You reported on the amount of contained gases in imported products/equipment. Please report on the amount of imported products/equipment, as well."

    let $sumGases := 
        sum(
            for $gas in $doc/F7_s11EquImportTable/Gas/*[name() = $tran]
            return cutil:numberIfEmpty($gas/Amount, 0)
        )

    let $amount := $doc/F7_s11EquImportTable/AmountOfImportedEquipment/*[name()= $tran]/Amount

    let $err_flag :=
        if ($sumGases > 0 and (cutil:isMissingOrEmpty($amount) or number($amount) = 0)) 
        then fn:true() 
        else fn:false()

    return uiutil:buildRuleResult("2065", replace(substring-after($tran, "tr_"), "^11", "11_"), $err_text, $xmlconv:BLOCKER, $err_flag, (), "Invalid gases are: ")

};


declare function xmlconv:qc2079($doc as element())
as element(div)* {
  
    let $errorText := "Please explain the category of imported foam products."
    let $gasAmounts := for $item in $doc/F7_s11EquImportTable/SumOfAllGasesS1/tr_11P 
                        return cutil:numberIfEmpty($item/Amount, 0)
    let $sum11P := sum($gasAmounts)
    return
        if($sum11P > 0) then
            let $tr11PCategory := $doc/F7_s11EquImportTable/Category/tr_11P
            return
                if(fn:string-length($tr11PCategory) < 2) then
                    uiutil:buildRuleResult("2079", "11_P", $errorText, $xmlconv:BLOCKER, true(), (), "")
                else
                    ()
        else
            ()
};

declare function xmlconv:qc2078($doc as element())
as element(div)* {

(: apply to rule 2078 :)

    let $err_text := "A negative amount here is implausible, please revise your data."

    let $gases :=
        for $gas in $doc/ReportedGases
        where $gas/IsBlend = 'true'
        return $gas/GasId

    let $err_flag :=
        for $gas in $gases
        return
            if ($doc/F1_S1_4_ProdImpExp/Gas[GasCode=$gas]/tr_01H[Amount castable as xs:decimal and number(Amount) < 0])
            then data($doc/ReportedGases[GasId eq $gas]/Name)
            else ()

    return uiutil:buildRuleResult("2078", "1H", $err_text, $xmlconv:BLOCKER,
            count($err_flag)>0, $err_flag, "Invalid gases are: ")
};

declare function xmlconv:qc2087($doc as element())
as element(div)?
{
    let $errorText := "Please explain the category of imported foam products."
    let $gasAmounts := for $item in $doc/F7_s11EquImportTable/SumOfAllGasesS1/tr_11H4 
                        return cutil:numberIfEmpty($item/Amount, 0)
    let $sum11H04 := sum($gasAmounts)
    return
        if($sum11H04 > 0) then
            let $tr11H04Category := $doc/F7_s11EquImportTable/Category/tr_11H4
            return
                if(fn:string-length($tr11H04Category) < 2) then
                    uiutil:buildRuleResult("2087", "11_H4", $errorText, $xmlconv:BLOCKER, true(), (), "")
                else
                    ()
        else
            ()
};

declare function xmlconv:qc2088($doc) as element(div)* 
{
    let $errorTextTemplate := 
        "It is not plausible that the values you have entered in 1B for [gas/mixture] are larger than those entered in 8_D_a (for HFC-23 and mixtures containing HFC-23). Please revise your data in 1B and/or 8_D_a."

    let $selectedGases := 
        for $gas in $doc/ReportedGases
        let $gasName := data($gas/Name)
        let $gasCode := data($gas/GasId)
        let $isHFC23 := $gasName = "HFC-23"
        let $isMixtureWithHFC23 := some $component in $gas/BlendComponents/Component satisfies ($component/Code = "HFC-23")
        where $isHFC23 or $isMixtureWithHFC23
        return $gas

    return
        for $gas in $selectedGases
        let $gasName := data($gas/Name)
        let $gasCode := data($gas/GasId)

        let $amount1B_raw := normalize-space($doc/F1_S1_4_ProdImpExp/Gas[GasCode = $gasCode]/tr_01B/Amount)
        let $amount8Da_raw := normalize-space($doc/F6_FUDest/Gas[GasCode = $gasCode]/tr_8Da/Amount)

        let $value1B := if ($amount1B_raw != "") then xs:decimal($amount1B_raw) else ()
        let $value8Da := if ($amount8Da_raw != "") then xs:decimal($amount8Da_raw) else ()

        where exists($value1B) and exists($value8Da) and $value1B > $value8Da
        return
            let $errorText := replace($errorTextTemplate, "\[gas/mixture\]", $gasName)
            return uiutil:buildRuleResult("2088", "01B", $errorText, $xmlconv:BLOCKER, true(), $gasName, "Invalid gases are: ")
};



declare function xmlconv:qc2089($doc) as element(div)* 
{
    (: QC 2089 :)
    let $errorText := "You reported on production for feedstock use in section 1C_a. Please accordingly select to be a Feedstock Use company in the activity selection and report subsequently in section 7."
    let $isFU := $doc/GeneralReportData/Activities/FU = 'true'
    let $gases := $doc/F2_S1_ReportedGases/Gas
    let $sumGas := sum(for $gas in $gases return cutil:numberIfEmpty($gas/tr_01A_fs, 0))
    let $sumCO2Eq := sum(
        for $gas in $gases
        let $co2eq := cutil:calculateSumOfAllCO2Eq($gas, $gas/tr_01A_fs)
        return $co2eq
    )
    return
        if ($isFU) then
            ()
        else if ($sumGas > 1 or $sumCO2Eq > 1000) then
            uiutil:buildRuleResult("2089", "1A_fs", $errorText, $xmlconv:BLOCKER, true(), (), "")
        else
            ()
};

declare function xmlconv:qc2090($report as element())
as element(div)*
{
    let $categoryMessages := map {
        "tr_11J2": "Please explain the type of medical or pharmaceutical aerosol",
        "tr_11L3": "Please explain the type of medical product or equipment",
        "tr_11M5": "Please explain the type of equipment for transmission and distribution of electricity",
        "tr_11N": "Please explain the type of electrical equipment",
        "tr_11O4": "Please explain the type of particle accelerator"
    }
    
    let $selectedCategories := map:keys($categoryMessages)
    
    let $invalidCategories :=
        for $cat in $selectedCategories
        let $isSelected := $report/F7_s11EquImportTable/UISelectedTransactions/*[name() = $cat] = "true"
        let $totalGasAmount := sum($report/F7_s11EquImportTable/Gas/*[name() = $cat]/Amount/text())
        let $comment := normalize-space($report/F7_s11EquImportTable/Category/*[name() = $cat])
        where $isSelected and $totalGasAmount > 0 and $comment = ""
        return $cat
    
    return
        if (not(empty($invalidCategories))) then
            for $cat in $invalidCategories
            return uiutil:buildRuleResult("2090", replace(substring-after($cat, "tr_"), "^11", "11_"), $categoryMessages($cat), $xmlconv:BLOCKER, true(), (), "")
        else ()
};



declare function xmlconv:qc2039($doc as element())
as element(div)* {

(: apply to rule 2080 ?? 2039:)

    let $err_text := "The totals reported for exempted uses in sections 5A - 5F cannot exceed the amount reported as physically placed on the market in sections 1–3, taking changes in stocks (section 4) into account. Please review your data."

    let $err_flag :=
        for $gas in $doc/ReportedGases

        let $sum_4 :=
            cutil:getZeroIfNotNumber($doc/F1_S1_4_ProdImpExp/Gas[GasCode=$gas/GasId]/tr_04M/Amount) (:+
                    cutil:getZeroIfNotNumber($doc/F1_S1_4_ProdImpExp/Gas[GasCode=$gas/GasId]/tr_04D/Amount):)

        let $sum_5 :=
            cutil:getZeroIfNotNumber($doc/F2_S5_exempted_HFCs/Gas[GasCode=$gas/GasId]/tr_05G/Amount) +
                    cutil:getZeroIfNotNumber($doc/F2_S5_exempted_HFCs/Gas[GasCode=$gas/GasId]/tr_05R/SumOfPartnerAmounts) (:+
                    cutil:getZeroIfNotNumber($doc/F1_S1_4_ProdImpExp/Gas[GasCode=$gas/GasId]/tr_04I/Amount):)

        where ($sum_5 > $sum_4)
        return data($gas/Name)

    return uiutil:buildRuleResult("2039", "5A", $err_text, $xmlconv:BLOCKER,
            count($err_flag)>0, $err_flag, "Invalid gases are: ")
};

declare function xmlconv:qc24220($doc) as element(div)* {
  let $errorText := "You reported supply for direct export in section 5C_exempted and the amounts reported in 5C_exempted for gas [name gas] exceed your stocks reported in section 4F. Please accordingly select to be a exporter in the activity selection and report subsequently in section 3."
  let $isExporter := cutil:is-activity-selected($doc/GeneralReportData/Activities/E)
  let $companyVAT := normalize-space($doc/GeneralReportData/Company/VATNumber)

  let $ownPartnerIds := for $p in $doc/F2_S5_exempted_HFCs/tr_05C_TradePartners/Partner
                        where normalize-space($p/CompanyName) = $companyVAT
                        return normalize-space($p/PartnerId)

  return
    if (empty($ownPartnerIds)) then ()
    else
      for $gas in $doc/F2_S5_exempted_HFCs/Gas
      let $gasCode := normalize-space($gas/GasCode)
      let $gasName := cutil:getGasNameByGasCode($doc, $gasCode)
      let $amount05C :=
        sum(
          for $entry in $gas/tr_05C/TradePartner
          where normalize-space($entry/TradePartnerID) = $ownPartnerIds
          return xs:decimal(cutil:getZeroIfNotNumber($entry/amount))
        )
      let $amount04F :=
        sum(
          for $g in $doc/F1_S1_4_ProdImpExp/Gas
          where normalize-space($g/GasCode) = $gasCode
          return xs:decimal(cutil:getZeroIfNotNumber($g/tr_04F/Amount))
        )
      return
        if ($amount05C > 0 and not($isExporter) and $amount05C > $amount04F) then
          let $msg := replace($errorText, "\[name gas\]", $gasName)
          return uiutil:buildRuleResult("24220", "5C_exempted", $msg, $xmlconv:BLOCKER, true(), (), "")
        else ()
};



declare function xmlconv:qc24221($doc) as element(div)* 
{
    let $errorText := "It appears implausible that your supply for direct export to your own company reported in 5C_exempted exceeds exports of amounts previously placed on the market as reported in 3C. Please revise your data or add an explanation as a comment in section 5C_exempted."
    let $isExporter := cutil:is-activity-selected($doc/GeneralReportData/Activities/E)
    return
        if(not($isExporter)) then
            ()
        else
            let $companyData := $doc/GeneralReportData/Company
            let $partnerId := 
                for $tradePartner in $doc/F2_S5_exempted_HFCs/tr_05C_TradePartners/Partner
                where cutil:isOnwCompany($companyData, $tradePartner)
                return $tradePartner/PartnerId
            let $companyId := distinct-values($partnerId)
            return
                if(cutil:isEmptyString($companyId)) then
                    ()
                else
                    let $ownTradePartnerEntries := $doc/F2_S5_exempted_HFCs/Gas/tr_05C/TradePartner[TradePartnerID = $companyId]
                    let $gasCodes := $ownTradePartnerEntries/../../GasCode
                    let $amounts05C := $ownTradePartnerEntries/amount
                    let $comments05C := $ownTradePartnerEntries/Comment
                    let $reportedGas03C := $doc/F1_S1_4_ProdImpExp/Gas/tr_03C
                    for $i in 1 to count($amounts05C)
                    let $gasAmount05C := $amounts05C[$i]
                    let $gasCode := $gasCodes[$i]
                    let $comment := $comments05C[$i]
                    let $gasAmount03C := 
                        for $g in $reportedGas03C
                        where $g/../GasCode = $gasCode
                        return $g/Amount
                    return
                        if ($gasAmount05C > $gasAmount03C) then
                            if (cutil:isEmptyString($comment)) then
                                uiutil:buildRuleResult("24221", "5C_exempted", $errorText, $xmlconv:BLOCKER, true(), (), "")
                            else
                            uiutil:buildRuleResult("24221", "5C_exempted", $errorText, $xmlconv:WARNING, true(), (), "")
                        else
                            ()
};


declare function xmlconv:qc2098($doc as element())
as element(div)* {
  
  (: apply to rule 2098 :)

    let $err_text := "Re-exports in products/equipment (2B) must not exceed the sum of your total imports, purchases under special customs procedures and 1st January stocks from own import/production not placed on the market (2A + 2G + 4C). Please revise your data."

    let $err_flag :=
        for $gas in $doc/ReportedGases
        let $isHFC := fgases:contains-HFC($gas/GasId)  

        let $tr_02A_value := 
            if ($isHFC) 
            then sum($doc/F1_S1_4_ProdImpExp/Gas[GasCode=$gas/GasId]/tr_02A/Amount)
            else cutil:getZeroIfNotNumber($doc/F1_S1_4_ProdImpExp/Gas[GasCode=$gas/GasId]/tr_02A/totalAmountForRow)

        let $tr_02G_value := cutil:getZeroIfNotNumber($doc/F1_S1_4_ProdImpExp/Gas[GasCode=$gas/GasId]/tr_02G/Amount)

        let $tr_04C_value := cutil:getZeroIfNotNumber($doc/F1_S1_4_ProdImpExp/Gas[GasCode=$gas/GasId]/tr_04C/Amount)

        let $sum := $tr_02A_value + $tr_02G_value + $tr_04C_value

        where (cutil:getZeroIfNotNumber($doc/F1_S1_4_ProdImpExp/Gas[GasCode=$gas/GasId]/tr_02B/Amount) > $sum)
        return data($gas/Name)

    return uiutil:buildRuleResult("2098", "2B", $err_text, $xmlconv:BLOCKER, count($err_flag) > 0, $err_flag, "Invalid gases are: ")
};


declare function xmlconv:qc2099($report)
as element(div)*
{
    let $errorText := "Destroyed own production (1D) must not exceed the sum of your total production and 1st January stocks from own import/production not placed on the market (1Ab + 4C and 8E). Please revise your data."
    for $gas in $report/F1_S1_4_ProdImpExp/Gas
        let $gasCode := $gas/GasCode
        let $tr01DAmount := cutil:numberIfEmpty($gas/tr_01D/Amount, 0)
        let $tr01AbAmount := cutil:numberIfEmpty($gas/tr_01Ab/Amount, 0)
        let $tr04CAmount := cutil:numberIfEmpty($gas/tr_04C/Amount, 0)
        let $tr08EAmount := cutil:numberIfEmpty($report/F6_FUDest/Gas[GasCode=$gasCode]/tr_8E/Amount, 0)
        where
            ($tr01DAmount > ($tr01AbAmount+$tr04CAmount)) or ($tr01DAmount > ($tr01AbAmount+$tr08EAmount))
        return
            uiutil:buildRuleResult("2099", "1D", $errorText, $xmlconv:BLOCKER, true(), (), "")
};

declare function xmlconv:qc2044($doc as element()) as element(div)* {
(: apply to QC 2044 :)
    let $errorText := "According to your figures, you placed more than 1000 t CO2eq of HFCs on the market (determined from values in 4M), or you specified quota-exempt supplies for direct export in bulk (5C_exempted). Note that you are therefore obliged to have this reporting verified. Please tick the box under section 9 to acknowledge this obligation."
    let $threshold := 1000
    let $tr09F := cutil:if-number($doc/F4_S9_IssuedAuthQuata/tr_09F/Amount, 0)
    let $tr05CSum := cutil:sum-numbers($doc/F2_S5_exempted_HFCs/Gas/tr_05C/TradePartner/amount)
    let $documentIsVerified := exists($doc/F4_S9_IssuedAuthQuata/Verified[text() = 'true'])
    return
        let $condition :=
            if($tr09F >= $threshold or $tr05CSum > 0 ) then
                true()
            else
                false()
        return
            if($condition and not($documentIsVerified)) then
                uiutil:buildRuleResult("2044", "09F", $errorText, $xmlconv:BLOCKER, true(), (), "")
            else
                ()
};


declare function xmlconv:qc2403($doc as element()) as element(div)* {
(: QC_2403 :)
    let $err_text := "Based on the reported numbers, your available HFC quota (9G) may not suffice to cover the amount of HFCs that was placed on the market. Please check your reported data in order to avoid erroneous reporting. Note that the European Commission (DG CLIMA) will assess your company’s quota compliance in co-operation with your Member State’s competent authorities. Failure to comply may result in reductions in future quota allocation and in penalties according to national law of the Member State concerned."
    return
        let $tr09F := cutil:if-number($doc/F4_S9_IssuedAuthQuata/tr_09F/Amount, 0)
        let $tr09G := cutil:if-number($doc/F4_S9_IssuedAuthQuata/tr_09G/Amount, 0)
        return
            if($tr09F <= $tr09G)
            then
                ()
            else
                uiutil:buildRuleResult("2403", "09F", $err_text, $xmlconv:WARNING, true(), (), "")
};

declare function xmlconv:qc24031($doc as element()) as element(div)* {
(: QC_24031 :)
    let $err_text := "The need of quota for HFCs placed on the market (section 9F) is calculated to be negative for the sum of all reported HFCs. This is not likely to be plausible. Please double check your data reported in sections 1, 2, 3, 4, 5 and/or 9A. "
    return
        let $tr09F := cutil:if-number($doc/F4_S9_IssuedAuthQuata/tr_09F/Amount, 0)
        return
            if($tr09F >= 0) then
                ()
            else
                uiutil:buildRuleResult("24031", "09F", $err_text, $xmlconv:COMPLIANCE, true(), (), "")
};

declare function xmlconv:qc2404($doc as element()) as element(div)* {
(: QC-2404 :)
    let $errorText := "According to the HFC Registry, authorisations have been issued to equipment importers by your undertaking (see section 9), but not included in this report. Please select the Auth activity (Supplier of Authorisations) on the Activities page and review the values in section 9. Keep in mind that incomplete reporting on authorisations may distort the preliminary quota assessment based on this report."
    let $tr09ARegistry := cutil:if-number($doc/F4_S9_IssuedAuthQuata/tr_09A_imp/SumOfPartnerAmounts,0)
    let $isAuth := cutil:is-activity-selected($doc/GeneralReportData/Activities/auth)
    return
        if($tr09ARegistry > 0) then
            if( $isAuth  ) then
                ()
            else
                uiutil:buildRuleResult("2404", "09A", $errorText, $xmlconv:COMPLIANCE, true(), (), "")
        else
            ()
};

declare function xmlconv:qc24041($doc as element()) as element(div)* {
(: QC-24041 :)
    let $errorText := "By adding data in section 9A_add you are trying to report an authorisation that is not registered in the HFC registry. Please do not repeat in 9A_add authorisations that are covered in the HFC registry and contained in the data of section 9A_imp.
    There should be no need for reporting authorisations outside the scope of 9A_imp, as authorisations can only be used by the recipient to cover their equipment imports in case the authorisation was duly registered in the HFC registry by 31 December.
If you are sure that your report should deviate in section 9A from the data as given in 9A_imp, please add a comment to explain why your authorisations were not registered in the HFC registry. You must be able to provide proof during quota compliance checking at a later time."


    let $qcStatus :=
        for  $TradePartner in $doc/F4_S9_IssuedAuthQuata/tr_09A_add/TradePartner
        return
            if ( cutil:if-number($TradePartner/amount, 0 ) != 0 and  fn:string-length($TradePartner/Comment) < 2 ) then
                1
            else
                ()
    return
        if ( exists($qcStatus) ) then
            uiutil:buildRuleResult("24041", "09A_add", $errorText, $xmlconv:BLOCKER, true(), (), "")
        else
            ()

};

declare function xmlconv:qc24042($doc as element()) as element(div)* {
(: QC-24042 :)
    let $errorText := "In section 9A you are reporting on authorisations that deviate from those registered in the HFC Registry. Please note that the European Commission will decide on a case by case basis whether such deviations from the Registry are acceptable. Keep in mind that incorrect reporting on authorisations may distort the automatic preliminary calculation of quota demand based on this report."
    let $qcStatus :=
        for $TradePartner in $doc/F4_S9_IssuedAuthQuata/tr_09A_add/TradePartner
        return
            if ( cutil:if-number($TradePartner/amount, 0 ) != 0 and  fn:string-length($TradePartner/Comment) > 2 ) then
                1
            else
                ()
    return
        if ( exists($qcStatus) ) then
            uiutil:buildRuleResult("24042", "09A_add", $errorText, $xmlconv:COMPLIANCE, true(), (), "")
        else
            ()

};

declare function xmlconv:qc24043($doc as element()) as element(div)* {
(: QC-2404 :)
    let $errorText := "You have reported authorisations in section 9A_add in addition to those registered in the HFC Registry. Your additions are negative in sum, which means that the total sum of authorisations in your report will not completely account for your authorisations registered in the HFC registry. Please check whether the data reported in section 9A_add are complete before submitting. Keep in mind that incomplete reporting on authorisations may distort the automatic preliminary calculation of quota demand based on this report."
    let $tr09A_Add_Sum := cutil:sum-numbers($doc/F4_S9_IssuedAuthQuata/tr_09A_add/TradePartner/amount)
    return
        if ( $tr09A_Add_Sum >= 0 ) then
            ()
        else
            uiutil:buildRuleResult("24043", "09A_add", $errorText, $xmlconv:COMPLIANCE, true(), (), "")
};


declare function xmlconv:qc2405($doc as element()) as element(div)* {
(: QC-2405 :)
    let $err_text := "Please note that authorisations issued to your own company are not deemed acceptable by the European Commission. Thus, the use of such self-authorisations to cover equipment imports charged with HFCs may be rejected during quota compliance checks."
    let $partners := $doc/F4_S9_IssuedAuthQuata/tr_09A_add_TradePartners/Partner
    let $reportingCompany := $doc/GeneralReportData/Company
    let $companyId := fgases:get-own-tradepartner-id($doc, $reportingCompany, $partners)
    return
        if(string-length($companyId) =0 ) then
            ()
        else
            let $ownAmount := $doc/F4_S9_IssuedAuthQuata/tr_09A_add/TradePartner[TradePartnerID=$companyId and amount castable as xs:integer and xs:integer(amount) > 0]
            let $condition := count($ownAmount) > 0
            return
                if($condition) then
                    uiutil:buildRuleResult("2405", "09A_add", $err_text, $xmlconv:COMPLIANCE, true(), (), "")
                else
                    ()
};

(:declare function xmlconv:qc2408($report as element()) as element(div)* :)
(:{:)
(: QC-2408 :)
(:let $gasAmounts06A := fgases:get-gas-amounts-with-values($report/F3A_S6A_IA_HFCs, 'tr_06A'):)
(:let $gasAmounts03A := fgases:get-gas-amounts-with-values($report/F1_S1_4_ProdImpExp, 'tr_03A'):)
(:let $invalidGasIds := :)
(:for $gasAmount06A in $gasAmounts06A:)
(:let $matching03A :=:)
(:for $gasAmount03A in $gasAmounts03A:)
(:where fgases:get-gas-id-of-gas-amount($gasAmount03A) = fgases:get-gas-id-of-gas-amount($gasAmount06A):)
(:return $gasAmount03A:)
(:return:)
(:if (empty($matching03A)) then () else fgases:get-gas-id-of-gas-amount($gasAmount06A):)
(:return:)
(:for $invalidGasId in $invalidGasIds:)
(:let $invalidGas := fgases:get-gas-by-id($invalidGasId):)
(:let $errorMsg := xmlconv:qc2408-error-text($invalidGas):)
(:return uiutil:buildRuleResult("2408", "6A", $errorMsg, $xmlconv:WARNING, true(), (), ""):)
(:};:)

declare function xmlconv:qc2408-error-text($gas as element(Gas)) as xs:string
{
    let $msgTemplate := "You have reported both bulk exports (section 3A) and non-bulk exports (intended application 6A) for [gas]. Please make sure your exports are separately reported as bulk (3A) and non-bulk (6A), but not double-counted. Your reporting may be followed up in order to make sure that the reporting is correct."
    return replace($msgTemplate, "\[gas\]", string($gas/Name))
};

declare function xmlconv:qc2409TradePartner2($transactionCode, $partnerDefinition as element()*, $partnerTransactionData as element()*) as element(div)* {
(: QC-2409 :)

    let $errorText := "Feedstock use has repeatedly been subject to erroneous reporting. Please provide a brief explanation of the process where the reported gas is used as a feedstock."
    let $partnerIds := $partnerDefinition/Partner/PartnerId
    let $invalidTradePartners :=
        for $partnerId in $partnerIds
        for $partnerData in $partnerTransactionData[TradePartnerID=$partnerId]
        let $amount := cutil:if-number($partnerData/amount, 0)
        let $comment := data($partnerData/Comment)
        where $amount > 0 and string-length($comment) = 0
        return string($partnerDefinition/Partner[PartnerId = $partnerId]/CompanyName)
    return
        if(count($invalidTradePartners) > 0) then
            let $tradePartnerNames := distinct-values($invalidTradePartners)
            return uiutil:buildRuleResult("2409", $transactionCode, $errorText, $xmlconv:BLOCKER, true(), $tradePartnerNames, "Invalid companies are : ")
        else
            ()
};

declare function xmlconv:qc2409TradePartner($reportedData as element(FGasesReporting), $partnerDefinition as element()*,
        $transactionCode as xs:string, $gases as element(Gas)*, $sectionName as xs:string)
as element(div)*
{
    let $transactionName := concat("tr_", $transactionCode)
    let $totalErrors :=
        for $gas in $gases
        let $gasCode := $gas/GasCode
        let $gasName := cutil:getGasNameByGasCode($reportedData, $gasCode)
        let $tradePartnerData := $gas/*[local-name()=$transactionName]/TradePartner
        let $errors :=
            for $tradePartner in $tradePartnerData
            let $tradePartnerName := cutil:getTransactionPartnerName($partnerDefinition, $tradePartner/TradePartnerID)
            let $errorText := xmlconv:getQC2409ErrorMessageTradePartner($tradePartnerName, $gasName, $sectionName)
            where not(cutil:transactionHasMandatoryCommentTradePartner($tradePartner))
            return uiutil:buildRuleResult("2409", $transactionCode, $errorText, $xmlconv:BLOCKER, true(), (), "")
        return $errors
    return $totalErrors
};

declare function xmlconv:qc2409CountrySpecific($reportedData as element(FGasesReporting), $countryDefinition as element()*,
        $transactionCode as xs:string, $gases as element(Gas)*, $sectionName as xs:string)
as element(div)*
{
    let $transactionName := concat("tr_", $transactionCode)
    let $totalErrors :=
        for $gas in $gases
        let $gasCode := $gas/GasCode
        let $gasName := cutil:getGasNameByGasCode($reportedData, $gasCode)
        let $countrySpecificData := $gas/*[local-name()=$transactionName]/CountrySpecific
        let $errors :=
            for $country in $countrySpecificData/Country
            let $countryName := cutil:getTransactionCountryName($countryDefinition, $country/CountryId)
            let $errorText := xmlconv:getQC2409ErrorMessageCountry($countryName, $gasName, $sectionName)
            where not(cutil:transactionHasMandatoryComment($country))
            return uiutil:buildRuleResult("2409", $transactionCode, $errorText, $xmlconv:BLOCKER, true(), (), "")
        return $errors
    return $totalErrors
};

declare function xmlconv:qc2409($reportedData as element(FGasesReporting), $transactionCode as xs:string,
        $gases as element(Gas)*, $sectionName as xs:string)
as element(div)*
{
    let $invalidGasTransactions :=
        for $gas in $gases
        let $transactionName := concat("tr_", $transactionCode)
        let $transactionData := $gas/*[fn:local-name()=$transactionName]
        where not(cutil:transactionHasMandatoryComment($transactionData))
        return
            let $gasName := cutil:getGasNameByGasCode($reportedData, $gas/GasCode)
            let $errorText := xmlconv:getQC2409ErrorMessage($gasName, $sectionName)
            return uiutil:buildRuleResult("2409", $transactionCode, $errorText, $xmlconv:BLOCKER, true(), (), "")
    return $invalidGasTransactions
};

declare function xmlconv:getQC2409ErrorMessage($gasName as xs:string, $section as xs:string )
as xs:string{
    let $msgTemplate := "Reporting on feedstock use has been erroneous in the past. Please provide a comment for [gas] in section [section]"
    let $msg1 := replace($msgTemplate, "\[gas\]", $gasName)
    return replace($msg1, "\[section\]", $section)
};

declare function xmlconv:getQC2409ErrorMessageTradePartner($tradePartnerName as xs:string, $gasName as xs:string, $section as xs:string )
as xs:string{
    let $msgTemplate := "Reporting on feedstock use has been erroneous in the past. Please provide a comment for [gas] in section [section] - supplied by [partner]"
    let $msg1 := replace($msgTemplate, "\[gas\]", $gasName)
    let $msg2 := replace($msg1, "\[section\]", $section)
    return replace($msg2, "\[partner\]", $tradePartnerName)
};

declare function xmlconv:getQC2409ErrorMessageCountry($countryName as xs:string, $gasName as xs:string, $section as xs:string )
as xs:string{
    let $msgTemplate := "Reporting on feedstock use has been erroneous in the past. Please provide a comment for [gas] in section [section] - supplied by [country]"
    let $msg1 := replace($msgTemplate, "\[gas\]", $gasName)
    let $msg2 := replace($msg1, "\[section\]", $section)
    return replace($msg2, "\[country\]", $countryName)
};

declare function xmlconv:getQC2455ErrorMessage($gasName as xs:string, $section as xs:string )
as xs:string{
    let $msgTemplate := "Transaction 01A_fs - [gas] : Reporting on production for feedstock uses ([section]]) has been erroneous in the past. Please provide a brief comment for [gas] in section 01A_fs explaining the nature of feedstock use. [QC 2455]"
    let $msg1 := replace($msgTemplate, "\[gas\]", $gasName)
    return replace($msg1, "\[section\]", $section)
};

declare function xmlconv:getQC2456ErrorMessage($gasName as xs:string, $section as xs:string )
as xs:string{
    let $msgTemplate := "Please explain the used destruction technology. [QC 2456]"
    let $msg1 := replace($msgTemplate, "\[gas\]", $gasName)
    return replace($msg1, "\[section\]", $section)
};

declare function xmlconv:qc2457($doc as element()) as element(div)* 
{
    let $errorTextTemplate := 
        "The amount of virgin HFC-23 destroyed [category_a] can not exceed the total amount destroyed by this technology [category]."

    let $selectedGases := $doc/ReportedGases
    let $hfc23Selected := 
        some $gas in $selectedGases 
        satisfies normalize-space(data($gas/Code)) = "HFC-23"

    return if (not($hfc23Selected)) then () 
    else 
        let $categories := (
            map{"a" : "tr_8A1ia", "b" : "tr_8A1i"},
            map{"a" : "tr_8A1iia", "b" : "tr_8A1ii"},
            map{"a" : "tr_8A1iiia", "b" : "tr_8A1iii"},
            map{"a" : "tr_8A1iva", "b" : "tr_8A1iv"},
            map{"a" : "tr_8A1othera", "b" : "tr_8A1other"},
            map{"a" : "tr_8A2othera", "b" : "tr_8A2other"},
            map{"a" : "tr_8Ba1ia", "b" : "tr_8Ba1i"},
            map{"a" : "tr_8Ba1iia", "b" : "tr_8Ba1ii"},
            map{"a" : "tr_8Ba1othera", "b" : "tr_8Ba1other"},
            map{"a" : "tr_8Ba2othera", "b" : "tr_8Ba2other"},
            map{"a" : "tr_8Bb1ia", "b" : "tr_8Bb1i"},
            map{"a" : "tr_8Bb1othera", "b" : "tr_8Bb1other"},
            map{"a" : "tr_8Bb2othera", "b" : "tr_8Bb2other"},
            map{"a" : "tr_8C1othera", "b" : "tr_8C1other"},
            map{"a" : "tr_8C2othera", "b" : "tr_8C2other"}
        )

        let $hfc23GasId := data($selectedGases[normalize-space(Code) = "HFC-23"]/GasId)

        for $pair in $categories
        let $category_a := $pair("a")
        let $category := $pair("b")

        let $amount_a_node := $doc/F6_FUDest/Gas[GasCode = $hfc23GasId]/*[name() = $category_a]/Amount
        let $amount_node := $doc/F6_FUDest/Gas[GasCode = $hfc23GasId]/*[name() = $category]/Amount

        where exists($amount_a_node) and exists($amount_node) and normalize-space($amount_a_node) != "" and normalize-space($amount_node) != ""

        let $amount_a := xs:decimal($amount_a_node)
        let $amount := xs:decimal($amount_node)
        let $code_a := data($doc/F6_FUDest/Gas[GasCode = $hfc23GasId]/*[name() = $category_a]/Code)
        let $code := data($doc/F6_FUDest/Gas[GasCode = $hfc23GasId]/*[name() = $category]/Code)


        where ($amount_a > $amount)
        let $errorText := replace(replace($errorTextTemplate, "\[category_a\]", $code_a), "\[category\]", $code)

        return uiutil:buildRuleResult("2457", $code_a, $errorText, $xmlconv:BLOCKER, true(), $code_a, "Invalid categories: ")
};

declare function xmlconv:getQC24100ErrorMessage($countryName as xs:string, $gasName as xs:string, $err_msg as xs:string )
as xs:string{
    let $msgTemplate := $err_msg
    let $msg1 := replace($msgTemplate, "\[gas\]", $gasName)
    return replace($msg1, "\[country\]", $countryName)
};

declare function xmlconv:getQC24100bErrorMessage($countryName as xs:string, $gasName as xs:string, $err_msg as xs:string )
as xs:string{
    let $msgTemplate := $err_msg
    let $msg1 := replace($msgTemplate, "\[gas\]", $gasName)
    return replace($msg1, "\[country\]", $countryName)
};


declare function xmlconv:qc2410($transactionCode as xs:string, $transactionData as node()? )
as element(div)*
{
    let $errorText := "Reporting on re-exports (2B) has been erroneous in the past. Please provide a brief comment for 'gas' in section 2B explaining the nature of the re-exports."
    let $ReportedGases := $transactionData/../ReportedGases

    let $result :=
        for $GasReport in $transactionData/Gas
        let $amount := cutil:if-number($GasReport/tr_02B/Amount, 0)
        let $comment := data($GasReport/tr_02B/Comment)
        let $gasName := $ReportedGases[GasId = $GasReport/GasCode]/Name
        let $errorMsg := fn:replace( $errorText , 'gas', $gasName)

        return
            if($amount > 0 and string-length($comment) = 0) then
                uiutil:buildRuleResult("2410", $transactionCode, $errorMsg, $xmlconv:BLOCKER, true(), (), "")
            else
                ()

    return $result
};

declare function xmlconv:qc2411($report as element()) as element(div)*
{
(: QC-2411 :)
    let $gasAmounts02A := fgases:get-gas-total-amounts($report/F1_S1_4_ProdImpExp, 'tr_02A')
    let $gasAmounts11Q := fgases:get-gas-amounts-with-values($report/F7_s11EquImportTable, 'tr_11Q')
    let $invalidGasIds :=
        for $gasAmount02A in $gasAmounts02A
        let $matching11Q :=
            for $gasAmount11Q in $gasAmounts11Q
            where fgases:get-gas-id-of-gas-amount($gasAmount11Q) = fgases:get-gas-id-of-gas-amount($gasAmount02A)
            return $gasAmount11Q
        return
            if (empty($matching11Q)) then
                ()
            else
                let $amount02A := fgases:get-amount-of-gas-amount($gasAmount02A)
                let $amount11Q := fgases:get-amount-of-gas-amount($matching11Q)
                return
                    if (abs($amount02A - $amount11Q) > 1 or $amount02A = 0) then
                        ()
                    else
                        fgases:get-gas-id-of-gas-amount($gasAmount02A)

    return
        for $invalidGasId in $invalidGasIds
        let $invalidGas := fgases:get-gas-by-id-or-name($invalidGasId ,  $report//ReportedGases[GasId = $invalidGasId]/Name )
        let $errorMsg := xmlconv:qc2411-error-text($invalidGas)
        return uiutil:buildRuleResult("2411", "2A", $errorMsg, $xmlconv:WARNING, true(), (), "")
};

declare function xmlconv:qc2412($report as element()) as element(div)*
{
(: QC-2412 :)
    let $errorMsg:="You reported bulk imports in section 2A but you have not available HFC quota (9G) for placing HFCs on the market. In case the HFCs you imported where contained in products or equipment, those amounts should be reported in seciton 11 instead of 2A. Please check your reported data in order to avoid erroneous reporting and consider resubmitting your report."
    let $gasAmounts02A := fgases:get-gas-total-amounts($report/F1_S1_4_ProdImpExp, 'tr_02A')
    let $gasAmount09F := cutil:if-number($report/F4_S9_IssuedAuthQuata/tr_09F/Amount, 0)
    let $gasAmount09G := cutil:if-number($report/F4_S9_IssuedAuthQuata/tr_09G/Amount, 0)
    let $invalidGases :=
        for $gasAmount02A in $gasAmounts02A
        let $amount02A := fgases:get-amount-of-gas-amount($gasAmount02A)
        return
            if ($amount02A <= 0) then
                ()
            else                
                if(($gasAmount09F>0) and ($gasAmount09G = 0)) then                
                    fgases:get-gas-name-by-id(fgases:get-gas-id-of-gas-amount($gasAmount02A))
                else ()
    
    return
        if (count($invalidGases)>0) then
            uiutil:buildRuleResult("2412", "2A ", $errorMsg(:fn:concat("9F: ",$gasAmount09F):), $xmlconv:WARNING, true(), $invalidGases , "Invalid gases are : ")
        else 
            ()
};



declare function xmlconv:qc2455($reportedData as element(FGasesReporting), $gases as element(Gas)*)
as element(div)*
{
    let $invalidGasTransactions :=
        for $gas in $gases, $country in $gas/tr_01A_fs/CountrySpecific/Country
       
        return if (not(cutil:transactionHasMandatoryComment($country)))
        then(
                    
            let $gasName := cutil:getGasNameByGasCode($reportedData, $gas/GasCode)
            let $errorText := xmlconv:getQC2455ErrorMessage($gasName, "tr_01A_fs")
            return uiutil:buildRuleResult("2455", "tr_01A_fs", $errorText, $xmlconv:BLOCKER, true(), (), "")
            )
        else()

    return $invalidGasTransactions
};
declare function xmlconv:qc2456_8A1other($reportedData as element(FGasesReporting), $gases as element(Gas)*)
as element(div)*
{
    let $invalidGasTransactions :=
        for $gas in $gases
        let $transactionData := $gas/*[fn:local-name()="tr_8A1other"]
        where not(cutil:transactionHasMandatoryComment($transactionData))
        return    
            let $gasName := cutil:getGasNameByGasCode($reportedData, $gas/GasCode)
            let $errorText := xmlconv:getQC2456ErrorMessage($gasName, "tr_8A1other")
            return uiutil:buildRuleResult("2456", "tr_8A1other", $errorText, $xmlconv:BLOCKER, true(), (), "")
    return $invalidGasTransactions
};
declare function xmlconv:qc2456_8A2other($reportedData as element(FGasesReporting), $gases as element(Gas)*)
as element(div)*
{
    let $invalidGasTransactions :=
        for $gas in $gases
        let $transactionData := $gas/*[fn:local-name()="tr_8A2other"]
        where not(cutil:transactionHasMandatoryComment($transactionData))
        return    
            let $gasName := cutil:getGasNameByGasCode($reportedData, $gas/GasCode)
            let $errorText := xmlconv:getQC2456ErrorMessage($gasName, "tr_8A2other")
            return uiutil:buildRuleResult("2456", "tr_8A2other", $errorText, $xmlconv:BLOCKER, true(), (), "")
    return $invalidGasTransactions
};
declare function xmlconv:qc2456_8Ba1other($reportedData as element(FGasesReporting), $gases as element(Gas)*)
as element(div)*
{
    let $invalidGasTransactions :=
        for $gas in $gases
        let $transactionData := $gas/*[fn:local-name()="tr_8Ba1other"]
        where not(cutil:transactionHasMandatoryComment($transactionData))
        return    
            let $gasName := cutil:getGasNameByGasCode($reportedData, $gas/GasCode)
            let $errorText := xmlconv:getQC2456ErrorMessage($gasName, "tr_8Ba1other")
            return uiutil:buildRuleResult("2456", "tr_8Ba1other", $errorText, $xmlconv:BLOCKER, true(), (), "")
    return $invalidGasTransactions
};
declare function xmlconv:qc2456_8Ba2other($reportedData as element(FGasesReporting), $gases as element(Gas)*)
as element(div)*
{
    let $invalidGasTransactions :=
        for $gas in $gases
        let $transactionData := $gas/*[fn:local-name()="tr_8Ba2other"]
        where not(cutil:transactionHasMandatoryComment($transactionData))
        return    
            let $gasName := cutil:getGasNameByGasCode($reportedData, $gas/GasCode)
            let $errorText := xmlconv:getQC2456ErrorMessage($gasName, "tr_8Ba2other")
            return uiutil:buildRuleResult("2456", "tr_8Ba2other", $errorText, $xmlconv:BLOCKER, true(), (), "")
    return $invalidGasTransactions
};
declare function xmlconv:qc2456_8Bb1other($reportedData as element(FGasesReporting), $gases as element(Gas)*)
as element(div)*
{
    let $invalidGasTransactions :=
        for $gas in $gases
        let $transactionData := $gas/*[fn:local-name()="tr_8Bb1other"]
        where not(cutil:transactionHasMandatoryComment($transactionData))
        return    
            let $gasName := cutil:getGasNameByGasCode($reportedData, $gas/GasCode)
            let $errorText := xmlconv:getQC2456ErrorMessage($gasName, "tr_8Bb1other")
            return uiutil:buildRuleResult("2456", "tr_8Bb1other", $errorText, $xmlconv:BLOCKER, true(), (), "")
    return $invalidGasTransactions
};
declare function xmlconv:qc2456_8Bb2other($reportedData as element(FGasesReporting), $gases as element(Gas)*)
as element(div)*
{
    let $invalidGasTransactions :=
        for $gas in $gases
        let $transactionData := $gas/*[fn:local-name()="tr_8Bb2other"]
        where not(cutil:transactionHasMandatoryComment($transactionData))
        return    
            let $gasName := cutil:getGasNameByGasCode($reportedData, $gas/GasCode)
            let $errorText := xmlconv:getQC2456ErrorMessage($gasName, "tr_8Bb2other")
            return uiutil:buildRuleResult("2456", "tr_8Bb2other", $errorText, $xmlconv:BLOCKER, true(), (), "")
    return $invalidGasTransactions
};
declare function xmlconv:qc2456_8C1other($reportedData as element(FGasesReporting), $gases as element(Gas)*)
as element(div)*
{
    let $invalidGasTransactions :=
        for $gas in $gases
        let $transactionData := $gas/*[fn:local-name()="tr_8C1other"]
        where not(cutil:transactionHasMandatoryComment($transactionData))
        return    
            let $gasName := cutil:getGasNameByGasCode($reportedData, $gas/GasCode)
            let $errorText := xmlconv:getQC2456ErrorMessage($gasName, "tr_8C1other")
            return uiutil:buildRuleResult("2456", "tr_8C1other", $errorText, $xmlconv:BLOCKER, true(), (), "")
    return $invalidGasTransactions
};
declare function xmlconv:qc2456_8C2other($reportedData as element(FGasesReporting), $gases as element(Gas)*)
as element(div)*
{
    let $invalidGasTransactions :=
        for $gas in $gases
        let $transactionData := $gas/*[fn:local-name()="tr_8C2other"]
        where not(cutil:transactionHasMandatoryComment($transactionData))
        return    
            let $gasName := cutil:getGasNameByGasCode($reportedData, $gas/GasCode)
            let $errorText := xmlconv:getQC2456ErrorMessage($gasName, "tr_8C2other")
            return uiutil:buildRuleResult("2456", "tr_8C2other", $errorText, $xmlconv:BLOCKER, true(), (), "")
    return $invalidGasTransactions
};


declare function xmlconv:qc24109($reportedData as element(FGasesReporting), $countryDefinition as element()*,
       $gases as element(Gas)*)
as element(div)*
{    
    let $err_msg := "2C and 2D indicate the amount of virgin and recycled HFCS imported per country as a subset of overall imports per country and thus can not exceed overall imports per country. Please correct your values and take care that all values have to be reported country specific.([country]) ([gas])"
    let $totalErrors :=
        for $gas in $gases
        let $gasCode := $gas/GasCode
        let $gasName := cutil:getGasNameByGasCode($reportedData, $gasCode)
        let $countrySpecificData := $gas/tr_02A/CountrySpecific
        let $errors :=
            if ( not(not($countrySpecificData/Country/text()[normalize-space(.) != '']) and $countrySpecificData/Country/*)) then
                ()
            else
                for $country in $countrySpecificData/Country
                let $countryId := $country/CountryId/text()
                let $countryName := cutil:getTransactionCountryName($countryDefinition, $countryId)
                let $errorText := xmlconv:getQC24100ErrorMessage($countryName, $gasName,  $err_msg)
                let $val02A := cutil:getCountrySpecificAmountForTransaction($gas, "tr_02A", $countryId)
                let $val02C := cutil:getCountrySpecificAmountForTransaction($gas, "tr_02C", $countryId)
                let $val02D := cutil:getCountrySpecificAmountForTransaction($gas, "tr_02D", $countryId)
                where ($val02D + $val02C > $val02A)
            return uiutil:buildRuleResult("24109", "02A", $errorText, $xmlconv:BLOCKER, true(), (), "")
        return $errors
    return $totalErrors
};

declare function xmlconv:qc24111($reportedData as element(FGasesReporting), $countryDefinition as element()*,
       $gases as element(Gas)*)
as element(div)*
{    
    let $err_msg := "3G and 3H indicate the amount of virgin and recycled HFCS exported per country as a subset of overallexports per country and thus can not exceed overall exports per country. Please correct your values and take care that all values have to be reported country specific.([country]) ([gas])"
    let $totalErrors :=
        for $gas in $gases
        let $gasCode := $gas/GasCode
        let $gasName := cutil:getGasNameByGasCode($reportedData, $gasCode)
        let $countrySpecificData := $gas/tr_03A/CountrySpecific
        let $errors :=
            if ( not(not($countrySpecificData/Country/text()[normalize-space(.) != '']) and $countrySpecificData/Country/*)) then
                ()        
            else
                for $country in $countrySpecificData/Country
                let $countryId := $country/CountryId/text()
                let $countryName := cutil:getTransactionCountryName($countryDefinition, $countryId)
                let $errorText := xmlconv:getQC24100ErrorMessage($countryName, $gasName,  $err_msg)
                let $val02A := cutil:getCountrySpecificAmountForTransaction($gas, "tr_03A", $countryId)
                let $val03G := cutil:getCountrySpecificAmountForTransaction($gas, "tr_03G", $countryId)
                let $val03H := cutil:getCountrySpecificAmountForTransaction($gas, "tr_03H", $countryId)
                where ($val03G + $val03H > $val02A)
            return uiutil:buildRuleResult("24111", "03A", $errorText, $xmlconv:BLOCKER, true(), (), "")
        return $errors
    return $totalErrors
};


declare function xmlconv:qc24100($reportedData as element(FGasesReporting), $countryDefinition as element()*,
       $gases as element(Gas)* , $transaction as xs:string, $atransaction as xs:string, $err_msg as xs:string, $qcCode as xs:string )
as element(div)*
{
    let $transactionName := concat("tr_", $transaction)
    let $totalErrors :=
        for $gas in $gases
        let $gasCode := $gas/GasCode
        let $gasName := cutil:getGasNameByGasCode($reportedData, $gasCode)
        let $countrySpecificData := $gas/*[local-name()=$transaction]/CountrySpecific
        let $errors :=
            if ( not(not($countrySpecificData/Country/text()[normalize-space(.) != '']) and $countrySpecificData/Country/*)) then
                ()
            else
                for $country in $countrySpecificData/Country
                let $countryId := $country/CountryId/text()
                let $countryName := cutil:getTransactionCountryName($countryDefinition, $countryId)
                let $errorText := xmlconv:getQC24100ErrorMessage($countryName, $gasName, $err_msg)
                let $valA := cutil:getCountrySpecificAmountForTransaction($gas, $atransaction, $countryId)
                let $val := cutil:getCountrySpecificAmountForTransaction($gas, $transactionName, $countryId)
                where ($val > $valA)
                return uiutil:buildRuleResult($qcCode, $transaction, $errorText, $xmlconv:BLOCKER, true(), (), "")
        return $errors
    return $totalErrors
};

declare function xmlconv:qc24100b($reportedData as element(FGasesReporting), $countryDefinition as element()*,
       $gases as element(Gas)* , $transaction1 as xs:string, $transaction2 as xs:string, $transaction3 as xs:string, $transaction4 as xs:string, $atransaction as xs:string, $err_msg as xs:string, $qcCode as xs:string )
as element(div)*
{
    let $transactionName1 := concat("tr_", $transaction1)
    let $transactionName2 := concat("tr_", $transaction2)
    let $transactionName3 := concat("tr_", $transaction3)
    let $transactionName4 := concat("tr_", $transaction4)
    let $totalErrors :=
        for $gas in $gases
        let $gasCode := $gas/GasCode
        let $gasName := cutil:getGasNameByGasCode($reportedData, $gasCode)
        let $countrySpecificData := $gas/*[local-name()=$transaction1]/CountrySpecific
        let $errors :=
            if ( not(not($countrySpecificData/Country/text()[normalize-space(.) != '']) and $countrySpecificData/Country/*)) then
                ()
            else
                for $country in $countrySpecificData/Country
                let $countryId := $country/CountryId/text()
                let $countryName := cutil:getTransactionCountryName($countryDefinition, $countryId)
                let $errorText := xmlconv:getQC24100bErrorMessage($countryName, $gasName, $err_msg)
                let $valA := cutil:getCountrySpecificAmountForTransaction($gas, $atransaction, $countryId)
                let $val1 := cutil:getCountrySpecificAmountForTransaction($gas, $transactionName1, $countryId)
                let $val2 := cutil:getCountrySpecificAmountForTransaction($gas, $transactionName2, $countryId)
                let $val3 := cutil:getCountrySpecificAmountForTransaction($gas, $transactionName3, $countryId)
                let $val4 := cutil:getCountrySpecificAmountForTransaction($gas, $transactionName4, $countryId)
                where (($val1 + $val2 + $val3 + $val4) > $valA )
                return uiutil:buildRuleResult($qcCode, $transaction1, $errorText, $xmlconv:BLOCKER, true(), (), "")
        return $errors
    return $totalErrors
};

declare function xmlconv:qc24100_3I($reportedData as element(FGasesReporting), $countryDefinition as element()*,
       $gases as element(Gas)*) as element(div)*
{
    let $err := "The partial amounts of virgin HFC reported for export for uses exepmted under the Montreal protocol in section 3 must not exceed the total reported in section 3A for [country] ([gas]). Please revise your data."
    let $qcCode := "24100"
    let $result := xmlconv:qc24100($reportedData, $countryDefinition, $gases, "03I", "tr_03A", $err, $qcCode)
    return $result
};

declare function xmlconv:qc24104($reportedData as element(FGasesReporting), $countryDefinition as element()*,
       $gases as element(Gas)*) as element(div)*
{
    let $err := "The partial amounts of HFCs in used, recycled or reclaimed hydrofluorocarbons in section 3 must not exceed the total reported in section 3A for [country] ([gas]). Please revise your data."
    let $qcCode := "24104"
    let $result := xmlconv:qc24100($reportedData, $countryDefinition, $gases, "03G", "tr_03A", $err, $qcCode)
    return $result
};

declare function xmlconv:qc24105($reportedData as element(FGasesReporting), $countryDefinition as element()*,
       $gases as element(Gas)*) as element(div)*
{
    let $err := "The partial amounts of virgin hydrofluorocarbons exported for feedstock use in  section 3 must not exceed the total reported in section 3A for [country] ([gas]). Please revise your data."
    let $qcCode := "2463"
    let $result := xmlconv:qc24100($reportedData, $countryDefinition, $gases, "03H", "tr_03A", $err, $qcCode)
    return $result
};

declare function xmlconv:qc24106_2A($reportedData as element(FGasesReporting), $countryDefinition as element()*,
       $gases as element(Gas)*) as element(div)*
{
    let $err := "2A_pp indicates the amount of HFCs per country imported in pre-blended polyols as a subset of overall imports per country and thus can not exceed overall imports for [country] ([gas]). Please correct your values and take care that all values have to be reported country specific."
    let $qcCode := "24106"
    let $result := xmlconv:qc24100b($reportedData, $countryDefinition, $gases, "02A_pp", "02C", "02E", "","tr_02A", $err, $qcCode)
    return $result
};

declare function xmlconv:qc24106_3A($reportedData as element(FGasesReporting), $countryDefinition as element()*,
       $gases as element(Gas)*) as element(div)*
{
    let $err := "The partial amounts of HFCs in pre-blended polyols in section 3 must not exceed the total reported in section 3A for [country] ([gas]). Please revise your data."
    let $qcCode := "24105"
    let $result := xmlconv:qc24100b($reportedData, $countryDefinition, $gases, "03A_pp", "03G", "03H", "03I", "tr_03A", $err, $qcCode)
    return $result
};

declare function xmlconv:qc24107($reportedData as element(FGasesReporting), $countryDefinition as element()*,
       $gases as element(Gas)*) as element(div)*
{
    let $err := "2C indicates the amount of used, recycled or reclaimed hydrofluorocarbons imported per country  as a subset of overall imports per country and thus can not exceed overall imports per country. Please correct your values and take care that all values have to be reported country specific. ([country]) ([gas])"
    let $qcCode := "24107"
    let $result := xmlconv:qc24100($reportedData, $countryDefinition, $gases, "02C", "tr_02A", $err, $qcCode)
    return $result
};

declare function xmlconv:qc24108($reportedData as element(FGasesReporting), $countryDefinition as element()*,
       $gases as element(Gas)*) as element(div)*
{
    let $err := "2D indicates the amount of virgin hydrofluorocarbons imported for feedstock use a subset of overall imports per country and thus can not exceed overall imports per country. Please correct your values and take care that all values have to be reported country specific.([country]) ([gas])"
    let $qcCode := "24108"
    let $result := xmlconv:qc24100($reportedData, $countryDefinition, $gases, "02D", "tr_02A", $err, $qcCode)
    return $result
};

declare function xmlconv:qc24110($reportedData as element(FGasesReporting), $countryDefinition as element()*,
       $gases as element(Gas)*) as element(div)*
{
    let $err := "2E indicates the amount  of virgin hydrofluorocarbons imported for uses exempted under the Montreal Protocol as a subset of overall imports per country and thus can not exceed overall imports per country. Please correct your values and take care that all values have to be reported country specific.([country])([gas])"
    let $qcCode := "24110"
    let $result := xmlconv:qc24100($reportedData, $countryDefinition, $gases, "02E", "tr_02A", $err, $qcCode)
    return $result
};

declare function xmlconv:qc2997($report as element(FGasesReporting))
as element(div)*
{    
    let $isAuth := not(empty($report/GeneralReportData/Activities[auth = 'true']))  
    return
        if (not($isAuth)) then
            ()
        else             
            let $val9A := cutil:numberIfEmpty($report/F4_S9_IssuedAuthQuata/tr_09A/SumOfPartnerAmounts, 0)
            let $val9A_add := cutil:numberIfEmpty($report/F4_S9_IssuedAuthQuata/tr_09A_add/SumOfPartnerAmounts, 0)
            let $val9A_imp := cutil:numberIfEmpty($report/F4_S9_IssuedAuthQuata/tr_09A_imp/SumOfPartnerAmounts, 0)
            return                
                if($val9A = 0 and $val9A_add = 0 and $val9A_imp = 0) then 
                    let $err_text := "You selected 'Provider of authorisations to other companies' in the activity selection. Please report on authorisations that were given out in section 9A, 9A_add or 9A_imp or unselect the activity."
                    return uiutil:buildRuleResult("2997", "tr_09A", $err_text, $xmlconv:BLOCKER, true(), (), "")
                else
                    ()
};

declare function xmlconv:qc21302($report as element(FGasesReporting))
as element(div)*
{        
    if(not(fgases:is-Eq-I-RACHP-HFC($report))) then
        ()
    else             
        let $val13A := cutil:numberIfEmpty($report/F9_S13/AuthBalance/Amount, 0)
        let $val13D := cutil:numberIfEmpty($report/F9_S13/Totals/tr_13D/Amount, 0)
        return                
            if ($val13D > $val13A) then
                let $err_text := "Authorisations available in the HFC registry (13A) do not cover the demand for authorisations (13D; determined from your data in 11A-F and 12A). Please check your data in 11A-11F and/or 12A to avoid errors. Note that the European Commission (DG CLIMA) will assess your company’s quota/authorisation compliance in co-operation with your Member State’s competent authorities. Failure to comply may result in penalties according to national law of the Member State concerned."
                return uiutil:buildRuleResult("21302", "tr_13A", $err_text, $xmlconv:WARNING, true(), (), "")
            else
                ()
};


declare function xmlconv:qc2411-error-text($gas as element(Gas)) as xs:string
{
    let $msgTemplate := "The values reported for equipment imports (11Q) and bulk imports (2A) of [gas] are very close to each other. Please note that 2A should only contain imports in bulk and not those F-gases that are contained in imported equipment. Your report may be followed up to avoid any issues of double counting."
    return replace($msgTemplate, "\[gas\]", string($gas/Name))
};

declare function xmlconv:qc2015($report as element(FGasesReporting))
as element(div)?
{
    if (empty($report/attachedCompanyData/nerStatus)) then
        ()
    else
        let $isNer := not(empty($report/attachedCompanyData[nerStatus = 'true']))
        let $isAuth := not(empty($report/GeneralReportData/Activities[auth = 'true']))
        let $isAuthNer := $isAuth and not(empty($report/GeneralReportData/Activities[auth-NER = 'true']))
        return
            if ($isNer) then
                if ($isAuth and not($isAuthNer)) then
                    let $errorText := 'According to the HFC Registry, your company received its HFC quota through a declaration for the New Entrants Reserve (NER). Please select the corresponding option just below the &quot;Authorisations provider&quot; section of the Year &amp; Activities page.'
                    return uiutil:buildRuleResult("2015", "auth-NER", $errorText, $xmlconv:BLOCKER, true(), (), "")
                else
                    ()
            else
                if ($isAuthNer) then
                    let $errorText := 'According to the HFC Registry, your company did not receive its HFC quota through a declaration for the New Entrants Reserve (NER). Please unselect the corresponding option just below the &quot;Authorisations provider&quot; section of the Year &amp; Activities page.'
                    return uiutil:buildRuleResult("2015", "auth-NER", $errorText, $xmlconv:BLOCKER, true(), (), "")
                else
                    ()
};

declare function xmlconv:qc2055($report as element(FGasesReporting))
as element(div)*
{
    for $transaction in xmlconv:_get-qc2055-transactions()
    return xmlconv:_qc2055($report, $transaction)
};

declare function xmlconv:_get-qc2055-transactions()
as element(transaction)*
{
    let $transactions :=
        <transactions>
            <transaction>
                <id>tr_04A</id>
                <label>04A</label>
                <code>4A</code>
                <stockCode>4F</stockCode>
            </transaction>
            <transaction>
                <id>tr_04B</id>
                <label>04B</label>
                <code>4B</code>
                <stockCode>4G</stockCode>
            </transaction>
            <transaction>
                <id>tr_04C</id>
                <label>04C</label>
                <code>4C</code>
                <stockCode>4H</stockCode>
            </transaction>
        </transactions>
    return $transactions/transaction
};

declare function xmlconv:_qc2055($report as element(FGasesReporting), $transaction as element(transaction))
as element(div)*
{
    if (empty($report/F1_S1_4_ProdImpExp)) then
        ()
    else
        let $isP := cutil:is-activity-selected($report/GeneralReportData/Activities/P)
        let $isI := cutil:is-activity-selected($report/GeneralReportData/Activities/I)
        let $isEq_I := cutil:is-activity-selected($report/GeneralReportData/Activities/Eq-I)
        let $isE := cutil:is-activity-selected($report/GeneralReportData/Activities/E)
        let $transactionId := string($transaction/id)
        let $stockTransactionCode := string($transaction/stockCode)
        let $gasAmounts := fgases:get-gas-amounts($report/F1_S1_4_ProdImpExp, $transactionId)
       
        return
            if ($isI or $isP) then
                for $gasAmount in $gasAmounts
                let $gasId := fgases:get-gas-id-of-gas-amount($gasAmount)
                let $stock := fgases:get-gas-stock-by-transaction($report, $gasId, $stockTransactionCode)
                let $amount := fgases:get-amount-of-gas-amount($gasAmount)
                return
                    if (empty($stock)) then

                        ()
                    else                        
                        let $stockAmount := xs:decimal($stock/amount)
                        return
                            if ((( cutil:getZeroIfNotNumber(string($amount)) < $stockAmount - 0.5) or (($amount=0) or (empty($amount)))) and (fn:not(fgases:has-comment-of-gas-amount($gasAmount)))) then
                                let $errorMsg := xmlconv:_compose-qc2055-error-message($report, $transaction, $stock, $xmlconv:BLOCKER)
                                return uiutil:buildRuleResult("2055", string($transaction/label), $errorMsg,  $xmlconv:BLOCKER, true(), (), "")
                               
                           
                            else if ((( cutil:getZeroIfNotNumber(string($amount)) < $stockAmount - 0.5) or (($amount=0) or (empty($amount)))) and not(fn:not(fgases:has-comment-of-gas-amount($gasAmount)))) then
                                    
                                let $errorMsg := xmlconv:_compose-qc2055-error-message($report, $transaction, $stock, $xmlconv:WARNING)
                                return uiutil:buildRuleResult("2055", string($transaction/label), $errorMsg,  $xmlconv:WARNING, true(), (), "")   
                            
                            else ()

                               
            else ()
};

declare function xmlconv:_compose-qc2055-error-message(
        $report as element(FGasesReporting),
        $transaction as element(transaction),
        $stock as element(stock),
        $errorLevel as xs:string
)
as xs:string
{
    let $msgTemplate :=
        if ($errorLevel = $xmlconv:BLOCKER) then
            'Stocks reported for [gas] on 1 Jan [transaction_year] (field [field_code]) are significantly below the corresponding stocks reported on 31 Dec of the previous year ([stock_value]; refer to [stock_field_code] in report on [previous_year]). Please revise your data or provide an explanation in section [field_code]. You may need to select "Importer" in the activity selection in order to access section 4.'
        else
            "Stocks reported for [gas] on 1 Jan [transaction_year] (field [field_code]) are significantly below the corresponding stocks reported on 31 Dec of the previous year ([stock_value]; refer to [stock_field_code] in report on [previous_year]). The comment provided will be considered during quality control."
    let $gasName := string(fgases:get-reported-gas-by-id($report, string($stock/gasId))/Name)
    let $transactionYear := fgases:get-transaction-year($report)
    let $previousYear := $transactionYear - 1
    let $msg1 := replace($msgTemplate, "\[gas\]", $gasName)
    let $msg2 := replace($msg1, "\[transaction_year\]", string($transactionYear))
    let $msg1 := replace($msg2, "\[previous_year\]", string($previousYear))
    let $msg2 := replace($msg1, "\[stock_value\]", string($stock/amount))
    let $msg1 := replace($msg2, "\[field_code\]", string($transaction/code))
    return replace($msg1, "\[stock_field_code\]", string($transaction/stockCode))
};

declare function xmlconv:_compose-qc2055-error-message2(
        $report as element(FGasesReporting),
        $transaction as element(transaction),
        $gasCode as xs:string,
        $errorLevel as xs:string
)
as xs:string
{
    let $msgTemplate :=
        if ($errorLevel = $xmlconv:BLOCKER) then
            'Stocks reported for [gas] on 1 Jan [transaction_year] (field [field_code]) are significantly below the corresponding stocks reported on 31 Dec of the previous year (none refer to [stock_field_code] in report on [previous_year]). Please revise your data or provide an explanation in section [field_code]. You may need to select "Importer" in the activity selection in order to access section 4.'
        else
            "Stocks reported for [gas] on 1 Jan [transaction_year] (field [field_code]) are significantly below the corresponding stocks reported on 31 Dec of the previous year (none refer to [stock_field_code] in report on [previous_year]). The comment provided will be considered during quality control."
   (: let $gasName := string(fgases:get-reported-gas-by-id($report, string($stock/gasId))/Name):)
   let $gasName := cutil:getGasNameByGasCode($report, $gasCode)
    let $transactionYear := fgases:get-transaction-year($report)
    let $previousYear := $transactionYear - 1
    let $msg1 := replace($msgTemplate, "\[gas\]", $gasName)
    let $msg2 := replace($msg1, "\[transaction_year\]", string($transactionYear))
    let $msg1 := replace($msg2, "\[previous_year\]", string($previousYear))
   (: let $msg2 := replace($msg1, "\[stock_value\]", string($stock/amount)):)
    let $msg2 := replace($msg1, "\[field_code\]", string($transaction/code))
    return replace($msg2, "\[stock_field_code\]", string($transaction/stockCode))
};

declare function xmlconv:qc2056($report as element(FGasesReporting))
as element(div)*
{
    let $stockTransactionCodes := ('4F', '4G', '4H', '8F')
    let $stocks := $report/attachedCompanyData/stocks/stock[transactionCode = $stockTransactionCodes]
    return
        for $stock in $stocks
        let $gas := fgases:get-reported-gas-by-id($report, string($stock/gasId))
        return
            if (empty($gas)) then
                let $errorMsg := xmlconv:_compose-qc2056-error-message($report, $stock)
                return uiutil:buildRuleResult("2056", "Gas selection", $errorMsg, $xmlconv:WARNING, true(), (), "")
            else
                ()
};
(: 1C_a should be <= 1A :)
declare function xmlconv:qc20101($report as element(FGasesReporting))
as element(div)*
{
    let $err_text := "The production for feedstock purpose (1A_fs) can not be greater than total production available for sale or feedstock use (1E)"
    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
        let $tr01A_fs_amount := cutil:numberIfEmpty($gas/tr_01A_fs/totalAmountForRow, 0)
        let $tr01E_amount := cutil:numberIfEmpty($gas/tr_01E/Amount, 0)
        let $ok := if (
            $tr01A_fs_amount castable as xs:double
                    and
                    $tr01E_amount castable as xs:double)
        then
            xs:double($tr01A_fs_amount) <= xs:double($tr01E_amount)
        else
            false()
        where not($ok)
        return data($report/ReportedGases[GasId = $gas/GasCode]/Name)
    return uiutil:buildRuleResult("20101", "01A_fs", $err_text,
            $xmlconv:BLOCKER, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};

declare function xmlconv:qc21200($report as element(FGasesReporting))
as element(div)*
{
    let $err_text := "The amount reported in (12B)
    should be equal with amount reported in (11G).
    Please revise your data."

    let $err_flag :=
        for $elem in $report/F8_S12/Gas
        let $tr_12B_amount := cutil:numberIfEmpty(data($elem/Totals/tr_12B), 0)
        let $tr_11G_amount := cutil:numberIfEmpty(
                data($report/F7_s11EquImportTable/Gas[GasCode = $elem/GasCode]/tr_11G/Amount),
                0)
        let $ok := if (
            $tr_12B_amount castable as xs:double
                    and
                    $tr_11G_amount castable as xs:double)
        then
            xs:double($tr_12B_amount) = xs:double($tr_11G_amount)
        else
            false()
        return
            if($ok)
            then ()
            else data($report/ReportedGases[GasId = $elem/GasCode]/Name)

    return uiutil:buildRuleResult("21200", "12B", $err_text,
            $xmlconv:BLOCKER, count($err_flag)>0,
            $err_flag, "Invalid gases are: "
    )
};

declare function xmlconv:qc21201($report as element(FGasesReporting))
as element(div)*
{
    let $errorTextTemplate := 
        "Reported amounts in re-imports in section 12 exceed the amounts placed on the market in imported refrigeration, air conditioning and heatpump equipment or metered dose inhalers (reported in section 11_A-F and 11_J1; see total in 12Ca) for [gas]. This is not plausible. Please revise your data."

    for $elem in $report/F8_S12/Gas
    
    let $tr_12C_raw := normalize-space($elem/Totals/tr_12C)
    let $tr_12C_amount := 
        if ($tr_12C_raw != "") 
        then xs:decimal($tr_12C_raw) 
        else ()
      where exists($tr_12C_amount) and $tr_12C_amount < 0
        let $gas_name := data($report/ReportedGases[GasId = string($elem/GasCode)]/Name)
        let $err_text := replace($errorTextTemplate, "\[gas\]", $gas_name)
        return uiutil:buildRuleResult("21201", "12C", $err_text, $xmlconv:BLOCKER, true(), (), "")
};

declare function xmlconv:qc21213($report as element(FGasesReporting))
as element(div)*
{
    let $errorTextTemplate := "Reported amounts of re-imports in 12A or 12aA exceed the amounts placed on the market in imported refrigeration, air conditioning and heatpump equipment (reported in section 11_A-F; see total in 12bA) for [gas]. This is not plausible. Please revise your data."

    for $elem in $report/F8_S12/Gas
    let $tr_12cA_amount := cutil:numberIfEmpty(data($elem/Totals/tr_12cA), 0)
    where $tr_12cA_amount < 0            
    let $err_text := replace($errorTextTemplate, "\[gas\]", data($report/ReportedGases[GasId = $elem/GasCode]/Name))
        return
            uiutil:buildRuleResult("21213", "12cA", $err_text, $xmlconv:BLOCKER, true(), (), "")
};

declare function xmlconv:qc21214($report as element(FGasesReporting))
as element(div)*
{
    let $errorTextTemplate := "Reported amounts of re-imports in 12B or 12aB exceed the amounts placed on the market in imported metered dose inhalers (reported in section 11_J1; see total in 12bB) for [gas]. This is not plausible. Please revise your data."

    for $elem in $report/F8_S12/Gas
    let $tr_12cB_amount := cutil:numberIfEmpty(data($elem/Totals/tr_12cB), 0)
    where $tr_12cB_amount < 0            
    let $err_text := replace($errorTextTemplate, "\[gas\]", data($report/ReportedGases[GasId = $elem/GasCode]/Name))
        return
            uiutil:buildRuleResult("21214", "12cB", $err_text, $xmlconv:BLOCKER, true(), (), "")
};

declare function xmlconv:qc21303($report as element(FGasesReporting))
as element(div)*
{
    let $err_text := "Your data indicates that you placed on the market more than 1000t of CO2 equivalents of HFCs irecharged equipment as referred to in Article 19 (3) of Regulation 2024/573. To proceed, please revisit section 13 and check the tickbox in the bottom to acknowledge your obligation to have your report verified by an independent auditor (verification to be submitted by 30 April in the separate BDR subcollection)."

    let $tr_13Bb_amount := cutil:numberIfEmpty(data($report/F9_S13/Totals/tr_13Bb/Amount), 0)

    return
        let $condition :=
            if($tr_13Bb_amount >= 1000 ) then
                true()
            else
                false()
        return
            if($condition and exists($report/F9_S13/Verified[text() != 'true'])) then
                uiutil:buildRuleResult("21303", "13Bb", $err_text, $xmlconv:BLOCKER, true(), (), "")
            else
                ()

};
declare function xmlconv:qc21301($report as element(FGasesReporting))
as element(div)*
{
    let $err_text := "The amount calculated in (13C)
    should be equal with amount reported in (12A).
    Please revise your data."
    let $blendDoc := doc($fgases:gas-list)
    let $tr_13C_amount := cutil:numberIfEmpty(data($report/F9_S13/Totals/tr_13C/Amount), 0)
    let $tr_12A_values :=
        for $gas in $report/F8_S12/Gas
        let $tr_12A := $gas/tr_12A/cutil:numberIfEmpty(SumOfPartnersAmount, 0)
        let $weightedGWP := cutil:calculate-weightedGWP($gas/GasCode, $blendDoc)
        return $tr_12A * sum($weightedGWP)

    let $tr_12A_total_amount := fn:round-half-to-even(sum($tr_12A_values))

    let $ok := if (
        $tr_13C_amount castable as xs:double
                and
                $tr_12A_total_amount castable as xs:double)
    then
        xs:double($tr_13C_amount) = xs:double($tr_12A_total_amount)
    else
        false()
    return uiutil:buildRuleResult("21301", "13C", $err_text,
            $xmlconv:BLOCKER, not($ok),
            ("13C = " || $tr_13C_amount || ", 12A = " || $tr_12A_total_amount),
            "Formula expected 13C=SUM(12A) "
    )
};
declare function xmlconv:qc21304($report as element(FGasesReporting))
as element(div)*
{
    let $err_text := "The amount calculated in (13D)
    should be equal with amount reported in (12C).
    Please revise your data."
    let $blendDoc := doc($fgases:gas-list)

    let $tr_13D_total_amount := cutil:numberIfEmpty(data($report/F9_S13/Totals/tr_13D/Amount), 0)
    let $tr_12C_values :=
        for $gas in $report/F8_S12/Gas
        let $tr_12C := $gas/Totals/cutil:numberIfEmpty(tr_12C, 0)
        let $weightedGWP := cutil:calculate-weightedGWP($gas/GasCode, $blendDoc)
        return $tr_12C * sum($weightedGWP)

    let $tr_12C_total_amount := fn:round-half-to-even(sum($tr_12C_values))
    let $ok := if (
        $tr_13D_total_amount castable as xs:double
                and
                $tr_12C_total_amount castable as xs:double)
    then
        xs:double($tr_13D_total_amount) = xs:double($tr_12C_total_amount)
    else
        false()    return uiutil:buildRuleResult("21304", "13D", $err_text,
            $xmlconv:BLOCKER, not($ok),
            ("13D = " || $tr_13D_total_amount || ", 12C = " || $tr_12C_total_amount),
            "Formula expected 13D=SUM(12C) "
    )
};
(:
let $transactionName := concat("tr_", $transactionCode)
    let $totalErrors :=
        for $gas in $gases
        let $gasCode := $gas/GasCode
        let $gasName := cutil:getGasNameByGasCode($reportedData, $gasCode)
        let $tradePartnerData := $gas/*[local-name()=$transactionName]/TradePartner
        let $errors :=
            for $tradePartner in $tradePartnerData
            let $tradePartnerName := cutil:getTransactionPartnerName($partnerDefinition, $tradePartner/TradePartnerID)
            let $errorText := xmlconv:getQC2409ErrorMessageTradePartner($tradePartnerName, $gasName, $sectionName)
            where not(cutil:transactionHasMandatoryCommentTradePartner($tradePartner))
            return uiutil:buildRuleResult("2409", $transactionCode, $errorText, $xmlconv:BLOCKER, true(), (), "")
        return $errors
    return $totalErrors
:)


declare function xmlconv:qc24114($report as element(FGasesReporting))
as element(div)*
{  
    let $err_text := "The total value for HFC-23 without prior capture can not be higher than the value reported for feedstock use."
    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $countryData := $gas/tr_01A_fs/CountrySpecific/Country

           
            for $country in $countryData
                    let $countryId := $country/CountryId
                    let $tr01A_fs_amount:= cutil:numberIfEmpty($country/Amount,0)
                    let $tr01A_fs1_amount := cutil:numberIfEmpty($gas/tr_01A_fs1/CountrySpecific/Country[CountryId=$countryId]/Amount, 0)
            
              let $ok := 
                if ($tr01A_fs_amount castable as xs:double and $tr01A_fs1_amount castable as xs:double)
                then
                    xs:double($tr01A_fs1_amount) <= xs:double($tr01A_fs_amount)
                else
                    false()
                return
                    if (not($ok))
                    then concat (data($report/ReportedGases[GasId = $gas/GasCode]/Name) ," for country ", data($countryId))
                    else ()
    return uiutil:buildRuleResult("24114", "1A_fs1", $err_text, $xmlconv:BLOCKER, count($err_flag)>0, $err_flag, "Invalid gases are: ")
   
};

declare function xmlconv:qc24115($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "The total value for amounts not captured (1Aa) can not be higher than total production (1A)."
    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $tr01Aa_amount := cutil:numberIfEmpty($gas/tr_01Aa/Amount, 0)
		    let $tr01A_amount := cutil:numberIfEmpty($gas/tr_01A/Amount, 0)
            let $ok := 
                if ($tr01Aa_amount castable as xs:double and $tr01A_amount castable as xs:double)
                then
                    xs:double($tr01Aa_amount) <= xs:double($tr01A_amount)
                else
                    false()
                return
                    if (not($ok))
                    then data($report/ReportedGases[GasId = $gas/GasCode]/Name)
                    else ()
    return uiutil:buildRuleResult("24115", "1Aa", $err_text, $xmlconv:BLOCKER, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};

declare function xmlconv:qc24112($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "The total amount of destroyed gases previously not captured (1A_a_own + 1A_a_other) can not be higher than the total amount of gases not captured (1Aa) (per gas)."
    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $tr01Aa_amount := cutil:numberIfEmpty($gas/tr_01Aa/Amount, 0)
		    let $tr01A_a_amount := cutil:numberIfEmpty($gas/tr_01A_a/Amount, 0)
            let $ok := 
                if ($tr01Aa_amount castable as xs:double and $tr01A_a_amount castable as xs:double)
                then
                    xs:double($tr01A_a_amount) <= xs:double($tr01Aa_amount)
                else
                    false()
                return
                    if (not($ok))
                    then data($report/ReportedGases[GasId = $gas/GasCode]/Name)
                    else ()
    return uiutil:buildRuleResult("24112", "1A_a", $err_text, $xmlconv:BLOCKER, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};

declare function xmlconv:qc24113($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "The amount produced and not captured (Transaction 1Aa) exceeds the amount thereof destroyed (Transaction 1A_a). Please note that this difference would be interpreted as an emission of that gas amount. If not intended, please revisit and revise your data reported in 1Aa and 1A_a."
    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $tr01Aa_amount := cutil:numberIfEmpty($gas/tr_01Aa/Amount, 0)
		    let $tr01A_a_amount := cutil:numberIfEmpty($gas/tr_01A_a/Amount, 0)
            let $ok := 
                if ($tr01Aa_amount castable as xs:double and $tr01A_a_amount castable as xs:double)
                then
                    xs:double($tr01Aa_amount) > xs:double($tr01A_a_amount)
                else
                    false()
                return
                    if ($ok)
                    then data($report/ReportedGases[GasId = $gas/GasCode]/Name)
                    else ()
    return uiutil:buildRuleResult("24113", "1Aa", $err_text, $xmlconv:WARNING, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};



declare function xmlconv:qc24118_2A($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "Please note that ‘EU intermediate storage’ is only eligible for HFCs which were moved by the reporting company from the EU market into a bonded warehouse under EU customs warehousing surveillance following an import for inward processing and which are intended to be released back to the EU market. (The release back to the EU market may be carried out by another undertaking.)
Your data will be checked for plausibility."
    

    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $tr02A_amount := for $country in $gas/tr_02A/CountrySpecific/Country
                                        return (if ($country/CountryId = "00")
                                            then cutil:numberIfEmpty($country/Amount, 0)
                                            else ()
                                            )
                                        

            let $ok := 
                if (not($tr02A_amount castable as xs:double) or ($tr02A_amount = 0))
                then
                    true()
                else
                    false()
                return
                    if (not($ok))
                    then data($report/ReportedGases[GasId = $gas/GasCode]/Name)
                    else ()
    

    return uiutil:buildRuleResult("24118", "2A", $err_text, $xmlconv:WARNING, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};



declare function xmlconv:qc24118_2App($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "Please note that ‘EU intermediate storage’ is only eligible for HFCs which were moved by the reporting company from the EU market into a bonded warehouse under EU customs warehousing surveillance following an import for inward processing and which are intended to be released back to the EU market. (The release back to the EU market may be carried out by another undertaking.)
Your data will be checked for plausibility."
    

    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
                                        
            let $tr02App_amount := for $country in $gas/tr_02App/CountrySpecific/Country
                                        return (if ($country/CountryId = "00")
                                            then cutil:numberIfEmpty($country/Amount, 0)
                                            else ()
                                        )
            
            let $ok := 
                if (not($tr02App_amount castable as xs:double) or ($tr02App_amount = 0))
                then
                    true()
                else
                    false()
                return
                    if (not($ok))
                    then data($report/ReportedGases[GasId = $gas/GasCode]/Name)
                    else ()
    

    return uiutil:buildRuleResult("24118", "2A_pp", $err_text, $xmlconv:WARNING, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};


declare function xmlconv:qc24118_2C($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "Please note that ‘EU intermediate storage’ is only eligible for HFCs which were moved by the reporting company from the EU market into a bonded warehouse under EU customs warehousing surveillance following an import for inward processing and which are intended to be released back to the EU market. (The release back to the EU market may be carried out by another undertaking.)
Your data will be checked for plausibility."
    

    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $tr02C_amount := for $country in $gas/tr_02C/CountrySpecific/Country
                                        return (if ($country/CountryId = "00")
                                            then cutil:numberIfEmpty($country/Amount, 0)
                                            else ()
                                        )

            let $ok := 
                if (not($tr02C_amount castable as xs:double) or ($tr02C_amount = 0))
                then
                    true()
                else
                    false()
                return
                    if (not($ok))
                    then data($report/ReportedGases[GasId = $gas/GasCode]/Name)
                    else ()
    

    return uiutil:buildRuleResult("24118", "2C", $err_text, $xmlconv:WARNING, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};


declare function xmlconv:qc24118_2D($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "Please note that ‘EU intermediate storage’ is only eligible for HFCs which were moved by the reporting company from the EU market into a bonded warehouse under EU customs warehousing surveillance following an import for inward processing and which are intended to be released back to the EU market. (The release back to the EU market may be carried out by another undertaking.)
Your data will be checked for plausibility."
    

    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $tr02D_amount := for $country in $gas/tr_02D/CountrySpecific/Country
                                        return (if ($country/CountryId = "00")
                                            then cutil:numberIfEmpty($country/Amount, 0)
                                            else ()
                                        )
            let $ok := 
                if (not($tr02D_amount castable as xs:double) or ($tr02D_amount = 0))
                then
                    true()
                else
                    false()
                return
                    if (not($ok))
                    then data($report/ReportedGases[GasId = $gas/GasCode]/Name)
                    else ()
    

    return uiutil:buildRuleResult("24118", "2D", $err_text, $xmlconv:WARNING, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};


declare function xmlconv:qc24118_2E($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "Please note that ‘EU intermediate storage’ is only eligible for HFCs which were moved by the reporting company from the EU market into a bonded warehouse under EU customs warehousing surveillance following an import for inward processing and which are intended to be released back to the EU market. (The release back to the EU market may be carried out by another undertaking.)
Your data will be checked for plausibility."
    

    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $tr02E_amount := for $country in $gas/tr_02E/CountrySpecific/Country
                                        return (if ($country/CountryId = "00")
                                            then cutil:numberIfEmpty($country/Amount, 0)
                                            else ()
                                        )

            let $ok := 
                if (not($tr02E_amount castable as xs:double) or ($tr02E_amount = 0))
                then
                    true()
                else
                    false()
                return
                    if (not($ok))
                    then data($report/ReportedGases[GasId = $gas/GasCode]/Name)
                    else ()
    

    return uiutil:buildRuleResult("24118", "2E", $err_text, $xmlconv:WARNING, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};




declare function xmlconv:qc24118_3A($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "Please note that ‘EU intermediate storage’ is only eligible for HFCs which were moved by the reporting company from the EU market into a bonded warehouse under EU customs warehousing surveillance following an import for inward processing and which are intended to be released back to the EU market. (The release back to the EU market may be carried out by another undertaking.)
Your data will be checked for plausibility."
    

    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $tr03A_amount := for $country in $gas/tr_03A/CountrySpecific/Country
                                        return (if ($country/CountryId = "00")
                                            then cutil:numberIfEmpty($country/Amount, 0)
                                            else ()
                                        )

            let $ok := 
                if (not($tr03A_amount castable as xs:double) or ($tr03A_amount = 0))
                then
                    true()
                else
                    false()
                return
                    if (not($ok))
                    then data($report/ReportedGases[GasId = $gas/GasCode]/Name)
                    else ()
    

    return uiutil:buildRuleResult("24118", "3A", $err_text, $xmlconv:WARNING, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};


declare function xmlconv:qc24118_3G($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "Please note that ‘EU intermediate storage’ is only eligible for HFCs which were moved by the reporting company from the EU market into a bonded warehouse under EU customs warehousing surveillance following an import for inward processing and which are intended to be released back to the EU market. (The release back to the EU market may be carried out by another undertaking.)
Your data will be checked for plausibility."
    

    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $tr03G_amount := for $country in $gas/tr_03G/CountrySpecific/Country
                                        return (if ($country/CountryId = "00")
                                            then cutil:numberIfEmpty($country/Amount, 0)
                                            else ()
                                        )
            let $ok := 
                if (not($tr03G_amount castable as xs:double) or ($tr03G_amount = 0))
                then
                    true()
                else
                    false()
                return
                    if (not($ok))
                    then data($report/ReportedGases[GasId = $gas/GasCode]/Name)
                    else ()
    

    return uiutil:buildRuleResult("24118", "3G", $err_text, $xmlconv:WARNING, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};


declare function xmlconv:qc24118_3H($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "Please note that ‘EU intermediate storage’ is only eligible for HFCs which were moved by the reporting company from the EU market into a bonded warehouse under EU customs warehousing surveillance following an import for inward processing and which are intended to be released back to the EU market. (The release back to the EU market may be carried out by another undertaking.)
Your data will be checked for plausibility."
    

    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $tr03H_amount := for $country in $gas/tr_03H/CountrySpecific/Country
                                        return (if ($country/CountryId = "00")
                                           then cutil:numberIfEmpty($country/Amount, 0)
                                            else ()
                                        )
            let $ok := 
                if (not($tr03H_amount castable as xs:double) or ($tr03H_amount = 0))
                then
                    true()
                else
                    false()
                return
                    if (not($ok))
                    then data($report/ReportedGases[GasId = $gas/GasCode]/Name)
                    else ()
    
    return uiutil:buildRuleResult("24118", "3H", $err_text, $xmlconv:WARNING, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};


declare function xmlconv:qc24118_3I($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "Please note that ‘EU intermediate storage’ is only eligible for HFCs which were moved by the reporting company from the EU market into a bonded warehouse under EU customs warehousing surveillance following an import for inward processing and which are intended to be released back to the EU market. (The release back to the EU market may be carried out by another undertaking.)
Your data will be checked for plausibility."
    

    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $tr03I_amount := for $country in $gas/tr_03I/CountrySpecific/Country
                                        return (if ($country/CountryId = "00")
                                            then cutil:numberIfEmpty($country/Amount, 0)
                                            else ()
                                        )

            let $ok := 
                if (not($tr03I_amount castable as xs:double) or ($tr03I_amount = 0))
                then
                    true()
                else
                    false()
                return
                    if (not($ok))
                    then data($report/ReportedGases[GasId = $gas/GasCode]/Name)
                    else ()
    

    return uiutil:buildRuleResult("24118", "3I", $err_text, $xmlconv:WARNING, count($err_flag)>0, $err_flag, "Invalid gases are: ")
};


declare function xmlconv:qc24119($report as element(FGasesReporting))
as element(div)*
{  
    let $err_text := "Please note that amounts of HFC-23 captured for feedstock (1A_fs2) and captured for desctruction (1D) must not exceed  the sum of your total production and 1st January stocks from own import/production captured and destroyed not placed on the market (1Ab + 4C and 8E). Please revise your data."
    let $err_flag :=
        for $gas in $report/F1_S1_4_ProdImpExp/Gas
            let $gasCode := $gas/GasCode
            let $gasCodeToCompare := $report/ReportedGases[GasId = $gasCode]/Code
            let $tr01DAmount := cutil:numberIfEmpty($gas/tr_01D/Amount, 0)
            let $tr01AbAmount := cutil:numberIfEmpty($gas/tr_01Ab/Amount, 0)
            let $tr04CAmount := cutil:numberIfEmpty($gas/tr_04C/Amount, 0)
            let $tr08EAmount := cutil:numberIfEmpty($report/F6_FUDest/Gas[GasCode=$gasCode]/tr_8E/Amount, 0)
            let $countryData := $gas/tr_01A_fs2/CountrySpecific/Country

            for $country in $countryData
                    let $countryId := $country/CountryId
                    let $tr01A_fs2_amount := cutil:numberIfEmpty($gas/tr_01A_fs2/CountrySpecific/Country[CountryId=$countryId]/Amount, 0)
            
              let $notok := 
                if ($gasCodeToCompare = 'HFC-23' and (($tr01A_fs2_amount+$tr01DAmount) > ($tr01AbAmount+$tr04CAmount) or ($tr01A_fs2_amount+$tr01DAmount) > ($tr01AbAmount+$tr08EAmount)))
                then
                    true()
                else
                    false()
                return
                    if ($notok)
                    then concat (data($report/ReportedGases[GasId = $gas/GasCode]/Name) ," for country ", data($countryId))
                    else ()
    return uiutil:buildRuleResult("24119", "1A_fs2", $err_text, $xmlconv:BLOCKER, count($err_flag)>0, $err_flag, "Invalid gases are: ")
   
};

declare function xmlconv:qc2500($report as element(FGasesReporting))
as element(div)*
{  
    let $err_text := 'Your draft report contains outdated data on quota/authorisations copied from the HFC registry. It appears you attempted submitting a report from a previous year without opening the report to check the data. Please restart the process and after loading your data from a previous submission, click on "Modify the Fluorinated Gases (F-gases) reporting questionnaire", then go to  the "Finish" Tab and click  "Reopen Form". Then check your data, close and save the report and then submit it to DG Clima. If you need any assistance, please contact the BDR helpdesk at  BDR.helpdesk@eea.europa.eu'
    let $transactionYear := fgases:get-transaction-year($report)
    let $nextYear := fn:string($transactionYear + 1)

    return
        let $tr09ADate := if (cutil:isMissingOrEmpty($report/F4_S9_IssuedAuthQuata/tr_09A_imp_date))
                            then $nextYear
                            else data($report/F4_S9_IssuedAuthQuata/tr_09A_imp_date)
        let $tr09GDate := if (cutil:isMissingOrEmpty($report/F4_S9_IssuedAuthQuata/tr_09G/Comment))
                            then $nextYear
                            else data($report/F4_S9_IssuedAuthQuata/tr_09G/Comment)
        let $tr13ADate := if (cutil:isMissingOrEmpty($report/F9_S13/tr_13A_date))
                            then $nextYear
                            else data($report/F9_S13/tr_13A_date)
        where
            ( not(fn:contains($tr09ADate, $nextYear)) or not(fn:contains($tr09GDate, $nextYear)) or not(fn:contains($tr13ADate, $nextYear)) )
        return uiutil:buildRuleResult("2500", "", $err_text, $xmlconv:BLOCKER, true(), (), "")
   
};

declare function xmlconv:qc2501($report as element(FGasesReporting))
as element(div)*
{  
    let $err_text := 'Please note that the report from the previous year you are trying to submit contains erroneous values due to an IT bug. It is thus not possible to use this old data for your submission. Please kindly restart the process by re-entering the data. We apologize for the inconvenience.  If you need any assistance, please contact the BDR helpdesk at  BDR.helpdesk@eea.europa.eu.'

    let $gases :=
        for $gas in $report/ReportedGases
        where $gas/IsBlend = 'true'
        return $gas

    return
    for $blendComponent in $gases/BlendComponents
        let $components := $blendComponent/Component
        let $totalPercentage:= sum($components/Percentage ! xs:decimal(.))
        where
            ( not($totalPercentage = 1) and not($totalPercentage = 100) )
        return uiutil:buildRuleResult("2501", "", $err_text, $xmlconv:BLOCKER, true(), (), "")
   
};


declare function xmlconv:qc24120($report as element(FGasesReporting)) as element(div)* {
    let $err_text := "An error has occured while loading company data from BDR. Please try again at a later point in time"
    

    let $err_flag :=
            let $xmlCompanyId := $report/GeneralReportData/Company/CompanyId
            let $xmlCompanyName := $report/GeneralReportData/Company/CompanyName                         

            return if (not(exists($xmlCompanyId) and exists($xmlCompanyName)))
                then true()
                else (cutil:isEmpty($xmlCompanyId) or cutil:isEmpty($xmlCompanyName))
    

    return uiutil:buildRuleResult("24120", "", $err_text, $xmlconv:BLOCKER, $err_flag, (), "")
};


declare function xmlconv:_compose-qc2056-error-message($report as element(FGasesReporting), $stock as element(stock))
as xs:string
{
    let $stockTransactionCode := string($stock/transactionCode)
    let $msgTemplate :=
        if ($stockTransactionCode = "8F") then
            "Stocks were reported as waiting for destruction for [gas] on 31 Dec [previous_year] ([stock_value]; refer to [stock_field_code] in report on [previous_year]), but [gas] is not included in this report. Please make sure that your gas selection for activities in [transaction_year] is complete before submitting your report."
        else
            "Stocks were reported for [gas] on 31 Dec [previous_year] ([stock_value]; refer to [stock_field_code] in report on [previous_year]), but [gas] is not included in this report. Please make sure that your gas selection for activities in [transaction_year] is complete before submitting your report."
    let $gasName := (fgases:get-gas-by-id-or-name($stock/gasId , $stock/gasName ) )/ Name
    let $transactionYear := fgases:get-transaction-year($report)
    let $previousYear := $transactionYear - 1
    let $msg1 := replace($msgTemplate, "\[gas\]", $gasName)
    let $msg2 := replace($msg1, "\[transaction_year\]", string($transactionYear))
    let $msg1 := replace($msg2, "\[previous_year\]", string($previousYear))
    let $msg2 := replace($msg1, "\[stock_value\]", string($stock/amount))
    return replace($msg2, "\[stock_field_code\]", $stockTransactionCode)
};

declare function xmlconv:Section9DocumentIsVerified($doc) as xs:boolean {
    let $verified := $doc/F4_S9_IssuedAuthQuata/Verified
    return if(not(empty($verified)) and cutil:verifyType($verified, "boolean")) then xs:boolean($verified) else false()
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
    let $doc := fn:doc($url)/FGasesReporting

    let $rStatus := xmlconv:rule_ReportStatus($doc)
    (: for NIL reports only return the status check :)
    let $nilReport := fgases:is-NIL-Report($doc)
    let $r24120 := xmlconv:qc24120($doc)
    let $resultDiv :=
        if(not($nilReport))
        then
            let $r2002 := xmlconv:qc2002($doc)
            let $r2003 := xmlconv:qc2003($doc)
            let $r2004 := xmlconv:qc2004($doc)
            let $r2005 := xmlconv:qc2005($doc)
            let $r2006 := xmlconv:qc2006($doc)
            (:let $r2007 := xmlconv:qc2007($doc):)
            let $r2008 := xmlconv:qc2008($doc)
            let $r2009 := xmlconv:qc2009($doc)
            let $r2010 := xmlconv:qc2010($doc)
            let $r2012 := xmlconv:qc2012($doc)
            let $r2013 := xmlconv:qc2013($doc)
            let $r2011 := xmlconv:qc2011($doc)
            let $r2017 :=
                for $tran in ('3C', '4D', '4E', '4I', '4J')
                return xmlconv:qc2017($doc, $tran)
            let $r2019 := xmlconv:qc2019($doc)
            let $r2020 := xmlconv:qc2020($doc)
            let $r2023 := xmlconv:qc2023($doc)
            let $r2024 := xmlconv:qc2024($doc)
            let $r2025 := xmlconv:qc2025($doc)
            let $r2026 := xmlconv:qc2026($doc)
            let $r2028 := xmlconv:qc2028($doc)
            let $r2029 := xmlconv:qc2029($doc)
            let $r2031 := xmlconv:qc2031($doc)
            let $r2039 := xmlconv:qc2039($doc)
            let $r2040 := xmlconv:qc2040($doc)
            let $r2041 := xmlconv:qc2041($doc)
            let $r2042 := xmlconv:qc2042($doc)
            let $r2043 := xmlconv:qc2043($doc)
            let $r2048 := xmlconv:qc2048($doc)

            let $r2050 :=  xmlconv:qc2050($doc, 'tr_11H4', '11H4') | xmlconv:qc2050($doc, 'tr_11L1', '11L1') | xmlconv:qc2050($doc, 'tr_11L3', '11L3') | xmlconv:qc2050($doc, 'tr_11P', '11P')  

            let $r2051 :=
                for $tran in ('tr_11A1a1', 'tr_11A1a2', 'tr_11A1a3', 'tr_11A1a4', 'tr_11A1b1', 'tr_11A1b2', 'tr_11A1b3', 'tr_11A1b4', 'tr_11A1c1', 'tr_11A1c2', 'tr_11A1c3', 'tr_11A1c4',
                              'tr_11A2a1i', 'tr_11A2a1ii', 'tr_11A2a1iii', 'tr_11A2a2i', 'tr_11A2a2ii', 'tr_11A2a2iii', 'tr_11A2a3i', 'tr_11A2a3ii', 'tr_11A2a3iii',
                              'tr_11A2b1i', 'tr_11A2b1ii', 'tr_11A2b1iii', 'tr_11A2b2i', 'tr_11A2b2ii', 'tr_11A2b2iii', 'tr_11A2b3i', 'tr_11A2b3ii', 'tr_11A2b3iii',
                              'tr_11B1', 'tr_11B2', 'tr_11B3', 'tr_11B4', 'tr_11B5',
                              'tr_11C1a', 'tr_11C1b', 'tr_11C2a', 'tr_11C2b',
                              'tr_11D',
                              'tr_11E1', 'tr_11E2', 'tr_11E3', 'tr_11E4',
                              'tr_11F1', 'tr_11F2', 'tr_11F3', 'tr_11F4', 'tr_11F5', 'tr_11F6', 'tr_11F7', 'tr_11F8', 'tr_11F9',
                              'tr_11G',
                              'tr_11H1', 'tr_11H2', 'tr_11H3', 'tr_11H4',
                              'tr_11I', 'tr_11J1', 'tr_11J2', 'tr_11K',
                              'tr_11L1', 'tr_11L2', 'tr_11L3',
                              'tr_11M1', 'tr_11M2', 'tr_11M3', 'tr_11M4', 'tr_11M5',
                              'tr_11N',
                              'tr_11O1', 'tr_11O2', 'tr_11O3', 'tr_11O4',
                              'tr_11P')
                return xmlconv:qc2051($doc, $tran)

            let $r2065 :=
                for $tran in ('tr_11A1a1', 'tr_11A1a2', 'tr_11A1a3', 'tr_11A1a4', 'tr_11A1b1', 'tr_11A1b2', 'tr_11A1b3', 'tr_11A1b4', 'tr_11A1c1', 'tr_11A1c2', 'tr_11A1c3', 'tr_11A1c4',
                              'tr_11A2a1i', 'tr_11A2a1ii', 'tr_11A2a1iii', 'tr_11A2a2i', 'tr_11A2a2ii', 'tr_11A2a2iii', 'tr_11A2a3i', 'tr_11A2a3ii', 'tr_11A2a3iii',
                              'tr_11A2b1i', 'tr_11A2b1ii', 'tr_11A2b1iii', 'tr_11A2b2i', 'tr_11A2b2ii', 'tr_11A2b2iii', 'tr_11A2b3i', 'tr_11A2b3ii', 'tr_11A2b3iii',
                              'tr_11B1', 'tr_11B2', 'tr_11B3', 'tr_11B4', 'tr_11B5',
                              'tr_11C1a', 'tr_11C1b', 'tr_11C2a', 'tr_11C2b',
                              'tr_11D',
                              'tr_11E1', 'tr_11E2', 'tr_11E3', 'tr_11E4',
                              'tr_11F1', 'tr_11F2', 'tr_11F3', 'tr_11F4', 'tr_11F5', 'tr_11F6', 'tr_11F7', 'tr_11F8', 'tr_11F9',
                              'tr_11G',
                              'tr_11H1', 'tr_11H2', 'tr_11H3', 'tr_11H4',
                              'tr_11I', 'tr_11J1', 'tr_11J2', 'tr_11K',
                              'tr_11L1', 'tr_11L2', 'tr_11L3',
                              'tr_11M1', 'tr_11M2', 'tr_11M3', 'tr_11M4', 'tr_11M5',
                              'tr_11N',
                              'tr_11O1', 'tr_11O2', 'tr_11O3', 'tr_11O4',
                              'tr_11P')
                return xmlconv:qc2065($doc, $tran)
            let $r2100 := xmlconv:qc2100($doc)
            let $r2102 := xmlconv:qc2102($doc)
            let $r2103 := xmlconv:qc2103($doc)
            let $r2104 := xmlconv:qc2104($doc)
            let $r2105 := xmlconv:qc2105($doc)
            let $r2106 := xmlconv:qc2106($doc)
            let $r2071 := xmlconv:qc2071($doc)
            let $r2072 := xmlconv:qc2072($doc)
            let $r2073 := xmlconv:qc2073($doc)
            let $r2078 := xmlconv:qc2078($doc)
            let $r2079 := xmlconv:qc2079($doc)
            let $r2087 := xmlconv:qc2087($doc)
            let $r2088 := xmlconv:qc2088($doc)
            let $r2089 := xmlconv:qc2089($doc)
            let $r2090 := xmlconv:qc2090($doc)
            let $r2091 := xmlconv:rule_09($doc, "6A", "5C", "2091")
            let $r2092 := xmlconv:rule_09($doc, "6B", "5A", "2092")
            let $r2093 := xmlconv:rule_09($doc, "6C", "5D", "2093")
            let $r2094 := xmlconv:rule_09($doc, "6I", "5F", "2094")
            let $r2095 := xmlconv:rule_09($doc, "6L", "5B", "2095")
            let $r2096 := xmlconv:rule_09($doc, "6M", "5E", "2096")
            let $r2098 := xmlconv:qc2098($doc)
            let $r2099 := xmlconv:qc2099($doc)
            
            let $r2301_11A1a1 := xmlconv:validateTransactionAmountRange($doc, "tr_11A1a1", 0.6, 2.5, "kg/piece", "2300")
            let $r2301_11A1a2 := xmlconv:validateTransactionAmountRange($doc, "tr_11A1a2", 0.6, 2.5, "kg/piece", "2300")
            let $r2301_11A1a3 := xmlconv:validateTransactionAmountRange($doc, "tr_11A1a3", 0.6,  2.5, "kg/piece", "2300")
            let $r2301_11A1a4 := xmlconv:validateTransactionAmountRange($doc, "tr_11A1a4", 0.6,  2.5, "kg/piece", "2300")
            let $r2301_11A1b1 := xmlconv:validateTransactionAmountRange($doc, "tr_11A1b1", 2.5, 12.0, "kg/piece", "2300")
            let $r2301_11A1b2 := xmlconv:validateTransactionAmountRange($doc, "tr_11A1b2", 2.5, 12.0, "kg/piece", "2300")
            let $r2301_11A1b3 := xmlconv:validateTransactionAmountRange($doc, "tr_11A1b3", 2.5, 12.0, "kg/piece", "2300")
            let $r2301_11A1b4 := xmlconv:validateTransactionAmountRange($doc, "tr_11A1b4", 2.5, 12.0, "kg/piece", "2300")
            let $r2301_11A1c1 := xmlconv:validateTransactionAmountRange($doc, "tr_11A1c1", 12.0, 500.0, "kg/piece", "2300")
            let $r2301_11A1c2 := xmlconv:validateTransactionAmountRange($doc, "tr_11A1c2", 12.0, 500.0, "kg/piece", "2300")
            let $r2301_11A1c3 := xmlconv:validateTransactionAmountRange($doc, "tr_11A1c3", 12.0, 500.0, "kg/piece", "2300")
            let $r2301_11A1c4 := xmlconv:validateTransactionAmountRange($doc, "tr_11A1c4", 12.0, 500.0, "kg/piece", "2300")
            
            let $r2301_11A2a1i := xmlconv:validateTransactionAmountRange($doc, "tr_11A2a1i", 0.6, 2.5, "kg/piece", "2300")
            let $r2301_11A2a1ii := xmlconv:validateTransactionAmountRange($doc, "tr_11A2a1ii", 0.6, 2.5, "kg/piece", "2300")
            let $r2301_11A2a1iii := xmlconv:validateTransactionAmountRange($doc, "tr_11A2a1iii", 0.6, 2.5, "kg/piece", "2300")
            let $r2301_11A2a2i := xmlconv:validateTransactionAmountRange($doc, "tr_11A2a2i", 0.6, 2.5, "kg/piece", "2300")
            let $r2301_11A2a2ii := xmlconv:validateTransactionAmountRange($doc, "tr_11A2a2ii", 0.6, 2.5, "kg/piece", "2300")
            let $r2301_11A2a2iii := xmlconv:validateTransactionAmountRange($doc, "tr_11A2a2iii", 0.6, 2.5, "kg/piece", "2300")
            let $r2301_11A2a3i := xmlconv:validateTransactionAmountRange($doc, "tr_11A2a3i", 0.6, 2.5, "kg/piece", "2300")
            let $r2301_11A2a3ii := xmlconv:validateTransactionAmountRange($doc, "tr_11A2a3ii", 0.6, 2.5, "kg/piece", "2300")
            let $r2301_11A2a3iii := xmlconv:validateTransactionAmountRange($doc, "tr_11A2a3iii", 0.6, 2.5, "kg/piece", "2300")
            
            let $r2301_11A2b1i := xmlconv:validateTransactionAmountRange($doc, "tr_11A2b1i", 2.5, 100.0, "kg/piece", "2300")
            let $r2301_11A2b1ii := xmlconv:validateTransactionAmountRange($doc, "tr_11A2b1ii", 2.5, 100.0, "kg/piece", "2300")
            let $r2301_11A2b1iii := xmlconv:validateTransactionAmountRange($doc, "tr_11A2b1iii", 2.5, 100.0, "kg/piece", "2300")
            let $r2301_11A2b2i := xmlconv:validateTransactionAmountRange($doc, "tr_11A2b2i", 2.5, 500.0, "kg/piece", "2300")
            let $r2301_11A2b2ii := xmlconv:validateTransactionAmountRange($doc, "tr_11A2b2ii", 2.5, 500.0, "kg/piece", "2300")
            let $r2301_11A2b2iii := xmlconv:validateTransactionAmountRange($doc, "tr_11A2b2iii", 2.5, 500.0, "kg/piece", "2300")
            let $r2301_11A2b3i := xmlconv:validateTransactionAmountRange($doc, "tr_11A2b3i", 2.5, 500.0, "kg/piece", "2300")
            let $r2301_11A2b3ii := xmlconv:validateTransactionAmountRange($doc, "tr_11A2b3ii", 2.5, 500.0, "kg/piece", "2300")
            let $r2301_11A2b3iii := xmlconv:validateTransactionAmountRange($doc, "tr_11A2b3iii", 2.5, 500.0, "kg/piece", "2300")
            
            let $r2301_11B1 := xmlconv:validateTransactionAmountRange($doc, "tr_11B1", 0.3, 1.0, "kg/piece", "2300")
            let $r2301_11B2 := xmlconv:validateTransactionAmountRange($doc, "tr_11B2", 0.3, 1000.0, "kg/piece", "2300")
            let $r2301_11B3 := xmlconv:validateTransactionAmountRange($doc, "tr_11B3", 0.3, 1000.0, "kg/piece", "2300")
            let $r2301_11B4 := xmlconv:validateTransactionAmountRange($doc, "tr_11B4", 0.3, 1000.0, "kg/piece", "2300")
            let $r2301_11B5 := xmlconv:validateTransactionAmountRange($doc, "tr_11B5", 0.3, 1000.0, "kg/piece", "2300")
            
            let $r2301_11C1a := xmlconv:validateTransactionAmountRange($doc, "tr_11C1a", 1.0, 3.0, "kg/piece", "2300")
            (: let $r2301_11C1b := xmlconv:validateTransactionAmountRange($doc, "tr_11C1b", 1.0, 3.0, "kg/piece", "2300") :)
            let $r2301_11C2a := xmlconv:validateTransactionAmountRange($doc, "tr_11C2a", 3.0, 1000.0, "kg/piece", "2300")
            (: let $r2301_11C2b := xmlconv:validateTransactionAmountRange($doc, "tr_11C2b", 3.0, 1000.0, "kg/piece", "2300") :)
            
            let $r2301_11D := xmlconv:validateTransactionAmountRange($doc, "tr_11D", 1.0, 1000.0, "kg/piece", "2300")
            
            let $r2301_11E1 := xmlconv:validateTransactionAmountRange($doc, "tr_11E1", 0.1, 13.0, "kg/piece", "2300")
            let $r2301_11E2 := xmlconv:validateTransactionAmountRange($doc, "tr_11E2", 0.025, 1.6, "kg/piece", "2300")
            let $r2301_11E3 := xmlconv:validateTransactionAmountRange($doc, "tr_11E3", 10.0, 50.0, "kg/piece", "2300")
            let $r2301_11E4 := xmlconv:validateTransactionAmountRange($doc, "tr_11E4", 0.03, 5.0, "kg/piece", "2300")
            
            let $r2301_11F1 := xmlconv:validateTransactionAmountRange($doc, "tr_11F1", 0.3, 1.5, "kg/piece", "2300")
            let $r2301_11F2 := xmlconv:validateTransactionAmountRange($doc, "tr_11F2", 1.0, 20.0, "kg/piece", "2300")
            let $r2301_11F3 := xmlconv:validateTransactionAmountRange($doc, "tr_11F3", 0.2, 1.5, "kg/piece", "2300")
            let $r2301_11F4 := xmlconv:validateTransactionAmountRange($doc, "tr_11F4", 0.03, 2, "kg/piece", "2300")
            let $r2301_11F5 := xmlconv:validateTransactionAmountRange($doc, "tr_11F5", 0.5, 2.5, "kg/piece", "2300")
            let $r2301_11F6 := xmlconv:validateTransactionAmountRange($doc, "tr_11F6", 1.0, 35.0, "kg/piece", "2300")
            let $r2301_11F7 := xmlconv:validateTransactionAmountRange($doc, "tr_11F7", 0.3, 50.0, "kg/piece", "2300")
            let $r2301_11F8 := xmlconv:validateTransactionAmountRange($doc, "tr_11F8", 2.0, 20.0, "kg/piece", "2300")
            let $r2301_11F9 := xmlconv:validateTransactionAmountRange($doc, "tr_11F9", 0.1, 50.0, "kg/piece", "2300")
            
            let $r2301_11H1 := xmlconv:validateTransactionAmountRange($doc, "tr_11H1", 10.0, 50.0, "kg/t", "2300")
            let $r2301_11H2 := xmlconv:validateTransactionAmountRange($doc, "tr_11H2", 1.0, 10.0, "kg/m3", "2300")
            let $r2301_11H3 := xmlconv:validateTransactionAmountRange($doc, "tr_11H3", 1.0, 10.0, "kg/piece", "2300")
            let $r2301_11H4 :=
                if($doc/F7_s11EquImportTable/TR_11H4_Unit="metrictonnes") then
                    xmlconv:validateTransactionAmountRange($doc, "tr_11H4", 10.0, 50.0, "kg/t", "2300")
                else if($doc/F7_s11EquImportTable/TR_11H4_Unit="cubicmetres") then
                    xmlconv:validateTransactionAmountRange($doc, "tr_11H4", 1.0, 10.0, "kg/m3", "2300")
                else if($doc/F7_s11EquImportTable/TR_11H4_Unit="pieces") then
                        xmlconv:validateTransactionAmountRange($doc, "tr_11H4", 1.0, 10.0, "kg/piece", "2300")
                    else
                        ()
            let $r2301_11I := xmlconv:validateTransactionAmountRange($doc, "tr_11I", 0.1, 50.0, "kg/piece", "2300")
            
            let $r2301_11J1 := xmlconv:validateTransactionAmountRange($doc, "tr_11J1", 0.007, 0.02, "kg/container", "2300")
            let $r2301_11J2 := xmlconv:validateTransactionAmountRange($doc, "tr_11J2", 0.007, 0.02, "kg/container", "2300")
            
            let $r2301_11K := xmlconv:validateTransactionAmountRange($doc, "tr_11K", 0.05, 0.5, "kg/container", "2300")
            
            let $r2301_11L1 := 
              if($doc/F7_s11EquImportTable/TR_11L1_Unit="metrictonnes") then
                xmlconv:validateTransactionAmountRange($doc, "tr_11L1", 10.0, 1000.0, "kg/t", "2300")
              else if($doc/F7_s11EquImportTable/TR_11L1_Unit="cubicmetres") then
                xmlconv:validateTransactionAmountRange($doc, "tr_11L1", 10.0, 1000.0, "kg/m3", "2300")
              else if($doc/F7_s11EquImportTable/TR_11L1_Unit="pieces") then
                xmlconv:validateTransactionAmountRange($doc, "tr_11L1", 0.01, 50.0, "kg/piece", "2300")
              else
                ()
            
            let $r2301_11L2 := xmlconv:validateTransactionAmountRange($doc, "tr_11L2", 0.01, 50.0, "kg/piece", "2300")
            let $r2301_11L3 := 
              if($doc/F7_s11EquImportTable/TR_11L3_Unit="metrictonnes") then
                xmlconv:validateTransactionAmountRange($doc, "tr_11L3", 10.0, 1000.0, "kg/t", "2300")
              else if($doc/F7_s11EquImportTable/TR_11L3_Unit="cubicmetres") then
                xmlconv:validateTransactionAmountRange($doc, "tr_11L3", 10.0, 100.0, "kg/m3", "2300")
              else if($doc/F7_s11EquImportTable/TR_11L3_Unit="pieces") then
                xmlconv:validateTransactionAmountRange($doc, "tr_11L3", 0.01, 50.0, "kg/piece", "2300")
            
            let $r2301_11M1 := xmlconv:validateTransactionAmountRange($doc, "tr_11M1", 0.01, 3.0, "kg/piece", "2300")
            let $r2301_11M2 := xmlconv:validateTransactionAmountRange($doc, "tr_11M2", 2.0, 6.0, "kg/piece", "2300")
            let $r2301_11M3 := xmlconv:validateTransactionAmountRange($doc, "tr_11M3", 5.0, 70.0, "kg/piece", "2300")
            let $r2301_11M4 := xmlconv:validateTransactionAmountRange($doc, "tr_11M4", 50.0, 1500.0, "kg/piece", "2300")
            let $r2301_11M5 := xmlconv:validateTransactionAmountRange($doc, "tr_11M5", 0.1, 1500.0, "kg/piece", "2300")
            
            let $r2301_11N := xmlconv:validateTransactionAmountRange($doc, "tr_11N", 0.5, 50.0, "kg/piece", "2300")
            
            let $r2301_11O1 := xmlconv:validateTransactionAmountRange($doc, "tr_11O1", 0.2, 1.0, "kg/piece", "2300")
            let $r2301_11O2 := xmlconv:validateTransactionAmountRange($doc, "tr_11O2", 3.0, 9.0, "kg/piece", "2300")
            let $r2301_11O3 := xmlconv:validateTransactionAmountRange($doc, "tr_11O3", 5.0, 18000.0, "kg/piece", "2300")
            let $r2301_11O4 := xmlconv:validateTransactionAmountRange($doc, "tr_11O4", 0.2, 5000.0, "kg/piece", "2300")
           
            
            let $r2301_11P :=
                if($doc/F7_s11EquImportTable/TR_11P_Unit="metrictonnes") then
                    xmlconv:validateTransactionAmountRange($doc, "tr_11P", 10.0, 1000.0, "kg/t", "2300")
                else if($doc/F7_s11EquImportTable/TR_11P_Unit="cubicmetres") then
                    xmlconv:validateTransactionAmountRange($doc, "tr_11P", 10.0, 100.0, "kg/m3", "2300")
                else if($doc/F7_s11EquImportTable/TR_11P_Unit="pieces") then
                        xmlconv:validateTransactionAmountRange($doc, "tr_11P", 0.01, 50.0, "kg/pieces", "2300")
                    else
                        ()
            let $r2044 := xmlconv:qc2044($doc)
            let $r24220 := xmlconv:qc24220($doc)
            let $r24221 := xmlconv:qc24221($doc)
            let $r2403 := xmlconv:qc2403($doc)
            let $r24031 := xmlconv:qc24031($doc)
            let $r2404 := xmlconv:qc2404($doc)
            let $r24041 := xmlconv:qc24041($doc)
            let $r24042 := xmlconv:qc24042($doc)
            let $r24043 := xmlconv:qc24043($doc)
            let $r2405 := xmlconv:qc2405($doc)           
            (:let $r2408 := xmlconv:qc2408($doc) :)
            let $r2409_02D := xmlconv:qc2409CountrySpecific($doc,$doc/F1_S1_4_ProdImpExp/tr_02A_Countries,"02D", $doc/F1_S1_4_ProdImpExp/Gas, "2D")
            (:let $r2409_03H := xmlconv:qc2409CountrySpecific($doc,$doc/F1_S1_4_ProdImpExp/tr_03A_Countries,"03H", $doc/F1_S1_4_ProdImpExp/Gas, "3H"):)
            let $r2409_05B := xmlconv:qc2409TradePartner($doc,$doc/F2_S5_exempted_HFCs/tr_05B_TradePartners/Partner,"05B", $doc/F2_S5_exempted_HFCs/Gas, "5B")
            let $r2409_07A := xmlconv:qc2409($doc, "07A", $doc/F6_FUDest/Gas, "7A")
            let $r2409_06L := xmlconv:qc2409($doc, "06L", $doc/F3A_S6A_IA_HFCs/Gas, "6L")
            let $r2410_02B := xmlconv:qc2410("02B", $doc/F1_S1_4_ProdImpExp)
            let $r2455 := xmlconv:qc2455($doc, $doc/F1_S1_4_ProdImpExp/Gas)
            let $r2456_8A1other := xmlconv:qc2456_8A1other($doc, $doc/F1_S1_4_ProdImpExp/Gas)
            let $r2456_8A2other := xmlconv:qc2456_8A2other($doc, $doc/F1_S1_4_ProdImpExp/Gas)
            let $r2456_8Ba1other := xmlconv:qc2456_8Ba1other($doc, $doc/F1_S1_4_ProdImpExp/Gas)
            let $r2456_8Ba2other := xmlconv:qc2456_8Ba2other($doc, $doc/F1_S1_4_ProdImpExp/Gas)
            let $r2456_8Bb1other := xmlconv:qc2456_8Bb1other($doc, $doc/F1_S1_4_ProdImpExp/Gas)
            let $r2456_8Bb2other := xmlconv:qc2456_8Bb2other($doc, $doc/F1_S1_4_ProdImpExp/Gas)
            let $r2456_8C1other := xmlconv:qc2456_8C1other($doc, $doc/F1_S1_4_ProdImpExp/Gas)
            let $r2456_8C2other := xmlconv:qc2456_8C2other($doc, $doc/F1_S1_4_ProdImpExp/Gas)
            let $r2457 := xmlconv:qc2457($doc)
            let $r2997 := xmlconv:qc2997($doc)
            let $r21302 := xmlconv:qc21302($doc)
            let $r24100 := xmlconv:qc24100_3I($doc,$doc/F1_S1_4_ProdImpExp/tr_03A_Countries,$doc/F1_S1_4_ProdImpExp/Gas)
            let $r24104 := xmlconv:qc24104($doc,$doc/F1_S1_4_ProdImpExp/tr_03A_Countries,$doc/F1_S1_4_ProdImpExp/Gas)
            let $r24105 := xmlconv:qc24105($doc,$doc/F1_S1_4_ProdImpExp/tr_03A_Countries,$doc/F1_S1_4_ProdImpExp/Gas)
            let $r24106_2A := xmlconv:qc24106_2A($doc,$doc/F1_S1_4_ProdImpExp/tr_03A_Countries,$doc/F1_S1_4_ProdImpExp/Gas)
            let $r24106_3A := xmlconv:qc24106_3A($doc,$doc/F1_S1_4_ProdImpExp/tr_03A_Countries,$doc/F1_S1_4_ProdImpExp/Gas)
            let $r24107 := xmlconv:qc24107($doc,$doc/F1_S1_4_ProdImpExp/tr_03A_Countries,$doc/F1_S1_4_ProdImpExp/Gas)
            let $r24108 := xmlconv:qc24108($doc,$doc/F1_S1_4_ProdImpExp/tr_03A_Countries,$doc/F1_S1_4_ProdImpExp/Gas)
            let $r24109 := xmlconv:qc24109($doc,$doc/F1_S1_4_ProdImpExp/tr_02A_Countries,$doc/F1_S1_4_ProdImpExp/Gas)
            let $r24110 := xmlconv:qc24110($doc,$doc/F1_S1_4_ProdImpExp/tr_03A_Countries,$doc/F1_S1_4_ProdImpExp/Gas)
            let $r24111 := xmlconv:qc24111($doc,$doc/F1_S1_4_ProdImpExp/tr_03A_Countries,$doc/F1_S1_4_ProdImpExp/Gas)
            let $r2411 := xmlconv:qc2411($doc)
            let $r2412 := xmlconv:qc2412($doc)
            let $r2015 := xmlconv:qc2015($doc)
            let $r2055 := xmlconv:qc2055($doc)
            let $r2056 := xmlconv:qc2056($doc)

            let $r24114 := xmlconv:qc24114($doc)
            let $r24115 := xmlconv:qc24115($doc)
            let $r24112 := xmlconv:qc24112($doc)
            let $r24113 := xmlconv:qc24113($doc)
            let $r24118_2A := xmlconv:qc24118_2A($doc)
            let $r24118_2App := xmlconv:qc24118_2App($doc)
            let $r24118_2C := xmlconv:qc24118_2C($doc)
            let $r24118_2D := xmlconv:qc24118_2D($doc)
            let $r24118_2E := xmlconv:qc24118_2E($doc)
            let $r24118_3A := xmlconv:qc24118_3A($doc)
            let $r24118_3G := xmlconv:qc24118_3G($doc)
            let $r24118_3H := xmlconv:qc24118_3H($doc)
            let $r24118_3I := xmlconv:qc24118_3I($doc)
            let $r24119 := xmlconv:qc24119($doc)
            
            let $r2500 := xmlconv:qc2500($doc)
            let $r2501 := xmlconv:qc2501($doc)

            let $r21213 := xmlconv:qc21213($doc)
            let $r21214 := xmlconv:qc21214($doc)
            let $r21303 := xmlconv:qc21303($doc)

            (: The following checks were disabled, it is not clear if these are needed :)
            let $disabled := ()
            let $r20601 := $disabled
            let $r20101 := $disabled
            let $r21200 := $disabled
            (: let $r21201 := $disabled :) 
            let $r21301 := $disabled
            let $r21304 := $disabled
            (:
            let $r20601 := xmlconv:qc20601($doc)
            let $r20101 := xmlconv:qc20101($doc)
            let $r21200 := xmlconv:qc21200($doc)
            let $r21201 := xmlconv:qc21201($doc)
            let $r21301 := xmlconv:qc21301($doc)
            let $r21304 := xmlconv:qc21304($doc)
:)
            let $r21201 := xmlconv:qc21201($doc)
            return
                <div class="errors">
                    {$rStatus}
                    {$r24120}
                    {$r2002}
                    {$r2003}
                    {$r2004}
                    {$r2005}
                    {$r2006} 
                    {$r2008}
                    {$r2009}
                    {$r2010}
                    {$r2011}
                    {$r2012}
                    {$r2013}
                    {$r2017} 
                    {$r2019} 
                    {$r2020}
                    {$r2023}
                    {$r2024}
                    {$r2025}
                    {$r2026}
                    {$r2028}
                    {$r2029}
                    {$r2031}
                    {$r2039}
                    {$r2040}
                    {$r2041}
                    {$r2042}
                    {$r2043}
                    {$r2044}
                    {$r24220}
                    {$r24221}
                    {$r2048}
                    {$r2050}
                    {$r2051}
                    {$r2065}
                    {$r2100}
                    {$r2102}
                    {$r2103}
                    {$r2104}
                    {$r2105}
                    {$r2106}
                    {$r2071}
                    {$r2072}
                    {$r2073}
                    {$r2078}
                    {$r2079}
                    {$r2087}
                    {$r2088}
                    {$r2089}
                    {$r2090}
                    {$r2091}
                    {$r2092}
                    {$r2093}
                    {$r2094}
                    {$r2095}
                    {$r2096}
                    {$r2098}
                    {$r2099}
                    {$r2301_11A1a1}
                    {$r2301_11A1a2}
                    {$r2301_11A1a3}
                    {$r2301_11A1a4}
                    {$r2301_11A1b1}
                    {$r2301_11A1b2}
                    {$r2301_11A1b3}
                    {$r2301_11A1b4}
                    {$r2301_11A1c1}
                    {$r2301_11A1c2}
                    {$r2301_11A1c3}
                    {$r2301_11A1c4}
                    {$r2301_11A2a1i}
                    {$r2301_11A2a1ii}
                    {$r2301_11A2a1iii}
                    {$r2301_11A2a2i}
                    {$r2301_11A2a2ii}
                    {$r2301_11A2a2iii}
                    {$r2301_11A2a3i}
                    {$r2301_11A2a3ii}
                    {$r2301_11A2a3iii}
                    {$r2301_11A2b1i}
                    {$r2301_11A2b1ii}
                    {$r2301_11A2b1iii}
                    {$r2301_11A2b2i}
                    {$r2301_11A2b2ii}
                    {$r2301_11A2b2iii}
                    {$r2301_11A2b3i}
                    {$r2301_11A2b3ii}
                    {$r2301_11A2b3iii}
                    {$r2301_11B1}
                    {$r2301_11B2}
                    {$r2301_11B3}
                    {$r2301_11B4}
                    {$r2301_11B5}
                    {$r2301_11C1a}
                    <!--{$r2301_11C1b}-->
                    {$r2301_11C2a}
                    <!--{$r2301_11C2b}-->
                    {$r2301_11D}
                    {$r2301_11E1}
                    {$r2301_11E2}
                    {$r2301_11E3}
                    {$r2301_11E4}
                    {$r2301_11F1}
                    {$r2301_11F2}
                    {$r2301_11F3}
                    {$r2301_11F4}
                    {$r2301_11F5}
                    {$r2301_11F6}
                    {$r2301_11F7}
                    {$r2301_11F8}
                    {$r2301_11F9}
                    {$r2301_11H1}
                    {$r2301_11H2}
                    {$r2301_11H3}
                    {$r2301_11H4}
                    {$r2301_11I}
                    
                    {$r2301_11J1}
                    {$r2301_11J2}
                    {$r2301_11K}
                    {$r2301_11L1}
                    {$r2301_11L2}
                    {$r2301_11L3}
                    {$r2301_11M1}
                    {$r2301_11M2}
                    {$r2301_11M3}
                    {$r2301_11M4}
                    {$r2301_11M5}
                    {$r2301_11N}
                    {$r2301_11O1}
                    {$r2301_11O2}
                    {$r2301_11O3}
                    {$r2301_11O4}
                    {$r2301_11P}
                    {$r2044}
                    {$r2403}
                    {$r24031}
                    {$r2404}
                    {$r24041}
                    {$r24042}
                    {$r24043}
                    {$r2405}
                    {$r2409_02D}
                    <!--{$r2409_03H}-->
                    {$r2409_05B}
                    {$r2409_07A}
                    {$r2409_06L} -
                    {$r2410_02B}
                    {$r2411}                    
                    {$r2412}
                    {$r2455}
                    {$r2456_8A1other}
                    {$r2456_8A2other}
                    {$r2456_8Ba1other}
                    {$r2456_8Ba2other}
                    {$r2456_8Bb1other}
                    {$r2456_8Bb2other}
                    {$r2456_8C1other}
                    {$r2456_8C2other}
                    {$r2457}
                    {$r24100}
                    {$r24104}
                    {$r24105}
                    {$r24106_2A}
                    {$r24106_3A}
                    {$r24107}
                    {$r24108}
                    {$r24109}
                    {$r24110}
                    {$r24111}
                    {$r2997}
                    {$r21302}
                    {$r2015}
                    {$r2055}
                    {$r2056}
                    {$r20101}
                    {$r21200}
                    {$r21201}
                    {$r21303}
                    {$r21301}
                    {$r21304}
                    {$r20601}
                    {$r24115}
                    {$r24112}
                    {$r24113}
                    {$r24114}
                    {$r24118_2A}
                    {$r24118_2App}
                    {$r24118_2C}
                    {$r24118_2D}
                    {$r24118_2E}
                    {$r24118_3A}
                    {$r24118_3G}
                    {$r24118_3H}
                    {$r24118_3I}
                    {$r24119}
                    {$r2500}
                    {$r2501}
                    {$r21213}
                    {$r21214}
                </div>
        else
            <div>
                {$rStatus}
                {$r24120}
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


