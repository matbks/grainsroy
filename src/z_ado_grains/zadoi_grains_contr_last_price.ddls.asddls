@AbapCatalog.sqlViewName: 'ZADOIGRAINSCLP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Último preço do contrato'
define view ZADOI_GRAINS_CONTR_LAST_PRICE
  as select from wb2_d_prasp as ContractPrices
{
  key ContractPrices.tkonn         as TradingContractNumber,
  key ContractPrices.tposn         as TradingContractItem,
  key ContractPrices.tposn_com     as TrdgContrCommoditySubitem,  

      max(ContractPrices.pr_count) as Counter 
}


where
  ContractPrices.pr_aspect = 'FBPR'

group by
  ContractPrices.tkonn,
  ContractPrices.tposn,
  ContractPrices.tposn_com
