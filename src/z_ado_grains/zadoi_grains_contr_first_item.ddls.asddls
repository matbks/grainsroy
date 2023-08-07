@AbapCatalog.sqlViewName: 'ZADOI_GRAINSCFI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Primeiro item do contrato (Cardinalidade)'
define view ZADOI_GRAINS_CONTR_FIRST_ITEM
  as select from I_ACMTradingContractItemData as ContractItem
{
  key ContractItem.TradingContractNumber,
      cast(min(ContractItem.TradingContractItem) as tposn)             as TradingContractItem,
      cast( min(ContractItem.TrdgContrCommoditySubitem) as tposn_sub ) as TrdgContrCommoditySubitem
      }

group by
  ContractItem.TradingContractNumber
