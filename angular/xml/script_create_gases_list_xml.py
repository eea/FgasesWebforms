from openpyxl import load_workbook
import datetime
import xml.etree.cElementTree as ET

wb = load_workbook(filename = 'F-Gas List 2025 with composition_v3.xlsx')
sheet_main = wb["qry_blendcomposition_details_20"] #sheet main 
col_gasId = 0   #Gas ID
col_shortlisted = 1   #Shortlisted
col_gasGroup = 2   #Gas_Group
col_GG_name = 3   #GG_name
col_gas_name_display = 4   #gas_name_display
col_gas_name_IA = 5   #gas_name_IA
col_Component_ID = 6   #Component_ID
col_comp_group = 7   #comp_group
col_Comp_group_name = 8   #Comp_group_name
col_Expr1009 = 13   #Expr1009
col_component_name_display = 9   #component_name_display
col_component_name_IA = 10   #component_name_IA
col_reported_other_explanation = 11   #reported_other_explanation
col_Percentage = 12   #Percentage
col_GWP_HFC = 14   #component_GWP_HFC
col_GWP_full = 15   #component_GWP_full

root_node = ET.Element("FGases")

i = 0
idComp_old = 0
count_idCompany = 0

arrayFinalExcel = []
lastId = 0
sameGasArray = []

for rowSheetMain in sheet_main.rows:
    if (i > 0):
        newId = rowSheetMain[col_gasId].value
        if (newId == lastId):
            sameGasArray.append(rowSheetMain)
            arrayFinalExcel[-1].append(rowSheetMain)
            sameGasArray = []
        else:
            sameGasArray.append(rowSheetMain)
            arrayFinalExcel.append(sameGasArray)
            sameGasArray = []
        lastId = newId
    i = i + 1
j = 0
#Order the gases with the fgases-gases.xml
treeXML = ET.parse('./fgases-gases.xml')
rootXML = treeXML.getroot()
arrayFinalExcelOrdered = []
GWP_AR4_HFCXMLArray = []
for gasXML in rootXML.iter('Gas'):
    #order components
    componentXMLArray = []
    for componentXML in gasXML.iter('Component'):
        componentXMLId = componentXML.find('Component_Id').text
        componentXMLGWP_AR4_HFC = componentXML.find('GWP_AR4_HFC').text
        componentXMLGWP_AR4_AnnexIV = componentXML.find('GWP_AR4_AnnexIV').text
        componentXMLPercentage = componentXML.find('Percentage').text
        componentXMLArray.append({"id":componentXMLId, "GWP_AR4_HFC":componentXMLGWP_AR4_HFC, "GWP_AR4_AnnexIV":componentXMLGWP_AR4_AnnexIV, "Percentage":componentXMLPercentage})
    #copy some values from xml
    gasXMLId = gasXML.find('GasId').text
    gasXMLIsCustom = gasXML.find('IsCustom').text
    gasXMLGWP_AR4_HFC = gasXML.find('GWP_AR4_HFC').text
    gasXMLGWP_AR4_AnnexIV = gasXML.find('GWP_AR4_AnnexIV').text
    if (gasXML.find('BlendComposition') is None):
        gasXMLBlendComposition = ""
    else:
        gasXMLBlendComposition = gasXML.find('BlendComposition').text
    
    GWP_AR4_HFCXMLArray.append({"id": gasXMLId, "IsCustom": gasXMLIsCustom, "GWP_AR4_HFC": gasXMLGWP_AR4_HFC, "GWP_AR4_AnnexIV": gasXMLGWP_AR4_AnnexIV, "blendComposition": gasXMLBlendComposition, "components": componentXMLArray})
    
    
    #order array of gases
    for gasElemRoot in  arrayFinalExcel[:]:
        gasElement = gasElemRoot[0]
        if (str(gasElement[col_gasId].value) == gasXMLId):
            arrayFinalExcelOrdered.append(gasElemRoot)
            arrayFinalExcel.remove(gasElemRoot)  #array of gases that are not in the xml

