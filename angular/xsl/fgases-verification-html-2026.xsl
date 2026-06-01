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

	<xsl:variable name="labelsLanguage" select="Verification/@xml:lang"/>
	<xsl:variable name="xmlPath" select="'../xmlfile/'"/>
	<!--<xsl:variable name="xmlPath" select="'.\..\xml\'"/>-->
	<xsl:variable name="labelsUrl">
		<xsl:choose>
			<xsl:when test="doc-available(concat($xmlPath, 'fgases-labels-verification-2025-', $labelsLanguage ,'.xml'))">
				<xsl:value-of select="concat($xmlPath, 'fgases-labels-verification-2025-', $labelsLanguage ,'.xml')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($xmlPath, 'fgases-labels-verification-2025-en.xml')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="labels" select="document($labelsUrl)/labels"/>

	
	<xsl:template name="getLabel">
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
					.form-check-label{
					white-space: pre-line !important;
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
							page-break-inside: avoid;
							font-weight:bold;
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
					h2,h4
						{font-weight: bold;
						padding: 0.2em 0.4em;
						background-color: rgb(240, 244, 245);
						color: #000000;
						border-top: 1px solid rgb(224, 231, 215);
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
					.form-check-label{
					display: inline-block;
					max-width: 100%;
					margin-bottom: 5px;
					font-weight: 700;
					}
					.table>tbody>tr>td{
					padding: 8px;
					line-height: 1.42857143;
					vertical-align: top;
					border-top: 1px solid #ddd;}
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
						/*font-weight: normal;*/
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

					/*td {
						color: rgb(0, 0, 192);
					}*/

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
						visibility: hidden;t
						border-color: #fff;
					}

					.hidden td {
						border-color: #fff;
						border-bottom: 1px solid #bbb !important;
					}

					.word-break {
						word-break: normal;
					}
					.table-bordered{
					border: 1px solid #ddd;
					empty-cells: show;
					background-color: #ffffff;
					font: inherit;
					font-size: 90%;
					/*width: 90%;*/
					max-width: 100%;
					margin-bottom: 20px;
					
					}
					td.no-top-border, tr.no-top-border {
					border-top: 0 !important;
					}
					td.no-bottom-border,tr.no-bottom-border {
					border-bottom: 0 !important;
					}
					.bulk-hfcs-selection-componets{
					width:100%}
					.resizable-textarea{
					width: 99%;
					min-height: 50px;
					box-sizing: border-box;
					resize: vertical;
					overflow-y: auto !important;
					padding: 10px;
					border: 1px solid #ccc;
					background-color: #f9f9f9;
					display: block;
					}
					table.section-3 tbody { vertical-align: top; }
					table.section-3 tr#bulk-hfcs-verification-section-3-confirmation label { display: unset }
					table.table-bordered-full { width: 100% }
				</style>

			</head>
			<body>
				<script type="text/javascript">
					// <![CDATA[
                    document.addEventListener('DOMContentLoaded', function() {
                        function adjustTextareaHeight(textarea) {
				        textarea.style.height = 'auto';
				        textarea.style.height = textarea.scrollHeight + 'px';
				    }
				
				    const textareas = document.querySelectorAll('.resizable-textarea');
				
				    textareas.forEach(textarea => {
				        // Ajusta la altura al cargar la página
				        adjustTextareaHeight(textarea);
				        // El evento 'input' no se disparará en un readonly, pero no molesta dejarlo.
				        // Si quieres optimizar, podrías quitar esta línea:
				        // textarea.addEventListener('input', () => adjustTextareaHeight(textarea));
				    });
                   });
                    // ]]>
				</script>
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

		<!-- Auditor Information tab -->
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
							<xsl:with-param name="labelName" select="'auditor-id'"/>
						</xsl:call-template>
					</th>
					<td colspan="3">
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Auditor/Auditor_uid"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'name'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Auditor/Company/CompanyName"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'contact-tel'"/>
						</xsl:call-template>
					</th>
					<td colspan="3">
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Auditor/Phone"/></xsl:call-template>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'website'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Auditor/Website"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'address-street'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Auditor/Adress/Street"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'address-number'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Auditor/Adress/Number"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'address-postcode'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Auditor/Adress/PostalCode"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'address-city'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Auditor/Company/City"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'country'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Auditor/Country/Name"/></xsl:call-template>
					</td>
				</tr>
				
			</tbody>
		</table>

		<h2>
			<xsl:call-template name="getLabel">
				<xsl:with-param name="labelName" select="'auditor-info'"/>
			</xsl:call-template>
		</h2>
		<table id="table-1" class="table table-hover table-bordered">
			<tbody>
				<tr>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'contact-first-name'"/>
						</xsl:call-template>
					</th>
					<td >
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Auditor/leadAuditorFirstName"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'contact-last-name'"/>
						</xsl:call-template>
					</th>
					<td>
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Auditor/leadAuditorLastName"/></xsl:call-template>
					</td>
					<th>
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'contact-email'"/>
						</xsl:call-template>
					</th>
					<td>
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Auditor/LeadAuditorEmail"/></xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table>
		
		
	</xsl:template> <!-- General report data -->
	<xsl:template match="VerificationScope">
		<h2>
			<xsl:call-template name="getLabel">
				<xsl:with-param name="labelName" select="'verification-scope-title'"/>
			</xsl:call-template>
		</h2>
		<table  id="table-3" class="table table-hover table-bordered">
			<tbody>
				
				<tr>
					<th colspan="">
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'url-submission'"/>
						</xsl:call-template>
					</th>
					<td colspan="">
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="DataReportUrl"/></xsl:call-template>
					</td>
					<th colspan="">
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'submission-date'"/>
						</xsl:call-template>
					</th>
					<td colspan="">
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="SubmissionDate"/></xsl:call-template>
					</td>
					<th colspan="">
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'calendar-year'"/>
						</xsl:call-template>
					</th>
					<td colspan="">
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="TransactionYear"/></xsl:call-template>
					</td>
				</tr>
				<tr>
					<th colspan="">
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'reported-by'"/>
						</xsl:call-template>
					</th>
					<td colspan="">
						<xsl:call-template name="getValue"><xsl:with-param name="elem" select="../GeneralReportData/Company/CompanyId"/></xsl:call-template> - <xsl:call-template name="getValue"><xsl:with-param name="elem" select="../GeneralReportData/Company/CompanyName"/></xsl:call-template>
					</td>
					<th colspan="">
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'scope-ver'"/>
						</xsl:call-template>
					</th>
					<td colspan="3">							
						<xsl:choose>
							<xsl:when test="(Bulk[. = 'true'] and Equipment[. = 'true'] )">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'both'"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="(Bulk[. = 'true'] and Equipment[. = 'false'] )">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'bulk'"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="(Bulk[. = 'false'] and Equipment[. = 'true'] )">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'equipment'"/>
								</xsl:call-template>
							</xsl:when>
						
						</xsl:choose>
						
					</td>
					
				</tr>
				
			</tbody>
		</table>
		
		<xsl:if test="count(../ReportedBulk/ReportedGases/Name[string-length(.) > 0]) > 0 ">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'Selection'"/>
				</xsl:call-template>
			</h2>
			<xsl:call-template name="gases" />
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="gases">

		<table id="table-2" class="table table-hover table-bordered">
			<tbody class="boldTh">
				<xsl:if test="count(../ReportedBulk/ReportedGases) > 0 ">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'bulk-selection'"/>
							</xsl:call-template>
						</th>

					</tr>
					<xsl:for-each select="../ReportedBulk/ReportedGases">
						<tr>
							
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>
				
				<xsl:if test="count(../ReportedEquipment/ReportedGases) > 0 ">
					<tr>
						<th colspan="2">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'eq-selection'"/>
							</xsl:call-template>
						</th>
						
					</tr>
					<xsl:for-each select="../ReportedEquipment/ReportedGases">
						<tr>
							
							<td class="padding-left-1em">
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>
			</tbody>
		</table>
	</xsl:template>
	


	<!-- Pagination -->
	<!--Test: http://stackoverflow.com/questions/12235060/pagination-in-xsl  -->

	<!--################################# PAGINATION LIMIT NR ##################################-->
	<xsl:variable name="pagingLimit" select="10"/>
	<!--########################################################################################-->

	
	<xsl:template name="tablePaging1">
		<xsl:copy>
			<xsl:apply-templates  select=".[name() = 'BulkHFCPart1']/Gas">
				<xsl:with-param name="section" select="2" />
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	

<!-- Cleans up leftovers -->
	<xsl:template match="Gas[position() mod $pagingLimit != 1]" />

	
	<!-- ###################################################### Tables full content ######################################################################## -->
	

	<xsl:template match="ReportedBulk">
		<xsl:if test="../VerificationScope/Bulk='true'">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'bulk'"/>
				</xsl:call-template>
			</h2>
		<h2>
			<xsl:call-template name="getLabel">
				<xsl:with-param name="labelName" select="'section-I-1-section-title'"/>
			</xsl:call-template>
		</h2>
		<table id="table-reportedBulk" class="table table-hover table-bordered table-bordered-full">
			<thead>
			<tr>
				<th colspan="6">
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'section-I-1-table-title'"/>
					</xsl:call-template>
				</th>
				
			</tr>
			<tr>
				<th class="" colspan="3">
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'section-I-1-table-header1'"/>
					</xsl:call-template>
				</th>	
				<th class="reported-hfc-title" colspan="3" rowspan="3">
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'section-I-1-table-header2'"/>
					</xsl:call-template>					
					<span class="ng-binding"></span>
				</th>
			</tr>
			<tr>
				<th class="confirmed-a">
					<span>(a)</span>
					<br></br>
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'table-confirmed-a'"/>
					</xsl:call-template>	
						
						<span>*</span>
				</th>
				<th class="confirmed-b">
					<span>(b)</span>
					<br></br>
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'table-confirmed-b'"/>
					</xsl:call-template>	
						
						<span>*</span>
				</th>
				<th class="confirmed-c">
					<span>(c)</span>
					<br></br>
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'table-confirmed-c'"/>
					</xsl:call-template>	
						
						<span>*</span>
				</th>
			</tr>
			</thead>
			<tbody>
				<tr id="bulk-hfcs-verification-confirmation">
					<td rowspan="5" class="confirmation no-bottom-border">
						<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../BulkHFCs/section_I_1/confirmation_a/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
					</td>
					<td rowspan="5" class="confirmation no-bottom-border">
						<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../BulkHFCs/section_I_1/confirmation_b/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>								
							</xsl:if>
						</input>
							<xsl:if test="../BulkHFCs/section_I_1/confirmation_b/option_1 = 'true'">
								<span >
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
								</xsl:call-template>
								</span>								
							</xsl:if>
							<xsl:if test="../BulkHFCs/section_I_1/confirmation_b/option_2 = 'true'">
								<span >
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
									</xsl:call-template>
								</span>		
							</xsl:if>
							<xsl:if test="../BulkHFCs/section_I_1/confirmation_b/option_3 = 'true'">
								<span >
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
									</xsl:call-template>
								</span>		
							</xsl:if>
							<xsl:if test="../BulkHFCs/section_I_1/confirmation_b/option_4 = 'true'">
								<span >
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
									</xsl:call-template>
								</span>		<br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_1/confirmation_b/option_4_reason"/></xsl:call-template></span>
							</xsl:if>
						
					</td>
					<td rowspan="5" class="confirmation no-bottom-border">
						<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../BulkHFCs/section_I_1/confirmation_c/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>								
							</xsl:if>
						</input>
						<xsl:if test="../BulkHFCs/section_I_1/confirmation_c/option_1 = 'true'">
							<span >
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
								</xsl:call-template>
							</span>		
						</xsl:if>
						<xsl:if test="../BulkHFCs/section_I_1/confirmation_c/option_2 = 'true'">
							<span >
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
								</xsl:call-template>
							</span>		
						</xsl:if>
						<xsl:if test="../BulkHFCs/section_I_1/confirmation_c/option_3 = 'true'">
							<span >
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
								</xsl:call-template>
							</span>		
						</xsl:if>
						<xsl:if test="../BulkHFCs/section_I_1/confirmation_c/option_4 = 'true'">
							<span >
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
								</xsl:call-template>
							</span>		<br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_1/confirmation_c/option_4_reason"/></xsl:call-template></span>
						</xsl:if>
						
					</td>
					
				</tr>
				<tr>					
					<xsl:for-each select="ReportedGases">	
						<td >
								<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template></span>
							</td>								
					</xsl:for-each>	
				</tr>
				<tr>
					<xsl:for-each select="ReportedGases">	
						<td >
							<span><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'section-II-1-table-component-gwp'"/>
							</xsl:call-template>:
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="GWP_AR4_AnnexIV"/></xsl:call-template></span>
						</td>								
					</xsl:for-each>		
				</tr>
				<tr>
					<xsl:for-each select="ReportedGases">	
						<td >
							<span class="ng-scope">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-1-table-component-composition'"/>
								</xsl:call-template>
							</span>	
						</td>
					</xsl:for-each>		
				</tr>
				<tr>					
					<xsl:for-each select="ReportedGases">	
						<!--<xsl:for-each select="BlendComponents/Component">-->
						<td style="text-align: center; padding: 0px;vertical-align: top;" class="ng-scope">
							<table class="table table-hover table-bordered bulk-hfcs-selection-componets">
								<thead>
									<tr>
										<th class="component">
											<span class="ng-scope">											
												<xsl:call-template name="getLabel">
													<xsl:with-param name="labelName" select="'section-II-1-table-component-component'"/>
												</xsl:call-template>
											</span>
										</th>
										<th class="percentage">
											<span dclass="ng-scope">
												
												<xsl:call-template name="getLabel">
													<xsl:with-param name="labelName" select="'section-II-1-table-component-percentage'"/>
												</xsl:call-template>
											</span>
										</th>
										<th class="gwp">
											<span class="ng-scope">												
												<xsl:call-template name="getLabel">
													<xsl:with-param name="labelName" select="'section-II-1-table-component-gwp'"/>
												</xsl:call-template>
											</span>
										</th>
									</tr>
								</thead>														
								<tbody>
									<xsl:if test="count(BlendComponents/Component) = 1">
										
										<tr>
											<td colspan="3">
												<span>
													<xsl:call-template name="getLabel">
														<xsl:with-param name="labelName" select="'section-I-1-table-component-not-applicable'"/>
													</xsl:call-template>
												</span>	
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="count(BlendComponents/Component) &gt; 1">	
										<xsl:for-each select="BlendComponents/Component">
										<tr>
										
																							
												<td>
													<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Code"/></xsl:call-template>	
												</td>
											<td>
												<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Percentage"/></xsl:call-template>	
											</td>
											<td>
												<xsl:call-template name="getValue"><xsl:with-param name="elem" select="GWP_AR4_AnnexIV"/></xsl:call-template>	
											</td>
											
										</tr>
										</xsl:for-each>
											
									</xsl:if>
								</tbody>
							</table>
						</td>
					</xsl:for-each>						
				</tr>
				<tr>
					<td class="no-top-border no-bottom-border"></td>
					<td class="no-top-border no-bottom-border"></td>
					<td colspan="4" class="no-top-border">
						<span class="ng-scope">							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'table-confirmed-a-description'"/>
							</xsl:call-template>
						</span>
					</td>
				</tr>
				<tr>
					<td class="no-top-border no-bottom-border"></td>
					<td colspan="5" class="no-top-border">
						<span class="ng-scope">							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'table-confirmed-b-description'"/>
							</xsl:call-template>
						</span>
					</td>
				</tr>
				<tr>
					<td colspan="6" class="no-top-border">
						<span class="ng-scope">							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'table-confirmed-c-description'"/>
							</xsl:call-template>
						</span>
					</td>
				</tr>
			</tbody>
		</table>		
		
		<h2><span class="ng-scope">
			<xsl:call-template name="getLabel">
				<xsl:with-param name="labelName" select="'section-I-2-section-title'"/>
			</xsl:call-template>
		</span></h2>
		
		<table class="table table-hover table-bordered table-bordered-full fixed-table bulk-hfcs-amounts ng-scope" style="font-size: 90%;">
    <thead>
        <tr>
            <th>
            	<xsl:attribute name="colspan">
            		<xsl:value-of select="count(//ReportedGases) + 6" />
            	</xsl:attribute>
            	<span class="ng-scope">
            	
            	<xsl:call-template name="getLabel">
            		<xsl:with-param name="labelName" select="'section-I-2-table-title'"/>
            	</xsl:call-template></span></th>
        </tr>
        <tr>
            <th class="" colspan="3" rowspan="2">
                <span class="ng-scope">                	
                	<xsl:call-template name="getLabel">
                		<xsl:with-param name="labelName" select="'section-I-1-table-header1'"/>
                	</xsl:call-template>                	
                </span>
            </th>
            <th class="transaction-code" rowspan="4">
                <span class="ng-scope">
                	<xsl:call-template name="getLabel">
                		<xsl:with-param name="labelName" select="'section-I-2-table-transaction-code'"/>
                	</xsl:call-template>               	
                </span>
            </th>
            <th class="transaction" rowspan="4">
            	<span class="ng-scope">
            		<xsl:call-template name="getLabel">
            			<xsl:with-param name="labelName" select="'section-I-2-table-transaction'"/>
            		</xsl:call-template> 
            	</span>
            </th>
            <th class="">
            	<xsl:attribute name="colspan">
            		<xsl:value-of select="count(//ReportedGases) + 1" />
            	</xsl:attribute>
                <span class="ng-scope">
                	<xsl:call-template name="getLabel">
                		<xsl:with-param name="labelName" select="'section-I-2-table-header4'"/>
                	</xsl:call-template>
                </span>            	
            	<span class="ng-binding"></span>
            </th>
        </tr>
        <tr>
            <th class="" rowspan="2">
            	<span class="ng-scope">
            		<xsl:call-template name="getLabel">
            			<xsl:with-param name="labelName" select="'section-I-2-table-total-hfcs'"/>
            		</xsl:call-template>
            	</span>
            </th>
        	<xsl:for-each select="ReportedGases">	
            	<th class="reported-gas ng-scope" >
            		<span class="ng-binding"><xsl:call-template name="getValue">
            			<xsl:with-param name="elem" select="Name"/></xsl:call-template>	
            		</span>
            	</th>
        	</xsl:for-each>
        </tr>
        <tr>
            <th class="confirmed-a">
                <span>(a)</span>
                <br></br>
                <span class="ng-scope">
                	<xsl:call-template name="getLabel">
                		<xsl:with-param name="labelName" select="'table-confirmed-a'"/>
                	</xsl:call-template>
                </span>
                <span>*</span>
            </th>
            <th class="confirmed-b">
                <span>(b)</span>
                <br></br>
                <span class="ng-scope">
                	<xsl:call-template name="getLabel">
                		<xsl:with-param name="labelName" select="'table-confirmed-b'"/>
                	</xsl:call-template>
                </span>
                <span>*</span>
            </th>
            <th class="confirmed-c">
                <span>(c)</span>
            	<br></br>
                <span class="ng-scope">
                	<xsl:call-template name="getLabel">
                		<xsl:with-param name="labelName" select="'table-confirmed-c'"/>
                	</xsl:call-template>
                </span>
                <span>*</span>
            </th>
        	<xsl:for-each select="ReportedGases">    
            	<th class="reported-gas ng-scope">               
            	<span class="ng-scope">
            		<xsl:call-template name="getLabel">
            			<xsl:with-param name="labelName" select="'section-II-1-table-component-gwp'"/>
            		</xsl:call-template>
            		: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="GWP_AR4_AnnexIV"/></xsl:call-template></span>
            </th>
        	</xsl:for-each>
        </tr>
        <tr> 
            <th class="confirmed-note" colspan="3">
                <span>* </span>
            	<span class="ng-scope">            		
            		<xsl:call-template name="getLabel">
            			<xsl:with-param name="labelName" select="'table-confirmed-note'"/>
            		</xsl:call-template>
            	</span>
            </th>
        	
            <th class="">
                <span>[
                	<xsl:call-template name="getLabel">
                		<xsl:with-param name="labelName" select="'unit-co2eq'"/>
                	</xsl:call-template>
                	]
                </span>
            </th>
        	<xsl:for-each select="ReportedGases"><th class="tones-gas ng-scope" ng-repeat="reportedGas in instance.Verification.ReportedBulk.ReportedGases">
                <span class="ng-scope">[
                	<xsl:call-template name="getLabel">
                		<xsl:with-param name="labelName" select="'section-I-2-table-tones-gas'"/>
                	</xsl:call-template>
                	]</span>
            </th>
        	</xsl:for-each>
        </tr>
    </thead>
			
    <tbody>
    	<tr id="bulk-hfcs-verification-confirmation-tr_01A" ng-repeat="transaction in instance.Verification.ReportedBulk.Transactions" class="ng-scope">    		
    		<td class="confirmation no-bottom-border" >
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01A/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation no-bottom-border">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01A/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    				
    				
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_01A/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation no-bottom-border">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01A/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_01A/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
            <td class="transaction-code">
                <span class="ng-binding">1A</span>
            </td>
            <td class="transaction">
                <span style="white-space: pre-wrap;" class="ng-binding">Total quantity of production from facilities in the Union, including amounts produced as by-products and amounts not captured</span>                
            </td>
            <td class="tco2e">
            	<span class="ng-binding"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_01A']/tco2e"/></xsl:call-template></span>
            </td>
    		<xsl:for-each select="Transactions[id='tr_01A']/gases">
    			<td ng-repeat="reportedGas in transaction.gases" class="amount ng-scope" ng-class="(reportedGas.amount === undefined) ? 'amount disabled' : 'amount'" data-bs-toggle="tooltip" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
            	</td>
    		</xsl:for-each>
        </tr>
    	<tr id="bulk-hfcs-verification-confirmation-tr_01A_a_own" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_01A_a_own/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">1A_a_own</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;" class="ng-binding">Total products and equipment covered by Article 19(1) of Regulation (EU) 2024/573</span>  
    			<div class="ng-scope">
    				<br></br>
    					<span class="formula ng-binding">Calculated: [11_R = 13Bb = 11_G + 11_J1]</span>
    			</div>
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_01A_a_own']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_01A_a_own']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	<tr id="bulk-hfcs-verification-confirmation-tr_01A_a_other" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_c/option_1 = 'true'">
    				<span >
    					<xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_01A_a_other/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">1A_a_other</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;" class="ng-binding">Amounts not captured, in-line destruction by another undertaking</span>      			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_01A_a_other']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_01A_a_other']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	<tr id="bulk-hfcs-verification-confirmation-tr_01B" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01B/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01B/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01B/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01B/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01B/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01B/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_01B/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01B/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01B/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01B/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01B/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01B/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_01B/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">1B</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;" class="ng-binding">Quantity of production from facilities in the Union consisting of recovered by-production or unwanted products, where that by-production or those products have been destroyed in the facilities prior to the placing on the market</span>      			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_01B']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_01B']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_01C" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01C/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01C/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01C/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01C/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01C/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01C/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_01C/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_01C/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01C/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01C/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01C/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_01C/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_01C/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">1C</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Quantity of production from facilities in the Union consisting of recovered by-production or unwanted products where that by-production or those products have been handed over to other undertakings for destruction and had not been placed on the market previously.</span>      			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_01C']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_01C']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_02A" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02A/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02A/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02A/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02A/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02A/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02A/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_02A/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02A/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02A/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02A/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02A/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02A/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_02A/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">2A</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Total amount imported into the Union in bulk (all imports except goods under temporary storage)</span>      			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_02A']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_02A']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_02B" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02B/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02B/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02B/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02B/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02B/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02B/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_02B/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02B/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02B/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02B/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02B/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02B/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_02B/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">2B</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Amount imported into the Union by the reporting undertaking, including amounts purchased or received from other undertakings under a special customs procedure, not released for free circulation, and re-exported by the reporting undertaking contained in products or equipment (not in bulk)</span>      			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_02B']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_02B']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_02G" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02G/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02G/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02G/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02G/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02G/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02G/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_02G/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02G/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02G/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02G/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02G/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02G/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_02G/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">2G</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Amounts under special customs procedures, purchased/received from other undertakings</span>      			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_02G']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_02G']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_02H" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02H/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02H/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02H/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02H/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02H/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02H/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_02H/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02H/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02H/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02H/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02H/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02H/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_02H/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">2H</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Amounts under special customs procedures that have been sold or supplied to other undertakings</span>      			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_02H']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_02H']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_02I" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02I/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02I/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02I/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02I/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02I/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02I/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_02I/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_02I/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02I/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02I/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02I/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_02I/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_02I/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">2I</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Amount emitted under special customs procedures</span>      			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_02I']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_02I']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_03B" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_03B/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_03B/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_03B/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_03B/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_03B/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_03B/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_03B/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_03B/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_03B/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_03B/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_03B/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_03B/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_03B/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">3B</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Export of amounts previously not placed on the market</span>      			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_03B']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_03B']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_04C" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_04C/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_04C/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04C/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04C/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04C/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04C/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_04C/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_04C/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04C/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04C/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04C/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04C/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_04C/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">4C</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Stocks on 1 January of quantities from own import or production or from own purchases under special customs procedures, previously not placed on the EU market, excluding goods under temporary storage</span>      			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_04C']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_04C']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_04H" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_04H/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_04H/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04H/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04H/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04H/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04H/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_04H/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_04H/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04H/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04H/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04H/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_04H/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_04H/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">4H</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Stocks on 31 December of quantities from own import or production or from own purchases under special customs procedures, previously not placed on the EU market, excluding goods under temporary storage</span>      			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_04H']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_04H']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_04M" class="ng-scope">    		
    		<td class="disabled">    			
    		</td>
    		<td  class="disabled">    			
    		</td>
    		<td  class="disabled">    			
    		</td>
    		<td class="transaction-code">
    			<span class="ng-binding">4M</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Total amount physically placed on the market</span>  
    			<div class="ng-scope">
    				<br></br>
    				<span class="formula ng-binding">Calculated: [4M = 1A – 1B – 1C – 1A_a_own – 1A_a_other + 2A – 2B + 2G – 2H – 2I – 3B + 4C – 4H]</span>
    			</div>    			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_04M']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_04M']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_05A" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05A/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05A/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05A/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05A/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05A/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05A/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_05A/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05A/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05A/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05A/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05A/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05A/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_05A/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">5A</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Quantity imported into the Union for destruction</span>      					
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_05A']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_05A']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_05B" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05B/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05B/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05B/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05B/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05B/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05B/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_05B/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05B/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05B/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05B/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05B/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05B/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_05B/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">5B</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Quantity used by a producer or importer in feedstock applications or supplied directly by a producer or an importer to undertakings for use in feedstock applications</span>      					
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_05B']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_05B']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_05C_exempted" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_5C_exempted_CO2e/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">5C_exempted</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Quantity supplied directly to undertakings for export out of the Union, where those quantities were not subsequently made available to another party within the Union prior to export</span>      					
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_5C_exempted_CO2e']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_5C_exempted_CO2e']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<!--<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="(amount)"/></xsl:call-template></span>--> 
    				<xsl:variable name="rawAmount">
    					<xsl:call-template name="getValue">
    						<xsl:with-param name="elem" select="amount"/>
    					</xsl:call-template>
    				</xsl:variable>
    				<xsl:value-of select="round($rawAmount)"/>
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_05D" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05D/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05D/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05D/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05D/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05D/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05D/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_05D/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05D/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05D/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05D/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05D/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05D/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_05D/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">5D</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Quantity supplied directly for use in military equipment</span>      					
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_05D']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_05D']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_05E" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05E/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05E/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05E/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05E/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05E/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05E/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_05E/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05E/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05E/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05E/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05E/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05E/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_05E/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">5E</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Quantity supplied directly to an undertaking using it for the etching of semiconductor material or the cleaning of chemicals vapour deposition chambers within the semiconductor manufacturing sector</span>      					
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_05E']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_05E']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_05F" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05F/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05F/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05F/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05F/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05F/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05F/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_05F/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_05F/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05F/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05F/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05F/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_05F/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_05F/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">5F</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Quantity supplied directly to an undertaking producing metered dose inhalers for the delivery of pharmaceutical ingredients</span>      					
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_05F']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_05F']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_05I" class="ng-scope">    		
    		<td class="disabled">    			
    		</td>
    		<td  class="disabled">    			
    		</td>
    		<td  class="disabled">    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">5I</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Total quantities of exempted uses of hydrofluorocarbons</span>      	
    			<div class="ng-scope">
    				<br></br>
    				<span class="formula ng-binding">Calculated: [5I = 5A + 5B + 5C_exempted + 5D + 5E]</span>
    			</div>    	
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_05I']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_05I']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_05J" class="ng-scope">    		
    		<td class="disabled">    			
    		</td>
    		<td  class="disabled">    			
    		</td>
    		<td  class="disabled">    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">5J</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Calculated amount of hydrofluorocarbons physically placed on the market, excluding exempted uses </span>      	
    			<div class="ng-scope">
    				<br></br>
    				<span class="formula ng-binding">Calculated: [5J = 4M – 5I]</span>
    			</div>    	
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_05J']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_05J']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_09A_imp" class="ng-scope">    		
    		<td class="disabled">    			
    		</td>
    		<td  class="disabled">    			
    		</td>
    		<td  class="disabled">    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">9A_imp</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Quota authorisations given to importers of refrigeration, air conditioning and heat pump equipment charged with hydrofluorocarbons (automatically imported from the HFC registry)</span>    				
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_09A_imp']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_09A_imp']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_09A_add" class="ng-scope">    		
    		<td class="disabled">    			
    		</td>
    		<td  class="disabled">    			
    		</td>
    		<td  class="disabled">    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">9A_add</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Quota authorisations given to importers of refrigeration, air conditioning and heat pump equipment charged with hydrofluorocarbons (additional to registry data)</span>    				
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_09A_add']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_09A_add']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_09A" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_09A/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_09A/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09A/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09A/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09A/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09A/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_09A/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_09A/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09A/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09A/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09A/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09A/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_09A/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">9A</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Quota authorisations given to importers of refrigeration, air conditioning and heat pump equipment charged with hydrofluorocarbons
    			</span>
    			<div class="ng-scope">
    				<br></br>
    				<span class="formula ng-binding">Calculated: [9A = 9A_imp + 9A_add]</span>
    			</div>  
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_09A']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_09A']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_09C" class="ng-scope">    		
    		<td class="disabled">    			
    		</td>
    		<td  class="disabled">    			
    		</td>
    		<td  class="disabled">    			
    		</td>
    		<td class="transaction-code">
    			<span class="ng-binding">9C</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Total amount of hydrofluorocarbons regarded as placed on the EU market (including authorisations)</span>
    			<div class="ng-scope">
    				<br></br>
    				<span class="formula ng-binding">Calculated: [9C = 4M + 9A]</span>
    			</div>  
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_09C']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_09C']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_09F" class="ng-scope">    		
    		<td class="confirmation no-bottom-border">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_09F/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation no-bottom-border">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_09F/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09F/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09F/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09F/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09F/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_09F/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation no-bottom-border">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../BulkHFCs/section_I_2/tr_09F/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09F/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09F/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09F/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../BulkHFCs/section_I_2/tr_09F/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_2/tr_09F/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">9F</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;">Total calculated need of quota for hydrofluorocarbons placed on the market</span>
    			<div class="ng-scope">
    				<br></br>
    				<span class="formula ng-binding">Calculated: [9F = 5J + 9A]</span>
    			</div>  
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_09F']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_09F']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>   	
    	
    	<!--**********************************************************************************-->
        <tr>
        	<td class="no-top-border no-bottom-border"></td>
        	<td class="no-top-border no-bottom-border"></td>
        	<td class="no-top-border" >
            	<xsl:attribute name="colspan">
            		<xsl:value-of select="count(//ReportedGases) + 4" />
            	</xsl:attribute>
        		<span data-translate="bulk-hfcs-verification.table-confirmed-a-description" class="ng-scope">Auditor’s statement, option c: Based on the verification conducted, we cannot provide reasonable assurance that the data reported in the section defined by the respective transaction code is free from material misstatement.</span>
        		
            </td>
        </tr>
        <tr>
        	<td class="no-top-border no-bottom-border"></td>
        	<td class="no-top-border">
            	<xsl:attribute name="colspan">
            		<xsl:value-of select="count(//ReportedGases) + 5" />
            	</xsl:attribute>
        		<span data-translate="bulk-hfcs-verification.table-confirmed-b-description" class="ng-scope">Auditor’s statement, option b: We provide reasonable assurance that the data reported in the section defined by the respective transaction code is accurate, complete, and free from material misstatement, though the following observations warrant attention.</span>
            </td>
        </tr>
        <tr>
        	<td class="no-top-border">
            	<xsl:attribute name="colspan">
            		<xsl:value-of select="count(//ReportedGases) + 6" />
            	</xsl:attribute>
        		<span data-translate="bulk-hfcs-verification.table-confirmed-c-description" class="ng-scope">Auditor’s statement, option a: We confirm with reasonable assurance that the data reported in the section defined by the respective transaction code is accurate, complete, and free from material misstatement.</span>
            </td>
        </tr>
    </tbody>
