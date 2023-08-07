CLASS zadocl_royalty_mass_discharge DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !payload  TYPE string                 OPTIONAL
        !edc      TYPE zed_royalty_edc_number OPTIONAL
        !quantity TYPE zadode_grains_quantity OPTIONAL .
    METHODS mass_discharge
      RETURNING
        VALUE(return) TYPE bapiret2_tt .
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
          edc               TYPE  zed_royalty_edc_number,
          quantity          TYPE zadode_grains_quantity,
          errors            TYPE bapiret2_tt,
          discharges_data   TYPE TABLE OF zados_royalties_mass_discharge,
          edc_data          TYPE TABLE OF zadoc_royalties_monitor,
          discharges        TYPE TABLE OF zadoc_royalties_log.

ENDCLASS.



CLASS ZADOCL_ROYALTY_MASS_DISCHARGE IMPLEMENTATION.


  METHOD constructor.

    me->payload  = payload.
    me->edc      = edc.
    me->quantity = quantity.

    me->setup( ).

  ENDMETHOD.


  METHOD setup.

    IF me->edc IS INITIAL.

      cl_fdt_json=>json_to_data(
              EXPORTING
                iv_json = me->payload
              CHANGING
                ca_data = me->discharges_data ).

      TRY.
          me->discharge_data = me->discharges_data[ 1 ].

          IF me->discharge_data-contract IS NOT INITIAL.
            UNPACK me->discharge_data-contract TO me->discharge_data-contract.
          ENDIF.

          me->pending_discharge = me->discharge_data-quantity.

          IF me->discharge_data-partner IS NOT INITIAL.
            UNPACK me->discharge_data-partner TO me->discharge_data-partner.
          ENDIF.

        CATCH cx_sy_itab_line_not_found.

          CLEAR me->discharge_data.

      ENDTRY.

    ELSEIF quantity IS NOT INITIAL.

      me->pending_discharge = CONV #( me->quantity ).

    ELSE.

      APPEND VALUE bapiret2(
          type       = 'E'
          message    = 'Informe EDC + Quantidade ou Parceiro/Contrato + Quantidade' ) TO me->errors.

    ENDIF.

    me->get_data( ).

  ENDMETHOD.


  METHOD get_data.

    me->get_edc_data( ).

    me->get_discharges( ).

  ENDMETHOD.


  METHOD get_edc_data.

    CHECK me->errors IS INITIAL.

    IF me->discharge_data-contract IS NOT INITIAL.

      SELECT * FROM zadoc_royalties_monitor  WHERE contractnum = @me->discharge_data-contract
                                               AND discharges IS NOT INITIAL INTO TABLE @me->edc_data.

    ELSEIF me->discharge_data-partner IS NOT INITIAL
       AND me->discharge_data-contract IS INITIAL.

      SELECT * FROM zadoc_royalties_monitor  WHERE partner = @me->discharge_data-partner
                                               AND discharges IS NOT INITIAL INTO TABLE @me->edc_data.

    ELSEIF me->edc IS NOT INITIAL.

      SELECT * FROM zadoc_royalties_monitor  WHERE edcnum  = @me->edc
                                               AND discharges IS NOT INITIAL INTO TABLE @me->edc_data.

    ENDIF.

    IF sy-subrc = 0.

      SORT me->edc_data BY EdcNum ASCENDING.

    ELSE.

      APPEND VALUE bapiret2( type       = 'E'
                             message    = 'Nenhuma entrada de mercadoria encontrada' ) TO me->errors.

    ENDIF.

  ENDMETHOD.


  METHOD get_discharges.

    CHECK me->errors IS INITIAL.

    SELECT * FROM zadoc_royalties_log INTO TABLE @me->discharges FOR ALL ENTRIES IN @me->edc_data WHERE edcnumber = @me->edc_data-EdcNum
                                                                                                    AND Romaneio  = @me->edc_data-Romaneio
                                                                                                    AND Plant     = @me->edc_data-Plant.

  ENDMETHOD.


  METHOD mass_discharge.

    IF me->errors IS NOT INITIAL.

      return = me->errors.

    ELSE.

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

    ENDIF.

  ENDMETHOD.


  METHOD discharge.

    CHECK me->errors IS INITIAL.

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
        discharge_status = 'Baixas em massa'
        created_by       = sy-uname
        protocol         = me->discharge_data-protocol ).

    INSERT zadot_royal_log FROM discharge.

    IF sy-subrc <> 0.

      APPEND VALUE bapiret2( type       = 'E'
                             message    = 'Falha no lançamento da baixa' ) TO me->errors.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
