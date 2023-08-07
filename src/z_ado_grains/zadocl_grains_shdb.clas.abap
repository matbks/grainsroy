CLASS zadocl_grains_shdb DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF t_gt_bdc,
             program  TYPE char40,
             dynpro   TYPE char100,
             dynbegin TYPE char1,
           END OF t_gt_bdc.

    TYPES: tt_gt_bdc TYPE TABLE OF t_gt_bdc.

    DATA: gt_bdc     TYPE TABLE OF bdcdata,
          gt_bdc_msg TYPE TABLE OF bdcmsgcoll,
          bdc_table  TYPE TABLE OF t_gt_bdc,
          log_table  TYPE TABLE OF bapiret2,
          tcode      TYPE tcode,
          options    TYPE ctu_params.

    METHODS constructor
      IMPORTING bdc_table TYPE tt_gt_bdc
                tcode     TYPE tcode
                options   TYPE ctu_params.
    METHODS execute
      RETURNING VALUE(return) TYPE trty_bdcmsgcoll.

  PRIVATE SECTION.

    METHODS set_bdc
      IMPORTING dyn_begin TYPE abap_bool
                program   TYPE char40
                dynpro    TYPE char100.
ENDCLASS.

CLASS zadocl_grains_shdb IMPLEMENTATION.

  METHOD constructor.
    me->bdc_table = bdc_table.
    me->tcode = tcode.
    me->options = options.
  ENDMETHOD.

  METHOD execute.

    LOOP AT me->bdc_table INTO DATA(bdc_line).

      CONDENSE bdc_line-dynpro NO-GAPS.

      me->set_bdc( dyn_begin = bdc_line-dynbegin
                   program   = bdc_line-program
                   dynpro    = bdc_line-dynpro ).
    ENDLOOP.

    CALL TRANSACTION me->tcode USING me->gt_bdc
                        OPTIONS FROM me->options
                        MESSAGES INTO return.

  ENDMETHOD.

  METHOD set_bdc.
    IF dyn_begin   = 'X'.
      DATA(ls_bdc) = VALUE bdcdata( program   = program
                                    dynpro    = dynpro
                                    dynbegin  = abap_true ).
    ELSE.
      ls_bdc = VALUE bdcdata( fnam = program
                              fval = dynpro ).
    ENDIF.
    APPEND ls_bdc TO me->gt_bdc.
  ENDMETHOD.

ENDCLASS.
