from openpyxl import load_workbook
import datetime
import xml.etree.cElementTree as ET
from django.utils.encoding import smart_str#, smart_unicode



wb = load_workbook(filename = 'transfer FDB to BDR 2025 reporting round_20260204.xlsx')
#sheet_main = wb.get_sheet_by_name('9A_imp (2019)')  #sheet main
sheet_main = wb["9A_imp (2025)"] #sheet main 
col_amount_sheet1 = 2   #Auth_amount, 9A_imp
col_idComp_sheet1 = 3   #Issuer_code, 9A_imp
col_regCode_sheet1 = 4   #Recipient_Code, 9A_imp
col_CompName_sheet1 = 5   #Recipient_name, 9A_imp
col_isEU_sheet1 = 6   #Recipient_IsEU, 9A_imp
col_VAT_sheet1 = 7   #Recipient_VAT, 9A_imp
col_CountryID_sheet1 = 8   #Recipient_CountryID, 9A_imp
col_CountryName_sheet1 = 9   #Recipient_CountryName, 9A_imp
col_RepName_sheet1 = 10   #Recipient_ORName, 9A_imp
col_RepVAT_sheet1 = 11   #Recipient_ORVAT, 9A_imp
#sheet_stocks = wb.get_sheet_by_name('4A,B,C, 8E (2020)')    #sheet stocks
sheet_stocks = wb["4A,B,C, 8E (2025)"]   #sheet stocks
col_idComp_sheetStocks = 1  #Portal_code, Stocks
col_gasId_sheetStocks = 2   #gasId, Stocks
col_tranCode_sheetStocks = 3   #transactionCode, Stocks
col_amount_sheetStocks = 4   #amount, Stocks
col_gasName_sheetStocks = 5   #gasName, Stocks
#sheet_quota = wb.get_sheet_by_name('9G (2020)')    #sheet quota
sheet_quota = wb["9G (2025)"]    #sheet quota
col_idComp_sheetQuota = 1  #Portal_code, quota
col_alloQuota_sheetQuota = 2   #Quota_balance, quota
col_alloQuotaDate_sheetQuota = 3   #Registry_extract, quota

#sheet_large = wb.get_sheet_by_name('large companies (2020)')    #sheet large
sheet_large = wb["large companies (2025)"]    #sheet large
col_idComp_sheetLarge = 0  #Portal_code, Large

#sheet_ner = wb.get_sheet_by_name('NER list (2020) ')    #sheet ner
sheet_ner = wb["NER list (2025) "]   #sheet ner
col_idComp_sheetNer = 1  #Portal_code, Large

root_node = ET.Element("dataRoot")

i=0
idComp_old = 0
count_idCompany = 0


