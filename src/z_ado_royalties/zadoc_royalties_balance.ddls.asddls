@AbapCatalog.sqlViewName: 'ZADOROYBAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Saldo de Royalties Bloqueados'
define view ZADOC_ROYALTIES_BALANCE

  as select from ZADOC_ROYALTIES_MONITOR
{
  key max( EdcNum )      as EdcNum,
  key max( Material )    as Material,
  key max( ContractNum ) as Contract,
  key max( Partner )     as Partner,
      sum( Discharges )  as Balance
}
group by
  Partner
