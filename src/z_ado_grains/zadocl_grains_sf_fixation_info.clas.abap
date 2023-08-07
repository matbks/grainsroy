CLASS zadocl_grains_sf_fixation_info DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        parameters TYPE zados_grains_sf_params.

    METHODS get_sf_data
      RETURNING VALUE(return) TYPE zados_grains_sf_data.

    METHODS financial_bank_fix_item_data
      RETURNING VALUE(return) TYPE zadoc_grains_fixation_bill_tt.

    METHODS nfes_edcs_data
      RETURNING VALUE(return) TYPE zados_grains_sf_bol_nfs_edc_tt.

    METHODS tax_amount_total
      RETURNING VALUE(return) TYPE zado_grains_tax_total_bol_tt.

    METHODS origin_tax_amount.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: BEGIN OF tax_dif_calc,
             contract_num TYPE tkonn,
             nfs_num      TYPE j_1bnfnum9,
             edc_num      TYPE /accgo/e_uis_id,
             app_num      TYPE /accgo/e_appldoc,
             ref_key      TYPE awkey,
             doc_type     TYPE char2,
             tax_type     TYPE qsskz,
             tax_name     TYPE char40,
             net_weight   TYPE j_1bnetqty,
             fixed_weight TYPE zadode_grains_quantity,
             tax_amount   TYPE with_item-wt_qbshh,
           END OF tax_dif_calc.

    DATA: tax_dif_calc_tab TYPE TABLE OF tax_dif_calc,
          tax_dif_calc_st  TYPE tax_dif_calc.

    DATA parameters                 TYPE zados_grains_sf_params.
    DATA financial_bank_data        TYPE TABLE OF zadoc_grains_fix_bank_data.
    DATA nfes_edcs_tab_data         TYPE TABLE OF zados_grains_sf_bol_nfs_edc.
    DATA nfes_edcs_tab_sales        TYPE TABLE OF zados_grains_sf_bol_nfs_sales.
    DATA nfes_edcs_form_data        TYPE TABLE OF zados_grains_sf_form_nfs_edc.
    DATA tax_amount_total_tab       TYPE TABLE OF zado_grains_tax_total_bol.
    DATA fin_bank_data              TYPE TABLE OF zadot_grains_bil.
    DATA partners_infos             TYPE TABLE OF zi_partners.
    DATA irf_info                   TYPE TABLE OF with_item.
    DATA invoices                   TYPE TABLE OF zadoc_grains_appl_invoices.
    DATA header_docs_fatura         TYPE TABLE OF rbkp.
    DATA application_invoices       TYPE TABLE OF zadoc_grains_appl_invoices.
    DATA ctr_app_inv_sd             TYPE TABLE OF zadoc_grains_ctr_app_inv_sd.
    DATA contract_inv_iv            TYPE TABLE OF zadoi_grains_contract_invoices.
    DATA tax_sales                  TYPE TABLE OF zadoc_grains_sf_tax_sales.
    DATA num_documents              TYPE TABLE OF bseg.
    DATA tax_names                  TYPE TABLE OF t059zt.
    DATA true_up_sub_docs           TYPE TABLE OF zadoi_grains_true_up_subs_docs.
    DATA fixation_taxes             TYPE TABLE OF zadoi_grains_taxes_fixations.
    DATA awkey_num_range            TYPE RANGE OF awkey.
    DATA bseg_range                 TYPE RANGE OF bseg-belnr.
    DATA partner_range              TYPE bus_partner_range_t.
    DATA bank_amount_to_weight_calc TYPE zadot_grains_bil.
    DATA tax_st                     TYPE zado_grains_tax_total_bol.
    DATA nfe_edc_st_data            TYPE zados_grains_sf_bol_nfs_edc.
    DATA nfe_edc_st_sales           TYPE zados_grains_sf_bol_nfs_sales.
    DATA bank_data                  TYPE zadot_grains_bil.
    DATA fix_item                   TYPE zadoi_grains_fixing_item.
    DATA sf_data                    TYPE zados_grains_sf_data.
    DATA company_data               TYPE zadoi_grains_contract_header.
    DATA contract_detail            TYPE zadoc_grains_contract_details.
    DATA fixation_data              TYPE zadoc_grains_fixation_data.
    DATA partner_info               TYPE zi_partners.
    DATA property_info              TYPE zi_partners.
    DATA company_info               TYPE zi_partners.
    DATA company_phone_nr           TYPE lfa1.
    DATA client_phone               TYPE kna1.
    DATA partner_code               TYPE wbhk.
    DATA logs                       TYPE bapiret2_t.


    DATA: address_company         TYPE string,
          cnpj_company            TYPE char18,
          ie_company              TYPE char17,
          phone_company           TYPE char14,
          cpf_supplier            TYPE char14,
          cnpj_supplier           TYPE char18,
          ie_property             TYPE char17,
          due_date                TYPE char10,
          date_ext                TYPE string,
          taxes_amount            TYPE wt_wt,
          sales_tax_total         TYPE wt_wt,
          gross_amount_sale_debt  TYPE wt_wt,
          net_price               TYPE dec23_2,
          gross_price             TYPE dec23_2,
          net_total_price         TYPE dec23_2,
          gross_total_amount      TYPE dec23_2,
          quantity_calc           TYPE menge_d,
          quantity_print          TYPE char14,
          bag_weight_kg           TYPE i,
          net_price_brl           TYPE char14,
          gross_price_brl         TYPE char14,
          net_total_price_brl     TYPE char14,
          taxes_brl               TYPE char14,
          gross_total_amount_brl  TYPE char14,
          amount_brl              TYPE char14,
          fixed_weight_form       TYPE char14,
          net_weight_raw          TYPE /accgo/e_document_qty,
          net_weight_form         TYPE char14,
          cpf_bank_holder         TYPE char14,
          format_data             TYPE char3,
          payment_date_format     TYPE char10,
          edc_date_format         TYPE char10,
          nfs_date_format         TYPE char10,
          gross_complement_amount TYPE bapi_rmwwr,
          gross_comp_amount_brl   TYPE char14,
          appl_doc_origin_taxes   TYPE TABLE OF bseg,
          fixation_consumed_appl  TYPE TABLE OF zadot_grains_app,
          appl_data               TYPE TABLE OF zadoc_grains_appl_invoices.

    METHODS get_data.

    METHODS get_buy_tax.

    METHODS get_sale_tax.

    METHODS taxes_and_amount_per_account.

    METHODS complement_amount_calc.

    METHODS format
      IMPORTING format_case TYPE char3.

    METHODS format_numbers
      IMPORTING
                raw_value     TYPE any
                decimals      TYPE char1
      RETURNING VALUE(return) TYPE char14.

    METHODS build.

