class ZADOCL_GRAINS_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  interfaces IF_SADL_GW_MODEL_EXPOSURE_DATA .

  types:
     TS_PRINT_SMARTFORM type ZADOS_GRAINS_PRINT_FORM .
  types:
TT_PRINT_SMARTFORM type standard table of TS_PRINT_SMARTFORM .
  types:
   begin of ts_text_element,
      artifact_name  type c length 40,       " technical name
      artifact_type  type c length 4,
      parent_artifact_name type c length 40, " technical name
      parent_artifact_type type c length 4,
      text_symbol    type textpoolky,
   end of ts_text_element .
  types:
         tt_text_elements type standard table of ts_text_element with key text_symbol .
  types:
     TS_JSONCOMMUNICATION type ZADOS_GRAINS_JSON_DATA .
  types:
TT_JSONCOMMUNICATION type standard table of TS_JSONCOMMUNICATION .
  types:
     TS_ACCOUNTINGDOCUMENTTREE type ZADOS_GRAINS_ACC_TREE .
  types:
TT_ACCOUNTINGDOCUMENTTREE type standard table of TS_ACCOUNTINGDOCUMENTTREE .
  types:
    begin of TS_I_ACMTRADINGCONTRACTDATATYP.
      include type I_ACMTRADINGCONTRACTDATA.
  types:
    end of TS_I_ACMTRADINGCONTRACTDATATYP .
  types:
   TT_I_ACMTRADINGCONTRACTDATATYP type standard table of TS_I_ACMTRADINGCONTRACTDATATYP .
  types:
    begin of TS_I_BUSINESSPARTNERVHTYPE.
      include type I_BUSINESSPARTNERVH.
  types:
    end of TS_I_BUSINESSPARTNERVHTYPE .
  types:
   TT_I_BUSINESSPARTNERVHTYPE type standard table of TS_I_BUSINESSPARTNERVHTYPE .
  types:
    begin of TS_I_UNITOFMEASURETYPE.
      include type I_UNITOFMEASURE.
  types:
      T_UNITOFMEASURE type I_UNITOFMEASURETEXT-UNITOFMEASURELONGNAME,
    end of TS_I_UNITOFMEASURETYPE .
  types:
   TT_I_UNITOFMEASURETYPE type standard table of TS_I_UNITOFMEASURETYPE .
  types:
    begin of TS_P_TRADINGCONTRACTTYPEVHTYPE.
      include type P_TRADINGCONTRACTTYPEVH.
  types:
    end of TS_P_TRADINGCONTRACTTYPEVHTYPE .
  types:
   TT_P_TRADINGCONTRACTTYPEVHTYPE type standard table of TS_P_TRADINGCONTRACTTYPEVHTYPE .
  types:
    begin of TS_ZADOA_GRAINS_SALES_APPLTYPE.
      include type ZADOA_GRAINS_SALES_APPL.
  types:
    end of TS_ZADOA_GRAINS_SALES_APPLTYPE .
  types:
   TT_ZADOA_GRAINS_SALES_APPLTYPE type standard table of TS_ZADOA_GRAINS_SALES_APPLTYPE .
  types:
    begin of TS_ZADOC_GRAINS_APPL_INVOICEST.
      include type ZADOC_GRAINS_APPL_INVOICES.
  types:
    end of TS_ZADOC_GRAINS_APPL_INVOICEST .
  types:
   TT_ZADOC_GRAINS_APPL_INVOICEST type standard table of TS_ZADOC_GRAINS_APPL_INVOICEST .
  types:
    begin of TS_ZADOC_GRAINS_APPROVAL_LISTT.
      include type ZADOC_GRAINS_APPROVAL_LIST.
  types:
    end of TS_ZADOC_GRAINS_APPROVAL_LISTT .
  types:
   TT_ZADOC_GRAINS_APPROVAL_LISTT type standard table of TS_ZADOC_GRAINS_APPROVAL_LISTT .
  types:
    begin of TS_ZADOC_GRAINS_BALANCES_PROPE.
      include type ZADOC_GRAINS_BALANCES_PROPERTY.
  types:
    end of TS_ZADOC_GRAINS_BALANCES_PROPE .
  types:
   TT_ZADOC_GRAINS_BALANCES_PROPE type standard table of TS_ZADOC_GRAINS_BALANCES_PROPE .
  types:
    begin of TS_ZADOC_GRAINS_BALANCES_TO_SA.
      include type ZADOC_GRAINS_BALANCES_TO_SALES.
  types:
    end of TS_ZADOC_GRAINS_BALANCES_TO_SA .
  types:
   TT_ZADOC_GRAINS_BALANCES_TO_SA type standard table of TS_ZADOC_GRAINS_BALANCES_TO_SA .
  types:
    begin of TS_ZADOC_GRAINS_CNTRACT_FIXATI.
      include type ZADOC_GRAINS_CNTRACT_FIXATIONS.
  types:
    end of TS_ZADOC_GRAINS_CNTRACT_FIXATI .
  types:
   TT_ZADOC_GRAINS_CNTRACT_FIXATI type standard table of TS_ZADOC_GRAINS_CNTRACT_FIXATI .
  types:
    begin of TS_ZADOC_GRAINS_COMMODITY_DATA.
      include type ZADOC_GRAINS_COMMODITY_DATA.
  types:
    end of TS_ZADOC_GRAINS_COMMODITY_DATA .
  types:
   TT_ZADOC_GRAINS_COMMODITY_DATA type standard table of TS_ZADOC_GRAINS_COMMODITY_DATA .
  types:
    begin of TS_ZADOC_GRAINS_CONSUMED_APPLT.
      include type ZADOC_GRAINS_CONSUMED_APPL.
  types:
    end of TS_ZADOC_GRAINS_CONSUMED_APPLT .
  types:
   TT_ZADOC_GRAINS_CONSUMED_APPLT type standard table of TS_ZADOC_GRAINS_CONSUMED_APPLT .
  types:
    begin of TS_ZADOC_GRAINS_CONTRACT_APPRO.
      include type ZADOC_GRAINS_CONTRACT_APPROVAL.
  types:
    end of TS_ZADOC_GRAINS_CONTRACT_APPRO .
  types:
   TT_ZADOC_GRAINS_CONTRACT_APPRO type standard table of TS_ZADOC_GRAINS_CONTRACT_APPRO .
  types:
    begin of TS_ZADOC_GRAINS_CONTRACT_DETAI.
      include type ZADOC_GRAINS_CONTRACT_DETAILS.
  types:
    end of TS_ZADOC_GRAINS_CONTRACT_DETAI .
  types:
   TT_ZADOC_GRAINS_CONTRACT_DETAI type standard table of TS_ZADOC_GRAINS_CONTRACT_DETAI .
  types:
    begin of TS_ZADOC_GRAINS_CONTRACT_PARTN.
      include type ZADOC_GRAINS_CONTRACT_PARTNERS.
  types:
    end of TS_ZADOC_GRAINS_CONTRACT_PARTN .
  types:
   TT_ZADOC_GRAINS_CONTRACT_PARTN type standard table of TS_ZADOC_GRAINS_CONTRACT_PARTN .
  types:
    begin of TS_ZADOC_GRAINS_CONTR_APPROV_H.
      include type ZADOC_GRAINS_CONTR_APPROV_HIST.
  types:
    end of TS_ZADOC_GRAINS_CONTR_APPROV_H .
  types:
   TT_ZADOC_GRAINS_CONTR_APPROV_H type standard table of TS_ZADOC_GRAINS_CONTR_APPROV_H .
  types:
    begin of TS_ZADOC_GRAINS_CTR_APP_INV_IV.
      include type ZADOC_GRAINS_CTR_APP_INV_IV.
  types:
    end of TS_ZADOC_GRAINS_CTR_APP_INV_IV .
  types:
   TT_ZADOC_GRAINS_CTR_APP_INV_IV type standard table of TS_ZADOC_GRAINS_CTR_APP_INV_IV .
  types:
    begin of TS_ZADOC_GRAINS_CTR_APP_INV_SD.
      include type ZADOC_GRAINS_CTR_APP_INV_SD.
  types:
    end of TS_ZADOC_GRAINS_CTR_APP_INV_SD .
  types:
   TT_ZADOC_GRAINS_CTR_APP_INV_SD type standard table of TS_ZADOC_GRAINS_CTR_APP_INV_SD .
  types:
    begin of TS_ZADOC_GRAINS_CUSTOMER_OPEN_.
      include type ZADOC_GRAINS_CUSTOMER_OPEN_ACC.
  types:
    end of TS_ZADOC_GRAINS_CUSTOMER_OPEN_ .
  types:
   TT_ZADOC_GRAINS_CUSTOMER_OPEN_ type standard table of TS_ZADOC_GRAINS_CUSTOMER_OPEN_ .
  types:
    begin of TS_ZADOC_GRAINS_DOLAR_QUOTATIO.
      include type ZADOC_GRAINS_DOLAR_QUOTATION.
  types:
    end of TS_ZADOC_GRAINS_DOLAR_QUOTATIO .
  types:
   TT_ZADOC_GRAINS_DOLAR_QUOTATIO type standard table of TS_ZADOC_GRAINS_DOLAR_QUOTATIO .
  types:
    begin of TS_ZADOC_GRAINS_EDC_FROM_CONTR.
      include type ZADOC_GRAINS_EDC_FROM_CONTRACT.
  types:
    end of TS_ZADOC_GRAINS_EDC_FROM_CONTR .
  types:
   TT_ZADOC_GRAINS_EDC_FROM_CONTR type standard table of TS_ZADOC_GRAINS_EDC_FROM_CONTR .
  types:
    begin of TS_ZADOC_GRAINS_FIXATION_BILLT.
      include type ZADOC_GRAINS_FIXATION_BILL.
  types:
    end of TS_ZADOC_GRAINS_FIXATION_BILLT .
  types:
   TT_ZADOC_GRAINS_FIXATION_BILLT type standard table of TS_ZADOC_GRAINS_FIXATION_BILLT .
  types:
    begin of TS_ZADOC_GRAINS_FIXATION_DATAT.
      include type ZADOC_GRAINS_FIXATION_DATA.
  types:
    end of TS_ZADOC_GRAINS_FIXATION_DATAT .
  types:
   TT_ZADOC_GRAINS_FIXATION_DATAT type standard table of TS_ZADOC_GRAINS_FIXATION_DATAT .
  types:
    begin of TS_ZADOC_GRAINS_FUTURE_PRICETY.
      include type ZADOC_GRAINS_FUTURE_PRICE.
  types:
    end of TS_ZADOC_GRAINS_FUTURE_PRICETY .
  types:
   TT_ZADOC_GRAINS_FUTURE_PRICETY type standard table of TS_ZADOC_GRAINS_FUTURE_PRICETY .
  types:
    begin of TS_ZADOC_GRAINS_INVOICESTYPE.
      include type ZADOC_GRAINS_INVOICES.
  types:
    end of TS_ZADOC_GRAINS_INVOICESTYPE .
  types:
   TT_ZADOC_GRAINS_INVOICESTYPE type standard table of TS_ZADOC_GRAINS_INVOICESTYPE .
  types:
    begin of TS_ZADOC_GRAINS_MON_BEHAVIORTY.
      include type ZADOC_GRAINS_MON_BEHAVIOR.
  types:
    end of TS_ZADOC_GRAINS_MON_BEHAVIORTY .
  types:
   TT_ZADOC_GRAINS_MON_BEHAVIORTY type standard table of TS_ZADOC_GRAINS_MON_BEHAVIORTY .
  types:
    begin of TS_ZADOC_GRAINS_PARTNER_BLOCKS.
      include type ZADOC_GRAINS_PARTNER_BLOCKS.
  types:
    end of TS_ZADOC_GRAINS_PARTNER_BLOCKS .
  types:
   TT_ZADOC_GRAINS_PARTNER_BLOCKS type standard table of TS_ZADOC_GRAINS_PARTNER_BLOCKS .
  types:
    begin of TS_ZADOC_GRAINS_PRICING_BANK_D.
      include type ZADOC_GRAINS_PRICING_BANK_DATA.
  types:
    end of TS_ZADOC_GRAINS_PRICING_BANK_D .
  types:
   TT_ZADOC_GRAINS_PRICING_BANK_D type standard table of TS_ZADOC_GRAINS_PRICING_BANK_D .
  types:
    begin of TS_ZADOC_GRAINS_ROYALTIES_BLOC.
      include type ZADOC_GRAINS_ROYALTIES_BLOCK.
  types:
    end of TS_ZADOC_GRAINS_ROYALTIES_BLOC .
  types:
   TT_ZADOC_GRAINS_ROYALTIES_BLOC type standard table of TS_ZADOC_GRAINS_ROYALTIES_BLOC .
  types:
    begin of TS_ZADOC_GRAINS_SALES_APP_BILL.
      include type ZADOC_GRAINS_SALES_APP_BILLING.
  types:
    end of TS_ZADOC_GRAINS_SALES_APP_BILL .
  types:
   TT_ZADOC_GRAINS_SALES_APP_BILL type standard table of TS_ZADOC_GRAINS_SALES_APP_BILL .
  types:
    begin of TS_ZADOC_GRAINS_TXTTYPE.
      include type ZADOC_GRAINS_TXT.
  types:
    end of TS_ZADOC_GRAINS_TXTTYPE .
  types:
   TT_ZADOC_GRAINS_TXTTYPE type standard table of TS_ZADOC_GRAINS_TXTTYPE .
  types:
    begin of TS_ZADOC_GRAINS_USER_INFOTYPE.
      include type ZADOC_GRAINS_USER_INFO.
  types:
    end of TS_ZADOC_GRAINS_USER_INFOTYPE .
  types:
   TT_ZADOC_GRAINS_USER_INFOTYPE type standard table of TS_ZADOC_GRAINS_USER_INFOTYPE .
  types:
    begin of TS_ZADOI_GRAINS_CONTRACT_ITEMS.
      include type ZADOI_GRAINS_CONTRACT_ITEMS.
  types:
    end of TS_ZADOI_GRAINS_CONTRACT_ITEMS .
  types:
   TT_ZADOI_GRAINS_CONTRACT_ITEMS type standard table of TS_ZADOI_GRAINS_CONTRACT_ITEMS .
  types:
    begin of TS_ZADOI_GRAINS_FIXING_ITEMTYP.
      include type ZADOI_GRAINS_FIXING_ITEM.
  types:
    end of TS_ZADOI_GRAINS_FIXING_ITEMTYP .
  types:
   TT_ZADOI_GRAINS_FIXING_ITEMTYP type standard table of TS_ZADOI_GRAINS_FIXING_ITEMTYP .
  types:
    begin of TS_ZADOI_GRAINS_TREE_ACC_DOCST.
      include type ZADOI_GRAINS_TREE_ACC_DOCS.
  types:
    end of TS_ZADOI_GRAINS_TREE_ACC_DOCST .
  types:
   TT_ZADOI_GRAINS_TREE_ACC_DOCST type standard table of TS_ZADOI_GRAINS_TREE_ACC_DOCST .
  types:
    begin of TS_ZADOI_GRAINS_UNLOCK_BLOCKST.
      include type ZADOI_GRAINS_UNLOCK_BLOCKS.
  types:
    end of TS_ZADOI_GRAINS_UNLOCK_BLOCKST .
  types:
   TT_ZADOI_GRAINS_UNLOCK_BLOCKST type standard table of TS_ZADOI_GRAINS_UNLOCK_BLOCKST .
  types:
    begin of TS_ZI_ACM_CONTRACT_VHTYPE.
      include type ZI_ACM_CONTRACT_VH.
  types:
    end of TS_ZI_ACM_CONTRACT_VHTYPE .
  types:
   TT_ZI_ACM_CONTRACT_VHTYPE type standard table of TS_ZI_ACM_CONTRACT_VHTYPE .

  constants GC_ZI_ACM_CONTRACT_VHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_ACM_CONTRACT_VHType' ##NO_TEXT.
  constants GC_ZADOI_GRAINS_UNLOCK_BLOCKST type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOI_GRAINS_UNLOCK_BLOCKSType' ##NO_TEXT.
  constants GC_ZADOI_GRAINS_TREE_ACC_DOCST type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOI_GRAINS_TREE_ACC_DOCSType' ##NO_TEXT.
  constants GC_ZADOI_GRAINS_FIXING_ITEMTYP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOI_GRAINS_FIXING_ITEMType' ##NO_TEXT.
  constants GC_ZADOI_GRAINS_CONTRACT_ITEMS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOI_GRAINS_CONTRACT_ITEMSType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_USER_INFOTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_USER_INFOType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_TXTTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_TXTType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_SALES_APP_BILL type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_SALES_APP_BILLINGType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_ROYALTIES_BLOC type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_ROYALTIES_BLOCKType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_PRICING_BANK_D type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_PRICING_BANK_DATAType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_PARTNER_BLOCKS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_PARTNER_BLOCKSType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_MON_BEHAVIORTY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_MON_BEHAVIORType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_INVOICESTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_INVOICESType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_FUTURE_PRICETY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_FUTURE_PRICEType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_FIXATION_DATAT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_FIXATION_DATAType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_FIXATION_BILLT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_FIXATION_BILLType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_EDC_FROM_CONTR type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_EDC_FROM_CONTRACTType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_DOLAR_QUOTATIO type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_DOLAR_QUOTATIONType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_CUSTOMER_OPEN_ type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_CUSTOMER_OPEN_ACCType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_CTR_APP_INV_SD type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_CTR_APP_INV_SDType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_CTR_APP_INV_IV type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_CTR_APP_INV_IVType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_CONTR_APPROV_H type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_CONTR_APPROV_HISTType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_CONTRACT_PARTN type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_CONTRACT_PARTNERSType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_CONTRACT_DETAI type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_CONTRACT_DETAILSType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_CONTRACT_APPRO type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_CONTRACT_APPROVALType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_CONSUMED_APPLT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_CONSUMED_APPLType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_COMMODITY_DATA type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_COMMODITY_DATAType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_CNTRACT_FIXATI type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_CNTRACT_FIXATIONSType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_BALANCES_TO_SA type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_BALANCES_TO_SALESType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_BALANCES_PROPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_BALANCES_PROPERTYType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_APPROVAL_LISTT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_APPROVAL_LISTType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_APPL_INVOICEST type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_APPL_INVOICESType' ##NO_TEXT.
  constants GC_ZADOA_GRAINS_SALES_APPLTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOA_GRAINS_SALES_APPLType' ##NO_TEXT.
  constants GC_P_TRADINGCONTRACTTYPEVHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'P_TradingContractTypeVHType' ##NO_TEXT.
  constants GC_PRINT_SMARTFORM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'Print_Smartform' ##NO_TEXT.
  constants GC_JSONCOMMUNICATION type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'JsonCommunication' ##NO_TEXT.
  constants GC_I_UNITOFMEASURETYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'I_UnitOfMeasureType' ##NO_TEXT.
  constants GC_I_BUSINESSPARTNERVHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'I_BusinessPartnerVHType' ##NO_TEXT.
  constants GC_I_ACMTRADINGCONTRACTDATATYP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'I_ACMTradingContractDataType' ##NO_TEXT.
  constants GC_ACCOUNTINGDOCUMENTTREE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'AccountingDocumentTree' ##NO_TEXT.

  methods LOAD_TEXT_ELEMENTS
  final
    returning
      value(RT_TEXT_ELEMENTS) type TT_TEXT_ELEMENTS
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .

  methods DEFINE
    redefinition .
  methods GET_LAST_MODIFIED
    redefinition .
