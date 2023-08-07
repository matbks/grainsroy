CLASS zadocl_grains_sales_fix_create DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: new_fixation    TYPE zados_grains_create_fixation,
          log             TYPE bapiret2_tt,
          fixation_header TYPE zadoc_grains_fixation_data,
          applications    TYPE TABLE OF zadoc_grains_consumed_appl.

    METHODS         constructor
      IMPORTING new_fixation TYPE zadott_grains_create_fixation.

    METHODS execute
      RETURNING VALUE(return) TYPE bapiret2_tt.

  PRIVATE SECTION.
    METHODS send_fixation.

    METHODS create_fixation.

    METHODS get_fixation_data.

    METHODS add_fixation_code.

    METHODS get_new_fixation_num
      RETURNING VALUE(return) TYPE wlf_pr_count.

    METHODS get_timestamp
      RETURNING VALUE(return) TYPE tzntstmps.

    METHODS convert_date
      CHANGING date TYPE zadode_grains_payment_date.

ENDCLASS.

CLASS zadocl_grains_sales_fix_create IMPLEMENTATION.

  METHOD execute.
    me->send_fixation( ).

    me->get_fixation_data( ).

    me->create_fixation( ).

    return = me->log.
  ENDMETHOD.

  METHOD create_fixation.
    DATA: fixation_data           TYPE /accgo/tt_price_fixation_api,
          new_fixation_num        TYPE cpet_seqno,
          before_new_fixation_num TYPE cpet_seqno,
          ls_updflag              TYPE /accgo/cak_s_ui_itm_upd_flags.

    CHECK NOT line_exists( me->log[ type = 'E' ] ).

    new_fixation_num = me->get_new_fixation_num( ).

    fixation_data = VALUE #( (  tposn = '000010'
                                condition_type =  VALUE #( ( condition_type = 'ACFT'
                                                             term_quan = me->fixation_header-Quantity
                                                             term_quan_unit = 'KG'
                                                             grp_seqno = new_fixation_num
                                                             rate = fixation_header-FuturePrice * 100
                                                             curr = 'USD'
                                                             per_quantity = 100
                                                             per_unit_of_measure = 'BU'
                                                             fixexchrate = fixation_header-DolarQuotation
                                                             maturity_code = fixation_header-KeydateCode
                                                             dcsid = fixation_header-CommodityId
                                                             mic = fixation_header-Mic
                                                             contract_number = me->fixation_header-ContractNum
                                                             contract_item_number = '000010'
                                                             new_keydate = me->fixation_header-PaymentDate
                                                             new_contract_code = fixation_header-KeydateCode )
                                                           (
                                                             condition_type = 'ACBS'
                                                             term_quan = me->fixation_header-Quantity
                                                             term_quan_unit = 'KG'
                                                             grp_seqno = new_fixation_num
                                                             rate = fixation_header-BasisPrice * 100
                                                             curr = 'USD' per_quantity = 100
                                                             per_unit_of_measure = 'BU'
                                                             fixexchrate = fixation_header-DolarQuotation
                                                             dcsid = fixation_header-CommodityId
                                                             mic = fixation_header-Mic
                                                             contract_number = me->fixation_header-ContractNum
                                                             contract_item_number = '000010'
                                                             is_basis = 'X' ) ) prc_approach = 'FB' ) ).

    /accgo/cl_cak_gen_bl=>get_instance( me->fixation_header-ContractNum )->get_item_data( EXPORTING iv_tposn = CONV #( '000010'  )
                                                                                          IMPORTING et_item_data = DATA(lt_item_data)
                                                                                                    ev_from_db   = DATA(lv_from_db) ).
    LOOP AT lt_item_data ASSIGNING FIELD-SYMBOL(<fs_item>).
      <fs_item>-pricing_approach = 'FB'.
    ENDLOOP.

    ls_updflag-cpe = abap_on.
    /accgo/cl_cak_gen_bl=>get_instance( me->fixation_header-ContractNum )->set_item_data( EXPORTING it_item_data = lt_item_data[]
                                                                                                    is_upd_flag  = ls_updflag ).

    CALL FUNCTION '/ACCGO/CCAK_PRCFIXATION'
      EXPORTING
        iv_contract       = me->fixation_header-ContractNum
        it_price_fixation = fixation_data.

    before_new_fixation_num = me->get_new_fixation_num(  ).

    IF before_new_fixation_num > new_fixation_num.
      me->log = VALUE #( BASE me->log ( type = 'S' id = 'ZADO_GRAINS' log_no = 019 ) ). "Fixação realizada com sucesso.
      me->add_fixation_code( ).
    ELSE.
      me->log = VALUE #( BASE me->log ( type = 'E' id = 'ZADO_GRAINS' log_no = 018 ) ). "Falha ao realizar a fixação.
    ENDIF.
  ENDMETHOD.

  METHOD send_fixation.
    DATA: applications TYPE TABLE OF zadot_grains_app,
          billing      TYPE TABLE OF zadot_grains_bil,
          fixation     TYPE zadot_grains_fix.

    me->convert_date( CHANGING date = me->new_fixation-paymentdate ).

    fixation = VALUE #( plant              = me->new_fixation-plant
                        contractnum        = me->new_fixation-contract
                        identification_fix = me->new_fixation-identification
                        material           = me->new_fixation-material
                        materialnum        = me->new_fixation-materialnum
                        quantity           = me->new_fixation-quantity
                        unit               = me->new_fixation-unit
                        amount             = me->new_fixation-amount
                        basis_price        = me->new_fixation-basisprice
                        future_price       = me->new_fixation-futureprice
                        currency           = me->new_fixation-currency
                        bagprice           = me->new_fixation-bagprice
                        keydate_code       = me->new_fixation-keydatecode
                        dolar_quotation    = me->new_fixation-dolarquotation
                        createdon          = me->get_timestamp( )
                        payment_date       = me->new_fixation-paymentdate
                        status             = 'S' ).

    applications = VALUE #( FOR application IN me->new_fixation-applicationdata WHERE ( applicationquantity IS NOT INITIAL )
                               ( plant              = me->new_fixation-plant
                                 contractnum        = me->new_fixation-contract
                                 apl_doc            = application-applicationdoc
                                 edcnum             = application-edcnum
                                 identification_fix = me->new_fixation-identification
                                 quantity           = application-applicationquantity
                                 measure            = application-measure ) ).

    IF fixation IS NOT INITIAL AND applications IS NOT INITIAL .
      MODIFY zadot_grains_app FROM TABLE applications.
      MODIFY zadot_grains_fix FROM fixation.
    ENDIF.

    IF sy-subrc = 0.
      COMMIT WORK AND WAIT.
      APPEND VALUE #( type = 'S' id = 'ZADO_GRAINS' number = 035 ) TO me->log. "Fixação gravada com sucesso.
    ENDIF.

  ENDMETHOD.

  METHOD constructor.
    TRY.
        me->new_fixation = new_fixation[ 1 ] .
      CATCH cx_sy_itab_line_not_found.
        me->log = VALUE #( ( type = 'E' id = 'ZADO_GRAINS' number = 026  ) ). "Não foram encontrados dados para fixação.
    ENDTRY.
  ENDMETHOD.

  METHOD get_fixation_data.
    CHECK NOT line_exists( me->log[ type = 'E' ] ).

    SELECT SINGLE * FROM zadoc_grains_fixation_data INTO @fixation_header WHERE IdentificationFix = @me->new_fixation-identification
                                                                            AND Contractnum       = @me->new_fixation-Contract
                                                                            AND Eliminated        = @abap_false.
    IF fixation_header IS NOT INITIAL.
      SELECT * FROM zadoc_grains_consumed_appl INTO TABLE @applications WHERE ContractNum = @me->new_fixation-Contract
                                                                          AND FixationId  = @me->new_fixation-identification
                                                                          ORDER BY EdcNum ASCENDING.
    ENDIF.

    IF applications IS INITIAL.
      me->log = VALUE #( BASE me->log ( type = 'E' id = 'ZADO_GRAINS' number = 017 ) ). "Não foi possível encontrar os dados da fixação.
    ENDIF.
  ENDMETHOD.

  METHOD get_timestamp.
    CHECK NOT line_exists( me->log[ type = 'E' ] ).

    DATA: timestamp_location TYPE timestampl,
          time_zone          TYPE tznzone.

    SELECT SINGLE * FROM zadot_grains_015 INTO @DATA(place_data) WHERE plant = @me->new_fixation-plant.

    SELECT SINGLE * FROM t001w INTO @DATA(location_data) WHERE werks = @me->new_fixation-plant.

    CALL FUNCTION 'TZON_LOCATION_TIMEZONE'
      EXPORTING
        if_country        = location_data-land1
        if_region         = location_data-regio
        if_zipcode        = location_data-pstlz
      IMPORTING
        ef_timezone       = time_zone
      EXCEPTIONS
        no_timezone_found = 1
        OTHERS            = 2.

    IF sy-subrc = 0.
      GET TIME STAMP FIELD timestamp_location.
      CONVERT TIME STAMP timestamp_location
          TIME ZONE time_zone INTO DATE DATA(date) TIME DATA(time).

      return = |{ date }{ time }|.
    ENDIF.
  ENDMETHOD.

  METHOD add_fixation_code.
    CHECK NOT line_exists( me->log[ type = 'E' ] ).

    SELECT SINGLE MAX( src_lt_id ) FROM /accgo/t_pr_asp INTO @DATA(approvals_fixations) WHERE tkonn = @me->fixation_header-ContractNum
                                                                                         GROUP BY tkonn.
    IF sy-subrc = 0.
      UPDATE zadot_grains_fix
        SET status      = 'T'
            fixation_id = approvals_fixations
      WHERE contractnum = me->fixation_header-ContractNum AND identification_fix = me->fixation_header-IdentificationFix.
      IF sy-subrc <> 0.
        me->log = VALUE #( BASE me->log ( type = 'E' id = 'ZADO_GRAINS' number = 020 ) ). "Falha ao atribuir id da precificação ao contrato.
      ELSE.
        COMMIT WORK AND WAIT.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD get_new_fixation_num.
    SELECT SINGLE MAX( pr_count ) FROM /accgo/t_pr_asp INTO @DATA(last_fix_num) WHERE tkonn = @me->fixation_header-ContractNum
                                                                                  GROUP BY tkonn.
    return = last_fix_num + 1.
  ENDMETHOD.

  METHOD convert_date.
    date = |{ date+4(4) }{ date+2(2) }{ date(2) }|.
  ENDMETHOD.

ENDCLASS.
