CLASS zadocl_grains_m_invoice_adjust DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING settlement_group TYPE zadott_grains_settlement_group.

    METHODS execute
      RETURNING VALUE(return) TYPE bapiret2_t.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: settlement_group TYPE zadott_grains_settlement_group.
ENDCLASS.



CLASS zadocl_grains_m_invoice_adjust IMPLEMENTATION.

  METHOD constructor.

    me->settlement_group = settlement_group.

  ENDMETHOD.


  METHOD execute.

    LOOP AT me->settlement_group INTO DATA(line).

      DATA(change_return) = NEW zadocl_grains_invoice_adjust( settlement_group_id = line-settlement_group_id
                                                              settlement_doc_year = line-settlement_doc_year )->execute( ).

      APPEND LINES OF change_return TO Return.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
