@AbapCatalog.sqlViewName: 'ZADOCGRAINSDQUO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Cotação Dólar'
define view ZADOC_GRAINS_DOLAR_QUOTATION
  as select from tcurr                        as Quodation
    inner join   ZADOA_GRAINS_DOLAR_QUOTATION as DayQuotation on  DayQuotation.Fcurr = Quodation.fcurr
                                                              and DayQuotation.Gdatu = Quodation.gdatu
                                                              and DayQuotation.Kurst = Quodation.kurst
                                                              and DayQuotation.Tcurr = Quodation.tcurr
{
  key Quodation.kurst as Kurst,
  key Quodation.fcurr as Fcurr,
  key Quodation.tcurr as Tcurr,
  key Quodation.gdatu as Gdatu,
      Quodation.ukurs as Ukurs  
}
