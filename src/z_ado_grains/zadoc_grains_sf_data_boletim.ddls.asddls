@AbapCatalog.sqlViewName: 'ZADOCSFDATABOL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Para Dados do Smartforms Boletim de Fixacao'
define view ZADOC_GRAINS_SF_DATA_BOLETIM
  as select from ZADOI_GRAINS_FIXING_ITEM       as FixItem
    inner join   ZADOC_GRAINS_CONSUMED_APPL     as ConsApp     on  FixItem.ContractNum       = ConsApp.ContractNum
                                                               and FixItem.IdentificationFix = ConsApp.FixationId

    inner join   ZADOC_GRAINS_EDC_FROM_CONTRACT as EdcContract on  FixItem.ContractNum = EdcContract.ContractNum
                                                               and ConsApp.EdcNum      = EdcContract.EdcNum

    inner join   ZADOC_GRAINS_EDC_INVOICE       as EdcInvoice  on EdcInvoice.EdcNum = EdcContract.EdcNum

    inner join   ZADOI_GRAINS_NFS               as Nfes        on  Nfes.nfenum = EdcInvoice.NfeNum
                                                               and Nfes.werks  = FixItem.Plant

{
  key    FixItem.Plant             as Plant,
  key    FixItem.ContractNum       as ContractNum,
  key    FixItem.IdentificationFix as IdFix,
  key    ConsApp.EdcNum            as EdcNum,
  key    ConsApp.ApplicationDoc    as ApplicationNum,
         EdcContract.CreatedOn     as EdcDate,        
         Nfes.nfenum               as Nfs,
         Nfes.series               as Serie,
         Nfes.credat               as NfeDate,
         @Semantics.quantity.unitOfMeasure: 'zadoi_grains_fixing_item.Unity'
         ConsApp.Quantity          as FixedWeight

}
