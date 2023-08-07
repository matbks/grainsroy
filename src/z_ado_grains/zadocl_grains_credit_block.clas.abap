
CLASS zadocl_grains_credit_block DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA last_block_number TYPE zadode_grains_block_number .

    METHODS get_last_block
      RETURNING
        VALUE(return) TYPE zadode_grains_block_number
      RAISING
        zcx_ado_credit_block_error.

    METHODS set_discharge
      IMPORTING
        !row          TYPE zadot_grains_017
      RETURNING
        VALUE(return) TYPE bapiret2_t .

    METHODS set_block
      IMPORTING
                !json_block   TYPE string
      RETURNING VALUE(return) TYPE bapiret2
      RAISING
                zcx_ado_credit_block_error.
  PRIVATE SECTION.

    METHODS json_to_data
      IMPORTING json TYPE string
      RAISING
                zcx_ado_credit_block_error.

    METHODS check_auth.

    METHODS get_contract.

    METHODS get_product_in.

    METHODS build
      RAISING
        zcx_ado_credit_block_error.

    METHODS insert_block
      RAISING
        zcx_ado_credit_block_error.

    DATA: contract   TYPE tkonn,
          product    TYPE matnr,
          authorized_user TYPE xfeld,
          block      TYPE zadot_grains_016,
          blocks     TYPE zadott_grains_016,
          block_data TYPE zadott_grains_creditb_json_dat,
          error      TYPE bapiret2.

ENDCLASS.



CLASS ZADOCL_GRAINS_CREDIT_BLOCK IMPLEMENTATION.


  METHOD build.

    me->block = VALUE zadot_grains_016( block_number        = me->get_last_block( ) + 1
                                        emission_date       = me->block_data[ 1 ]-emissiondate
                                        destination_holder  = |{ block_data[ 1 ]-destinationholder ALPHA = IN }|
                                        origin_partner      = |{ block_data[ 1 ]-originpartner ALPHA = IN }|
                                        product             = me->product
                                        block_type          = block_data[ 1 ]-blocktype
                                        transgenia          = block_data[ 1 ]-transgenia
                                        quantity            = block_data[ 1 ]-quantity
                                        um                  = block_data[ 1 ]-um
                                        status              = block_data[ 1 ]-status
                                        observation         = block_data[ 1 ]-observation
                                        contract            = |{ me->contract ALPHA = IN }|
                                        safra               = block_data[ 1 ]-safra
                                        balance             = block_data[ 1 ]-balance
                                        created_by          = sy-uname
                                        created_at          = sy-datlo
                                        created_on          = sy-timlo ).

  ENDMETHOD.


  METHOD get_contract.

    TRY.
        me->contract = me->block_data[ 1 ]-contract.
      CATCH cx_sy_itab_line_not_found.
        CLEAR: contract.
    ENDTRY.

  ENDMETHOD.


  METHOD get_last_block.

    DATA: last_block_number TYPE numc10,
          error             TYPE nrreturn.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '1'
        object                  = 'ZADOGBLOCK'
      IMPORTING
        number                  = last_block_number
        returncode              = error
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.

    IF sy-subrc <> 0.

      me->error-type       = 'E'.
      me->error-message    = 'Falha na leitura do SNRO(ZADOGBLOCK)' .

      RAISE EXCEPTION TYPE zcx_ado_credit_block_error.

    ENDIF.

    return = last_block_number.

  ENDMETHOD.


  METHOD get_product_in.

    TRY.
        me->product = me->block_data[ 1 ]-product.
      CATCH cx_sy_itab_line_not_found.
        CLEAR  me->block_data[ 1 ]-product.
    ENDTRY.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = me->product
      IMPORTING
        output = me->product.

  ENDMETHOD.


  METHOD insert_block.

    MODIFY zadot_grains_016 FROM me->block.

  ENDMETHOD.


  METHOD json_to_data.

    cl_fdt_json=>json_to_data(
           EXPORTING
             iv_json = json "er_entity-json
           CHANGING
             ca_data = me->block_data ).

    IF me->block_data IS INITIAL.

      me->error = VALUE #( type    = 'E'
                           message = '' ).

      RAISE EXCEPTION TYPE zcx_ado_credit_block_error.

    ENDIF.

  ENDMETHOD.


  METHOD set_block.

    TRY.

*        me->check_auth( ).

        me->json_to_data( json_block ).

        me->get_contract( ).

        me->get_product_in( ).

        me->build( ).

        me->insert_block( ).

      CATCH zcx_ado_credit_block_error.
        return = me->error.
    ENDTRY.

  ENDMETHOD.


  METHOD set_discharge.

    TRY.

    me->check_auth( ).

    MODIFY zadot_grains_017 FROM row.

    IF sy-subrc <> 0.

      return = VALUE bapiret2_t( (
          type       = 'E'
          message    = 'Não foi possível efetuar o lançamento da baixa'
          ) ).

    ENDIF.

    CATCH zcx_ado_credit_block_error.

    ENDTRY.

  ENDMETHOD.


  METHOD check_auth.

    SELECT SINGLE * FROM zadot_grains_009 INTO @DATA(authorized_user) WHERE username   = @sy-uname
                                                                        AND auth_group = 'DELETEDISC'.

    IF sy-subrc = 0.

      me->authorized_user = abap_true.

    ELSE.

       me->error = VALUE #( type    = 'E'
                           message = 'Exclusão não authorizada para este usuário' ).

      RAISE EXCEPTION TYPE zcx_ado_credit_block_error.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
