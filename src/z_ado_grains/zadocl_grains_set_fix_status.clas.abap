CLASS zadocl_grains_set_fix_status DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING fixation_data TYPE zadott_grains_set_fix_status.


    METHODS set_status
      RETURNING VALUE(return) TYPE bapiret2_t.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: fixation_data TYPE zadott_grains_set_fix_status,
          fixations     TYPE TABLE OF zadot_grains_fix.

    DATA: authorization_data TYPE TABLE OF zadoi_grains_contr_user_auth.

    METHODS setup.


ENDCLASS.



CLASS zadocl_grains_set_fix_status IMPLEMENTATION.

  METHOD constructor.

    me->fixation_data = fixation_data.

    me->setup( ).

  ENDMETHOD.


  METHOD setup.

    CHECK me->fixation_data IS NOT INITIAL.

    SELECT * FROM zadoi_grains_contr_user_auth
      FOR ALL ENTRIES IN @me->fixation_data WHERE Plant       = @me->fixation_data-plant
                                              AND Username    = @sy-uname
                                              AND FixApprover = @abap_true INTO TABLE @me->authorization_data.

    SELECT * FROM zadot_grains_fix
      FOR ALL ENTRIES IN @me->fixation_data WHERE Plant              = @me->fixation_data-plant
                                              AND contractnum        = @me->fixation_data-contractnum
                                              AND identification_fix = @me->fixation_data-identification_fix
                                            INTO TABLE @me->fixations.

  ENDMETHOD.


  METHOD set_status.

    LOOP AT me->fixations ASSIGNING FIELD-SYMBOL(<fixation>).

      TRY.
          DATA(authorization) = me->authorization_data[ Plant = <fixation>-plant ].
        CATCH cx_sy_itab_line_not_found.
          CLEAR authorization.

          DATA(msg_return) = zadocl_grains_utilities=>get_msg( type = 'E'  id = 'ZADO_GRAINS'  number = '009' ).
          APPEND msg_return TO return.

          CONTINUE.

      ENDTRY.

      TRY.
          DATA(fix_new_status) = me->fixation_data[ plant              = <fixation>-plant
                                                    contractnum        = <fixation>-contractnum
                                                    identification_fix = <fixation>-identification_fix ].
        CATCH cx_sy_itab_line_not_found.
          CLEAR fix_new_status.
      ENDTRY.

      <fixation>-status = fix_new_status-new_status.

      IF fix_new_status-new_status = 'T'.
        DATA(msgs_perform_fixation) = NEW zadocl_grains_create_fixation( contractnum = <fixation>-contractnum
                                                                         fixation_id = <fixation>-identification_fix )->execute( ).
        IF msgs_perform_fixation IS NOT INITIAL.
          APPEND LINES OF msgs_perform_fixation TO return.
        ENDIF.

      ENDIF.

      IF fix_new_status-new_status = 'U'.
        <fixation>-status   = fix_new_status-new_status.
        DATA(change_return) = NEW zadocl_grains_change_fixation( fixation = <fixation> )->change( ).
        APPEND change_return TO return.
      ENDIF.


*      IF NOT line_exists( return[ type = 'E' ] ) AND fix_new_status-new_status = 'T'.
*        msg_return = NEW zadocl_grains_change_fixation( fixation    = <fixation>
*                                                        reject_text = fix_new_status-text  )->change( ).
*        IF msg_return IS NOT INITIAL.
*          APPEND msg_return TO return.
*        ENDIF.
*      ENDIF.

      IF fix_new_status-new_status = 'S'.

        msg_return = NEW zadocl_grains_change_fixation( fixation    = <fixation>
                                                        reject_text = fix_new_status-text  )->delete( ).
        IF msg_return IS NOT INITIAL.
          APPEND msg_return TO return.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.



ENDCLASS.