</table>
		<xsl:call-template name="BulkHFCsSection3"></xsl:call-template>		
		<xsl:call-template name="BulkHFCsSection4"></xsl:call-template>
		</xsl:if>	
</xsl:template>

	
	<xsl:template name="BulkHFCsSection3">
		<h2><span>Section I-3: Summary verification statement on bulk HFC verification pursuant to Art 26(8) of Regulation (EU) 2024/573</span></h2>
		
	<table class="section-3">
		<thead>
				<tr>
					<th class="confirmed-a">
						<span>(a)</span>
						<br></br>
							<span data-translate="bulk-hfcs-verification.table-confirmed-a" class="ng-scope">Fully confirmed</span>
							
					</th>
					<th class="confirmed-b">
						<span>(b)</span>
						<br></br>
							<span data-translate="bulk-hfcs-verification.table-confirmed-b" class="ng-scope">Confirmed with reservations</span>
							
					</th>
					<th class="confirmed-c">
						<span>(c)</span>
						<br></br>
							<span data-translate="bulk-hfcs-verification.table-confirmed-c" class="ng-scope">Not confirmed</span>
							
					</th>
				</tr>
			</thead>
			<tbody>
				<tr id="bulk-hfcs-verification-section-3-confirmation">
					<td id="bulk-hfcs-verification-section-3-confirmation-a" class="confirmation">
						<input class="" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../BulkHFCs/section_I_3/confirmation_a/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<label class="form-check-label ng-binding" for="verification-confirm-I-3-a" data-bs-toggle="tooltip" data-tooltip="This option can only be chosen if the HFC selection and all bulk HFC transactions were fully confirmed.">a) We confirm with reasonable assurance, in accordance with Regulation (EU) 2024/573, that the reported data summarised in parts 1 and 2 of the bulk HFC verification table above is accurate, complete, and free from material misstatement.</label>
					</td>
					<td id="bulk-hfcs-verification-section-3-confirmation-b" class="confirmation">
						<input class="" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../BulkHFCs/section_I_3/confirmation_b/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<label class="form-check-label ng-binding" for="verification-confirm-I-3-b" data-bs-toggle="tooltip" data-tooltip="This option cannot be chosen if reasonable assurance was denied for the HFC selection or any bulk HFC transaction.">b) We provide reasonable assurance, in accordance with Regulation (EU) 2024/573, that the reported data summarised in parts 1 and 2 of the bulk HFC verification table above is accurate, complete, and free from material misstatement, though the following observations warrant attention.</label>
						<br/><br/>
						<xsl:if test="../BulkHFCs/section_I_3/confirmation_b/checked = 'true'">
							<xsl:if test="../BulkHFCs/section_I_3/confirmation_b/option_1 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-2-table-option-b1'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<xsl:if test="../BulkHFCs/section_I_3/confirmation_b/option_2 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-2-table-option-b2'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<xsl:if test="../BulkHFCs/section_I_3/confirmation_b/option_3 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-2-table-option-b3'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<xsl:if test="../BulkHFCs/section_I_3/confirmation_b/option_4 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-2-table-option-b4'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
						</xsl:if>
						<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_3/confirmation_b/option_4_reason"/></xsl:call-template></span>
					</td>
					<td id="bulk-hfcs-verification-section-3-confirmation-c" class="confirmation">
						<input class="" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../BulkHFCs/section_I_3/confirmation_c/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<label class="form-check-label ng-binding" for="verification-confirm-I-3-c" data-bs-toggle="tooltip" data-tooltip="This option must be chosen if reasonable assurance was denied for the HFC selection or any bulk HFC transaction.">c) Based on the verification conducted, we cannot provide reasonable assurance, in accordance with Regulation (EU) 2024/573, that the reported data in parts 1 and 2 of the bulk HFC verification table above is free from material misstatement</label>
						<br/><br/>
						<xsl:if test="../BulkHFCs/section_I_3/confirmation_c/checked = 'true'">
							<xsl:if test="../BulkHFCs/section_I_3/confirmation_c/option_1 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-2-table-option-c1'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<xsl:if test="../BulkHFCs/section_I_3/confirmation_c/option_2 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-2-table-option-c2'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<xsl:if test="../BulkHFCs/section_I_3/confirmation_c/option_3 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-2-table-option-c3'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<xsl:if test="../BulkHFCs/section_I_3/confirmation_c/option_4 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-I-2-table-option-c4'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
						</xsl:if>
						<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_3/confirmation_c/option_4_reason"/></xsl:call-template></span>
					</td>
				</tr>
			</tbody>
		</table>
		
	</xsl:template>
	
	<xsl:template name="BulkHFCsSection4">
		<h2><span>Section I-4: Upload of bulk verification report</span></h2>
		<div class="hfcs-verification-section ng-scope" ng-include="" src="'section_I_4.html'"><div class="ng-scope">
			<p data-translate="bulk-hfcs-verification.section-I-4-upload-document-text" class="ng-scope">Please upload a copy of the full verification report. In case the verification report covers both placing on the market of bulk HFCs (Article 26(8) of the Regulation) and placing on the market of HFCs in imported products/equipment (Article 26(7) of the Regulation), the same document may need to be uploaded twice, i.e. separately for both verification reporting obligations.</p>
			<div class="ng-scope">
				
				<a id="bulk-hfcs-verification-verification-report"  target="_blank" class="ng-binding">
					<xsl:attribute name="href">
						<xsl:value-of select="translate(../BulkHFCs/section_I_4/VerificationReport/Url,' ','_')"/>
					</xsl:attribute>
					<xsl:call-template name="getValue"><xsl:with-param name="elem" select="../BulkHFCs/section_I_4/VerificationReport/Url"/></xsl:call-template>
				</a>				
			</div>	
		</div>
		</div>
	</xsl:template>
	
	<!-- ******************************************EQUIPMENT************************************************ -->
	
	<xsl:template match="ReportedEquipment">
		<xsl:if test="../VerificationScope/Equipment='true'">
			<h2>
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'equipment'"/>
				</xsl:call-template>
			</h2>
		<h2>
			<xsl:call-template name="getLabel">
				<xsl:with-param name="labelName" select="'section-II-1-section-title'"/>
			</xsl:call-template>
		</h2>
		<table id="table-reportedEquipment" class="table table-hover table-bordered table-bordered-full">
			<colgroup>
				<!-- 3 columnas de confirmation -->
				<col style="width: 5%;"/>
				<col style="width: 5%;"/>
				<col style="width: 5%;"/>
			</colgroup>
			<thead>
			<tr>
				<th colspan="6">
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'section-II-1-table-title'"/>
					</xsl:call-template>
				</th>
				
			</tr>
			<tr>
				<th class="" colspan="3">
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'section-II-1-table-header1'"/>
					</xsl:call-template>
				</th>	
				<th class="reported-hfc-title" colspan="3" rowspan="3">
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'section-II-1-table-header2'"/>
					</xsl:call-template>					
					<span class="ng-binding"></span>
				</th>
			</tr>
			<tr>
				<th class="confirmed-a">
					<span>(a)</span>
					<br></br>
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'table-confirmed-a'"/>
					</xsl:call-template>	
						
						<span>*</span>
				</th>
				<th class="confirmed-b">
					<span>(b)</span>
					<br></br>
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'table-confirmed-b'"/>
					</xsl:call-template>	
						
						<span>*</span>
				</th>
				<th class="confirmed-c">
					<span>(c)</span>
					<br></br>
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'table-confirmed-c'"/>
					</xsl:call-template>	
						
						<span>*</span>
				</th>
			</tr>
			</thead>
			<tbody>
				<tr id="bulk-hfcs-verification-confirmation">
					<td rowspan="5" class="confirmation no-bottom-border">
						<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../EquipmentHFCs/section_II_1/confirmation_a/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
					</td>
					<td rowspan="5" class="confirmation no-bottom-border">
						<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../EquipmentHFCs/section_II_1/confirmation_b/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>								
							</xsl:if>
						</input>
						<xsl:if test="../EquipmentHFCs/section_II_1/confirmation_b/option_1 = 'true'">
								<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
							</xsl:if>
						<xsl:if test="../EquipmentHFCs/section_II_1/confirmation_b/option_2 = 'true'">
								<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
							</xsl:if>
						<xsl:if test="../EquipmentHFCs/section_II_1/confirmation_b/option_3 = 'true'">
								<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
							</xsl:if>
						<xsl:if test="../EquipmentHFCs/section_II_1/confirmation_b/option_4 = 'true'">
							<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_1/confirmation_b/option_4_reason"/></xsl:call-template></span>
							</xsl:if>
						
					</td>
					<td rowspan="5" class="confirmation no-bottom-border">
						<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../EquipmentHFCs/section_II_1/confirmation_c/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>								
							</xsl:if>
						</input>
						<xsl:if test="../EquipmentHFCs/section_II_1/confirmation_c/option_1 = 'true'">
							<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
						</xsl:if>
						<xsl:if test="../EquipmentHFCs/section_II_1/confirmation_c/option_2 = 'true'">
							<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
						</xsl:if>
						<xsl:if test="../EquipmentHFCs/section_II_1/confirmation_c/option_3 = 'true'">
							<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
						</xsl:if>
						<xsl:if test="../EquipmentHFCs/section_II_1/confirmation_c/option_4 = 'true'">
							<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_1/confirmation_c/option_4_reason"/></xsl:call-template></span>
						</xsl:if>
						
					</td>
					
				</tr>
				<tr>					
					<xsl:for-each select="ReportedGases">	
							<td >
								<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template></span>
							</td>								
					</xsl:for-each>	
				</tr>
				<tr>
					<xsl:for-each select="ReportedGases">	
						<td >
							<span><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'section-II-1-table-component-gwp'"/>
							</xsl:call-template>:
								<xsl:call-template name="getValue"><xsl:with-param name="elem" select="GWP_AR4_AnnexIV"/></xsl:call-template></span>
						</td>								
					</xsl:for-each>		
				</tr>
				<tr>
					<xsl:for-each select="ReportedGases">	
						<td >
							<span class="ng-scope">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-II-1-table-component-composition'"/>
							</xsl:call-template>
							
						</span>
						</td>								
					</xsl:for-each>		
				</tr>
				<tr>
					
					<xsl:for-each select="ReportedGases">	
						<!--<xsl:for-each select="BlendComponents/Component">-->
						<td style="text-align: center; padding: 0px;vertical-align: top;" class="ng-scope">
							<table class="table table-hover table-bordered bulk-hfcs-selection-componets">
								<thead>
									<tr>
										<th class="component">
											<span class="ng-scope">											
												<xsl:call-template name="getLabel">
													<xsl:with-param name="labelName" select="'section-II-1-table-component-component'"/>
												</xsl:call-template>
											</span>
										</th>
										<th class="percentage">
											<span dclass="ng-scope">
												
												<xsl:call-template name="getLabel">
													<xsl:with-param name="labelName" select="'section-II-1-table-component-percentage'"/>
												</xsl:call-template>
											</span>
										</th>
										<th class="gwp">
											<span class="ng-scope">												
												<xsl:call-template name="getLabel">
													<xsl:with-param name="labelName" select="'section-II-1-table-component-gwp'"/>
												</xsl:call-template>
											</span>
										</th>
									</tr>
								</thead>														
								<tbody>
									<xsl:if test="count(BlendComponents/Component) = 1">
										
										<tr>
											<td colspan="3">
												<span>Not applicable.</span>	
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="count(BlendComponents/Component) &gt; 1">	
										<xsl:for-each select="BlendComponents/Component">
										<tr>								
																							
												<td>
													<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Code"/></xsl:call-template>	
												</td>
											<td>
												<xsl:call-template name="getValue"><xsl:with-param name="elem" select="Percentage"/></xsl:call-template>	
											</td>
											<td>
												<xsl:call-template name="getValue"><xsl:with-param name="elem" select="GWP_AR4_AnnexIV"/></xsl:call-template>	
											</td>
											
										</tr>
										</xsl:for-each>
											
									</xsl:if>
								</tbody>
							</table>
						</td>
					</xsl:for-each>						
				</tr>
				<tr>
					<td class=" no-top-border no-bottom-border"></td>
					<td class=" no-top-border no-bottom-border"></td>
					<td colspan="4" class="no-top-border">
						<span class="ng-scope">							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'table-confirmed-a-description'"/>
							</xsl:call-template>
						</span>
					</td>
				</tr>
				<tr>
					<td class=" no-top-border no-bottom-border"></td>
					<td colspan="5" class="no-top-border">
						<span class="ng-scope">							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'table-confirmed-b-description'"/>
							</xsl:call-template>
						</span>
					</td>
				</tr>
				<tr>
					<td colspan="6" class="no-top-border">
						<span class="ng-scope">							
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'table-confirmed-c-description'"/>
							</xsl:call-template>
						</span>
					</td>
				</tr>
			</tbody>
		</table>		
		
		<h2><span class="ng-scope">
			
			<xsl:call-template name="getLabel">
				<xsl:with-param name="labelName" select="'section-II-2-section-title'"/>
			</xsl:call-template>
			</span></h2>
		
		<table class="table table-hover table-bordered table-bordered-full fixed-table bulk-hfcs-amounts ng-scope" style="font-size: 90%; border-left:none ;border-right:none;">
    <thead>
        <tr>
            <th >
            	<xsl:attribute name="colspan">
            		<xsl:value-of select="count(//ReportedGases) + 6" />
            	</xsl:attribute>
            	<span class="ng-scope">            	
            	<xsl:call-template name="getLabel">
            		<xsl:with-param name="labelName" select="'section-II-2-table-title'"/>
            	</xsl:call-template>
            </span></th>
        </tr>
    	<tr>
    		<th class="" colspan="3" rowspan="2">
    			<span class="ng-scope">                	
    				<xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-header1'"/>
    				</xsl:call-template>                	
    			</span>
    		</th>
    		<th class="transaction-code" rowspan="4">
    			<span class="ng-scope">
    				<xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-2-table-transaction-code'"/>
    				</xsl:call-template>               	
    			</span>
    		</th>
    		<th class="transaction" rowspan="4">
    			<span class="ng-scope">
    				<xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-2-table-transaction'"/>
    				</xsl:call-template> 
    			</span>
    		</th>
    		<th class="">
    			<xsl:attribute name="colspan">
    				<xsl:value-of select="count(//ReportedGases) + 1" />
    			</xsl:attribute>
    			<span class="ng-scope">
    				<xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-2-table-header4'"/>
    				</xsl:call-template>
    			</span>            	
    			<span class="ng-binding"></span>
    		</th>
    	</tr>
        <tr>
            <th class="" rowspan="2">
            	
            	<span class="ng-scope">
            		<xsl:call-template name="getLabel">
            		<xsl:with-param name="labelName" select="'section-I-2-table-total-hfcs'"/>
            	</xsl:call-template></span>
            </th>
        	<xsl:for-each select="ReportedGases">	
            	<th class="reported-gas ng-scope" >
            		<span class="ng-binding"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Name"/></xsl:call-template>	</span>
            	</th>
        	</xsl:for-each>
        </tr>
    	<tr>
    		<th class="confirmed-a">
    			<span>(a)</span>
    			<br></br>
    			<span class="ng-scope">
    				<xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'table-confirmed-a'"/>
    				</xsl:call-template>
    			</span>
    			<span>*</span>
    		</th>
    		<th class="confirmed-b">
    			<span>(b)</span>
    			<br></br>
    			<span class="ng-scope">
    				<xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'table-confirmed-b'"/>
    				</xsl:call-template>
    			</span>
    			<span>*</span>
    		</th>
    		<th class="confirmed-c">
    			<span>(c)</span>
    			<br></br>
    			<span class="ng-scope">
    				<xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'table-confirmed-c'"/>
    				</xsl:call-template>
    			</span>
    			<span>*</span>
    		</th>
    		<xsl:for-each select="ReportedGases">    
    			<th class="reported-gas ng-scope">               
    				<span class="ng-scope">
    					<xsl:call-template name="getLabel">
    						<xsl:with-param name="labelName" select="'section-II-1-table-component-gwp'"/>
    					</xsl:call-template>
    					: <xsl:call-template name="getValue"><xsl:with-param name="elem" select="GWP_AR4_AnnexIV"/></xsl:call-template></span>
    			</th>
    		</xsl:for-each>
    	</tr>
        <tr> 
            <th class="confirmed-note" colspan="3">
                <span>* </span><span data-translate="bulk-hfcs-verification.table-confirmed-note" class="ng-scope">See full wording of auditor’s statements at the bottom of the table</span>
            </th>
        	
            <th class="">
                <span>[t CO2e]</span>
            </th>
        	<xsl:for-each select="ReportedGases"><th class="tones-gas ng-scope" ng-repeat="reportedGas in instance.Verification.ReportedBulk.ReportedGases">
                <span data-translate="bulk-hfcs-verification.section-I-2-table-tones-gas" class="ng-scope">[tonnes of gas]</span>
            </th>
        	</xsl:for-each>
        </tr>
    </thead>
			
    <tbody>
    	<tr id="bulk-hfcs-verification-confirmation-tr_011G" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_11G/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_11G/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11G/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11G/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11G/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11G/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_11G/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_11G/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11G/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11G/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11G/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11G/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_11G/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
            <td class="transaction-code">
                <span class="ng-binding">11_G</span>
            </td>
            <td class="transaction">
            	<span style="white-space: pre-wrap;" class="ng-binding">Total refrigeration, air conditioning or heat pump equipment</span>                
            </td>
            <td class="tco2e">
            	<span class="ng-binding"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_11G']/tco2e"/></xsl:call-template></span>
            </td>
    		<xsl:for-each select="Transactions[id='tr_11G']/gases">
    			<td ng-repeat="reportedGas in transaction.gases" class="amount ng-scope" ng-class="(reportedGas.amount === undefined) ? 'amount disabled' : 'amount'" data-bs-toggle="tooltip" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
            	</td>
    		</xsl:for-each>
        </tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_011J1" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_11J1/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">11_J1</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;" class="ng-binding">Metered dose inhalers for the delivery of pharmaceutical ingredients</span>                
    		</td>
    		<td class="tco2e">
    			<span class="ng-binding"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_11J1']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_11J1']/gases">
    			<td ng-repeat="reportedGas in transaction.gases" class="amount ng-scope" ng-class="(reportedGas.amount === undefined) ? 'amount disabled' : 'amount'" data-bs-toggle="tooltip" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_011R" class="ng-scope">    		
    		<td class="confirmation">
    		</td>
    		<td  class="confirmation">
    		</td>
    		<td  class="confirmation">
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">11_R</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;" class="ng-binding">Total products and equipment covered by Article 19(1) of Regulation (EU) 2024/573</span>             
    			<div class="ng-scope">
    				<br></br>
    				<span class="formula ng-binding">Calculated: [11_R = 13Bb = 11_G + 11_J1]</span>
    			</div>  
    		</td>
    		<td class="tco2e">
    			<span class="ng-binding"><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_11R']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_11R']/gases">
    			<td ng-repeat="reportedGas in transaction.gases" class="amount ng-scope" ng-class="(reportedGas.amount === undefined) ? 'amount disabled' : 'amount'" data-bs-toggle="tooltip" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_12A" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_12A/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_12A/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12A/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12A/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12A/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12A/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_12A/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_12A/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12A/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12A/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12A/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12A/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_12A/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">12A</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;" class="ng-binding">Amount of hydrofluorocarbons charged into the imported refrigeration equipment, air conditioning equipment or heat pumps, released by customs for free circulation in the EU, for which the hydrofluorocarbons had previously been exported from the Union and which had been subject to the hydrofluorocarbon quota limitation for placing on the Union market</span>  
    			<!--<div class="ng-scope">
    				<br></br>
    					<span class="formula ng-binding">Calculated: [11_R = 13Bb = 11_G + 11_J1]</span>
    			</div>-->
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_12A']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_12A']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_12aA" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_12aA/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">12aA</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;" class="ng-binding">Amount of hydrofluorocarbons charged into the imported refrigeration equipment, air conditioning equipment or heat pumps, where the equipment (including the charge of hydrofluorocarbons) had previously been placed on the Union market and subsequently been exported from the Union prior to the re-import</span>      			
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_12aA']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_12aA']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_12B" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_12B/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_12B/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12B/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12B/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12B/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12B/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_12B/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_12B/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12B/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12B/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12B/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12B/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_12B/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">12B</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;" class="ng-binding">Amount of hydrofluorocarbons charged into the imported metered dose inhalers, released by customs for free circulation in the Union, for which the hydrofluorocarbons had previously been exported from the Union and which had been subject to the hydrofluorocarbon quota limitation for placing on the Union market</span>  
    			<!--<div class="ng-scope">
    				<br></br>
    					<span class="formula ng-binding">Calculated: [11_R = 13Bb = 11_G + 11_J1]</span>
    			</div>-->
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_12B']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_12B']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_12aB" class="ng-scope">    		
    		<td class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_12aB/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">12aB</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;" class="ng-binding">Amount of hydrofluorocarbons charged into the imported metered dose inhalers, where the inhalers (including the charge of hydrofluorocarbons) had previously been placed on the Union market and subsequently been exported from the Union prior to the re-import</span>  
    			<!--<div class="ng-scope">
    				<br></br>
    					<span class="formula ng-binding">Calculated: [11_R = 13Bb = 11_G + 11_J1]</span>
    			</div>-->
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_12aB']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_12aB']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	
    	<tr id="bulk-hfcs-verification-confirmation-tr_13D" class="ng-scope">    		
    		<td class="confirmation no-bottom-border">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_13D/confirmation_a/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>
    				</xsl:if>
    			</input>
    		</td>
    		<td  class="confirmation no-bottom-border">
    			<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_13D/confirmation_b/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_13D/confirmation_b/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_13D/confirmation_b/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_13D/confirmation_b/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_13D/confirmation_b/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_13D/confirmation_b/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>
    		<td  class="confirmation no-bottom-border">
    			<input class="" type="checkbox" >
					<xsl:attribute name="disabled">disabled</xsl:attribute>
    				<xsl:if test="../EquipmentHFCs/section_II_2/tr_13D/confirmation_c/checked = 'true'">
    					<xsl:attribute name="checked">checked</xsl:attribute>								
    				</xsl:if>
    			</input>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_13D/confirmation_c/option_1 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_13D/confirmation_c/option_2 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_13D/confirmation_c/option_3 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
    				</xsl:call-template></span>
    			</xsl:if>
    			<xsl:if test="../EquipmentHFCs/section_II_2/tr_13D/confirmation_c/option_4 = 'true'">
    				<span ><xsl:call-template name="getLabel">
    					<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
    				</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_13D/confirmation_c/option_4_reason"/></xsl:call-template></span>
    			</xsl:if>    			
    		</td>    		
    		<td class="transaction-code">
    			<span class="ng-binding">13D</span>
    		</td>
    		<td class="transaction">
    			<span style="white-space: pre-wrap;" class="ng-binding">Calculated amount of imported hydrofluorocarbons in need of authorisation to use HFC quota</span>
    			<div class="ng-scope">
    				<br></br>
    				<span class="formula ng-binding">Calculated: [13D = 12C = 11_R - 12A -12aA - 12B - 12aB]</span>
    			</div>
    		</td>
    		<td class="tco2e">
    			<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_13D']/tco2e"/></xsl:call-template></span>
    		</td>
    		<xsl:for-each select="Transactions[id='tr_13D']/gases">
    			<td  class="amount ng-scope" data-tooltip="">               
    				<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
    			</td>
    		</xsl:for-each>
    	</tr>
    	
    	
    	
    	<!--**********************************************************************************-->
        <tr>
        	<td class="no-top-border no-bottom-border"></td>
        	<td class="no-top-border no-bottom-border"></td>
        	<td class="no-top-border">
            	<xsl:attribute name="colspan">
            		<xsl:value-of select="count(//ReportedGases) + 4" />
            	</xsl:attribute>
                <span class="ng-scope">                	
                	<xsl:call-template name="getLabel">
                		<xsl:with-param name="labelName" select="'section-II-2-table1-confirmed-a-description'"/>
                	</xsl:call-template>
                </span>	
            </td>
        </tr>
        <tr>
        	<td class="no-top-border no-bottom-border"></td>
        	<td  class="no-top-border">
            	<xsl:attribute name="colspan">
            		<xsl:value-of select="count(//ReportedGases) + 5" />
            	</xsl:attribute>
                <span class="ng-scope">                	
                	<xsl:call-template name="getLabel">
                		<xsl:with-param name="labelName" select="'section-II-2-table1-confirmed-b-description'"/>
                	</xsl:call-template>
                </span>	
            </td>
        </tr>
        <tr>
        	<td colspan="7" class="no-top-border">
            	<xsl:attribute name="colspan">
            		<xsl:value-of select="count(//ReportedGases) + 6" />
            	</xsl:attribute>
                <span class="ng-scope">                	
                	<xsl:call-template name="getLabel">
                		<xsl:with-param name="labelName" select="'section-II-2-table1-confirmed-c-description'"/>
                	</xsl:call-template>
                </span>	
            </td>
        </tr>
    </tbody>
	
		
			
	<xsl:if test="Transactions[id='tr_11P']">
			<tbody >
				<tr style="height: 20px;">
					<td colspan="{@totalCols}" style="border: none;"></td> <!-- colspan para que ocupe todo el ancho -->
				</tr>
			</tbody>
			<tbody>
				
				
				<tr id="bulk-hfcs-verification-confirmation-tr_11P" class="ng-scope">    		
					<td class="confirmation no-bottom-border">
						<input class="" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../EquipmentHFCs/section_II_2/tr_11P/confirmation_a/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
					</td>
					<td  class="confirmation no-bottom-border">
						<input class="form-check-input ng-pristine ng-untouched ng-valid ng-scope" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../EquipmentHFCs/section_II_2/tr_11P/confirmation_b/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>								
							</xsl:if>
						</input>
						<xsl:if test="../EquipmentHFCs/section_II_2/tr_11P/confirmation_b/option_1 = 'true'">
							<span ><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'section-I-1-table-option-b1'"/>
							</xsl:call-template></span>
						</xsl:if>
						<xsl:if test="../EquipmentHFCs/section_II_2/tr_11P/confirmation_b/option_2 = 'true'">
							<span ><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'section-I-1-table-option-b2'"/>
							</xsl:call-template></span>
						</xsl:if>
						<xsl:if test="../EquipmentHFCs/section_II_2/tr_11P/confirmation_b/option_3 = 'true'">
							<span ><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'section-I-1-table-option-b3'"/>
							</xsl:call-template></span>
						</xsl:if>
						<xsl:if test="../EquipmentHFCs/section_II_2/tr_11P/confirmation_b/option_4 = 'true'">
							<span ><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'section-I-1-table-option-b4'"/>
							</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_11P/confirmation_b/option_4_reason"/></xsl:call-template></span>
						</xsl:if>    			
					</td>
					<td  class="confirmation no-bottom-border">
						<input class="" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../EquipmentHFCs/section_II_2/tr_11P/confirmation_c/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>								
							</xsl:if>
						</input>
						<xsl:if test="../EquipmentHFCs/section_II_2/tr_11P/confirmation_c/option_1 = 'true'">
							<span ><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'section-I-1-table-option-c1'"/>
							</xsl:call-template></span>
						</xsl:if>
						<xsl:if test="../EquipmentHFCs/section_II_2/tr_11P/confirmation_c/option_2 = 'true'">
							<span ><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'section-I-1-table-option-c2'"/>
							</xsl:call-template></span>
						</xsl:if>
						<xsl:if test="../EquipmentHFCs/section_II_2/tr_11P/confirmation_c/option_3 = 'true'">
							<span ><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'section-I-1-table-option-c3'"/>
							</xsl:call-template></span>
						</xsl:if>
						<xsl:if test="../EquipmentHFCs/section_II_2/tr_11P/confirmation_c/option_4 = 'true'">
							<span ><xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'section-I-1-table-option-c4'"/>
							</xsl:call-template></span><br></br><span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_2/tr_13D/confirmation_c/option_4_reason"/></xsl:call-template></span>
						</xsl:if>    			
					</td>    		
					<td class="transaction-code">
						<span class="ng-binding">11P</span>
					</td>
					<td class="transaction">
						<span style="white-space: pre-wrap;" class="ng-binding">Other products and equipment containing gases listed in Annexes I, II or III to Regulation (EU) 2024/573</span>
						<div class="ng-scope">
							<br></br>
							<span class="formula ng-binding">(other than reportable in sections 11_A – 11_O)</span>
						</div>
					</td>
					
					<td class="tco2e">
						<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="Transactions[id='tr_11P']/tco2e"/></xsl:call-template></span>
					</td>
					<xsl:for-each select="Transactions[id='tr_11P']/gases">
						<td  class="amount ng-scope" data-tooltip="">               
							<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="amount"/></xsl:call-template></span>    			
						</td>
					</xsl:for-each>
				</tr>
				
				
				<tr class="ng-scope">
					<td class="no-bottom-border no-top-border"></td>
					<td class="no-top-border no-bottom-border"></td>
					<td colspan="8" class="no-top-border" >
						<span data-translate="equipment-verification.section-II-2-table2-confirmed-a-description" class="ng-scope">Auditor’s statement, option c: Based on the verification conducted, we cannot provide reasonable assurance that the products / equipment reported in section 11_P are not covered by Article 19(1) of Regulation (EU) 2024/573.</span>
					</td>
				</tr>
				<tr class="ng-scope">
					<td class="no-top-border no-bottom-border"></td>
					<td class="no-top-border" colspan="9" >
						<span data-translate="equipment-verification.section-II-2-table2-confirmed-b-description" class="ng-scope">Auditor’s statement, option b: We provide reasonable assurance that the products / equipment reported in section 11_P are not covered by Article 19(1) of Regulation (EU) 2024/573, though the observations as indicated warrant attention.</span>
					</td>
				</tr>
				<tr class="ng-scope">
					<td class="no-top-border" colspan="10" >
						<span data-translate="equipment-verification.section-II-2-table2-confirmed-c-description" class="ng-scope">Auditor’s statement, option a: We confirm with reasonable assurance that the products / equipment reported in section 11_P are not covered by Article 19(1) of Regulation (EU) 2024/573.</span>
					</td>
				</tr>
			</tbody>
		
	</xsl:if>
			
			
