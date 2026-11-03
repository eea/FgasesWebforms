<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  >

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*" />

  <xsl:template match="node()|@*" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="GeneralReportData/@status">
    <xsl:attribute name="status">copied</xsl:attribute>
  </xsl:template>

  <xsl:template match="TransactionYear">
    <xsl:copy>2026</xsl:copy>
  </xsl:template>

  <xsl:template match="@*[name() = 'xsi:noNamespaceSchemaLocation']">
    <xsl:attribute name="{name()}">http://dd.eionet.europa.eu/schemas/fgases-2026/FGasesReporting.xsd</xsl:attribute>
  </xsl:template>

  <xsl:template match="F4_S9_IssuedAuthQuata/tr_09G">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
    <tr_09H1>
      <Code>09H1</Code>
      <Amount/>
    </tr_09H1>
    <tr_09H2>
      <Code>09H2</Code>
      <Amount/>
    </tr_09H2>
  </xsl:template>

  <xsl:template match="F9_S13/Totals/tr_13D">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
    <tr_13E1>
      <Code>13E1</Code>
      <Amount/>
      <Unit>CO2e</Unit>
    </tr_13E1>
    <tr_13E2>
      <Code>13E2</Code>
      <Amount/>
      <Unit>CO2e</Unit>
    </tr_13E2>
  </xsl:template>
  
</xsl:stylesheet>