#print new layers of Excel file
print("New layers:")
for gasElemRoot in  arrayFinalExcel[:]:
    gasElement = gasElemRoot[0]
    gas_node = ET.SubElement(root_node, "Gas")
    gasId_node = ET.SubElement(gas_node, "GasId").text = str(gasElement[col_gasId].value)
    gasCode_node = ET.SubElement(gas_node, "Code").text = str(gasElement[col_gas_name_IA].value)
    gasName_node = ET.SubElement(gas_node, "Name").text = str(gasElement[col_gas_name_display].value)
    gasGroupId_node = ET.SubElement(gas_node, "GasGroupId").text = str(gasElement[col_gasGroup].value)
    gasGroupName_node = ET.SubElement(gas_node, "GasGroupName").text = str(gasElement[col_GG_name].value)
    #calculate GWP_AR4_HFC and GWP_AR4_AnnexIV values
    GWP_AR4_HFC_value = 0
    GWP_AR4_AnnexIV_value = 0
    for component in gasElemRoot:
        Expr1009_value = component[col_GWP_HFC].value
        GWP_AR4_100_value = component[col_GWP_full].value
        if (Expr1009_value is None):
            Expr1009_value = 0
        if (GWP_AR4_100_value is None):
            GWP_AR4_100_value = 0
        percentage_value = float(str(component[col_Percentage].value).replace("%",""))*100
        componentGropuId_node = str(component[col_comp_group].value)
        if (componentGropuId_node == "1"): #only if component is part of HFC group
            GWP_AR4_HFC_value = GWP_AR4_HFC_value + (float(Expr1009_value) * percentage_value / 100)
        GWP_AR4_AnnexIV_value = GWP_AR4_AnnexIV_value + (float(GWP_AR4_100_value) * percentage_value / 100)
    GWP_AR4_HFC_value = "{:g}".format(GWP_AR4_HFC_value)
    gasGWP_AR4_HFC_node = ET.SubElement(gas_node, "GWP_AR4_HFC").text = str(GWP_AR4_HFC_value)
    GWP_AR4_AnnexIV_value = "{:g}".format(GWP_AR4_AnnexIV_value)
    gasGWP_AR4_AnnexIV_node = ET.SubElement(gas_node, "GWP_AR4_AnnexIV").text = str(GWP_AR4_AnnexIV_value)
    if (gasElement[col_shortlisted].value == True):
        isShortlisted = "true"
        isCustom = "false"
    else:
        isShortlisted = "false"
        isCustom = "true"
    gasisShortlisted_node = ET.SubElement(gas_node, "IsShortlisted").text = isShortlisted
    gasisCustom_node = ET.SubElement(gas_node, "IsCustom").text = isCustom
    if (len(gasElemRoot) > 1):
        isBlend = "true"
    else:
        isBlend = "false"
    gasisBlend_node = ET.SubElement(gas_node, "IsBlend").text = isBlend
    bledComponents_node = ET.SubElement(gas_node, "BlendComponents")
    blendComponents_value = ""
    #Components
    for component in gasElemRoot:
        components_node = ET.SubElement(bledComponents_node, "Component")
        componentId_node = ET.SubElement(components_node, "Component_Id").text = str(component[col_Component_ID].value)
        componentCode_node = ET.SubElement(components_node, "Code").text = str(component[col_component_name_IA].value)
        if (str(component[col_component_name_IA].value) == "Other"):
            componentName_node = ET.SubElement(components_node, "Name").text = str(component[col_component_name_IA].value) + "(" + str(component[col_reported_other_explanation].value) + ")"
        else:
            componentName_node = ET.SubElement(components_node, "Name").text = str(component[col_component_name_display].value)
        componentGropuId_node = ET.SubElement(components_node, "GasGroupId").text = str(component[col_comp_group].value)
        componentGropuName_node = ET.SubElement(components_node, "GasGroupName").text = str(component[col_Comp_group_name].value)
        Expr1009_value = component[col_GWP_HFC].value
        GWP_AR4_100_value = component[col_GWP_full].value
        if (Expr1009_value is None):
            Expr1009_value = 0
        if (GWP_AR4_100_value is None):
            GWP_AR4_100_value = 0
        componentGWP_AR4_HFC_node = ET.SubElement(components_node, "GWP_AR4_HFC").text = str(Expr1009_value)
        componentGWP_AR4_AnnexIV_node = ET.SubElement(components_node, "GWP_AR4_AnnexIV").text = str(GWP_AR4_100_value)
        percentage_value = float(str(component[col_Percentage].value).replace("%",""))*100
        percentage_value = "{:g}".format(percentage_value)
        componentPercentage_node = ET.SubElement(components_node, "Percentage").text = str(percentage_value)
        if (component == gasElemRoot[-1]): #last element
            lastStringPartBlend = "%"
        else:
            lastStringPartBlend = "%; "
        componentCodeValue = str(component[col_component_name_IA].value)
        if (componentCodeValue == "Other"):
            componentCodeValue = str(component[col_reported_other_explanation].value)
        blendComponents_value = blendComponents_value + componentCodeValue + ":" + str(percentage_value) + lastStringPartBlend
    
    if (len(gasElemRoot) > 1):
        blendComponentsValue_node = ET.SubElement(gas_node, "BlendComposition").text = blendComponents_value

