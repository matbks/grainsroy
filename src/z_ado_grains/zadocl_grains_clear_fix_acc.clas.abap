CLASS zadocl_grains_clear_fix_acc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING contract_num TYPE tkonn
                invoice      TYPE re_belnr OPTIONAL
                test_run     TYPE abap_bool DEFAULT ''
                mode         TYPE allgazmd  DEFAULT 'N'.

    METHODS execute_clearing
      RETURNING VALUE(return) TYPE bapiret2_t.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA: contract_num  TYPE tkonn,
          invoice       TYPE re_belnr,
          invoice_range TYPE RANGE OF re_belnr,
          test_run      TYPE abap_bool,
          mode          TYPE allgazmd.

    DATA: application_invoices     TYPE TABLE OF zadoi_grains_contract_invoices,
          subsequent_invoices      TYPE TABLE OF zadoc_grains_ctr_app_inv_sd,
          subsequent_invoice_items TYPE TABLE OF zadoi_grains_contract_invoices.

    DATA: cleared_quantities     TYPE TABLE OF zadot_grains_clr,
          fixations_header       TYPE TABLE OF zadot_grains_fix,
          fixations_installments TYPE TABLE OF zADOT_GRAINS_BIL,
          true_up_sub_documents  TYPE TABLE OF zadoi_grains_true_up_subs_docs.

    DATA: logs TYPE bapiret2_t.

    METHODS get_data.
    METHODS execute.

    METHODS posting_clearing
      IMPORTING t_ftclear     TYPE re_t_ex_ftclear
                t_ftpost      TYPE re_t_ex_ftpost
      RETURNING VALUE(return) TYPE bapiret2.

    METHODS get_ext_format
      IMPORTING value         TYPE any
      RETURNING VALUE(return) TYPE char255.

    METHODS condense
      IMPORTING value         TYPE any
      RETURNING VALUE(return) TYPE char255.

    METHODS update_fix_status
      IMPORTING
        clearing_doc    TYPE augbl
        clearing_year   TYPE gjahr
        fixation_header TYPE zadot_grains_fix.



ENDCLASS.



CLASS zadocl_grains_clear_fix_acc IMPLEMENTATION.

  METHOD constructor.

    me->contract_num = contract_num.
    me->invoice      = invoice.
    me->test_run     = test_run.
    me->mode         = mode.

    IF invoice IS NOT INITIAL.
      me->invoice_range = VALUE #( ( sign = 'I'    option = 'EQ'    low = me->invoice ) ).
    ENDIF.

    me->get_data( ).

  ENDMETHOD.


  METHOD get_data.

    CLEAR me->subsequent_invoices.
    SELECT * FROM zadoc_grains_ctr_app_inv_sd WHERE TradingContract          =  @me->contract_num
                                                AND AccountingDocumentStatus =  'OPEN'
                                                AND AccountingDocument       IS NOT INITIAL
                                                AND InvoiceDoc               IN @me->invoice_range
                                               INTO TABLE @me->subsequent_invoices. "SD


    IF sy-subrc = 0.

      CLEAR me->subsequent_invoice_items.
      SELECT * FROM zadoi_grains_contract_invoices
        FOR ALL ENTRIES IN @me->subsequent_invoices WHERE TradingContract          = @me->subsequent_invoices-TradingContract
                                                      AND AccountingDocumentStatus = 'OPEN'
                                                      AND InvoiceDocType           = @me->subsequent_invoices-InvoiceDocType "SD
                                                      AND AccountingDocument       = @me->subsequent_invoices-AccountingDocument
                                                     INTO TABLE @me->subsequent_invoice_items.

      CLEAR me->application_invoices.
      SELECT * FROM zadoi_grains_contract_invoices
        FOR ALL ENTRIES IN @me->subsequent_invoices WHERE TradingContract = @me->subsequent_invoices-TradingContract
