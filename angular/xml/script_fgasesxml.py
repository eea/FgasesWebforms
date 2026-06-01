from openpyxl import load_workbook
import datetime
import xml.etree.cElementTree as ET
from django.utils.encoding import smart_str#, smart_unicode


wb = load_workbook(filename = 'F-Gas List 2022 with composition.xlsx')

sheet_main = wb["qry_blendcomposition_details"] #sheet main 
col_Gas_ID =0
col_shortlisted = 1   #shortlisted
col_Gas_Group = 2   #Gas_Group
col_GG_name = 3   #GG_name
col_gas_name_display = 4   #gas_name_display
col_gas_name_IA = 5   #gas_name_IA
col_Component_ID = 6   #Component_ID
col_comp_group = 7   #comp_group
col_Comp_group_name = 8   #Comp_group_name
col_GWP_AR4_100=9 #GWP_AR4_100
col_component_name_display = 10   #component_name_display
col_component_name_IA = 11   #component_name_IA
col_reported_other_explanation = 12   #reported_other_explanation
col_Percentage = 13   #Percentage
col_component_GWP_HFC = 14   
col_component_GWP_full = 15   

#col_Expr1009 = 5   #Expr1009



#sheet_gwp 
sheet_gwp = wb["qry_gas_GWPs"]   #sheet qry_gas_GWPs
col_ID_Gas_sheet_gwp = 0  #ID_Gas_
col_sortkey_sheet_gwp = 1   #sortkey
col_gas_name_display_sheet_gwp = 2   #
col_gas_name_IA_sheet_gwp = 3   #
col_ID_Group_sheet_gwp = 4   #
col_MP_HFC_sheet_gwp = 5   #
col_HFC_name_MP_sheet_gwp = 6   #
col_group_name_sheet_gwp = 7   #
col_IsCustom_sheet_gwp = 8   #
col_IsBlend_sheet_gwp = 9   #
col_IsShortlisted_sheet_gwp = 10   #
col_GWP_HFC_part_sheet_gwp = 11   #
col_GWP_HFC_full_sheet_gwp = 12   #
col_GWP_full_full_sheet_gwp = 13  #



root_node = ET.Element("FGases")

i=0
idGas = 0
count_idGas = 0
blendcomps_node=ET.Element("")
gasIDforGWPSheet=""
componentsIDs = []


