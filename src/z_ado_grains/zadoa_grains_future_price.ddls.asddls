@AbapCatalog.sqlViewName: 'ZADOAGRAINSFP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Agregação preço futuro'
define view ZADOA_GRAINS_FUTURE_PRICE
  as select from tbat_pricequot_f as FuturePrice

{
  key    FuturePrice.dcsid          as CommodityId,
  key    FuturePrice.mic            as Place,
  key    FuturePrice.pricedate      as PriceDate,
  key    FuturePrice.keydate        as KeyDate,
         max(FuturePrice.pricetime) as PriceTime
}

group by
  FuturePrice.dcsid,
  FuturePrice.mic,
  FuturePrice.pricedate,
  FuturePrice.keydate
