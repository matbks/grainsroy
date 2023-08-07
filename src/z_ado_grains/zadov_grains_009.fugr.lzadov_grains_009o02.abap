*----------------------------------------------------------------------*
***INCLUDE LZADOV_GRAINS_009O02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module FILL_KEY_DESCRIPTIONS OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE fill_key_descriptions OUTPUT.

  IF zadov_grains_009-company_code_descr IS INITIAL.

    SELECT SINGLE butxt FROM t001 INTO zadov_grains_009-company_code_descr WHERE bukrs = zadov_grains_009-company_code.

  ENDIF.

  IF zadov_grains_009-name_text IS INITIAL.

    SELECT SINGLE name_textc  FROM user_addr INTO zadov_grains_009-name_text WHERE bname = zadov_grains_009-username.

  ENDIF.

ENDMODULE.
