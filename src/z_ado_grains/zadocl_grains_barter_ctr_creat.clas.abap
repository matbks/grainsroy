CLASS zadocl_grains_barter_ctr_creat DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor.

    METHODS execute.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zadocl_grains_barter_ctr_creat IMPLEMENTATION.

  METHOD constructor.

  ENDMETHOD.

  METHOD execute.

    DATA: itemdatain TYPE TABLE OF bapitcitem.

    DATA(headdatain) = VALUE bapitchead( trcont_type = 'ZCB1' trcont_stat = 'L' trcont_currency = 'BRL' trcont_currency_iso = 'BRL'
                                         exch_rate_p = 1 trans_date = '20230307' sales_org = '1901' distr_chan = '10' division = '20'
                                         sales_grp = '255' sales_off = '7511' last_change_party = 'T' ).

    itemdatain = VALUE #( (  trcont_item = '000010' material = '5001160' plant = '1901' stge_loc = 'GR01' short_text = 'SOJA' ) ).

*    CALL FUNCTION 'BAPI_TRADINGCONTRACT_CREATE'
*      EXPORTING
*        headdatain     = headdatain
*      TABLES
*        itemdatain     =
*        scheduledatain =
*        businessdatain =.



  ENDMETHOD.

ENDCLASS.