for rowSheetQuota in sheet_quota.rows:
    if i!=0 and str(rowSheetQuota[col_idComp_sheetQuota].value)!="None": #saltarse la fila de la cabecera
        count_idCompany = count_idCompany + 1        
        print (rowSheetQuota[col_idComp_sheetQuota].value)
        regis_node = ET.SubElement(root_node, "registryData")
        regis_node.attrib["companyId"] = str(rowSheetQuota[col_idComp_sheetQuota].value)
        #----------STOCKS----------
        stocks_node = ET.SubElement(regis_node, "stocks")
        for rowSheetStocks in sheet_stocks.rows:
            if rowSheetQuota[col_idComp_sheetQuota].value == rowSheetStocks[col_idComp_sheetStocks].value:
                stock_node = ET.SubElement(stocks_node, "stock")
                tranCode_node = ET.SubElement(stock_node, "transactionCode").text = str(rowSheetStocks[col_tranCode_sheetStocks].value)
                gasId_node = ET.SubElement(stock_node, "gasId").text = str(rowSheetStocks[col_gasId_sheetStocks].value)
                gasName_node = ET.SubElement(stock_node, "gasName").text = smart_str(rowSheetStocks[col_gasName_sheetStocks].value)
                amount_node = ET.SubElement(stock_node, "amount").text = str(rowSheetStocks[col_amount_sheetStocks].value)
        #----------///////----------
        #----------QUOTA----------
        quota_node = ET.SubElement(regis_node, "quota")
        alloQuota_node = ET.SubElement(quota_node, "allocatedQuota").text = str(rowSheetQuota[col_alloQuota_sheetQuota].value)
        avaiQuota_node = ET.SubElement(quota_node, "availableQuota").text = str(rowSheetQuota[col_alloQuota_sheetQuota].value)
        #alloQuotaDate_node = ET.SubElement(quota_node, "allocatedQuotaDate").text = (rowSheetQuota[col_alloQuotaDate_sheetQuota].value).strftime("%d-%m-%Y")      
        alloQuotaDate_node = ET.SubElement(quota_node, "allocatedQuotaDate").text = "03-02-2023"
        #avaiQuotaDate_node = ET.SubElement(quota_node, "availableQuotaDate").text = (rowSheetQuota[col_alloQuotaDate_sheetQuota].value).strftime("%d-%m-%Y")
        avaiQuotaDate_node = ET.SubElement(quota_node, "availableQuotaDate").text = "03-02-2023"
        #----------///////----------
        #----------QUOTA9A-IMP----------
        
        for rowSheetMain in sheet_main.rows:
            if rowSheetQuota[col_idComp_sheetQuota].value == rowSheetMain[col_idComp_sheet1].value:
                quota9Aimp_node = ET.SubElement(quota_node, "quota9A_imp")
                tradePartner_node = ET.SubElement(quota9Aimp_node, "tradePartner")
                ET.SubElement(tradePartner_node, "CompanyName").text = smart_str(rowSheetMain[col_CompName_sheet1].value)
                if (rowSheetMain[col_isEU_sheet1].value):
                    ET.SubElement(tradePartner_node, "EUVAT").text = str(rowSheetMain[col_VAT_sheet1].value)
                else:
                    ET.SubElement(tradePartner_node, "NonEUCountryCodeOfEstablishment").text = str(rowSheetMain[col_CountryID_sheet1].value)
                    ET.SubElement(tradePartner_node, "NonEUCountryOfEstablishment").text = str(rowSheetMain[col_CountryID_sheet1].value)
                    ET.SubElement(tradePartner_node, "NonEUDgClimaRegCode").text = str(rowSheetMain[col_regCode_sheet1].value)
                    ET.SubElement(tradePartner_node, "NonEURepresentativeName").text = str(rowSheetMain[col_RepName_sheet1].value)
                    ET.SubElement(tradePartner_node, "NonEURepresentativeVAT").text = str(rowSheetMain[col_RepVAT_sheet1].value)
                ET.SubElement(quota9Aimp_node, "amount").text = str(rowSheetMain[col_amount_sheet1].value)
        #----------///////----------
        #----------LARGE COMPANY----------
        isLarge = False
        for rowSheetLarge in sheet_large.rows:
            if rowSheetQuota[col_idComp_sheetQuota].value == rowSheetLarge[col_idComp_sheetLarge].value:
                isLarge = True
        if isLarge:
            ET.SubElement(regis_node, "large").text = "true"
        else:
            ET.SubElement(regis_node, "large").text = "false"
        #----------///////----------
        #----------NER----------
        isNer = False
        for rowSheetNer in sheet_ner.rows:
            if rowSheetQuota[col_idComp_sheetQuota].value == rowSheetNer[col_idComp_sheetNer].value:
                isNer = True
        if isNer:
            ET.SubElement(regis_node, "ner").text = "true"
        else:
            ET.SubElement(regis_node, "ner").text = "false"
        

    i=i+1	 
    print('--- END OF ROW ---')

print(count_idCompany)
if count_idCompany!=None:
    tree = ET.ElementTree(root_node)
    tree.write("filename3.xml",encoding="utf-8")
