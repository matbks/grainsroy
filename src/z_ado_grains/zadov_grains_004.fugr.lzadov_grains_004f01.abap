*----------------------------------------------------------------------*
***INCLUDE LZADOV_GRAINS_004F01.
*----------------------------------------------------------------------*

FORM add_new_entry .

  SELECT COUNT(*) FROM zadot_grains_004 INTO @DATA(records).

  IF sy-subrc <> 0 AND zadov_grains_004-id <> 0.

    ADD 1 TO records.

    zadov_grains_004-id = records.

    RETURN.

  ELSEIF total[] IS INITIAL.

    zadov_grains_004-id = records + 1.

    RETURN.

  ENDIF.

  records = lines( total ).

  zadov_grains_004-id = records + 1.


ENDFORM.
