*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZADOV_GRAINS_MAT................................*
FORM GET_DATA_ZADOV_GRAINS_MAT.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZADOT_GRAINS_MAT WHERE
(VIM_WHERETAB) .
    CLEAR ZADOV_GRAINS_MAT .
ZADOV_GRAINS_MAT-MANDT =
ZADOT_GRAINS_MAT-MANDT .
ZADOV_GRAINS_MAT-COMPANY_CODE =
ZADOT_GRAINS_MAT-COMPANY_CODE .
ZADOV_GRAINS_MAT-APP_CODE =
ZADOT_GRAINS_MAT-APP_CODE .
ZADOV_GRAINS_MAT-TRANSGENIA =
ZADOT_GRAINS_MAT-TRANSGENIA .
ZADOV_GRAINS_MAT-MATERIAL =
ZADOT_GRAINS_MAT-MATERIAL .
    SELECT SINGLE * FROM MARA WHERE
MATNR = ZADOT_GRAINS_MAT-MATERIAL .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM MAKT WHERE
MATNR = MARA-MATNR AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZADOV_GRAINS_MAT-MAKTX =
MAKT-MAKTX .
      ENDIF.
    ENDIF.
<VIM_TOTAL_STRUC> = ZADOV_GRAINS_MAT.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZADOV_GRAINS_MAT .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZADOV_GRAINS_MAT.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZADOV_GRAINS_MAT-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZADOT_GRAINS_MAT WHERE
  COMPANY_CODE = ZADOV_GRAINS_MAT-COMPANY_CODE AND
  APP_CODE = ZADOV_GRAINS_MAT-APP_CODE AND
  TRANSGENIA = ZADOV_GRAINS_MAT-TRANSGENIA AND
  MATERIAL = ZADOV_GRAINS_MAT-MATERIAL .
    IF SY-SUBRC = 0.
    DELETE ZADOT_GRAINS_MAT .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZADOT_GRAINS_MAT WHERE
  COMPANY_CODE = ZADOV_GRAINS_MAT-COMPANY_CODE AND
  APP_CODE = ZADOV_GRAINS_MAT-APP_CODE AND
  TRANSGENIA = ZADOV_GRAINS_MAT-TRANSGENIA AND
  MATERIAL = ZADOV_GRAINS_MAT-MATERIAL .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZADOT_GRAINS_MAT.
    ENDIF.
ZADOT_GRAINS_MAT-MANDT =
ZADOV_GRAINS_MAT-MANDT .
ZADOT_GRAINS_MAT-COMPANY_CODE =
ZADOV_GRAINS_MAT-COMPANY_CODE .
ZADOT_GRAINS_MAT-APP_CODE =
ZADOV_GRAINS_MAT-APP_CODE .
ZADOT_GRAINS_MAT-TRANSGENIA =
ZADOV_GRAINS_MAT-TRANSGENIA .
ZADOT_GRAINS_MAT-MATERIAL =
ZADOV_GRAINS_MAT-MATERIAL .
    IF SY-SUBRC = 0.
    UPDATE ZADOT_GRAINS_MAT ##WARN_OK.
    ELSE.
    INSERT ZADOT_GRAINS_MAT .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZADOV_GRAINS_MAT-UPD_FLAG,
STATUS_ZADOV_GRAINS_MAT-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZADOV_GRAINS_MAT.
  SELECT SINGLE * FROM ZADOT_GRAINS_MAT WHERE
COMPANY_CODE = ZADOV_GRAINS_MAT-COMPANY_CODE AND
APP_CODE = ZADOV_GRAINS_MAT-APP_CODE AND
TRANSGENIA = ZADOV_GRAINS_MAT-TRANSGENIA AND
MATERIAL = ZADOV_GRAINS_MAT-MATERIAL .
ZADOV_GRAINS_MAT-MANDT =
ZADOT_GRAINS_MAT-MANDT .
ZADOV_GRAINS_MAT-COMPANY_CODE =
ZADOT_GRAINS_MAT-COMPANY_CODE .
ZADOV_GRAINS_MAT-APP_CODE =
ZADOT_GRAINS_MAT-APP_CODE .
ZADOV_GRAINS_MAT-TRANSGENIA =
ZADOT_GRAINS_MAT-TRANSGENIA .
ZADOV_GRAINS_MAT-MATERIAL =
ZADOT_GRAINS_MAT-MATERIAL .
    SELECT SINGLE * FROM MARA WHERE
MATNR = ZADOT_GRAINS_MAT-MATERIAL .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM MAKT WHERE
MATNR = MARA-MATNR AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZADOV_GRAINS_MAT-MAKTX =
MAKT-MAKTX .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZADOV_GRAINS_MAT-MAKTX .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZADOV_GRAINS_MAT-MAKTX .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZADOV_GRAINS_MAT USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZADOV_GRAINS_MAT-COMPANY_CODE TO
ZADOT_GRAINS_MAT-COMPANY_CODE .
MOVE ZADOV_GRAINS_MAT-APP_CODE TO
ZADOT_GRAINS_MAT-APP_CODE .
MOVE ZADOV_GRAINS_MAT-TRANSGENIA TO
ZADOT_GRAINS_MAT-TRANSGENIA .
MOVE ZADOV_GRAINS_MAT-MATERIAL TO
ZADOT_GRAINS_MAT-MATERIAL .
MOVE ZADOV_GRAINS_MAT-MANDT TO
ZADOT_GRAINS_MAT-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZADOT_GRAINS_MAT'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZADOT_GRAINS_MAT TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZADOT_GRAINS_MAT'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
FORM COMPL_ZADOV_GRAINS_MAT USING WORKAREA.
*      provides (read-only) fields from secondary tables related
*      to primary tables by foreignkey relationships
ZADOT_GRAINS_MAT-MANDT =
ZADOV_GRAINS_MAT-MANDT .
ZADOT_GRAINS_MAT-COMPANY_CODE =
ZADOV_GRAINS_MAT-COMPANY_CODE .
ZADOT_GRAINS_MAT-APP_CODE =
ZADOV_GRAINS_MAT-APP_CODE .
ZADOT_GRAINS_MAT-TRANSGENIA =
ZADOV_GRAINS_MAT-TRANSGENIA .
ZADOT_GRAINS_MAT-MATERIAL =
ZADOV_GRAINS_MAT-MATERIAL .
    SELECT SINGLE * FROM MARA WHERE
MATNR = ZADOT_GRAINS_MAT-MATERIAL .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM MAKT WHERE
MATNR = MARA-MATNR AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZADOV_GRAINS_MAT-MAKTX =
MAKT-MAKTX .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZADOV_GRAINS_MAT-MAKTX .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZADOV_GRAINS_MAT-MAKTX .
    ENDIF.
ENDFORM.
