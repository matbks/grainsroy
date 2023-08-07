class ZCL_ZADOP_CREDIT_BLOCK_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  interfaces IF_SADL_GW_MODEL_EXPOSURE_DATA .

  types:
     TS_JSONCOMM type ZADOS_GRAINS_CB_JSON_DATA .
  types:
TT_JSONCOMM type standard table of TS_JSONCOMM .
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
    begin of TS_I_BUSINESSPARTNERVHTYPE.
      include type I_BUSINESSPARTNERVH.
  types:
    end of TS_I_BUSINESSPARTNERVHTYPE .
  types:
   TT_I_BUSINESSPARTNERVHTYPE type standard table of TS_I_BUSINESSPARTNERVHTYPE .
  types:
    begin of TS_I_MATERIALDESCRIPTIONTYPE.
      include type I_MATERIALDESCRIPTION.
  types:
    end of TS_I_MATERIALDESCRIPTIONTYPE .
  types:
   TT_I_MATERIALDESCRIPTIONTYPE type standard table of TS_I_MATERIALDESCRIPTIONTYPE .
  types:
    begin of TS_ZADOA_GRAINS_CREDIT_BLOCK_D.
      include type ZADOA_GRAINS_CREDIT_BLOCK_D.
  types:
    end of TS_ZADOA_GRAINS_CREDIT_BLOCK_D .
  types:
   TT_ZADOA_GRAINS_CREDIT_BLOCK_D type standard table of TS_ZADOA_GRAINS_CREDIT_BLOCK_D .
  types:
    begin of TS_ZADOC_COMERCIAL_CONTRACTTYP.
      include type ZADOC_COMERCIAL_CONTRACT.
  types:
    end of TS_ZADOC_COMERCIAL_CONTRACTTYP .
  types:
   TT_ZADOC_COMERCIAL_CONTRACTTYP type standard table of TS_ZADOC_COMERCIAL_CONTRACTTYP .
  types:
    begin of TS_ZADOC_CONTRACT_SAFRATYPE.
      include type ZADOC_CONTRACT_SAFRA.
  types:
    end of TS_ZADOC_CONTRACT_SAFRATYPE .
  types:
   TT_ZADOC_CONTRACT_SAFRATYPE type standard table of TS_ZADOC_CONTRACT_SAFRATYPE .
  types:
    begin of TS_ZADOC_CREDIT_BLOCKS_PARTNER.
      include type ZADOC_CREDIT_BLOCKS_PARTNER_VH.
  types:
    end of TS_ZADOC_CREDIT_BLOCKS_PARTNER .
  types:
   TT_ZADOC_CREDIT_BLOCKS_PARTNER type standard table of TS_ZADOC_CREDIT_BLOCKS_PARTNER .
  types:
    begin of TS_ZADOC_CREDIT_BLOCKS_PRODUCT.
      include type ZADOC_CREDIT_BLOCKS_PRODUCT_VH.
  types:
    end of TS_ZADOC_CREDIT_BLOCKS_PRODUCT .
  types:
   TT_ZADOC_CREDIT_BLOCKS_PRODUCT type standard table of TS_ZADOC_CREDIT_BLOCKS_PRODUCT .
  types:
    begin of TS_ZADOC_CREDIT_BLOCK_BP_F4TYP.
      include type ZADOC_CREDIT_BLOCK_BP_F4.
  types:
    end of TS_ZADOC_CREDIT_BLOCK_BP_F4TYP .
  types:
   TT_ZADOC_CREDIT_BLOCK_BP_F4TYP type standard table of TS_ZADOC_CREDIT_BLOCK_BP_F4TYP .
  types:
    begin of TS_ZADOC_CREDIT_BLOCK_CONTRACT.
      include type ZADOC_CREDIT_BLOCK_CONTRACT_VH.
  types:
    end of TS_ZADOC_CREDIT_BLOCK_CONTRACT .
  types:
   TT_ZADOC_CREDIT_BLOCK_CONTRACT type standard table of TS_ZADOC_CREDIT_BLOCK_CONTRACT .
  types:
    begin of TS_ZADOC_GRAINS_TRANSGENIATYPE.
      include type ZADOC_GRAINS_TRANSGENIA.
  types:
    end of TS_ZADOC_GRAINS_TRANSGENIATYPE .
  types:
   TT_ZADOC_GRAINS_TRANSGENIATYPE type standard table of TS_ZADOC_GRAINS_TRANSGENIATYPE .
  types:
    begin of TS_ZADOC_SAFRASTYPE.
      include type ZADOC_SAFRAS.
  types:
    end of TS_ZADOC_SAFRASTYPE .
  types:
   TT_ZADOC_SAFRASTYPE type standard table of TS_ZADOC_SAFRASTYPE .
  types:
    begin of TS_ZADOI_CREDIT_BLOCK_TO_FIXTY.
      include type ZADOI_CREDIT_BLOCK_TO_FIX.
  types:
    end of TS_ZADOI_CREDIT_BLOCK_TO_FIXTY .
  types:
   TT_ZADOI_CREDIT_BLOCK_TO_FIXTY type standard table of TS_ZADOI_CREDIT_BLOCK_TO_FIXTY .
  types:
    begin of TS_ZADOI_GRAINS_CREDIT_BLOCKTY.
      include type ZADOI_GRAINS_CREDIT_BLOCK.
  types:
    end of TS_ZADOI_GRAINS_CREDIT_BLOCKTY .
  types:
   TT_ZADOI_GRAINS_CREDIT_BLOCKTY type standard table of TS_ZADOI_GRAINS_CREDIT_BLOCKTY .
  types:
    begin of TS_ZI_ACM_CONTRACT_VHTYPE.
      include type ZI_ACM_CONTRACT_VH.
  types:
    end of TS_ZI_ACM_CONTRACT_VHTYPE .
  types:
   TT_ZI_ACM_CONTRACT_VHTYPE type standard table of TS_ZI_ACM_CONTRACT_VHTYPE .
  types:
    begin of TS_ZI_PARTNERSTYPE.
      include type ZI_PARTNERS.
  types:
    end of TS_ZI_PARTNERSTYPE .
  types:
   TT_ZI_PARTNERSTYPE type standard table of TS_ZI_PARTNERSTYPE .
  types:
    begin of TS_Z_ADOC_MATERIAL_DESCRIPT_ZC.
      include type Z_ADOC_MATERIAL_DESCRIPT_ZCOM.
  types:
    end of TS_Z_ADOC_MATERIAL_DESCRIPT_ZC .
  types:
   TT_Z_ADOC_MATERIAL_DESCRIPT_ZC type standard table of TS_Z_ADOC_MATERIAL_DESCRIPT_ZC .

  constants GC_I_BUSINESSPARTNERVHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'I_BusinessPartnerVHType' ##NO_TEXT.
  constants GC_I_MATERIALDESCRIPTIONTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'I_MaterialDescriptionType' ##NO_TEXT.
  constants GC_JSONCOMM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'JsonComm' ##NO_TEXT.
  constants GC_ZADOA_GRAINS_CREDIT_BLOCK_D type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOA_GRAINS_CREDIT_BLOCK_DType' ##NO_TEXT.
  constants GC_ZADOC_COMERCIAL_CONTRACTTYP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_COMERCIAL_CONTRACTType' ##NO_TEXT.
  constants GC_ZADOC_CONTRACT_SAFRATYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_CONTRACT_SAFRAType' ##NO_TEXT.
  constants GC_ZADOC_CREDIT_BLOCKS_PARTNER type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_CREDIT_BLOCKS_PARTNER_VHType' ##NO_TEXT.
  constants GC_ZADOC_CREDIT_BLOCKS_PRODUCT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_CREDIT_BLOCKS_PRODUCT_VHType' ##NO_TEXT.
  constants GC_ZADOC_CREDIT_BLOCK_BP_F4TYP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_CREDIT_BLOCK_BP_F4Type' ##NO_TEXT.
  constants GC_ZADOC_CREDIT_BLOCK_CONTRACT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_CREDIT_BLOCK_CONTRACT_VHType' ##NO_TEXT.
  constants GC_ZADOC_GRAINS_TRANSGENIATYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_GRAINS_TRANSGENIAType' ##NO_TEXT.
  constants GC_ZADOC_SAFRASTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_SAFRASType' ##NO_TEXT.
  constants GC_ZADOI_CREDIT_BLOCK_TO_FIXTY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOI_CREDIT_BLOCK_TO_FIXType' ##NO_TEXT.
  constants GC_ZADOI_GRAINS_CREDIT_BLOCKTY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOI_GRAINS_CREDIT_BLOCKType' ##NO_TEXT.
  constants GC_ZI_ACM_CONTRACT_VHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_ACM_CONTRACT_VHType' ##NO_TEXT.
  constants GC_ZI_PARTNERSTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_PARTNERSType' ##NO_TEXT.
  constants GC_Z_ADOC_MATERIAL_DESCRIPT_ZC type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'Z_ADOC_MATERIAL_DESCRIPT_ZCOMType' ##NO_TEXT.

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

  constants GC_INCL_NAME type STRING value 'ZCL_ZADOP_CREDIT_BLOCK_MPC====CP' ##NO_TEXT.

  methods DEFINE_JSONCOMM
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_RDS_4
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods GET_LAST_MODIFIED_RDS_4
    returning
      value(RV_LAST_MODIFIED_RDS) type TIMESTAMP .
