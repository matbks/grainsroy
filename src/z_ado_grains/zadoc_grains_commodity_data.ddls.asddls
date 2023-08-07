@AbapCatalog.sqlViewName: 'ZADOCGRAINSCMM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Dados da commodity'
define view ZADOC_GRAINS_COMMODITY_DATA
  as select from zadot_grains_014 as CommodityData
{
  key company_code         as CompanyCode,
  key app_code             as AppCode,
  key commodity            as Commodity,
      commodity_id         as CommodityId,
      conversion_factor    as ConversionFactor,
      royalties_percentage as RoyaltiesBlockPerc,
      active               as Active
}
