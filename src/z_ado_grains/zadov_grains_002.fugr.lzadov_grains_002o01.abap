*----------------------------------------------------------------------*
***INCLUDE LZADOV_GRAINS_002O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module FILL_KEY_DESCRIPTIONS OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE fill_key_descriptions OUTPUT.

  IF zadov_grains_002-company_code_descr IS INITIAL.

    SELECT SINGLE butxt FROM t001 INTO zadov_grains_002-company_code_descr WHERE bukrs = zadov_grains_002-company_code.

  ENDIF.

ENDMODULE.
