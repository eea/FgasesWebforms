<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  >

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*" />

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="TransactionYear">
    <xsl:copy>2017</xsl:copy>
  </xsl:template>

  <xsl:template match="@*[name() = 'xsi:noNamespaceSchemaLocation']">
    <xsl:attribute name="{name()}">http://dd.eionet.europa.eu/schemas/fgases-2017/FGasesReporting.xsd</xsl:attribute>
  </xsl:template>

  <xsl:template match="FGasesReporting/F1_S1_4_ProdImpExp/Gas/tr_01A">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
    <xsl:if test="not(../tr_01A_fs)">
      <tr_01A_fs>
        <Code>01A_fs</Code>
        <Amount />
      </tr_01A_fs>
    </xsl:if>
    <xsl:if test="not(../tr_01A_ex)">
      <tr_01A_ex>
        <Code>01A_ex</Code>
        <Amount />
      </tr_01A_ex>
    </xsl:if>
  </xsl:template>

  <xsl:template match="FGasesReporting/F4_S9_IssuedAuthQuata/SupportingDocuments">
    <!-- remove -->
  </xsl:template>

  <xsl:template match="FGasesReporting/F7_s11EquImportTable/Category/tr_11A03">
    <xsl:if test="not(../tr_11A01)">
      <tr_11A01 />
    </xsl:if>
    <xsl:if test="not(../tr_11A02)">
      <tr_11A02 />
    </xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="FGasesReporting/F7_s11EquImportTable/Category/tr_11H04">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
    <xsl:if test="not(../tr_11I)">
      <tr_11I />
    </xsl:if>
    <xsl:if test="not(../tr_11J)">
      <tr_11J />
    </xsl:if>
    <xsl:if test="not(../tr_11K)">
      <tr_11K />
    </xsl:if>
    <xsl:if test="not(../tr_11L)">
      <tr_11L />
    </xsl:if>
    <xsl:if test="not(../tr_11M)">
      <tr_11M />
    </xsl:if>
    <xsl:if test="not(../tr_11N)">
      <tr_11N />
    </xsl:if>
    <xsl:if test="not(../tr_11O)">
      <tr_11O />
    </xsl:if>
  </xsl:template>

  <xsl:template match="FGasesReporting">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
      <xsl:if test="not(./F8_S12)">
        <F8_S12>
          <Gas>
            <GasCode></GasCode>
            <tr_12A>
              <Code>12A</Code>
              <SumOfPartnersAmount></SumOfPartnersAmount>
              <Unit></Unit>
              <Transaction>
                <TransactionID></TransactionID>
                <Amount></Amount>
                <Exporter>
                  <TradePartnerID></TradePartnerID>
                  <Year></Year>
                </Exporter>
                <POM>
                  <TradePartnerID></TradePartnerID>
                  <Year></Year>
                </POM>
                <Comment></Comment>
              </Transaction>
            </tr_12A>
            <Totals>
              <tr_12B></tr_12B>
              <tr_12C></tr_12C>
            </Totals>
          </Gas>
          <tr_12A_TradePartners>
            <Partner></Partner>
          </tr_12A_TradePartners>
        </F8_S12>
      </xsl:if>
      <xsl:if test="not(./F9_S13)">
        <F9_S13>
          <AuthBalance>
            <Code></Code>
            <Amount></Amount>
            <Unit>CO2e</Unit>
          </AuthBalance>
          <Totals>
            <tr_13B>
              <Code>tr_13B</Code>
              <Amount></Amount>
              <Unit>CO2e</Unit>
            </tr_13B>
            <tr_13C>
              <Code>tr_13C</Code>
              <Amount></Amount>
              <Unit>CO2e</Unit>
            </tr_13C>
            <tr_13D>
              <Code>tr_13D</Code>
              <Amount></Amount>
              <Unit>CO2e</Unit>
            </tr_13D>
          </Totals>
          <Verified></Verified>
        </F9_S13>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

