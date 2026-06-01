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

  <xsl:template match="TransactionYear">
    <xsl:copy>2021</xsl:copy>
  </xsl:template>

  <xsl:template match="@*[name() = 'xsi:noNamespaceSchemaLocation']">
    <xsl:attribute name="{name()}">http://dd.eionet.europa.eu/schemas/fgases-2021/FGasesReporting.xsd</xsl:attribute>
  </xsl:template>

  <xsl:template match="FGasesReporting/F1_S1_4_ProdImpExp/tr_03A_Countries">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
    <xsl:if test="not(../tr_01A_fs_Countries)">
      <tr_01A_fs_Countries>
          <Country />
      </tr_01A_fs_Countries>
    </xsl:if>
  </xsl:template>

  <xsl:template match="FGasesReporting/F1_S1_4_ProdImpExp/Gas/tr_01A">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
    <xsl:if test="not(../tr_01Aa)">
      <tr_01Aa>
        <Code>01Aa</Code>
        <Amount/>
      </tr_01Aa>
      <tr_01A_a>
        <Code>01A_a</Code>
        <Amount/>
      </tr_01A_a>
      <tr_01A_a_own>
        <Code>01A_a_own</Code>
        <Amount/>
      </tr_01A_a_own>
      <tr_01A_a_other>
        <Code>01A_a_other</Code>
        <SumOfPartnerAmounts/>
        <Unit/>
        <Comment/>
        <TradePartner>
          <TradePartnerID/>
          <amount/>
          <Comment/>
        </TradePartner>
      </tr_01A_a_other>
      <tr_01Ab>
        <Code>01Ab</Code>
        <Amount/>
      </tr_01Ab>
    </xsl:if>
  </xsl:template>

  <xsl:template match="FGasesReporting/F1_S1_4_ProdImpExp/Gas/tr_01A_fs" />
  <xsl:template match="FGasesReporting/F1_S1_4_ProdImpExp/Gas/tr_01A_ex" />
<xsl:template match="FGasesReporting/F2_S5_exempted_HFCs/Gas/tr_13aA" />
  <xsl:template match="FGasesReporting/F2_S5_exempted_HFCs/Gas/tr_13aB" />
  <xsl:template match="FGasesReporting/F2_S5_exempted_HFCs/Gas/tr_13aC" />

  <xsl:template match="FGasesReporting/F1_S1_4_ProdImpExp/Gas/tr_01E">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
    <xsl:if test="not(./tr_01A_fs)">
      <tr_01A_fs>
        <Code>01A_fs</Code>
        <CountrySpecific>
          <Country/>
        </CountrySpecific>
      </tr_01A_fs>
      <tr_01A_fs1>
        <Code>01A_fs1</Code>
        <CountrySpecific>
          <Country/>
        </CountrySpecific>
      </tr_01A_fs1>
      <tr_01A_fs2>
        <Code>01A_fs2</Code>
        <CountrySpecific>
          <Country/>
        </CountrySpecific>
      </tr_01A_fs2>
    </xsl:if>
    <xsl:copy-of select="./preceding-sibling::tr_01A_ex[1]" />
  </xsl:template>

  <xsl:template match="FGasesReporting/F4_S9_IssuedAuthQuata/tr_09A">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
    <xsl:if test="not(../tr_09A_imp_date)">
      <tr_09A_imp_date/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tr_09A_Registry">
  </xsl:template>
</xsl:stylesheet>

