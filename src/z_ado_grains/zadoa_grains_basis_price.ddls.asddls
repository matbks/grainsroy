@AbapCatalog.sqlViewName: 'ZADOAGRAINSBPRC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Preço Basis'
define view ZADOA_GRAINS_BASIS_PRICE
  as select from tbact_bas_quot as BasisPrice
{
  key   BasisPrice.dcsid          as CommodityId,
  key   BasisPrice.mic            as Place,
  key   BasisPrice.pricedate      as PriceDate,
  key   BasisPrice.keydate        as KeyDate,
        max(BasisPrice.pricetime) as PriceTime
}

group by
  BasisPrice.dcsid,
  BasisPrice.mic,
  BasisPrice.keydate,
  BasisPrice.pricedate
