*- SAP------------------------------------------------------------SAP -*
*-           *** Adopi - Compensação de Liquidações ***               -*
*- SAP------------------------------------------------------------SAP -*
************************************************************************
* Projeto:
* Modulo / Componente:
*
* Report: zador_grains_settlement_clear
* Descrição: Executar a compensação de liquidações de fixações
*
* Modo Execução: [X] Background * [X] Online
*
************************************************************************
* Autor: Luiz Zanella                                   Data: 29/03/2023
*
************************************************************************
* Modificações:
*
************************************************************************
REPORT zador_grains_settlement_clear.

TABLES: zadocgrainscais.

CONSTANTS: structure_name TYPE tabname VALUE 'ZADOS_GRAINS_SETTLEMENT_CLEAR'.

DATA: output TYPE TABLE OF zados_grains_settlement_clear.

DATA: ok_code           TYPE sy-ucomm,
      alv_grid          TYPE REF TO cl_gui_alv_grid,
      docking_container TYPE REF TO cl_gui_docking_container,
      fieldcatalog      TYPE lvc_t_fcat,
      sort              TYPE lvc_t_sort,
      variant           TYPE disvariant.




SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001. "Opções de Seleção

  SELECT-OPTIONS: s_tkonn FOR zadocgrainscais-TradingContract,
                  s_tctyp FOR zadocgrainscais-TradingContractType,
                  s_bukrs FOR zadocgrainscais-InvoiceCompanyCode,
                  s_lifnr FOR zadocgrainscais-InvoicePartner,
                  s_re_bel FOR zadocgrainscais-InvoiceDoc,
                  s_re_ghj FOR zadocgrainscais-InvoiceDocYear.


SELECTION-SCREEN END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002. "Opções de Seleção

  PARAMETERS: p_open  RADIOBUTTON GROUP gr1 DEFAULT 'X',
              p_clear RADIOBUTTON GROUP gr1,
              p_all   RADIOBUTTON GROUP gr1.


SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-006. "Modo de execução

  PARAMETERS: p_mode TYPE allgazmd AS LISTBOX VISIBLE LENGTH 20 DEFAULT 'N' OBLIGATORY,
              p_test AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK b3.


SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-003. "Layout

  PARAMETERS: p_layout LIKE disvariant-variant.

SELECTION-SCREEN END OF BLOCK b4.


AT SELECTION-SCREEN OUTPUT.

  DATA(mode_list) = VALUE vrm_values( ( key = 'A' text = 'Exibir todas telas' )
                                      ( key = 'N' text = 'Sem exibição' )
                                      ( key = 'E' text = 'Exibir apenas erros' ) ).

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'P_MODE'
      values          = mode_list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.
  PERFORM: get_layout.


START-OF-SELECTION.

  PERFORM get_data.

END-OF-SELECTION.


  IF output IS NOT INITIAL.

    IF sy-batch = abap_true.
      PERFORM execute_background.
    ENDIF.

    CALL SCREEN 9001.

  ELSE.
    MESSAGE s064(ab). "Não foram selecionados dados.
  ENDIF.


*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data.

  DATA acc_status_range TYPE RANGE OF zadode_grains_acc_status.

  IF p_open = abap_true.
    acc_status_range = VALUE #( ( sign = 'I'  option = 'EQ'  low = 'OPEN'     ) ).

  ELSEIF p_clear = abap_true.
    acc_status_range = VALUE #( ( sign = 'I'  option = 'EQ'  low = 'CLEARING' ) ).

  ELSE.
    CLEAR acc_status_range.

  ENDIF.

  SELECT * FROM zadoc_grains_ctr_app_inv_sd WHERE TradingContract          IN @s_tkonn
                                              AND TradingContractType      IN @s_tctyp
                                              AND InvoiceCompanyCode       IN @s_bukrs
                                              AND InvoicePartner           IN @s_lifnr
                                              AND InvoiceDoc               IN @s_re_bel
                                              AND InvoiceDocYear           IN @s_re_ghj
                                              AND AccountingDocumentStatus IN @acc_status_range
                                             INTO CORRESPONDING FIELDS OF TABLE @output.

