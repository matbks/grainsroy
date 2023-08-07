@AbapCatalog.sqlViewName: 'ZADOCROYCONTRACT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parceiro Ajuda de Pesquisa'
define view ZADOC_ROYALTIES_CONTRACTS

  as select distinct from ZADOC_ROYALTIES_MONITOR as royalties
    inner join            wbhk                    as contracts on contracts.tkonn = royalties.ContractNum

{
  key tkonn    as Contract,
      tkonn_ex as ContractDescription,
      royalties.Partner as Partner   
}