ENDCLASS.

CLASS zadocl_grains_sf_fixation_info IMPLEMENTATION.


  METHOD constructor.

    me->parameters = parameters.

    me->get_data( ).

    IF partner_code-kunnr IS INITIAL.

      me->get_buy_tax( ).

    ELSE.

      me->get_sale_tax( ).

    ENDIF.

    me->origin_tax_amount( ).

    me->taxes_and_amount_per_account( ).

    me->complement_amount_calc( ).

    me->build( ).

  ENDMETHOD.


  METHOD get_sf_data.

    return = me->sf_data.

  ENDMETHOD.

  METHOD financial_bank_fix_item_data.

    return = financial_bank_data.

  ENDMETHOD.

  METHOD nfes_edcs_data.

    return = nfes_edcs_form_data.

  ENDMETHOD.

  METHOD tax_amount_total.

    return = tax_amount_total_tab.

  ENDMETHOD.


  METHOD get_data.

    DATA doc_num TYPE char14.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = me->parameters-contract_num
      IMPORTING
        output = me->parameters-contract_num.

    "SELECT * FROM zi_partners INTO TABLE @partners_infos.

    SELECT SINGLE * FROM wbhk INTO @partner_code WHERE tkonn = @me->parameters-contract_num.

    IF partner_code-kunnr IS INITIAL.

      SELECT * FROM zadot_grains_bil INTO TABLE @fin_bank_data WHERE contractnum        = @me->parameters-contract_num
                                                                 AND identification_fix = @me->parameters-idnum.

    ENDIF.

    SELECT SINGLE * FROM zadoi_grains_fixing_item INTO @fix_item WHERE contractnum       = @me->parameters-contract_num
                                                                   AND identificationfix = @me->parameters-idnum.

    SELECT SINGLE * FROM zadoc_grains_fixation_data INTO @fixation_data WHERE ContractNum       = @me->parameters-contract_num
                                                                          AND IdentificationFix = @me->parameters-idnum.

    SELECT SINGLE * FROM t001w INTO @DATA(company_code) WHERE werks = @me->parameters-plant_nr.

    SELECT SINGLE * FROM zadoi_grains_contract_header INTO @company_data WHERE TradingContractNumber = @me->parameters-contract_num.

    SELECT SINGLE * FROM zadoc_grains_contract_details INTO @contract_detail WHERE ContractNum = @me->parameters-contract_num.

    SELECT * FROM zadoi_grains_taxes_fixations INTO TABLE @fixation_taxes WHERE contract               = @me->parameters-contract_num
                                                                            AND identificationfixation = @me->parameters-idnum
                                                                            AND plant                  = @me->parameters-plant_nr
                                                                            AND companycode            = @company_data-CompanyCode.

    SELECT * FROM zadot_grains_app INTO TABLE @fixation_consumed_appl WHERE contractnum        = @parameters-contract_num
                                                                              AND identification_fix = @parameters-idnum.
    IF sy-subrc = 0.

      SELECT * FROM zadoc_grains_appl_invoices INTO TABLE @appl_data
          FOR ALL ENTRIES IN @fixation_consumed_appl WHERE ApplicationDoc = @fixation_consumed_appl-apl_doc
                                                       AND Contract       = @parameters-contract_num.
      IF sy-subrc = 0.

        SELECT * FROM bseg INTO TABLE @appl_doc_origin_taxes
            FOR ALL ENTRIES IN @appl_data WHERE awkey = @appl_data-InvoiceRefKey.

      ENDIF.

    ENDIF.


    IF partner_code-kunnr IS INITIAL.

      SELECT * FROM zadoc_grains_sf_data_boletim INTO TABLE @nfes_edcs_tab_data WHERE ContractNum = @me->parameters-contract_num
                                                                                  AND IdFix       = @me->parameters-idnum
                                                                                  AND Plant       = @me->parameters-plant_nr.

    ELSE.

      SELECT * FROM zadoc_grains_sf_sales_nfe_bol INTO TABLE @nfes_edcs_tab_sales WHERE ContractNum = @me->parameters-contract_num
                                                                                    AND IdFix       = @me->parameters-idnum
                                                                                    AND Plant       = @me->parameters-plant_nr.

    ENDIF.

    CHECK sy-subrc = 0.

    IF partner_code-kunnr IS INITIAL.

      SELECT * FROM zadoc_grains_appl_invoices INTO TABLE @application_invoices
        FOR ALL ENTRIES IN @nfes_edcs_tab_data WHERE applicationdoc = @nfes_edcs_tab_data-applicationnum
                                                 AND reversed = ''.

    ELSE.

      SELECT * FROM zadoc_grains_appl_invoices INTO TABLE @application_invoices
        FOR ALL ENTRIES IN @nfes_edcs_tab_sales WHERE applicationdoc = @nfes_edcs_tab_sales-applicationnum
                                                  AND reversed = ''.

    ENDIF.

    CHECK sy-subrc = 0.

    SELECT * FROM rbkp INTO TABLE @header_docs_fatura
      FOR ALL ENTRIES IN @application_invoices WHERE belnr = @application_invoices-SupplierInvoice.

