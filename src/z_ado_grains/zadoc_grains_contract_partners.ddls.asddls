@AbapCatalog.sqlViewName: 'ZADOCGRAINSPA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Parceiros'
define view ZADOC_GRAINS_CONTRACT_PARTNERS
  as select distinct from ZADOC_GRAINS_CONTRACT_DETAILS as ContractDetails
{
  key ContractDetails.Partner,
      ContractDetails.PartnerName,
      ContractDetails.PartnerCity
    
}
