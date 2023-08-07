@AbapCatalog.sqlViewName: 'ZADOIGRAINSBFI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Obter a OV a partir do documento de faturamento'
define view ZADOI_GRAINS_BILLING_FRST_ITEM
  as select from vbrp
{
  vbeln      as BillingDocument,
  min(posnr) as BillingItem
}

group by
  vbeln
