CLASS zadocl_grains_change_fixation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        fixation    TYPE zadot_grains_fix
        reject_text TYPE zadode_grains_string OPTIONAL
        do_commit   TYPE abap_bool DEFAULT abap_true.

    METHODS create
      RETURNING VALUE(return) TYPE bapiret2.

    METHODS change
      RETURNING VALUE(return) TYPE bapiret2.

    METHODS delete
      RETURNING VALUE(return) TYPE bapiret2.

  PRIVATE SECTION.
    DATA: fixation    TYPE zadot_grains_fix,
          reject_text TYPE zadode_grains_string,
          do_commit   TYPE abap_bool.

    DATA: old_fixation     TYPE zadot_grains_fix,
          reject_text_guid TYPE sysuuid_c22.

    METHODS setup.

    METHODS execute_change_document
      IMPORTING change_indicator TYPE cdchngindh.

    METHODS save_text.

ENDCLASS.



CLASS zadocl_grains_change_fixation IMPLEMENTATION.

  METHOD constructor.

    me->fixation    = fixation.
    me->reject_text = reject_text.
    me->do_commit   = do_commit.

    me->setup( ).

  ENDMETHOD.


  METHOD setup.

    " Fill old values
    CLEAR me->old_fixation.
    SELECT SINGLE * FROM zadot_grains_fix WHERE plant              = @me->fixation-plant
                                            AND contractnum        = @me->fixation-contractnum
                                            AND identification_fix = @me->fixation-identification_fix
                                          INTO @me->old_fixation.


    TRY.
        me->reject_text_guid = cl_system_uuid=>create_uuid_c22_static( ).
      CATCH cx_uuid_error.
        CLEAR me->reject_text_guid.
    ENDTRY.

  ENDMETHOD.


  METHOD create.

    DATA(fix_id) = CONV syst_msgv( me->fixation-identification_fix ). CONDENSE fix_id NO-GAPS.

    IF me->old_fixation IS NOT INITIAL.

      return = zadocl_grains_utilities=>get_msg( type   = 'E'
                                                 id     = 'ZADO_GRAINS'
                                                 number = '012'
                                                 var1   = fix_id
                                                 var2   = CONV #( |{ me->fixation-contractnum ALPHA = OUT }| ) ). "Fixação &1, do contrato &2, já existe.
      RETURN.

    ENDIF.

    INSERT zadot_grains_fix FROM me->fixation.

    IF sy-subrc = 0.

      return = zadocl_grains_utilities=>get_msg( type   = 'S'
                                                 id     = 'ZADO_GRAINS'
                                                 number = '010'
                                                 var1   = fix_id
                                                 var2   = CONV #( |{ me->fixation-contractnum ALPHA = OUT }| ) ). "Fixação &1, do contrato &2, criada com sucesso.

      me->execute_change_document( 'I' ).

    ELSE.

      return = zadocl_grains_utilities=>get_msg( type   = sy-msgty
                                                 id     = sy-msgid
                                                 number = sy-msgno
                                                 var1   = sy-msgv1
                                                 var2   = sy-msgv2
                                                 var3   = sy-msgv3
                                                 var4   = sy-msgv4 ).


    ENDIF.

  ENDMETHOD.

  METHOD change.

    MODIFY zadot_grains_fix FROM me->fixation.

    IF sy-subrc = 0.

      IF me->do_commit = abap_true.
        COMMIT WORK AND WAIT.
      ENDIF.

      DATA(fix_id) = CONV syst_msgv( me->fixation-identification_fix ). CONDENSE fix_id NO-GAPS.
      return = zadocl_grains_utilities=>get_msg( type   = 'S'
                                                 id     = 'ZADO_GRAINS'
                                                 number = '011'
                                                 var1   = fix_id
                                                 var2   = CONV #( |{ me->fixation-contractnum ALPHA = OUT }| ) ). "Fixação &1, do contrato &2, alterada com sucesso.

      IF me->reject_text IS NOT INITIAL.
        me->save_text( ).
      ENDIF.

      me->execute_change_document( 'U' ).

    ELSE.

      return = zadocl_grains_utilities=>get_msg( type   = sy-msgty
                                                 id     = sy-msgid
                                                 number = sy-msgno
                                                 var1   = sy-msgv1
                                                 var2   = sy-msgv2
                                                 var3   = sy-msgv3
                                                 var4   = sy-msgv4 ).


    ENDIF.

  ENDMETHOD.


  METHOD save_text.

    DATA(workarea) = VALUE zadot_grains_txt( guid               = me->reject_text_guid
                                             plant              = me->fixation-plant
                                             contractnum        = me->fixation-contractnum
                                             identification_fix = me->fixation-identification_fix
                                             type               = 'Fixação'
                                             created_by         = sy-uname
                                             created_on         = zadocl_grains_utilities=>get_timestamp( )
                                             text               = me->reject_text ).

    MODIFY zadot_grains_txt FROM workarea.

  ENDMETHOD.

  METHOD delete.

    UPDATE zadot_grains_fix
      SET eliminated = abap_true
          status     = 'S'
          WHERE plant              = me->fixation-plant
            AND contractnum        = me->fixation-contractnum
            AND identification_fix = me->fixation-identification_fix.


    IF sy-subrc = 0.

      DATA(fix_id) = CONV syst_msgv( me->fixation-identification_fix ). CONDENSE fix_id NO-GAPS.
      return = zadocl_grains_utilities=>get_msg( type   = 'S'
                                                 id     = 'ZADO_GRAINS'
                                                 number = '013'
                                                 var1   = fix_id
                                                 var2   = CONV #( |{ me->fixation-contractnum ALPHA = OUT }| ) ). "Fixação &1, do contrato &2, deletada com sucesso.

      me->execute_change_document( 'D' ).

    ELSE.

      return = zadocl_grains_utilities=>get_msg( type   = sy-msgty
                                                 id     = sy-msgid
                                                 number = sy-msgno
                                                 var1   = sy-msgv1
                                                 var2   = sy-msgv2
                                                 var3   = sy-msgv3
                                                 var4   = sy-msgv4 ).

    ENDIF.


  ENDMETHOD.


  METHOD execute_change_document.

    DATA: text_data   TYPE TABLE OF cdtxt,
          wa_old_data TYPE yzadot_grains_fix,
          old_data    TYPE TABLE OF yzadot_grains_fix,
          wa_new_data TYPE yzadot_grains_fix,
          new_data    TYPE TABLE OF yzadot_grains_fix.

    CLEAR:  wa_old_data, old_data, wa_new_data, new_data.

    MOVE-CORRESPONDING me->old_fixation TO wa_old_data.
    wa_old_data-kz = change_indicator.
    APPEND wa_old_data TO old_data.

    MOVE-CORRESPONDING me->fixation TO wa_new_data.
    wa_new_data-kz = change_indicator.
    APPEND wa_new_data TO new_data.

    CASE change_indicator.
      WHEN 'I'.
        CLEAR old_data.

      WHEN 'D'.
        CLEAR new_data.
    ENDCASE.

    CALL FUNCTION 'ZADOCDGRAINSFIX_WRITE_DOCUMENT'
      EXPORTING
        objectid                   = CONV cdobjectv( |{ me->fixation-contractnum }-{ me->reject_text_guid }| )
        tcode                      = sy-tcode
        utime                      = sy-timlo
        udate                      = sy-datlo
        username                   = sy-uname
        object_change_indicator    = change_indicator
        upd_icdtxt_zadocdgrainsfix = COND #( WHEN change_indicator = 'I' THEN change_indicator ELSE space )
        upd_zadot_grains_fix       = change_indicator
      TABLES
        icdtxt_zadocdgrainsfix     = text_data
        xzadot_grains_fix          = new_data
        yzadot_grains_fix          = old_data.

  ENDMETHOD.

ENDCLASS.