ENDFORM.



*&---------------------------------------------------------------------*
*& Form build_fieldcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fieldcat.

  CLEAR fieldcatalog.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = structure_name
    CHANGING
      ct_fieldcat            = fieldcatalog
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form build_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_sort.

  CLEAR sort.
  sort = VALUE lvc_t_sort( ( spos = 1   fieldname = 'TRADINGCONTRACT'      up = abap_true )
                           ( spos = 2   fieldname = 'ABDNUMBER'            up = abap_true ) ).

ENDFORM.


*&---------------------------------------------------------------------*
*& Form refresh_alv_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_alv_display.

  alv_grid->get_scroll_info_via_id( IMPORTING es_row_no   = DATA(es_row_no)
                                              es_row_info = DATA(es_row_info)
                                              es_col_info = DATA(es_col_info) ).

  PERFORM get_data.

  alv_grid->refresh_table_display( ).

  alv_grid->set_scroll_info_via_id( EXPORTING is_row_info = es_row_info
                                              is_col_info = es_col_info
                                              is_row_no   = es_row_no ).

ENDFORM.


*&---------------------------------------------------------------------*
*& Form execute
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM execute.

  alv_grid->get_selected_rows( IMPORTING  et_index_rows = DATA(rows) ).


  LOOP AT rows INTO DATA(row).

    TRY.
        ASSIGN output[ row-index ] TO FIELD-SYMBOL(<workarea>).
      CATCH cx_sy_itab_line_not_found.
        CONTINUE.
    ENDTRY.

    IF NOT <workarea>-accountingdocumentstatus = 'OPEN'.
      <workarea>-status  = icon_warning.
      <workarea>-message = TEXT-004. "Documento já está compensado
      CONTINUE.
    ENDIF.

    DATA(clear_return) = NEW zadocl_grains_clear_fix_acc( contract_num = <workarea>-tradingcontract
                                                          invoice      = <workarea>-invoicedoc
                                                          mode         = p_mode
                                                          test_run     = p_test )->execute_clearing( ).


    <workarea>-status      = COND #( WHEN line_exists( clear_return[ type = 'E' ] ) THEN icon_incomplete ELSE icon_checked ).
    <workarea>-executed_on = zadocl_grains_utilities=>get_timestamp( ).
    <workarea>-executed_by = sy-uname.

    LOOP AT clear_return INTO DATA(line_return).

      IF <workarea>-message IS INITIAL.
        <workarea>-message = line_return-message.
      ELSE.
        <workarea>-message = |{ <workarea>-message } / { line_return-message }|.
      ENDIF.

    ENDLOOP.

  ENDLOOP.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form execute_background
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM execute_background.

  LOOP AT output  ASSIGNING FIELD-SYMBOL(<workarea>).

    IF NOT <workarea>-accountingdocumentstatus = 'OPEN'.
      <workarea>-status  = icon_warning.
      <workarea>-message = TEXT-004. "Documento já está compensado
      CONTINUE.
    ENDIF.

    DATA(clear_return) = NEW zadocl_grains_clear_fix_acc( contract_num = <workarea>-tradingcontract
                                                          invoice      = <workarea>-invoicedoc )->execute_clearing( ).


    <workarea>-status      = COND #( WHEN line_exists( clear_return[ type = 'E' ] ) THEN icon_incomplete ELSE icon_checked ).
    <workarea>-executed_on = zadocl_grains_utilities=>get_timestamp( ).
    <workarea>-executed_by = sy-uname.

    LOOP AT clear_return INTO DATA(line_return).

      MESSAGE line_return-message TYPE line_return-type.

      IF <workarea>-message IS INITIAL.
        <workarea>-message = line_return-message.
      ELSE.
        <workarea>-message = |{ <workarea>-message } / { line_return-message }|.
      ENDIF.

    ENDLOOP.

  ENDLOOP.


