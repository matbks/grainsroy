CLASS zadocl_grains_contract_quant DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .

    CLASS-METHODS:
      get_quantity FOR TABLE FUNCTION zadotf_grains_contract_quant.


ENDCLASS.



CLASS zadocl_grains_contract_quant IMPLEMENTATION.

  METHOD get_quantity BY DATABASE FUNCTION FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                      USING wb2_d_shd_item.


    RETURN SELECT
                CtrQuantities.client                              as Client,
                CtrQuantities.document                            as Contract,
                substring(CtrQuantities.item, 5 ,6)               AS ContractItem,
                CtrQuantities.sub_item                            as ContractCommodityItem,
                CtrQuantities.assgd_uom                           as BaseUnitOfMeasure,
                abap_df34raw_to_decimal(CtrQuantities.item_quan)  AS OriginalQuantity,
                abap_df34raw_to_decimal(CtrQuantities.assgd_quan) AS ConsumedQuantity,

                abap_df34raw_to_decimal(CtrQuantities.item_quan) -
                abap_df34raw_to_decimal(CtrQuantities.assgd_quan) AS BalanceQuantity
             from wb2_d_shd_item as CtrQuantities




           where client = :p_clnt
             and type   = 'Q';
  ENDMETHOD.


ENDCLASS.