protected section.
private section.

  constants GC_INCL_NAME type STRING value 'ZADOCL_GRAINS_MPC=============CP' ##NO_TEXT.

  methods DEFINE_PRINT_SMARTFORM
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_JSONCOMMUNICATION
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_ACCOUNTINGDOCUMENTTREE
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_RDS_4
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods GET_LAST_MODIFIED_RDS_4
    returning
      value(RV_LAST_MODIFIED_RDS) type TIMESTAMP .
ENDCLASS.



CLASS ZADOCL_GRAINS_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*

model->set_schema_namespace( 'ZADOP_GRAINS_SRV' ).

define_print_smartform( ).
define_jsoncommunication( ).
define_accountingdocumenttree( ).
define_rds_4( ).
get_last_modified_rds_4( ).
  endmethod.


  method DEFINE_JSONCOMMUNICATION.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  data:
        lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       type ref to /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - JsonCommunication
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'JsonCommunication' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'StructureName' iv_abap_fieldname = 'STRUCTURE_NAME' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '001' iv_text_element_container = gc_incl_name ).  "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 30 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Action' iv_abap_fieldname = 'ACTION' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Json' iv_abap_fieldname = 'JSON' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).

lo_entity_type->bind_structure( iv_structure_name   = 'ZADOS_GRAINS_JSON_DATA'
                                iv_bind_conversions = 'X' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'JsonCommunicationSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_true ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
  endmethod.


  method LOAD_TEXT_ELEMENTS.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


DATA:
     ls_text_element TYPE ts_text_element.                                 "#EC NEEDED


clear ls_text_element.
ls_text_element-artifact_name          = 'StructureName'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                       "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'JsonCommunication'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'ETYP'.                                       "#EC NOTEXT
ls_text_element-text_symbol            = '001'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.


clear ls_text_element.
ls_text_element-artifact_name          = 'NodeId'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                       "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'AccountingDocumentTree'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'ETYP'.                                       "#EC NOTEXT
ls_text_element-text_symbol            = '002'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'HierarchyLevel'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                       "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'AccountingDocumentTree'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'ETYP'.                                       "#EC NOTEXT
ls_text_element-text_symbol            = '003'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'ParentNodeId'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                       "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'AccountingDocumentTree'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'ETYP'.                                       "#EC NOTEXT
ls_text_element-text_symbol            = '005'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
clear ls_text_element.
ls_text_element-artifact_name          = 'DrillState'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                       "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'AccountingDocumentTree'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'ETYP'.                                       "#EC NOTEXT
ls_text_element-text_symbol            = '006'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
  endmethod.


  method DEFINE_RDS_4.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*
*   This code is generated for Reference Data Source
*   4
*&---------------------------------------------------------------------*
    TRY.
        if_sadl_gw_model_exposure_data~get_model_exposure( )->expose( model )->expose_vocabulary( vocab_anno_model ).
      CATCH cx_sadl_exposure_error INTO DATA(lx_sadl_exposure_error).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_med_exception
          EXPORTING
            previous = lx_sadl_exposure_error.
    ENDTRY.
  endmethod.


  method GET_LAST_MODIFIED.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  CONSTANTS: lc_gen_date_time TYPE timestamp VALUE '20230629170205'.                  "#EC NOTEXT
 DATA: lv_rds_last_modified TYPE timestamp .
  rv_last_modified = super->get_last_modified( ).
  IF rv_last_modified LT lc_gen_date_time.
    rv_last_modified = lc_gen_date_time.
  ENDIF.
 lv_rds_last_modified =  GET_LAST_MODIFIED_RDS_4( ).
 IF rv_last_modified LT lv_rds_last_modified.
 rv_last_modified  = lv_rds_last_modified .
 ENDIF .
  endmethod.


  method GET_LAST_MODIFIED_RDS_4.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*
*   This code is generated for Reference Data Source
*   4
*&---------------------------------------------------------------------*
*    @@TYPE_SWITCH:
    CONSTANTS: co_gen_date_time TYPE timestamp VALUE '20230629170205'.
    TRY.
        rv_last_modified_rds = CAST cl_sadl_gw_model_exposure( if_sadl_gw_model_exposure_data~get_model_exposure( ) )->get_last_modified( ).
      CATCH cx_root ##CATCH_ALL.
        rv_last_modified_rds = co_gen_date_time.
    ENDTRY.
    IF rv_last_modified_rds < co_gen_date_time.
      rv_last_modified_rds = co_gen_date_time.
    ENDIF.
  endmethod.


  method IF_SADL_GW_MODEL_EXPOSURE_DATA~GET_MODEL_EXPOSURE.
    CONSTANTS: co_gen_timestamp TYPE timestamp VALUE '20230629170205'.
    DATA(lv_sadl_xml) =
               |<?xml version="1.0" encoding="utf-16"?>|  &
               |<sadl:definition xmlns:sadl="http://sap.com/sap.nw.f.sadl" syntaxVersion="V2" >|  &
               | <sadl:dataSource type="CDS" name="I_ACMTRADINGCONTRACTDATA" binding="I_ACMTRADINGCONTRACTDATA" />|  &
               | <sadl:dataSource type="CDS" name="ZI_ACM_CONTRACT_VH" binding="ZI_ACM_CONTRACT_VH" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_APPL_INVOICES" binding="ZADOC_GRAINS_APPL_INVOICES" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_APPROVAL_LIST" binding="ZADOC_GRAINS_APPROVAL_LIST" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_BALANCES_PROPERTY" binding="ZADOC_GRAINS_BALANCES_PROPERTY" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_BALANCES_TO_SALES" binding="ZADOC_GRAINS_BALANCES_TO_SALES" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_CNTRACT_FIXATIONS" binding="ZADOC_GRAINS_CNTRACT_FIXATIONS" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_COMMODITY_DATA" binding="ZADOC_GRAINS_COMMODITY_DATA" />|  &
               | <sadl:dataSource type="CDS" name="I_BUSINESSPARTNERVH" binding="I_BUSINESSPARTNERVH" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_CONSUMED_APPL" binding="ZADOC_GRAINS_CONSUMED_APPL" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_CONTRACT_APPROVAL" binding="ZADOC_GRAINS_CONTRACT_APPROVAL" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_CONTRACT_DETAILS" binding="ZADOC_GRAINS_CONTRACT_DETAILS" />|  &
               | <sadl:dataSource type="CDS" name="I_UNITOFMEASURE" binding="I_UNITOFMEASURE" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_CONTRACT_PARTNERS" binding="ZADOC_GRAINS_CONTRACT_PARTNERS" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_CONTR_APPROV_HIST" binding="ZADOC_GRAINS_CONTR_APPROV_HIST" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_CTR_APP_INV_IV" binding="ZADOC_GRAINS_CTR_APP_INV_IV" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_CTR_APP_INV_SD" binding="ZADOC_GRAINS_CTR_APP_INV_SD" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_CUSTOMER_OPEN_ACC" binding="ZADOC_GRAINS_CUSTOMER_OPEN_ACC" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_DOLAR_QUOTATION" binding="ZADOC_GRAINS_DOLAR_QUOTATION" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_EDC_FROM_CONTRACT" binding="ZADOC_GRAINS_EDC_FROM_CONTRACT" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_FIXATION_BILL" binding="ZADOC_GRAINS_FIXATION_BILL" />|  &
               | <sadl:dataSource type="CDS" name="P_TRADINGCONTRACTTYPEVH" binding="P_TRADINGCONTRACTTYPEVH" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_FIXATION_DATA" binding="ZADOC_GRAINS_FIXATION_DATA" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_FUTURE_PRICE" binding="ZADOC_GRAINS_FUTURE_PRICE" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_INVOICES" binding="ZADOC_GRAINS_INVOICES" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_MON_BEHAVIOR" binding="ZADOC_GRAINS_MON_BEHAVIOR" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_PARTNER_BLOCKS" binding="ZADOC_GRAINS_PARTNER_BLOCKS" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_PRICING_BANK_DATA" binding="ZADOC_GRAINS_PRICING_BANK_DATA" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_ROYALTIES_BLOCK" binding="ZADOC_GRAINS_ROYALTIES_BLOCK" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_SALES_APP_BILLING" binding="ZADOC_GRAINS_SALES_APP_BILLING" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_TXT" binding="ZADOC_GRAINS_TXT" />|  &
               | <sadl:dataSource type="CDS" name="ZADOA_GRAINS_SALES_APPL" binding="ZADOA_GRAINS_SALES_APPL" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_USER_INFO" binding="ZADOC_GRAINS_USER_INFO" />|  &
               | <sadl:dataSource type="CDS" name="ZADOI_GRAINS_CONTRACT_ITEMS" binding="ZADOI_GRAINS_CONTRACT_ITEMS" />|  &
               | <sadl:dataSource type="CDS" name="ZADOI_GRAINS_FIXING_ITEM" binding="ZADOI_GRAINS_FIXING_ITEM" />|  &
               | <sadl:dataSource type="CDS" name="ZADOI_GRAINS_TREE_ACC_DOCS" binding="ZADOI_GRAINS_TREE_ACC_DOCS" />|  &
               | <sadl:dataSource type="CDS" name="ZADOI_GRAINS_UNLOCK_BLOCKS" binding="ZADOI_GRAINS_UNLOCK_BLOCKS" />|  &
               |<sadl:resultSet>|  &
               |<sadl:structure name="I_ACMTradingContractData" dataSource="I_ACMTRADINGCONTRACTDATA" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_ACM_CONTRACT_VH" dataSource="ZI_ACM_CONTRACT_VH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_APPL_INVOICES" dataSource="ZADOC_GRAINS_APPL_INVOICES" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">| .
      lv_sadl_xml = |{ lv_sadl_xml }| &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_APPROVAL_LIST" dataSource="ZADOC_GRAINS_APPROVAL_LIST" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_CONTRACTITEM" binding="_CONTRACTITEM" target="ZADOI_GRAINS_CONTRACT_ITEMS" cardinality="oneToMany" />|  &
               | <sadl:association name="TO_FIXINGITEM" binding="_FIXINGITEM" target="ZADOI_GRAINS_FIXING_ITEM" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_STATUSCHANGELOG" binding="_STATUSCHANGELOG" target="ZADOC_GRAINS_CONTR_APPROV_HIST" cardinality="zeroToMany" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_BALANCES_PROPERTY" dataSource="ZADOC_GRAINS_BALANCES_PROPERTY" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_BALANCES_TO_SALES" dataSource="ZADOC_GRAINS_BALANCES_TO_SALES" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_CNTRACT_FIXATIONS" dataSource="ZADOC_GRAINS_CNTRACT_FIXATIONS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_BALANCEPROPERTY" binding="_BALANCEPROPERTY" target="ZADOC_GRAINS_BALANCES_PROPERTY" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_BILLING" binding="_BILLING" target="ZADOC_GRAINS_FIXATION_BILL" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_CONSAPPLICATIONS" binding="_CONSAPPLICATIONS" target="ZADOC_GRAINS_CONSUMED_APPL" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_FIXATIONDATA" binding="_FIXATIONDATA" target="ZADOC_GRAINS_FIXATION_DATA" cardinality="zeroToOne" />|  &
               | <sadl:association name="TO_PARTNERBLOCKS" binding="_PARTNERBLOCKS" target="ZADOC_GRAINS_PARTNER_BLOCKS" cardinality="zeroToMany" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_COMMODITY_DATA" dataSource="ZADOC_GRAINS_COMMODITY_DATA" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="I_BusinessPartnerVH" dataSource="I_BUSINESSPARTNERVH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_CONSUMED_APPL" dataSource="ZADOC_GRAINS_CONSUMED_APPL" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_CONTRACT_APPROVAL" dataSource="ZADOC_GRAINS_CONTRACT_APPROVAL" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_CONTRACTITEM" binding="_CONTRACTITEM" target="ZADOI_GRAINS_CONTRACT_ITEMS" cardinality="oneToMany" />|  &
               | <sadl:association name="TO_FIXINGITEM" binding="_FIXINGITEM" target="ZADOI_GRAINS_FIXING_ITEM" cardinality="zeroToMany" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_CONTRACT_DETAILS" dataSource="ZADOC_GRAINS_CONTRACT_DETAILS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_APPINVOICES" binding="_APPINVOICES" target="ZADOC_GRAINS_APPL_INVOICES" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_APPLICATIONS" binding="_APPLICATIONS" target="ZADOC_GRAINS_EDC_FROM_CONTRACT" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_APPLICATIONSTOSALES" binding="_APPLICATIONSTOSALES" target="ZADOA_GRAINS_SALES_APPL" cardinality="zeroToMany" />| .
      lv_sadl_xml = |{ lv_sadl_xml }| &
               | <sadl:association name="TO_BALANCEPROPERTY" binding="_BALANCEPROPERTY" target="ZADOC_GRAINS_BALANCES_PROPERTY" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_COMMODITYITEMDETAILS" binding="_COMMODITYITEMDETAILS" target="ZADOI_GRAINS_CONTRACT_ITEMS" cardinality="oneToMany" />|  &
               | <sadl:association name="TO_CUSTOPENACC" binding="_CUSTOPENACC" target="ZADOC_GRAINS_CUSTOMER_OPEN_ACC" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_FIXATIONS" binding="_FIXATIONS" target="ZADOC_GRAINS_CNTRACT_FIXATIONS" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_FIXINVOICES" binding="_FIXINVOICES" target="ZADOC_GRAINS_APPL_INVOICES" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_NFS" binding="_NFS" target="ZADOC_GRAINS_INVOICES" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_PARTNERBLOCKS" binding="_PARTNERBLOCKS" target="ZADOC_GRAINS_PARTNER_BLOCKS" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_ROYALTIESBLOCKS" binding="_ROYALTIESBLOCKS" target="ZADOC_GRAINS_ROYALTIES_BLOCK" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_SALESAPPBILLING" binding="_SALESAPPBILLING" target="ZADOC_GRAINS_SALES_APP_BILLING" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_SALESFIXBILLING" binding="_SALESFIXBILLING" target="ZADOC_GRAINS_SALES_APP_BILLING" cardinality="zeroToMany" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="I_UnitOfMeasure" dataSource="I_UNITOFMEASURE" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_CONTRACT_PARTNERS" dataSource="ZADOC_GRAINS_CONTRACT_PARTNERS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_CONTR_APPROV_HIST" dataSource="ZADOC_GRAINS_CONTR_APPROV_HIST" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_CTR_APP_INV_IV" dataSource="ZADOC_GRAINS_CTR_APP_INV_IV" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_ACCTREE" binding="_ACCTREE" target="ZADOI_GRAINS_TREE_ACC_DOCS" cardinality="zeroToMany" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_CTR_APP_INV_SD" dataSource="ZADOC_GRAINS_CTR_APP_INV_SD" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_INVOICEAPLICATIONS" binding="_INVOICEAPLICATIONS" target="ZADOC_GRAINS_CTR_APP_INV_IV" cardinality="zeroToMany" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_CUSTOMER_OPEN_ACC" dataSource="ZADOC_GRAINS_CUSTOMER_OPEN_ACC" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_DOLAR_QUOTATION" dataSource="ZADOC_GRAINS_DOLAR_QUOTATION" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_EDC_FROM_CONTRACT" dataSource="ZADOC_GRAINS_EDC_FROM_CONTRACT" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_ROYALTIESBLOCKS" binding="_ROYALTIESBLOCKS" target="ZADOC_GRAINS_ROYALTIES_BLOCK" cardinality="one" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_FIXATION_BILL" dataSource="ZADOC_GRAINS_FIXATION_BILL" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>| .
      lv_sadl_xml = |{ lv_sadl_xml }| &
               |<sadl:structure name="P_TradingContractTypeVH" dataSource="P_TRADINGCONTRACTTYPEVH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_FIXATION_DATA" dataSource="ZADOC_GRAINS_FIXATION_DATA" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_FUTURE_PRICE" dataSource="ZADOC_GRAINS_FUTURE_PRICE" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_INVOICES" dataSource="ZADOC_GRAINS_INVOICES" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_MON_BEHAVIOR" dataSource="ZADOC_GRAINS_MON_BEHAVIOR" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_PARTNER_BLOCKS" dataSource="ZADOC_GRAINS_PARTNER_BLOCKS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_UNLOCKBLOCKS" binding="_UNLOCKBLOCKS" target="ZADOI_GRAINS_UNLOCK_BLOCKS" cardinality="zeroToMany" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_PRICING_BANK_DATA" dataSource="ZADOC_GRAINS_PRICING_BANK_DATA" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_ROYALTIES_BLOCK" dataSource="ZADOC_GRAINS_ROYALTIES_BLOCK" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_SALES_APP_BILLING" dataSource="ZADOC_GRAINS_SALES_APP_BILLING" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_TXT" dataSource="ZADOC_GRAINS_TXT" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOA_GRAINS_SALES_APPL" dataSource="ZADOA_GRAINS_SALES_APPL" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_USER_INFO" dataSource="ZADOC_GRAINS_USER_INFO" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOI_GRAINS_CONTRACT_ITEMS" dataSource="ZADOI_GRAINS_CONTRACT_ITEMS" maxEditMode="RO" exposure="TRUE" >| .
      lv_sadl_xml = |{ lv_sadl_xml }| &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOI_GRAINS_FIXING_ITEM" dataSource="ZADOI_GRAINS_FIXING_ITEM" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOI_GRAINS_TREE_ACC_DOCS" dataSource="ZADOI_GRAINS_TREE_ACC_DOCS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOI_GRAINS_UNLOCK_BLOCKS" dataSource="ZADOI_GRAINS_UNLOCK_BLOCKS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |</sadl:resultSet>|  &
               |</sadl:definition>| .

   ro_model_exposure = cl_sadl_gw_model_exposure=>get_exposure_xml( iv_uuid      = CONV #( 'ZADOP_GRAINS' )
                                                                    iv_timestamp = co_gen_timestamp
                                                                    iv_sadl_xml  = lv_sadl_xml ).
  endmethod.


  method DEFINE_ACCOUNTINGDOCUMENTTREE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  data:
        lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       type ref to /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - AccountingDocumentTree
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'AccountingDocumentTree' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'NodeId' iv_abap_fieldname = 'NODE_ID' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '002' iv_text_element_container = gc_incl_name ).  "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_int16( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ClearingDocument' iv_abap_fieldname = 'CLEARING_DOCUMENT' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ). "#EC NOTEXT
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Description' iv_abap_fieldname = 'DESCRIPTION' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 50 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ClearingDocumentYear' iv_abap_fieldname = 'CLEARING_DOCUMENT_YEAR' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ). "#EC NOTEXT
lo_property->set_conversion_exit( 'GJAHR' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'HierarchyLevel' iv_abap_fieldname = 'HIERARCHY_LEVEL' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '003' iv_text_element_container = gc_incl_name ).  "#EC NOTEXT
lo_property->set_type_edm_int16( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ParentNodeId' iv_abap_fieldname = 'PARENT_NODE_ID' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '005' iv_text_element_container = gc_incl_name ).  "#EC NOTEXT
lo_property->set_type_edm_int16( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'DrillState' iv_abap_fieldname = 'DRILL_STATE' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '006' iv_text_element_container = gc_incl_name ).  "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CompanyCode' iv_abap_fieldname = 'COMPANY_CODE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'AccountingDocument' iv_abap_fieldname = 'ACCOUNTING_DOCUMENT' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ). "#EC NOTEXT
lo_property->set_conversion_exit( 'ALPHA' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'AccountingDocumentYear' iv_abap_fieldname = 'ACCOUNTING_DOCUMENT_YEAR' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 4 ). "#EC NOTEXT
lo_property->set_conversion_exit( 'GJAHR' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'AccountingItem' iv_abap_fieldname = 'ACCOUNTING_ITEM' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 3 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Amount' iv_abap_fieldname = 'AMOUNT' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 3 ). "#EC NOTEXT
lo_property->set_maxlength( iv_max_length = 24 ). "#EC NOTEXT
lo_property->set_conversion_exit( 'AU132' ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Currency' iv_abap_fieldname = 'CURRENCY' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 5 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Status' iv_abap_fieldname = 'STATUS' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 10 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).

lo_entity_type->bind_structure( iv_structure_name   = 'ZADOS_GRAINS_ACC_TREE'
                                iv_bind_conversions = 'X' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'AccountingDocumentTreeSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_true ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
  endmethod.


  method DEFINE_PRINT_SMARTFORM.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  data:
        lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       type ref to /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - Print_Smartform
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'Print_Smartform' iv_def_entity_set = abap_false ). "#EC NOTEXT
lo_entity_type->set_is_media( 'X' ).  "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'FormName' iv_abap_fieldname = 'FORM_NAME' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 30 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'FormParams' iv_abap_fieldname = 'FORM_PARAMS' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).

lo_entity_type->bind_structure( iv_structure_name   = 'ZADOS_GRAINS_PRINT_FORM'
                                iv_bind_conversions = 'X' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'Print_SmartformSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_false ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
  endmethod.
ENDCLASS.
