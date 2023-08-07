@AbapCatalog.sqlViewName: 'ZADOIGRAINSSLP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Settlement Last Pricing'
define view ZADOI_GRAINS_SETTL_LAST_PRICE
  as select from /accgo/t_stlprc as SettlementPricing

{
  key SettlementPricing.stl_item_guid as SettlementItemGuid,
      max(SettlementPricing.pr_count) as PriceCount
}

where
  SettlementPricing.pr_aspect = 'FBPR'

group by
  SettlementPricing.stl_item_guid
