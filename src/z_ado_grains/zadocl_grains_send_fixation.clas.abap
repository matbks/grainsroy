CLASS zadocl_grains_send_fixation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING new_fixation TYPE zadott_grains_create_fixation.

    METHODS execute
      RETURNING VALUE(return) TYPE bapiret2_tt.

  PRIVATE SECTION.
    DATA: new_fixation TYPE zados_grains_create_fixation,
          log          TYPE TABLE OF bapiret2.

    METHODS get_timestamp
      RETURNING VALUE(return) TYPE tzntstmps.

    METHODS create.

    METHODS send_to_approval
      IMPORTING block_reason TYPE bapi_msg.

    METHODS convert_date_format
      IMPORTING date          TYPE any
      RETURNING VALUE(return) TYPE datum.

ENDCLASS.



CLASS zadocl_grains_send_fixation IMPLEMENTATION.


  METHOD constructor.

    TRY.
        me->new_fixation = new_fixation[ 1 ] .
      CATCH cx_sy_itab_line_not_found.
        me->log = VALUE #( ( type = 'E' id = 'ZADO_GRAINS' number = 026  ) ). "Não foram encontrados dados para fixação.
    ENDTRY.

  ENDMETHOD.


  METHOD execute.

    DATA(validation) = NEW zadocl_grains_fix_validate( me->new_fixation  )->validate( ).

    APPEND LINES OF validation TO me->log.

    IF NOT line_exists( validation[ type = 'E' ] ).

      IF NOT line_exists( validation[ type = 'W' ] ).
        me->create( ).
      ELSE.

        TRY.
            me->send_to_approval( block_reason = validation[ type = 'W' ]-message ).
            me->log = VALUE #( BASE me->log ( type = 'W' id = 'ZADO_GRAINS' number = 024 ) ). "Precificação enviada para aprovação.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.

      ENDIF.

    ENDIF.

    DELETE me->log WHERE message IS NOT INITIAL.

    return = me->log.

  ENDMETHOD.


  METHOD send_to_approval.

    DATA: applications TYPE TABLE OF zadot_grains_app,
          billing      TYPE TABLE OF zadot_grains_bil,
          fixation     TYPE zadot_grains_fix.

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
                        block_reason       = block_reason
                        royalties_block    = COND #( WHEN me->new_fixation-blockedquantity > 0 THEN abap_true ELSE abap_false )
                        blocked_quantity   = me->new_fixation-blockedquantity
                        transgenic         = me->new_fixation-applicationdata[ 1 ]-idroyalties
                        property           = me->new_fixation-applicationdata[ 1 ]-property
                        keydate_code       = me->new_fixation-keydatecode
                        dolar_quotation    = me->new_fixation-dolarquotation
                        createdon          = zadocl_grains_utilities=>get_timestamp( )"me->get_timestamp( )
                        createdby          = sy-uname
                        status             = 'U'
                        payment_date       = me->convert_date_format( VALUE #( me->new_fixation-bankdata[ 1 ]-paymentdate OPTIONAL ) ) ).

    DATA(create_fixation) = NEW zadocl_grains_change_fixation( fixation = fixation )->create( ).


    IF create_fixation-type = 'S'.

      applications = VALUE #( FOR application IN me->new_fixation-applicationdata WHERE ( applicationquantity IS NOT INITIAL )
                                 ( plant              = me->new_fixation-plant
                                   contractnum        = me->new_fixation-contract
                                   apl_doc            = application-applicationdoc
                                   edcnum             = application-edcnum
                                   identification_fix = me->new_fixation-identification
                                   quantity           = application-applicationquantity
                                   measure            = application-measure
                                   property           = new_fixation-applicationdata[ 1 ]-property ) ).

      billing = VALUE #( FOR billing_data IN me->new_fixation-bankdata
                            ( bank               = billing_data-bank
                              bankagency         = billing_data-bankagency
                              bankholder         = billing_data-bankholder
                              amount             = billing_data-amount
                              contractnum        = me->new_fixation-contract
                              currency           = billing_data-currency
                              installment        = billing_data-installment
                              BankAccountId      = billing_data-bankaccountid
                              bankaccount        = billing_data-bankaccount
                              paymentdate        = me->convert_date_format( billing_data-paymentdate )
                              plant              = me->new_fixation-plant
                              identification_fix = me->new_fixation-identification
                              quantity           = billing_data-quantity
                              unit               = billing_data-unit ) ).

    ENDIF.

    MODIFY zadot_grains_bil FROM TABLE billing.
    MODIFY zadot_grains_app FROM TABLE applications.

    IF sy-subrc = 0.
      COMMIT WORK AND WAIT.
      APPEND VALUE #( type = 'S' id = 'ZADO_GRAINS' number = 035 ) TO me->log. "Fixação gravada com sucesso.
    ENDIF.

  ENDMETHOD.


  METHOD create.

    me->send_to_approval( block_reason = '' ).

    me->log = VALUE #( BASE me->log ( type = 'S'      id = 'ZADO_GRAINS'       number = 025 ) ). "Precificação aprovada.

    DATA(create_fixation) = NEW zadocl_grains_create_fixation( contractnum = me->new_fixation-contract
                                                               fixation_id = me->new_fixation-identification )->execute( ).

    APPEND LINES OF create_fixation TO me->log.

  ENDMETHOD.


  METHOD get_timestamp.

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


  METHOD convert_date_format.

    return = |{ date+4(4) }{ date+2(2) }{ date(2) }|.

  ENDMETHOD.
ENDCLASS.
