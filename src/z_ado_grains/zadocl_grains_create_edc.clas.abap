CLASS zadocl_grains_create_edc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_create_edc,
             contract         TYPE tkonn,
             ticket           TYPE char11,
             nr_romaneio      TYPE char11,
             nfenum           TYPE j_1bnfnum9,
             romaneio_exemplo TYPE char11,
           END OF ty_create_edc.

    DATA: create_data TYPE ty_create_edc.

    METHODS create
      IMPORTING create_data TYPE ty_create_edc.

  PRIVATE SECTION.
ENDCLASS.

CLASS zadocl_grains_create_edc IMPLEMENTATION.
  METHOD create.
    me->create_data = create_data.

    SELECT SINGLE * FROM zado_balancat040 INTO @DATA(balance_data)
        WHERE nr_romaneio = @me->create_data-romaneio_exemplo.

    SELECT * FROM zado_balancat012 INTO TABLE @DATA(qm_data) WHERE ticket = @balance_data-ticket.

    IF sy-subrc = 0.

      MOVE-CORRESPONDING me->create_data TO balance_data.

      LOOP AT qm_data ASSIGNING FIELD-SYMBOL(<fs_line>).
        <fs_line>-ticket = me->create_data-ticket.
      ENDLOOP.

      MODIFY zado_balancat040 FROM balance_data.
      MODIFY zado_balancat012 FROM TABLE qm_data.

      COMMIT WORK AND WAIT.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
