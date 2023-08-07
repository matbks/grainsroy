@AbapCatalog.sqlViewName: 'ZADOI_GRAINSCPK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Preço por KG de Contrato Fixo'
define view ZADOI_GRAINS_CONTRACT_PRICE
  as select from ZADOTF_GRAINS_GET_FIX_CONT_PRC( p_client: $session.client ) as ContractPrices
{
  key ContractPrices.contract                                      as TradingContractNumber,
      ContractPrices.pr_cont                                       as Counter,

      @Semantics.amount.currencyCode: 'Currency'
      cast( ContractPrices.price as zadode_grains_value_kg )       as Value,
 
      @Semantics.currencyCode: true
      cast('BRL' as abap.cuky( 5 ) )                               as Currency,

      cast( ContractPrices.price * 60 as zadode_grains_value_60kg) as Amount60KG

}
