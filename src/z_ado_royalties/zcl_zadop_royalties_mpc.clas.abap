class ZCL_ZADOP_ROYALTIES_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  interfaces IF_SADL_GW_MODEL_EXPOSURE_DATA .

  types:
     TS_DISCHARGEQTY type ZADOS_ROYALTY_LOG .
  types:
TT_DISCHARGEQTY type standard table of TS_DISCHARGEQTY .
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
  begin of TS_JSONCOMM,
     ACTION type C length 20,
     PAYLOAD type string,
  end of TS_JSONCOMM .
  types:
TT_JSONCOMM type standard table of TS_JSONCOMM .
  types:
    begin of TS_ZADOC_COMERCIAL_CONTRACTTYP.
      include type ZADOC_COMERCIAL_CONTRACT.
  types:
    end of TS_ZADOC_COMERCIAL_CONTRACTTYP .
  types:
   TT_ZADOC_COMERCIAL_CONTRACTTYP type standard table of TS_ZADOC_COMERCIAL_CONTRACTTYP .
  types:
    begin of TS_ZADOC_CREDIT_BLOCK_BP_F4TYP.
      include type ZADOC_CREDIT_BLOCK_BP_F4.
  types:
    end of TS_ZADOC_CREDIT_BLOCK_BP_F4TYP .
  types:
   TT_ZADOC_CREDIT_BLOCK_BP_F4TYP type standard table of TS_ZADOC_CREDIT_BLOCK_BP_F4TYP .
  types:
    begin of TS_ZADOC_ROYALTIES_BALANCETYPE.
      include type ZADOC_ROYALTIES_BALANCE.
  types:
    end of TS_ZADOC_ROYALTIES_BALANCETYPE .
  types:
   TT_ZADOC_ROYALTIES_BALANCETYPE type standard table of TS_ZADOC_ROYALTIES_BALANCETYPE .
  types:
    begin of TS_ZADOC_ROYALTIES_BALANCE_CTY.
      include type ZADOC_ROYALTIES_BALANCE_C.
  types:
    end of TS_ZADOC_ROYALTIES_BALANCE_CTY .
  types:
   TT_ZADOC_ROYALTIES_BALANCE_CTY type standard table of TS_ZADOC_ROYALTIES_BALANCE_CTY .
  types:
    begin of TS_ZADOC_ROYALTIES_BALANCE_SUM.
      include type ZADOC_ROYALTIES_BALANCE_SUM.
  types:
    end of TS_ZADOC_ROYALTIES_BALANCE_SUM .
  types:
   TT_ZADOC_ROYALTIES_BALANCE_SUM type standard table of TS_ZADOC_ROYALTIES_BALANCE_SUM .
  types:
    begin of TS_ZADOC_ROYALTIES_CONTRACTSTY.
      include type ZADOC_ROYALTIES_CONTRACTS.
  types:
    end of TS_ZADOC_ROYALTIES_CONTRACTSTY .
  types:
   TT_ZADOC_ROYALTIES_CONTRACTSTY type standard table of TS_ZADOC_ROYALTIES_CONTRACTSTY .
  types:
    begin of TS_ZADOC_ROYALTIES_DISCHAR_REP.
      include type ZADOC_ROYALTIES_DISCHAR_REPORT.
  types:
    end of TS_ZADOC_ROYALTIES_DISCHAR_REP .
  types:
   TT_ZADOC_ROYALTIES_DISCHAR_REP type standard table of TS_ZADOC_ROYALTIES_DISCHAR_REP .
  types:
    begin of TS_ZADOC_ROYALTIES_LOGTYPE.
      include type ZADOC_ROYALTIES_LOG.
  types:
    end of TS_ZADOC_ROYALTIES_LOGTYPE .
  types:
   TT_ZADOC_ROYALTIES_LOGTYPE type standard table of TS_ZADOC_ROYALTIES_LOGTYPE .
  types:
    begin of TS_ZADOC_ROYALTIES_MONITORTYPE.
      include type ZADOC_ROYALTIES_MONITOR.
  types:
    end of TS_ZADOC_ROYALTIES_MONITORTYPE .
  types:
   TT_ZADOC_ROYALTIES_MONITORTYPE type standard table of TS_ZADOC_ROYALTIES_MONITORTYPE .
  types:
    begin of TS_ZADOC_ROYALTIES_PARTNERSTYP.
      include type ZADOC_ROYALTIES_PARTNERS.
  types:
    end of TS_ZADOC_ROYALTIES_PARTNERSTYP .
  types:
   TT_ZADOC_ROYALTIES_PARTNERSTYP type standard table of TS_ZADOC_ROYALTIES_PARTNERSTYP .

  constants GC_DISCHARGEQTY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'DischargeQty' ##NO_TEXT.
  constants GC_JSONCOMM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'JsonComm' ##NO_TEXT.
  constants GC_ZADOC_COMERCIAL_CONTRACTTYP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_COMERCIAL_CONTRACTType' ##NO_TEXT.
  constants GC_ZADOC_CREDIT_BLOCK_BP_F4TYP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_CREDIT_BLOCK_BP_F4Type' ##NO_TEXT.
  constants GC_ZADOC_ROYALTIES_BALANCETYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_ROYALTIES_BALANCEType' ##NO_TEXT.
  constants GC_ZADOC_ROYALTIES_BALANCE_CTY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_ROYALTIES_BALANCE_CType' ##NO_TEXT.
  constants GC_ZADOC_ROYALTIES_BALANCE_SUM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_ROYALTIES_BALANCE_SUMType' ##NO_TEXT.
  constants GC_ZADOC_ROYALTIES_CONTRACTSTY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_ROYALTIES_CONTRACTSType' ##NO_TEXT.
  constants GC_ZADOC_ROYALTIES_DISCHAR_REP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_ROYALTIES_DISCHAR_REPORTType' ##NO_TEXT.
  constants GC_ZADOC_ROYALTIES_LOGTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_ROYALTIES_LOGType' ##NO_TEXT.
  constants GC_ZADOC_ROYALTIES_MONITORTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_ROYALTIES_MONITORType' ##NO_TEXT.
  constants GC_ZADOC_ROYALTIES_PARTNERSTYP type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZADOC_ROYALTIES_PARTNERSType' ##NO_TEXT.

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

  methods DEFINE_DISCHARGEQTY
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
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



