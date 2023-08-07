CLASS zadocl_grains_create_fixation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING contractnum TYPE tkonn
                fixation_id TYPE zadode_grains_origin_fix.

    METHODS execute
      RETURNING VALUE(return) TYPE bapiret2_tt.

  PRIVATE SECTION.

    DATA: fixation_header TYPE zadoc_grains_fixation_data,
          applications    TYPE TABLE OF zadoc_grains_consumed_appl,
          billing         TYPE zadoc_grains_fixation_bill,
          fixation_id     TYPE zadode_grains_origin_fix,
          contractnum     TYPE tkonn,
          log             TYPE bapiret2_tt.

    METHODS create.

    METHODS get_fixation_data.

    METHODS add_fixation_code.

    METHODS get_new_fixation_num
      RETURNING VALUE(return) TYPE wlf_pr_count.

    METHODS update_royalties_block_quan.

ENDCLASS.

CLASS zadocl_grains_create_fixation IMPLEMENTATION.



  METHOD constructor.
    me->contractnum = contractnum.
    me->fixation_id = fixation_id.
  ENDMETHOD.



  METHOD execute.
    me->get_fixation_data( ).
    me->create( ).
    me->update_royalties_block_quan(  ).
    return = me->log.
  ENDMETHOD.



  METHOD create.
    DATA: fixation_data           TYPE /accgo/tt_price_fixation_api,
          new_fixation_num        TYPE cpet_seqno,
          before_new_fixation_num TYPE cpet_seqno,
          ls_updflag              TYPE /accgo/cak_s_ui_itm_upd_flags.

    CHECK NOT line_exists( me->log[ type = 'E' ] ).

    new_fixation_num = me->get_new_fixation_num( ).

    fixation_data = VALUE #( (  tposn = '000010'
                                condition_type =  VALUE #( ( condition_type       = 'ACFT'
                                                             term_quan            = me->fixation_header-Quantity
                                                             term_quan_unit       = 'KG'
                                                             grp_seqno            = new_fixation_num
                                                             rate                 = fixation_header-FuturePrice * 100
                                                             curr                 = 'USD'
                                                             per_quantity         = 100
                                                             per_unit_of_measure  = 'BU'
                                                             fixexchrate          = fixation_header-DolarQuotation
                                                             maturity_code        = fixation_header-KeydateCode
                                                             dcsid                = fixation_header-CommodityId
                                                             mic                  = fixation_header-Mic
                                                             contract_number      = me->contractnum
                                                             contract_item_number = '000010'
                                                             new_keydate          = me->fixation_header-PaymentDate
                                                             new_contract_code    = fixation_header-KeydateCode )
                                                           (
                                                             condition_type       = 'ACBS'
                                                             term_quan            = me->fixation_header-Quantity
                                                             term_quan_unit       = 'KG'
                                                             grp_seqno            = new_fixation_num
                                                             rate                 = fixation_header-BasisPrice * 100
                                                             curr                 = 'USD' per_quantity = 100
                                                             per_unit_of_measure  = 'BU'
                                                             fixexchrate          = fixation_header-DolarQuotation
                                                             dcsid                = fixation_header-CommodityId
                                                             mic                  = fixation_header-Mic
                                                             contract_number      = me->contractnum
                                                             contract_item_number = '000010'
                                                             is_basis             = 'X' ) ) prc_approach = 'FB' ) ).

    /accgo/cl_cak_gen_bl=>get_instance( me->contractnum )->get_item_data( EXPORTING iv_tposn     = CONV #( '000010'  )
                                                                          IMPORTING et_item_data = DATA(lt_item_data)
                                                                                    ev_from_db   = DATA(lv_from_db) ).
    LOOP AT lt_item_data ASSIGNING FIELD-SYMBOL(<fs_item>).
      <fs_item>-pricing_approach = 'FB'.
    ENDLOOP.

    ls_updflag-cpe = abap_on.
    /accgo/cl_cak_gen_bl=>get_instance( me->contractnum )->set_item_data( EXPORTING it_item_data = lt_item_data[]
                                                                                    is_upd_flag  = ls_updflag ).

    CALL FUNCTION '/ACCGO/CCAK_PRCFIXATION'
      EXPORTING
        iv_contract       = me->contractnum
        it_price_fixation = fixation_data.


    APPEND zadocl_grains_utilities=>get_msg( type   = sy-msgty
                                             id     = sy-msgid
                                             number = sy-msgno
                                             var1   = sy-msgv1
                                             var2   = sy-msgv2
                                             var3   = sy-msgv3
                                             var4   = sy-msgv4 ) TO me->log.

    IF sy-msgid = '/ACCGO/ACM_COMMON' AND sy-msgno = '065'.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

    before_new_fixation_num = me->get_new_fixation_num(  ).

    IF before_new_fixation_num > new_fixation_num.
      APPEND zadocl_grains_utilities=>get_msg( type = 'S'   id = 'ZADO_GRAINS'    number = '019' ) TO me->log. "Fixação realizada com sucesso.
      me->add_fixation_code( ).
    ELSE.
      APPEND zadocl_grains_utilities=>get_msg( type = 'E'   id = 'ZADO_GRAINS'    number = '018' ) TO me->log. "Falha ao realizar a fixação.
    ENDIF.

  ENDMETHOD.



  METHOD get_fixation_data.

    SELECT SINGLE * FROM zadoc_grains_fixation_data INTO @fixation_header WHERE IdentificationFix = @me->fixation_id
                                                                             AND Contractnum = @me->contractnum
                                                                             AND Eliminated  = @abap_false.
    IF fixation_header IS NOT INITIAL.
      SELECT * FROM zadoc_grains_consumed_appl INTO TABLE @applications WHERE ContractNum = @me->fixation_header-ContractNum
                                                                          AND FixationId  = @me->fixation_header-IdentificationFix
                                                                          ORDER BY EdcNum ASCENDING.

      SELECT SINGLE * FROM zadoc_grains_fixation_bill INTO @billing WHERE ContractNum = @me->fixation_header-ContractNum
                                                                      AND FixationId  = @me->fixation_header-IdentificationFix.
    ENDIF.

    IF applications IS INITIAL OR billing IS INITIAL.
      APPEND zadocl_grains_utilities=>get_msg( type = 'E'   id = 'ZADO_GRAINS'    number = '017' ) TO me->log. "Não foi possível encontrar os dados da fixação.
    ENDIF.

  ENDMETHOD.



  METHOD add_fixation_code.

    SELECT SINGLE MAX( src_lt_id ) FROM /accgo/t_pr_asp  WHERE tkonn = @me->contractnum
                                                      GROUP BY tkonn
                                                          INTO @DATA(source_lot_id).
    IF sy-subrc = 0.

      SELECT SINGLE * FROM zadot_grains_fix WHERE contractnum        = @me->contractnum
                                              AND identification_fix = @me->fixation_id
                                             INTO @DATA(fixation_header).

      SELECT * FROM zadot_grains_bil WHERE contractnum        = @fixation_header-contractnum
                                       AND identification_fix = @fixation_header-identification_fix
                                      INTO TABLE @DATA(fixation_installments).

      IF sy-subrc = 0.

        fixation_header-status      = 'T'.
        fixation_header-fixation_id = source_lot_id.

        DATA(change_return) = NEW zadocl_grains_change_fixation( fixation = fixation_header )->change( ).
        APPEND change_return TO me->log.

        LOOP AT fixation_installments ASSIGNING FIELD-SYMBOL(<fixation_installment>).
          <fixation_installment>-fixation_id = source_lot_id.
        ENDLOOP.

        MODIFY zadot_grains_bil FROM TABLE fixation_installments.
        COMMIT WORK AND WAIT.

      ELSE.
        APPEND zadocl_grains_utilities=>get_msg( type = 'E'    id = 'ZADO_GRAINS'   number = '020' ) TO me->log. "Falha ao atribuir id da precificação ao contrato.
      ENDIF.

    ENDIF.
  ENDMETHOD.



  METHOD get_new_fixation_num.
    SELECT SINGLE MAX( pr_count ) FROM /accgo/t_pr_asp INTO @DATA(last_fix_num) WHERE tkonn = @me->contractnum
                                                                                  GROUP BY tkonn.
    return = last_fix_num + 1.
  ENDMETHOD.



  METHOD update_royalties_block_quan.
    CHECK NOT line_exists( me->log[ type = 'E' ] ) AND me->fixation_header-BlockedQuantity > 0.

    DATA(block_quantity) = me->fixation_header-BlockedQuantity.

    LOOP AT applications INTO DATA(application).
      IF block_quantity > 0.
        DATA(edc_unlock_quantity) =
        COND zadode_grains_quantity( WHEN block_quantity >= application-Quantity THEN application-Quantity
                                     ELSE block_quantity ).

        DATA(return) = NEW zadocl_royalty_mass_discharge( edc = application-EdcNum
                                                          quantity = edc_unlock_quantity )->mass_discharge( ).

        block_quantity = COND #( WHEN block_quantity >= application-Quantity THEN block_quantity - application-Quantity ELSE 0 ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
