*----------------------------------------------------------------------*
***INCLUDE LZADOV_GRAINS_004O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module FILL_KEY_DESCRIPTIONS OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE fill_key_descriptions OUTPUT.

  IF zadov_grains_004-app_description IS INITIAL.

    SELECT SINGLE app_description FROM zadot_grains_002 INTO zadov_grains_004-app_description WHERE app_code = zadov_grains_004-app_code.

  ENDIF.

  IF zadov_grains_004-company_code_descr IS INITIAL.

    SELECT SINGLE butxt FROM t001 INTO zadov_grains_004-company_code_descr WHERE bukrs = zadov_grains_004-company_code.

  ENDIF.


ENDMODULE.
