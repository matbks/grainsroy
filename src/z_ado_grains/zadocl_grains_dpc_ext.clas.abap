CLASS zadocl_grains_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zadocl_grains_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .
  PROTECTED SECTION.

    METHODS accountingdocume_get_entityset
        REDEFINITION .
    METHODS jsoncommunicatio_create_entity
        REDEFINITION .
    METHODS zadoc_grains_edc_get_entityset
        REDEFINITION .
    METHODS zadoc_grains_use_get_entityset
        REDEFINITION .
  PRIVATE SECTION.

    METHODS send_logs_to_front
      IMPORTING
        entity_type TYPE string
        msgs        TYPE bapiret2_t.


ENDCLASS.

CLASS zadocl_grains_dpc_ext IMPLEMENTATION.

  METHOD jsoncommunicatio_create_entity.

    DATA: return_msgs TYPE bapiret2_t.

    FIELD-SYMBOLS: <output_data> TYPE ANY TABLE.

    io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

    DATA(ref_data) = zadocl_grains_convert_json=>convert( json           = er_entity-json
                                                          structure_name = er_entity-structure_name
                                                          table          = abap_true ).

    ASSIGN ref_data->* TO <output_data>.


    CHECK <output_data> IS ASSIGNED.
    CHECK <output_data> IS NOT INITIAL.


    CASE er_entity-action.

      WHEN 'SETSTATUS'.

        return_msgs = NEW zadocl_grains_set_contr_status( <output_data> )->set_status( ).

      WHEN 'FIXCREATE'.

        return_msgs = NEW zadocl_grains_send_fixation( <output_data> )->execute( ).

      WHEN 'FIXSETSTAT'.

        return_msgs = NEW zadocl_grains_set_fix_status( <output_data> )->set_status( ).

      WHEN 'DATEVALID'.

        return_msgs = NEW zadocl_grains_payment_validate( <output_data> )->validate( ).

        IF line_exists( return_msgs[ type = 'E' ] ).
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = mo_context->get_message_container( ).
        ENDIF.

      WHEN 'GETLASTBLOCK'.


      WHEN 'SETDISCHARGE'.

      WHEN 'MSG'.
        return_msgs = VALUE #( ( id = 'ZADO_GRAINS' number = 17 type = 'E' )
                               ( id = 'ZADO_GRAINS' number = 18 type = 'E' )
                               ( id = 'ZADO_GRAINS' number = 19 type = 'S' )
                               ( id = 'ZADO_GRAINS' number = 20 type = 'S' ) ).


      WHEN 'ACC_CLEAR'.

        return_msgs = NEW zadocl_grains_ms_clear_fix_acc( settlements_to_clear = <output_data> )->execute( ).


      WHEN 'CLEAR_REV'.

        return_msgs = NEW zadocl_grains_acc_clr_reverse( clearing_docs = <output_data> )->execute( ).

      WHEN 'LIQUIDATE'.

        return_msgs = NEW zadocl_grains_fix_liquidate( fixation_data = <output_data> )->execute( ).

      WHEN 'SALESFIX'.

        return_msgs = NEW zadocl_grains_sales_fix_create( new_fixation = <output_data> )->execute( ).


      WHEN 'CHECK_AUTH'.

        return_msgs = NEW zadocl_grains_auth_validation( auth_data = <output_data> )->validate( ).


        IF line_exists( return_msgs[ type = 'E' ] ).

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = mo_context->get_message_container( ).
        ENDIF.


      WHEN 'INVOICEPST'.

        return_msgs = NEW zadocl_grains_m_invoice_adjust( <output_data> )->execute( ).

        IF line_exists( return_msgs[ type = 'E' ] ).

          me->send_logs_to_front( entity_type = iv_entity_name
                                  msgs        = return_msgs ).

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = mo_context->get_message_container( ).
        ENDIF.

      WHEN OTHERS.

    ENDCASE.

    me->send_logs_to_front( entity_type = iv_entity_name
                            msgs        = return_msgs ).

    IF line_exists( return_msgs[ type = 'E' ] ).
      er_entity-success = abap_true.
    ENDIF.

