CLASS zcl_zadop_royalties_mass_disch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        payload TYPE string.

    METHODS mass_discharge
      RETURNING VALUE(return) TYPE bapiret2.

  PRIVATE SECTION.

    METHODS setup.

    METHODS get_data.

    METHODS get_edc_data.

    METHODS get_discharges.

    METHODS discharge
      IMPORTING edc TYPE zadoc_royalties_monitor.

    DATA: payload           TYPE string,
          discharge_data    TYPE zados_royalties_mass_discharge,
          pending_discharge TYPE /accgo/e_adjusted_qty_dec,
          to_discharge      TYPE /accgo/e_adjusted_qty_dec,
          discharges_data   TYPE TABLE OF zados_royalties_mass_discharge,
          edc_data          TYPE TABLE OF zadoc_royalties_monitor,
          discharges        TYPE TABLE OF zadoc_royalties_log.

ENDCLASS.



CLASS ZCL_ZADOP_ROYALTIES_MASS_DISCH IMPLEMENTATION.


  METHOD constructor.

    me->payload = payload.

    me->setup( ).

  ENDMETHOD.


  METHOD setup.

    cl_fdt_json=>json_to_data(
            EXPORTING
              iv_json = me->payload
            CHANGING
              ca_data = me->discharges_data ).

    TRY.
        me->discharge_data = me->discharges_data[ 1 ].

        UNPACK me->discharge_data-contract TO me->discharge_data-contract.

        me->pending_discharge = me->discharge_data-quantity.

        me->get_data( ).

      CATCH cx_sy_itab_line_not_found.

        CLEAR me->discharge_data.

    ENDTRY.

  ENDMETHOD.


  METHOD get_data.

    me->get_edc_data( ).

    me->get_discharges( ).

  ENDMETHOD.


  METHOD get_edc_data.

    SELECT * FROM zadoc_royalties_monitor INTO TABLE @me->edc_data WHERE ContractNum = @me->discharge_data-contract
                                                                      OR Partner     = @me->discharge_data-partner.

    IF sy-subrc = 0.

      SORT me->edc_data BY EdcNum ASCENDING.

    ENDIF.

  ENDMETHOD.


  METHOD get_discharges.

    SELECT * FROM zadoc_royalties_log INTO TABLE @me->discharges FOR ALL ENTRIES IN @me->edc_data WHERE edcnumber = @me->edc_data-EdcNum
                                                                                                    AND Romaneio  = @me->edc_data-Romaneio
                                                                                                    AND Plant     = @me->edc_data-Plant.

  ENDMETHOD.


  METHOD mass_discharge.

    LOOP AT me->edc_data INTO DATA(edc).

      IF pending_discharge IS NOT INITIAL
     AND edc-discharges    IS NOT INITIAL.

        IF pending_discharge <= edc-discharges.

          me->to_discharge = pending_discharge.

          me->discharge( edc ).

          IF sy-subrc = 0.

            CLEAR me->pending_discharge.

            EXIT.

          ENDIF.

        ELSE.

          to_discharge = edc-discharges.

          me->discharge( edc ).

          IF sy-subrc = 0.

            pending_discharge -= edc-discharges.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD discharge.

    DATA: timestamp TYPE timestamp.

    GET TIME STAMP FIELD timestamp.

    DATA(discharge) = VALUE zadot_royal_log(
        plant            = edc-plant
        romaneio         = edc-romaneio
        edc_number       = edc-edcnum
        created_on       = timestamp
        operation        = '1'
        discharge        = to_discharge
        fiscal_year      = sy-datum(4)
        discharge_status = '' ).

    INSERT zadot_royal_log FROM discharge.

  ENDMETHOD.
ENDCLASS.