ENDCLASS.



CLASS ZCL_ZADOP_CREDIT_BLOCK_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*

model->set_schema_namespace( 'ZADOP_CREDIT_BLOCK_SRV' ).

define_jsoncomm( ).
define_rds_4( ).
get_last_modified_rds_4( ).
  endmethod.


  method DEFINE_JSONCOMM.
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
*   ENTITY - JsonComm
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'JsonComm' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

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
lo_property = lo_entity_type->create_property( iv_property_name = 'Returnmessage' iv_abap_fieldname = 'RETURNMESSAGE' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '001' iv_text_element_container = gc_incl_name ).  "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 100 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).

lo_entity_type->bind_structure( iv_structure_name   = 'ZADOS_GRAINS_CB_JSON_DATA'
                                iv_bind_conversions = 'X' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'JsonCommSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_true ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
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


  CONSTANTS: lc_gen_date_time TYPE timestamp VALUE '20230609133602'.                  "#EC NOTEXT
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
    CONSTANTS: co_gen_date_time TYPE timestamp VALUE '20230609133602'.
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
    CONSTANTS: co_gen_timestamp TYPE timestamp VALUE '20230609133602'.
    DATA(lv_sadl_xml) =
               |<?xml version="1.0" encoding="utf-16"?>|  &
               |<sadl:definition xmlns:sadl="http://sap.com/sap.nw.f.sadl" syntaxVersion="V2" >|  &
               | <sadl:dataSource type="CDS" name="I_BUSINESSPARTNERVH" binding="I_BUSINESSPARTNERVH" />|  &
               | <sadl:dataSource type="CDS" name="I_MATERIALDESCRIPTION" binding="I_MATERIALDESCRIPTION" />|  &
               | <sadl:dataSource type="CDS" name="ZADOA_GRAINS_CREDIT_BLOCK_D" binding="ZADOA_GRAINS_CREDIT_BLOCK_D" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_COMERCIAL_CONTRACT" binding="ZADOC_COMERCIAL_CONTRACT" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_CONTRACT_SAFRA" binding="ZADOC_CONTRACT_SAFRA" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_CREDIT_BLOCKS_PARTNER_VH" binding="ZADOC_CREDIT_BLOCKS_PARTNER_VH" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_CREDIT_BLOCKS_PRODUCT_VH" binding="ZADOC_CREDIT_BLOCKS_PRODUCT_VH" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_CREDIT_BLOCK_BP_F4" binding="ZADOC_CREDIT_BLOCK_BP_F4" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_CREDIT_BLOCK_CONTRACT_VH" binding="ZADOC_CREDIT_BLOCK_CONTRACT_VH" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_GRAINS_TRANSGENIA" binding="ZADOC_GRAINS_TRANSGENIA" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_SAFRAS" binding="ZADOC_SAFRAS" />|  &
               | <sadl:dataSource type="CDS" name="ZADOI_CREDIT_BLOCK_TO_FIX" binding="ZADOI_CREDIT_BLOCK_TO_FIX" />|  &
               | <sadl:dataSource type="CDS" name="ZADOI_GRAINS_CREDIT_BLOCK" binding="ZADOI_GRAINS_CREDIT_BLOCK" />|  &
               | <sadl:dataSource type="CDS" name="ZI_ACM_CONTRACT_VH" binding="ZI_ACM_CONTRACT_VH" />|  &
               | <sadl:dataSource type="CDS" name="ZI_PARTNERS" binding="ZI_PARTNERS" />|  &
               | <sadl:dataSource type="CDS" name="Z_ADOC_MATERIAL_DESCRIPT_ZCOM" binding="Z_ADOC_MATERIAL_DESCRIPT_ZCOM" />|  &
               |<sadl:resultSet>|  &
               |<sadl:structure name="I_BusinessPartnerVH" dataSource="I_BUSINESSPARTNERVH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="I_MaterialDescription" dataSource="I_MATERIALDESCRIPTION" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOA_GRAINS_CREDIT_BLOCK_D" dataSource="ZADOA_GRAINS_CREDIT_BLOCK_D" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_COMERCIAL_CONTRACT" dataSource="ZADOC_COMERCIAL_CONTRACT" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_CONTRACT_SAFRA" dataSource="ZADOC_CONTRACT_SAFRA" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_CREDIT_BLOCKS_PARTNER_VH" dataSource="ZADOC_CREDIT_BLOCKS_PARTNER_VH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_CREDIT_BLOCKS_PRODUCT_VH" dataSource="ZADOC_CREDIT_BLOCKS_PRODUCT_VH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_CREDIT_BLOCK_BP_F4" dataSource="ZADOC_CREDIT_BLOCK_BP_F4" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>| .
      lv_sadl_xml = |{ lv_sadl_xml }| &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_CREDIT_BLOCK_CONTRACT_VH" dataSource="ZADOC_CREDIT_BLOCK_CONTRACT_VH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_GRAINS_TRANSGENIA" dataSource="ZADOC_GRAINS_TRANSGENIA" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_SAFRAS" dataSource="ZADOC_SAFRAS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOI_CREDIT_BLOCK_TO_FIX" dataSource="ZADOI_CREDIT_BLOCK_TO_FIX" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOI_GRAINS_CREDIT_BLOCK" dataSource="ZADOI_GRAINS_CREDIT_BLOCK" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_CREDITBLOCKDISCHARGE" binding="_CREDITBLOCKDISCHARGE" target="ZADOA_GRAINS_CREDIT_BLOCK_D" cardinality="zeroToMany" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_ACM_CONTRACT_VH" dataSource="ZI_ACM_CONTRACT_VH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_PARTNERS" dataSource="ZI_PARTNERS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="Z_ADOC_MATERIAL_DESCRIPT_ZCOM" dataSource="Z_ADOC_MATERIAL_DESCRIPT_ZCOM" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |</sadl:resultSet>|  &
               |</sadl:definition>| .

   ro_model_exposure = cl_sadl_gw_model_exposure=>get_exposure_xml( iv_uuid      = CONV #( 'ZADOP_CREDIT_BLOCK' )
                                                                    iv_timestamp = co_gen_timestamp
                                                                    iv_sadl_xml  = lv_sadl_xml ).
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
ls_text_element-artifact_name          = 'Returnmessage'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                       "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'JsonComm'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'ETYP'.                                       "#EC NOTEXT
ls_text_element-text_symbol            = '001'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
  endmethod.
ENDCLASS.