*    IF line_exists( return_msgs[ type = 'E' ] ).
*      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*        EXPORTING
*          message_container = mo_context->get_message_container( ).
*    ENDIF.


  ENDMETHOD.


  METHOD send_logs_to_front.

    DATA(distinc_msgs) = msgs.

    SORT distinc_msgs BY type number message_v1.
    DELETE ADJACENT DUPLICATES FROM distinc_msgs COMPARING type number message_v1.

    LOOP AT distinc_msgs INTO DATA(msg).

      me->mo_context->get_message_container( )->add_message_from_bapi(
        EXPORTING
          is_bapi_message           = msg
          iv_entity_type            = entity_type
          iv_add_to_response_header = abap_true
          iv_message_target         = CONV string( msg-field ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD zadoc_grains_use_get_entityset.

    SELECT * FROM zadoc_grains_user_info WHERE Username = @sy-uname INTO TABLE @et_entityset.

  ENDMETHOD.


  METHOD accountingdocume_get_entityset.

    TRY.
        DATA(company_code)             = CONV bukrs( it_filter_select_options[   property = 'CompanyCode'            ]-select_options[ 1 ]-low ).
      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.

    TRY.
        DATA(accounting_document)      = CONV belnr_d( it_filter_select_options[ property = 'AccountingDocument'     ]-select_options[ 1 ]-low ).
      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.

    TRY.
        DATA(accounting_document_year) = CONV gjahr( it_filter_select_options[   property = 'AccountingDocumentYear' ]-select_options[ 1 ]-low ).
      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.

    TRY.
        DATA(accounting_item)          = CONV buzei( it_filter_select_options[   property = 'AccountingItem'         ]-select_options[ 1 ]-low ).
      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.

    et_entityset = NEW zadocl_grains_get_acc_tree( company_code             = company_code
                                                   accounting_document      = accounting_document
                                                   accounting_document_year = accounting_document_year
                                                   accounting_item          = accounting_item )->get_entityset_data( ).

  ENDMETHOD.


  METHOD zadoc_grains_edc_get_entityset.
    TRY.
        CALL METHOD super->zadoc_grains_edc_get_entityset
          EXPORTING
            iv_entity_name           = iv_entity_name
            iv_entity_set_name       = iv_entity_set_name
            iv_source_name           = iv_source_name
            it_filter_select_options = it_filter_select_options
            is_paging                = is_paging
            it_key_tab               = it_key_tab
            it_navigation_path       = it_navigation_path
            it_order                 = it_order
            iv_filter_string         = iv_filter_string
            iv_search_string         = iv_search_string
            io_tech_request_context  = io_tech_request_context
          IMPORTING
            et_entityset             = et_entityset
            es_response_context      = es_response_context.
      CATCH /iwbep/cx_mgw_busi_exception.
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.
    SORT et_entityset BY applicationdocnum.
    DELETE ADJACENT DUPLICATES FROM et_entityset COMPARING applicationdocnum.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
    DATA(keys) = io_tech_request_context->get_keys( ).

    DATA: device_type          TYPE rspoptype,
          function_name        TYPE rs38l_fnam,
          output_data          TYPE ssfcrescl,
          user_print_parameter TYPE usr01,
          tstotf               TYPE tsfotf,
          lines                TYPE TABLE OF tline,
          pdf_len              TYPE i,
          pdf_xstring          TYPE xstring.

    TRY.
        DATA(form_name)   = VALUE tdsfname( keys[ name = 'FORM_NAME' ]-value ).
        DATA(form_params) = keys[ name = 'FORM_PARAMS' ]-value.
      CATCH cx_sy_itab_line_not_found.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid            = /iwbep/cx_mgw_busi_exception=>business_error_unlimited
            message_unlimited = 'Form ID not Found'.
    ENDTRY.

    DATA: params TYPE zados_grains_sf_params.

    IF form_name IS NOT INITIAL AND form_params IS NOT INITIAL.
      CASE form_name.
        WHEN 'ZADOSF_GRAINS_BOL_FIX'.

          cl_fdt_json=>json_to_data( EXPORTING iv_json = form_params
                                     CHANGING  ca_data = params ).
          CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
            EXPORTING
              formname           = form_name
            IMPORTING
              fm_name            = function_name
            EXCEPTIONS
              no_form            = 1
              no_function_module = 2.

          IF sy-subrc = 0.
            DATA(composer_parameter) = VALUE ssfcompop( tdnewid   = abap_true
                                                        tdarmod   = '1'
                                                        tdimmed   = abap_true
                                                        tdfinal   = abap_true
                                                        tddest    = 'LP01'
                                                        tdnoprint = space ).

            DATA(control_parameter) = VALUE ssfctrlop( no_dialog = abap_true
                                                       preview   = space
                                                       langu     = sy-langu
                                                       getotf    = 'X'  ).
            CALL FUNCTION function_name
              EXPORTING
                control_parameters = control_parameter
                output_options     = composer_parameter
                user_settings      = space
                params             = params
              IMPORTING
                job_output_info    = output_data
              EXCEPTIONS
                formatting_error   = 1
                internal_error     = 2
                send_error         = 3
                user_canceled      = 4
                OTHERS             = 5.

            APPEND LINES OF output_data-otfdata TO tstotf.
            CHECK tstotf IS NOT INITIAL.

            CALL FUNCTION 'CONVERT_OTF'
              EXPORTING
                format                = 'PDF'
              IMPORTING
                bin_filesize          = pdf_len
                bin_file              = pdf_xstring
              TABLES
                otf                   = tstotf
                lines                 = lines
              EXCEPTIONS
                err_max_linewidth     = 1
                err_format            = 2
                err_conv_not_possible = 3
                err_bad_otf           = 4
                OTHERS                = 5.

            IF sy-subrc = 0.
              DATA(stream) = VALUE ty_s_media_resource( mime_type = 'application/pdf'
                                                        value     = pdf_xstring ).

              set_header( is_header = VALUE #( name = 'Content-Disposition' value = 'inline; filename=' ) ).

              copy_data_to_ref( EXPORTING is_data = stream
                                CHANGING  cr_data = er_stream ).
            ENDIF.
          ENDIF.

        WHEN 'ZADOSF_GRAINS_BOL_FIX_SELL'.

          cl_fdt_json=>json_to_data( EXPORTING iv_json = form_params
                                     CHANGING  ca_data = params ).
          CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
            EXPORTING
              formname           = form_name
            IMPORTING
              fm_name            = function_name
            EXCEPTIONS
              no_form            = 1
              no_function_module = 2.

          IF sy-subrc = 0.
            composer_parameter = VALUE ssfcompop( tdnewid   = abap_true
                                                  tdarmod   = '1'
                                                  tdimmed   = abap_true
                                                  tdfinal   = abap_true
                                                  tddest    = 'LP01'
                                                  tdnoprint = space ).

            control_parameter = VALUE ssfctrlop( no_dialog = abap_true
                                                 preview   = space
                                                 langu     = sy-langu
                                                 getotf    = 'X'  ).
            CALL FUNCTION function_name
              EXPORTING
                control_parameters = control_parameter
                output_options     = composer_parameter
                user_settings      = space
                params             = params
              IMPORTING
                job_output_info    = output_data
              EXCEPTIONS
                formatting_error   = 1
                internal_error     = 2
                send_error         = 3
                user_canceled      = 4
                OTHERS             = 5.

            APPEND LINES OF output_data-otfdata TO tstotf.
            CHECK tstotf IS NOT INITIAL.

            CALL FUNCTION 'CONVERT_OTF'
              EXPORTING
                format                = 'PDF'
              IMPORTING
                bin_filesize          = pdf_len
                bin_file              = pdf_xstring
              TABLES
                otf                   = tstotf
                lines                 = lines
              EXCEPTIONS
                err_max_linewidth     = 1
                err_format            = 2
                err_conv_not_possible = 3
                err_bad_otf           = 4
                OTHERS                = 5.

            IF sy-subrc = 0.
              stream = VALUE ty_s_media_resource( mime_type = 'application/pdf'
                                                  value     = pdf_xstring ).

              set_header( is_header = VALUE #( name = 'Content-Disposition' value = 'inline; filename=' ) ).

              copy_data_to_ref( EXPORTING is_data = stream
                                CHANGING  cr_data = er_stream ).
            ENDIF.
          ENDIF.

        WHEN OTHERS.

      ENDCASE.

    ENDIF.


  ENDMETHOD.
ENDCLASS.
