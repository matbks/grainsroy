CLASS zadocl_grains_invoice_adjust DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING settlement_group_id TYPE /accgo/e_stl_ctnr_id
                settlement_doc_year TYPE /accgo/e_settl_yr.

    METHODS execute
      RETURNING VALUE(return) TYPE bapiret2_t.

  PRIVATE SECTION.

    DATA: settlement_group_id TYPE /accgo/e_stl_ctnr_id,
          settlement_doc_year TYPE /accgo/e_settl_yr,
          logs                TYPE bapiret2_t.

    DATA: fixation_header TYPE zadot_grains_fix,
          invoice_data    TYPE zadoi_grains_contract_invoices,
          lipre_settings  TYPE ztbacm_edc_aut02.

    DATA: headerdata_change          TYPE bapi_incinv_chng_header,
          headerdata_changex         TYPE bapi_incinv_chng_headerx,
          table_change               TYPE bapi_incinv_chng_tables,
          vendoritemsplitdata_change TYPE TABLE OF bapi_incinv_create_vendorsplit.

    METHODS setup.

    METHODS get_data.
    METHODS map_data.

    METHODS save_invoice_doc.
    METHODS save_acc_doc.
    METHODS execute_clearing.

    METHODS invoice_change.


ENDCLASS.



CLASS zadocl_grains_invoice_adjust IMPLEMENTATION.

  METHOD constructor.

    me->settlement_group_id = settlement_group_id.
    me->settlement_doc_year = settlement_doc_year.

    me->setup( ).

  ENDMETHOD.


  METHOD setup.

    me->get_data( ).
    me->save_invoice_doc( ).
    me->map_data( ).

  ENDMETHOD.


  METHOD execute.


    me->invoice_change( ).


    return = me->logs.

  ENDMETHOD.


  METHOD get_data.

    CLEAR me->fixation_header.
    SELECT SINGLE * FROM zadot_grains_fix WHERE settlement_group_id = @me->settlement_group_id
                                            AND settlement_year     = @me->settlement_doc_year
                                           INTO @me->fixation_header.

    DO 8 TIMES .
      CLEAR me->invoice_data.
      SELECT SINGLE * FROM zadoi_grains_contract_invoices WHERE SettlementGroupId   = @me->settlement_group_id
                                                            AND SettlementGroupYear = @me->settlement_doc_year
                                                            AND invoicedoctype      = 'SD' "Invoice de complemento
                                                            AND InvoiceDoc          IS NOT INITIAL
                                                           INTO @me->invoice_data.

      IF sy-subrc = 0.
        EXIT.
      ENDIF.
      WAIT UP TO 1 SECONDS.
    ENDDO.

    IF me->invoice_data IS INITIAL.

      DATA(message_v1) = CONV syst_msgv( |{ me->settlement_group_id }/{ me->settlement_doc_year }| ).

      APPEND zadocl_grains_utilities=>get_msg( type = 'E'  id = 'ZADO_GRAINS'   number = '044'   var1 = message_v1 ) TO me->logs.  "Não foi possível encontrar fatura para o grupo de liquidação &1.

      RETURN.

    ENDIF.

    IF sy-subrc = 0.


      SELECT SINGLE * FROM zadoi_grains_contract_invoices WHERE ApplicationDoc     = @me->invoice_data-ApplicationDoc
                                                            AND ApplicationDocItem = @me->invoice_data-ApplicationDocItem
                                                            AND invoicedoctype     = 'IV' "Invoice da primeira aplicação
                                                           INTO @DATA(first_aplication_inv).

      IF sy-subrc = 0.

        SELECT SINGLE * FROM rbkp WHERE belnr = @first_aplication_inv-InvoiceDoc
                                    AND gjahr = @first_aplication_inv-InvoiceDocYear
                                   INTO @DATA(predecessor_invoice). "MIRO da primeira aplicação

        IF sy-subrc = 0.

          SELECT SINGLE * FROM ztbacm_edc_aut02 WHERE nftype = @predecessor_invoice-j_1bnftype
                                                  AND type   = '01'
                                                 INTO @DATA(normal_lipre). "Lipre da primeira aplicação

          IF sy-subrc = 0.

            SELECT SINGLE * FROM ztbacm_edc_aut02 WHERE lipre = @normal_lipre-lipre
                                                    AND type  = '03'
                                                   INTO @me->lipre_settings. "Lipre da invoice de complemento

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.




  ENDMETHOD.



  METHOD map_data.


    DATA: headerdata          TYPE bapi_incinv_detail_header,
          itemdata            TYPE STANDARD TABLE OF bapi_incinv_detail_item,
          materialdata        TYPE  TABLE OF bapi_incinv_detail_material,
          taxdata             TYPE STANDARD TABLE OF bapi_incinv_detail_tax,
          vendoritemsplitdata TYPE STANDARD TABLE OF bapi_incinv_detail_vendorsplit,
          withtaxdata         TYPE TABLE OF bapi_incinv_detail_withtax,
          bapi_return         TYPE TABLE OF bapiret2.

    DATA: gross_amount       TYPE bapi_rmwwr,
          split_total_amount TYPE bapi_rmwwr.

    CHECK NOT line_exists( me->logs[ type = 'E' ] ).

    CALL FUNCTION 'BAPI_INCOMINGINVOICE_GETDETAIL'
      EXPORTING
        invoicedocnumber    = me->invoice_data-InvoiceDoc
        fiscalyear          = me->invoice_data-InvoiceDocYear
      IMPORTING
        headerdata          = headerdata
      TABLES
        itemdata            = itemdata
        materialdata        = materialdata
        taxdata             = taxdata
        withtaxdata         = withtaxdata
        vendoritemsplitdata = vendoritemsplitdata
        return              = bapi_return.

    APPEND LINES OF bapi_return TO me->logs.
    CHECK NOT line_exists( me->logs[ type = 'E' ] ).


    MOVE-CORRESPONDING headerdata TO me->headerdata_change.

    CLEAR gross_amount.
    LOOP AT itemdata INTO DATA(item). "Dados de itens de Pedido
      gross_amount += item-item_amount.
    ENDLOOP.

    LOOP AT materialdata INTO DATA(material). "Dados de Materiais
      gross_amount += material-item_amount.
    ENDLOOP.

    LOOP AT taxdata INTO DATA(tax). "Impostos
      gross_amount += tax-tax_amount.
    ENDLOOP.

    LOOP AT withtaxdata INTO DATA(irf). "Impostos retidos na fonte
      gross_amount += irf-wi_tax_amt.
    ENDLOOP.

    me->headerdata_change-gross_amount  = gross_amount.
    me->headerdata_changex-gross_amount = abap_true.

    me->headerdata_change-alloc_nmbr  = me->invoice_data-TradingContract. "Contrato no número de Atribuição
    me->headerdata_changex-alloc_nmbr = abap_true.

    me->headerdata_change-item_text  = ''.
    me->headerdata_changex-item_text = abap_true.

    me->headerdata_change-dsct_days1  = me->fixation_header-payment_date - sy-datum.
    me->headerdata_changeX-dsct_days1 = abap_true.


  ENDMETHOD.


  METHOD invoice_change.

    DATA: bapi_return TYPE TABLE OF bapiret2.

    CHECK NOT line_exists( me->logs[ type = 'E' ] ).

    BREAK t_lzanella.

    CALL FUNCTION 'BAPI_INCOMINGINVOICE_CHANGE'
      EXPORTING
        invoicedocnumber    = me->invoice_data-InvoiceDoc
        fiscalyear          = me->invoice_data-InvoiceDocYear
        table_change        = me->table_change
        headerdata_change   = me->headerdata_change
        headerdata_changex  = me->headerdata_changex
      TABLES
        vendoritemsplitdata = me->vendoritemsplitdata_change
        return              = bapi_return.


    APPEND LINES OF bapi_return TO me->logs.

    IF NOT line_exists( me->logs[ type = 'E' ] ).
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

    IF me->lipre_settings-nfvalid = abap_false.

      IF  me->lipre_settings-nftype IS INITIAL.
        APPEND zadocl_grains_utilities=>get_msg( type = 'E'  id = 'ZADO_GRAINS'   number = '033' ) TO me->logs.  "Não foi possível determinar a categoria de NF.
        RETURN.
      ENDIF.

    ELSE.

      DATA(invoice_and_year) = CONV symsgv( |{ me->invoice_data-InvoiceDoc }/{ me->invoice_data-InvoiceDocYear }| ).
      APPEND zadocl_grains_utilities=>get_msg( type = 'I'  id = 'ZADO_GRAINS'   number = '041' var1 = invoice_and_year ) TO me->logs.  "Fatura &1 memorizada. Será necessário finalizar o registro manualmente.

      RETURN.
    ENDIF.

    CHECK NOT line_exists( me->logs[ type = 'E' ] ).

    CALL FUNCTION 'DEQUEUE_ALL'.

    CALL FUNCTION 'BAPI_INCOMINGINVOICE_POST'  "A categoria de nota será preenchida na BADI INVOICE_UPDATE
      EXPORTING                                "implementada na classe zcl_im_acm_nftype_update
        invoicedocnumber = me->invoice_data-InvoiceDoc
        fiscalyear       = me->invoice_data-InvoiceDocYear
      TABLES
        return           = bapi_return.


    IF line_exists( bapi_return[ type   = 'E'
                                 number = '534'
                                 id     = 'M8' ] )."Divergência de valor...

      DATA(gross_amount) = bapi_return[ id = 'M8' number = '534' ]-message_v2.

      REPLACE ALL OCCURRENCES OF '.' IN gross_amount WITH ''.
      REPLACE ALL OCCURRENCES OF ',' IN gross_amount WITH '.'.
      CONDENSE gross_amount NO-GAPS.
      me->headerdata_change-gross_amount = CONV bapi_rmwwr( gross_amount ).

      CLEAR bapi_return.

      me->invoice_change( ).
      RETURN.
    ENDIF.

    APPEND LINES OF bapi_return TO me->logs.


    IF line_exists( me->logs[ type   = 'E'
                              number = '064'
                              id     = '/ACCGO/CAS_STL_LOGIC' ] ) .

      ROLLBACK WORK .

      DELETE me->logs WHERE id = '/ACCGO/CAS_STL_LOGIC'  AND number = '064'.

      RETURN.

    ENDIF.


    IF NOT line_exists( me->logs[ type = 'E' ] ).

      COMMIT WORK AND WAIT.

      APPEND zadocl_grains_utilities=>get_msg( type   = 'S'
                                               id     = 'ZADO_GRAINS'
                                               number = '042'
                                               var1   = |{ me->invoice_data-InvoiceDoc }/{ me->invoice_data-InvoiceDocYear }| ) TO me->logs.
      me->save_acc_doc( ).
      me->execute_clearing( ).

    ELSE.
      ROLLBACK WORK.
    ENDIF.


  ENDMETHOD.


  METHOD save_invoice_doc.

    CHECK me->fixation_header IS NOT INITIAL.
    CHECK me->invoice_data    IS NOT INITIAL.

    me->fixation_header-invoice_doc      = me->invoice_data-InvoiceDoc.
    me->fixation_header-invoice_doc_year = me->invoice_data-InvoiceDocYear.

    IF me->lipre_settings-nfvalid = abap_true.
      me->fixation_header-invoice_post_manually = abap_true.
    ENDIF.

    DATA(change_return) = NEW zadocl_grains_change_fixation( fixation = me->fixation_header )->change( ).

  ENDMETHOD.


  METHOD save_acc_doc.

    CHECK me->fixation_header IS NOT INITIAL.
    CHECK me->invoice_data    IS NOT INITIAL.

    DATA(acc_found) = abap_false.

    DATA(invoice) = CONV awkey( me->invoice_data-InvoiceDoc && me->invoice_data-InvoiceDocYear ).


    DO 8 TIMES.

      SELECT SINGLE bukrs, belnr, gjahr, awkey FROM bkpf WHERE awkey = @invoice INTO @DATA(acc_header).

      IF sy-subrc = 0.

        SELECT bukrs, belnr, gjahr, buzei, qsznr FROM bseg WHERE bukrs = @acc_header-bukrs
                                                             AND belnr = @acc_header-belnr
                                                             AND gjahr = @acc_header-gjahr
                                                             AND bschl = '31' "Fatura
                                                             AND koart = 'K' "Fornecedor
                                                            INTO TABLE @DATA(acc_items).

        IF sy-subrc = 0.

          me->fixation_header-company_code        = acc_header-bukrs.
          me->fixation_header-accounting_document = acc_header-belnr.
          me->fixation_header-fiscal_year         = acc_header-gjahr.
          me->fixation_header-status              = 'F'.

          DATA(change_return) = NEW zadocl_grains_change_fixation( fixation = me->fixation_header )->change( ).

          acc_found = abap_true.
          EXIT.

        ENDIF.

      ELSE.

        WAIT UP TO 1 SECONDS.

      ENDIF.

    ENDDO.

    IF acc_found = abap_false.
      APPEND zadocl_grains_utilities=>get_msg( type = 'E'  id = 'ZADO_GRAINS'  number = '034' ) TO me->logs.  "Documento contábil não foi encontrado.
    ENDIF.

  ENDMETHOD.


  METHOD execute_clearing.

    CHECK NOT line_exists( me->logs[ type = 'E' ] ).


    SELECT SINGLE * FROM zadot_grains_fix WHERE invoice_doc        = @me->invoice_data-InvoiceDoc
                                            AND invoice_doc_year   = @me->invoice_data-InvoiceDocYear
                                           INTO @DATA(fixation_header).

    IF sy-subrc = 0.

      DATA(clearing_return) = NEW zadocl_grains_clear_fix_acc( contract_num = fixation_header-contractnum
                                                               invoice      = fixation_header-invoice_doc )->execute_clearing( ).

      APPEND LINES OF clearing_return TO me->logs.

    ENDIF.


  ENDMETHOD.

ENDCLASS.