for rowMain in sheet_main.rows:
    if i!=0 and str(rowMain[col_Gas_ID].value)!="None" and str(rowMain[col_Gas_ID].value) != idGas : #saltarse la fila de la cabecera
        #if str(rowMain[col_Gas_ID].value != idGas):
        
        count_idGas = count_idGas + 1        
        idGas = str(rowMain[col_Gas_ID].value)
        #print(idGas)
        gas_node = ET.SubElement(root_node, "Gas")
        gasID_node = ET.SubElement(gas_node, "GasId").text = str(rowMain[col_Gas_ID].value)
        code_node = ET.SubElement(gas_node, "Code").text = str(rowMain[col_gas_name_IA].value)
        name_node = ET.SubElement(gas_node, "Name").text = str(rowMain[col_gas_name_display].value)
        gasgroupID_node = ET.SubElement(gas_node, "GasGroupId").text = str(rowMain[col_Gas_Group].value)
        gasgroup_node = ET.SubElement(gas_node, "GasGroupName").text = str(rowMain[col_GG_name].value)
        #GWP_AR4_HFC_node = ET.SubElement(gas_node, "GWP_AR4_HFC").text = str(rowMain[col_component_GWP_HFC].value)
        #GWP_AR4_Annex_node = ET.SubElement(gas_node, "GWP_AR4_AnnexIV").text = str(rowMain[col_component_GWP_full].value)
        
        
        
        
        for rowGWP in sheet_gwp.rows:
            if rowMain[col_Gas_ID].value == rowGWP[col_ID_Gas_sheet_gwp].value:
                GWP_AR4_HFC_node = ET.SubElement(gas_node, "GWP_AR4_HFC").text = str(rowGWP[col_GWP_HFC_part_sheet_gwp].value)
                GWP_AR4_Annex_node = ET.SubElement(gas_node, "GWP_AR4_AnnexIV").text = str(rowGWP[col_GWP_full_full_sheet_gwp].value)
                shortlisted_node = ET.SubElement(gas_node, "IsShortlisted").text = (str(rowGWP[col_IsShortlisted_sheet_gwp].value).lower())
                custom_node = ET.SubElement(gas_node, "IsCustom").text = (str(rowGWP[col_IsCustom_sheet_gwp].value).lower())
                blend_node = ET.SubElement(gas_node, "IsBlend").text = (str(rowGWP[col_IsBlend_sheet_gwp].value).lower())
                blendcomps_node = ET.SubElement(gas_node, "BlendComponents") 
                
        for rowMain2 in sheet_main.rows:
            if rowMain[col_Gas_ID].value == rowMain2[col_Gas_ID].value and str(rowGWP[col_IsBlend_sheet_gwp].value) == 'True':
              
                component_name= str(rowMain2[col_component_name_display].value)
                component_node = ET.SubElement(blendcomps_node, "Component") 
                compID_node = ET.SubElement(component_node, "Component_Id").text = str(rowMain2[col_Component_ID].value)
                comp_code_node = ET.SubElement(component_node, "Code").text = str(rowMain2[col_component_name_IA].value)
                comp_name_node = ET.SubElement(component_node, "Name").text = str(rowMain2[col_component_name_display].value)
                comp_gasgroupID_node = ET.SubElement(component_node, "GasGroupId").text = str(rowMain2[col_comp_group].value)
                compID__gasgroup_node = ET.SubElement(component_node, "GasGroupName").text = str(rowMain2[col_Comp_group_name].value)
                GWP_AR4_HFC_node2 = ET.SubElement(component_node, "GWP_AR4_HFC").text = str(rowMain2[col_component_GWP_HFC].value)
                GWP_AR4_Annex_node2 = ET.SubElement(component_node, "GWP_AR4_AnnexIV").text = str(rowMain2[col_component_GWP_full].value)
                
                #for rowMain3 in sheet_main.rows:
                    #if rowMain3[col_gas_name_display].value == component_name:
                        #componentsIDs.append(rowMain3[col_Gas_ID].value)
                        #gasIDforGWPSheet= rowMain3[col_Gas_ID].value
                        #GWP_AR4_HFC_node2 = ET.SubElement(component_node, "GWP_AR4_HFC").text = str(rowMain3[col_component_GWP_HFC].value)
                        #GWP_AR4_Annex_node2 = ET.SubElement(component_node, "GWP_AR4_AnnexIV").text = str(rowMain3[col_component_GWP_full].value)
                        
                
                        #for rowGWP2 in sheet_gwp.rows:
                            #if gasIDforGWPSheet == rowGWP2[col_ID_Gas_sheet_gwp].value:
                               # GWP_AR4_HFC_node2 = ET.SubElement(component_node, "GWP_AR4_HFC").text = str(rowGWP2[col_GWP_HFC_full_sheet_gwp].value)
                               # GWP_AR4_Annex_node2 = ET.SubElement(component_node, "GWP_AR4_AnnexIV").text = str(rowGWP2[col_GWP_full_full_sheet_gwp].value)
                             
                   
                
                comp_perc_node = ET.SubElement(component_node, "Percentage").text = str(rowMain2[col_Percentage].value)

#for rowMain3 in sheet_main.rows:
 #   if i!=0 and str(rowMain3[col_Gas_ID].value)!="None" and str(rowMain3[col_Gas_ID].value) != idGas : #saltarse la fila de la cabecera    
 #       comp_node = ET.SubElement(gas_node, "Component")        
 ##       compID_node2 = ET.SubElement(comp_node, "ComponentId").text = str(rowMain3[col_Component_ID].value)
  #      comp_code_node2 = ET.SubElement(comp_node, "Code").text = str(rowMain3[col_component_name_IA].value)
  #      comp_name_node2 = ET.SubElement(comp_node, "Name").text = str(rowMain3[col_component_name_display].value)
  #      comp_gasgroupID_node2 = ET.SubElement(comp_node, "GasGroupId").text = str(rowMain3[col_comp_group].value)
  #      compID__gasgroup_node2 = ET.SubElement(comp_node, "GasGroupName").text = str(rowMain3[col_Comp_group_name].value)
    i=i+1
    componentsIDs=[]    
    print('--- END OF ROW ---')

print(count_idGas)
if count_idGas!=None:
    tree = ET.ElementTree(root_node)
    tree.write("fgases-gases.xml",encoding="utf-8")
