@AbapCatalog.sqlViewName: 'ZADOROYALDISC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Total de baixas de bloqueio de crédito'
define view ZADOC_ROYALTIES_DISCHARGES_SUM

  as select from ZADOC_ROYALTIES_LOG as discharges
{
   key Plant,
   key Romaneio,
   key EdcNumber,
   key CreatedOn,
   Discharge,
   FiscalYear,
   Balance,
   DischargeStatus
}