ENDFORM.



*&---------------------------------------------------------------------*
*& Form revert_acc_clear
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM revert_acc_clear.


  alv_grid->get_selected_rows( IMPORTING  et_index_rows = DATA(rows) ).


  LOOP AT rows INTO DATA(row).

    TRY.
        ASSIGN output[ row-index ] TO FIELD-SYMBOL(<workarea>).
      CATCH cx_sy_itab_line_not_found.
        CONTINUE.
    ENDTRY.

    IF NOT <workarea>-accountingdocumentstatus = 'CLEARING'.
      <workarea>-status  = icon_warning.
      <workarea>-message =  TEXT-005. "Documento de compensação não encontrado.
      CONTINUE.
    ENDIF.

    DATA(revert_return) = NEW zadocl_grains_acc_clr_reverse( VALUE #( ( company_code  = <workarea>-invoicecompanycode
                                                                        clearing_doc  = <workarea>-clearingdocument
                                                                        clearing_year = <workarea>-clearingdocumentyear
                                                                        mode          = 'N' ) ) )->execute( ).


    <workarea>-status      = COND #( WHEN line_exists( revert_return[ type = 'E' ] ) THEN icon_incomplete ELSE icon_checked ).
    <workarea>-executed_on = zadocl_grains_utilities=>get_timestamp( ).
    <workarea>-executed_by = sy-uname.


    LOOP AT revert_return INTO DATA(line_return).

      IF <workarea>-message IS INITIAL.
        <workarea>-message = line_return-message.
      ELSE.
        <workarea>-message = |{ <workarea>-message } / { line_return-message }|.
      ENDIF.

    ENDLOOP.

  ENDLOOP.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_layout.

  CLEAR: variant.

  variant-report = sy-repid.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant         = variant
      i_save             = 'A'
      i_display_via_grid = abap_true
    IMPORTING
      es_variant         = variant
    EXCEPTIONS
      not_found          = 2.

  IF sy-subrc = 0.
    p_layout = variant-variant.
  ELSE.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      CLEAR ok_code.
      SET SCREEN 0.
    WHEN 'REFRESH'.
      CLEAR ok_code.
      PERFORM refresh_alv_display.
    WHEN 'EXECUTE'.
      PERFORM execute.
    WHEN 'REVERT_ACC'.
      PERFORM revert_acc_clear.
  ENDCASE.

ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_9001 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_9001 OUTPUT.
  SET PF-STATUS 'PF9001'.
  SET TITLEBAR  'T9001'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module BUILD_ALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE build_alv OUTPUT.

  IF alv_grid IS INITIAL.

*    docking_container = NEW cl_gui_docking_container( extension = '2500' ).
*    alv_grid          = NEW cl_gui_alv_grid( i_parent = docking_container ).

    alv_grid = NEW cl_gui_alv_grid( i_parent = cl_gui_container=>default_screen ).

    DATA(layout) = VALUE lvc_s_layo( cwidth_opt = abap_true
                                     zebra      = abap_true
                                     sel_mode   = 'A' ).

    variant = VALUE disvariant( report   = sy-repid
                                username = sy-uname
                                variant  = p_layout ).

    PERFORM build_sort.
    PERFORM build_fieldcat .

    alv_grid->set_table_for_first_display(
      EXPORTING
*       i_structure_name = 'zrdwcpds0001'
        is_layout       = layout
        i_save          = 'A'
        is_variant      = variant
      CHANGING
        it_fieldcatalog = fieldcatalog
        it_outtab       = output
        it_sort         = sort ).

  ELSE.

    alv_grid->set_frontend_layout( is_layout = layout ).
    alv_grid->refresh_table_display( ).

  ENDIF.

ENDMODULE.
