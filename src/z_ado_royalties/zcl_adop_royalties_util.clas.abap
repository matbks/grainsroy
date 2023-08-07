CLASS zcl_adop_royalties_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        block_object TYPE zadott_royalties_util.

    METHODS discharge
      IMPORTING
        quantity TYPE /accgo/e_adjusted_qty_dec.


  PRIVATE SECTION.

    DATA: block_object TYPE zadott_royalties_util,
          quantity     TYPE /accgo/e_adjusted_qty_dec.

    METHODS setup.


ENDCLASS.



CLASS zcl_adop_royalties_util IMPLEMENTATION.

  METHOD constructor.
    me->block_object = block_object.
  ENDMETHOD.

  METHOD setup.

  ENDMETHOD.

  METHOD discharge.



  ENDMETHOD.

ENDCLASS.
