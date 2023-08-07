@AbapCatalog.sqlViewName: 'ZADOCGRAINSBPRC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Preço Basis'
define view ZADOC_GRAINS_BASIS_PRICE
  as select from tbact_bas_quot           as BasisPrice

    inner join   ZADOA_GRAINS_BASIS_PRICE as ActualBasisPrice on  ActualBasisPrice.CommodityId = BasisPrice.dcsid
                                                              and ActualBasisPrice.Place       = BasisPrice.mic
                                                              and ActualBasisPrice.KeyDate     = BasisPrice.keydate
                                                              and ActualBasisPrice.PriceDate   = BasisPrice.pricedate
                                                              and ActualBasisPrice.PriceTime   = BasisPrice.pricetime

    inner join   zadot_grains_014         as Commodity        on  Commodity.commodity_id = ActualBasisPrice.CommodityId
                                                              and Commodity.active       = 'X'
                                                              and Commodity.app_code     = 'ACMCONTROL'

    inner join   zadot_grains_015         as Place            on  Place.mic          = ActualBasisPrice.Place
                                                              and Place.company_code = Commodity.company_code
                                                              and Place.app_code     = Commodity.app_code

{
  key BasisPrice.dcsid       as CommodityId,
  key BasisPrice.mic         as Place,
  key BasisPrice.keydate     as DueDate,
  key BasisPrice.pricedate   as PriceDate,
      Commodity.commodity    as Commodity,
      Commodity.company_code as CompanyCode,
      Place.plant            as Plant,
      BasisPrice.price       as Price,
      BasisPrice.currency    as Currency
}

where
  BasisPrice.deletion_ind is initial
