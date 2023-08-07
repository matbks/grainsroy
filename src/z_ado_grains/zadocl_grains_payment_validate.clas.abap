CLASS zadocl_grains_payment_validate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: payment_date TYPE zadott_grains_payment_date.

    METHODS constructor
      IMPORTING fixation_date TYPE zadott_grains_payment_date.

    METHODS validate
      RETURNING VALUE(return) TYPE bapiret2_tt.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS zadocl_grains_payment_validate IMPLEMENTATION.

  METHOD constructor.
    me->payment_date = fixation_date.
  ENDMETHOD.

  METHOD validate.
    TRY.
        DATA(payment_date) = me->payment_date[ 1 ]-paymentdate.

        payment_date = |{ payment_date+4(4) }{ payment_date+2(2) }{ payment_date(2) }|.

        CALL FUNCTION 'DATE_CHECK_WORKINGDAY'
          EXPORTING
            date                       = payment_date
            factory_calendar_id        = 'BR'
            message_type               = 'E'
          EXCEPTIONS
            date_after_range           = 1
            date_before_range          = 2
            date_invalid               = 3
            date_no_workingday         = 4
            factory_calendar_not_found = 5
            message_type_invalid       = 6
            OTHERS                     = 7.

        return = VALUE #( ( type = COND #( WHEN sy-subrc = 0 THEN 'S' ELSE 'E' )  ) ).

      CATCH cx_sy_itab_line_not_found.
        return = VALUE #( ( type = 'E'   ) ).
    ENDTRY.


  ENDMETHOD.

ENDCLASS.
