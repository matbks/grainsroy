@AbapCatalog.sqlViewName: 'ZADOAGRAINSAQT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Somatório das quantidades do contrato'
define view ZADOA_GRAINS_SUM_ITEMS_QUANT
  as select from ZADOI_GRAINS_CONTRACT_ITEMS as ContractItem
{
  key ContractItem.TradingContractNumber,
  
      @Semantics.quantity.unitOfMeasure: 'BaseUnitOfMeasure'
      cast(sum(ContractItem.OriginalQuantity) as /accgo/e_contract_qty   ) as Quantity,
      
      
      @Semantics.unitOfMeasure: true
      cast(max(ContractItem.BaseUnitOfMeasure) as meins )                  as BaseUnitOfMeasure
}

group by
  ContractItem.TradingContractNumber