#Repeated Gases
for gasElementRow in  arrayFinalExcelOrdered:
    gasElement = gasElementRow[0]
    gas_node = ET.SubElement(root_node, "Gas")
    gasId_node = ET.SubElement(gas_node, "GasId").text = str(gasElement[col_gasId].value)
    gasCode_node = ET.SubElement(gas_node, "Code").text = str(gasElement[col_gas_name_IA].value)
    gasName_node = ET.SubElement(gas_node, "Name").text = str(gasElement[col_gas_name_display].value)
    gasGroupId_node = ET.SubElement(gas_node, "GasGroupId").text = str(gasElement[col_gasGroup].value)
    gasGroupName_node = ET.SubElement(gas_node, "GasGroupName").text = str(gasElement[col_GG_name].value)
    #calculate GWP_AR4_HFC and GWP_AR4_AnnexIV values
    GWP_AR4_HFC_value = 0
    GWP_AR4_AnnexIV_value = 0
    for component in gasElementRow:
        Expr1009_value = component[col_GWP_HFC].value
        GWP_AR4_100_value = component[col_GWP_full].value
        if (Expr1009_value is None):
            Expr1009_value = 0
        if (GWP_AR4_100_value is None):
            GWP_AR4_100_value = 0
        percentage_value = float(str(component[col_Percentage].value).replace("%",""))*100
        GWP_AR4_HFC_value = GWP_AR4_HFC_value + (float(Expr1009_value) * percentage_value / 100)
        GWP_AR4_AnnexIV_value = GWP_AR4_AnnexIV_value + (float(GWP_AR4_100_value) * percentage_value / 100)
        
    GWP_AR4_HFC_value = "{:g}".format(GWP_AR4_HFC_value)
    if ("." in GWP_AR4_HFC_value):
        GWP_AR4_HFC_value = round(float(GWP_AR4_HFC_value),3)
    GWP_AR4_AnnexIV_value = "{:g}".format(GWP_AR4_AnnexIV_value)
    if ("." in GWP_AR4_AnnexIV_value):
        GWP_AR4_AnnexIV_value = round(float(GWP_AR4_AnnexIV_value),3)

    for r in GWP_AR4_HFCXMLArray: #get GWP_AR4_HFC value from fgases-gases.xml
        if (str(r["id"]) == str(gasElement[col_gasId].value)):
            IsCustom_value = r["IsCustom"]
            #GWP_AR4_HFC_value = r["GWP_AR4_HFC"]
            #GWP_AR4_AnnexIV_value = r["GWP_AR4_AnnexIV"]
            componentsArray_value = r["components"]
            blendComponents_value = r["blendComposition"]
    gasGWP_AR4_HFC_node = ET.SubElement(gas_node, "GWP_AR4_HFC").text = str(GWP_AR4_HFC_value)
    gasGWP_AR4_AnnexIV_node = ET.SubElement(gas_node, "GWP_AR4_AnnexIV").text = str(GWP_AR4_AnnexIV_value)

    gasisShortlisted_node = ET.SubElement(gas_node, "IsShortlisted").text = str(gasElement[col_shortlisted].value).lower()
    if (len(gasElementRow) > 1):
        isCustom = "true"
        isBlend = "true"
    else:
        isCustom = "false"
        isBlend = "false"
    gasisCustom_node = ET.SubElement(gas_node, "IsCustom").text = IsCustom_value
    gasisBlend_node = ET.SubElement(gas_node, "IsBlend").text = isBlend

    if (str(gasElement[col_gasId].value) == "149"):
        josu = ""

    bledComponents_node = ET.SubElement(gas_node, "BlendComponents")
    blendComponents_value = ""
    #Components
    for component in gasElementRow:
        components_node = ET.SubElement(bledComponents_node, "Component")
        componentId_node = ET.SubElement(components_node, "Component_Id").text = str(component[col_Component_ID].value)
        componentCode_node = ET.SubElement(components_node, "Code").text = str(component[col_component_name_IA].value)
        if (str(component[col_component_name_IA].value) == "Other"):
            componentName_node = ET.SubElement(components_node, "Name").text = str(component[col_component_name_IA].value) + "(" + str(component[col_reported_other_explanation].value) + ")"
        else:
            componentName_node = ET.SubElement(components_node, "Name").text = str(component[col_component_name_display].value)
        componentGropuId_node = ET.SubElement(components_node, "GasGroupId").text = str(component[col_comp_group].value)
        componentGropuName_node = ET.SubElement(components_node, "GasGroupName").text = str(component[col_Comp_group_name].value)
        percentage_value = float(str(component[col_Percentage].value).replace("%",""))*100
        percentage_value = "{:g}".format(percentage_value)
        GWP_AR4_HFC_value = str(component[col_GWP_HFC].value)
        GWP_AR4_AnnexIV_value = str(component[col_GWP_full].value)
        if (GWP_AR4_HFC_value is None):
            GWP_AR4_HFC_value = 0
        if (GWP_AR4_AnnexIV_value is None):
            GWP_AR4_AnnexIV_value = 0
        componentGWP_AR4_HFC_node = ET.SubElement(components_node, "GWP_AR4_HFC").text = GWP_AR4_HFC_value
        componentGWP_AR4_AnnexIV_node = ET.SubElement(components_node, "GWP_AR4_AnnexIV").text = GWP_AR4_AnnexIV_value
        componentPercentage_node = ET.SubElement(components_node, "Percentage").text = str(percentage_value)

        if (component == gasElemRoot[-1]): #last element
            lastStringPartBlend = "%"
        else:
            lastStringPartBlend = "%; "
        componentCodeValue = str(component[col_component_name_IA].value)
        if (componentCodeValue == "Other"):
            componentCodeValue = str(component[col_reported_other_explanation].value)
        blendComponents_value = blendComponents_value + componentCodeValue + ":" + str(percentage_value) + lastStringPartBlend
    
    if (len(gasElementRow) > 1):
        blendComponentsValue_node = ET.SubElement(gas_node, "BlendComposition").text = blendComponents_value
    
    j = j + 1




tree = ET.ElementTree(root_node)
tree.write("output_gasList.xml",encoding="utf-8")


print("Finished")
