@AbapCatalog.sqlViewName: 'ZADOAGRAINSSAPP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Agregação saldos de aplicações de vendas'
define view ZADOA_GRAINS_SALES_APPL
  as select from ZADOC_GRAINS_BALANCES_TO_SALES as ContractApplications

{
  key    ContractApplications.ContractNum,
  key    ContractApplications.Plant,
         ContractApplications.PlantName,
         ContractApplications.AppUnit,  
         ContractApplications.Material,
         @Semantics.quantity: {unitOfMeasure: 'AppUnit'}
         sum(ContractApplications.AvailableQuantity) as TotalQuantity
}
where
  DocNum is not initial

group by
  ContractApplications.ContractNum,
  ContractApplications.Plant,
  ContractApplications.PlantName,
  ContractApplications.Material,
  ContractApplications.AppUnit
