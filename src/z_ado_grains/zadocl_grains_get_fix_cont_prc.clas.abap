CLASS zadocl_grains_get_fix_cont_prc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .

    CLASS-METHODS:
      get_data FOR TABLE FUNCTION zadotf_grains_get_fix_cont_prc.

  PRIVATE SECTION.
ENDCLASS.

CLASS zadocl_grains_get_fix_cont_prc IMPLEMENTATION.

  METHOD get_data BY DATABASE FUNCTION FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                      USING /accgo/t_pr_asp.


    RETURN SELECT
    Price.client                                                as client,
    Price.tkonn                                                 as contract,
    Price.pr_count                                              as pr_cont,
    Price.total_price_doc_curr                                  as Price
    from "/ACCGO/T_PR_ASP" as Price

    where client = :p_client;

  endmethod.
ENDCLASS.
