CLASS zadocl_grains_acc_clr_reverse DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING clearing_docs TYPE zadott_grains_acc_clear_revers.

    METHODS execute
      RETURNING VALUE(return) TYPE bapiret2_t.

  PRIVATE SECTION.
    DATA: clearing_docs TYPE zadott_grains_acc_clear_revers.


ENDCLASS.



CLASS zadocl_grains_acc_clr_reverse IMPLEMENTATION.


  METHOD constructor.

    me->clearing_docs = clearing_docs.

  ENDMETHOD.


  METHOD execute.

    DATA: e_xstor                 TYPE char255,
          ev_reverse_needed_text1 TYPE string,
          ev_reverse_needed_text2 TYPE string,
          ev_reverse_needed_text3 TYPE string.

    DATA: e_msgid TYPE sy-msgid,
          e_msgty TYPE sy-msgty,
          e_msgno TYPE sy-msgno,
          e_msgv1 TYPE sy-msgv1,
          e_msgv2 TYPE sy-msgv2,
          e_msgv3 TYPE sy-msgv3,
          e_msgv4 TYPE sy-msgv4,
          e_subrc TYPE sy-subrc.


    LOOP AT me->clearing_docs INTO DATA(clearing_doc).

      CALL FUNCTION 'POSTING_INTERFACE_START'
        EXPORTING
          i_function = 'C'
          i_mode     = clearing_doc-mode.

      CALL FUNCTION 'POSTING_INTERFACE_RESET_CLEAR'
        EXPORTING
          i_augbl                  = clearing_doc-clearing_doc
          i_bukrs                  = clearing_doc-company_code
          i_gjahr                  = clearing_doc-clearing_year
          i_tcode                  = 'FBRA'
        IMPORTING
          e_msgid                  = e_msgid
          e_msgno                  = e_msgno
          e_msgty                  = e_msgty
          e_msgv1                  = e_msgv1
          e_msgv2                  = e_msgv2
          e_msgv3                  = e_msgv3
          e_msgv4                  = e_msgv4
          e_subrc                  = e_subrc
        EXCEPTIONS
          transaction_code_invalid = 1
          no_authorization         = 2
          OTHERS                   = 3.

      return = VALUE #( BASE return
              ( zadocl_grains_utilities=>get_msg( type   = e_msgty
                                                  id     = e_msgid
                                                  number = e_msgno
                                                  var1   = e_msgv1
                                                  var2   = e_msgv2
                                                  var3   = e_msgv3
                                                  var4   = e_msgv4 ) ) ).

      SET PARAMETER ID 'FSG' FIELD '01'.

      DATA: t_blntab TYPE TABLE OF blntab.

      CALL FUNCTION 'POSTING_INTERFACE_REVERSE_DOC'
        EXPORTING
          i_belns                  = clearing_doc-clearing_doc
          i_bukrs                  = clearing_doc-company_code
          i_gjahs                  = clearing_doc-clearing_year
          i_tcode                  = 'FB08'
        IMPORTING
          e_msgid                  = e_msgid
          e_msgno                  = e_msgno
          e_msgty                  = e_msgty
          e_msgv1                  = e_msgv1
          e_msgv2                  = e_msgv2
          e_msgv3                  = e_msgv3
          e_msgv4                  = e_msgv4
          e_subrc                  = e_subrc
        TABLES
          t_blntab                 = t_blntab
        EXCEPTIONS
          transaction_code_invalid = 1
          no_authorization         = 2
          OTHERS                   = 3.



      CALL FUNCTION 'POSTING_INTERFACE_END'.

      return = VALUE #( BASE return
                        ( zadocl_grains_utilities=>get_msg( type   = e_msgty
                                                            id     = e_msgid
                                                            number = e_msgno
                                                            var1   = e_msgv1
                                                            var2   = e_msgv2
                                                            var3   = e_msgv3
                                                            var4   = e_msgv4 ) ) ).

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