*   GET DATA TO CALC TAXES

    IF partner_code-kunnr IS INITIAL.

      SELECT * FROM zadoc_grains_appl_invoices INTO TABLE @invoices
        FOR ALL ENTRIES IN @nfes_edcs_tab_data WHERE contract = @nfes_edcs_tab_data-contract_num
                                                 AND reversed = ''.


      awkey_num_range = VALUE #( FOR inv     IN invoices
                                 ( option  = 'EQ'
                                   sign    = 'I'
                                   low     = inv-InvoiceRefKey ) ) .

      SELECT * FROM bseg INTO TABLE @num_documents WHERE awkey IN @awkey_num_range.

      bseg_range = VALUE #( FOR doc    IN num_documents
                              ( option = 'EQ'
                                sign   = 'I'
                                low    = doc-belnr ) ).

      SELECT * FROM with_item INTO TABLE @irf_info WHERE belnr IN @bseg_range
                                                     AND bukrs  = @company_code-vkorg.

      CHECK sy-subrc = 0.

      SELECT * FROM t059zt INTO TABLE @tax_names
        FOR ALL ENTRIES IN @irf_info WHERE witht = @irf_info-witht
                                       AND spras = 'P'.

    ELSE.

      SELECT * FROM zadoc_grains_sf_tax_sales INTO TABLE @tax_sales WHERE ContractNum = @me->parameters-contract_num.

    ENDIF.

    CLEAR: partner_range.
    IF company_data-Supplier IS NOT INITIAL.
      APPEND VALUE bus_partner_range( sign   = 'I'
                                      option = 'EQ'
                                      low    = company_data-Supplier ) TO partner_range.
    ENDIF.

    IF company_data-Customer IS NOT INITIAL.
      APPEND VALUE bus_partner_range( sign   = 'I'
                                      option = 'EQ'
                                      low    = company_data-Customer ) TO partner_range.
    ENDIF.

    IF fix_item-property IS NOT INITIAL.
      APPEND VALUE bus_partner_range( sign   = 'I'
                                      option = 'EQ'
                                      low    = fix_item-property ) TO partner_range.
    ENDIF.

    IF company_code-kunnr IS NOT INITIAL.
      APPEND VALUE bus_partner_range( sign   = 'I'
                                      option = 'EQ'
                                      low    = company_code-kunnr ) TO partner_range.
    ENDIF.

    IF partner_code-kunnr IS NOT INITIAL.
      APPEND VALUE bus_partner_range( sign   = 'I'
                                      option = 'EQ'
                                      low    = partner_code-kunnr ) TO partner_range.
    ENDIF.

    IF partner_range IS NOT INITIAL.
      SELECT * FROM zi_partners INTO TABLE @partners_infos WHERE partner IN @partner_range.
    ENDIF.

    TRY.
        IF partner_code-kunnr IS INITIAL.
          partner_info = partners_infos[ Partner = company_data-Supplier ].
        ELSE.
          partner_info = partners_infos[ Partner = company_data-Customer ].
        ENDIF.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    TRY.
        property_info = partners_infos[ Partner = fix_item-property ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    TRY.
        IF partner_code-kunnr IS INITIAL.
          company_info = partners_infos[ Partner = company_code-kunnr ].
        ELSE.
          company_info = partners_infos[ Partner = partner_code-kunnr ].
        ENDIF.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

  ENDMETHOD.


  METHOD get_buy_tax.

    TYPES: BEGIN OF tax_names_amount,
             tax_code   TYPE char4,
             tax_name   TYPE char20,
             tax_amount TYPE with_item-wt_qbshh,
           END OF tax_names_amount.

    DATA: tax_names_amount_tab  TYPE TABLE OF tax_names_amount,
          tax_name_noduplicates TYPE TABLE OF tax_names_amount,
          tax_amount_total      TYPE wt_wt.

    DATA: weight_dif TYPE p LENGTH 16 DECIMALS 4,
          amount     TYPE p LENGTH 16 DECIMALS 4.

    LOOP AT fixation_taxes ASSIGNING FIELD-SYMBOL(<fixations_value>).
      IF <fixations_value>-taxe < 0.
        <fixations_value>-Taxe = abs( <fixations_value>-taxe ).
      ENDIF.
    ENDLOOP.

    LOOP AT invoices INTO DATA(invo).

      LOOP AT num_documents INTO DATA(doc_num) WHERE awkey = invo-InvoiceRefKey
                                                 AND qsskz IS NOT INITIAL.

        TRY.
            DATA(app_num) = nfes_edcs_tab_data[ contract_num = invo-Contract
                                                     edc_num = invo-Edc ].
          CATCH cx_sy_itab_line_not_found.
            CLEAR: app_num.
        ENDTRY.

        TRY.
            DATA(irf) = irf_info[ belnr = doc_num-belnr
                                  witht = doc_num-qsskz
                                  bukrs = partner_code-company_code

                                  ].
          CATCH cx_sy_itab_line_not_found.
            CLEAR: irf.
            CONTINUE.
        ENDTRY.

        TRY.
            DATA(tax_name) = tax_names[ witht = doc_num-qsskz ].
          CATCH cx_sy_itab_line_not_found.
            CLEAR: tax_name.
        ENDTRY.

        SPLIT tax_name-text40 AT '-' INTO DATA(name) DATA(rest).

        "Valida Imposto Encontrado
        TRY.
            DATA(valid_tax) = fixation_taxes[ taxe = irf-wt_qsfhb ].

            tax_dif_calc_tab = VALUE #( BASE tax_dif_calc_tab ( contract_num = invo-Contract
                                                                nfs_num      = invo-BR_NotaFiscal
                                                                edc_num      = invo-Edc
                                                                app_num      = app_num-applicationnum
                                                                ref_key      = doc_num-awkey
                                                                doc_type     = invo-InvoiceDocType
                                                                tax_type     = doc_num-qsskz
                                                                tax_name     = name
                                                                net_weight   = invo-quantity
                                                                fixed_weight = app_num-fixed_weight
                                                                tax_amount   = irf-wt_qbshb ) ).

          CATCH cx_sy_itab_line_not_found.
            CLEAR: valid_tax.
            CONTINUE.
        ENDTRY.

      ENDLOOP.
    ENDLOOP.

    LOOP AT tax_dif_calc_tab INTO tax_dif_calc_st.

      IF tax_dif_calc_st-tax_amount <> 0.

        IF tax_dif_calc_st-doc_type = 'SD'.

          tax_names_amount_tab = VALUE #( BASE tax_names_amount_tab ( tax_code   = tax_dif_calc_st-tax_type
                                                                      tax_name   = tax_dif_calc_st-tax_name
                                                                      tax_amount = tax_dif_calc_st-tax_amount ) ).

        ELSEIF tax_dif_calc_st-doc_type = 'IV'.

          IF tax_dif_calc_st-net_weight <> tax_dif_calc_st-fixed_weight.

            TRY.

                weight_dif = tax_dif_calc_st-fixed_weight / tax_dif_calc_st-net_weight.

              CATCH cx_sy_zerodivide.

            ENDTRY.

            amount = tax_dif_calc_st-tax_amount * weight_dif.

            tax_names_amount_tab = VALUE #( BASE tax_names_amount_tab ( tax_code   = tax_dif_calc_st-tax_type
                                                                        tax_name   = tax_dif_calc_st-tax_name
                                                                        tax_amount = amount ) ).

          ELSE.

            tax_names_amount_tab = VALUE #( BASE tax_names_amount_tab ( tax_code   = tax_dif_calc_st-tax_type
                                                                        tax_name   = tax_dif_calc_st-tax_name
                                                                        tax_amount = tax_dif_calc_st-tax_amount ) ).

          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.

    tax_name_noduplicates = tax_names_amount_tab.

    SORT tax_name_noduplicates BY tax_code.

    DELETE ADJACENT DUPLICATES FROM tax_name_noduplicates COMPARING tax_code.

    LOOP AT tax_name_noduplicates INTO DATA(no_duplicate).

      LOOP AT tax_names_amount_tab INTO DATA(tax_amount_st) WHERE tax_code = no_duplicate-tax_code.

        tax_amount_total += tax_amount_st-tax_amount.

      ENDLOOP.

      tax_amount_total_tab = VALUE #( BASE tax_amount_total_tab ( tax_code = no_duplicate-tax_code
                                                                  tax_name = no_duplicate-tax_name
                                                                  tax_amount = tax_amount_total ) ).

      CLEAR: tax_amount_total.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_sale_tax.

    TYPES: BEGIN OF sales_tax_names_amount,
             tax_code   TYPE char4,
             tax_name   TYPE char20,
             tax_amount TYPE with_item-wt_qbshh,
           END OF sales_tax_names_amount.

    DATA: non_duplicates_tax_sales   TYPE TABLE OF zadoc_grains_sf_tax_sales,
          sales_tax_names_amount_tab TYPE TABLE OF sales_tax_names_amount,
          amount_total               TYPE wt_wt.

    non_duplicates_tax_sales = tax_sales.

    SORT non_duplicates_tax_sales BY CondType.
    DELETE ADJACENT DUPLICATES FROM non_duplicates_tax_sales COMPARING CondType.

    LOOP AT non_duplicates_tax_sales INTO DATA(non_duplicate_tax).

      LOOP AT tax_sales INTO DATA(tax_sale) WHERE CondType = non_duplicate_tax-CondType.
        amount_total  += tax_sale-CondValue.
      ENDLOOP.

      sales_tax_names_amount_tab = VALUE #( BASE sales_tax_names_amount_tab ( tax_code = tax_sale-CondType
                                                                                   tax_name = COND #( WHEN tax_sale-CondType = 'ZFDM' THEN 'FUNDEMS'
                                                                                                      WHEN tax_sale-CondType = 'ZFDS' THEN 'FUNDERSUL'
                                                                                                      WHEN tax_sale-CondType = 'ZCMI' THEN 'Valor Bruto'
                                                                                                      WHEN tax_sale-CondType = 'ZFHB' THEN 'FETHAB')
                                                                                   tax_amount = amount_total ) ).

      CLEAR: amount_total.
    ENDLOOP.

    sales_tax_total = REDUCE #( INIT val = 0
                                       FOR wa IN
                                        sales_tax_names_amount_tab
                                                 WHERE ( tax_code <> 'ZCMI' )
                                                 NEXT val = val + wa-tax_amount ).

    gross_amount_sale_debt = sales_tax_names_amount_tab[ tax_code = 'ZCMI' ]-tax_amount.

  ENDMETHOD.

  METHOD complement_amount_calc.

    DATA: headerdata          TYPE bapi_incinv_detail_header,
          itemdata            TYPE STANDARD TABLE OF bapi_incinv_detail_item,
          materialdata        TYPE  TABLE OF bapi_incinv_detail_material,
          taxdata             TYPE STANDARD TABLE OF bapi_incinv_detail_tax,
          vendoritemsplitdata TYPE STANDARD TABLE OF bapi_incinv_detail_vendorsplit,
          withtaxdata         TYPE TABLE OF bapi_incinv_detail_withtax,
          bapi_return         TYPE TABLE OF bapiret2.

    LOOP AT header_docs_fatura INTO DATA(header_doc).

      IF header_doc-rbstat <> '5'.

        CALL FUNCTION 'BAPI_INCOMINGINVOICE_GETDETAIL'
          EXPORTING
            invoicedocnumber    = header_doc-belnr
            fiscalyear          = header_doc-gjahr
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

        LOOP AT itemdata INTO DATA(item). "Dados de itens de Pedido
          gross_complement_amount += item-item_amount.
        ENDLOOP.

        LOOP AT materialdata INTO DATA(material). "Dados de Materiais
          gross_complement_amount += material-item_amount.
        ENDLOOP.

        LOOP AT taxdata INTO DATA(tax). "Impostos
          gross_complement_amount += tax-tax_amount.
        ENDLOOP.

        LOOP AT withtaxdata INTO DATA(irf). "Impostos retidos na fonte
          gross_complement_amount += irf-wi_tax_amt.
        ENDLOOP.

      ELSE.
        CONTINUE.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD taxes_and_amount_per_account.

    DATA: quantity_total_fin_data TYPE zadode_grains_quantity,
          percent_qtd_to_amount   TYPE dec11_4,
          net_amount_per_account  TYPE dmbtr.

    LOOP AT tax_amount_total_tab INTO DATA(tax_sum_total).
      DATA(index) = sy-tabix.

      taxes_amount -= tax_sum_total-tax_amount.

    ENDLOOP.

    format_data = 'TXA'.

    me->format( format_data ).

    bag_weight_kg = 60.

    quantity_calc = fix_item-Quantity.


    TRY.

        IF partner_code-kunnr IS INITIAL.
          net_total_price =    ( ( fix_item-Quantity / bag_weight_kg ) * fix_item-Bagprice ) - taxes_amount.
          gross_total_amount = ( ( fix_item-Quantity / bag_weight_kg ) * fix_item-Bagprice ).

        ELSE.
          net_total_price = gross_amount_sale_debt - sales_tax_total.
          gross_total_amount = gross_amount_sale_debt.

        ENDIF.
        net_price =              net_total_price / ( fix_item-Quantity / bag_weight_kg  ).
        gross_price =        ( ( fix_item-Quantity / bag_weight_kg ) * fix_item-Bagprice ) / ( fix_item-Quantity / bag_weight_kg ).

      CATCH cx_sy_zerodivide.

        net_price = '0'.
        gross_price = '0'.

    ENDTRY.


    quantity_total_fin_data = REDUCE #( INIT val = 0
                                        FOR wa IN fin_bank_data NEXT val += wa-quantity ).

    LOOP AT fin_bank_data ASSIGNING FIELD-SYMBOL(<weight_to_amount>).

      percent_qtd_to_amount = <weight_to_amount>-quantity / quantity_total_fin_data.

      net_amount_per_account = net_total_price * percent_qtd_to_amount.

      <weight_to_amount>-amount = net_amount_per_account.

    ENDLOOP.

  ENDMETHOD.

  METHOD build.

    format_data = 'SFD'.

    me->format( format_data ).

    sf_data = VALUE zados_grains_sf_data( company_code       = contract_detail-CompanyCode
                                          company_name       = company_info-PartnerName
                                          company_address    = address_company
                                          company_cnpj       = cnpj_company
                                          company_ie         = ie_company
                                          company_phone      = phone_company
                                          date_ext           = date_ext
                                          created_by         = fixation_data-CreatedBy
                                          fixation_id        = me->parameters-idnum
                                          contract_nr        = fixation_data-ContractNum
                                          warehouse          = contract_detail-WareHouse
                                          supplier_name      = partner_info-PartnerName
                                          supplier_city      = |{ partner_info-City }-{ partner_info-Region }|
                                          supplier_cpf_cnpj  = COND #( WHEN partner_info-cpf IS NOT INITIAL THEN cpf_supplier
                                                                       ELSE cnpj_supplier )
                                          property_name      = property_info-Vocativo
                                          property_ie        = ie_property
                                          product_desc       = contract_detail-Material
                                          harvest            = contract_detail-Safra
                                          weight             = quantity_print
                                          unit_measure       = fixation_data-Unit
                                          net_price          = net_price_brl
                                          gross_price        = gross_price_brl
                                          net_total_price    = net_total_price_brl
                                          gross_total_price  = gross_total_amount_brl
                                          taxes_amount       = taxes_brl
                                          discount_total     = taxes_brl
                                          total_compensated  = taxes_brl
                                          net_amount_total   = net_total_price_brl
                                          currency           = fixation_data-Currency
                                          balance_receivable = net_total_price_brl
                                          gross_comp_amount  = gross_comp_amount_brl ).

    LOOP AT fin_bank_data INTO bank_data.

      TRY.

          cpf_bank_holder = partners_infos[ Partner = company_data-Supplier ]-cpf.

        CATCH cx_sy_itab_line_not_found.

      ENDTRY.

      format_data = 'FBD'.

      me->format( format_data ).

      financial_bank_data = VALUE #( BASE financial_bank_data ( contract_num   = COND #( WHEN partner_code-kunnr IS INITIAL THEN bank_data-ContractNum        ELSE fixation_data-ContractNum )
                                                                idfix          = COND #( WHEN partner_code-kunnr IS INITIAL THEN bank_data-identification_fix ELSE fixation_data-IdentificationFix )
                                                                installment    = COND #( WHEN partner_code-kunnr IS INITIAL THEN bank_data-Installment        ELSE '' )
                                                                plant          = COND #( WHEN partner_code-kunnr IS INITIAL THEN bank_data-Plant              ELSE fixation_data-plant )
                                                                amount         = amount_brl
                                                                currency       = COND #( WHEN partner_code-kunnr IS INITIAL THEN bank_data-Currency           ELSE fixation_data-currency )
                                                                quantity       = COND #( WHEN partner_code-kunnr IS INITIAL THEN bank_data-Quantity           ELSE fixation_data-Quantity )
                                                                unit           = COND #( WHEN partner_code-kunnr IS INITIAL THEN bank_data-Unit               ELSE '' )
                                                                bank           = COND #( WHEN partner_code-kunnr IS INITIAL THEN bank_data-Bank               ELSE '' )
                                                                bankagency     = COND #( WHEN partner_code-kunnr IS INITIAL THEN bank_data-BankAgency         ELSE '' )
                                                                bankaccount    = COND #( WHEN partner_code-kunnr IS INITIAL THEN bank_data-BankAccount        ELSE '' )
                                                                bankholder     = COND #( WHEN partner_code-kunnr IS INITIAL THEN bank_data-BankHolder         ELSE '' )
                                                                paymentdate    = payment_date_format
                                                                bankholder_cpf = COND #( WHEN partner_code-kunnr IS INITIAL THEN cpf_bank_holder              ELSE '' ) ) ).

    ENDLOOP.

    IF partner_code-kunnr IS INITIAL.

      LOOP AT nfes_edcs_tab_data INTO nfe_edc_st_data.

        format_data = 'NED'.

        TRY.
            net_weight_raw = application_invoices[ Contract = nfe_edc_st_data-contract_num ApplicationDoc = nfe_edc_st_data-applicationnum ]-Quantity.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.

        me->format( format_data ).

        nfes_edcs_form_data = VALUE #( BASE nfes_edcs_form_data ( contract_num   = nfe_edc_st_data-contract_num
                                                                  idfix          = nfe_edc_st_data-idfix
                                                                  edc_num        = nfe_edc_st_data-edc_num
                                                                  applicationnum = nfe_edc_st_data-applicationnum
                                                                  edc_date       = edc_date_format
                                                                  nfs_num        = |{ nfe_edc_st_data-nfs_num }-{ nfe_edc_st_data-nfs_series }|
                                                                  nfs_date       = nfs_date_format
                                                                  net_weight     = net_weight_form
                                                                  fixed_weight   = fixed_weight_form ) ).

      ENDLOOP.

    ELSE.

      LOOP AT nfes_edcs_tab_sales INTO nfe_edc_st_sales.

        format_data = 'NED'.

        TRY.

            net_weight_raw = application_invoices[ Contract = nfe_edc_st_data-contract_num ApplicationDoc = nfe_edc_st_data-applicationnum ]-Quantity.

          CATCH cx_sy_itab_line_not_found.
        ENDTRY.

        me->format( format_data ).

        nfes_edcs_form_data = VALUE #( BASE nfes_edcs_form_data ( contract_num   = nfe_edc_st_sales-contract_num
                                                                  idfix          = nfe_edc_st_sales-idfix
                                                                  edc_num        = nfe_edc_st_sales-edc_num
                                                                  applicationnum = nfe_edc_st_sales-applicationnum
                                                                  edc_date       = edc_date_format
                                                                  nfs_num        = |{ nfe_edc_st_sales-nfs_num }-{ nfe_edc_st_sales-nfs_series }|
                                                                  nfs_date       = nfs_date_format
                                                                  net_weight     = net_weight_form
                                                                  fixed_weight   = fixed_weight_form ) ).

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD format.

    CASE format_data.

      WHEN 'SFD'.

        DATA: day              TYPE p,
              weekdays         TYPE TABLE OF t246,
              months           TYPE TABLE OF t247,
              weekday_ext      TYPE char13,
              month_ext        TYPE char9,
              date             TYPE datum,
              date_time        TYPE char14,
              amount           TYPE char40,
              edc_date_create  TYPE numc15,
              payment_date_raw TYPE numc15.

        date_time = fixation_data-CreatedOn.

        date = date_time(8).

        CALL FUNCTION 'DAY_IN_WEEK'
          EXPORTING
            datum = date
          IMPORTING
            wotnr = day.

        CALL FUNCTION 'WEEKDAY_GET'
          EXPORTING
            language          = sy-langu
          TABLES
            weekday           = weekdays
          EXCEPTIONS
            weekday_not_found = 1
            OTHERS            = 2.

        CALL FUNCTION 'MONTH_NAMES_GET'
          EXPORTING
            language              = sy-langu
          TABLES
            month_names           = months
          EXCEPTIONS
            month_names_not_found = 1.

        TRY.

            weekday_ext = weekdays[ wotnr = day ]-langt.

          CATCH cx_sy_itab_line_not_found.

        ENDTRY.

        TRY.

            month_ext = months[ mnr = date+4(2) ]-ltx.

          CATCH cx_sy_itab_line_not_found.

        ENDTRY.

        date_ext = |{ weekday_ext }, { date+6(2) } de { month_ext } de { date(4) }|.

        address_company = |{ company_info-Street }, No { company_info-HouseNumber }, { company_info-District }, CEP: { company_info-PostalCode }|.
        WRITE company_info-cnpj         USING EDIT MASK 'RR__.___.___/____-__' TO cnpj_company.
        WRITE company_info-ie           USING EDIT MASK 'RR___.___.___.___'    TO ie_company.
        WRITE company_info-DefaultPhone USING EDIT MASK 'RR(__) ____-____'     TO phone_company.

        IF partner_info-cpf IS NOT INITIAL.
          WRITE partner_info-cpf        USING EDIT MASK 'RR___.___.___-__'     TO cpf_supplier.
        ELSE.
          WRITE partner_info-cnpj       USING EDIT MASK 'RR__.___.___/____-__' TO cnpj_supplier.
        ENDIF.

        WRITE property_info-ie          USING EDIT MASK 'RR___.___.___.___'    TO ie_property.

        SHIFT cnpj_company  LEFT DELETING LEADING ' '.
        SHIFT ie_company    LEFT DELETING LEADING ' '.
        SHIFT phone_company LEFT DELETING LEADING ' '.
        SHIFT cpf_supplier  LEFT DELETING LEADING ' '.
        SHIFT cnpj_supplier LEFT DELETING LEADING ' '.
        SHIFT ie_property   LEFT DELETING LEADING ' '.

        quantity_print = me->format_numbers( raw_value = quantity_calc decimals = '3' ).

        net_price_brl = me->format_numbers( raw_value = net_price decimals = '2' ).

        net_total_price_brl = me->format_numbers( raw_value = net_total_price decimals = '2' ).

        gross_price_brl = me->format_numbers( raw_value = gross_price decimals = '2' ).

        taxes_brl = me->format_numbers( raw_value = taxes_amount decimals = '2' ).

        REPLACE ALL OCCURRENCES OF '-' IN taxes_brl WITH ''.

        gross_total_amount_brl = me->format_numbers( raw_value = gross_total_amount decimals = '2' ).

        gross_comp_amount_brl = me->format_numbers( raw_value = gross_complement_amount decimals = '2').


      WHEN 'FBD'.

