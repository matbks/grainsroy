@AbapCatalog.sqlViewName: 'ZADOIGRAINSCTI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Items do Contrato'
define view ZADOI_GRAINS_CONTRACT_ITEMS
  as select from    I_ACMTradingContractItemData                                as ContractItem

    inner join      wbhi                                                        as ContractItemBase on  ContractItem.TradingContractNumber     = ContractItemBase.tkonn
                                                                                                    and ContractItem.TradingContractItem       = ContractItemBase.tposn
                                                                                                    and ContractItem.TrdgContrCommoditySubitem = ContractItemBase.tposn_sub


    left outer join ZADOTF_GRAINS_CONTRACT_QUANT( p_clnt: $session.client )     as ContractQuantity on  ContractQuantity.Contract     = ContractItem.TradingContractNumber
                                                                                                    and ContractQuantity.ContractItem = ContractItem.TradingContractItem

    left outer join ZADOI_GRAINS_CONTR_LAST_PRICE                               as LastPriceLink    on  ContractItem.TradingContractNumber = LastPriceLink.TradingContractNumber
                                                                                                    and ContractItem.TradingContractItem   = LastPriceLink.TradingContractItem

  //    left outer join ZADOI_GRAINS_CONTRACT_PRICE                             as LastPrice        on  LastPriceLink.TradingContractNumber = LastPrice.TradingContractNumber
  //                                                                                                and LastPriceLink.Counter               = LastPrice.Counter
  //
    left outer join ZADOTF_GRAINS_GET_FIX_CONT_PRC( p_client: $session.client ) as LastPrice        on  LastPrice.contract = LastPriceLink.TradingContractNumber
                                                                                                    and LastPrice.pr_cont  = LastPriceLink.Counter

    left outer join ZADOA_GRAINS_CTR_INVOICES_QUAN                              as InvoicesQuantity on InvoicesQuantity.ContractNum = ContractItem.TradingContractNumber


  association [0..1] to ZADOI_GRAINS_CONTRACT_HEADER as _ContractHeader on $projection.TradingContractNumber = _ContractHeader.TradingContractNumber

  association [0..1] to I_Plant                      as _Plant          on $projection.ContractPlant = _Plant.Plant



{
  key ContractItem.TradingContractNumber,
  key ContractItem.TradingContractItem,
  key ContractItem.TrdgContrCommoditySubitem,
      ContractItem.ContractMaterial,
      ContractItem.ContractPlant,
      ContractItem.ContractStorageLocation,
      ContractItem.TrdgContrPurgQuantity,
      ContractItem.TrdgContrSalesQuantity,
      ContractItem.BaseUnit,
      ContractItem.PrcgCndnTradingContrCurrency,
      ContractItem.TradingContractSalesCurrency,
      ContractItem.Commodity,
      ContractItem.ProfitCenter,
      ContractItem.ItemPrice,
      ContractItem.PriceCurrency,


      @Semantics.quantity.unitOfMeasure: 'BaseUnitOfMeasure'
      cast(ContractQuantity.OriginalQuantity as zadode_grains_quantity )   as OriginalQuantity,

      @Semantics.quantity.unitOfMeasure: 'BaseUnitOfMeasure'
      cast(ContractQuantity.ConsumedQuantity as zadode_grains_quantity )   as ConsumedQuantity,

      @Semantics.quantity.unitOfMeasure: 'BaseUnitOfMeasure'
      cast(ContractQuantity.BalanceQuantity as zadode_grains_quantity )    as BalanceQuantity,

      @Semantics.quantity.unitOfMeasure: 'BaseUnitOfMeasure'
      cast( case when  InvoicesQuantity.InvoiceQuantity is null then 0
      else InvoicesQuantity.InvoiceQuantity end as zadode_grains_quantity) as InvoiceQuantity,

      @Semantics.quantity.unitOfMeasure: 'BaseUnitOfMeasure'
      cast( case when  InvoicesQuantity.InvoiceQuantity is null then
      0 - ContractQuantity.ConsumedQuantity
      else InvoicesQuantity.InvoiceQuantity -
      ContractQuantity.ConsumedQuantity end as zadode_grains_quantity )    as FixationAvailableQuantity,

      @Semantics.unitOfMeasure: true
      ContractQuantity.BaseUnitOfMeasure,

      //      @Semantics.amount.currencyCode: 'Currency'
      cast( LastPrice.price as zadode_grains_value_kg )                    as Value,

      //      @Semantics.amount.currencyCode: 'Currency'
      cast( LastPrice.price * 60 as zadode_grains_value_kg )               as Amount60KG,

      @Semantics.currencyCode: true
      cast('BRL' as abap.cuky( 5 ) )                                       as Currency,

      // Associations
      _ContractHeader,
      _Plant


}
