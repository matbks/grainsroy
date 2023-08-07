*----------------------------------------------------------------------*
***INCLUDE LZADOV_GRAINS_006O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module FILL_KEY_DESCRIPTIONS OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE fill_key_descriptions OUTPUT.


  IF zadov_grains_006-app_description IS INITIAL.

    SELECT SINGLE app_description FROM zadot_grains_002 INTO zadov_grains_006-app_description WHERE app_code = zadov_grains_006-app_code.

  ENDIF.

  IF zadov_grains_006-company_code_descr IS INITIAL.

    SELECT SINGLE butxt FROM t001 INTO zadov_grains_006-company_code_descr WHERE bukrs = zadov_grains_006-company_code.

  ENDIF.

  IF zadov_grains_006-ddl_name IS INITIAL.

    SELECT SINGLE ddl_name FROM zadot_grains_004  INTO zadov_grains_006-ddl_name WHERE id = zadov_grains_006-id
                                                                                   AND company_code = zadov_grains_006-company_code
                                                                                   AND app_code     = zadov_grains_006-app_code.

  ENDIF.

  IF zadov_grains_006-ddl_name_descr IS INITIAL.

    SELECT SINGLE ddtext  FROM ddddlsrct  INTO zadov_grains_006-ddl_name_descr WHERE ddlname    = zadov_grains_006-ddl_name
                                                                                 AND ddlanguage = 'P'
                                                                                 AND as4local   = 'A'.

  ENDIF.

ENDMODULE.
