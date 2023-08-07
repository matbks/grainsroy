CLASS zadocl_grains_auth_validation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING auth_data TYPE zadott_grains_auth.

    METHODS validate
      RETURNING VALUE(return) TYPE bapiret2_tt.
  PRIVATE SECTION.
    DATA: auth_data            TYPE zados_grains_auth,
          authorizations       TYPE TABLE OF zadot_grains_009,
          plant_authorizations TYPE TABLE OF zadot_grains_010.

    METHODS get_authorizations.

ENDCLASS.

CLASS zadocl_grains_auth_validation IMPLEMENTATION.

  METHOD constructor.

    TRY.
        me->auth_data = auth_data[ 1 ].
        me->get_authorizations( ).
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

  ENDMETHOD.

  METHOD validate.

    IF line_exists( me->authorizations[ auth_group = 'ADMIN' ] ).
      RETURN.
    ENDIF.

    IF line_exists( me->authorizations[ auth_group = me->auth_data-authorization ] ).
      IF me->plant_authorizations IS NOT INITIAL.
        RETURN.
      ENDIF.
    ENDIF.

    return = VALUE #( ( type = 'E' ) ).

  ENDMETHOD.

  METHOD get_authorizations.

    SELECT * FROM zadot_grains_009 INTO TABLE me->authorizations WHERE company_code = me->auth_data-company_code
                                                                   AND username     = sy-uname
                                                                   AND active       = abap_true.

    SELECT * FROM zadot_grains_010 INTO TABLE me->plant_authorizations WHERE company_code = me->auth_data-company_code
                                                                         AND plant        = me->auth_data-plant
                                                                         AND username     = sy-uname
                                                                         AND active       = abap_true.
  ENDMETHOD.

ENDCLASS.
