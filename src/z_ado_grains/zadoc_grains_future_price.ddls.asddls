@AbapCatalog.sqlViewName: 'ZADOCGRAINSFPC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Preço futuro'
define view ZADOC_GRAINS_FUTURE_PRICE
  as select from    tbat_pricequot_f          as FuturePrice

    inner join      ZADOA_GRAINS_FUTURE_PRICE as ActualFuturePrice on  ActualFuturePrice.CommodityId = FuturePrice.dcsid
                                                                   and ActualFuturePrice.Place       = FuturePrice.mic
                                                                   and ActualFuturePrice.KeyDate     = FuturePrice.keydate
                                                                   and ActualFuturePrice.PriceDate   = FuturePrice.pricedate
                                                                   and ActualFuturePrice.PriceTime   = FuturePrice.pricetime


    inner join      zadot_grains_014          as Commodity         on  Commodity.commodity_id = ActualFuturePrice.CommodityId
                                                                   and Commodity.active       = 'X'
                                                                   and Commodity.app_code     = 'ACMCONTROL'

    inner join      zadot_grains_015          as Place             on  Place.mic          = ActualFuturePrice.Place
                                                                   and Place.company_code = Commodity.company_code
                                                                   and Place.app_code     = Commodity.app_code

    left outer join tbac_dcs_kd               as PriceData         on  PriceData.dcsid   = FuturePrice.dcsid
                                                                   and PriceData.keydate = FuturePrice.keydate

{
  key FuturePrice.dcsid       as CommodityId,
  key FuturePrice.mic         as Place,
  key FuturePrice.keydate     as DueDate,
  key FuturePrice.pricedate   as PriceDate,
      Commodity.commodity     as Commodity,
      Place.plant             as Plant,
      Commodity.company_code  as CompanyCode,
      FuturePrice.price       as Price,
      FuturePrice.currency    as Currency,
      PriceData.contract_code as DueCode
}

where
  FuturePrice.deletion_ind is initial
