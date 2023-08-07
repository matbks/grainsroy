@AbapCatalog.sqlViewName: 'ZADOAGRAINSUQ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Quantitidade desbloqueada por bloqueio'
define view ZADOA_GRAINS_UNLOCK_QUANTITY
  as select from zadot_grains_017 as UnlockQuantity
{
  key UnlockQuantity.block_number  as BlockNumber,
      sum(UnlockQuantity.quantity) as UnlockQuantity
}

group by
  block_number
 
