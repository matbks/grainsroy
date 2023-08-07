@EndUserText.label: 'Grains - Table Func - Quant. do Contrato'
@ClientHandling.type: #CLIENT_DEPENDENT
define table function ZADOTF_GRAINS_CONTRACT_QUANT
  with parameters
    @Environment.systemField: #CLIENT
    p_clnt : abap.clnt

returns

{
  Client                : abap.clnt;
  Contract              : tkonn;
  ContractItem          : tposn;
  ContractCommodityItem : tposn_sub;
  BaseUnitOfMeasure     : meins;
  OriginalQuantity      : /accgo/e_contract_qty;
  ConsumedQuantity      : /accgo/e_c_qty;
  BalanceQuantity       : fsh_pg_uqty;
}
implemented by method
  zadocl_grains_contract_quant=>get_quantity;