CLASS ZCL_ZADOP_ROYALTIES_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*

model->set_schema_namespace( 'ZADOP_ROYALTIES_SRV' ).

define_dischargeqty( ).
define_jsoncomm( ).
define_rds_4( ).
get_last_modified_rds_4( ).
  endmethod.


  method DEFINE_DISCHARGEQTY.
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
*   ENTITY - DischargeQty
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'DischargeQty' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'Plant' iv_abap_fieldname = 'PLANT' ). "#EC NOTEXT
lo_property->set_is_key( ).
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
lo_property = lo_entity_type->create_property( iv_property_name = 'Romaneio' iv_abap_fieldname = 'ROMANEIO' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 11 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Edcnumber' iv_abap_fieldname = 'EDCNUMBER' ). "#EC NOTEXT
lo_property->set_is_key( ).
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
lo_property = lo_entity_type->create_property( iv_property_name = 'Createdon' iv_abap_fieldname = 'CREATEDON' ). "#EC NOTEXT
lo_property->set_type_edm_datetime( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Discharge' iv_abap_fieldname = 'DISCHARGE' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 2 ). "#EC NOTEXT
lo_property->set_maxlength( iv_max_length = 31 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Fiscalyear' iv_abap_fieldname = 'FISCALYEAR' ). "#EC NOTEXT
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
lo_property = lo_entity_type->create_property( iv_property_name = 'Balance' iv_abap_fieldname = 'BALANCE' ). "#EC NOTEXT
lo_property->set_type_edm_decimal( ).
lo_property->set_precison( iv_precision = 2 ). "#EC NOTEXT
lo_property->set_maxlength( iv_max_length = 31 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Dischargestatus' iv_abap_fieldname = 'DISCHARGESTATUS' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 24 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Operation' iv_abap_fieldname = 'OPERATION' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 1 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Protocol' iv_abap_fieldname = 'PROTOCOL' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 20 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).

lo_entity_type->bind_structure( iv_structure_name   = 'ZADOS_ROYALTY_LOG'
                                iv_bind_conversions = 'X' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'DischargeQtySet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_true ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
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
lo_property->set_maxlength( iv_max_length = 20 ). "#EC NOTEXT
lo_property->set_creatable( abap_true ).
lo_property->set_updatable( abap_true ).
lo_property->set_sortable( abap_true ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_true ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Payload' iv_abap_fieldname = 'PAYLOAD' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_true ).
lo_property->set_updatable( abap_true ).
lo_property->set_sortable( abap_true ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_true ).
lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      EXPORTING
        iv_key      = 'unicode'
        iv_value    = 'false' ).

lo_entity_type->bind_structure( iv_structure_name  = 'ZCL_ZADOP_ROYALTIES_MPC=>TS_JSONCOMM' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'JsonCommSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_false ).
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


  CONSTANTS: lc_gen_date_time TYPE timestamp VALUE '20230428205034'.                  "#EC NOTEXT
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
    CONSTANTS: co_gen_date_time TYPE timestamp VALUE '20230428205034'.
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
    CONSTANTS: co_gen_timestamp TYPE timestamp VALUE '20230428205034'.
    DATA(lv_sadl_xml) =
               |<?xml version="1.0" encoding="utf-16"?>|  &
               |<sadl:definition xmlns:sadl="http://sap.com/sap.nw.f.sadl" syntaxVersion="V2" >|  &
               | <sadl:dataSource type="CDS" name="ZADOC_COMERCIAL_CONTRACT" binding="ZADOC_COMERCIAL_CONTRACT" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_CREDIT_BLOCK_BP_F4" binding="ZADOC_CREDIT_BLOCK_BP_F4" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_ROYALTIES_BALANCE" binding="ZADOC_ROYALTIES_BALANCE" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_ROYALTIES_BALANCE_C" binding="ZADOC_ROYALTIES_BALANCE_C" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_ROYALTIES_BALANCE_SUM" binding="ZADOC_ROYALTIES_BALANCE_SUM" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_ROYALTIES_CONTRACTS" binding="ZADOC_ROYALTIES_CONTRACTS" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_ROYALTIES_DISCHAR_REPORT" binding="ZADOC_ROYALTIES_DISCHAR_REPORT" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_ROYALTIES_LOG" binding="ZADOC_ROYALTIES_LOG" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_ROYALTIES_MONITOR" binding="ZADOC_ROYALTIES_MONITOR" />|  &
               | <sadl:dataSource type="CDS" name="ZADOC_ROYALTIES_PARTNERS" binding="ZADOC_ROYALTIES_PARTNERS" />|  &
               |<sadl:resultSet>|  &
               |<sadl:structure name="ZADOC_COMERCIAL_CONTRACT" dataSource="ZADOC_COMERCIAL_CONTRACT" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_CREDIT_BLOCK_BP_F4" dataSource="ZADOC_CREDIT_BLOCK_BP_F4" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_ROYALTIES_BALANCE" dataSource="ZADOC_ROYALTIES_BALANCE" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_ROYALTIES_BALANCE_C" dataSource="ZADOC_ROYALTIES_BALANCE_C" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_ROYALTIES_BALANCE_SUM" dataSource="ZADOC_ROYALTIES_BALANCE_SUM" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_ROYALTIES_CONTRACTS" dataSource="ZADOC_ROYALTIES_CONTRACTS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_ROYALTIES_DISCHAR_REPORT" dataSource="ZADOC_ROYALTIES_DISCHAR_REPORT" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_ROYALTIES_LOG" dataSource="ZADOC_ROYALTIES_LOG" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZADOC_ROYALTIES_MONITOR" dataSource="ZADOC_ROYALTIES_MONITOR" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_ROYALTIESLOG" binding="_ROYALTIESLOG" target="ZADOC_ROYALTIES_LOG" cardinality="zeroToMany" />|  &
               |</sadl:structure>| .
      lv_sadl_xml = |{ lv_sadl_xml }| &
               |<sadl:structure name="ZADOC_ROYALTIES_PARTNERS" dataSource="ZADOC_ROYALTIES_PARTNERS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |</sadl:resultSet>|  &
               |</sadl:definition>| .

   ro_model_exposure = cl_sadl_gw_model_exposure=>get_exposure_xml( iv_uuid      = CONV #( 'ZADOP_ROYALTIES' )
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
  endmethod.
ENDCLASS.
