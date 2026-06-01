<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:fgas="http://eionet.europa.eu/dataflows/fgas"
				xmlns:functx="http://www.functx.com"
				version="2.0">
	<xsl:output method="xhtml" indent="yes"
				doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
				doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
				omit-xml-declaration="yes"/>

	<xsl:param name="envelopeurl" />
	<xsl:param name="filename" />
	<xsl:param name="envelopepath" />
	<xsl:param name="acceptable" />
	<xsl:param name="submissionDate" />

	<xsl:variable name="current-date" select="current-dateTime()"/>

	<xsl:variable name="labelsLanguage" select="FGasesReporting/@xml:lang"/>
	<xsl:variable name="xmlPath" select="'../xmlfile/'"/>
	<xsl:variable name="labelsUrl">
		<xsl:choose>
			<xsl:when test="doc-available(concat($xmlPath, 'fgases-labels-2025-', $labelsLanguage ,'.xml'))">
				<xsl:value-of select="concat($xmlPath, 'fgases-labels-2025-', $labelsLanguage ,'.xml')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($xmlPath, 'fgases-labels-en.xml')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="labels" select="document($labelsUrl)/labels"/>

	<xsl:variable name="verificationRequired"
		select="
			/FGasesReporting/F4_S9_IssuedAuthQuata/tr_09C/Amount &gt;= 1000
			or
			count(/FGasesReporting/F2_S5_exempted_HFCs/Gas/tr_05C/TradePartner[Amount &gt; 0]) &gt; 0
	"/>




	<xsl:template name="getLabel" >
		<xsl:param name="labelName"/>
		<xsl:param name="labelPath" select="''"/>

		<xsl:variable name="labelValue" select="$labels/descendant-or-self::*[local-name() = $labelName]"/>

		<xsl:choose>
			<xsl:when test="string-length($labelPath) &gt; 0">
				<xsl:variable name="labelValue2" select="$labels/descendant-or-self::*[local-name() = $labelPath]/descendant-or-self::*[local-name() = $labelName]"/>
				<xsl:value-of disable-output-escaping="yes" select="$labelValue2"/>
			</xsl:when>
			<xsl:when test="string-length($labelValue) &gt; 0">
				<xsl:choose>
					<xsl:when test="contains($labelValue,'{{reportingYear}}')">
						<xsl:value-of select="replace($labelValue,'\{\{reportingYear\}\}', string(../@year))"/>
					</xsl:when>

					<xsl:otherwise><xsl:value-of disable-output-escaping="yes" select="$labelValue"/> </xsl:otherwise>
				</xsl:choose>

			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of disable-output-escaping="yes" select="$labelName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getGas">
		<xsl:param name="elem"/>
		<!--<xsl:variable name="gasNameParts" select="tokenize($elem, '\s+')"></xsl:variable>-->
		<xsl:variable name="replaceComma" select="replace($elem,',',', ')"/>

		<xsl:choose>
			<xsl:when test="contains($replaceComma, 'propane')">
				<xsl:value-of select="replace($replaceComma,'propane',' propane')"/>
			</xsl:when>
			<xsl:when test="contains($replaceComma, 'butane')">
				<xsl:value-of select="replace($replaceComma,'butane',' butane')"/>
			</xsl:when>
			<xsl:when test="contains($replaceComma, 'pentane')">
				<xsl:value-of select="replace($replaceComma,'pentane',' pentane')"/>
			</xsl:when>
			<xsl:when test="contains($replaceComma, 'methane')">
				<xsl:value-of select="replace($replaceComma,'methane',' methane')"/>
			</xsl:when>
			<xsl:when test="contains($replaceComma, 'ethane')">
				<xsl:value-of select="replace($replaceComma,'ethane',' ethane')"/>
			</xsl:when>
			<xsl:when test="contains($replaceComma, 'butane')">
				<xsl:value-of select="replace($replaceComma,'butane',' butane')"/>
			</xsl:when>
			<xsl:when test="contains($replaceComma, 'propanol')">
				<xsl:value-of select="replace($replaceComma,'propanol',' propanol')"/>
			</xsl:when>
			<xsl:when test="contains($replaceComma, 'isopropylether')">
				<xsl:value-of select="replace(replace($replaceComma,'isopropylether',' isopropylether'), 'polymethyl',' polymethyl')"/>
			</xsl:when>

			<xsl:otherwise><xsl:value-of select="$replaceComma"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getValue">
		<xsl:param name="elem"/>
		<xsl:param name="elementType" select="''"/>
		<xsl:param name="colspan" select="0"/>
		<xsl:param name="isLink" select="false()"/>
		<xsl:param name="codelistElement" select="''"/>
		<xsl:variable name="elemValue">
			<xsl:choose>
				<!-- <xsl:when test="string-length($codelistName) &gt; 0">
                     <xsl:value-of select="$schema/xs:simpleType[@name = $elementType]//xs:enumeration[@value = $elem]/xs:annotation/xs:documentation"/>
                 </xsl:when>-->
				<xsl:when test="$elem/text()='yes'">Yes</xsl:when>
				<xsl:when test="$elem/text()='no'">No</xsl:when>
				<!-- detect disabled fields -->
				<xsl:otherwise><xsl:value-of select="$elem"/></xsl:otherwise>

			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string($elemValue) = 'true'">
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'yes'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="string($elemValue) = 'false'">
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'no'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="break">
					<xsl:with-param name="text" select="$elemValue"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="break">
		<xsl:param name="text" select="."/>
		<xsl:choose>

			<xsl:when test="contains($text, '&#10;')">
				<xsl:value-of select="substring-before($text, '&#10;')" />
				<br/>
				<xsl:call-template name="break">
					<xsl:with-param name="text" select="substring-after($text, '&#10;')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="functx:reverse-string" as="xs:string">
		<xsl:param name="arg" as="xs:string?"/>
		<xsl:sequence select="codepoints-to-string(reverse(string-to-codepoints($arg)))"/>
	</xsl:function>

	<xsl:function name="fgas:format-number-with-space">
		<xsl:param name="num"/>
		<xsl:value-of select="functx:reverse-string(replace(functx:reverse-string($num), '(\d{3})(\d{1,3})', '$1 $2'))"/>
	</xsl:function>

	<xsl:function name="fgas:format-number-with-space-multi">
		<xsl:param name="num"/>
		<xsl:variable name="formatted-value" select="fgas:format-number-with-space($num)"/>
		<!--<xsl:message>
			num: <xsl:value-of select="$num"/>
			format: <xsl:value-of select="$formatted-value"/>
		</xsl:message>-->
		<xsl:choose>
			<xsl:when test="$formatted-value != $num">
				<xsl:value-of select="fgas:format-number-with-space-multi($formatted-value)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$formatted-value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:function name="fgas:isHfcBased" as="xs:boolean">
		<xsl:param name="gasId" />
		<xsl:param name="rootElm" as="item()" />
		<xsl:value-of select="$gasId = '187' or not(empty($rootElm/ReportedGases[GasId = $gasId and GWP_AR4_HFC > 0])) or
							   not(empty($rootElm/ReportedGases[GasId = $gasId and GasGroupId = 7]))" />
	</xsl:function>

	<xsl:function name="fgas:isHfc23" as="xs:boolean">
		<xsl:param name="gasId" />
		<xsl:param name="rootElm" as="item()" />
		<xsl:value-of select="$gasId = '2'" />
	</xsl:function>
	
	<xsl:template name="loop">
		<xsl:param name="i"/>
		<xsl:param name="limit"/>
		<xsl:param name="var1"/>
		<xsl:param name="var2"/>	
		<xsl:if test="$i &lt;= $limit">
			<div>
				<xsl:value-of select="$var1"/>
			</div>
			<xsl:call-template name="loop">
				<xsl:with-param name="i" select="$i+1"/>
				<xsl:with-param name="limit" select="$limit"/>
				<xsl:with-param name="var1" select="$var1+$var2"/>
				<xsl:with-param name="var2" select="$var2"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	

	<xsl:template match="/">
		<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'Questionnaire-title'"/>
					</xsl:call-template>
				</title>
				<meta content="text/html; charset=utf-8"/>
				<style type="text/css">
					/*@media print{@page {size: landscape}}*/
					@page {
						size: A4;
						/*margin: 0;*/
						margin-right: 5em;
						margin-left: 5em;
					}

					@media print {
						h1 {
							width: 50em;
						}

						html, body {
							width: 210mm;
							height: 297mm;
						}

						@page {
							/*-webkit-transform: rotate(-90deg); -moz-transform:rotate(-90deg);
							filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=3) !important;*/

						}

						/*table {
							page: rotated
						}*/

						table {
							font-size: 6pt;
						}

						th {
							page-break-inside: avoid
						}

						td {
							page-break-inside: avoid;
							white-space: pre-line;
						}

						tr {
							page-break-inside: avoid
						}

						#table-5 {
							page-break-inside: avoid
						}

						#table-5 th span {
							text-align: left;
							float: left;
						}

						/*.table-2{ page-break-inside : avoid}*/
						/*#table-3 { display: none; !important}
						.table-3-print{display: inherit !important}*/
						/*.table-3-print{ page-break-inside : avoid !important;}*/
						/*.table-3-print, .table-3-print tr , .table-3-print tr td{width: 100% !important;padding-bottom: 1em;}
						.table-3-print-all, .table-3-print-all table {width: 100% !important; display: inherit !important; }
						#table-3-main-h2{display: none !important;}*/
						h2 {
							page-break-after: avoid
						}

						@page {
							orphans: 4;
							widows: 2;
						}

						/*#table-6 { display: none; !important}
						.table-6-print{display: inherit !important; padding-bottom: 1em;}*/
						th {
							text-align: center !important;
							padding: 0;
						}

						td {
							padding: 0;
						}

						/*@page {
							-webkit-transform: rotate(-90deg); -moz-transform:rotate(-90deg);
							filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
						}*/
						.landScape {
							width: 100%;
							height: 100%;
							margin: 0% 0% 0% 0%;
							filter: progid:DXImageTransform.Microsoft.BasicImage(Rotation=3);
						}
					}

					@media print and (-webkit-min-device-pixel-ratio: 0) {
						/*@page {
							size: landscape;
						}*/
					}

					/*@media print{@page {
						-webkit-transform: rotate(-90deg); -moz-transform:rotate(-90deg);
						filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
					}*/
					/*#table-3-main-h2{display: inherit;}
					.table-3-print-all{display: none;}
					.table-3-print{display: none;}
					.table-6-print{display: none;}*/
					h2 {
						font-family: arial, verdana, sans-serif;
					}

					h1 {
						font-size: 160%;
						padding-bottom: 0.5em;
						border-bottom: 1px solid #999999;
					}

					body {
						font-size: 80%;
						font-family: verdana, helvetica, arial, sans-serif;
						color: #333;
					}

					caption {
						display: none;
						font-family: vardana, verdana, helvetica, arial, sans-serif;
						text-align: left;
						font-size: 150%;
					}

					table {
						font-size: 100%;
						border: 1px solid #bbb;
						margin: 0 0 2em 0;
						border-collapse: collapse;
						max-width: 74em;
					}

					#table-4 {
						width: 10em !important;
					}

					.sub {
						font-size: 0.8em;
					}

					sup {
						font-size: 0.8em;
						font-style: italic;
						color: #777;
					}

					.datatable tr.th {
						text-align: left;

					}

					.datatable2 tr.th {
						text-align: left;

					}

					.datatable2 {
						margin: 0 0 0 0;
						border: 1px solid #bbb;
						border-collapse: collapse;
					}

					th, td {
						font-size: 100%;
						border: 1px solid #bbb;
					}

					th {
						background-color: #f6f6f6;
						text-align: left;
						vertical-align: top;
						font-weight: normal;
						color: black;
					}

					table {
						font-size: 100%;
						border: 1px solid #bbb;
						margin: 0 0 2em 0;
						border-collapse: collapse;
					}

					.left {
						text-align: left;
					}

					.bold {
						font-weight: bold;
					}

					.transactionColum {
						width: 15em;
					}

					.substanceColum {
						width: 5em;
						text-align: center;
					}

					.exportRow1 {

					}

					.exportRow2 {
						width: 7em;
					}

					.cellHeight {
						height: 1.4em;
					}

					.generalReportDataColum {
						width: 10em;
					}

					.metadata_table tr th:first-child {
						width: 15em;
					}

					.metadata_table td {
						width: 10em;
					}

					.footnote-b-tr td {
						word-wrap: break-word;
						width: 10em;
					}

					.footnote span, div.footnote {
						font-size: 0.9em;
						font-style: italic;
						color: #777;
					}
					.comment {
						font-style: italic;
						white-space: normal;
					}
					.commentTbl tr.th {
						width: 10em;
					}

					.commentTbl th.col-1 {
						width: 5em;
					}

					.commentTbl th.col-2 {
						width: 14.5em;
					}

					.commentTbl th.col-3 {
						width: 5em;
					}

					.commentTbl th.col-4 {
						width: 5em;
					}

					.section11-table th, .section11-table td {
						vertical-align: top;
						background-color: #f6f6f6;
					}

					.section11-table .code {
						font-weight:bold;
					}

					.floatRight {
						float: right;
					}

					.activitiesCheckbox .floatRight {
						float: right;
					}

					.activitiesCheckbox input.floatRight {
						width: 2em;
					}

					.floatLeft {
						float: left;
					}

					.bottom-border-bold {
						border-bottom: 2px solid rgb(182, 182, 182);
					}

					#affiliation-intro, #affiliation-intro td {
						border: 0;
					}

					.padding-right-1em {
						padding-right: 1em;
					}

					.padding-left-1-5em {
						padding-left: 1.5em;
					}

					.padding-left-1em {
						padding-left: 1em;
					}

					.padding-left-2em {
						padding-left: 2em;
					}

					.padding-left-3em {
						padding-left: 3em;
					}

					.padding-left-4em {
						padding-left: 4em;
					}

					.boldTh th {
						font-weight: bold;
					}

					.padding-top {
						padding-top: 3em;
					}

					.gasTh {
						width: 4em;
					}
					.sum-of-supplied-hfs {
						width: 8em;
						colspan: 2;
					}

					.boldSpan th span {
						font-weight: bold;
					}

					th p {
						margin: 0;
					}

					.boldHeading th {
						font-weight: bold;
					}

					.no-wrap {
						white-space: nowrap;
					}

					input:disabled, textarea:disabled {
						color: #000000;
					}

					#table-1 td, #table-1 th {
						padding: 0.5em;
					}

					#table-2 td, #table-2 th {
						padding: 0.5em;
					}

					#table-3 td, #table-3 th {
						padding: 0.5em;
					}

					#Affiliations td, #Affiliations th {
						padding: 0.5em;
					}

					#table-4 td, #table-4 th {
						padding: 0.5em;
					}

					.textCenter {
						text-align: center !important;
					}

					.sidePadding {
						padding-right: 1em;
						padding-left: 1em;
					}

					.tablePaginationNrColor {
						color: blue;
					}

					.tradingPartners div {
						float: left;
					}

					body {
						font-family: arial !important;
					}

					td {
						color: rgb(0, 0, 192);
					}

					.black {
						color: black !important;
					}

					.firstTh {
						width: 20em;
					}

					.tableSizeLimit {
						max-width: 79em;
						width: 48em;
					}

					.tdColorBlack td {
						color: black;
					}

					.tdColorBlue {
						color: rgb(0, 0, 192) !important;
					}

					.formula {
						font-weight: bold;
						font-style: italic;
						/*color: rgb(90, 90, 90); gray*/
						/*rgb(16, 152, 0); lighter green*/
						color: rgb(25, 102, 16); /*darker green */
					}

					.fontNormal {
						font-weight: normal !important;
					}

					.num_cell {
						text-align: right;
						background-color: #FFFFE0 !important;
						padding-right: 0.2em;
						white-space: nowrap;
						padding-left: 0.2em;
						vertical-align:top;
						color: rgb(0, 0, 192);
					}

					.text_input {
						background-color: #FFFFE0 !important;
					}

					.total {
						/*
						font-weight:bold;
						*/
						color: black;
						background-color: #f6f6f6;
						text-align: right;
						padding-left: 0.2em;
						padding-right: 0.2em;
						white-space: nowrap;
						vertical-align:top;
						color: rgb(0, 0, 192);
					}

					.nowrap {
						white-space: nowrap;
					}

					.inputPadding span {
						padding-left: 0.5em;
					}

					.section11Amount {
						width: 6em;
					}

					.section11Explanation {
						width: 6em;
					}

					.section11Code {
						width: 3em;
					}

					.hidden {
						visibility: hidden;
						border-color: #fff;
					}

					.hidden td {
						border-color: #fff;
						border-bottom: 1px solid #bbb !important;
					}

					.word-break {
						word-break: normal;
					}
				</style>

			</head>
			<body>
				<h1>
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'Questionnaire-title'"/>
					</xsl:call-template>
				</h1>
				<div>
					<p><span>XML file: </span><a><xsl:attribute name="href"><xsl:value-of select="concat($envelopeurl,'/',$filename)"/></xsl:attribute>
						<xsl:attribute name="target"><xsl:value-of select="'blank_'"/></xsl:attribute>
						<xsl:value-of select="$filename"/></a></p>
					<p><span>XML file converted at: </span>
						<xsl:value-of select="concat(substring(string($current-date), 1, 10), ' ', substring(string($current-date), 12, 5))"/>
					</p>
					<xsl:if test="$acceptable = 'true' or $acceptable = 'false'">
						<p><span>Envelope submission date: </span>
							<xsl:value-of select="concat(substring(string($submissionDate), 1, 10), ' ', substring(string($submissionDate), 12, 5))"/>
						</p>
					</xsl:if>
					<p><span>Converted from: </span>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$envelopeurl"/>
							</xsl:attribute>
							<xsl:value-of select="$envelopeurl"/>
						</a>
					</p>
					<p><span>Envelope status: </span>
						<xsl:choose>
							<xsl:when test="$acceptable = 'true'">
								Accepted by automated quality control
							</xsl:when>
							<xsl:when test="$acceptable = 'false'">
								Rejected by automated quality control
							</xsl:when>
							<xsl:otherwise>
								Draft envelope (not yet submitted)
							</xsl:otherwise>
						</xsl:choose>
					</p>
				</div>
				<xsl:apply-templates />
				<div class="padding-bottom"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="GeneralReportData">

		<!-- Company Information tab -->
		<h2>
			<xsl:call-template name="getLabel">
				<xsl:with-param name="labelName" select="'info'"/>
			</xsl:call-template>
		</h2>
		<table id="table-1" class="table table-hover table-bordered">
			<tbody>
				<tr>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'name'"/>
						</xsl:call-template>
					</th>
					<td colspan="3">
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/CompanyName"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'contact-tel'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/Telephone"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'website'"/>
						</xsl:call-template>
					</th>
					<td colspan="3">
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/Website"/></xsl:call-template>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'address-street'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/PostalAddress/StreetAddress"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'address-number'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/PostalAddress/Number"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'address-postcode'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/PostalAddress/PostalCode"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'address-city'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/PostalAddress/City"/></xsl:call-template>
					</td>
					<th>
						<xsl:choose>
							<xsl:when test="Company/Country/Type='EU_TYPE'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'eu-country'"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'non-eu-country'"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/Country/Name"/></xsl:call-template>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'vat'"/>
						</xsl:call-template>
					</th>
					<td colspan="2">
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/VATNumber"/></xsl:call-template>
					</td>
					
					
					
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'eori'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue">
							<xsl:with-param name="elem" select="Company/EORI"/>
						</xsl:call-template>
					</td>
				
					
					
				</tr>
				<tr>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'id'"/>
						</xsl:call-template>
					</th>
					<td colspan="9">
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/CompanyId"/></xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table>


		<xsl:if test="string-length(Company/EuLegalRepresentativeCompany/CompanyName) > 0">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'eu-legal-representative'"/>
				</xsl:call-template>
			</h2>
			<table id="table-2" class="table table-hover table-bordered">
				<tbody>
					<tr>
						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'OR-company-id'"/>
							</xsl:call-template>
						</th>
						<td>
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/CompanyId"/></xsl:call-template>
						</td>
						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'eu-legal-representative-name'"/>
							</xsl:call-template>
						</th>
						<td  colspan="2">
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/CompanyName"/></xsl:call-template>
						</td>
						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'contact-tel'"/>
							</xsl:call-template>
						</th>
						<td >
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/Telephone"/></xsl:call-template>
						</td>
						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'website'"/>
							</xsl:call-template>
						</th>
						<td colspan="2">
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/Website"/></xsl:call-template>
						</td>
					</tr>
					<tr>
						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'address-street'"/>
							</xsl:call-template>
						</th>
						<td >
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/PostalAddress/StreetAddress"/></xsl:call-template>
						</td>

						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'address-number'"/>
							</xsl:call-template>
						</th>
						<td >
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/PostalAddress/number"/></xsl:call-template>
						</td>

						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'address-postcode'"/>
							</xsl:call-template>
						</th>
						<td >
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/PostalAddress/PostalCode"/></xsl:call-template>
						</td>

						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'address-city'"/>
							</xsl:call-template>
						</th>
						<td >
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/PostalAddress/City"/></xsl:call-template>
						</td>

						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'eu-country'"/>
							</xsl:call-template>
						</th>
						<td >
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/Country/Name"/></xsl:call-template>
						</td>
					</tr>
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'eu-legal-representative-contact'"/>
							</xsl:call-template>
						</th>
						<td colspan="3">
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/ContactPerson/FirstName"/></xsl:call-template>
							<span style="padding-right:1em;"/>
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/ContactPerson/LastName"/></xsl:call-template>
						</td>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'eu-legal-representative-email'"/>
							</xsl:call-template>
						</th>
						<td colspan="3">
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/ContactPerson/Email"/></xsl:call-template>
						</td>
					</tr>
					<tr>
						<th colspan="1">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'eu-vat'"/>
							</xsl:call-template>
						</th>
						<td colspan="4">
							<xsl:call-template name="getValue">
								<xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/VATNumber"/>
							</xsl:call-template>
						</td>
						<th colspan="1">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'eu-or-eori'"/>
							</xsl:call-template>
						</th>
						<td colspan="4">
							<xsl:call-template name="getValue">
								<xsl:with-param name="elem" select="Company/EuLegalRepresentativeCompany/EORI"/>
							</xsl:call-template>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>

		<h2>
			<xsl:call-template name="getLabel">
				<xsl:with-param name="labelName" select="'contact-info'"/>
			</xsl:call-template>
		</h2>
		<table  id="table-3" class="table table-hover table-bordered">
			<tbody>
				<xsl:for-each select="Company/ContactPersons/*">
					<tr>
						<th colspan="">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'contact-first-name'"/>
							</xsl:call-template>
						</th>
						<td colspan="">
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="./FirstName"/></xsl:call-template>
						</td>
						<th colspan="">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'contact-last-name'"/>
							</xsl:call-template>
						</th>
						<td colspan="">
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="./LastName"/></xsl:call-template>
						</td>
						<th colspan="">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'contact-email'"/>
							</xsl:call-template>
						</th>
						<td colspan="">
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="./Email"/></xsl:call-template>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
		<h2>
			<xsl:call-template name="getLabel">
				<xsl:with-param name="labelName" select="'affiliation-header'"/>
			</xsl:call-template>
		</h2>
		<table  id="affiliation-intro" style="margin-top:1em;"  class="table table-hover table-bordered">
			<tr>
				<td class="black">
					<span >
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'affiliation-intro'"/>
						</xsl:call-template>
					</span>
				</td>
			</tr>
		</table>
		<xsl:if test="count(Company/Affiliations/*) = 0">
			<span>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'affiliation-confirmed-nothing'"/>
				</xsl:call-template>
			</span>
		</xsl:if>
		<xsl:if test="count(Company/Affiliations/*) > 0">
			<table  id="Affiliations" style="margin-top:1em;"  class="table table-hover table-bordered">
				<xsl:for-each select="Company/Affiliations/*">
					<xsl:if test="position() > 1">
						<tr>
							<td colspan="4"/>
						</tr>
					</xsl:if>
					<tr>
						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'trading-partner-company-name'"/>
							</xsl:call-template>
						</th>
						<td>
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template>
						</td>

						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'trading-partner-eu-based'"/>
							</xsl:call-template>
						</th>
						<td>
							<xsl:call-template name="getValue"><xsl:with-param name="elem" select="isEUBased"/></xsl:call-template>
						</td>
					</tr>

					<xsl:if test="isEUBased = 'true'">
						<tr class="bottom-border-bold">
							<th>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'trading-partner-vat-no'"/>
								</xsl:call-template>
							</th>
							<td colspan="3">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="isEUBased = 'false'">
						<tr>
							<th>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'trading-partner-country'"/>
								</xsl:call-template>
							</th>
							<td colspan="1">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
							</td>
							<th>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'trading-partner-reg-code'"/>
								</xsl:call-template>
							</th>
							<td colspan="1">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUDgClimaRegCode"/></xsl:call-template>
							</td>
						</tr>
						<tr class="bottom-border-bold">
							<th>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
								</xsl:call-template>
							</th>
							<td colspan="1">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
							</td>
							<th>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
								</xsl:call-template>
							</th>
							<td colspan="1">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeVAT"/></xsl:call-template>
							</td>
						</tr>
					</xsl:if>

				</xsl:for-each>


			</table>
		</xsl:if>
		<!-- Year & Activities tab -->
		<table  id="table-4" style="margin-top:1em;"  class="table table-hover table-bordered">
			<tr>
				<th class="nowrap">
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'reporting-year'"/>
					</xsl:call-template>
				</th>
				<td>
					<xsl:call-template name="getValue"><xsl:with-param name="elem" select="TransactionYear"/></xsl:call-template>
				</td>
			</tr>
		</table>


		<xsl:if test="count(Activities/*[. = 'true']) > 0">
			<table  id="table-5"  class="activitiesCheckbox table table-hover table-bordered">
				<tr style="border-top: 1px solid #fff;
                    border-left: 1px solid #fff;
                    border-right: 1px solid #fff;">
					<td class="black" style="border-top: 1px solid #fff;
                    border-left: 1px solid #fff;
                    border-right: 1px solid #fff;" colspan="2">
						<h2>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'heading'"/>
							</xsl:call-template>
						</h2>
					</td>
				</tr>
				<xsl:if test="Activities/*[substring(name(.),1,1) = 'P'] = 'true'">
					<tr>
						<th colspan="2" class="inputPadding">
							<input class="floatLeft" type="checkbox" name="P-HFC"  checked="true" disabled="true"></input>
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'producer'"/>
								</xsl:call-template>
							</span>
						</th>
					</tr>
					<xsl:if test="Activities/P-HFC = 'true'">
						<tr>
							<td class="padding-left-1-5em">
								<input class="floatRight" type="checkbox" name="P-HFC"  checked="true" disabled="true"></input>
							</td>
							<th>
								<span>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'producer-hfc'"/>
									</xsl:call-template>
								</span>
							</th>
						</tr>
					</xsl:if>
					<xsl:if test="Activities/P-other = 'true'">
						<tr>
							<td class="padding-left-1-5em">
								<input class="floatRight" type="checkbox" name="P-other"  checked="true" disabled="true"></input>
							</td>
							<th>
								<span>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'producer-other'"/>
									</xsl:call-template>
								</span>
							</th>
						</tr>
					</xsl:if>
				</xsl:if>
				<xsl:if test="Activities/*[substring(name(.),1,1) = 'I'] = 'true'">
					<tr>
						<th colspan="2" class="inputPadding">
							<input class="floatLeft" type="checkbox" name="importer-bulk"  checked="true" disabled="true"></input>
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'importer-bulk'"/>
								</xsl:call-template>
							</span>
						</th>
					</tr>
					<xsl:if test="Activities/I-HFC = 'true'">
						<tr>
							<td class="padding-left-1-5em">
								<input class="floatRight" type="checkbox" name="I-HFC"  checked="true" disabled="true"></input>
							</td>
							<th>
								<span>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'importer-bulk-hfc'"/>
									</xsl:call-template>
								</span>
							</th>
						</tr>
					</xsl:if>
					<xsl:if test="Activities/I-other = 'true'">
						<tr>
							<td class="padding-left-1-5em">
								<input class="floatRight" type="checkbox" name="P-other"  checked="true" disabled="true"></input>
							</td>
							<th>
								<span>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'importer-bulk-other'"/>
									</xsl:call-template>
								</span>
							</th>
						</tr>
					</xsl:if>
				</xsl:if>
				<xsl:if test="Activities/E = 'true'">
					<tr>
						<td>
							<input type="checkbox" name="E"  checked="true" disabled="true"></input>
						</td>
						<th>
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'exporter-bulk'"/>
								</xsl:call-template>
							</span>
						</th>
					</tr>
				</xsl:if>
				<xsl:if test="Activities/RC = 'true'">
					<tr>
						<td>
							<input type="checkbox" name="RC"  checked="true" disabled="true"></input>
						</td>
						<th>
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'reclamation-company'"/>
								</xsl:call-template>
							</span>
						</th>
					</tr>
				</xsl:if>
				<xsl:if test="Activities/RQ = 'true'">
					<tr>
						<td>
							<input type="checkbox" name="RQ"  checked="true" disabled="true"></input>
						</td>
						<th>
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'recipient-quota'"/>
								</xsl:call-template>
							</span>
						</th>
					</tr>
				</xsl:if>
				<xsl:if test="Activities/RH = 'true'">
					<tr>
						<td>
							<input type="checkbox" name="RH"  checked="true" disabled="true"></input>
						</td>
						<th>
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'recipient-HFC'"/>
								</xsl:call-template>
							</span>
						</th>
					</tr>
				</xsl:if>
				<xsl:if test="Activities/FU = 'true'">
					<tr>
						<td>
							<input type="checkbox" name="E"  checked="true" disabled="true"></input>
						</td>
						<th>
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'feedstock-user'"/>
								</xsl:call-template>
							</span>
						</th>
					</tr>
				</xsl:if>
				<xsl:if test="Activities/D = 'true'">
					<tr>
						<td>
							<input type="checkbox" name="E"  checked="true" disabled="true"></input>
						</td>
						<th>
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'destruction-company'"/>
								</xsl:call-template>
							</span>
						</th>
					</tr>
				</xsl:if>
				<xsl:if test="Activities/*[substring(name(.),1,2) = 'Eq' or substring(name(.),1,4) = 'auth'] = 'true'">
					<!--<tr>
						<th class="bold" colspan="2">
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'manufacturer-containing-fgases'"/>
								</xsl:call-template>
							</span>
						</th>
					</tr>
					<tr>
                    <th colspan="2">
                        <span style="padding-bottom:1em;">
                            <xsl:call-template name="getLabel">
                                <xsl:with-param name="labelName" select="'manufacturer-containing-fgases-info-text'"/>
                            </xsl:call-template>
                        </span>
                        <span>
                            <xsl:call-template name="getLabel">
                                <xsl:with-param name="labelName" select="'manufacturer-containing-fgases-info-text2'"/>
                            </xsl:call-template>
                        </span>
                    </th>
                </tr>-->
					<xsl:if test="Activities/*[substring(name(.),1,2) = 'Eq'] = 'true'">
						<tr>
							<th colspan="2" class="inputPadding">
								<input class="floatLeft" type="checkbox" name="importer-fgases"  checked="true" disabled="true"></input>
								<span>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'importer-fgases'"/>
									</xsl:call-template>
								</span>
							</th>
						</tr>
					</xsl:if>
					<xsl:if test="Activities/Eq-I-RACHP-HFC = 'true'">
						<tr>
							<td  class="padding-left-1-5em">
								<input class="floatRight" type="checkbox" name="Eq-I-RACHP-HFC"  checked="true" disabled="true"></input>
							</td>
							<th>
								<span>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'importer-fgases-hfc'"/>
									</xsl:call-template>
								</span>
							</th>
						</tr>
					</xsl:if>
					<xsl:if test="Activities/Eq-I-other = 'true'">
						<tr>
							<td  class="padding-left-1-5em">
								<input class="floatRight" type="checkbox" name="Eq-I-other"  checked="true" disabled="true"></input>
							</td>
							<th>
								<span>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'importer-fgases-other'"/>
									</xsl:call-template>
								</span>
							</th>
						</tr>
					</xsl:if>
					<xsl:if test="Activities/auth = 'true'">
						<tr>
							<td>
								<input type="checkbox" name="auth"  checked="true" disabled="true"></input>
							</td>
							<th colspan="2">

								<span>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'undertaking-authorisation'"/>
									</xsl:call-template>
								</span>
							</th>
						</tr>
					</xsl:if>
				</xsl:if>
				<xsl:if test="Activities/RQA = 'true'">
					<tr>
						<td>
							<input type="checkbox" name="RQA"  checked="true" disabled="true"></input>
						</td>
						<th colspan="2">

							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'received-quota-allocation'"/>
								</xsl:call-template>
							</span>
						</th>
					</tr>
				</xsl:if>
				<xsl:if test="Activities/NIL-Report = 'true'">
					<tr>
						<th colspan="2" class="bold">
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'nil-report-desc'"/>
								</xsl:call-template>
							</span>
						</th>
					</tr>
					<tr>
						<th colspan="2" class="inputPadding">
							<input class="floatLeft" type="checkbox" name="nil-report"  checked="true" disabled="true"></input>
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'nil-report'"/>
								</xsl:call-template>
							</span>
						</th>
					</tr>
				</xsl:if>
			</table>
		</xsl:if>
		<xsl:if test="count(../ReportedGases/GasGroup[string-length(.) > 0]) > 0 and Activities/NIL-Report != 'true'">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'selection'"/>
				</xsl:call-template>
			</h2>
			<xsl:call-template name="gases" />
		</xsl:if>
	</xsl:template>
	<xsl:template name="gases">

		<table id="table-2" class="table table-hover table-bordered">
			<tbody class="boldTh">
				<xsl:if test="count(../ReportedGases/GasGroup[.= 'HFCs']) > 0 ">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'hfc-selection'"/>
							</xsl:call-template>
						</th>

					</tr>
					<xsl:for-each select="../ReportedGases[./GasGroup = 'HFCs']">
						<tr>
							<td/>
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="count(../ReportedGases/GasGroup[.= 'HFC mixtures']) > 0 ">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'mixtures-selection'"/>
							</xsl:call-template>
						</th>

					</tr>
					<xsl:for-each select="../ReportedGases[./GasGroup = 'HFC mixtures']">
						<tr>
							<td/>
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="count(../ReportedGases/GasGroup[.= 'Unsaturated HFCs and HCFCs']) > 0 ">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'unsaturated-hfc-selection'"/>
							</xsl:call-template>
						</th>

					</tr>
					<xsl:for-each select="../ReportedGases[./GasGroup = 'Unsaturated HFCs and HCFCs']">
						<tr>
							<td/>
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="count(../ReportedGases/GasGroup[.= 'PFCs']) > 0 ">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'pfc-selection'"/>
							</xsl:call-template>
						</th>

					</tr>
					<xsl:for-each select="../ReportedGases[./GasGroup = 'PFCs']">
						<tr>
							<td/>
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="count(../ReportedGases/GasGroup[.= 'Other (per)fluorinated compounds and fluorinated nitriles (Annex I, Section 3)']) > 0 ">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'sf6-selection'"/>
							</xsl:call-template>
						</th>

					</tr>
					<xsl:for-each select="../ReportedGases[./GasGroup = 'Other (per)fluorinated compounds and fluorinated nitriles (Annex I, Section 3)']">
						<tr>
							<td/>
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="count(../ReportedGases/GasGroup[.= 'Fluorinated substances used as inhalation anaesthetics']) > 0 ">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'inhalation-selection'"/>
							</xsl:call-template>
						</th>

					</tr>
					<xsl:for-each select="../ReportedGases[./GasGroup = 'Fluorinated substances used as inhalation anaesthetics']">
						<tr>
							<td/>
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="count(../ReportedGases/GasGroup[.= 'Other fluorinated substances (Annex II, Section 3)']) > 0 ">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'nf3-selection'"/>
							</xsl:call-template>
						</th>

					</tr>
					<xsl:for-each select="../ReportedGases[./GasGroup = 'Other fluorinated substances (Annex II, Section 3)']">
						<tr>
							<td/>
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="count(../ReportedGases/GasGroup[.= 'Fluorinated ethers, ketones and alcohols']) > 0 ">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'fluorinated-ethers-alcohols-selection'"/>
							</xsl:call-template>
						</th>

					</tr>
					<xsl:for-each select="../ReportedGases[./GasGroup = 'Fluorinated ethers, ketones and alcohols']">
						<tr>
							<td/>
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="count(../ReportedGases/GasGroup[.= 'Other fluorinated compounds (Annex III, Section 2)']) > 0 ">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'other-prefluorinated-selection'"/>
							</xsl:call-template>
						</th>

					</tr>
					<xsl:for-each select="../ReportedGases[./GasGroup = 'Other fluorinated compounds (Annex III, Section 2)']">
						<tr>
							<td/>
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="count(../ReportedGases/GasGroup[.= 'Non-fluorinated substances (FGR)']) > 0 or count(../ReportedGases/GasGroup[.= 'Other non-fluorinated substances']) > 0">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'non-fluorinated-selection'"/>
							</xsl:call-template>
						</th>

					</tr>
					<xsl:for-each select="../ReportedGases[./GasGroup = 'Non-fluorinated substances (FGR)']">
						<tr>
							<td/>
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:for-each select="../ReportedGases[./GasGroup = 'Other non-fluorinated substances']">
						<tr>
							<td/>
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="count(../ReportedGases/GasGroup[.= 'CustomMixture']) > 0 ">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'custom-mixtures'"/>
							</xsl:call-template>
						</th>

					</tr>
					<tr>
						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'mixture-name'"/>
							</xsl:call-template>
						</th>
						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'mixture-gas-name'"/>
							</xsl:call-template>
							<span> - </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'mixture-gas-ratio'"/>
							</xsl:call-template>
						</th>
					</tr>
					<xsl:for-each select="../ReportedGases[./GasGroup = 'CustomMixture']">
						<tr>
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Code"/></xsl:call-template>
							</td>
							<td >
								<xsl:for-each select="./BlendComponents/Component">
									<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Code"/></xsl:call-template>
									<span> - </span>
									<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Percentage"/></xsl:call-template>
									<span>% </span>
								</xsl:for-each>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template match="ReportedGases"/>


	<!-- Pagination -->
	<!--Test: http://stackoverflow.com/questions/12235060/pagination-in-xsl  -->

	<!--################################# PAGINATION LIMIT NR ##################################-->
	<xsl:variable name="pagingLimit" select="10"/>
	<!--########################################################################################-->

	<xsl:template name="tablePaging1">
		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'F1_S1_4_ProdImpExp']/Gas">
				<xsl:with-param name="section" select="1" />
			</xsl:apply-templates>

		</xsl:copy>
	</xsl:template>

	<xsl:template name="tablePaging2">
		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'F1_S1_4_ProdImpExp']/Gas">
				<xsl:with-param name="section" select="2" />
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="tablePaging3">
		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'F1_S1_4_ProdImpExp']/Gas">
				<xsl:with-param name="section" select="3" />
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="tablePaging4">
		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'F1_S1_4_ProdImpExp']/Gas">
				<xsl:with-param name="section" select="4" />
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="tablePaging5">
		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'F2_S5_exempted_HFCs']/Gas">
				<xsl:with-param name="section" select="5" />
			</xsl:apply-templates>

		</xsl:copy>
	</xsl:template>

	<xsl:template name="tablePaging5a">
		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'F2a_S5a_exempted_HFCs']/Gas">
				<xsl:with-param name="section" select="51" />
			</xsl:apply-templates>

		</xsl:copy>
	</xsl:template>

	<xsl:template name="tablePaging6">
		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'F3A_S6A_IA_HFCs']/Gas">
				<xsl:with-param name="section" select="6" />
			</xsl:apply-templates>

		</xsl:copy>
	</xsl:template>


	<xsl:template name="tablePaging7">
		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'F6_FUDest']/Gas">
				<xsl:with-param name="section" select="7" />
			</xsl:apply-templates>

		</xsl:copy>
	</xsl:template>
	<xsl:template name="tablePaging8">
		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'F6_FUDest']/Gas">
				<xsl:with-param name="section" select="8" />
			</xsl:apply-templates>

		</xsl:copy>
	</xsl:template>

	<xsl:template name="tablePaging11">
		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'F7_s11EquImportTable']/Gas">
				<xsl:with-param name="section" select="11" />
			</xsl:apply-templates>

		</xsl:copy>
	</xsl:template>

	<xsl:template name="tablePaging12">
		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'F8_S12']/Gas">
				<xsl:with-param name="section" select="12" />
			</xsl:apply-templates>

		</xsl:copy>
	</xsl:template>
	<xsl:template name="table13">
		<table class="tdColorBlack tableSizeLimit table table-hover table-bordered section11-table">
			<tbody class="boldSpan">
				<tr class="boldHeading">
					<th>Code and reporting parameter</th>
					<th>Explanation for category, if needed</th>
					<th>	<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'tr-header-amount-label'"/>
					</xsl:call-template> /
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-header-amount-unit'"/>
						</xsl:call-template></th>
				</tr>
				<tr>
					<td class="code">13A</td>
					<td>	  	<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'tr-13a-desc'"/>
					</xsl:call-template>
						<br/>
						<xsl:variable name="tr-13a-desc-taill">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-13a-desc-tail'"/>
							</xsl:call-template>
						</xsl:variable>
						<i><xsl:value-of select="replace(string($tr-13a-desc-taill), '\{\{ date \}\}', string(.[name() = 'F9_S13']/tr_13A_date) )"/></i>
					</td>
					<td><xsl:call-template name="formatValue"><xsl:with-param name="num" select=".[name() = 'F9_S13']/AuthBalance/Amount"/></xsl:call-template></td>
					<!--<td><xsl:value-of select="format-number(.[name() = 'F9_S13']/AuthBalance/Amount, '#')"/></td>-->
				</tr>

				<tr>
					<td colspan="3">
						<span class="bold">Disclaimer</span>
						<span>	<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-13a-disclaimer'"/>
						</xsl:call-template>
						</span>
					</td>
				</tr>

				<tr>
					<td class="code">13B</td>
					<td>	  	<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'tr-13b-desc'"/>
					</xsl:call-template>
						<span class="formula"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-13b-formula'"/>
						</xsl:call-template></span></td>
					<td  class="tdColorBlue total">
						<xsl:call-template name="formatValue"><xsl:with-param name="num" select=".[name() = 'F9_S13']/Totals/tr_13B/Amount"/></xsl:call-template>
					</td>
				</tr>
				
				<tr>
					<td class="code">13Ba</td>
					<td>	  	<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'tr-13ba-desc'"/>
					</xsl:call-template>
						<span class="formula"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-13ba-formula'"/>
						</xsl:call-template></span></td>
					<td  class="tdColorBlue total">
						<xsl:call-template name="formatValue"><xsl:with-param name="num" select=".[name() = 'F9_S13']/Totals/tr_13Ba/Amount"/></xsl:call-template>
					</td>
				</tr>
				
				<tr>
					<td class="code">13Bb</td>
					<td>	  	<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'tr-13Bb-desc'"/>
					</xsl:call-template>
						<span class="formula"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-13Bb-formula'"/>
						</xsl:call-template></span></td>
					<td  class="tdColorBlue total">
						<xsl:call-template name="formatValue"><xsl:with-param name="num" select=".[name() = 'F9_S13']/Totals/tr_13Bb/Amount"/></xsl:call-template>
					</td>
				</tr>
				
				<tr>
					<td class="code">13C</td>
					<td>	  	<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'tr-13c-desc'"/>
					</xsl:call-template><span class="formula"><xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'tr-13c-formula'"/>
					</xsl:call-template></span></td>
					<td class="tdColorBlue total">
						<xsl:call-template name="formatValue"><xsl:with-param name="num" select=".[name() = 'F9_S13']/Totals/tr_13C/Amount"/></xsl:call-template>
					</td>
				</tr>
				
				<tr>
					<td class="code">13Ca</td>
					<td>	  	<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'tr-13ca-desc'"/>
					</xsl:call-template><span class="formula"><xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'tr-13ca-formula'"/>
					</xsl:call-template></span></td>
					<td class="tdColorBlue total">
						<xsl:call-template name="formatValue"><xsl:with-param name="num" select=".[name() = 'F9_S13']/Totals/tr_13Ca/Amount"/></xsl:call-template>
					</td>
				</tr>
				
					
				<tr>
					<td class="code">13D</td>
					<td>	  	<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'tr-13d-desc'"/>
					</xsl:call-template><span class="formula"><xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'tr-13d-formula'"/>
					</xsl:call-template></span></td>
					<td class="tdColorBlue total">
						<xsl:call-template name="formatValue"><xsl:with-param name="num" select=".[name() = 'F9_S13']/Totals/tr_13D/Amount"/></xsl:call-template>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="code">
						<xsl:if test=".[name() = 'F9_S13']/Verified = 'false' or .[name() = 'F9_S13']/Verified = ''">
							<input type="checkbox" name="13checkbox" value="false"  disabled="true" />
						</xsl:if>
						<xsl:if test=".[name() = 'F9_S13']/Verified = 'true'">
							<input type="checkbox" name="13checkbox" value="true" checked="checked" disabled="true"/>
						</xsl:if>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-verified-desc'"/>
						</xsl:call-template>

					</td>
				</tr>
			</tbody>
		</table>


		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'F9_S13']/Totals">
				<xsl:with-param name="section" select="13" />
			</xsl:apply-templates>

		</xsl:copy>
	</xsl:template>
	<!-- Cleans up leftovers -->
	<xsl:template match="Gas[position() mod $pagingLimit != 1]" />

	<!-- ###################################################### Tables with pagination ######################################################################## -->
	<xsl:template match="Gas[position() mod $pagingLimit = 1]"  name="section">
		<xsl:param name="section" />

		<!-- Section 1 -->
		<!--<xsl:message>-->
		<!--Section: <xsl:value-of select="$section"/>-->
		<!--</xsl:message>-->

		<xsl:if test="$section = 12">
			<span class="bold tablePaginationNrColor" >(<xsl:value-of select="ceiling(position() div $pagingLimit)" />/<xsl:value-of select="ceiling(count(../Gas) div $pagingLimit)" /> )</span>
			<table  class="tdColorBlack tableSizeLimit table table-hover table-bordered section11-table">
				<tbody  class="boldSpan">
					<tr class="hidden">
						<td class="section11Code"/>
						<td class="section11Explanation" style="width: 68em;"/>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class=""/>
							</xsl:if>
						</xsl:for-each>
					</tr>
					<tr class="boldHeading">
						<th rowspan="2" colspan="1" class=""><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'code_and_reporting_parameter'"/>
						</xsl:call-template>
						</th>
						<th rowspan="2" class=""><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'reporter_specify_category'"/>
						</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<th class="gasTh">
									<xsl:call-template name="getGas"><xsl:with-param name="elem" select="../../ReportedGases[./GasId = current()/GasCode]/Name"/></xsl:call-template>
								</th>
							</xsl:if>
						</xsl:for-each>
					</tr>
					<tr class="boldHeading no-wrap">
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<th  class="textCenter sidePadding">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'common'"/>
									</xsl:call-template>
								</th>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<!-- 12A -->
					<tr>
						<td class="code">12A</td>
						<td>	  	<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12a-desc'"/>
						</xsl:call-template></td>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_12A/SumOfPartnersAmount"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<xsl:for-each select="tr_12A/Transaction">
						<xsl:variable name="trPos" select="position()"/>
						<tr>
							<td></td>
							<td style="text-align: right;">
								Transaction #<xsl:value-of select="$trPos"/><br/>
								<xsl:choose>
									<xsl:when test="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/isEUBased=true()">
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-pom-label'"/>
										</xsl:call-template>:</span>
										<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/CompanyName"/></span>
										<div>
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-vat-no'"/>
											</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/EUVAT"/></span>
										</div><span style="white-space: nowrap;">Year of placing on the EU Market: <xsl:value-of select="POM/Year"/></span>
										<br/>
									</xsl:when>
									<xsl:otherwise>
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-pom-label'"/>
										</xsl:call-template>:</span>
										<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/CompanyName"/></span>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEURepresentativeName"/></span>
										</div>
										<div><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEURepresentativeVAT"/></span>
										</div><div> <span>Year of export: <xsl:value-of select="POM/Year"/></span></div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-country'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEUCountryOfEstablishment"/></span>
										</div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-reg-code'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEUDgClimaRegCode"/></span>
										</div>
										<br/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/isEUBased=true()">
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-exp-label'"/>
										</xsl:call-template>:</span>
										<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/CompanyName"/></span>
										<div>
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-vat-no'"/>
											</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/EUVAT"/></span>
										</div><span style="white-space: nowrap;">Year of export of precharged product/equipment: <xsl:value-of select="Exporter/Year"/></span>
									</xsl:when>
									<xsl:otherwise>
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-exp-label'"/>
										</xsl:call-template>:</span>				
										<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/CompanyName"/></span>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEURepresentativeName"/></span>
										</div><div><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEURepresentativeVAT"/></span>
										</div><div> <span>Year of export: <xsl:value-of select="Exporter/Year"/></span></div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-country'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEUCountryOfEstablishment"/></span>
										</div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-reg-code'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12A_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEUDgClimaRegCode"/></span>
										</div>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<xsl:for-each select=".|../../following-sibling::Gas[not(position()>($pagingLimit - 1))]/tr_12A/Transaction[$trPos]">							
								<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/../../GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td class="tdColorBlue num_cell">										
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="Amount"/></xsl:call-template>
										<br/>
										<br/>
										<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Comment"/></xsl:call-template></span>
									</td>
								</xsl:if>
							</xsl:for-each>
						</tr>
					</xsl:for-each>

					<!-- 12aA -->
					<tr>
						<td class="code">12aA</td>
						<td>	  	<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12aA-desc'"/>
						</xsl:call-template></td>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_12aA/SumOfPartnersAmount"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<xsl:for-each select="tr_12aA/Transaction">
						<xsl:variable name="trPos" select="position()"/>
						<tr>
							<td></td>
							<td style="text-align: right;">
								Transaction #<xsl:value-of select="$trPos"/><br/>
								<xsl:choose>
									<xsl:when test="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/isEUBased=true()">
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-pom-label'"/>
										</xsl:call-template>:</span>
										<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/CompanyName"/></span>
										<div>
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-vat-no'"/>
											</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/EUVAT"/></span>
										</div><span style="white-space: nowrap;">Year of placing on the EU Market: <xsl:value-of select="POM/Year"/></span>
										<br/>
									</xsl:when>
									<xsl:otherwise>
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-pom-label'"/>
										</xsl:call-template>:</span>
										<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/CompanyName"/></span>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEURepresentativeName"/></span>
										</div>
										<div><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEURepresentativeVAT"/></span>
										</div><div> <span>Year of export: <xsl:value-of select="POM/Year"/></span></div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-country'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEUCountryOfEstablishment"/></span>
										</div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-reg-code'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEUDgClimaRegCode"/></span>
										</div>
										<br/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/isEUBased=true()">
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-exp-label'"/>
										</xsl:call-template>:</span>
										<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/CompanyName"/></span>
										<div>
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-vat-no'"/>
											</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/EUVAT"/></span>
										</div><span style="white-space: nowrap;">Year of export of precharged product/equipment: <xsl:value-of select="Exporter/Year"/></span>
									</xsl:when>
									<xsl:otherwise>
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-exp-label'"/>
										</xsl:call-template>:</span>				
										<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/CompanyName"/></span>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEURepresentativeName"/></span>
										</div><div><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEURepresentativeVAT"/></span>
										</div><div> <span>Year of export: <xsl:value-of select="Exporter/Year"/></span></div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-country'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEUCountryOfEstablishment"/></span>
										</div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-reg-code'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12aA_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEUDgClimaRegCode"/></span>
										</div>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<xsl:for-each select=".|../../following-sibling::Gas[not(position()>($pagingLimit - 1))]/tr_12aA/Transaction[$trPos]">							
								<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/../../GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td class="tdColorBlue num_cell">										
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="Amount"/></xsl:call-template>
										<br/>
										<br/>
										<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Comment"/></xsl:call-template></span>
									</td>
								</xsl:if>
							</xsl:for-each>
						</tr>
					</xsl:for-each>

					<!-- 12bA -->
					<tr>
						<td class="code">12bA</td>
						<td>	  	<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12bA-desc'"/>
						</xsl:call-template><span class="formula"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12bA-formula'"/>
						</xsl:call-template></span></td>

						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="Totals/tr_12bA"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<!-- 12cA -->
					<tr>
						<td class="code">12cA</td>
						<td>	  	<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12cA-desc'"/>
						</xsl:call-template><span class="formula"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12cA-formula'"/>
						</xsl:call-template></span></td>

						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="Totals/tr_12cA"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>



					<!-- 12B -->
					<tr>
						<td class="code">12B</td>
						<td>	  	<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12b-desc'"/>
						</xsl:call-template></td>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_12B/SumOfPartnersAmount"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<xsl:for-each select="tr_12B/Transaction">
						<xsl:variable name="trPos" select="position()"/>
						<tr>
							<td></td>
							<td style="text-align: right;">
								Transaction #<xsl:value-of select="$trPos"/><br/>
								<xsl:choose>
									<xsl:when test="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/isEUBased=true()">
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-pom-label'"/>
										</xsl:call-template>:</span>
										<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/CompanyName"/></span>
										<div>
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-vat-no'"/>
											</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/EUVAT"/></span>
										</div><span style="white-space: nowrap;">Year of placing on the EU Market: <xsl:value-of select="POM/Year"/></span>
										<br/>
									</xsl:when>
									<xsl:otherwise>
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-pom-label'"/>
										</xsl:call-template>:</span>
										<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/CompanyName"/></span>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEURepresentativeName"/></span>
										</div>
										<div><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEURepresentativeVAT"/></span>
										</div><div> <span>Year of export: <xsl:value-of select="POM/Year"/></span></div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-country'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEUCountryOfEstablishment"/></span>
										</div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-reg-code'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEUDgClimaRegCode"/></span>
										</div>
										<br/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/isEUBased=true()">
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-exp-label'"/>
										</xsl:call-template>:</span>
										<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/CompanyName"/></span>
										<div>
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-vat-no'"/>
											</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/EUVAT"/></span>
										</div><span style="white-space: nowrap;">Year of export of precharged product/equipment: <xsl:value-of select="Exporter/Year"/></span>
									</xsl:when>
									<xsl:otherwise>
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-exp-label'"/>
										</xsl:call-template>:</span>				
										<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/CompanyName"/></span>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEURepresentativeName"/></span>
										</div><div><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEURepresentativeVAT"/></span>
										</div><div> <span>Year of export: <xsl:value-of select="Exporter/Year"/></span></div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-country'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEUCountryOfEstablishment"/></span>
										</div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-reg-code'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12B_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEUDgClimaRegCode"/></span>
										</div>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<xsl:for-each select=".|../../following-sibling::Gas[not(position()>($pagingLimit - 1))]/tr_12B/Transaction[$trPos]">							
								<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/../../GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td class="tdColorBlue num_cell">										
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="Amount"/></xsl:call-template>
										<br/>
										<br/>
										<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Comment"/></xsl:call-template></span>
									</td>
								</xsl:if>
							</xsl:for-each>
						</tr>
					</xsl:for-each>


					<!-- 12aB -->
					<tr>
						<td class="code">12aB</td>
						<td>	  	<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12ab-desc'"/>
						</xsl:call-template></td>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_12aB/SumOfPartnersAmount"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<xsl:for-each select="tr_12aB/Transaction">
						<xsl:variable name="trPos" select="position()"/>
						<tr>
							<td></td>
							<td style="text-align: right;">
								Transaction #<xsl:value-of select="$trPos"/><br/>
								<xsl:choose>
									<xsl:when test="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/isEUBased=true()">
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-pom-label'"/>
										</xsl:call-template>:</span>
										<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/CompanyName"/></span>
										<div>
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-vat-no'"/>
											</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/EUVAT"/></span>
										</div><span style="white-space: nowrap;">Year of placing on the EU Market: <xsl:value-of select="POM/Year"/></span>
										<br/>
									</xsl:when>
									<xsl:otherwise>
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-pom-label'"/>
										</xsl:call-template>:</span>
										<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/CompanyName"/></span>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEURepresentativeName"/></span>
										</div>
										<div><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEURepresentativeVAT"/></span>
										</div><div> <span>Year of export: <xsl:value-of select="POM/Year"/></span></div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-country'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEUCountryOfEstablishment"/></span>
										</div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-reg-code'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/POM/TradePartnerID]/NonEUDgClimaRegCode"/></span>
										</div>
										<br/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/isEUBased=true()">
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-exp-label'"/>
										</xsl:call-template>:</span>
										<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/CompanyName"/></span>
										<div>
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-vat-no'"/>
											</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/EUVAT"/></span>
										</div><span style="white-space: nowrap;">Year of export of precharged product/equipment: <xsl:value-of select="Exporter/Year"/></span>
									</xsl:when>
									<xsl:otherwise>
										<span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'tr-12a-exp-label'"/>
										</xsl:call-template>:</span>				
										<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/CompanyName"/></span>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEURepresentativeName"/></span>
										</div><div><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:
											<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEURepresentativeVAT"/></span>
										</div><div> <span>Year of export: <xsl:value-of select="Exporter/Year"/></span></div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-country'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEUCountryOfEstablishment"/></span>
										</div>
										<div>
											<span><xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'trading-partner-reg-code'"/>
											</xsl:call-template>:</span>
											<span class="bold"><xsl:value-of select="../../../tr_12aB_TradePartners/Partner[./PartnerId = current()/Exporter/TradePartnerID]/NonEUDgClimaRegCode"/></span>
										</div>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<xsl:for-each select=".|../../following-sibling::Gas[not(position()>($pagingLimit - 1))]/tr_12aB/Transaction[$trPos]">							
								<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/../../GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td class="tdColorBlue num_cell">										
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="Amount"/></xsl:call-template>
										<br/>
										<br/>
										<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Comment"/></xsl:call-template></span>
									</td>
								</xsl:if>
							</xsl:for-each>
						</tr>
					</xsl:for-each>

					<!-- 12bB -->
					<tr>
						<td class="code">12bB</td>
						<td>	  	<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12bb-desc'"/>
						</xsl:call-template><span class="formula"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12bb-formula'"/>
						</xsl:call-template></span></td>

						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="Totals/tr_12bB"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<!-- 12cB -->
					<tr>
						<td class="code">12cB</td>
						<td>	  	<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12cb-desc'"/>
						</xsl:call-template><span class="formula"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12cb-formula'"/>
						</xsl:call-template></span></td>

						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="Totals/tr_12cB"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<!-- 12Ca -->
					<tr>
						<td class="code">12Ca</td>
						<td>	  	<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12ca-desc'"/>
						</xsl:call-template><span class="formula"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12ca-formula'"/>
						</xsl:call-template></span></td>

						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="Totals/tr_12Ca"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<!-- 12C -->
					<tr>
						<td class="code">12C</td>
						<td>	  	<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12c-desc'"/>
						</xsl:call-template><span class="formula"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-12c-formula'"/>
						</xsl:call-template></span></td>

						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="Totals/tr_12C"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<!-- 12 Disclaimer -->
					<tr>
						<td colspan="30">
							<span class="bold">Disclaimer</span>
							<span>	<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-12-disclaimer'"/>
							</xsl:call-template>
							</span>
						</td>
					</tr>
				</tbody></table>
		</xsl:if>

		<xsl:if test="$section = 1">
			<span class="bold tablePaginationNrColor" >(<xsl:value-of select="ceiling(position() div $pagingLimit)" />/<xsl:value-of select="ceiling(count(../Gas) div $pagingLimit)" /> )</span>
			<table   class="tableSizeLimit table table-hover table-bordered">
				<tbody  class="boldSpan">
					<tr class="boldHeading">
						<th class="firstTh"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'sheet-transactions-header'"/>
						</xsl:call-template></th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th class="gasTh">
								<xsl:call-template name="getGas"><xsl:with-param name="elem" select="../../ReportedGases[./GasId = current()/GasCode]/Name"/></xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr class="boldHeading no-wrap">
						<th/>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th class="textCenter sidePadding">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'common'"/>
								</xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr>
						<th>
							<span>1A : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01a-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01A/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					
					<tr>
						<th>
							<span>1Aa : </span>
							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01aa-desc'"/>
							</xsl:call-template>
							
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01Aa/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					
					<tr>
						<th>
							<span class="padding-left-1em">1A_a : </span>
							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01a_a-desc'"/>
							</xsl:call-template>
							<br/><span class="formula padding-left-1em">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'tr-01a_a-formula'"/>
								</xsl:call-template>
							</span>
							
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:if test="tr_01A_a/Amount!=''">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01A_a/Amount"/></xsl:call-template>
								</xsl:if>
								<xsl:if test="tr_01A_a/Amount=''">
									
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="'0.000'"/></xsl:call-template>
								</xsl:if>
							</td>
						</xsl:for-each>
					</tr>
					
					<tr>
						<th>
							<span class="padding-left-2em">1A_a_own : </span>
							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01a_a_own-desc'"/>
							</xsl:call-template>
							
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01A_a_own/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					
					<tr>
						<th>
							<span class="padding-left-2em">1A_a_other : </span>
							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01a_a_other-desc'"/>
							</xsl:call-template>
							
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
							
							</td>
						</xsl:for-each>
					</tr>
					<xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
					<xsl:for-each select="../tr_01A_a_other_ExtDestruction/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="padding-left-2em tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-2em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-2em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
																				<br/><span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:<xsl:value-of select="NonEURepresentativeVAT"/></span>
									</div>
								</xsl:if>

							</td>
							<xsl:for-each select="$gases/tr_01A_a_other/TradePartner[TradePartnerID = $partnerId]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
								</td>
							</xsl:for-each>

						</tr>
					</xsl:for-each>
					
					
					<tr>
						<th class="padding-left-1em">
							<span>1Ab : </span>
							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01ab-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'tr-01ab-formula'"/>
								</xsl:call-template>
							</span>
							
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01Ab/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					
					<tr>
						<th class="padding-left-1em">
							<span>1B : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01b-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<span><xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01B/Amount"/></xsl:call-template></span>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_01B/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>1C : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01c-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01C/SumOfPartnerAmounts"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
					<xsl:for-each select="../tr_01C_TradePartners/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="padding-left-1em tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
											<div><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:
										<span><xsl:value-of select="NonEURepresentativeVAT"/></span></div>
									</div>
								</xsl:if>

							</td>
							<xsl:for-each select="$gases/tr_01C/TradePartner[TradePartnerID = $partnerId ]">
								<td  class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
								</td>
							</xsl:for-each>

						</tr>
					</xsl:for-each>
					<tr>
						<th  class="padding-left-1em">
							<span>1D : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01d-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01d-formula'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td  class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01D/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>1E : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01e-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01e-formula'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td  class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01E/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					
					<!--<tr>
						<th class="padding-left-1em">
							<span>1A_fs : </span>
							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01a_fs-desc'"/>
							</xsl:call-template>
							
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01A_fs/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>-->
					
					<tr>
						<th class="padding-left-1em">
							<span>1C_a (formerly 1A_fs) : </span>
							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01a_fs-desc'"/>
							</xsl:call-template>
							
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
							</td>
						</xsl:for-each>
						
					</tr>
					<xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
					
					<xsl:for-each select="../tr_01A_fs_Countries/*">
						<xsl:variable name="countryId" select="CountryId" />
						<tr> 
							
							<td class="padding-left-1em">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'countryFeedstockUse'"/>
									
								</xsl:call-template>
								
								<span>: <xsl:call-template name="formatValue"><xsl:with-param name="num"  
									select="CountryName"/></xsl:call-template> </span>
								
							</td>
							
							

							<xsl:for-each select="$gases">
								<xsl:variable name="getGasGroup"><xsl:value-of select="../../ReportedGases[./GasId = current()/GasCode]/GasGroup" /></xsl:variable>
								
								<xsl:if test="$getGasGroup = 'HFCs' and ../../GeneralReportData/Activities/P-HFC = 'true' ">
									<td  class="num_cell">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01A_fs/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/></xsl:call-template>
										<br/>
										<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_01A_fs/CountrySpecific/Country[CountryId = $countryId]/Comment/text()"/></xsl:call-template></span>
									</td>
								</xsl:if>
								<xsl:if test=" $getGasGroup != 'HFCs' or ../../GeneralReportData/Activities/P-HFC != 'true' ">
									<td  class="total">
									</td>
								</xsl:if>
							</xsl:for-each>	
							
							
							<!-- -->
						</tr>
						
					</xsl:for-each>
					
					<tr>
						<th class="padding-left-2em">
							<span>1C_a1 (formerly 1A_fs1) : </span>
							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01a_fs1-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'tr-01a_fs1-subtitle'"/>
								</xsl:call-template>
							</span>
							
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
							</td>
						</xsl:for-each>
						
					</tr>
					<xsl:for-each select="../tr_01A_fs_Countries/*">
						<xsl:variable name="countryId" select="CountryId" />
						<tr> 
							
							<td class="padding-left-2em">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'countryFeedstockUse'"/>
									
								</xsl:call-template>
								
								<span>: <xsl:call-template name="formatValue"><xsl:with-param name="num"  
									select="CountryName"/></xsl:call-template> </span>
								
							</td>
							
							<xsl:for-each select="$gases">
								<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfc23(current()/GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td  class="num_cell">
										
										
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01A_fs1/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/></xsl:call-template>
									</td>
								</xsl:if>
								<xsl:if test="$isHfc != true()">
									<td  class="total">
									</td>
								</xsl:if>
							</xsl:for-each>
							
							
							<!-- -->
						</tr>
						
					</xsl:for-each>
					
						
					<tr>
						<th class="padding-left-2em">
							<span>1C_a2 (formerly 1A_fs2) : </span>
							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01a_fs2-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'tr-01a_fs2-subtitle'"/>
								</xsl:call-template>
							</span>
							<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'tr-01a_fs2-formula'"/>
								</xsl:call-template>
							</span>
							
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
							</td>
						</xsl:for-each>
						
						
					</tr>
					
					
					<xsl:for-each select="../tr_01A_fs_Countries/*">
						<xsl:variable name="countryId" select="CountryId" />
						<tr> 
							
							<td class="padding-left-2em">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'countryFeedstockUse'"/>
									
								</xsl:call-template>
								
								<span>: <xsl:call-template name="formatValue"><xsl:with-param name="num"  
									select="CountryName"/></xsl:call-template> </span>
								
							</td>
							<!--<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">-->
						
							<xsl:for-each select="$gases">
							
								<xsl:variable name="isHfc23"><xsl:value-of select="fgas:isHfc23(current()/GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc23= true()">
									<td  class="total">
										
										
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01A_fs2/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/></xsl:call-template>
									</td>
								</xsl:if>
								<xsl:if test="$isHfc23 != true()">
									<td  class="total">
									</td>
								</xsl:if>
							</xsl:for-each>
							
							
							
							<!-- -->
						</tr>
						
					</xsl:for-each>
					<tr>
						<th class="padding-left-1em">
							<span>1C_b (formerly 1A_ex) : </span>
							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01a_ex-desc'"/>
							</xsl:call-template>
							
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01A_ex/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>

					<tr>
						<th>
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'voluntary-reporting-mixtures'"/>
									<xsl:with-param name="labelPath" select="'sheet1'"/>
								</xsl:call-template>
							</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td/>
						</xsl:for-each>
					</tr>
					
					<tr>
						<th >
							<span>1F : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01f-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01F/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th  class="padding-left-1em">
							<span>1G : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01g-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01G/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th  class="padding-left-1em">
							<span>1H : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01h-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01h-formula'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01H/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>

					<tr>
						<th>
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'voluntary-reporting'"/>
									<xsl:with-param name="labelPath" select="'sheet2'"/>
								</xsl:call-template>
							</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td/>
						</xsl:for-each>
					</tr>

					<tr>
						<th >
							<span>1I : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01i-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01I/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>1J : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01j-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td  class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01J/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>1K : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01k-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-01k-formula'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td  class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_01K/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
				</tbody>
			</table>
		</xsl:if>

		<!-- Section 2 -->

		<xsl:if test="$section = 2">
			<span class="bold tablePaginationNrColor" >(<xsl:value-of select="ceiling(position() div $pagingLimit)" />/<xsl:value-of select="ceiling(count(../Gas) div $pagingLimit)" /> )</span>
			<table style="width: 37em;"  class="table table-hover table-bordered">
				<tbody  class="boldSpan">
					<tr class="boldHeading">
						<th class="firstTh"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'sheet-transactions-header'"/>
						</xsl:call-template></th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th class="gasTh">
								<xsl:call-template name="getGas"><xsl:with-param name="elem" select="../../ReportedGases[./GasId = current()/GasCode]/Name"/></xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr class="boldHeading no-wrap">
						<th/>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th class="textCenter sidePadding">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'common'"/>
								</xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr>
						<th>
							<span>2A : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-02a-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_02A/totalAmountForRow"/></xsl:call-template>
							</td>
						</xsl:for-each>
					 </tr>
                  <xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
    				
			 <xsl:for-each select="../tr_02A_Countries/*">
                        <xsl:variable name="countryId" select="CountryId" />
                 <tr> 
                        <td>
						  	<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'countryImportedOf'"/>
							</xsl:call-template>
						  
						   <span>: <xsl:call-template name="formatValue"><xsl:with-param name="num"  
                            select="CountryName"/></xsl:call-template> </span>
                            
                        </td>

						 <xsl:for-each select="$gases">
							 <xsl:variable name="isHfc">
								 <xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
							 </xsl:variable>
							 <xsl:variable name="className">
								 <xsl:choose>
									 <xsl:when test="$isHfc = true()">num_cell</xsl:when>
									 <xsl:otherwise>total</xsl:otherwise>
								 </xsl:choose>
							 </xsl:variable>


							 <td class="{$className}">
								 <xsl:if test="$isHfc = true()">
									 <xsl:call-template name="formatValue">
										 <xsl:with-param name="num" select="tr_02A/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/>
									 </xsl:call-template>
								 </xsl:if>
							 </td>
						 </xsl:for-each>

					 <!-- -->
                </tr>
                        
				</xsl:for-each>


					<!--2B Start -->
                  
					<tr>
						<th class="padding-left-1em">
							<span>2B : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-02b-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_02B/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_02B/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
                  
           
              <!--2C Start -->
                <tr>
						<th class="padding-left-1em">
							<span>2C : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-02c-desc'"/>
							</xsl:call-template>
							<br/><span>Totals</span>
						</th>
                      <xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_02C/totalAmountForRow"/></xsl:call-template>
							</td>
						</xsl:for-each>
						
					 </tr>
                  
                  <xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
                 
               
    				
			 <xsl:for-each select="../tr_02A_Countries/*">
                        <xsl:variable name="countryId" select="CountryId" />
                 <tr> 
                        <td>
						  	<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'countryImportedOf'"/>
							</xsl:call-template>
						  
						   <span>: <xsl:call-template name="formatValue"><xsl:with-param name="num"  
                            select="CountryName"/></xsl:call-template> </span>
                            
                        </td>

					 <xsl:for-each select="$gases">
						 <xsl:variable name="isHfc">
							 <xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
						 </xsl:variable>
						 <xsl:variable name="className">
							 <xsl:choose>
								 <xsl:when test="$isHfc = true()">num_cell</xsl:when>
								 <xsl:otherwise>total</xsl:otherwise>
							 </xsl:choose>
						 </xsl:variable>


						 <td class="{$className}">
							 <xsl:if test="$isHfc = true()">
								 <xsl:call-template name="formatValue">
									 <xsl:with-param name="num" select="tr_02C/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/>
								 </xsl:call-template>
							 </xsl:if>
						 </td>
					 </xsl:for-each>



					 <!-- -->
                </tr>
                        
				</xsl:for-each>

                    
                  
              <!--2C End -->           
                  
                      
              <!--2D Start -->
                <tr>
					<th class="padding-left-1em">
						<span>2D : </span>

						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'tr-02d-desc'"/>
						</xsl:call-template>
						<br/><span>Totals</span>
					</th>
                    <xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
						<td class="total">
							<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_02D/totalAmountForRow"/></xsl:call-template>
						</td>
					</xsl:for-each>
						
				</tr>
                  
                <xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />

					<xsl:for-each select="../tr_02A_Countries/*">
						<xsl:variable name="countryId" select="CountryId" />
						<tr>
							<td>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'countryImportedOf'"/>
								</xsl:call-template>
								<span>
									:
									<xsl:call-template name="formatValue">
										<xsl:with-param name="num" select="CountryName"/>
									</xsl:call-template>
								</span>
							</td>


							<xsl:for-each select="$gases">
								<xsl:variable name="isHfc">
									<xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
								</xsl:variable>
								<xsl:variable name="className">
									<xsl:choose>
										<xsl:when test="$isHfc = true()">num_cell</xsl:when>
										<xsl:otherwise>total</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>


								<td class="{$className}">
									<xsl:if test="$isHfc = true()">
										<xsl:call-template name="formatValue">
											<xsl:with-param name="num" select="tr_02D/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/>
										</xsl:call-template>
										<br/>
										<br/>
										<span class="comment">
											<xsl:call-template name="getValue">
												<xsl:with-param name="elem" select="tr_02D/CountrySpecific/Country[CountryId = $countryId]/Comment/text()"/>
											</xsl:call-template>
										</span>
									</xsl:if>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>

              <!--2D End -->
                  
                      
              <!--2E Start -->
                <tr>
						<th class="padding-left-1em">
							<span>2E : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-02e-desc'"/>
							</xsl:call-template>
							<br/><span>Totals</span>
						</th>
                      <xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_02E/totalAmountForRow"/></xsl:call-template>
							</td>
						</xsl:for-each>
						
					 </tr>
                  
                  <xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
                 
               
    				
			 <xsl:for-each select="../tr_02A_Countries/*">
                        <xsl:variable name="countryId" select="CountryId" />
				 <tr>
					 <td>
						 <xsl:call-template name="getLabel">
							 <xsl:with-param name="labelName" select="'countryImportedOf'"/>
						 </xsl:call-template>
						 <span>
							 :
							 <xsl:call-template name="formatValue">
								 <xsl:with-param name="num" select="CountryName"/>
							 </xsl:call-template>
						 </span>
					 </td>


					 <xsl:for-each select="$gases">
						 <xsl:variable name="isHfc">
							 <xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
						 </xsl:variable>
						 <xsl:variable name="className">
							 <xsl:choose>
								 <xsl:when test="$isHfc = true()">num_cell</xsl:when>
								 <xsl:otherwise>total</xsl:otherwise>
							 </xsl:choose>
						 </xsl:variable>


						 <td class="{$className}">
							 <xsl:if test="$isHfc = true()">
								 <xsl:call-template name="formatValue">
									 <xsl:with-param name="num" select="tr_02E/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/>
								 </xsl:call-template>
							 </xsl:if>
						 </td>
					 </xsl:for-each>
				 </tr>


			 </xsl:for-each>

                    
                  
              <!--2E End -->

			<!--2App Start -->
					<tr>
						<th class="padding-left-1em">
							<span>2F (formerly 2A_pp) : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-02app-desc'"/>
							</xsl:call-template>
							<br/>
							<span>Totals</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue">
									<xsl:with-param name="num" select="tr_02App/totalAmountForRow"/>
								</xsl:call-template>
							</td>
						</xsl:for-each>

					</tr>

					<xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />



					<xsl:for-each select="../tr_02A_Countries/*">
						<xsl:variable name="countryId" select="CountryId" />
						<tr>
							<td>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'countryImportedOf'"/>
								</xsl:call-template>

								<span>
									: <xsl:call-template name="formatValue">
										<xsl:with-param name="num"
                            select="CountryName"/>
									</xsl:call-template>
								</span>

							</td>

							<xsl:for-each select="$gases">
								<xsl:variable name="isHfc">
									<xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
								</xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td  class="num_cell">
										<span>
											<xsl:call-template name="formatValue">
												<xsl:with-param name="num" select="tr_02App/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/>
											</xsl:call-template>
										</span>
										<br/>
										<br/>
										<span class="comment">
											<xsl:call-template name="getValue">
												<xsl:with-param name="elem" select="tr_02App/CountrySpecific/Country[CountryId = $countryId]/Comment"/>
											</xsl:call-template>
										</span>
									</td>
								</xsl:if>
								<xsl:if test="$isHfc != true()">
									<td  class="total">
									</td>
								</xsl:if>
							</xsl:for-each>


							<!-- -->
						</tr>

					</xsl:for-each>



					<!--2App End -->
                  
				  <!--2G Start -->
                  <tr>
						<th>
							<span>2G : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-02g-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_02G/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>

			  <!--2G End -->

			  <!--2H Start -->
					<tr>
						<th>
							<span>2H : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-02h-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_02H/SumOfPartnerAmounts"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
					<xsl:for-each select="../tr_02H_TradePartners/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
											<div><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:
										<span><xsl:value-of select="NonEURepresentativeVAT"/></span></div>
									</div>
								</xsl:if>

							</td>
							<xsl:for-each select="$gases/tr_02H/TradePartner[TradePartnerID = $partnerId ]">
								<td  class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
								</td>
							</xsl:for-each>

						</tr>
					</xsl:for-each>

			  <!--2H End -->

			  <!--2I Start -->
					<tr>
						<th>
							<span>2I : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-02i-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_02I/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_02I/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>

			  <!--2I End -->

				</tbody>
			</table>
		</xsl:if>

		<!-- Section 3 -->

		<xsl:if test="$section = 3">
			<span class="bold tablePaginationNrColor" >(<xsl:value-of select="ceiling(position() div $pagingLimit)" />/<xsl:value-of select="ceiling(count(../Gas) div $pagingLimit)" /> )</span>
			<table  class="tableSizeLimit table table-hover table-bordered">
				<tbody  class="boldSpan">
					<tr class="boldHeading">
						<th class="firstTh"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'sheet-transactions-header'"/>
						</xsl:call-template></th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th class="gasTh">
								<xsl:call-template name="getGas"><xsl:with-param name="elem" select="../../ReportedGases[./GasId = current()/GasCode]/Name"/></xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr class="boldHeading no-wrap">
						<th/>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th class="textCenter sidePadding">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'common'"/>
								</xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr>
						<th>
							<span>3A : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-03a-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_03A/totalAmountForRow"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr> 
                  
                  <xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
                 
                   <xsl:for-each select="../tr_03A_Countries/*">
                        <xsl:variable name="countryId" select="CountryId" />
						<tr> 
								<td>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'countryExportedOf'"/>
									</xsl:call-template>
									
									<span>: <xsl:call-template name="formatValue"><xsl:with-param name="num"  
										select="CountryName"/></xsl:call-template> </span>
										
								</td>
								<xsl:for-each select="$gases">
									<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
									<xsl:if test="$isHfc = true()">
											<td  class="num_cell">
										
																						
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_03A/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/></xsl:call-template>
											</td>
									</xsl:if>
									<xsl:if test="$isHfc != true()">
											<td  class="total">
											</td>
									</xsl:if>
								</xsl:for-each>
								<!-- -->
							</tr>
                        
					</xsl:for-each>
                  <!-- 3A end -->
                  
                  
                         
              <!--3App Start -->
                <tr>
						<th>
							<span>3J (formerly 3A_pp) : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-03app-desc'"/>
							</xsl:call-template>
							<br/><span>Totals</span>
						</th>
                      <xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_03App/totalAmountForRow"/></xsl:call-template>
							</td>
						</xsl:for-each>
						
					 </tr>
                  
                  <xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
                 
               
    				
			 <xsl:for-each select="../tr_03A_Countries/*">
                        <xsl:variable name="countryId" select="CountryId" />
                 <tr> 
                        <td>
						  	<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'countryExportedOf'"/>
							</xsl:call-template>
						  
						   <span>: <xsl:call-template name="formatValue"><xsl:with-param name="num" select="CountryName"/></xsl:call-template> </span>
                            
                        </td>						
                        <xsl:for-each select="$gases">
                          <xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
						   <xsl:if test="$isHfc = true()">
								<td  class="num_cell">
									<span><xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_03App/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/></xsl:call-template></span>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_03App/CountrySpecific/Country[CountryId = $countryId]/Comment"/></xsl:call-template></span>
								</td>
                           </xsl:if>
                           <xsl:if test="$isHfc != true()">
                                <td  class="total">
								</td>
                           </xsl:if>
						</xsl:for-each>                                 
                    <!-- -->
                </tr>
                        
				</xsl:for-each>

                    
                  
              <!--3App End -->
                  
                  
                  
					<tr>
						<th class="padding-left-1em">
							<span>3B : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-03b-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_03B/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>3C : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-03c-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param
										name="labelName" select="'tr-03c-formula'"/>
							</xsl:call-template>
						</span>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_03C/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					
              <!--3G Start -->
                <tr>
						<th>
							<span>3G : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-03g-desc'"/>
							</xsl:call-template>
							<br/><span>Totals</span>
						</th>
                      <xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_03G/totalAmountForRow"/></xsl:call-template>
							</td>
						</xsl:for-each>
						
					 </tr>
                  
                  <xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
                 
               
    				
			 <xsl:for-each select="../tr_03A_Countries/*">
                        <xsl:variable name="countryId" select="CountryId" />
                 <tr> 
                        <td>
						  	<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'countryExportedOf'"/>
							</xsl:call-template>
						  
						   <span>: <xsl:call-template name="formatValue"><xsl:with-param name="num" select="CountryName"/></xsl:call-template> </span>
                            
                        </td>
                  
                        <xsl:for-each select="$gases">
                          <xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
						   <xsl:if test="$isHfc = true()">
                                <td  class="num_cell">
                            
                                                                               
                            	<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_03G/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/></xsl:call-template>
								</td>
                           </xsl:if>
                           <xsl:if test="$isHfc != true()">
                                 <td  class="total">
								</td>
                           </xsl:if>
						</xsl:for-each>
                    
                
                    <!-- -->
                </tr>
                        
				</xsl:for-each>

                    
                  
              <!--3G End -->
                  
                  <!--3H Start -->
                <tr>
						<th>
							<span>3H : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-03h-desc'"/>
							</xsl:call-template>
							<br/><span>Totals</span>
						</th>
                      <xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_03H/totalAmountForRow"/></xsl:call-template>
							</td>
						</xsl:for-each>
						
					 </tr>
                  
                  <xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
                 
               
    				
			 <xsl:for-each select="../tr_03A_Countries/*">
                        <xsl:variable name="countryId" select="CountryId" />
                 <tr> 
                        <td>
						  	<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'countryExportedOf'"/>
							</xsl:call-template>
						  
						   <span>: <xsl:call-template name="formatValue"><xsl:with-param name="num" select="CountryName"/></xsl:call-template> </span>
                            
                        </td>
                  
                        <xsl:for-each select="$gases">
                          <xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
						   <xsl:if test="$isHfc = true()">
                                <td  class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_03H/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/></xsl:call-template>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_03H/CountrySpecific/Country[CountryId = $countryId]/Comment/text()"/></xsl:call-template></span>
								</td>
                           </xsl:if>
                           <xsl:if test="$isHfc != true()">
                                 <td  class="total">
								</td>
                           </xsl:if>
						</xsl:for-each>
                    
                
                    <!-- -->
                </tr>
                        
				</xsl:for-each>

                    
                  
              <!--3H End -->
                  <!--3I Start -->
                <tr>
						<th>
							<span>3I : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-03i-desc'"/>
							</xsl:call-template>
							<br/><span>Totals</span>
						</th>
                      <xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_03I/totalAmountForRow"/></xsl:call-template>
							</td>
						</xsl:for-each>
						
					 </tr>
                  
                  <xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
                 
               
    				
			 <xsl:for-each select="../tr_03A_Countries/*">
                        <xsl:variable name="countryId" select="CountryId" />
                 <tr> 
                        <td>
						  	<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'countryExportedOf'"/>
							</xsl:call-template>
						  
						   <span>: <xsl:call-template name="formatValue"><xsl:with-param name="num" select="CountryName"/></xsl:call-template> </span>
                            
                        </td>
                  
                        <xsl:for-each select="$gases">
                          <xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
						   <xsl:if test="$isHfc = true()">
                                <td  class="num_cell">
                            
                                                                               
                            	<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_03I/CountrySpecific/Country[CountryId = $countryId]/Amount/text()"/></xsl:call-template>
								</td>
                           </xsl:if>
                           <xsl:if test="$isHfc != true()">
                                 <td  class="total">
								</td>
                           </xsl:if>
						</xsl:for-each>
                    
                
                    <!-- -->
                </tr>
                        
				</xsl:for-each>

                    
                  
              <!--3I End -->
                  
                  
                  
				</tbody>
			</table>
		</xsl:if>

		<!-- Section 4 -->

		<xsl:if test="$section = 4">
			<span class="bold tablePaginationNrColor" >(<xsl:value-of select="ceiling(position() div $pagingLimit)" />/<xsl:value-of select="ceiling(count(../Gas) div $pagingLimit)" /> )</span>
			<table   class="tableSizeLimit table table-hover table-bordered">
				<tbody  class="boldSpan">
					<tr class="boldHeading">
						<th class="firstTh"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'sheet-transactions-header'"/>
						</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th class="gasTh">
								<xsl:call-template name="getGas"><xsl:with-param name="elem" select="../../ReportedGases[./GasId = current()/GasCode]/Name"/></xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr class="boldHeading no-wrap">
						<th/>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th class="textCenter sidePadding">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'common'"/>
								</xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>4A : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04a-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04A/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_04A/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>4Aa : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04Aa-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04Aa/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_04Aa/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th  class="padding-left-1em">
							<span>4B : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04b-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04B/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_04B/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th  class="padding-left-2em">
							<span>4C : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04c-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04C/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_04C/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th  class="padding-left-2em">
							<span>4D : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04d-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04d-formula'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04D/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>4E : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04e-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04e-formula'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04E/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th>
							<span>4F : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04f-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04F/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>4Fa : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04fa-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04Fa/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th  class="padding-left-1em">
							<span>4G : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04g-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04G/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_04G/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th  class="padding-left-2em">
							<span>4H : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04h-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04H/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_04H/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th  class="padding-left-2em">
							<span>4I : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04i-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04i-formula'"/>
							</xsl:call-template>
						</span>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04I/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th  class="padding-left-1em">
							<span>4J : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04j-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04j-formula'"/>
							</xsl:call-template>
						</span>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04J/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th>
							<span>4K : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04k-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04K/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th>
							<span>4M : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04m-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-04m-formula'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_04M/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
				</tbody>
			</table>
		</xsl:if>

		<!-- Section 5 -->

		<xsl:if test="$section = 5">
			<span class="bold tablePaginationNrColor" >(<xsl:value-of select="ceiling(position() div $pagingLimit)" />/<xsl:value-of select="ceiling(count(../Gas) div $pagingLimit)" /> )</span>
			<table  class="tableSizeLimit table table-hover table-bordered">
				<tbody  class="boldSpan">
					<xsl:variable name="gases" select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]" />
					<tr class="boldHeading">
						<th class="firstTh"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'sheet-transactions-header'"/>
						</xsl:call-template></th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<th class="gasTh">
									<xsl:call-template name="getGas"><xsl:with-param name="elem" select="../../ReportedGases[./GasId = current()/GasCode]/Name"/></xsl:call-template>
								</th>
							</xsl:if>
						</xsl:for-each>
					</tr>
					<tr class="boldHeading no-wrap">
						<th/>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<th class="textCenter sidePadding">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'common'"/>
									</xsl:call-template>
								</th>
							</xsl:if>
						</xsl:for-each>
					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>5A : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05a-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_05A/SumOfPartnerAmounts"/></xsl:call-template>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_05A/Comment"/></xsl:call-template></span>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<xsl:for-each select="../tr_05A_TradePartners/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="padding-left-1em tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
										<br/><span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:<xsl:value-of select="NonEURepresentativeVAT"/></span>
									</div>
								</xsl:if>
							</td>

							<xsl:for-each select="$gases/tr_05A/TradePartner[TradePartnerID = $partnerId ]">
								<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/../../GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td class="num_cell">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
										<br/>
										<br/>
										<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Comment"/></xsl:call-template></span>
									</td>
								</xsl:if>
							</xsl:for-each>

						</tr>
					</xsl:for-each>
					<tr>
						<th class="padding-left-1em">
							<span>5B : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05b-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_05B/SumOfPartnerAmounts"/></xsl:call-template>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_05B/Comment"/></xsl:call-template></span>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<xsl:for-each select="../tr_05B_TradePartners/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="padding-left-1em tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
										<br/><span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:<xsl:value-of select="NonEURepresentativeVAT"/></span>
									</div>
								</xsl:if>

							</td>

							<xsl:for-each select="$gases/tr_05B/TradePartner[TradePartnerID = $partnerId ]">
								<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/../../GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td class="num_cell">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
										<br/>
										<br/>
										<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Comment"/></xsl:call-template></span>
									</td>
								</xsl:if>
							</xsl:for-each>

						</tr>
					</xsl:for-each>
					<tr>
						<th class="padding-left-1em">
							<span>5C_exempted : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05c-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_05C/SumOfPartnerAmounts"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<xsl:for-each select="../tr_05C_TradePartners/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="padding-left-1em tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
																				<br/><span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:<xsl:value-of select="NonEURepresentativeVAT"/></span>
									</div>
								</xsl:if>

							</td>

							<xsl:for-each select="$gases/tr_05C/TradePartner[TradePartnerID = $partnerId ]">
								<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/../../GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td class="num_cell">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
										<br/>
										<br/>
										<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Comment"/></xsl:call-template></span>
									</td>
								</xsl:if>
							</xsl:for-each>

						</tr>
					</xsl:for-each>
					<tr>
						<th class="padding-left-1em">
							<span>5D : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05d-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_05D/SumOfPartnerAmounts"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>
					<xsl:for-each select="../tr_05D_TradePartners/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="padding-left-1em tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
																				<br/><span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:<xsl:value-of select="NonEURepresentativeVAT"/></span>
									</div>
								</xsl:if>

							</td>

							<xsl:for-each select="$gases/tr_05D/TradePartner[TradePartnerID = $partnerId ]">
								<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/../../GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td class="num_cell">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
									</td>
								</xsl:if>
							</xsl:for-each>

						</tr>
					</xsl:for-each>
					<tr>
						<th class="padding-left-1em">
							<span>5E : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05e-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_05E/SumOfPartnerAmounts"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>
					<xsl:for-each select="../tr_05E_TradePartners/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="padding-left-1em tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
																				<br/><span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:<xsl:value-of select="NonEURepresentativeVAT"/></span>
									</div>
								</xsl:if>

							</td>

							<xsl:for-each select="$gases/tr_05E/TradePartner[TradePartnerID = $partnerId ]">
								<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/../../GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td class="num_cell">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
									</td>
								</xsl:if>
							</xsl:for-each>

						</tr>
					</xsl:for-each>
					<tr>
						<th class="padding-left-1em">
							<span>5F : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05f-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_05F/SumOfPartnerAmounts"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>
					<xsl:for-each select="../tr_05F_TradePartners/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="padding-left-1em tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
																				<br/><span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:<xsl:value-of select="NonEURepresentativeVAT"/></span>
									</div>
								</xsl:if>

							</td>

							<xsl:for-each select="$gases/tr_05F/TradePartner[TradePartnerID = $partnerId ]">
								<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/../../GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td class="num_cell">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
									</td>
								</xsl:if>
							</xsl:for-each>

						</tr>
					</xsl:for-each>
					<!--
                    <tr>
                        <th class="padding-left-1em">
                            <span>5G : </span>

                            <xsl:call-template name="getLabel">
                                <xsl:with-param name="labelName" select="'tr-05g-desc'"/>
                            </xsl:call-template>
                            <br/><span class="formula">
                            <xsl:call-template name="getLabel">
                                <xsl:with-param name="labelName" select="'tr-05g-formula'"/>
                            </xsl:call-template>
                            </span>
                        </th>
                        <xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
                        	<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
                        	<xsl:if test="$isHfc = true()">
	                            <td class="total">
	                                <xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_05G/Amount"/></xsl:call-template>
	                            </td>
                            </xsl:if>
                        </xsl:for-each>
                    </tr>
                     -->
					<tr>
						<th class="padding-left-1em">
							<span>5H : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05h-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05h-formula'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_05H/Amount"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>5I : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05i-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05i-formula'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_05I/Amount"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>5J : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05j-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05j-formula'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_05J/Amount"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<tr>
						<th>
							<span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'voluntary-reporting'"/>
									<xsl:with-param name="labelPath" select="'sheet2'"/>
								</xsl:call-template>

							</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td/>
							</xsl:if>
						</xsl:for-each>
					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>5C_voluntary : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05r-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" /></xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_05R/SumOfPartnerAmounts"/></xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>
					<xsl:for-each select="../tr_05R_TradePartners/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="padding-left-1em tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
																				<br/><span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:<xsl:value-of select="NonEURepresentativeVAT"/></span>
									</div>
								</xsl:if>

							</td>
							<xsl:for-each select="$gases/tr_05R/TradePartner[TradePartnerID = $partnerId ]">
								<xsl:variable name="isHfc"><xsl:value-of select="fgas:isHfcBased(current()/../../GasCode, /FGasesReporting)" /></xsl:variable>
								<xsl:if test="$isHfc = true()">
									<td class="num_cell">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
									</td>
								</xsl:if>
							</xsl:for-each>

						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>	

		<!-- End of Section 5-->


		<!-- Section 5a -->

		<xsl:if test="$section = 51">
			<span class="bold tablePaginationNrColor" >
				(<xsl:value-of select="ceiling(position() div $pagingLimit)" />/<xsl:value-of select="ceiling(count(../Gas) div $pagingLimit)" /> )
			</span>
			<table class="tableSizeLimit table table-hover table-bordered">
				<tbody class="boldSpan">
					<tr class="boldHeading">
						<th class="firstTh">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'sheet-transactions-header'" />
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc">
								<xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
							</xsl:variable>
							<xsl:if test="$isHfc = true()">
								<th class="gasTh">
									<xsl:call-template name="getGas">
										<xsl:with-param name="elem" select="../../ReportedGases[./GasId = current()/GasCode]/Name" />
									</xsl:call-template>
								</th>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<tr class="boldHeading no-wrap">
						<th />
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc">
								<xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
							</xsl:variable>
							<xsl:if test="$isHfc = true()">
								<th class="textCenter sidePadding">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'" />
										<xsl:with-param name="labelPath" select="'common'" />
									</xsl:call-template>
								</th>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<tr>
						<th>
							<span>5aD : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05aD-desc'" />
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc">
								<xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
							</xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="num_cell">
									<xsl:call-template name="formatValue">
										<xsl:with-param name="num" select="tr_05aD/Amount" />
									</xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<tr>
						<th>
							<span>5aE : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05aE-desc'" />
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc">
								<xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
							</xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="num_cell">
									<xsl:call-template name="formatValue">
										<xsl:with-param name="num" select="tr_05aE/Amount" />
									</xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<tr>
						<th>
							<span>5aF : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-05aF-desc'" />
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc">
								<xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
							</xsl:variable>
							<xsl:if test="$isHfc = true()">
								<td class="num_cell">
									<xsl:call-template name="formatValue">
										<xsl:with-param name="num" select="tr_05aF/Amount" />
									</xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>
					</tr>
				</tbody>
			</table>
		</xsl:if>

		<!-- End of Section 5a -->


		<!-- Section 6 -->

		<xsl:if test="$section = 6">
			<span class="bold tablePaginationNrColor" >(<xsl:value-of select="ceiling(position() div $pagingLimit)" />/<xsl:value-of select="ceiling(count(../Gas) div $pagingLimit)" /> )</span>
			<table   class="tableSizeLimit table table-hover table-bordered">
				<tbody  class="boldSpan">
					<tr class="boldHeading">
						<th class="firstTh"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'sheet-transactions-header'"/>
						</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th class="gasTh">
								<xsl:call-template name="getGas"><xsl:with-param name="elem" select="../../ReportedGases[./GasId = current()/GasCode]/Name"/></xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr class="boldHeading no-wrap">
						<th/>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th class="textCenter sidePadding">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'common'"/>
								</xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6A : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06a-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06A/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6B : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06b-desc'"/>
							</xsl:call-template>

						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06B/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6C : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06c-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06C/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6D : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06d-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06D/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6E : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06e-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06E/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6F : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06f-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06F/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6G : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06g-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06G/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6H : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06h-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06H/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6I : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06i-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06I/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6J : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06j-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06J/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6K : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06k-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06K/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6L : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06l-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06L/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_06L/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6M : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06m-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06M/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6N : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06n-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06N/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6O : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06o-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06O/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6P : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06p-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06P/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6Q : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06q-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06Q/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6R : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06r-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06R/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6S : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06s-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06s-formula'"/>
							</xsl:call-template>
							</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06S/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>6S1 : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06s1-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06S1/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>6S2 : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06s2-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06S2/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6T : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06t-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06T/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_06T/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6U : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06u-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06U/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_06U/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6V : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06v-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06V/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_06V/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6W : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06w-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06w-formula'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06W/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>6X : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06x-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-06x-formula'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_06X/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
				</tbody>
			</table>
		</xsl:if>


		<!-- Section 7 -->

		<xsl:if test="$section = 7">
			<span class="bold tablePaginationNrColor" >(<xsl:value-of select="ceiling(position() div $pagingLimit)" />/<xsl:value-of select="ceiling(count(../Gas) div $pagingLimit)" /> )</span>
			<table   class="tableSizeLimit table table-hover table-bordered">
				<tbody  class="boldSpan">
					<tr class="boldHeading">
						<th class="firstTh"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'sheet-transactions-header'"/>
						</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th class="gasTh">
								<xsl:call-template name="getGas"><xsl:with-param name="elem" select="../../ReportedGases[./GasId = current()/GasCode]/Name"/></xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr class="boldHeading no-wrap">
						<th/>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th  class="textCenter sidePadding">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'common'"/>
								</xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr>
						<th >
							<span>7A : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-07a-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_07A/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_07A/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>7A_a : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-07Aa-desc'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_07Aa/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
				</tbody>
			</table>
		</xsl:if>

		<!-- Section 8 -->

		<xsl:if test="$section = 8">
			<span class="bold tablePaginationNrColor" >(<xsl:value-of select="ceiling(position() div $pagingLimit)" />/<xsl:value-of select="ceiling(count(../Gas) div $pagingLimit)" /> )</span>
			<table style="width: 33em;"  class="table table-hover table-bordered">
				<tbody  class="boldSpan">
					<tr class="hidden">
						<td style="width: 2em;"></td>
						<td style="width: 2em;"></td>
						<td style="width: 2em;"></td>
						<td style="width: 2em;"></td>
					</tr>
					<tr class="boldHeading">
						<th class="firstTh" colspan="4"><xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'sheet-transactions-header'"/>
						</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th class="gasTh">
								<xsl:call-template name="getGas"><xsl:with-param name="elem" select="../../ReportedGases[./GasId = current()/GasCode]/Name"/></xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr class="boldHeading no-wrap">
						<th colspan="4"></th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<th  class="textCenter sidePadding">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'common'"/>
								</xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>

					<tr>
						<th colspan="4">
							<span>8_A : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'parameter'"/>
								<xsl:with-param name="labelPath" select="'tr_8a'"/>
							</xsl:call-template>
							<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_8a'"/>
								</xsl:call-template>
							</span>
						</th>
						
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc">
								<xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$isHfc = true()">
									<td class="total">
										<xsl:call-template name="formatValue">
											<xsl:with-param name="num" select="tr_8A/Amount"/>
										</xsl:call-template>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="num_cell">
										<xsl:call-template name="formatValue">
											<xsl:with-param name="num" select="tr_8A/Amount"/>
										</xsl:call-template>
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</tr>
					<xsl:if test="../UISelectedTransactions/tr_8A1i= 'true' or ../UISelectedTransactions/tr_8A1ii= 'true' or ../UISelectedTransactions/tr_8A1iii= 'true' or 
					../UISelectedTransactions/tr_8A1iv= 'true' or ../UISelectedTransactions/tr_8A1v= 'true' or ../UISelectedTransactions/tr_8A1vi= 'true' or ../UISelectedTransactions/tr_8A1other= 'true'">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_A1 : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8a1'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1i= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_A1_i : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1i'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1i/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1i= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_A1_i_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1ia'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1ia/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1ii= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_A1_ii : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1ii'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1ii/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1ii= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_A1_ii_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1iia'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1iia/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1iii= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_A1_iii : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1iii'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1iii/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1iii= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_A1_iii_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1iiia'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1iiia/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1iv= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_A1_iv : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1iv'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1iv/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1iv= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_A1_iv_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1iva'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1iva/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1v= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_A1_v : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1v'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1v/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1vi= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_A1_vi : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1vi'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1vi/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1other= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_A1_other : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1other'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1other/Amount"/></xsl:call-template>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_8A1other/Comment"/></xsl:call-template></span>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1other= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_A1_other_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a1othera'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A1othera/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A2i= 'true' or ../UISelectedTransactions/tr_8A2ii= 'true' or ../UISelectedTransactions/tr_8A2other= 'true'">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_A2 : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a2'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8a2'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A2/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A2i= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_A2_i : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a2i'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A2i/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A2ii= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_A2_ii : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a2ii'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A2ii/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A2other= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_A2_other : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a2other'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A2other/Amount"/></xsl:call-template>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_8A2other/Comment"/></xsl:call-template></span>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A2other= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_A2_other_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8a2othera'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8A2othera/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8A1i= 'true' or ../UISelectedTransactions/tr_8A1ii= 'true' or ../UISelectedTransactions/tr_8A1iii= 'true' or 
					../UISelectedTransactions/tr_8A1iv= 'true' or ../UISelectedTransactions/tr_8A1other= 'true' or ../UISelectedTransactions/tr_8A2other= 'true' ">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_A_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8aa'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8aa'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Aa/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<tr>
						<th colspan="4">
							<span>8_Ba : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'parameter'"/>
								<xsl:with-param name="labelPath" select="'tr_8ba'"/>
							</xsl:call-template>
							<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_8ba'"/>
								</xsl:call-template>
							</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc">
								<xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$isHfc = true()">
									<td class="total">
										<xsl:call-template name="formatValue">
											<xsl:with-param name="num" select="tr_8Ba/Amount"/>
										</xsl:call-template>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="num_cell">
										<xsl:call-template name="formatValue">
											<xsl:with-param name="num" select="tr_8Ba/Amount"/>
										</xsl:call-template>
									</td>
								</xsl:otherwise>
							</xsl:choose>					</xsl:for-each>
					</tr>
					<xsl:if test="../UISelectedTransactions/tr_8Ba1i= 'true' or ../UISelectedTransactions/tr_8Ba1ii= 'true' or ../UISelectedTransactions/tr_8Ba1iii= 'true'
					or ../UISelectedTransactions/tr_8Ba1other= 'true'">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_Ba1 : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8ba1'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8ba1'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Ba1/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Ba1i= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_Ba1_i : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8ba1i'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Ba1i/Amount"/></xsl:call-template></td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Ba1i= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_Ba1_i_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8ba1ia'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Ba1ia/Amount"/></xsl:call-template></td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Ba1ii= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_Ba1_ii : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8ba1ii'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Ba1ii/Amount"/></xsl:call-template></td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Ba1ii= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_Ba1_ii_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8ba1iia'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Ba1iia/Amount"/></xsl:call-template></td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Ba1iii= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_Ba1_iii : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8ba1iii'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Ba1iii/Amount"/></xsl:call-template></td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Ba1other= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_Ba1_other : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8ba1other'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Ba1other/Amount"/></xsl:call-template>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_8Ba1other/Comment"/></xsl:call-template></span>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Ba1other= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_Ba1_other_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8ba1othera'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Ba1othera/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Ba2other= 'true'">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_Ba2 : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8ba2'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8ba2'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Ba2/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Ba2other= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_Ba2_other : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8ba2other'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Ba2other/Amount"/></xsl:call-template>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_8Ba2other/Comment"/></xsl:call-template></span>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Ba2other= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_Ba2_other_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8ba2othera'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Ba2othera/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Ba1i= 'true' or ../UISelectedTransactions/tr_8Ba1ii= 'true' or 
					../UISelectedTransactions/tr_8Ba1other= 'true' or ../UISelectedTransactions/tr_8Ba2other= 'true' ">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_Ba_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8baa'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8baa'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Baa/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<tr>
						<th colspan="4">
							<span>8_Bb : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'parameter'"/>
								<xsl:with-param name="labelPath" select="'tr_8bb'"/>
							</xsl:call-template>
							<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_8bb'"/>
								</xsl:call-template>
							</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc">
								<xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$isHfc = true()">
									<td class="total">
										<xsl:call-template name="formatValue">
											<xsl:with-param name="num" select="tr_8Bb/Amount"/>
										</xsl:call-template>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="num_cell">
										<xsl:call-template name="formatValue">
											<xsl:with-param name="num" select="tr_8Bb/Amount"/>
										</xsl:call-template>
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</tr>
					<xsl:if test="../UISelectedTransactions/tr_8Bb1i= 'true' or ../UISelectedTransactions/tr_8Bb1ii= 'true' or ../UISelectedTransactions/tr_8Bb1iii= 'true'
					or ../UISelectedTransactions/tr_8Bb1other= 'true'">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_Bb1 : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8bb1'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8bb1'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Bb1/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Bb1i= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_Bb1_i : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8bb1i'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Bb1i/Amount"/></xsl:call-template></td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Bb1i= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_Bb1_i_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8bb1ia'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Bb1ia/Amount"/></xsl:call-template></td>
							</xsl:for-each>
						</tr>
					</xsl:if>

					<xsl:if test="../UISelectedTransactions/tr_8Bb1ii= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_Bb1_ii : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8bb1ii'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Bb1ii/Amount"/></xsl:call-template></td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Bb1ii= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_Bb1_ii_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8bb1iia'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Bb1iia/Amount"/></xsl:call-template></td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Bb1iii= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_Bb1_iii : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8bb1iii'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Bb1iii/Amount"/></xsl:call-template></td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Bb1other= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_Bb1_other : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8bb1other'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Bb1other/Amount"/></xsl:call-template>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_8Bb1other/Comment"/></xsl:call-template></span>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Bb1other= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_Bb1_other_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8bb1othera'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Bb1othera/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Bb2other= 'true'">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_Bb2 : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8bb2'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8bb2'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Bb2/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Bb2other= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_Bb2_other : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8bb2other'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Bb2other/Amount"/></xsl:call-template>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_8Bb2other/Comment"/></xsl:call-template></span>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Bb2other= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_Bb2_other_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8bb2othera'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Bb2othera/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8Bb1i= 'true' or ../UISelectedTransactions/tr_8Bb1ii= 'true' or 
					../UISelectedTransactions/tr_8Bb1other= 'true' or ../UISelectedTransactions/tr_8Bb2other= 'true' ">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_Bb_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8bba'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8bba'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Bba/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<tr>
						<th colspan="4">
							<span>8_C : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'parameter'"/>
								<xsl:with-param name="labelPath" select="'tr_8c'"/>
							</xsl:call-template>
							<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_8c'"/>
								</xsl:call-template>
							</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<xsl:variable name="isHfc">
								<xsl:value-of select="fgas:isHfcBased(current()/GasCode, /FGasesReporting)" />
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$isHfc = true()">
									<td class="total">
										<xsl:call-template name="formatValue">
											<xsl:with-param name="num" select="tr_8C/Amount"/>
										</xsl:call-template>
										<br/>
										<br/>
										<span class="comment">
											<xsl:call-template name="getValue">
												<xsl:with-param name="elem" select="tr_8C/Comment"/>
											</xsl:call-template>
										</span>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="num_cell">
										<xsl:call-template name="formatValue">
											<xsl:with-param name="num" select="tr_8C/Amount"/>
										</xsl:call-template>
										<br/>
										<br/>
										<span class="comment">
											<xsl:call-template name="getValue">
												<xsl:with-param name="elem" select="tr_8C/Comment"/>
											</xsl:call-template>
										</span>
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</tr>
					<xsl:if test="../UISelectedTransactions/tr_8C1other= 'true'">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_C1 : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8c1'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8c1'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8C1/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8C1other= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_C1_other : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8c1other'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8C1other/Amount"/></xsl:call-template>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_8C1other/Comment"/></xsl:call-template></span>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8C1other= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_C1_other_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8c1othera'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8C1othera/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8C2other= 'true'">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_C2 : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8c2'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8c2'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8C2/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8C2other= 'true'">
						<tr>
							<th colspan="2" />
							<th colspan="2">
								<span>8_C2_other : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8c2other'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8C2other/Amount"/></xsl:call-template>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_8C2other/Comment"/></xsl:call-template></span>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8C2other= 'true'">
						<tr>
							<th colspan="3" />
							<th>
								<span>8_C2_other_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8c2othera'"/>
								</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8C2othera/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:if test="../UISelectedTransactions/tr_8C1other= 'true' or ../UISelectedTransactions/tr_8C2other= 'true'">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_C_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8ca'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8ca'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Ca/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<tr>
						<th colspan="4">
							<span>8_D : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'parameter'"/>
								<xsl:with-param name="labelPath" select="'tr_8d'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'formula'"/>
								<xsl:with-param name="labelPath" select="'tr_8d'"/>
							</xsl:call-template>
						</span>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="total">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8D/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
					<xsl:if test="../UISelectedTransactions/tr_8A1i= 'true' or ../UISelectedTransactions/tr_8A1ii= 'true' or ../UISelectedTransactions/tr_8A1iii= 'true' or 
					../UISelectedTransactions/tr_8A1iv= 'true' or ../UISelectedTransactions/tr_8A1v= 'true' or ../UISelectedTransactions/tr_8A1vi= 'true' or 
					../UISelectedTransactions/tr_8A1other= 'true' or ../UISelectedTransactions/tr_8A2i= 'true' or ../UISelectedTransactions/tr_8A2ii= 'true' or 
					../UISelectedTransactions/tr_8A2other= 'true' or ../UISelectedTransactions/tr_8Ba1i= 'true' or ../UISelectedTransactions/tr_8Ba1ii= 'true' or 
					../UISelectedTransactions/tr_8Ba1iii= 'true' or ../UISelectedTransactions/tr_8Ba1other= 'true' or ../UISelectedTransactions/tr_8Ba2other= 'true' or 
					../UISelectedTransactions/tr_8Bb1i= 'true' or ../UISelectedTransactions/tr_8Bb1ii= 'true' or 
					../UISelectedTransactions/tr_8Bb1other= 'true' or ../UISelectedTransactions/tr_8Bb2other= 'true' or ../UISelectedTransactions/tr_8C1other= 'true' or 
					../UISelectedTransactions/tr_8C2other= 'true'">
						<tr>
							<th colspan="1" />
							<th colspan="3">
								<span>8_D_a : </span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_8da'"/>
								</xsl:call-template>
								<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_8da'"/>
									</xsl:call-template>
								</span>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="total">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8Da/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<tr>
						<th colspan="4">
							<span>8_E : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'parameter'"/>
								<xsl:with-param name="labelPath" select="'tr_8e'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8E/Amount"/></xsl:call-template>
								<br/>
								<br/>
								<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="tr_8E/Comment"/></xsl:call-template></span>
							</td>
						</xsl:for-each>
					</tr>
					<tr>
						<th colspan="4">
							<span>8_F : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'parameter'"/>
								<xsl:with-param name="labelPath" select="'tr_8f'"/>
							</xsl:call-template>
						</th>
						<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
							<td class="num_cell">
								<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_8F/Amount"/></xsl:call-template>
							</td>
						</xsl:for-each>
					</tr>
				</tbody>
			</table>
		</xsl:if>

		<!-- Section 11 -->

		<xsl:if test="$section = 11">

			<xsl:if test="(count((../UISelectedTransactions/child::*[. = 'true']) ) >= 1)">
				<span class="bold tablePaginationNrColor" >(<xsl:value-of select="ceiling(position() div $pagingLimit)" />/<xsl:value-of select="ceiling(count(../Gas) div $pagingLimit)" /> )</span>
				<table  class="tdColorBlack tableSizeLimit table table-hover table-bordered section11-table">
					<tbody  class="boldSpan">
						<tr class="hidden">
							<td class="section11Code"/>
							<td class="section11Code"/>

							<td class="" style="width: 2em;"/>
							<td class="section11Explanation"/>

							<td class="section11Amount"/>

							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class=""/>
							</xsl:for-each>
						</tr>
						<tr class="boldHeading">
							<th rowspan="2" colspan="3" class=""><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'code_and_reporting_parameter'"/>
							</xsl:call-template>
							</th>
							<th rowspan="2" class=""><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'reporter_specify_category'"/>
							</xsl:call-template>
							</th>
							<th rowspan="2" class=" "><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'amount_of_importer_equipment'"/>
							</xsl:call-template>
							</th>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<th class="gasTh">
									<xsl:call-template name="getGas"><xsl:with-param name="elem" select="../../ReportedGases[./GasId = current()/GasCode]/Name"/></xsl:call-template>
								</th>
							</xsl:for-each>
						</tr>
						<tr class="boldHeading no-wrap">
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<th  class="textCenter sidePadding">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'common'"/>
									</xsl:call-template>
								</th>
							</xsl:for-each>
						</tr>

						<!-- A --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,6) = 'tr_11A' and . = 'true']) ) > 0">
						<tr>
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>

						<!-- A1 --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,7) = 'tr_11A1' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>

						<!-- A1a --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,8) = 'tr_11A1a' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1a'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1a'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1a'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1a/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1a'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1a/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- A1a1 -->
						<xsl:if test="../UISelectedTransactions/tr_11A1a1= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1a1'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1a1'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1a1/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1a1'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1a1/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A1a1/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a1a1'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A1a1) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A1a1"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A1a2 -->
						<xsl:if test="../UISelectedTransactions/tr_11A1a2= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1a2'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1a2'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1a2/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1a2'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1a2/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A1a2/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a1a2'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A1a2) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A1a2"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A1a3 -->
						<xsl:if test="../UISelectedTransactions/tr_11A1a3= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1a3'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1a3'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1a3/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1a3'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1a3/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A1a3/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a1a3'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A1a3) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A1a3"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A1a4 -->
						<xsl:if test="../UISelectedTransactions/tr_11A1a4= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1a4'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1a4'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11A1a4) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11A1a4"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1a4/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1a4'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1a4/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A1a4/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a1a4'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A1a4) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A1a4"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A1b --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,8) = 'tr_11A1b' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1b'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1b'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1b'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1b/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1b'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1b/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- A1b1 -->
						<xsl:if test="../UISelectedTransactions/tr_11A1b1= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1b1'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1b1'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1b1/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1b1'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1b1/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A1b1/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a1b1'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A1b1) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A1b1"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A1b2 -->
						<xsl:if test="../UISelectedTransactions/tr_11A1b2= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1b2'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1b2'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1b2/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1b2'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1b2/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A1b2/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a1b2'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A1b2) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A1b2"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A1b3 -->
						<xsl:if test="../UISelectedTransactions/tr_11A1b3= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1b3'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1b3'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1b3/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1b3'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1b3/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A1b3/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a1b3'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A1b3) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A1b3"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A1b4 -->
						<xsl:if test="../UISelectedTransactions/tr_11A1b4= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1b4'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1b4'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11A1b4) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11A1b4"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1b4/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1b4'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1b4/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A1b4/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a1b4'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A1b4) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A1b4"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A1c --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,8) = 'tr_11A1c' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1c'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1c'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1c'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1c/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a1c'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1c/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- A1c1 -->
						<xsl:if test="../UISelectedTransactions/tr_11A1c1= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1c1'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1c1'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1c1/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1c1'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1c1/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A1c1/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a1c1'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A1c1) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A1c1"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A1c2 -->
						<xsl:if test="../UISelectedTransactions/tr_11A1c2= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1c2'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1c2'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1c2/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1c2'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1c2/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A1c2/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a1c2'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A1c2) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A1c2"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A1c3 -->
						<xsl:if test="../UISelectedTransactions/tr_11A1c3= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1c3'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1c3'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1c3/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1c3'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1c3/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A1c3/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a1c3'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A1c3) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A1c3"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A1c4 -->
						<xsl:if test="../UISelectedTransactions/tr_11A1c4= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1c4'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1c4'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11A1c4) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11A1c4"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A1c4/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a1c4'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A1c4/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A1c4/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a1c4'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A1c4) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A1c4"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A2 --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,7) = 'tr_11A2' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>

						<!-- A2a --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,8) = 'tr_11A2a' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- A2a1 --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,9) = 'tr_11A2a1' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a1'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a1'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a1'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a1/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a1'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a1/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- A2a1i -->
						<xsl:if test="../UISelectedTransactions/tr_11A2a1i= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a1i'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a1i'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a1i/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a1i'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a1i/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2a1i/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2a1i'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2a1i) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2a1i"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- A2a1ii -->
						<xsl:if test="../UISelectedTransactions/tr_11A2a1ii= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a1ii'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a1ii'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a1ii/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a1ii'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a1ii/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2a1ii/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2a1ii'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2a1ii) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2a1ii"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- A2a1iii -->
						<xsl:if test="../UISelectedTransactions/tr_11A2a1iii= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a1iii'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a1iii'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11A2a1iii) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11A2a1iii"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a1iii/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a1iii'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a1iii/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2a1iii/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2a1iii'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2a1iii) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2a1iii"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A2a2 --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,9) = 'tr_11A2a2' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a2'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a2'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a2'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a2/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a2'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a2/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- A2a2i -->
						<xsl:if test="../UISelectedTransactions/tr_11A2a2i= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a2i'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a2i'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a2i/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a2i'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a2i/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2a2i/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2a2i'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2a2i) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2a2i"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- A2a2ii -->
						<xsl:if test="../UISelectedTransactions/tr_11A2a2ii= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a2ii'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a2ii'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a2ii/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a2ii'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a2ii/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2a2ii/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2a2ii'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2a2ii) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2a2ii"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- A2a2iii -->
						<xsl:if test="../UISelectedTransactions/tr_11A2a2iii= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a2iii'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a2iii'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11A2a2iii) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11A2a2iii"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a2iii/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a2iii'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a2iii/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2a2iii/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2a2iii'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2a2iii) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2a2iii"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A2a3 --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,9) = 'tr_11A2a3' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a3'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a3'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a3'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a3/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2a3'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a3/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- A2a3i -->
						<xsl:if test="../UISelectedTransactions/tr_11A2a3i= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a3i'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a3i'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a3i/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a3i'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a3i/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2a3i/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2a3i'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2a3i) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2a3i"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- A2a3ii -->
						<xsl:if test="../UISelectedTransactions/tr_11A2a3ii= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a3ii'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a3ii'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a3ii/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a3ii'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a3ii/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2a3ii/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2a3ii'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2a3ii) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2a3ii"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- A2a3iii -->
						<xsl:if test="../UISelectedTransactions/tr_11A2a3iii= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a3iii'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a3iii'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11A2a3iii) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11A2a3iii"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2a3iii/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2a3iii'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2a3iii/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2a3iii/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2a3iii'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2a3iii) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2a3iii"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A2b --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,8) = 'tr_11A2b' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- A2b1 --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,9) = 'tr_11A2b1' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b1'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b1'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b1'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b1/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b1'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b1/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- A2b1i -->
						<xsl:if test="../UISelectedTransactions/tr_11A2b1i= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b1i'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b1i'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b1i/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b1i'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b1i/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2b1i/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2b1i'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2b1i) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2b1i"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- A2b1ii -->
						<xsl:if test="../UISelectedTransactions/tr_11A2b1ii= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b1ii'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b1ii'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b1ii/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b1ii'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b1ii/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2b1ii/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2b1ii'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2b1ii) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2b1ii"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- A2b1iii -->
						<xsl:if test="../UISelectedTransactions/tr_11A2b1iii= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b1iii'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b1iii'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11A2b1iii) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11A2b1iii"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b1iii/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b1iii'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b1iii/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2b1iii/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2b1iii'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2b1iii) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2b1iii"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A2b2 --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,9) = 'tr_11A2b2' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b2'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b2'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b2'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b2/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b2'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b2/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- A2b2i -->
						<xsl:if test="../UISelectedTransactions/tr_11A2b2i= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b2i'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b2i'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b2i/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b2i'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b2i/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2b2i/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2b2i'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2b2i) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2b2i"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- A2b2ii -->
						<xsl:if test="../UISelectedTransactions/tr_11A2b2ii= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b2ii'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b2ii'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b2ii/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b2ii'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b2ii/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2b2ii/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2b2ii'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2b2ii) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2b2ii"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- A2b2iii -->
						<xsl:if test="../UISelectedTransactions/tr_11A2b2iii= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b2iii'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b2iii'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11A2b2iii) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11A2b2iii"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b2iii/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b2iii'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b2iii/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2b2iii/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2b2iii'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2b2iii) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2b2iii"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>

						<!-- A2b3 --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,9) = 'tr_11A2b3' and . = 'true']) ) > 0">
						<tr>
							<td  rowspan="1" />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b3'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b3'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b3'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b3/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11a2b3'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b3/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- A2b3i -->
						<xsl:if test="../UISelectedTransactions/tr_11A2b3i= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b3i'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b3i'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b3i/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b3i'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b3i/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2b3i/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2b3i'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2b3i) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2b3i"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- A2b3ii -->
						<xsl:if test="../UISelectedTransactions/tr_11A2b3ii= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b3ii'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b3ii'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b3ii/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b3ii'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b3ii/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2b3ii/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2b3ii'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2b3ii) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2b3ii"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- A2b3iii -->
						<xsl:if test="../UISelectedTransactions/tr_11A2b3iii= 'true'">
							<tr>
								<td rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b3iii'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b3iii'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11A2b3iii) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11A2b3iii"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11A2b3iii/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11a2b3iii'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11A2b3iii/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11A2b3iii/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11a2b3iii'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11A2b3iii) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11A2b3iii"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
		
						<!-- B --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,6) = 'tr_11B' and . = 'true']) ) > 0">
						<tr>
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11b'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11b'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11b'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11B/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11b'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11B/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- B1 -->
						<xsl:if test="../UISelectedTransactions/tr_11B1= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11b1'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11b1'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11B1/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11b1'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11B1/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11B1/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11b1'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11B1) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11B1"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- B2 -->
						<xsl:if test="../UISelectedTransactions/tr_11B2= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11b2'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11b2'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11B2/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11b2'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11B2/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11B2/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11b2'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11B2) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11B2"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- B3 -->
						<xsl:if test="../UISelectedTransactions/tr_11B3= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11b3'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11b3'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11B3) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11B3"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11B3/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11b3'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11B3/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11B3/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11b3'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11B3) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11B3"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- B4 -->
						<xsl:if test="../UISelectedTransactions/tr_11B4= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11b4'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11b4'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11B4/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11b4'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11B4/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11B4/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11b4'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11B4) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11B4"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- B5 -->
						<xsl:if test="../UISelectedTransactions/tr_11B5= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11b5'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11b5'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11B5) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11B5"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11B5/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11b5'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11B5/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11B5/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11b5'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11B5) > 0">
										<br/><br/>
										<span class="bold">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11B5"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- C --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,6) = 'tr_11C' and . = 'true']) ) > 0">
						<tr>
							<td class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11c'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11c'"/>
								</xsl:call-template>
							</td>

							<td>
								<span class="padding-right-1em tdColorBlue num_cell" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11C/Amount"/></xsl:call-template>
								</span>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11c'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11C/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					<!-- C1 --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,7) = 'tr_11C1' and . = 'true']) ) > 0">
						<tr>
							<td />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11c1'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11c1'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11c1'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11C1/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11c1'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11C1/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- C1a -->
						<xsl:if test="../UISelectedTransactions/tr_11C1a= 'true'">
							<tr>
								<td  rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11c1a'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11c1a'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11C1a/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11c1a'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11C1a/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11C1a/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11c1a'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11C1a) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11C1a"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- C1b -->
						<xsl:if test="../UISelectedTransactions/tr_11C1b= 'true'">
							<tr>
								<td  rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11c1b'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11c1b'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11C1b) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11C1b"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11C1b/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11c1b'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11C1b/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11C1b/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11c1b'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11C1b) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11C1b"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
					<!-- C2 --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,7) = 'tr_11C2' and . = 'true']) ) > 0">
						<tr>
							<td />
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11c2'"/>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11c2'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11c2'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11C2/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11c2'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11C2/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- C2a -->
						<xsl:if test="../UISelectedTransactions/tr_11C2a= 'true'">
							<tr>
								<td  rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11c2a'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11c2a'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11C2a/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11c2a'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11C2a/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11C2a/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11c2a'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11C2a) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11C2a"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- C2b -->
						<xsl:if test="../UISelectedTransactions/tr_11C2b= 'true'">
							<tr>
								<td  rowspan="2" colspan="2" />
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11c2b'"/>
									</xsl:call-template>
								</td>
								<td colspan="1">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11c2b'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11C2b) > 0">
										<span class="bold padding-right-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue">
											<xsl:call-template name="getValue">
												<xsl:with-param name="elem" select="../Category/tr_11C2b"/>
											</xsl:call-template>
										</div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11C2b/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11c2b'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11C2b/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11C2b/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11c2b'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11C2b) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11C2b"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- D --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,6) = 'tr_11D' and . = 'true']) ) > 0">
						<tr>
							<td class="code" rowspan="2">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11d'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11d'"/>
								</xsl:call-template>
								<xsl:if test="string-length(../Category/tr_11D) > 0">
									<span class="bold padding-right-1em padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'please_specify'"/>
										</xsl:call-template>:
									</span>
									<div class="tdColorBlue text_input">
										<xsl:call-template name="getValue">
											<xsl:with-param name="elem" select="../Category/tr_11D"/>
										</xsl:call-template>
									</div>
								</xsl:if>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11D/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'tr_11d'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue num_cell" rowspan="2" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11D/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
						<tr>
							<td colspan="4">
								<span class="bold padding-right-1em" >
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'s2'"/>
									</xsl:call-template>
								</span>
								<span class="tdColorBlue"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11D/Amount"/></xsl:call-template></span>
								<span class="padding-left-1em">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
										<xsl:with-param name="labelPath" select="'tr_11d'"/>
									</xsl:call-template>
								</span>
								<xsl:if test="string-length(../Comment/tr_11D) > 0">
									<br/><br/>
									<span class="bold ">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'obligatory_comment'"/>
											<xsl:with-param name="labelPath" select="'form7'"/>
										</xsl:call-template>:
									</span>
									<br/>
									<div class="tdColorBlue text_input"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11D"/></xsl:call-template></div>
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
						<!-- E --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,6) = 'tr_11E' and . = 'true']) ) > 0">
						<tr>
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11e'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11e'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11e'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11E/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11e'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11E/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- E1 -->
						<xsl:if test="../UISelectedTransactions/tr_11E1= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11e1'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11e1'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11E1/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11e1'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11E1/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11E1/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11e1'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11E1) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11E1"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- E2 -->
						<xsl:if test="../UISelectedTransactions/tr_11E2= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11e2'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11e2'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11E2) > 0">
										<span class="bold padding-right-1em padding-left-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11E2"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11E2/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11e2'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11E2/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11E2/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11e2'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11E2) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11E2"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- E3 -->
						<xsl:if test="../UISelectedTransactions/tr_11E3= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11e3'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11e3'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11E3/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11e3'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11E3/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11E3/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11e3'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11E3) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11E3"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- E4 -->
						<xsl:if test="../UISelectedTransactions/tr_11E4= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11e4'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11e4'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11E4) > 0">
										<span class="bold padding-right-1em padding-left-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11E4"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11E4/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11e4'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11E4/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11E4/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11e4'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11E4) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11E4"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- F --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,6) = 'tr_11F' and . = 'true']) ) > 0">
						<tr>
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11f'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11f'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11f'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11F/Amount"/></xsl:call-template> </div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit_for_amount'"/>
									<xsl:with-param name="labelPath" select="'tr_11f'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11F/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- F1 -->
						<xsl:if test="../UISelectedTransactions/tr_11F1= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11f1'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11f1'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11F1/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11f1'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11F1/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11F1/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11f1'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11F1) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11F1"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- F2 -->
						<xsl:if test="../UISelectedTransactions/tr_11F2= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11f2'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11f2'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11F2/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11f2'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11F2/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11F2/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11f2'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11F2) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11F2"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- F3 -->
						<xsl:if test="../UISelectedTransactions/tr_11F3= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11f3'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11f3'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11F3/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11f3'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11F3/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11F3/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11f3'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11F3) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11F3"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- F4 -->
						<xsl:if test="../UISelectedTransactions/tr_11F4= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11f4'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11f4'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11F4/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11f4'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11F4/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11F4/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11f4'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11F4) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11F4"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- F5 -->
						<xsl:if test="../UISelectedTransactions/tr_11F5= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11f5'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11f5'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11F5/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11f5'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11F5/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11F5/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11f5'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11F5) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11F5"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- F6 -->
						<xsl:if test="../UISelectedTransactions/tr_11F6= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11f6'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11f6'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11F6/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11f6'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11F6/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11F6/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11f6'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11F6) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11F6"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- F7 -->
						<xsl:if test="../UISelectedTransactions/tr_11F7= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11f7'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11f7'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11F7/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11f7'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11F7/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11F7/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11f7'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11F7) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11F7"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- F8 -->
						<xsl:if test="../UISelectedTransactions/tr_11F8= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11f8'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11f8'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11F8/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11f8'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11F8/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11F8/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11f8'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11F8) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11F8"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- F9 -->
						<xsl:if test="../UISelectedTransactions/tr_11F9= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11f9'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11f9'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11F9) > 0">
										<span class="bold padding-right-1em padding-left-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11F9"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11F9/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11f9'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11F9/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11F9/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11f9'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11F9) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11F9"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- G -->
						<xsl:variable name="trG" select="count((../UISelectedTransactions/child::*[(substring(name(.),1,6) = 'tr_11A' or substring(name(.),1,6) = 'tr_11B' or substring(name(.),1,6) = 'tr_11C' or substring(name(.),1,6) = 'tr_11D' or substring(name(.),1,6) = 'tr_11E' or substring(name(.),1,6) = 'tr_11F')  and . = 'true']) ) > 0"/>
						<xsl:if test="$trG">
							<tr>
								<td  class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11g'"/>
									</xsl:call-template>
								</td>
								<td colspan="3">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11g'"/>
									</xsl:call-template>
									<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_11g'"/>
									</xsl:call-template>
								</span>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue total"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11G/Amount"/></xsl:call-template> </div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit_for_amount'"/>
										<xsl:with-param name="labelPath" select="'tr_11g'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue total" >
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11G/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
						</xsl:if>
						<!-- H --><xsl:if test="count((../UISelectedTransactions/child::*[substring(name(.),1,7) = 'tr_11H0' and . = 'true']) ) > 0">
						<tr>
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11h'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11h'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11h'"/>
								</xsl:call-template>
							</span>
							</td>
							<td>

							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11H/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
						<!-- H1 -->
						<xsl:if test="../UISelectedTransactions/tr_11H1= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11h1'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11h1'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11H1/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11h1'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11H1/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11H1/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11h1'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11H1) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11H1"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- H2 -->
						<xsl:if test="../UISelectedTransactions/tr_11H2= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11h2'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11h2'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11H2/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11h2'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11H2/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11H2/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11h2'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11H2) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11H2"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- H3 -->
						<xsl:if test="../UISelectedTransactions/tr_11H3= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11h3'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11h3'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11H3/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11h3'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11H3/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11H3/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11h3'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11H3) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11H3"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- H4 -->
						<xsl:if test="../UISelectedTransactions/tr_11H4= 'true'">
							<tr>
								<td  rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11h4'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11h4'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11H4) > 0">
										<span class="bold padding-right-1em padding-left-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11H4"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11H4/Amount"/></xsl:call-template></div>
									<xsl:variable name="unitName" select="../TR_11H4_Unit"/>
									<xsl:call-template name="getUnit">
										<xsl:with-param name="unit" select="$unitName"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11H4/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11H4/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11h4'"/>
										</xsl:call-template>
										<xsl:choose>
											<xsl:when test="../TR_11H4_Unit = 'pieces'">piece</xsl:when>
											<xsl:when test="../TR_11H4_Unit = 'cubicmetres'">cubic metre</xsl:when>
											<xsl:when test="../TR_11H4_Unit = 'metrictonnes'">metric tonne</xsl:when>
										</xsl:choose>
									</span>
									<xsl:if test="string-length(../Comment/tr_11H4) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11H4"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- I --><xsl:if test="../UISelectedTransactions/tr_11I= 'true'">
						<tr>

							<td rowspan="2" class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11i'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11i'"/>
								</xsl:call-template>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11I/Amount"/></xsl:call-template></div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'tr_11i'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue num_cell" rowspan="2" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11I/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
						<tr>
							<td colspan="4">
								<span class="bold padding-right-1em" >
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'s2'"/>
									</xsl:call-template>
								</span>
								<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11I/Amount"/></xsl:call-template></span>
								<span class="padding-left-1em">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
										<xsl:with-param name="labelPath" select="'tr_11i'"/>
									</xsl:call-template>
								</span>
								<xsl:if test="string-length(../Comment/tr_11I) > 0">
									<br/><br/>
									<span class="bold ">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'obligatory_comment'"/>
											<xsl:with-param name="labelPath" select="'form7'"/>
										</xsl:call-template>:
									</span>
									<br/>
									<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11I"/></xsl:call-template></div>
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
						<!-- J --><xsl:if test="../UISelectedTransactions/tr_11J= 'true'">
						<tr>

							<td rowspan="2" class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11j'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11j'"/>
								</xsl:call-template>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11J/Amount"/></xsl:call-template></div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'tr_11j'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue num_cell" rowspan="2" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11J/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
						<tr>
							<td colspan="4">
								<span class="bold padding-right-1em" >
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'s2'"/>
									</xsl:call-template>
								</span>
								<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11J/Amount"/></xsl:call-template></span>
								<span class="padding-left-1em">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
										<xsl:with-param name="labelPath" select="'tr_11j'"/>
									</xsl:call-template>
								</span>
								<xsl:if test="string-length(../Comment/tr_11J) > 0">
									<br/><br/>
									<span class="bold ">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'obligatory_comment'"/>
											<xsl:with-param name="labelPath" select="'form7'"/>
										</xsl:call-template>:
									</span>
									<br/>
									<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11J"/></xsl:call-template></div>
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
						<!-- J1 -->
						<xsl:if test="../UISelectedTransactions/tr_11J1= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11j1'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11j1'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11J1/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11j1'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11J1/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11J1/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11j1'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11J1) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11J1"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- J2 -->
						<xsl:if test="../UISelectedTransactions/tr_11J2= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11j2'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11j2'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11J2) > 0">
										<span class="bold padding-right-1em padding-left-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11J2"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11J2/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11j2'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11J2/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11J2/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11j2'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11J2) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11J2"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- K --><xsl:if test="../UISelectedTransactions/tr_11K= 'true'">
						<tr>

							<td rowspan="2" class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11k'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11k'"/>
								</xsl:call-template>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11K/Amount"/></xsl:call-template></div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'tr_11k'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue num_cell" rowspan="2">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11K/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
						<tr>
							<td colspan="4">
								<span class="bold padding-right-1em" >
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'s2'"/>
									</xsl:call-template>
								</span>
								<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11K/Amount"/></xsl:call-template></span>
								<span class="padding-left-1em">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
										<xsl:with-param name="labelPath" select="'tr_11k'"/>
									</xsl:call-template>
								</span>
								<xsl:if test="string-length(../Comment/tr_11K) > 0">
									<br/><br/>
									<span class="bold ">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'obligatory_comment'"/>
											<xsl:with-param name="labelPath" select="'form7'"/>
										</xsl:call-template>:
									</span>
									<br/>
									<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11K"/></xsl:call-template></div>
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
						<!-- L --><xsl:if test="../UISelectedTransactions/tr_11L= 'true'">
						<tr>

							<td rowspan="2" class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11l'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11l'"/>
								</xsl:call-template>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11L/Amount"/></xsl:call-template></div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'tr_11l'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue num_cell" rowspan="2" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11L/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
						<tr>
							<td colspan="4">
								<span class="bold padding-right-1em" >
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'s2'"/>
									</xsl:call-template>
								</span>
								<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11L/Amount"/></xsl:call-template></span>
								<span class="padding-left-1em">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
										<xsl:with-param name="labelPath" select="'tr_11l'"/>
									</xsl:call-template>
								</span>
								<xsl:if test="string-length(../Comment/tr_11L) > 0">
									<br/><br/>
									<span class="bold ">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'obligatory_comment'"/>
											<xsl:with-param name="labelPath" select="'form7'"/>
										</xsl:call-template>:
									</span>
									<br/>
									<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11L"/></xsl:call-template></div>
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
						<!-- L1 -->
						<xsl:if test="../UISelectedTransactions/tr_11L1= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11l1'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11l1'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11L1/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11l1'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11L1/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11L1/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11l1'"/>
										</xsl:call-template>
									</span>
									<xsl:choose>
										<xsl:when test="../TR_11L1_Unit = 'pieces'">units</xsl:when>
										<xsl:when test="../TR_11L1_Unit = 'cubicmetres'">cubic metres</xsl:when>
										<xsl:when test="../TR_11L1_Unit = 'metrictonnes'">tonnes</xsl:when>
									</xsl:choose>
									<xsl:if test="string-length(../Comment/tr_11L1) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11L1"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- L2 -->
						<xsl:if test="../UISelectedTransactions/tr_11L2= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11l2'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11l2'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11L2/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11l2'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11L2/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11L2/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11l2'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11L2) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11L2"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- L3 -->
						<xsl:if test="../UISelectedTransactions/tr_11L3= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11l3'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11l3'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11L3) > 0">
										<span class="bold padding-right-1em padding-left-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11L3"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11L3/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11l3'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11L3/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11L3/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11l3'"/>
										</xsl:call-template>
									</span>
									<xsl:choose>
										<xsl:when test="../TR_11L3_Unit = 'pieces'">units</xsl:when>
										<xsl:when test="../TR_11L3_Unit = 'cubicmetres'">cubic metres</xsl:when>
										<xsl:when test="../TR_11L3_Unit = 'metrictonnes'">tonnes</xsl:when>
									</xsl:choose>
									<xsl:if test="string-length(../Comment/tr_11L3) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11L3"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- M --><xsl:if test="../UISelectedTransactions/tr_11M= 'true'">
						<tr>

							<td rowspan="2" class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11m'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11m'"/>
								</xsl:call-template>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11M/Amount"/></xsl:call-template></div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'tr_11m'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue num_cell" rowspan="2" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11M/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
						<tr>
							<td colspan="4">
								<span class="bold padding-right-1em" >
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'s2'"/>
									</xsl:call-template>
								</span>
								<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11M/Amount"/></xsl:call-template></span>
								<span class="padding-left-1em">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
										<xsl:with-param name="labelPath" select="'tr_11m'"/>
									</xsl:call-template>
								</span>
								<xsl:if test="string-length(../Comment/tr_11M) > 0">
									<br/><br/>
									<span class="bold ">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'obligatory_comment'"/>
											<xsl:with-param name="labelPath" select="'form7'"/>
										</xsl:call-template>:
									</span>
									<br/>
									<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11M"/></xsl:call-template></div>
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
						<!-- M1 -->
						<xsl:if test="../UISelectedTransactions/tr_11M1= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11m1'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11m1'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11M1/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11m1'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11M1/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11M1/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11m1'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11M1) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11M1"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- M2 -->
						<xsl:if test="../UISelectedTransactions/tr_11M2= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11m2'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11m2'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11M2/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11m2'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11M2/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11M2/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11m2'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11M2) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11M2"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- M3 -->
						<xsl:if test="../UISelectedTransactions/tr_11M3= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11m3'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11m3'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11M3/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11m3'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11M3/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11M3/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11m3'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11M3) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11M3"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- M4 -->
						<xsl:if test="../UISelectedTransactions/tr_11M4= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11m4'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11m4'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11M4/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11m4'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11M4/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11M4/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11m4'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11M4) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11M4"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- M5 -->
						<xsl:if test="../UISelectedTransactions/tr_11M5= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11m5'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11m5'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11M5) > 0">
										<span class="bold padding-right-1em padding-left-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11M5"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11M5/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11m5'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11M5/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11M5/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11m5'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11M5) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11M5"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- N --><xsl:if test="../UISelectedTransactions/tr_11N= 'true'">
						<tr>

							<td rowspan="2" class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11n'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11n'"/>
								</xsl:call-template>
								<xsl:if test="string-length(../Category/tr_11N) > 0">
									<span class="bold padding-right-1em padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'please_specify'"/>
										</xsl:call-template>:
									</span>
									<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11N"/></xsl:call-template></div>
								</xsl:if>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11N/Amount"/></xsl:call-template></div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'tr_11n'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue num_cell" rowspan="2" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11N/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
						<tr>
							<td colspan="4">
								<span class="bold padding-right-1em" >
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'s2'"/>
									</xsl:call-template>
								</span>
								<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11N/Amount"/></xsl:call-template></span>
								<span class="padding-left-1em">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
										<xsl:with-param name="labelPath" select="'tr_11n'"/>
									</xsl:call-template>
								</span>
								<xsl:if test="string-length(../Comment/tr_11N) > 0">
									<br/><br/>
									<span class="bold ">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'obligatory_comment'"/>
											<xsl:with-param name="labelPath" select="'form7'"/>
										</xsl:call-template>:
									</span>
									<br/>
									<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11N"/></xsl:call-template></div>
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
						<!-- O --><xsl:if test="../UISelectedTransactions/tr_11O= 'true'">
						<tr>
							<td rowspan="2" class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11o'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11o'"/>
								</xsl:call-template>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11O/Amount"/></xsl:call-template></div>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'unit'"/>
									<xsl:with-param name="labelPath" select="'tr_11o'"/>
								</xsl:call-template>
							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue num_cell" rowspan="2" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11O/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
						<tr>
							<td colspan="4">
								<span class="bold padding-right-1em" >
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'s2'"/>
									</xsl:call-template>
								</span>
								<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11O/Amount"/></xsl:call-template></span>
								<span class="padding-left-1em">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
										<xsl:with-param name="labelPath" select="'tr_11o'"/>
									</xsl:call-template>
								</span>
								<xsl:if test="string-length(../Comment/tr_11O) > 0">
									<br/><br/>
									<span class="bold ">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'obligatory_comment'"/>
											<xsl:with-param name="labelPath" select="'form7'"/>
										</xsl:call-template>:
									</span>
									<br/>
									<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11O"/></xsl:call-template></div>
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
						<!-- O1 -->
						<xsl:if test="../UISelectedTransactions/tr_11O1= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11o1'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11o1'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11O1/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11o1'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11O1/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11O1/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11o1'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11O1) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11O1"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- O2 -->
						<xsl:if test="../UISelectedTransactions/tr_11O2= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11o2'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11o2'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11O2/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11o2'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11O2/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11O2/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11o2'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11O2) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11O2"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- O3 -->
						<xsl:if test="../UISelectedTransactions/tr_11O3= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11o3'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11o3'"/>
									</xsl:call-template>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11O3/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11o3'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11O3/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11O3/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11o3'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11O3) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11O3"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- O4 -->
						<xsl:if test="../UISelectedTransactions/tr_11O4= 'true'">
							<tr>
								<td rowspan="2"/>
								<td rowspan="2" class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11o4'"/>
									</xsl:call-template>
								</td>
								<td colspan="2">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11o4'"/>
									</xsl:call-template>
									<xsl:if test="string-length(../Category/tr_11O4) > 0">
										<span class="bold padding-right-1em padding-left-1em">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'please_specify'"/>
											</xsl:call-template>:
										</span>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11O4"/></xsl:call-template></div>
									</xsl:if>
								</td>
								<td>
									<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11O4/Amount"/></xsl:call-template></div>
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit'"/>
										<xsl:with-param name="labelPath" select="'tr_11o4'"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue num_cell" rowspan="2">
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11O4/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<td colspan="3">
									<span class="bold padding-right-1em" >
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'s2'"/>
										</xsl:call-template>
									</span>
									<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11O4/Amount"/></xsl:call-template></span>
									<span class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
											<xsl:with-param name="labelPath" select="'tr_11o4'"/>
										</xsl:call-template>
									</span>
									<xsl:if test="string-length(../Comment/tr_11O4) > 0">
										<br/><br/>
										<span class="bold ">
											<xsl:call-template name="getLabel">
												<xsl:with-param name="labelName" select="'obligatory_comment'"/>
												<xsl:with-param name="labelPath" select="'form7'"/>
											</xsl:call-template>:
										</span>
										<br/>
										<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11O4"/></xsl:call-template></div>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<!-- P --><xsl:if test="../UISelectedTransactions/tr_11P= 'true'">
						<tr>

							<td rowspan="2" class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11p'"/>
								</xsl:call-template>
							</td>
							<td colspan="3">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11p'"/>
								</xsl:call-template>
								<xsl:if test="string-length(../Category/tr_11P) > 0">
									<span class="bold padding-right-1em padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'please_specify'"/>
										</xsl:call-template>:
									</span>
									<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Category/tr_11P"/></xsl:call-template></div>
								</xsl:if>
							</td>
							<td>
								<div class="padding-right-1em tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../AmountOfImportedEquipment/tr_11P/Amount"/></xsl:call-template></div>

								<xsl:variable name="unitName2" select="../TR_11P_Unit"/>
								<xsl:call-template name="getUnit">
									<xsl:with-param name="unit" select="$unitName2"/>
								</xsl:call-template>


							</td>
							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue num_cell" rowspan="2" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11P/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
						<tr>
							<td colspan="4">
								<span class="bold padding-right-1em" >
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'s2'"/>
									</xsl:call-template>
								</span>
								<span class="tdColorBlue num_cell"><xsl:call-template name="formatValue"><xsl:with-param name="num" select="../SumOfAllGasesS2/tr_11P/Amount"/></xsl:call-template></span>
								<span class="padding-left-1em">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'unit_of_spec_charge'"/>
										<xsl:with-param name="labelPath" select="'tr_11p'"/>
									</xsl:call-template>
								</span>
								<xsl:choose>
									<xsl:when test="../TR_11P_Unit = 'pieces'">piece</xsl:when>
									<xsl:when test="../TR_11P_Unit = 'cubicmetres'">cubic metre</xsl:when>
									<xsl:when test="../TR_11P_Unit = 'metrictonnes'">metric tonne</xsl:when>
								</xsl:choose>
								<xsl:if test="string-length(../Comment/tr_11P) > 0">
									<br/><br/>
									<span class="bold ">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'obligatory_comment'"/>
											<xsl:with-param name="labelPath" select="'form7'"/>
										</xsl:call-template>:
									</span>
									<br/>
									<div class="tdColorBlue"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../Comment/tr_11P"/></xsl:call-template></div>
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
						<!-- Q -->
						<xsl:if test="$trG or (count((../UISelectedTransactions/child::*[(substring(name(.),1,7) = 'tr_11H0' or substring(name(.),1,6) = 'tr_11I' or substring(name(.),1,6) = 'tr_11J' or substring(name(.),1,6) = 'tr_11K' or substring(name(.),1,6) = 'tr_11L' or substring(name(.),1,6) = 'tr_11M' or substring(name(.),1,6) = 'tr_11N' or substring(name(.),1,6) = 'tr_11O' or substring(name(.),1,6) = 'tr_11P') and . = 'true']) ) > 0)">
							<tr>
								<td  class="code">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'code'"/>
										<xsl:with-param name="labelPath" select="'tr_11q'"/>
									</xsl:call-template>
								</td>
								<td colspan="4">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'parameter'"/>
										<xsl:with-param name="labelPath" select="'tr_11q'"/>
									</xsl:call-template>
									<br/><span class="formula">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'formula'"/>
										<xsl:with-param name="labelPath" select="'tr_11q'"/>
									</xsl:call-template>
								</span>
								</td>

								<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
									<td class="tdColorBlue total" >
										<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11Q/Amount"/></xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
						</xsl:if>
					<!-- R -->
					<xsl:if test="$trG">
						<tr>
							<td  class="code">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'code'"/>
									<xsl:with-param name="labelPath" select="'tr_11r'"/>
								</xsl:call-template>
							</td>
							<td colspan="4">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'parameter'"/>
									<xsl:with-param name="labelPath" select="'tr_11r'"/>
								</xsl:call-template>
								<br/><span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'formula'"/>
									<xsl:with-param name="labelPath" select="'tr_11r'"/>
								</xsl:call-template>
							</span>
							</td>

							<xsl:for-each select=".|following-sibling::Gas[not(position()>($pagingLimit - 1))]">
								<td class="tdColorBlue total" >
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_11R/Amount"/></xsl:call-template>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:if>
					</tbody>
				</table>
			</xsl:if>
		</xsl:if>

	</xsl:template>


	<!-- ###################################################### Tables full content ######################################################################## -->

	<xsl:template match="F1_S1_4_ProdImpExp">
		<xsl:if test="../GeneralReportData/Activities/*[substring(name(.),1,1) = ('P' , 'I') ] = 'true'" >
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section1-heading'"/>
				</xsl:call-template>
			</h2>
			<xsl:call-template name="tablePaging1"/>
		</xsl:if>

		<xsl:if test="../GeneralReportData/Activities/I-HFC = 'true'
                    or ../GeneralReportData/Activities/I-other = 'true'  ">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section2-heading'"/>
				</xsl:call-template>
			</h2>
			<xsl:call-template name="tablePaging2"/>
		</xsl:if>

		<xsl:if test=" ../GeneralReportData/Activities/E = 'true'">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section3-heading'"/>
				</xsl:call-template>
			</h2>
			<xsl:call-template name="tablePaging3"/>
		</xsl:if>

		<xsl:if test="../GeneralReportData/Activities/*[substring(name(.),1,1) = 'P'] = 'true'
                            or ../GeneralReportData/Activities/I = 'true' or  ../GeneralReportData/Activities/RC = 'true' ">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section4-heading'"/>
				</xsl:call-template>
			</h2>
			<xsl:call-template name="tablePaging4"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="F2_S5_exempted_HFCs">
		<xsl:if test="../GeneralReportData/Activities/P-HFC = 'true'  or ../GeneralReportData/Activities/I-HFC = 'true' ">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section5-heading'"/>
				</xsl:call-template>
			</h2>
			<xsl:call-template name="tablePaging5"/>
		</xsl:if>

	</xsl:template>


	<xsl:template match="F2a_S5a_exempted_HFCs">
		<xsl:if test=" ../GeneralReportData/Activities/RQ = 'true' or ../GeneralReportData/Activities/RH = 'true' ">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section5a-heading'"/>
				</xsl:call-template>
			</h2>
			<xsl:call-template name="tablePaging5a"/>
		</xsl:if>

	</xsl:template>


	<xsl:template match="F3A_S6A_IA_HFCs">
		<xsl:if test="../GeneralReportData/Activities/P-HFC = 'true' or ../GeneralReportData/Activities/P-other = 'true'  or ../GeneralReportData/Activities/I-HFC = 'true'  or ../GeneralReportData/Activities/I-other = 'true'">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section6-heading'"/>
				</xsl:call-template>
			</h2>
			<xsl:call-template name="tablePaging6"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="F4_S9_IssuedAuthQuata">
		<xsl:if test="../GeneralReportData/Activities/P-HFC = 'true'  or ../GeneralReportData/Activities/I-HFC = 'true' or ../GeneralReportData/Activities/auth = 'true' or ../GeneralReportData/Activities/RC = 'true' or ../GeneralReportData/Activities/RQA = 'true'">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section9-heading'"/>
				</xsl:call-template>
			</h2>
			<table class="tableSizeLimit table table-hover table-bordered">
				<tbody  class="boldSpan">
					<tr class="boldHeading">
						<th class="firstTh">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'sheet-transactions-header'"/>
							</xsl:call-template>
						</th>
						<th class="gasTh">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'amount-of-hfcs'"/>
							</xsl:call-template>
						</th>

					</tr>
					<tr class="boldHeading no-wrap">
						<th/>

						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'unit-co2eq'"/>
								<xsl:with-param name="labelPath" select="'common'"/>
							</xsl:call-template>
						</th>

					</tr>

					<tr>
						<th>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09a-head'"/>
							</xsl:call-template>
							<br/>
							<xsl:variable name="tr-09a-desc-tail">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'tr-09a-desc-tail'"/>
								</xsl:call-template>
							</xsl:variable>
							<i><xsl:value-of select="replace(string($tr-09a-desc-tail), '\{\{ date \}\}', string(tr_09A_imp_date) )"/></i>
						</th>
						<td/>
					</tr>

					<tr>
						<th class="padding-left-1em">
							<span>9A_imp : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09a_imp-desc'"/>
							</xsl:call-template>

						</th>

						<td class="total">
							<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_09A_imp/SumOfPartnerAmounts"/></xsl:call-template>
						</td>
					</tr>
					<xsl:for-each select="tr_09A_imp_TradePartners/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="padding-left-1em tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
																				<br/><span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:<xsl:value-of select="NonEURepresentativeVAT"/></span>
									</div>
								</xsl:if>

							</td>
							<xsl:for-each select="../../tr_09A_imp/TradePartner[TradePartnerID = $partnerId]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
								</td>
							</xsl:for-each>

						</tr>
					</xsl:for-each>

					<tr>
						<th class="padding-left-1em">
							<span>9A_add : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09a_add-desc'"/>
							</xsl:call-template>

						</th>

						<td class="total">
							<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_09A_add/SumOfPartnerAmounts"/></xsl:call-template>
						</td>
					</tr>
					<xsl:for-each select="tr_09A_add_TradePartners/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="padding-left-1em tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
																				<br/><span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:<xsl:value-of select="NonEURepresentativeVAT"/></span>
									</div>
								</xsl:if>

							</td>
							<xsl:for-each select="../../tr_09A_add/TradePartner[TradePartnerID = $partnerId]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
									<br/>
									<br/>
									<span class="comment"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Comment"/></xsl:call-template></span>
								</td>
							</xsl:for-each>

						</tr>
					</xsl:for-each>

					<tr>
						<th class="padding-left-1em">
							<span>9A : </span>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09a-desc'"/>
							</xsl:call-template>

						</th>

						<td class="total">
							<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_09A/SumOfPartnerAmounts"/></xsl:call-template>
						</td>

					</tr>

					<tr>
						<th colspan="2">
							<strong>Disclaimer : </strong>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09b_f-disclaimer'"/>
							</xsl:call-template>
						</th>
					</tr>
					<!--
                    <tr>
                        <th class="padding-left-1em">
                            <span>9A_registry : </span>

                            <xsl:call-template name="getLabel">
                                <xsl:with-param name="labelName" select="'tr-09a-registry-description'"/>
                            </xsl:call-template>

                        </th>

                        <td class="total">
                            <xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_09A_Registry/Amount"/></xsl:call-template>
                        </td>

                    </tr>
					 -->
					<xsl:for-each select="tr_09A_TradePartners/*">
						<xsl:variable name="partnerId" select="PartnerId"/>
						<tr>
							<td  class="padding-left-1em tradingPartners">
								<div><li/></div>
								<div><span class="bold"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="CompanyName"/></xsl:call-template> </span></div>

								<br/>
								<xsl:if test="isEUBased">
									<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue"><xsl:with-param name="elem" select="EUVAT"/></xsl:call-template></div>
								</xsl:if>
								<xsl:if test="isEUBased = 'false'">
									<div class="padding-left-1em">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-country'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEUCountryOfEstablishment"/></xsl:call-template>
										-
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
										</xsl:call-template>
										: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="NonEURepresentativeName"/></xsl:call-template>
																				<br/><span><xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
										</xsl:call-template>:<xsl:value-of select="NonEURepresentativeVAT"/></span>
									</div>
								</xsl:if>

							</td>
							<xsl:for-each select="../../tr_09A/TradePartner[TradePartnerID = $partnerId]">
								<td class="num_cell">
									<xsl:call-template name="formatValue"><xsl:with-param name="num" select="amount"/></xsl:call-template>
								</td>
							</xsl:for-each>

						</tr>
					</xsl:for-each>
					<tr>
						<th class="padding-left-1em">
							<span>9B : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09b-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09b-formula'"/>
							</xsl:call-template>
						</span>

						</th>

						<td class="total">
							<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_09B/Amount"/></xsl:call-template>
						</td>

					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>9C : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09c-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09c-formula'"/>
							</xsl:call-template>
						</span>
						</th>

						<td class="total">
							<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_09C/Amount"/></xsl:call-template>
						</td>

					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>9D : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09d-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09d-formula'"/>
							</xsl:call-template>
						</span>
						</th>

						<td class="total">
							<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_09D/Amount"/></xsl:call-template>
						</td>

					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>9E : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09e-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09e-formula'"/>
							</xsl:call-template>
						</span>
						</th>

						<td class="total">
							<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_09E/Amount"/></xsl:call-template>
						</td>

					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>9F : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09f-desc'"/>
							</xsl:call-template>
							<br/><span class="formula">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09f-formula'"/>
							</xsl:call-template>
						</span>
						</th>

						<td class="total">
							<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_09F/Amount"/></xsl:call-template>
						</td>

					</tr>
					<tr>
						<th class="padding-left-1em">
							<span>9G : </span>

							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-09g-desc'"/>
							</xsl:call-template>
							<br/>
							<xsl:variable name="tr-09g-desc-tail">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'tr-09g-desc-tail'"/>
								</xsl:call-template>
							</xsl:variable>
							<i>
								<xsl:value-of select="replace(string($tr-09g-desc-tail), '\{\{ date \}\}', string(tr_09G/Comment) )"/>
							</i>
							<br/>
							<span class="formula">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'tr-09g-formula'"/>
								</xsl:call-template>
							</span>
						</th>

						<td class="total">
							<xsl:call-template name="formatValue"><xsl:with-param name="num" select="tr_09G/Amount"/></xsl:call-template>
						</td>

					</tr>
				</tbody>
			</table>

			<table style="border: 0 !important;">
				<tbody>
					<tr>
						<td>
							<xsl:if test="NilReportConfirmed = 'false' or NilReportConfirmed = ''">
								<input type="checkbox" name="9Nilcheckbox"  disabled="true" ></input>
							</xsl:if>
							<xsl:if test="NilReportConfirmed = 'true'">
								<input type="checkbox" name="9Nilcheckbox" value="$nilcheckbox" checked="checked" disabled="true"/>
							</xsl:if>

						</td>
						<td>
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'tr-nil_report-check'"/>
								<xsl:with-param name="labelPath" select="'sheet4'"/>
							</xsl:call-template>
						</td>
					</tr>

					<xsl:if test="$verificationRequired">
						<tr>
							<td>
								<xsl:if test="Verified = 'true'">
									<input type="checkbox" name="9checkbox" checked="checked" disabled="true"/>
								</xsl:if>
								<xsl:if test="not(Verified = 'true')">
									<input type="checkbox" name="9checkbox" disabled="true"/>
								</xsl:if>
							</td>
							<td>
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'verified-desc'"/>
									<xsl:with-param name="labelPath" select="'sheet4'"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>

				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	<xsl:template match="F6_FUDest">
		<xsl:if test="../GeneralReportData/Activities/FU = 'true' ">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section7-heading'"/>

				</xsl:call-template>
			</h2>
			<xsl:call-template name="tablePaging7"/>
		</xsl:if>
		<xsl:if test=" ../GeneralReportData/Activities/D = 'true'">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section8-heading'"/>

				</xsl:call-template>
			</h2>
			<xsl:call-template name="tablePaging8"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="F8_S12">
		<xsl:if test="../GeneralReportData/Activities/Eq-I-RACHP-HFC = 'true' ">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section12-heading'"/>
					<xsl:with-param name="labelPath" select="'sheet8'"/>
				</xsl:call-template>
			</h2>

			<xsl:call-template name="tablePaging12"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="F9_S13">
		<xsl:if test="../GeneralReportData/Activities/Eq-I-RACHP-HFC = 'true'">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section13-heading'"/>
					<xsl:with-param name="labelPath" select="'sheet9'"/>
				</xsl:call-template>
			</h2>
			<xsl:call-template name="table13"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="FGasesReporting/F7_s11EquImportTable">
		<xsl:if test="transactionsConfirmed = 'true' or ../GeneralReportData/Activities/Eq-I-RACHP-HFC = 'true'  or ../GeneralReportData/Activities/Eq-I-other = 'true'">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'header'"/>
					<xsl:with-param name="labelPath" select="'form7'"/>
				</xsl:call-template>
			</h2>
		
			<xsl:call-template name="tablePaging11"/>
		</xsl:if>
	</xsl:template>	

	<xsl:template name="formatValue">
		<xsl:param name="num"/>
		<xsl:choose>
			<xsl:when test="string-length($num) &gt; 0 and (number($num) &gt; 0 or number($num) &lt;= 0)">
				<xsl:choose>
					<xsl:when test="contains($num, '.') = false()"><xsl:value-of select="fgas:format-number-with-space-multi($num)"/><span style="visibility:hidden">.000</span></xsl:when>
					<xsl:when test="string-length(substring-after($num, '.')) = 0"><xsl:value-of select="fgas:format-number-with-space-multi($num)"/><span style="visibility:hidden">000</span></xsl:when>
					<xsl:when test="string-length(substring-after($num, '.')) = 1"><xsl:value-of select="fgas:format-number-with-space-multi($num)"/><span style="visibility:hidden">00</span></xsl:when>
					<xsl:when test="string-length(substring-after($num, '.')) = 2"><xsl:value-of select="fgas:format-number-with-space-multi($num)"/><span style="visibility:hidden">0</span></xsl:when>
					<xsl:when test="contains($num, '.') = true()"><xsl:value-of select="fgas:format-number-with-space-multi(substring-before($num, '.'))"/>.<xsl:value-of select="substring-after($num, '.')"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$num"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$num"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="totalValue">
		<xsl:param name="num"/>
		<td class="total">
			<xsl:call-template name="formatValue"><xsl:with-param name="num" select="$num"/></xsl:call-template><span class="sub" style="visibility:hidden;">*</span>
		</td>
	</xsl:template>
	<xsl:template name="getUnit">
		<xsl:param name="unit"/>
		<xsl:choose>
			<xsl:when test="$unit = 'cubicmetres' or $unit = 'metrictonnes'">
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="$unit"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$unit"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getTradePartnerInfo">
		<xsl:param name="partner"></xsl:param>
		<xsl:if test="count(partner) > 0">
			<xsl:for-each select="partner/*">
				<div>
					<span class="bold">
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="./CompanyName"/></xsl:call-template>
					</span>
				</div>
				<br/>
				<xsl:if test="isEUBased">
					<div class="padding-left-1em"><span> </span> <xsl:call-template name="getValue">
						<xsl:with-param name="elem" select="./EUVAT"/></xsl:call-template>
					</div>
				</xsl:if>
				<xsl:if test="isEUBased = 'false'">
					<div class="padding-left-1em">
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'trading-partner-country'"/>
						</xsl:call-template>
						: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="./NonEUCountryOfEstablishment"/></xsl:call-template>
						-
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'trading-partner-representative-name'"/>
						</xsl:call-template>
						: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="./NonEURepresentativeName"/></xsl:call-template>
						<br/><span><xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'trading-partner-representative-vat'"/>
					</xsl:call-template>:<xsl:value-of select="NonEURepresentativeVAT"/></span>
					</div>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>