*                                                      AND applicationdoc  = @me->subsequent_invoices-applicationdoc
*                                                    AND AccountingDocumentStatus = 'OPEN'
                                                      AND InvoiceDocType = 'IV'
                                                      AND AccountingDocument IS NOT INITIAL
                                                     INTO TABLE @me->application_invoices.

      IF sy-subrc = 0.

        CLEAR me->true_up_sub_documents.
        SELECT * FROM zadoi_grains_true_up_subs_docs
          FOR ALL ENTRIES IN @me->application_invoices WHERE TrueUpGuid = @me->application_invoices-ApplicationTrueUpGuid
                                                        INTO TABLE @me->true_up_sub_documents.

      ENDIF.

      CLEAR me->fixations_header.
      SELECT  * FROM zadot_grains_fix
        FOR ALL ENTRIES IN @me->subsequent_invoices WHERE contractnum         =  @me->subsequent_invoices-TradingContract
                                                      AND settlement_group_id = @me->subsequent_invoices-SettlementGroupId
                                                      AND settlement_year     = @me->subsequent_invoices-SettlementGroupYear
                                                     INTO TABLE @me->fixations_header.
      IF sy-subrc = 0.

        CLEAR me->fixations_installments.
        SELECT * FROM zadot_grains_bil
            FOR ALL ENTRIES IN @me->fixations_header WHERE plant              = @me->fixations_header-plant
                                                       AND contractnum        = @me->fixations_header-contractnum
                                                       AND identification_fix = @me->fixations_header-identification_fix
                                                      INTO TABLE @me->fixations_installments.

      ENDIF.



    ENDIF.




  ENDMETHOD.


  METHOD execute.

    DATA: t_ftclear                   TYPE TABLE OF ftclear,
          t_ftpost                    TYPE TABLE OF ftpost,
          amount                      TYPE p LENGTH 16 DECIMALS 6,
          value_ponderado             TYPE p LENGTH 16 DECIMALS 6,
          amount_ponderado            TYPE p LENGTH 16 DECIMALS 6,
          installments_amount         TYPE p LENGTH 16 DECIMALS 6,
          amount_application_to_clear TYPE p LENGTH 16 DECIMALS 6,
          amount_true_up              TYPE p LENGTH 16 DECIMALS 6,
          residual_invoce_docs        TYPE TABLE OF zados_grains_acc_tree,
          true_up_open_docs           TYPE TABLE OF zados_grains_acc_tree,
          amount_credit               TYPE p LENGTH 16 DECIMALS 2,
          amount_debit                TYPE p LENGTH 16 DECIMALS 2.



    DATA: value_rounded TYPE p LENGTH 15 DECIMALS 2.

    CHECK me->subsequent_invoices      IS NOT INITIAL.
    CHECK me->subsequent_invoice_items IS NOT INITIAL.
    CHECK me->application_invoices     IS NOT INITIAL.


    DATA applicationdoc_range TYPE RANGE OF /accgo/e_appldoc.

    LOOP AT subsequent_invoices INTO DATA(subsequent_invoice).
      CLEAR: t_ftclear, t_ftpost, amount,residual_invoce_docs, amount_credit.

      CLEAR applicationdoc_range.
      "Items do documento quando tem split de contas bancárias.
      LOOP AT me->subsequent_invoice_items INTO DATA(subsequent_invoice_item) WHERE AccountingDocument = subsequent_invoice-AccountingDocument.

        amount += subsequent_invoice_item-AmountInCompanyCurrency.

        APPEND VALUE #( sign = 'I' option = 'EQ'  low = subsequent_invoice_item-ApplicationDoc ) TO applicationdoc_range.

      ENDLOOP.

      IF subsequent_invoice-FixationIdFromZTable IS INITIAL.
        APPEND zadocl_grains_utilities=>get_msg( type   = 'E'
                                                 id     = 'ZADO_GRAINS'
                                                 number = '037'
                                                 var1   = |{ subsequent_invoice-SettlementGroupId }/{ subsequent_invoice-SettlementGroupYear }| ) TO me->logs. "Grupo de liquidação &1 não foi criado pelo monitor ACM Controlling.
        CONTINUE.
      ENDIF.


      DATA(application_problem) = abap_false.
      LOOP AT me->application_invoices INTO DATA(application_invoice) WHERE applicationdoc IN applicationdoc_range.

        IF application_invoice-ApplicationDiffStatus IS NOT INITIAL AND
           application_invoice-ApplicationDiffStatus <> 'STCP'      AND
           application_invoice-ApplicationDiffStatus <> 'STRD'.

          APPEND zadocl_grains_utilities=>get_msg( type   = 'E'
                                                   id     = 'ZADO_GRAINS'
                                                   number = '038'
                                                   var1   = CONV syst_msgv( application_invoice-ApplicationDoc ) ) TO me->logs. "Aplicação &1 possui pendências de Notas Fiscais.

          application_problem = abap_true.
        ENDIF.

        "Buscar o documento contábil que está em aberto...
        DATA(app_open_acc_document) = NEW zadocl_grains_get_acc_tree( company_code             = application_invoice-InvoiceCompanyCode
                                                                      accounting_document      = application_invoice-AccountingDocument
                                                                      accounting_document_year = application_invoice-AccountingDocumentYear
                                                                      accounting_item          = application_invoice-AccountingItem )->get_last_document( ).

        IF app_open_acc_document IS NOT INITIAL.

          t_ftclear = VALUE #( BASE t_ftclear  "Invoices parciais
                                 ( agkoa  = 'K'
                                   agkon  = app_open_acc_document-vendor
                                   agbuk  = app_open_acc_document-company_code
                                   xnops  = 'X'
                                   selfd  = 'BELNR'
                                   selvon = app_open_acc_document-Accounting_Document && app_open_acc_document-Accounting_Document_Year && app_open_acc_document-Accounting_Item
                                   selbis = app_open_acc_document-accounting_document ) ).

          amount_credit += app_open_acc_document-amount.

        ENDIF.

        CLEAR amount_true_up.
        CLEAR true_up_open_docs.
        LOOP AT me->true_up_sub_documents INTO DATA(true_up_sub_document) WHERE TrueUpGuid = application_invoice-ApplicationTrueUpGuid.


          DATA(true_up_open_acc_document) = NEW zadocl_grains_get_acc_tree( company_code             = true_up_sub_document-CompanyCode
                                                                            accounting_document      = true_up_sub_document-AccountingDocument
                                                                            accounting_document_year = true_up_sub_document-AccountingDocumentYear
                                                                            accounting_item          = true_up_sub_document-AccountingItem )->get_last_document( ).

          IF true_up_open_acc_document IS INITIAL .
            CONTINUE.
          ENDIF.

          APPEND true_up_open_acc_document TO true_up_open_docs.
          amount_true_up += true_up_open_acc_document-amount.
          CLEAR true_up_open_acc_document.
        ENDLOOP.

        CLEAR amount_application_to_clear.
        amount_application_to_clear = app_open_acc_document-amount + amount_true_up.

        amount_application_to_clear = ( amount_application_to_clear / ( application_invoice-AvailableQuantity + application_invoice-QuantityToClear ) ) * application_invoice-QuantityToClear.

        IF amount_application_to_clear <= app_open_acc_document-amount. "Quando o valor a compensar é menor do que o valor do documento original da aplicação

          IF application_invoice-AvailableQuantity IS INITIAL. "Itens Normais
            amount                      += app_open_acc_document-amount.
            amount_application_to_clear -= app_open_acc_document-amount.

          ELSE. "Residual

            amount       += amount_application_to_clear.

            app_open_acc_document-amount -= amount_application_to_clear.

            APPEND app_open_acc_document TO residual_invoce_docs.

            CLEAR amount_application_to_clear.

          ENDIF.

        ELSE. "Quando o valor da aplicação não é suficiente para compensar.

          amount       += app_open_acc_document-amount.
          amount_application_to_clear -= app_open_acc_document-amount.

          LOOP AT true_up_open_docs INTO DATA(true_up_open_doc).

            t_ftclear = VALUE #( BASE t_ftclear  "Documentos contábeis subsequentes (True Up)
                                   ( agkoa  = 'K'
                                     agkon  = true_up_open_doc-vendor
                                     agbuk  = true_up_open_doc-company_code
                                     xnops  = 'X'
                                     selfd  = 'BELNR'
                                     selvon = true_up_open_doc-Accounting_Document && true_up_open_doc-Accounting_Document_Year && true_up_open_doc-Accounting_Item
                                     selbis = true_up_open_doc-accounting_document ) ).

            amount_credit = true_up_open_doc-amount.

            IF true_up_open_doc-amount <= amount_application_to_clear. "Compensar integral o complemento (True Up)

              amount                      += true_up_open_doc-amount.
              amount_application_to_clear -= true_up_open_doc-amount.


            ELSE. "Compensar o documento de complemento (true Up) e gerar partida residual do True Up.

              amount                  += amount_application_to_clear.
              true_up_open_doc-amount -= amount_application_to_clear.
              APPEND true_up_open_doc TO residual_invoce_docs.

              CLEAR amount_application_to_clear.
              CLEAR true_up_open_doc.

            ENDIF.

          ENDLOOP.

        ENDIF.

        "Informações relativas ao saldo que já foi compensado.
        APPEND VALUE zadot_grains_clr(  mandt                    = sy-mandt
                                        contract_num             = subsequent_invoice-TradingContract
                                        application_doc          = application_invoice-ApplicationDoc
                                        application_doc_item     = application_invoice-ApplicationDocItem
                                        company_code             = application_invoice-InvoiceCompanyCode
                                        accounting_document_year = application_invoice-AccountingDocument
                                        accounting_document      = application_invoice-AccountingDocumentYear
                                        accounting_document_item = application_invoice-AccountingItem
                                        edc                      = application_invoice-edc
                                        cleared_quantity         = application_invoice-QuantityToClear
                                        uom                      = application_invoice-Uom
                                        created_by               = sy-uname
                                        created_on               = zadocl_grains_utilities=>get_timestamp( ) ) TO me->cleared_quantities.



      ENDLOOP.




      "Invoice final
      t_ftclear = VALUE #( BASE t_ftclear
                             ( agkoa  = 'K'
                               agkon  = subsequent_invoice-InvoicePartner
                               agbuk  = subsequent_invoice-InvoiceCompanyCode
                               xnops  = 'X'
                               selfd  = 'BELNR'
                               selvon = subsequent_invoice-AccountingDocument && subsequent_invoice-AccountingDocumentYear
                               selbis = subsequent_invoice-AccountingDocument ) ).

      amount_credit += subsequent_invoice-AmountInCompanyCurrency.


      DATA(Assignment) = VALUE #( application_invoices[ 1 ]-Assignment OPTIONAL ).

      DATA(counter) = CONV count_pi( '001' ).
      t_ftpost = VALUE #( BASE t_ftpost
            "Cabeçalho do documento de compensação
            ( stype = 'K'  count = counter  fnam = 'BKPF-BLDAT'   fval = me->get_ext_format( sy-datum  )  )
            ( stype = 'K'  count = counter  fnam = 'BKPF-BUDAT'   fval = me->get_ext_format( sy-datum  )  )
            ( stype = 'K'  count = counter  fnam = 'BKPF-BLART'   fval = 'KR'  )
            ( stype = 'K'  count = counter  fnam = 'BKPF-BUKRS'   fval = application_invoice-InvoiceCompanyCode  )
            ( stype = 'K'  count = counter  fnam = 'BKPF-WAERS'   fval = application_invoice-CompanyCurrency  )
            ( stype = 'K'  count = counter  fnam = 'BKPF-XBLNR'   fval = |{ subsequent_invoice-SettlementGroupId }/{ subsequent_invoice-SettlementGroupYear }| )
            ( stype = 'K'  count = counter  fnam = 'BKPF-AWKEY'   fval = application_invoice-InvoiceDoc && application_invoice-InvoiceDocYear ) ).


      TRY.
          DATA(fixation_header) = me->fixations_header[ contractnum         = subsequent_invoice-TradingContract
                                                        settlement_group_id = subsequent_invoice-SettlementGroupId
                                                        settlement_year     = subsequent_invoice-SettlementGroupYear ].
        CATCH cx_sy_itab_line_not_found.
          CLEAR fixation_header.
      ENDTRY.


      CLEAR installments_amount. "Valor total da fixação
      LOOP AT me->fixations_installments INTO DATA(fixation_installment).
        installments_amount += fixation_installment-amount.
      ENDLOOP.


      CLEAR amount_ponderado.
      LOOP AT me->fixations_installments INTO fixation_installment WHERE contractnum        = fixation_header-contractnum
                                                                     AND plant              = fixation_header-plant
                                                                     AND identification_fix = fixation_header-identification_fix.

        CLEAR value_ponderado.

        TRY.
            value_ponderado = amount * ( fixation_installment-amount / installments_amount ).
          CATCH cx_sy_zerodivide.
            CLEAR value_ponderado.
        ENDTRY.

        amount_ponderado += CONV wrbtr( value_ponderado ).

        counter += 1.

        t_ftpost = VALUE #( BASE t_ftpost  "Item a pagar ao fornecedor (Fixação)
              ( stype = 'P'  count = counter  fnam = 'RF05A-NEWBS'  fval = '31' )
              ( stype = 'P'  count = counter  fnam = 'RF05A-NEWKO'  fval = application_invoice-InvoicePartner )
              ( stype = 'P'  count = counter  fnam = 'BSEG-WRBTR'   fval = me->get_ext_format( CONV wrbtr( value_ponderado ) ) )
              ( stype = 'P'  count = counter  fnam = 'BSEG-ZTERM'   fval = 'ZFRP' ) "application_invoice-PaymentTerm )
              ( stype = 'P'  count = counter  fnam = 'BSEG-BUPLA'   fval = application_invoice-BusinessPlace )
              ( stype = 'P'  count = counter  fnam = 'BSEG-ZFBDT'   fval = me->get_ext_format( subsequent_invoice-FixationCreatedAt ) )
              ( stype = 'P'  count = counter  fnam = 'BSEG-ZBD1T'   fval = me->get_ext_format( subsequent_invoice-FixationPaymentDays ) )
              ( stype = 'P'  count = counter  fnam = 'BSEG-ZUONR'   fval = Assignment )
              ( stype = 'P'  count = counter  fnam = 'BSEG-SGTXT'   fval = |Ctr:{ application_invoice-TradingContract },Liq:{ subsequent_invoice-SettlementGroupId }/{ subsequent_invoice-SettlementGroupYear },Fix:{ subsequent_invoice-FixationId }| )
              ( stype = 'P'  count = counter  fnam = 'BSEG-BVTYP'   fval = application_invoice-BankPartnerType )
              ( stype = 'P'  count = counter  fnam = 'BSEG-ZLSPR'   fval = 'F' ) "Bloqueio de Crédito
              ( stype = 'P'  count = counter  fnam = 'BSEG-BVTYP'   fval = fixation_installment-bankaccountid ) ).

        amount_debit += value_ponderado.
      ENDLOOP.


      IF me->fixations_installments IS INITIAL.  "Quando não encontrar parcelas nas tabelas Zs

        counter += 1.

        t_ftpost = VALUE #( BASE t_ftpost  "Item a pagar ao fornecedor (Fixação)
              ( stype = 'P'  count = counter  fnam = 'RF05A-NEWBS'  fval = '31' )
              ( stype = 'P'  count = counter  fnam = 'RF05A-NEWKO'  fval = application_invoice-InvoicePartner )
              ( stype = 'P'  count = counter  fnam = 'BSEG-WRBTR'   fval = me->get_ext_format( CONV wrbtr( amount ) ) )
              ( stype = 'P'  count = counter  fnam = 'BSEG-ZTERM'   fval = 'ZFRP' ) "application_invoice-PaymentTerm )
              ( stype = 'P'  count = counter  fnam = 'BSEG-BUPLA'   fval = application_invoice-BusinessPlace )
              ( stype = 'P'  count = counter  fnam = 'BSEG-ZFBDT'   fval = me->get_ext_format( subsequent_invoice-FixationCreatedAt ) )
              ( stype = 'P'  count = counter  fnam = 'BSEG-ZBD1T'   fval = me->get_ext_format( subsequent_invoice-FixationPaymentDays ) )
              ( stype = 'P'  count = counter  fnam = 'BSEG-ZUONR'   fval = Assignment )
              ( stype = 'P'  count = counter  fnam = 'BSEG-SGTXT'   fval = |Ctr:{ application_invoice-TradingContract },Liq:{ subsequent_invoice-SettlementGroupId }/{ subsequent_invoice-SettlementGroupYear },Fix:{ subsequent_invoice-FixationId }| )
              ( stype = 'P'  count = counter  fnam = 'BSEG-BVTYP'   fval = application_invoice-BankPartnerType )
              ( stype = 'P'  count = counter  fnam = 'BSEG-ZLSPR'   fval = 'F' ) "Bloqueio de Crédito
              ( stype = 'P'  count = counter  fnam = 'BSEG-BVTYP'   fval = fixation_installment-bankaccountid ) ).

        amount_debit += amount.
      ENDIF.

      "Itens dos documentos residuais a serem criados



      LOOP AT residual_invoce_docs INTO DATA(residual_invoce_doc).

        counter += 1.

        IF residual_invoce_doc-reference_doc IS NOT INITIAL.
          DATA(reference_doc)  = residual_invoce_doc-reference_doc.
          DATA(reference_year) = residual_invoce_doc-reference_year.
          DATA(reference_item) = residual_invoce_doc-reference_item.
        ELSE.
          reference_doc  = residual_invoce_doc-accounting_document.
          reference_year = residual_invoce_doc-accounting_document_year.
          reference_item = residual_invoce_doc-accounting_item.
        ENDIF.

        t_ftpost = VALUE #(  BASE t_ftpost
             ( stype = 'P'  count = counter  fnam = 'RF05A-NEWBS'  fval = '31' )
             ( stype = 'P'  count = counter  fnam = 'RF05A-NEWKO'  fval = residual_invoce_doc-vendor )
             ( stype = 'P'  count = counter  fnam = 'BSEG-WRBTR'   fval = me->get_ext_format( residual_invoce_doc-amount ) )
             ( stype = 'P'  count = counter  fnam = 'BSEG-ZTERM'   fval = residual_invoce_doc-payment_term )
             ( stype = 'P'  count = counter  fnam = 'BSEG-BUPLA'   fval = residual_invoce_doc-business_place )
             ( stype = 'P'  count = counter  fnam = 'BSEG-ZFBDT'   fval = me->get_ext_format( residual_invoce_doc-base_date ) )
             ( stype = 'P'  count = counter  fnam = 'BSEG-ZUONR'   fval = Assignment )
             ( stype = 'P'  count = counter  fnam = 'BSEG-SGTXT'   fval = |Residual - Doc.Orig: { residual_invoce_doc-accounting_document } | )
             ( stype = 'P'  count = counter  fnam = 'BSEG-BVTYP'   fval = residual_invoce_doc-bank_partner_type )
             ( stype = 'P'  count = counter  fnam = 'BSEG-REBZG'   fval = reference_doc )
             ( stype = 'P'  count = counter  fnam = 'BSEG-REBZJ'   fval = reference_year )
             ( stype = 'P'  count = counter  fnam = 'BSEG-REBZZ'   fval = reference_item ) ).

        amount_debit += residual_invoce_doc-amount.
        CLEAR: value_rounded, reference_doc, reference_year, reference_item.

      ENDLOOP.

      IF amount_credit <> amount_debit.

        CLEAR amount.

        ASSIGN t_ftpost[ fnam  = 'BSEG-WRBTR' ]-fval TO FIELD-SYMBOL(<first_debit_amount>).

        IF <first_debit_amount> IS ASSIGNED.

          REPLACE ALL OCCURRENCES OF '.' IN <first_debit_amount> WITH ''.
          REPLACE ALL OCCURRENCES OF ',' IN <first_debit_amount> WITH '.'.

          amount = <first_debit_amount>.
          amount += ( amount_credit - amount_debit ).
          <first_debit_amount> = me->get_ext_format( CONV wrbtr( amount ) ).

        ENDIF.

      ENDIF.


      IF application_problem = abap_true.
        CONTINUE.
      ENDIF.

      "Executar a compensação relativa a invoice de liquidação
      DATA(msg) = me->posting_clearing( t_ftclear = t_ftclear
                                        t_ftpost  = t_ftpost ).

      IF msg-type = 'S' AND msg-number = '312' AND msg-id = 'F5'.

        LOOP AT me->cleared_quantities ASSIGNING FIELD-SYMBOL(<cleared_quantity>).

          <cleared_quantity>-clearing_document      = msg-message_v1.
          <cleared_quantity>-clearing_document_year = sy-datum(4).

        ENDLOOP.

        MODIFY zadot_grains_clr FROM TABLE me->cleared_quantities.
        COMMIT WORK AND WAIT.

        me->update_fix_status( clearing_doc    = CONV #( msg-message_v1 )
                               clearing_year   = sy-datum(4)
                               fixation_header = fixation_header ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD update_fix_status.

    SELECT SINGLE * FROM zadot_grains_fix WHERE plant              = @fixation_header-plant
                                            AND contractnum        = @fixation_header-contractnum
                                            AND identification_fix = @fixation_header-identification_fix
                                           INTO @DATA(fixation).

    fixation-status               = 'C'.
    fixation-clearing_document    = clearing_doc.
    fixation-clearing_fiscal_year = clearing_year.

    DATA(change_return) = NEW zadocl_grains_change_fixation( fixation )->change( ).

    IF change_return-type = 'E'.
      APPEND change_return TO me->logs.
    ENDIF.

  ENDMETHOD.


  METHOD execute_clearing.

    me->execute( ).

    return = me->logs.

  ENDMETHOD.


  METHOD posting_clearing.

    DATA: t_blntab TYPE re_t_ex_blntab,
          t_fttax  TYPE re_t_ex_fttax.

    CHECK t_ftclear IS NOT INITIAL.
    CHECK t_ftpost  IS NOT INITIAL.

    DATA: e_msgid TYPE sy-msgid,
          e_msgty TYPE sy-msgty,
          e_msgno TYPE sy-msgno,
          e_msgv1 TYPE sy-msgv1,
          e_msgv2 TYPE sy-msgv2,
          e_msgv3 TYPE sy-msgv3,
          e_msgv4 TYPE sy-msgv4,
          e_subrc TYPE sy-subrc.


    CALL FUNCTION 'POSTING_INTERFACE_START'
      EXPORTING
        i_function = 'C'
        i_mode     = me->mode.


    CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
      EXPORTING
        i_auglv                    = 'UMBUCHNG'
        i_tcode                    = 'FB05'
        i_sgfunct                  = 'C'
        i_xsimu                    = me->test_run
      IMPORTING
        e_msgid                    = e_msgid
        e_msgno                    = e_msgno
        e_msgty                    = e_msgty
        e_msgv1                    = e_msgv1
        e_msgv2                    = e_msgv2
        e_msgv3                    = e_msgv3
        e_msgv4                    = e_msgv4
        e_subrc                    = e_subrc
      TABLES
        t_blntab                   = t_blntab
        t_ftclear                  = t_ftclear
        t_ftpost                   = t_ftpost
        t_fttax                    = t_fttax
      EXCEPTIONS
        clearing_procedure_invalid = 1
        clearing_procedure_missing = 2
        table_t041a_empty          = 3
        transaction_code_invalid   = 4
        amount_format_error        = 5
        too_many_line_items        = 6
        company_code_invalid       = 7
        screen_not_found           = 8
        no_authorization           = 9
        OTHERS                     = 10.

    CALL FUNCTION 'POSTING_INTERFACE_END'.

    IF e_msgty = 'E'.

      return = zadocl_grains_utilities=>get_msg( type   = e_msgty
                                                 id     = e_msgid
                                                 number = e_msgno
                                                 var1   = e_msgv1
                                                 var2   = e_msgv2
                                                 var3   = e_msgv3
                                                 var4   = e_msgv4 ).

    ELSE.

      return = zadocl_grains_utilities=>get_msg( type   = sy-msgty
                                                 id     = sy-msgid
                                                 number = sy-msgno
                                                 var1   = sy-msgv1
                                                 var2   = sy-msgv2
                                                 var3   = sy-msgv3
                                                 var4   = sy-msgv4 ).


    ENDIF.

    APPEND return TO me->logs.


  ENDMETHOD.



  METHOD get_ext_format.

    WRITE value TO return.

    CONDENSE return NO-GAPS.

  ENDMETHOD.


  METHOD condense.

    WRITE value TO return.

    return = |{ return ALPHA = OUT }|.

    CONDENSE return NO-GAPS.

  ENDMETHOD.


ENDCLASS.
