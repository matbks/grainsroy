class ZCL_ZADOP_ROYALTIES_DPC_EXT definition
  public
  inheriting from ZCL_ZADOP_ROYALTIES_DPC
  create public .

public section.
protected section.

  methods DISCHARGEQTYSET_CREATE_ENTITY
    redefinition .
  methods JSONCOMMSET_CREATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZADOP_ROYALTIES_DPC_EXT IMPLEMENTATION.


  METHOD dischargeqtyset_create_entity.

    io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

*    SELECT SINGLE * FROM zadot_royal_del INTO @DATA(username_permission) WHERE username   = @sy-uname
*                                                                           AND permission = @abap_true.
*
*    IF sy-subrc <> 0.
*      er_entity-protocol = 'no auth user'.
*      EXIT.
*    ENDIF.

    DATA log TYPE zadot_royal_log.

    log = VALUE #( plant            = er_entity-plant
                   romaneio         = er_entity-romaneio
                   edc_number       = er_entity-edcnumber
                   created_on       = er_entity-createdon
                   discharge        = er_entity-discharge
                   fiscal_year      = er_entity-fiscalyear
                   balance          = er_entity-balance
                   discharge_status = er_entity-dischargestatus
                   operation        = er_entity-operation
                   protocol         = er_entity-protocol ).

    MODIFY zadot_royal_log FROM log.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = mo_context->get_message_container( ).
    ENDIF.

  ENDMETHOD.


  METHOD jsoncommset_create_entity.

    io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

    CASE er_entity-action.

      WHEN 'MASSDISCHARGE'.

         DATA(return) = NEW zadocl_royalty_mass_discharge( payload = er_entity-payload )->mass_discharge( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
