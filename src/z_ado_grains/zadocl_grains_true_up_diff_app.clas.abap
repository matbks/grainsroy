CLASS zadocl_grains_true_up_diff_app DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .

    CLASS-METHODS:
      get_data FOR TABLE FUNCTION zadotf_grains_true_up_diff_app.


ENDCLASS.



CLASS zadocl_grains_true_up_diff_app IMPLEMENTATION.

  METHOD get_data BY DATABASE FUNCTION FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                      USING /accgo/t_brdiffa.


    RETURN SELECT
              mandt                                 AS Client,
              app_trp_guid                          AS ApplicationTrueUpGuid,
              appldoc                               AS ApplicationDoc,
              item                                  AS ApplicationDocItem,
              side                                  AS Side,
              sub_item                              AS SubItem,
              appl_status                           AS ApplicationDiffStatus,
              abap_df34raw_to_decimal(nf_qty_raw)   AS NfQuantity,
              nf_uom                                AS NfUom,
              abap_df34raw_to_decimal(appl_qty_raw) AS ApplicationQuantity,
              appl_uom                              AS ApplicationUom,

              abap_df34raw_to_decimal(appl_qty_raw) -
              abap_df34raw_to_decimal(nf_qty_raw)   AS QuantityTrueUpDiff


             FROM "/ACCGO/T_BRDIFFA" as TrueUpDif

           WHERE mandt = :p_clnt;
  ENDMETHOD.


ENDCLASS.
