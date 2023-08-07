@AbapCatalog.sqlViewName: 'ZADOROYALBAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Soma dos saldos'
define view ZADOC_ROYALTIES_BALANCE_SUM

  as select from ZADOC_ROYALTIES_MONITOR        as creditBlocks
    inner join   ZADOC_ROYALTIES_DISCHARGES_SUM as discharges on  discharges.EdcNumber = creditBlocks.EdcNum
                                                              and discharges.Romaneio  = creditBlocks.Romaneio
  //                                                              and discharges.Plant     = creditBlocks.Plant
{
  key  creditBlocks.EdcNum,
  key  creditBlocks.ContractNum,
  key  creditBlocks.Partner,
  key  creditBlocks.Romaneio,
  key  creditBlocks.Plant,
       case when discharges.Discharge is initial then creditBlocks.ApplicationQuantity
            else creditBlocks.ApplicationQuantity - discharges.Discharge end as Quantity
}