</table>
			

			<xsl:call-template name="EquipmentHFCsSection3"></xsl:call-template>		
		<xsl:call-template name="EquipmentHFCsSection4"></xsl:call-template>
	    <xsl:call-template name="EquipmentHFCsSection5"></xsl:call-template>
		</xsl:if>	
</xsl:template>
	
	
	<xsl:template name="EquipmentHFCsSection3">
		<h2><span>
			<xsl:call-template name="getLabel">
				<xsl:with-param name="labelName" select="'section-II-3-section-title'"/>
			</xsl:call-template>
			</span></h2>
		
	<table class="section-3">
		<thead>
				<tr>
					<th class="confirmed-a">
						<span>(a)</span>
						<br></br>
						<span class="ng-scope">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'table-confirmed-a'"/>
							</xsl:call-template>
						</span>
						
					</th>
					<th class="confirmed-b">
						<span>(b)</span>
						<br></br>
						<span class="ng-scope">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'table-confirmed-b'"/>
							</xsl:call-template>
						</span>
							
					</th>
					<th class="confirmed-c">
						<span>(c)</span>
						<br></br>
						<span class="ng-scope">
							<xsl:call-template name="getLabel">
								<xsl:with-param name="labelName" select="'table-confirmed-c'"/>
							</xsl:call-template>
						</span>
							
					</th>
				</tr>
			</thead>
			<tbody>
				<tr id="bulk-hfcs-verification-section-3-confirmation">
					<td id="bulk-hfcs-verification-section-3-confirmation-a" class="confirmation">
						<input class="" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_a/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<label class="form-check-label ng-binding" for="verification-confirm-I-3-a" data-bs-toggle="tooltip" data-tooltip="This option can only be chosen if the HFC selection and all bulk HFC transactions were fully confirmed.">a) We confirm with reasonable assurance that the documentation of compliance with Article 19(1) of the Regulation is accurate, complete, free from material misstatement and consistent to the data reported pursuant to Article 26 of that Regulation.</label>
					</td>
					<td id="bulk-hfcs-verification-section-3-confirmation-b" class="confirmation">
						<input class="" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_b/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<label class="form-check-label ng-binding" for="verification-confirm-I-3-b" data-bs-toggle="tooltip" data-tooltip="This option cannot be chosen if reasonable assurance was denied for the HFC selection or any bulk HFC transaction.">b) We provide reasonable assurance that the documentation of compliance with Article 19(1) of the Regulation is accurate, complete, free from material misstatement and consistent to the data reported pursuant to Article 26 of that Regulation, though the following observations warrant attention:</label>
						<br/><br/>
						<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_b/checked = 'true'">
							<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_b/option_1 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-II-2-table-option-b1'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_b/option_2 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-II-2-table-option-b2'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_b/option_3 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-II-2-table-option-b3'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_b/option_4 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-II-2-table-option-b4'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
						</xsl:if>
						<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_3/confirmation_b/option_4_reason"/></xsl:call-template></span>
					</td>
					<td id="bulk-hfcs-verification-section-3-confirmation-c" class="confirmation">
						<input class="" type="checkbox" >
							<xsl:attribute name="disabled">disabled</xsl:attribute>
							<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_c/checked = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<label class="form-check-label ng-binding" for="verification-confirm-I-3-c" data-bs-toggle="tooltip" data-tooltip="This option must be chosen if reasonable assurance was denied for the HFC selection or any bulk HFC transaction.">c) Based on the verification conducted, we cannot provide reasonable assurance, that the documentation of compliance with Article 19(1) of the Regulation is accurate, complete, free from material misstatement and consistent to the data reported pursuant to Article 26 of that Regulation.</label>
						<br/><br/>
						<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_c/checked = 'true'">
							<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_c/option_1 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-II-2-table-option-c1'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_c/option_2 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-II-2-table-option-c2'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_c/option_3 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-II-2-table-option-c3'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<xsl:if test="../EquipmentHFCs/section_II_3/confirmation_c/option_4 = 'true'">
								<xsl:call-template name="getLabel">
									<xsl:with-param name="labelName" select="'section-II-2-table-option-c4'"/>
								</xsl:call-template>
								<br/>
							</xsl:if>
						</xsl:if>
						<span><xsl:call-template name="getValue"><xsl:with-param name="elem" select="../EquipmentHFCs/section_II_3/confirmation_c/option_4_reason"/></xsl:call-template></span>
					</td>
				</tr>
			</tbody>
		</table>
		
	</xsl:template>
	<xsl:template name="EquipmentHFCsSection4">
		<h2><span>
			<xsl:call-template name="getLabel">
				<xsl:with-param name="labelName" select="'section-II-4-section-title'"/>
			</xsl:call-template>
		</span></h2>
		
		<div class="hfcs-verification-section ng-scope" ng-include="" src="'section_II_4.html'"><style class="ng-scope">
			table.section-II-4-option label {
			text-align: left;
			white-space: pre-wrap;
			}
			table.section-II-4-option input.comment {
			width: 100%;
			}
		</style>			
			<h4 class="ng-scope">
				<span class="ng-scope">					
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'section-II-4-part-1-title'"/>
					</xsl:call-template>
					:
				</span>
				<br></br>
					<span class="ng-scope">						
						<xsl:call-template name="getLabel">
							<xsl:with-param name="labelName" select="'section-II-4-part-1-text'"/>
						</xsl:call-template>						
					</span>
			</h4>
			<table class="table table-hover table-bordered section-II-4-option ng-scope">
				
				
				<tbody id="equipment-verification-section-II-4-option-a">
					<tr>
						<td id="equipment-verification-section-II-4-option-a-1">
							
							<input class="form-check-input ng-pristine ng-untouched ng-valid" type="radio" > 
								<xsl:attribute name="disabled">disabled</xsl:attribute>
								<xsl:if test="../EquipmentHFCs/section_II_4/option_a/option = '1'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							
								<label class="form-check-label">
									<span class="ng-scope">
										<xsl:call-template name="getLabel">
											<xsl:with-param name="labelName" select="'yes'"/>
										</xsl:call-template></span>
								</label>
							<br></br>
							<!-- conditionEquipmentPart1Op1 -->
							<xsl:if test="../EquipmentHFCs/section_II_4/option_a/option = '1'">
								<xsl:if test="../ReportedEquipment/Transactions[id='tr_13D']/tco2e = 0 or ../EquipmentHFCs/section_II_2/tr_13D/confirmation_c/checked = 'true'">
									<span data-translate="equipment-verification.section-II-4-part-1-option-1-comment" class="ng-scope">In section II-4, part 1 of this questionnaire, choosing “Yes” indicates the auditor confirms sufficient availability of quota authorisations for all cases where Option A was used in declaration(s) of conformity (DoC).
										However, in section II-2 of this questionnaire, the auditor has selected option c) (confirmation denied) for the verification statement on data reported in section 13 D of the data report (or no HFCs were reported in section 13D of the data report &amp; confirmed by the auditor in section II-2 of this questionnaire). HFCs reported in section 13D of the data report correspond to authorisation need to be reflected by option A of the DoC.
										This combination of auditor’s selections in section II-2 and II-4 of the questionnaire does not appear plausible.
										The auditor is requested to enter a comment to explain:</span>
									<br></br>
									<xsl:if test="../EquipmentHFCs/section_II_4/option_a/reason_1 and normalize-space(../EquipmentHFCs/section_II_4/option_a/reason_1) != ''">
										<textarea class="resizable-textarea">
											<xsl:attribute name="readonly">readonly</xsl:attribute>									
												<xsl:value-of select="../EquipmentHFCs/section_II_4/option_a/reason_1"/>									
										</textarea>
									</xsl:if>
								</xsl:if>
							</xsl:if>
						</td>
					</tr>
					<tr>
						<td id="equipment-verification-section-II-4-option-a-2">
							<input class="form-check-input ng-pristine ng-untouched ng-valid" type="radio" > 
								<xsl:attribute name="disabled">disabled</xsl:attribute>
								<xsl:if test="../EquipmentHFCs/section_II_4/option_a/option = '2'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<label class="form-check-label">
								<span class="ng-scope">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'no'"/>
									</xsl:call-template></span>
							</label>
							<br></br>
							<!-- conditionEquipmentPart1Op2 -->
							<xsl:if test="../EquipmentHFCs/section_II_4/option_a/option = '2'">
								<xsl:if test="../ReportedEquipment/Transactions[id='tr_13D']/tco2e &lt;= 0">
									<span data-translate="equipment-verification.section-II-4-part-1-option-2-comment" class="ng-scope">In section II-4, part 1 of this questionnaire, choosing “No” indicates the auditor does not confirm sufficient availability of quota authorisations for all cases where Option A was used in declaration(s) of conformity (DoC).
										However, in section II-2 of this questionnaire, the auditor confirmed that no HFCs were reported in section 13D of the data report. HFCs reported in section 13D of the data report correspond to authorisation need to be reflected by option A of the DoC.
										This combination of auditor’s selections in section II-2 and II-4 of the questionnaire does not appear plausible.
										The auditor is requested to enter a comment to explain:</span>
									<br></br>
									<xsl:if test="../EquipmentHFCs/section_II_4/option_a/reason_2 and normalize-space(../EquipmentHFCs/section_II_4/option_a/reason_2) != ''">
										<textarea class="resizable-textarea">
											<xsl:attribute name="readonly">readonly</xsl:attribute>										
												<xsl:value-of select="../EquipmentHFCs/section_II_4/option_a/reason_2"/>										
										</textarea>
									</xsl:if>
								</xsl:if>
							</xsl:if>
						</td>
					</tr>
					<tr>
						
						<td id="equipment-verification-section-II-4-option-a-3">
							<input class="form-check-input ng-pristine ng-untouched ng-valid" type="radio" > 
								<xsl:attribute name="disabled">disabled</xsl:attribute>
								<xsl:if test="../EquipmentHFCs/section_II_4/option_a/option = '3'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<label class="form-check-label">
								<span class="ng-scope">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'section-II-4-part-1-option-3'"/>
									</xsl:call-template></span>
							</label>	
							<br></br>
							<!-- conditionEquipmentPart1Op3 -->
							<xsl:if test="../EquipmentHFCs/section_II_4/option_a/option = '3'">
								<xsl:if test="../ReportedEquipment/Transactions[id='tr_13D']/tco2e &gt; 0">
									<xsl:if test="../EquipmentHFCs/section_II_2/tr_13D/confirmation_a/checked = 'true' or ../EquipmentHFCs/section_II_2/tr_13D/confirmation_b/checked = 'true'">
										<span data-translate="equipment-verification.section-II-4-part-1-option-3-comment" class="ng-scope">In section II-4, part 1, of this questionnaire, the auditor states that Option A was not used in declaration(s) of conformity (DoC).
											However, in section II-2 of this questionnaire, the auditor selected options a) or b) (full confirmation or confirmation with reservations) for the verification statement on data reported in section 13D of the data report. HFCs reported in section 13D of the data report correspond to authorisation need to be reflected by option A of the DoC.
											This combination of auditor’s selections in section II-2 and II-4 of the questionnaire does not appear plausible.
											The auditor is requested to enter a comment to explain:</span>
										<br></br>
										<xsl:if test="../EquipmentHFCs/section_II_4/option_a/reason_3  and normalize-space(../EquipmentHFCs/section_II_4/option_a/reason_3) != ''">
											<textarea class="resizable-textarea">
												<xsl:attribute name="readonly">readonly</xsl:attribute>										
													<xsl:value-of select="../EquipmentHFCs/section_II_4/option_a/reason_3"/>										
											</textarea>
										</xsl:if>
									</xsl:if>
								</xsl:if>
							</xsl:if>
						</td>
					</tr>
				</tbody>
			</table>
			<h4 class="ng-scope">
				<span class="ng-scope">					
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'section-II-4-part-2-title'"/>
					</xsl:call-template>
					:
				</span>
				<br></br>
				<span class="ng-scope">						
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'section-II-4-part-2-text'"/>
					</xsl:call-template>						
				</span>
			</h4>
			<table class="table table-hover table-bordered section-II-4-option ng-scope">
				<tbody id="equipment-verification-section-II-4-option-a">
					<tr>
						<td id="equipment-verification-section-II-4-option-a-1">
							<input class="form-check-input ng-pristine ng-untouched ng-valid" type="radio" > 
								<xsl:attribute name="disabled">disabled</xsl:attribute>
								<xsl:if test="../EquipmentHFCs/section_II_4/option_b/option = '1'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<label class="form-check-label">
								<span  class="ng-scope">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'yes'"/>
									</xsl:call-template></span>
							</label>	
							<br></br>
							<!-- conditionEquipmentPart2Op1 -->
							<xsl:if test="../EquipmentHFCs/section_II_4/option_b/option = '1'">
								<xsl:if test="(../ReportedEquipment/Transactions[id='tr_12A']/tco2e = 0 and ../ReportedEquipment/Transactions[id='tr_12B']/tco2e = 0) or 
											  (../EquipmentHFCs/section_II_2/tr_12A/confirmation_c/checked = 'true' or ../EquipmentHFCs/section_II_2/tr_12B/confirmation_c/checked = 'true')">
									<span  class="ng-scope">In section II-4, part 2 of this questionnaire, the auditor confirms that a declaration is available by the undertaking that placed the hydrofluorocarbons on the market (as referred to in Article 2(2)(d) of Commission Implementing Regulation (EU) 2025/2155), for all cases where option B was chosen in the declaration(s) of conformity (DoC), covering the relevant quantities.
										However, in section II-2 of this questionnaire, the auditor has selected option c) (confirmation denied) for the verification statement on data reported in section 12B and/or 12B of the data report (or no HFCs were reported in section 12A/12B of the data report &amp; confirmed by the auditor in section II-2 of this questionnaire). HFCs reported in sections 12A and 12B of the data report correspond to quantities to be reflected by option B of the DoC.
										This combination of auditor’s selections in section II-2 and II-4 of the questionnaire does not appear plausible.
										The auditor is requested to enter a comment to explain:</span>
									<br></br>
									<xsl:if test="../EquipmentHFCs/section_II_4/option_b/reason_1  and normalize-space(../EquipmentHFCs/section_II_4/option_b/reason_1) != ''">
										<textarea class="resizable-textarea">
											<xsl:attribute name="readonly">readonly</xsl:attribute>										
												<xsl:value-of select="../EquipmentHFCs/section_II_4/option_b/reason_1"/>										
										</textarea>
									</xsl:if>
								</xsl:if>
							</xsl:if>							
						</td>
					</tr>
					<tr>
						<td id="equipment-verification-section-II-4-option-a-2">
							<input class="form-check-input ng-pristine ng-untouched ng-valid" type="radio" > 
								<xsl:attribute name="disabled">disabled</xsl:attribute>
								<xsl:if test="../EquipmentHFCs/section_II_4/option_b/option = '2'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<label class="form-check-label">
								<span class="ng-scope">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'no'"/>
									</xsl:call-template></span>
							</label>	
							<br></br>
							<!-- conditionEquipmentPart2Op2 -->
							<xsl:if test="../EquipmentHFCs/section_II_4/option_b/option = '2'">
								<xsl:if test="(../ReportedEquipment/Transactions[id='tr_12A']/tco2e = 0 and ../ReportedEquipment/Transactions[id='tr_12B']/tco2e = 0)">
									<span data-translate="equipment-verification.section-II-4-part-1-option-2-comment" class="ng-scope">In section II-4, part 2 of this questionnaire, choosing “No” indicates the auditor does not confirm the availability of supporting declarations for all cases where Option B was used in declaration(s) of conformity (DoC).
										However, in section II-2 of this questionnaire, the auditor confirmed that no HFCs were reported in sections 12A and/or 12B of the data report. HFCs reported in section 12A/12B of the data report correspond to quantities to be reflected by option B of the DoC.
										This combination of auditor’s selections in section II-2 and II-4 of the questionnaire does not appear plausible.
										The auditor is requested to enter a comment to explain:</span>
									<br></br>
									<xsl:if test="../EquipmentHFCs/section_II_4/option_b/reason_2  and normalize-space(../EquipmentHFCs/section_II_4/option_b/reason_2) != ''">
										<textarea class="resizable-textarea">
											<xsl:attribute name="readonly">readonly</xsl:attribute>									
												<xsl:value-of select="../EquipmentHFCs/section_II_4/option_b/reason_2"/>
											
										</textarea>
									</xsl:if>
								</xsl:if>
							</xsl:if>			
						</td>
					</tr>
					<tr>
						
						<td id="equipment-verification-section-II-4-option-a-3">
							<input class="form-check-input ng-pristine ng-untouched ng-valid" type="radio" > 
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
								<xsl:if test="../EquipmentHFCs/section_II_4/option_b/option = '3'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<label class="form-check-label">
								<span class="ng-scope">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'section-II-4-part-2-option-3'"/>
									</xsl:call-template></span>
							</label>	
							<br></br>
							<!-- conditionEquipmentPart2Op3 -->
							<xsl:if test="../EquipmentHFCs/section_II_4/option_b/option = '3'">
								<xsl:if test="(../ReportedEquipment/Transactions[id='tr_12A']/tco2e &gt; 0 and 
												(../EquipmentHFCs/section_II_2/tr_12A/confirmation_a/checked = 'true' or ../EquipmentHFCs/section_II_2/tr_12A/confirmation_b/checked = 'true')
											   ) or 
											(../ReportedEquipment/Transactions[id='tr_12B']/tco2e &gt; 0 and 
												(../EquipmentHFCs/section_II_2/tr_12B/confirmation_a/checked = 'true' or ../EquipmentHFCs/section_II_2/tr_12B/confirmation_b/checked = 'true')
											)">
									<span data-translate="equipment-verification.section-II-4-part-1-option-2-comment" class="ng-scope">In section II-4, part 2, of this questionnaire, the auditor states that Option B was not used in declaration(s) of conformity (DoC).
										However, in section II-2 of this questionnaire, the auditor selected options a) or b) (full confirmation or confirmation with reservations) for the verification statement on data reported in sections 12A and/or 12B of the data report. HFCs reported in section 12A and/or 12B of the data report correspond to quantities needing to be reflected by option B of the DoC.
										This combination of auditor’s selections in section II-2 and II-4 of the questionnaire does not appear plausible.
										The auditor is requested to enter a comment to explain:</span>
									<br></br>
									<xsl:if test="../EquipmentHFCs/section_II_4/option_b/reason_3 and normalize-space(../EquipmentHFCs/section_II_4/option_b/reason_3) != ''">
										<textarea class="resizable-textarea">
											<xsl:attribute name="readonly">readonly</xsl:attribute>									
												<xsl:value-of select="../EquipmentHFCs/section_II_4/option_b/reason_3"/>										
										</textarea>
									</xsl:if>
								</xsl:if>
							</xsl:if>			
						</td>
					</tr>
				</tbody>
			</table>
		
		<!-- part 3 -->
			
			<h4 class="ng-scope">
				<span class="ng-scope">
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'section-II-4-part-3-title'" />
					</xsl:call-template>
					:
				</span>
				<br></br>
				<span class="ng-scope">
					<xsl:call-template name="getLabel">
						<xsl:with-param name="labelName" select="'section-II-4-part-3-text'" />
					</xsl:call-template>
				</span>
			</h4>
			<table class="table table-hover table-bordered section-II-4-option ng-scope">
				<tbody id="equipment-verification-section-II-4-option-a">
					<tr>
						<td id="equipment-verification-section-II-4-option-a-1">
							<input class="form-check-input ng-pristine ng-untouched ng-valid" type="radio">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
								<xsl:if test="../EquipmentHFCs/section_II_4/option_c/option = '1'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<label class="form-check-label">
								<span class="ng-scope">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'yes'" />
									</xsl:call-template>
								</span>
							</label>
							<br></br>
							<!-- conditionEquipmentPart3Op1 -->
							<xsl:if test="../EquipmentHFCs/section_II_4/option_c/option = '1'">
								<xsl:if test="(../ReportedEquipment/Transactions[id='tr_12aA']/tco2e = 0 and ../ReportedEquipment/Transactions[id='tr_12aB']/tco2e = 0) or
										(../EquipmentHFCs/section_II_2/tr_12aA/confirmation_c/checked = 'true' or ../EquipmentHFCs/section_II_2/tr_12aB/confirmation_c/checked = 'true')">							
									<span class="ng-scope">In section II-4, part 3 of this questionnaire, the auditor confirms that a declaration is available by the undertaking that placed the hydrofluorocarbons on the market (as referred to in Article 2(2)(d) of Commission Implementing Regulation (EU) 2025/2155), for all cases where option C was chosen in the declaration(s) of conformity (DoC), covering the relevant quantities.
										However, in section II-2 of this questionnaire, the auditor has selected option c) (confirmation denied) for the verification statement on data reported in section 12aA and/or 12aB of the data report (or no HFCs were reported in section 12A/12B of the data report &amp; confirmed by the auditor in section II-2 of this questionnaire). HFCs reported in sections 12aA and 12aB of the data report correspond to quantities to be reflected by option C of the DoC.
										This combination of auditor’s selections in section II-2 and II-4 of the questionnaire does not appear plausible.
										The auditor is requested to enter a comment to explain:<br></br></span>
									<xsl:if test="../EquipmentHFCs/section_II_4/option_c/reason_1 and normalize-space(../EquipmentHFCs/section_II_4/option_c/reason_1) != ''">
										<textarea class="resizable-textarea">
											<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:value-of select="../EquipmentHFCs/section_II_4/option_c/reason_1" />
										</textarea>
									</xsl:if>
								</xsl:if>
							</xsl:if>
						</td>
					</tr>
					<tr>
						<td id="equipment-verification-section-II-4-option-a-2">
							<input class="form-check-input ng-pristine ng-untouched ng-valid" type="radio" > 
								<xsl:attribute name="disabled">disabled</xsl:attribute>
								<xsl:if test="../EquipmentHFCs/section_II_4/option_c/option = '2'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<label class="form-check-label">
								<span class="ng-scope">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'no'" />
									</xsl:call-template>
								</span>
							</label>
							<br></br>
							<!-- conditionEquipmentPart3Op2 -->
							<xsl:if test="../EquipmentHFCs/section_II_4/option_c/option = '2'">
								<xsl:if test="(../ReportedEquipment/Transactions[id='tr_12aA']/tco2e = 0 and ../ReportedEquipment/Transactions[id='tr_12aB']/tco2e = 0)">
									<span data-translate="equipment-verification.section-II-4-part-1-option-2-comment" class="ng-scope">In section II-4, part 3 of this questionnaire, choosing “No” indicates the auditor does not confirm the availability of supporting declarations for all cases where Option C was used in declaration(s) of conformity (DoC).
										However, in section II-2 of this questionnaire, the auditor confirmed that no HFCs were reported in sections 12aA and/or 12aB of the data report. HFCs reported in section 12aA/12aB of the data report correspond to quantities to be reflected by option C of the DoC.
										This combination of auditor’s selections in section II-2 and II-4 of the questionnaire does not appear plausible.
										The auditor is requested to enter a comment to explain:</span>
									<br></br>
									<xsl:if test="../EquipmentHFCs/section_II_4/option_c/reason_2 and normalize-space(../EquipmentHFCs/section_II_4/option_c/reason_2) != ''">
										<textarea class="resizable-textarea">
											<xsl:attribute name="readonly">readonly</xsl:attribute>										
												<xsl:value-of select="../EquipmentHFCs/section_II_4/option_c/reason_2" />																	
										</textarea>
									</xsl:if>
								</xsl:if>
							</xsl:if>
						</td>
					</tr>
					<tr>
						<td id="equipment-verification-section-II-4-option-a-3">
							<input class="form-check-input ng-pristine ng-untouched ng-valid" type="radio" > 
								<xsl:attribute name="disabled">disabled</xsl:attribute>
								<xsl:if test="../EquipmentHFCs/section_II_4/option_c/option = '3'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<label class="form-check-label">
								<span class="ng-scope">
									<xsl:call-template name="getLabel">
										<xsl:with-param name="labelName" select="'section-II-4-part-3-option-3'" />
									</xsl:call-template>
								</span>
							</label>
							<br></br>
							<!-- conditionEquipmentPart3Op3 -->
							<xsl:if test="../EquipmentHFCs/section_II_4/option_c/option = '3'">
								<xsl:if test="(../ReportedEquipment/Transactions[id='tr_12aA']/tco2e &gt; 0 or ../ReportedEquipment/Transactions[id='tr_12aB']/tco2e &gt; 0) and
										(
											../EquipmentHFCs/section_II_2/tr_12aA/confirmation_a/checked = 'true' or
											../EquipmentHFCs/section_II_2/tr_12aB/confirmation_a/checked = 'true' or
											../EquipmentHFCs/section_II_2/tr_12aA/confirmation_b/checked = 'true' or
											../EquipmentHFCs/section_II_2/tr_12aB/confirmation_b/checked = 'true'
										)">
									<span data-translate="equipment-verification.section-II-4-part-1-option-2-comment" class="ng-scope">In section II-4, part 3, of this questionnaire, the auditor states that Option C was not used in declaration(s) of conformity (DoC).
										However, in section II-2 of this questionnaire, the auditor selected options a) or b) (full confirmation or confirmation with reservations) for the verification statement on data reported in sections 12aA and/or 12aB of the data report. HFCs reported in section 12aA and/or 12aB of the data report correspond to quantities needing to be reflected by option C of the DoC.
										This combination of auditor’s selections in section II-2 and II-4 of the questionnaire does not appear plausible.
										The auditor is requested to enter a comment to explain:</span>
									<br></br>
									<xsl:if test="../EquipmentHFCs/section_II_4/option_c/reason_3 and normalize-space(../EquipmentHFCs/section_II_4/option_c/reason_3) != ''">
										<textarea class="resizable-textarea">
											<xsl:attribute name="readonly">readonly</xsl:attribute>										
												<xsl:value-of select="../EquipmentHFCs/section_II_4/option_c/reason_3" />										
										</textarea>
									</xsl:if>
								</xsl:if>
							</xsl:if>
						</td>
					</tr>
				</tbody>
			</table>
		
		</div>
	</xsl:template>
	
	<xsl:template name="EquipmentHFCsSection5">
		<h2><span>
			<xsl:call-template name="getLabel">
				<xsl:with-param name="labelName" select="'section-II-5-section-title'"/>
			</xsl:call-template>
		</span></h2>
		<div class="hfcs-verification-section ng-scope" ng-include=""><div class="ng-scope">
			<p class="ng-scope">				
				
				<xsl:call-template name="getLabel">
					<xsl:with-param name="labelName" select="'section-II-5-upload-document-text'"/>
				</xsl:call-template></p>
			<div class="ng-scope">				
				<a id="bulk-hfcs-verification-verification-report" target="_blank" class="ng-binding">
					<xsl:attribute name="href">						
						<xsl:value-of select="translate(../BulkHFCs/section_II_5/VerificationReport/Url,' ','_')"/>
					</xsl:attribute>
					<xsl:call-template name="getValue">
						<xsl:with-param name="elem" select="../EquipmentHFCs/section_II_5/VerificationReport/Url"/>
					</xsl:call-template>
				</a>				
			</div>	
		</div>
		</div>
	</xsl:template>
	
	<!-- *******************************************EQUIPMENT*********************************************** -->
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
