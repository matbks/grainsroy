@AbapCatalog.sqlViewName: 'ZADOAGRAINSCTQ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Quantidade total de aplicação do contrato'
define view ZADOA_GRAINS_CONT_APP_QUAN
  as select from ZADOC_GRAINS_BALANCES_PROPERTY as PropertyQuantity
{
  PropertyQuantity.ContractNum            as ContractNum,
  @Semantics.quantity.unitOfMeasure: 'Unit'
  sum(PropertyQuantity.AvailableQuantity) as AvailableQuantity,
  PropertyQuantity.Unit                   as Unit
}
group by
  ContractNum,
  Unit
