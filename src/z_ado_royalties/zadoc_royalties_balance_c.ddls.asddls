@AbapCatalog.sqlViewName: 'ZADOROYBALC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Saldo de Royalties Bloqueados Por Contrato'
define view ZADOC_ROYALTIES_BALANCE_C 

  as select from ZADOC_ROYALTIES_MONITOR
{
  key max( EdcNum )      as EdcNum,
  key max( Material )    as Material,
  key max( ContractNum ) as Contract,
  key max( Partner )     as Partner,
      max( PartnerDescription ) as PartnerDescription,
      sum( Discharges )  as Balance
}
group by
  ContractNum
