@AbapCatalog.sqlViewName: 'ZADOROYALDISCH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Soma das baixas de bloqueio de crédito'
define view ZADOC_ROYALTIES_DISCHARGES_TOT

  as select from ZADOC_ROYALTIES_DISCHARGES_SUM

{
  key max( EdcNumber  ) as EdcNumber,
  key max( Romaneio )   as Romaneio,
  key max( Plant )      as Plant,
      sum( Discharge )  as Discharges
}

group by
  EdcNumber,
  Romaneio,
  Plant