* FORMAT bank_data

        IF partner_code-kunnr IS INITIAL.

          amount_brl = me->format_numbers( raw_value = bank_data-Amount decimals = '2' ).

          payment_date_format = |{ bank_data-PaymentDate+6(2) }/{ bank_data-PaymentDate+4(2) }/{ bank_data-PaymentDate(4) }|.

        ELSE.

          amount_brl = me->format_numbers( raw_value = fixation_data-Amount decimals = '2' ).

          payment_date_raw = fixation_data-PaymentDate.

          payment_date_format = |{ payment_date_raw+6(2) }/{ payment_date_raw+4(2) }/{ payment_date_raw(4) }|.

        ENDIF.

        WRITE cpf_bank_holder USING EDIT MASK 'RR___.___.___-__' TO cpf_bank_holder.

      WHEN 'NED'.

* FORMAT Nfe/EDC data.

        IF partner_code-kunnr IS INITIAL.

          edc_date_create = nfe_edc_st_data-edc_date.

          SHIFT edc_date_create LEFT DELETING LEADING '0'.

          edc_date_format = |{ edc_date_create+6(2) }/{ edc_date_create+4(2) }/{ edc_date_create(4) }|.

          nfs_date_format = |{ nfe_edc_st_data-nfs_date+6(2) }/{ nfe_edc_st_data-nfs_date+4(2) }/{ nfe_edc_st_data-nfs_date(4) }|.

          net_weight_form = me->format_numbers( raw_value = net_weight_raw decimals = '3' ).

          fixed_weight_form = me->format_numbers( raw_value = nfe_edc_st_data-fixed_weight decimals = '3' ).

        ELSE.

          edc_date_create = nfe_edc_st_sales-edc_date.

          SHIFT edc_date_create LEFT DELETING LEADING '0'.

          edc_date_format = |{ edc_date_create+6(2) }/{ edc_date_create+4(2) }/{ edc_date_create(4) }|.

          nfs_date_format = |{ nfe_edc_st_sales-nfs_date+6(2) }/{ nfe_edc_st_sales-nfs_date+4(2) }/{ nfe_edc_st_sales-nfs_date(4) }|.

          net_weight_form = me->format_numbers( raw_value = net_weight_raw decimals = '3' ).

          fixed_weight_form = me->format_numbers( raw_value = nfe_edc_st_sales-fixed_weight decimals = '3' ).

        ENDIF.

      WHEN 'TXA'.

        DATA: amount_formatted TYPE char14.

        LOOP AT tax_amount_total_tab INTO DATA(tax_sum_total).
          DATA(index) = sy-tabix.

          amount_formatted = me->format_numbers( raw_value = tax_sum_total-tax_amount decimals = '2').

          REPLACE ALL OCCURRENCES OF '-' IN amount_formatted WITH ''.

          CONDENSE amount_formatted NO-GAPS.

          tax_st = VALUE #( tax_code = tax_sum_total-tax_code
                            tax_name = tax_sum_total-tax_name
                            tax_amount = amount_formatted ).

          MODIFY tax_amount_total_tab FROM tax_st INDEX index.

        ENDLOOP.

    ENDCASE.

  ENDMETHOD.

  METHOD format_numbers.

    CASE decimals.

      WHEN '2'.

        CALL FUNCTION 'CONVERSION_EXIT_DEC2_OUTPUT'
          EXPORTING
            input  = raw_value
          IMPORTING
            output = return.

        CONDENSE return NO-GAPS.

      WHEN '3'.

        CALL FUNCTION 'CONVERSION_EXIT_DEC3_OUTPUT'
          EXPORTING
            input  = raw_value
          IMPORTING
            output = return.

        CONDENSE return NO-GAPS.

    ENDCASE.

  ENDMETHOD.

  METHOD origin_tax_amount.

    DATA(actual_documents) = VALUE belnr_ran_tab( FOR document IN fixation_taxes ( sign = 'I' option = 'EQ' low = document-AccountingDocument  ) ).

    DELETE appl_doc_origin_taxes WHERE belnr IN actual_documents.

    LOOP AT fixation_consumed_appl INTO DATA(application).

      TRY.

          DATA(origin_appl) = appl_data[ ApplicationDoc = application-apl_doc InvoiceDocType = 'IV' ].

          LOOP AT tax_amount_total_tab ASSIGNING FIELD-SYMBOL(<tax>).

            DATA(origin_appl_tax_amount) = CONV dmbtr( appl_doc_origin_taxes[ qsskz = <tax>-tax_code awkey = origin_appl-InvoiceRefKey ]-dmbtr * application-quantity / origin_appl-Quantity ).

            <tax>-tax_amount -= origin_appl_tax_amount.

          ENDLOOP.

        CATCH cx_sy_itab_line_not_found.

      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
