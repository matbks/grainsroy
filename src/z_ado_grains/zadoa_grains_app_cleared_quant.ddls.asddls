@AbapCatalog.sqlViewName: 'ZADOAGRAINSACQ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Quantidade Compensada da Aplicação'
define view ZADOA_GRAINS_APP_CLEARED_QUANT
  as select from ZADOI_GRAINS_APP_CLEARED_QUANT

{
  key ContractNum,
  key ApplicationDoc,
  key ApplicationDocItem,
      cast(sum(ClearedQuantity) as zadode_grains_cleared_quantity) as ClearedQuantity,
      Uom
}

group by
  ContractNum,
  ApplicationDoc,
  ApplicationDocItem,
  Uom
