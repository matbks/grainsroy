*----------------------------------------------------------------------*
***INCLUDE LZADOV_GRAINS_010O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module FILL_KEY_DESCRIPTIONS OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE fill_key_descriptions OUTPUT.

  IF zadov_grains_010-company_code_descr IS INITIAL.

    SELECT SINGLE butxt FROM t001 INTO zadov_grains_010-company_code_descr WHERE bukrs = zadov_grains_010-company_code.

  ENDIF.

  IF zadov_grains_010-name_text IS INITIAL.

    SELECT SINGLE name_textc  FROM user_addr INTO zadov_grains_010-name_text WHERE bname = zadov_grains_010-username.

  ENDIF.

ENDMODULE.
