CLASS zadocl_grains_ms_clear_fix_acc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING settlements_to_clear TYPE zadott_grains_acc_clear.


    METHODS execute
      RETURNING VALUE(return) TYPE bapiret2_t.


  PRIVATE SECTION.

    DATA: settlements_to_clear TYPE zadott_grains_acc_clear.



ENDCLASS.



CLASS zadocl_grains_ms_clear_fix_acc IMPLEMENTATION.

  METHOD constructor.

    me->settlements_to_clear = settlements_to_clear.

  ENDMETHOD.


  METHOD execute.

    LOOP AT me->settlements_to_clear INTO DATA(settlement_to_clear).

      DATA(return_log) = NEW zadocl_grains_clear_fix_acc( contract_num = settlement_to_clear-contract_num
                                                          invoice      = settlement_to_clear-invoice
                                                          test_run     = settlement_to_clear-test_run
                                                          mode         = settlement_to_clear-mode )->execute_clearing( ).

    ENDLOOP.

    APPEND LINES OF return_log TO return.

  ENDMETHOD.


ENDCLASS.
