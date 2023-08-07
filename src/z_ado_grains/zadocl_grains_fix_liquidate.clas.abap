CLASS zadocl_grains_fix_liquidate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING fixation_data TYPE zadott_grains_create_fixation.

    METHODS execute
      RETURNING VALUE(return) TYPE bapiret2_tt.

  PRIVATE SECTION.

    DATA: logs TYPE TABLE OF bapiret2.

    DATA: contract_num       TYPE tkonn,
          identification_fix TYPE zadode_grains_origin_fix,
          applications       TYPE TABLE OF zadot_grains_app,
          fixation_data      TYPE zadot_grains_fix,
          installment        TYPE zadode_grains_installment,
          all_ctr_fixations  TYPE TABLE OF zadot_grains_fix.


    METHODS get_data.

    METHODS liquidate
      RETURNING VALUE(return) TYPE /accgo/s_group.

    METHODS update_fixation
      IMPORTING settlement_data TYPE /accgo/s_group.

    METHODS check_compensations_completed
      RETURNING VALUE(return) TYPE abap_bool.

    METHODS call_clearing.

ENDCLASS.



CLASS ZADOCL_GRAINS_FIX_LIQUIDATE IMPLEMENTATION.


  METHOD constructor.

    TRY.
        me->contract_num         = fixation_data[ 1 ]-contract.
        me->identification_fix   = fixation_data[ 1 ]-identification.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

  ENDMETHOD.


  METHOD execute.

    me->get_data( ).

    me->check_compensations_completed( ).

    IF line_exists( me->logs[ type = 'E' ] ).
      return = me->logs.
      RETURN.
    ENDIF.

    DATA(settlement_data) = me->liquidate( ).

    IF settlement_data IS NOT INITIAL AND NOT line_exists( me->logs[ type = 'E' ] ).
      DATA(adjust_return) = NEW zadocl_grains_invoice_adjust( settlement_group_id = settlement_data-group_id
                                                              settlement_doc_year = settlement_data-settl_yr )->execute(  ).

      APPEND LINES OF adjust_return TO me->logs.
    ELSE.
      me->logs = VALUE #( BASE me->logs ( type = 'E' number = 028 id = 'ZADO_GRAINS' ) ). "Falha ao gerar grupo de liquidação
    ENDIF.

    IF line_exists( me->logs[ type = 'S' id = 'ZADO_GRAINS' number = '042' ] )."Fatura &1 registrada com sucesso.
      me->call_clearing( ).
    ENDIF.

    return = me->logs.

  ENDMETHOD.


  METHOD check_compensations_completed.

    DATA(counter) = 0.
    LOOP AT me->all_ctr_fixations INTO DATA(fixation) WHERE status <> 'C'.
      counter += 1.
    ENDLOOP.

    IF counter <= 1.
      return = abap_true.
    ELSE.
      APPEND zadocl_grains_utilities=>get_msg( type = 'E'  id = 'ZADO_GRAINS'  number = '043' ) TO me->logs. "Existem fixações anteriores a essa que não foram compensadas.
    ENDIF.

  ENDMETHOD.


  METHOD call_clearing.

    CHECK NOT line_exists( me->logs[ type  = 'E' ] ).

    SELECT SINGLE * FROM zadot_grains_fix WHERE contractnum        = @me->contract_num
                                            AND identification_fix = @me->identification_fix
                                            AND invoice_doc        IS NOT INITIAL
                                            AND status             = 'L'
                                           INTO @me->fixation_data.

    IF sy-subrc = 0.

      DATA(clearing_return) = NEW zadocl_grains_clear_fix_acc( contract_num = me->contract_num
                                                               invoice      = me->fixation_data-invoice_doc )->execute_clearing( ).

      APPEND LINES OF clearing_return TO me->logs.

    ENDIF.

  ENDMETHOD.


  METHOD liquidate.

    DATA: et_groupid       TYPE /accgo/tt_group,
          et_messages      TYPE /accgo/tt_common_br_bapiret2,
          all_messages     TYPE bal_t_msg,
          application_docs TYPE TABLE OF /accgo/e_appldoc.

    DATA(fixation_quantity) = me->fixation_data-quantity.

    LOOP AT me->applications INTO DATA(line_application).
      fixation_quantity = fixation_quantity - line_application-quantity.
      application_docs = VALUE #( BASE application_docs ( line_application-apl_doc  ) ).

      IF NOT fixation_quantity > 0.
        CONTINUE.
      ENDIF.
    ENDLOOP.

    IF application_docs IS NOT INITIAL.

      LOOP AT application_docs INTO DATA(application).
        APPEND VALUE #( type = 'S' number = 055 id = 'ZADO_GRAINS' message_v1 = application ) TO me->logs. "Iniciando processo de liquidação para aplicação &1.
      ENDLOOP.

      DATA: devolution_scenario TYPE xfeld.

      devolution_scenario = abap_true.
      EXPORT devolution_scenario FROM devolution_scenario TO MEMORY ID 'DEV_SCENARIO'.

      CALL FUNCTION '/ACCGO/CAS_GENERATE_STL_GROUP'
        EXPORTING
          it_t_appldocs                  = application_docs
          iv_pro_stl                     = 'X'
          iv_sub_stl                     = 'X'
          iv_final_stl                   = 'X'
          iv_counter_prty_apprvl_require = ''
          iv_commit                      = 'X'
        IMPORTING
          et_groupid                     = et_groupid
          et_messages                    = et_messages.

      LOOP AT et_groupid ASSIGNING FIELD-SYMBOL(<message>).
        all_messages = VALUE #( BASE all_messages
                                  FOR message IN <message>-log
                                   ( msgty = message-msgty ) ).
      ENDLOOP.

      IF line_exists( all_messages[ msgty = 'E' ] ) OR line_exists( et_messages[ type = 'E' ] ).
        me->logs = VALUE #( BASE me->logs ( type = 'E' number = 028 id = 'ZADO_GRAINS' ) ). "Falha ao gerar grupo de liquidação
      ENDIF.

      DELETE et_messages WHERE type <> 'E'.
      APPEND LINES OF et_messages TO me->logs.

      DATA(settlements_docs) = et_groupid.
      SORT settlements_docs BY group_id.
      DELETE ADJACENT DUPLICATES FROM settlements_docs COMPARING group_id.

      IF lines( settlements_docs ) > 1.
        me->logs = VALUE #( BASE me->logs ( type = 'E' number = 029 id = 'ZADO_GRAINS' ) ). "Falha no agrupamento ao gerar grupo de liquidação
      ELSE.
        TRY.
            return = et_groupid[ 1 ].
            me->update_fixation( settlement_data = et_groupid[ 1 ] ).
            me->logs = VALUE #( BASE me->logs ( type = 'S' number = 030 id = 'ZADO_GRAINS' message_v1 = et_groupid[ 1 ]-settl_doc ) ). "Grupo de liquidação &1 gerado com sucesso
          CATCH cx_sy_itab_line_not_found.
            me->logs = VALUE #( BASE me->logs ( type = 'E' number = 028 id = 'ZADO_GRAINS' ) ). "Falha ao gerar grupo de liquidação
        ENDTRY.
      ENDIF.
    ELSE.
      me->logs = VALUE #( BASE me->logs ( type = 'E' number = 028 id = 'ZADO_GRAINS' ) ). "Falha ao gerar grupo de liquidação
    ENDIF.
  ENDMETHOD.


  METHOD get_data.

    SELECT * FROM zadot_grains_app INTO TABLE @me->applications WHERE contractnum        = @me->contract_num
                                                                  AND identification_fix = @me->identification_fix.

    SELECT * FROM zadot_grains_fix WHERE contractnum = @me->contract_num INTO TABLE @me->all_ctr_fixations.

    TRY.
        me->fixation_data = me->all_ctr_fixations[ identification_fix = me->identification_fix ].
      CATCH cx_sy_itab_line_not_found.
        me->logs = VALUE #( BASE me->logs ( type = 'E' number = 026 id = 'ZADO_GRAINS' ) ). "Não foram encontrados dados para fixação.
    ENDTRY.

  ENDMETHOD.


  METHOD update_fixation.

    CHECK NOT line_exists( me->logs[ type = 'E'  ] ).


    SELECT SINGLE * FROM zadot_grains_fix WHERE contractnum        = @me->contract_num
                                            AND identification_fix = @me->identification_fix
                                            AND plant              = @me->fixation_data-plant
                                           INTO @DATA(fixation_header).

    fixation_header-status              = 'L'.
    fixation_header-settlement_doc      = settlement_data-settl_doc.
    fixation_header-settlement_year     = settlement_data-settl_yr.
    fixation_header-settlement_group_id = settlement_data-group_id.

    DATA(change_return) = NEW zadocl_grains_change_fixation( fixation = fixation_header )->change( ).

    IF change_return-type = 'E'.
      APPEND change_return TO me->logs.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
