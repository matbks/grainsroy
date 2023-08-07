@AbapCatalog.sqlViewName: 'ZADOAGRAINSDQUO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Cotação Dólar'
define view ZADOA_GRAINS_DOLAR_QUOTATION
  as select from tcurr as Quotations
{
  key kurst        as Kurst,
  key fcurr        as Fcurr,
  key tcurr        as Tcurr,
      min( gdatu ) as Gdatu
}
where
      kurst = 'M'
  and fcurr = 'USD'
  and tcurr = 'BRL'

group by
  kurst,
  fcurr,
  tcurr
