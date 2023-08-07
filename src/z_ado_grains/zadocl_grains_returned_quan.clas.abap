CLASS zadocl_grains_returned_quan DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .

    CLASS-METHODS:
      get_data FOR TABLE FUNCTION zadotf_grains_returned_quan.

  PRIVATE SECTION.
ENDCLASS.



CLASS zadocl_grains_returned_quan IMPLEMENTATION.

  METHOD get_data BY DATABASE FUNCTION FOR HDB
                   LANGUAGE SQLSCRIPT
                   OPTIONS READ-ONLY
                   USING zi_acm_qtd_dev.

    RETURN SELECT
                ReturnedQuan.mandt                                    as Client,
                ReturnedQuan.edc                                      as Edc,
                abap_df34raw_to_decimal(ReturnedQuan.qtd_dev)         as Quantity
             from  zi_acm_qtd_dev  as ReturnedQuan

           where mandt = :p_clnt;

  ENDMETHOD.


ENDCLASS.
