CLASS zadocl_grains_fix_validate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: fixation TYPE zados_grains_create_fixation,
          log      TYPE TABLE OF bapiret2.

    METHODS constructor
      IMPORTING fixation_data TYPE zados_grains_create_fixation.

    METHODS validate
      RETURNING VALUE(return) TYPE bapiret2_tt.

  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS price_validate.

    METHODS contract_available_quantity.

    METHODS time_validation.

ENDCLASS.

CLASS zadocl_grains_fix_validate IMPLEMENTATION.
  METHOD constructor.
    me->fixation = fixation_data.
  ENDMETHOD.

  METHOD validate.
    me->price_validate( ).

    me->contract_available_quantity( ).

    me->time_validation( ).

    return = me->log.
  ENDMETHOD.

  METHOD price_validate.
    CHECK NOT line_exists( me->log[ type = 'E' ]  ).

    TRY.
        DATA(payment_date) = me->fixation-bankdata[ 1 ]-paymentdate.

        payment_date = |{ payment_date+4(4) }{ payment_date+2(2) }{ payment_date(2) }|.

        SELECT * FROM zadoc_grains_basis_price INTO TABLE @DATA(basis_price) WHERE commodity   = @me->fixation-materialnum
                                                                               AND Plant       = @me->fixation-plant
                                                                               AND DueDate    >= @payment_date.
        IF sy-subrc <> 0.
          me->log = VALUE #( BASE me->log ( type = 'E' id = 'ZADO_GRAINS' number = 021 ) ). "Falha ao buscar a cotação para preço basis.
        ELSE.
          SORT basis_price BY DueDate ASCENDING PriceDate DESCENDING.

          DELETE ADJACENT DUPLICATES FROM basis_price COMPARING DueDate PriceDate.

          IF basis_price[ 1 ]-Price <> me->fixation-basisprice.
            me->log = VALUE #( BASE me->log ( type = 'W' message = '1' id = 'ZADO_GRAINS' number = 022  ) ). "Preço basis diferente do previsto.
          ENDIF.
        ENDIF.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

  ENDMETHOD.

  METHOD contract_available_quantity.
    CHECK NOT line_exists( me->log[ type = 'E' ]  ).
    DATA: consumed_appquantity TYPE zadode_grains_quantity,
          billing_quantity     TYPE zadode_grains_quantity.

    IF me->fixation-applicationdata IS NOT INITIAL.
      SELECT * FROM zadoc_grains_edc_from_contract INTO TABLE @DATA(available_quantity)
        FOR ALL ENTRIES IN @me->fixation-applicationdata WHERE ApplicationDocNum = @me->fixation-applicationdata-applicationdoc.

      LOOP AT available_quantity INTO DATA(line_available_quantity).
        IF line_available_quantity-AvailableQuantity < me->fixation-applicationdata[ applicationdoc = line_available_quantity-ApplicationDocNum ]-applicationquantity.
          me->log = VALUE #( BASE me->log ( type = 'E' id = 'ZADO_GRAINS' number = 040  ) ). "Quantidade inválida
        ENDIF.
        consumed_appquantity +=  me->fixation-applicationdata[ applicationdoc = line_available_quantity-ApplicationDocNum ]-applicationquantity.
      ENDLOOP.

    ELSE.
      me->log = VALUE #( BASE me->log ( type = 'E' id = 'ZADO_GRAINS' number = 039  ) ). "Falha ao buscar documentos de aplicação para fixação.
    ENDIF.

    LOOP AT me->fixation-bankdata INTO DATA(line_bank_data).
      billing_quantity += line_bank_data-quantity.
    ENDLOOP.

    IF consumed_appquantity <> billing_quantity OR me->fixation-quantity <> billing_quantity.
      me->log = VALUE #( BASE me->log ( type = 'E' id = 'ZADO_GRAINS' number = 040  ) ). "Quantidade inválida
    ENDIF.

    SELECT SINGLE AvailableQuantity FROM zadoc_grains_balances_property INTO @DATA(contract_available_quantity) WHERE ContractNum = @me->fixation-contract.
    IF sy-subrc = 0.
      IF billing_quantity > contract_available_quantity.
        me->log = VALUE #( BASE me->log ( type = 'E' id = 'ZADO_GRAINS' number = 040  ) ). "Quantidade inválida
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD time_validation.
    CHECK NOT line_exists( me->log[ type = 'E' ]  ).

    DATA: timestamp_location TYPE timestampl,
          time_zone          TYPE tznzone.

    SELECT SINGLE * FROM zadot_grains_015 INTO @DATA(place_data) WHERE plant = @me->fixation-plant.

    SELECT SINGLE * FROM t001w INTO @DATA(location_data) WHERE werks = @me->fixation-plant.

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
          TIME ZONE time_zone INTO TIME DATA(time)
                                   DATE DATA(date).
    ENDIF.

    IF NOT ( place_data-morning_from <= time AND place_data-morning_to >= time ) OR
       ( place_data-afternoon_from <= time AND place_data-afternoon_to >= time ).

      me->log = VALUE #( BASE me->log ( type = 'W' message = '2' id = 'ZADO_GRAINS' number = 023 ) ). "Fora do horário previsto para fixação.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
