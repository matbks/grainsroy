CLASS zadocl_grains_set_contr_status DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING contract_data TYPE zadott_grains_set_contr_status.

    METHODS set_status
      EXPORTING contract_data TYPE zadott_grains_set_contr_status
      RETURNING VALUE(return) TYPE bapiret2_t.


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: contract_data TYPE zadott_grains_set_contr_status.

    DATA: authorization_data  TYPE TABLE OF zadoi_grains_contr_user_auth,
          fix_contracts       TYPE TABLE OF zadoi_grains_contract_fix,
          fix_contract_prices TYPE TABLE OF /accgo/t_pr_asp.

    METHODS setup.

ENDCLASS.



CLASS zadocl_grains_set_contr_status IMPLEMENTATION.


  METHOD constructor.

    me->contract_data = contract_data.

    me->setup( ).

  ENDMETHOD.


  METHOD setup.

    CHECK me->contract_data IS NOT INITIAL.

    SELECT * FROM zadoi_grains_contr_user_auth
      FOR ALL ENTRIES IN @me->contract_data WHERE Plant       = @me->contract_data-plant
                                              AND Username    = @sy-uname
                                              AND CtrApprover = @abap_true INTO TABLE @me->authorization_data.


    SELECT * FROM zadoi_grains_contract_fix
      FOR ALL ENTRIES IN @me->contract_data WHERE TradingContractNumber = @me->contract_data-trading_contract_number
        INTO TABLE @me->fix_contracts.

    IF sy-subrc = 0.

      SELECT * FROM /accgo/t_pr_asp
         FOR ALL ENTRIES IN @me->fix_contracts WHERE tkonn = @me->fix_contracts-TradingContractNumber
            INTO TABLE @me->fix_contract_prices.

    ENDIF.



  ENDMETHOD.



  METHOD set_status.

    DATA: applicationstatus TYPE TABLE OF bapitcstatus,
          bapi_return       TYPE bapiret2_t,
          bapi_return_line  TYPE bapiret2.

    LOOP AT me->contract_data ASSIGNING FIELD-SYMBOL(<line>).

      TRY.
          DATA(authorization) = me->authorization_data[ Plant = <line>-plant ].
        CATCH cx_sy_itab_line_not_found.
          CLEAR authorization.

          bapi_return_line = zadocl_grains_utilities=>get_msg( type = 'E'  id = 'ZADO_GRAINS'  number = '009' ).
          APPEND bapi_return_line TO return.

          CONTINUE.

      ENDTRY.


      TRY.
          DATA(fix_contract) = me->fix_contracts[ TradingContractNumber = <line>-trading_contract_number ]-TradingContractNumber.

          TRY.
              DATA(fix_contract_price) = me->fix_contract_prices[ tkonn = fix_contract ].
            CATCH cx_sy_itab_line_not_found.


              bapi_return_line = zadocl_grains_utilities=>get_msg( type = 'E'  id = 'ZADO_GRAINS'  number = '036' )."Não foi possível aprovar o contrato pois ainda não existe preço fixado.
              APPEND bapi_return_line TO return.

              CONTINUE.

          ENDTRY.
        CATCH cx_sy_itab_line_not_found.
          CLEAR fix_contract.
      ENDTRY.



      CALL FUNCTION 'BAPI_TRADINGCONTRACT_SETSTATUS'
        EXPORTING
          tradingcontractno = <line>-trading_contract_number
          langu             = sy-langu
          trcont_stat       = <line>-new_status
          withcommit        = abap_true
        IMPORTING
          success           = <line>-success
        TABLES
          applicationstatus = applicationstatus
          return            = bapi_return.


      READ TABLE bapi_return ASSIGNING FIELD-SYMBOL(<return_msg>) WITH KEY type   = 'S'
                                                                           id     = 'WB2B'
                                                                           number = '005'.

      IF sy-subrc = 0.

        CASE <line>-new_status.

          WHEN 'T'.
            bapi_return_line = zadocl_grains_utilities=>get_msg( type = 'S'  id = 'ZADO_GRAINS'  number = '001'  var1 = CONV #( <line>-trading_contract_number ) ).

          WHEN 'S'.
            bapi_return_line = zadocl_grains_utilities=>get_msg( type = 'S'  id = 'ZADO_GRAINS'  number = '007'  var1 = CONV #( <line>-trading_contract_number ) ).

          WHEN 'U'.
            bapi_return_line = zadocl_grains_utilities=>get_msg( type = 'S'  id = 'ZADO_GRAINS'  number = '008'  var1 = CONV #( <line>-trading_contract_number ) ).

        ENDCASE.

        APPEND bapi_return_line TO return.
        CLEAR bapi_return_line.

      ELSE.

        APPEND LINES OF bapi_return TO return.

      ENDIF.


    ENDLOOP.

    contract_data = me->contract_data.

  ENDMETHOD.

ENDCLASS.
