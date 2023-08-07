*----------------------------------------------------------------------*
***INCLUDE LZADOV_GRAINS_TRAF02.
*----------------------------------------------------------------------*

 FORM add_new_entry .

  SELECT COUNT(*) FROM zadot_grains_tra INTO @DATA(records).

  IF sy-subrc <> 0 AND zadov_grains_tra-transgenia <> 0.

    ADD 1 TO records.

   zadov_grains_tra-transgenia = records.

    RETURN.

  ELSEIF total[] IS INITIAL.

    zadov_grains_tra-transgenia = records + 1.

    RETURN.

  ENDIF.

  records = lines( total ).

  zadov_grains_tra-transgenia = records + 1.


ENDFORM.
