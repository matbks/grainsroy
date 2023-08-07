CLASS zadocl_grains_balance_sales DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .

    CLASS-METHODS:
      get_data FOR TABLE FUNCTION zadotf_grains_balances_sales.

ENDCLASS.

CLASS zadocl_grains_balance_sales IMPLEMENTATION.

  METHOD get_data BY DATABASE FUNCTION FOR HDB
                   LANGUAGE SQLSCRIPT
                   OPTIONS READ-ONLY
                   USING /accgo/t_cas_cai.

    RETURN SELECT
                Balances.mandt                                    as Client,
                Balances.appldoc                                  as ApplicationDoc,
                abap_df34raw_to_decimal(Balances.applied_qty_raw) as Quantity
             from  "/ACCGO/T_CAS_CAI"  as Balances

           where mandt = :p_clnt
           and SHD_TYPE = 'ZA';

  ENDMETHOD.

ENDCLASS.
