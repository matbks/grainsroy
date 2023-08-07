CLASS zadocl_grains_royalt_invoices DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: fixation_data          TYPE zados_grains_create_fixation,
          fixation_header        TYPE zadoc_grains_fixation_data,
          account_configurations TYPE zadot_grains_020,
          log                    TYPE bapiret2_tt.

    METHODS constructor
      IMPORTING fixation_data TYPE zadott_grains_create_fixation.

    METHODS execute
      RETURNING VALUE(return) TYPE bapiret2_tt.

  PRIVATE SECTION.
    METHODS get_data.

    METHODS simulate
      RETURNING VALUE(return) TYPE zadode_grains_amount.

    METHODS invoice_create
      IMPORTING amount TYPE zadode_grains_amount.

ENDCLASS.

CLASS zadocl_grains_royalt_invoices IMPLEMENTATION.
  METHOD constructor.
    TRY.
        me->fixation_data = fixation_data[ 1 ].
      CATCH cx_sy_itab_line_not_found.
        APPEND VALUE #( type = 'E' number = 026 id = 'ZADO_GRAINS'  ) TO me->log. "Não foram encontrados dados para fixação.
    ENDTRY.
  ENDMETHOD.

  METHOD execute.
    me->get_data(  ).

    me->invoice_create( me->simulate( ) ).

    return = me->log.
  ENDMETHOD.

  METHOD get_data.
    CHECK NOT line_exists( me->log[ type = 'E' ] ).

    SELECT SINGLE * FROM zadoc_grains_fixation_data INTO @fixation_header WHERE contractnum = @me->fixation_data-contract
                                                                      AND IdentificationFix = @me->fixation_data-identification.
    IF sy-subrc <> 0.
      APPEND VALUE #( type = 'E' number = 026 id = 'ZADO_GRAINS'  ) TO me->log. "Não foram encontrados dados para fixação.
    ENDIF.

    SELECT SINGLE * FROM zadot_grains_020 INTO me->account_configurations WHERE company_code = me->fixation_header-CompanyCode
                                                                            AND commodity = me->fixation_header-MaterialNum
                                                                            AND app_code = 'ACMCONTROL'.
    IF sy-subrc <> 0.
      APPEND VALUE #( type = 'E' number = 026 id = 'ZADO_GRAINS'  ) TO me->log. "Não foram encontrados dados para fixação.
    ENDIF.
  ENDMETHOD.

  METHOD simulate.
    CHECK NOT line_exists( me->log[ type = 'E' ] ).

    IF me->fixation_header-bagprice = 0.
      APPEND VALUE #( type = 'E' number = 026 id = 'ZADO_GRAINS'  ) TO me->log. "Preço inválido
      RETURN.
    ENDIF.

    DATA(price) = CONV float( me->fixation_header-bagprice / 60 ).

    return = price * me->fixation_header-BlockedQuantity.

  ENDMETHOD.

  METHOD invoice_create.

    DATA: documentheader TYPE bapiache09,
          accountgl      TYPE TABLE OF bapiacgl09,
          currencyamount TYPE TABLE OF bapiaccr09,
          return         TYPE STANDARD TABLE OF bapiret2,
          obj_type       TYPE awtyp,
          obj_key        TYPE awkey,
          obj_sys        TYPE awsys.

    CHECK amount > 0.

    documentheader = VALUE #( comp_code = me->fixation_header-CompanyCode doc_date = sy-datum pstng_date = sy-datum
                              doc_type = 'KR'  ref_doc_no = me->fixation_header-ContractNum ).

    accountgl = VALUE #( (  itemno_acc = '002' gl_account = me->account_configurations-transitory_account acct_type = 'S' profit_ctr = me->account_configurations-profit_center  ) ).

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
      EXPORTING
        documentheader = documentheader
      IMPORTING
        obj_type       = obj_type
        obj_key        = obj_key
        obj_sys        = obj_sys
      TABLES
        accountgl      = accountgl
        currencyamount = currencyamount
        return         = return.

    IF line_exists( return[ type = 'E' ] ).
      APPEND VALUE #( type = 'E' number = 026 id = 'ZADO_GRAINS'  ) TO me->log. "Falha ao realizar o lançamento
    ENDIF.

  ENDMETHOD.

ENDCLASS.
